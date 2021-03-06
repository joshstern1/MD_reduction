//Purpose: unit that can handle the multicast in the router
//this unit will distribute the packets marked in the multicast entry to their destinations
//
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 14th 2015
//
////
//
//the 256-bit data format will be like this
//Outside the router 
/*
    *|255      |254---152|151-----144|143-----128|127--96|95--64|63--32|31--0|
    *|valid bit|unused   |log  weight|table Index|type   |z     |y     |x    |

    *

    */
//inside the router
/*
    *|255      |254--164 |163---160|159---152|151-----144|143-----128|127--96|95--64|63--32|31--0|
    *|valid bit|unused   |dst      |priority |log  weight|table index|type   |z     |y     |x    |

    *

    */
//routing table entry format
/*
* 32 bits in total
    * |packetType|dst       |table index|priority|
    * |4   bits  |4     bits|16 bits    |8 bits  | 
    * if the packet type is a singlecast packet, the dst field will be the exiting port on current node, the table index is the index on next node. 
      if the packet type is a multicast packet, the dst field is a dont-care field. The table index is the corresponding entry on the multicast table, the down stream packet will inherent the priority field of the parent packet
      if the packet type is a reduction packet, the dst field is a dont-care field. The table index is the corresponding entry on the reduction table, the up stream packet will have the same prioity as the largest one among the largest packet
      The first bit of the packet type field is valid bit
      1000 is single cast packet
      1001 is the mutlicast packet
      1010 is the reduction packet
        
    * /
//multicast table entry format
/*
* at most 5 fan-out for 3D-torus network.
  for each fanout, format is as below:
  |dst   |table index|
  |4 bits|16 bits    | 
* |counter of valid packets|5th packet| 4th packet| 3rd packet| 2nd packet| 1th packet| 103 bits in total
* | 3 bits                 |20 bits   | 20 bits   | 20 bits   | 20 bits   | 20 bits   | 
* */

module multicast_unit#(
    parameter SrcID=4'd0,//if this is on local unit, which means it is the root, it does not need to send the singlecast packet to itself
    parameter PayloadLen=128,
    parameter DataWidth=256,
    parameter WeightPos=144,
    parameter WeightWidth=8,
    parameter IndexPos=128,
    parameter IndexWidth=16,
    parameter PriorityPos=152,
    parameter PriorityWidth=8,
    parameter ExitPos=160,
    parameter ExitWidth=4,
    parameter InterNodeFIFODepth=128,
    parameter IntraNodeFIFODepth=1,
    parameter RoutingTableWidth=32,
    parameter RoutingTablesize=256,
    parameter MulticastTableWidth=103,
    parameter MulticastTablesize=256,
    parameter ReductionTableWidth=162,
    parameter ReductionTablesize=256,
    parameter PcktTypeLen=4
)
(
    input clk,
    input rst,
    input [DataWidth-1:0] input_fifo_out,
    input consume_inject,//read signal to read the data in the multicast queue
    input [RoutingTableWidth-1:0] routing_table_entry,
    output [DataWidth-1:0] injector_in_multicast,
    output start,//indicate the mulitcast unit is taking control of the injecting
    output fifo2_consume_multicast, //read signal to the data in the inject queue, which will be asserted when all of the data in the multicast queue has all been sent
    output start_but_not_ready// there is a not ready cycle when the last of children is sent  
);
    
    wire [MulticastTableWidth-1:0] multicast_table_entry;
   
    wire [DataWidth-1:0] multicast_children[5:0]; //There are five fan-out at most and one to local
    reg [WeightWidth-1:0] weight_split[5:0]; //weight split
//    wire start;//when asserted, means the multicast unit is active.
    reg start_reg;
    reg[MulticastTableWidth-1:0] multicast_table[MulticastTablesize-1:0];
    reg [2:0] children_ptr;//point to the children packet that is about to be sent
    reg [2:0] children_ptr_reg;
    wire [2:0] multicast_counter;
    reg sending_the_last;
    reg sending_the_last_reg;

    wire [3:0] SrcID_wire;
 //   wire start_but_not_ready;

    assign SrcID_wire=SrcID;

    assign base_children_ptr=(SrcID_wire==4'd0);
    
    assign start=(routing_table_entry[RoutingTableWidth-1:RoutingTableWidth-PcktTypeLen]==4'b1001) && (input_fifo_out[DataWidth-1]); //packet type equals to multicast

    assign multicast_counter=multicast_table_entry[102:100];

    always@(posedge clk) begin
        if(rst)
            start_reg<=0;
        else
            start_reg<=start;
    end


    always@(posedge clk) begin
        if(rst)
            children_ptr_reg<=0;
        else
            children_ptr_reg<=children_ptr;
    end

    always@(posedge clk) begin
        if(rst) begin
            sending_the_last<=0;
        end
        else begin
            if(children_ptr==base_children_ptr+1) begin
                if(consume_inject)
                    sending_the_last<=1;
                else
                    sending_the_last<=0;
            end
            else if(children_ptr==base_children_ptr) begin
                if(sending_the_last) begin
                    if(consume_inject) begin
                        sending_the_last<=0;
                    end
                    else begin
                        sending_the_last<=1;
                    end
                end
                else begin
                    sending_the_last<=0;
                end
            end
            else
                sending_the_last<=sending_the_last;
        end
    end

    always@(posedge clk) begin
        sending_the_last_reg<=sending_the_last;
    end

    assign start_but_not_ready=start && children_ptr==base_children_ptr && children_ptr!= multicast_counter && sending_the_last==0;



    always@(posedge clk) begin
        if(rst) begin
            children_ptr<=base_children_ptr;
        end
        else if(children_ptr==base_children_ptr) begin
            if(sending_the_last) begin
                children_ptr<=base_children_ptr;
            end
            else if(start) begin
                children_ptr<=multicast_counter;
            end
            else
                children_ptr<=base_children_ptr;
        end
        else begin
            if(start && consume_inject) 
                children_ptr<=children_ptr-1;
            else
                children_ptr<=children_ptr;
        end
    end
            

  
    assign injector_in_multicast=multicast_children[children_ptr];
    assign fifo2_consume_multicast=start&& sending_the_last && consume_inject; //when the local port, do not need to send the multicast_children[0]  
 


    assign multicast_table_entry=multicast_table[routing_table_entry[23:8]];//when the packet is not multicast, this is invalid
    

    assign multicast_children[0]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],{4'b0},{7'b0,1'b1},weight_split[0],16'd0,input_fifo_out[PayloadLen-1:0]};// local pckt has the lowest priority and the table entry is a dont care value
    assign multicast_children[1]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[19:16],routing_table_entry[7:0],weight_split[1],multicast_table_entry[15:0],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[2]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[39:36],routing_table_entry[7:0],weight_split[2],multicast_table_entry[35:20],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[3]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[59:56],routing_table_entry[7:0],weight_split[3],multicast_table_entry[55:40],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[4]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[79:76],routing_table_entry[7:0],weight_split[4],multicast_table_entry[75:60],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[5]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[99:96],routing_table_entry[7:0],weight_split[5],multicast_table_entry[95:80],input_fifo_out[PayloadLen-1:0]};
    
    always@(*) begin
        if(multicast_table_entry[102:100]==1) begin//the counter of valid packets can only be 1,2,3,4,5
            if(SrcID_wire!=4'd0) begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
                weight_split[2]=0;
                weight_split[3]=0;
                weight_split[4]=0;
                weight_split[5]=0;
            end
            else begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos];//1/2
                weight_split[1]=0;
                weight_split[2]=0;
                weight_split[3]=0;
                weight_split[4]=0;
                weight_split[5]=0;
            end

        end
        else if(multicast_table_entry[102:100]==2) begin//the counter of valid packets can only be 1,2,3,4,5
            if(SrcID_wire!=4'd0) begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
                weight_split[3]=0;
                weight_split[4]=0;
                weight_split[5]=0;
            end
            else begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
                weight_split[2]=0;
                weight_split[3]=0;
                weight_split[4]=0;
                weight_split[5]=0;
            end
        end
        else if(multicast_table_entry[102:100]==3) begin
            if(SrcID_wire!=4'd0) begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[3]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[4]=0;
                weight_split[5]=0;
            end
            else begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
                weight_split[3]=0;
                weight_split[4]=0;
                weight_split[5]=0;
            end

        end
        else if(multicast_table_entry[102:100]==4) begin
            if(SrcID_wire!=4'd0) begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[3]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[4]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[5]=0;
            end
            else begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
                weight_split[3]=0;
                weight_split[4]=0;
                weight_split[5]=0;
            end

        end
        else if(multicast_table_entry[102:100]==5) begin
            if(SrcID_wire!=4'd0) begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[3]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[4]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[5]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            end
            else begin
                weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
                weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[3]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[4]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
                weight_split[5]=0;
            end


        end
        else begin
            weight_split[0]=0;
            weight_split[1]=0;
            weight_split[2]=0;
            weight_split[3]=0;
            weight_split[4]=0;
            weight_split[5]=0;
        end
    end

 

endmodule
