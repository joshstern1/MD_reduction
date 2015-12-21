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
* |counter of valid packets|1st packet| 2nd packet| 3rd packet| 4th packet| 5th packet| 103 bits in total
* | 3 bits                 |20 bits   | 20 bits   | 20 bits   | 20 bits   | 20 bits   | 
* */

module multicast_unit#(
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
    output fifo2_consume_multicast //read signal to the data in the inject queue, which will be asserted when all of the data in the multicast queue has all been sent
);
    
    wire [MulticastTableWidth-1:0] multicast_table_entry;
   
    wire [DataWidth-1:0] multicast_children[4:0]; //There are five fan-out at most
    reg [WeightWidth-1:0] weight_split[4:0]; //weight split
//    wire start;//when asserted, means the multicast unit is active.
    reg start_reg;
    reg[MulticastTableWidth-1:0] multicast_table[MulticastTablesize-1:0];
    reg [2:0] children_ptr;//point to the children packet that is about to be sent
    wire [2:0] multicast_counter;
    
    assign start=routing_table_entry[RoutingTableWidth-1:RoutingTableWidth-PcktTypeLen]==2; //packet type equals to multicast

    assign multicast_counter=multicast_table_entry[102:100];

    always@(posedge clk) begin
        start_reg<=start;
    end

    always@(posedge clk) begin
        if(rst) begin
            children_ptr<=0;
        end
        else if(start && ~start_reg) begin
            children_ptr<=multicast_counter;// the initial counter is between 1 and 5
        end
        else if(start && consume_inject) begin
            children_ptr<=children_ptr-1;
        end
        else begin
            children_ptr<=children_ptr;
        end
      end
  
    assign injector_in_multicast=multicast_children[children_ptr];
    assign fifo2_consume_multicast=start&&(children_ptr==0);  



    assign multicast_table_entry=multicast_table[routing_table_entry[23:8]];//when the packet is not multicast, this is invalid
    
    assign multicast_children[0]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth-1],multicast_table_entry[19:16],routing_table_entry[PriorityPos+PriorityWidth-1:PriorityPos],weight_split[0],multicast_table_entry[15:0],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[1]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth-1],multicast_table_entry[39:36],routing_table_entry[PriorityPos+PriorityWidth-1:PriorityPos],weight_split[1],multicast_table_entry[35:20],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[2]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth-1],multicast_table_entry[59:56],routing_table_entry[PriorityPos+PriorityWidth-1:PriorityPos],weight_split[2],multicast_table_entry[55:50],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[3]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth-1],multicast_table_entry[79:76],routing_table_entry[PriorityPos+PriorityWidth-1:PriorityPos],weight_split[3],multicast_table_entry[75:70],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[4]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth-1],multicast_table_entry[99:96],routing_table_entry[PriorityPos+PriorityWidth-1:PriorityPos],weight_split[3],multicast_table_entry[95:90],input_fifo_out[PayloadLen-1:0]};
    
    always@(*) begin
        if(multicast_table_entry[127:120]==2) begin//the counter of valid packets can only be 2,3,4,5
            weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
            weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
            weight_split[2]=0;
            weight_split[3]=0;
            weight_split[4]=0;
        end
        else if(multicast_table_entry[127:120]==3) begin
            weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>1;//1/2
            weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[3]=0;
            weight_split[4]=0;
        end
        else if(multicast_table_entry[127:120]==4) begin
            weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[3]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[4]=0;
        end
        else if(multicast_table_entry[127:120]==5) begin
            weight_split[0]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[1]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[2]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>2;//1/4
            weight_split[3]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
            weight_split[4]=input_fifo_out[WeightPos+WeightWidth-1:WeightPos]>>3;//1/8
        end
        else begin
            weight_split[0]=0;
            weight_split[1]=0;
            weight_split[2]=0;
            weight_split[3]=0;
            weight_split[4]=0;
        end
    end

 

endmodule
