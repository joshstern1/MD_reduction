//Purpose: crossbar-based switch that is composed of 7 routers
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Feb 10th 2015
//
//the 256-bit data format will be like this
//Outside the router 
/*
    *|255      |254          | 253--246    |245--238     |237--230     |229--222        |221--218   |217--210     |209--202     |201--194     |193--186            |185--152|151-----144|143-----128|127--96|95--64|63--32|31--0|
    *|valid bit|reduction bit|z of src node|y of src node|x of src onde|src id of packet|packet type|z of dst node|y of dst node|x of dst node|dst id of the packet|unused  |log  weight|table index|type   |z     |y     |x    |

    *

    */
//inside the router
/*
    *|255      |254          |253--246     |245--238     |237--230     |229--222        |221---218  |217--210     |209--202     |201--194     |193--186            |185-164|163---160|159---152|151-----144|143-----128|127--96|95--64|63--32|31--0|
    *|valid bit|reduction bit|Z of src node|Y of src node|X of src onde|src id of packet|packet type|z of dst node|y of dst node|x of dst node|dst id of the packet|unused  |dst      |priority |log  weight|table index|type   |z     |y     |x    |

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
  the counter are between 1 and 5
* */

in_port
#(
    parameter DataSize=8'd172,
    parameter X=8'd0,
    parameter Y=8'd0,
    parameter Z=8'd0,
    parameter srcID=4'd0,
    parameter ReductionBitPos=254,
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

//interfaces between the input port and fifos
    input [DataWidth-1:0] in,
    input data_in_avail,

    output input_fifo_full,

//interfaces between muxes and in_port
    output reg [Datawidth-1:0] out_port_in[7];
    input out_avail[7];
)

    //pipeline has three stages:
    //first stage: input buffer consume stage (IC)
    //second stage: routing table read stage (RR)
    //third stage: multicast table read stage (MR)
    //fourth stage: muxes input stage (MI) this is the stage before the muxes

    //pipeline control signals
    wire stall;
    wire input_fifo_consume;
    

	//the ID mapping on the crossbar ports is shown below
    //local:0
    //yneg:1
    //ypos:2
    //xpos:3
    //xneg:4
    //zpos:5
    //zneg:6
    //
	//routing table
	reg[RoutingTableWidth-1:0] routing_table[RoutingTablesize-1:0];
    
    //multicast table
    reg[RoutingTableWidth-1:0] multicast_table[MulticastTablesize-1:0];

    

    wire input_fifo_full;
    wire input_fifo_empty;
    wire [DataWidth-1:0] input_fifo_out_IC; //input fifo out from buffer at IC(input buffer consumption) stage

    reg [DataWidth-1:0] input_fifo_out_RR; //input fifo out at routing table read stage

    reg [DataWidth-1:0] input_fifo_out_MR; //input fifo out at multicast table read stage

    


    wire [IndexWidth-1:0] routing_table_index;
    reg [RoutingTableWidth-1:0] routing_table_entry;//routing table entry register at RR stage
    reg [RoutingTableWidth-1:0] routing_table_entry_MR;//routing table entry regiester at MR stage



    wire [PcktTypeLen-1:0] packet_type;
    wire is_multicast;
    reg is_multicast_MR;// the state register of is_multicast at MR stage
    reg [MulticastTableWidth-1:0] multicast_table_entry;
    wire [IndexWidth-1:0] multicast_table_index;

    wire [DataWidth-1:0] multicast_children[5:0];
    wire [WeightWidth-1:0] weight_split[5:0];

    wire [2:0] perm_multicast[7]; //the permutation pattern from the multicast children to the output ports out[i]<=multicast_children[perm[i]]; if perm[i]=8 means the out[i] should get a zero value.

    wire [DataWidth-1:0] singcast_children;    


    
    //pipeline stage1 IC
    buffer#(
        .buffer_depth(InterNodeFIFODepth),
        .buffer_width(DataWidth)
    )(
        .clk(clk),
        .rst(rst),
        .in(in),
        .produce(data_in_avail),
        .consume(input_fifo_consume),
        .full(input_fifo_full),
        .empty(input_fifo_empty),
        .out(input_fifo_out_IC)
    )

    
    assign routing_table_index=input_fifo_out[IndexPos+IndexWidth-1:IndexPos];

    //pipeline stage2 RR
    always@(posedge clk) begin
        routing_table_entry<=routing_table[routing_table_index];
    end

    always@(posedge clk) begin
        input_fifo_out_RR<=input_fifo_out_IC;
    end

    //pipeline stage 3 MR
    always@(posedge clk) begin
        input_fifo_out_MR<=input_fifo_out_RR;
    end
    assign packet_type=routing_table_entry[31:28];
    assign is_multicast=(packet_type==4'd9);
    assign mutlicast_table_index=(is_multicast)?routing_table_entry[23:8]:0;

    always@(posedge clk) begin
        if(is_multicast) begin
            multicast_table_entry<=multicast_table[multicast_table_index];
        end
        else begin
            multicast_table_entry<=0;
        end
    end

    always@(posedge clk) begin
        is_multicast_MR<=is_multicast;
    end
    
    always@(posedge clk) begin
        routing_table_entry_MR<=routing_table_entry;
    end



    //pipeline stage 4 MI
    //
    //
    //
    //
    always@(*) begin
        if(is_multicast_MR) begin
            singlecast_children=0;
        end
        else if(routing_table_entry_MR[RoutingTableWidth-1:RoutingTableWidth-PcktTypeLen]==SINGLECAST) begin
            singlecast_children={input_fifo_out_MR[DataWidth-1],1'b0,input_fifo_out_MR[ReductionBitPos-1:ExitPos+ExitWidth],routing_table_entry_MR[27:24],routing_table_entry_MR[7:0],input_fifo_out_MR[WeightPos+WeightWidth-1:WeightPos],routing_table_entry_MR[23:8],input_fifo_out_MR[PayloadLen-1:0]};
        end
        else if(routing_table_entry_MR[RoutingTableWidth-1:RoutingTableWidth-PcktTypeLen]==REDUCTION) begin
            singlecast_children={input_fifo_out_MR[DataWidth-1],1'b1,input_fifo_out_MR[ReductionBitPos-1:ExitPos+ExitWidth],routing_table_entry_MR[27:24],routing_table_entry_MR[7:0],input_fifo_out_MR[WeightPos+WeightWidth-1:WeightPos],routing_table_entry_MR[23:8],input_fifo_out_MR[PayloadLen-1:0]};
        end
        else begin
            singlecast_children=0;
        end
    end

    always@(posedge clk) begin
        if(is_multicast_MR) begin
            out_port_in[0]<=multicast_children[0];
            out_port_in[1]<=(perm[1]==7)?0:multicast_children[perm[1]];
            out_port_in[2]<=(perm[2]==7)?0:multicast_children[perm[2]];
            out_port_in[3]<=(perm[3]==7)?0:multicast_children[perm[3]];
            out_port_in[4]<=(perm[4]==7)?0:multicast_children[perm[4]];
            out_port_in[5]<=(perm[5]==7)?0:multicast_children[perm[5]];
            out_port_in[6]<=(perm[6]==7)?0:multicast_children[perm[6]];
        end
        else begin
            out_port_in[0]<=(routing_table_entry_MR[27:24]==0)?singlecast_children:0;
            out_port_in[1]<=(routing_table_entry_MR[27:24]==1)?singlecast_children:0;
            out_port_in[2]<=(routing_table_entry_MR[27:24]==2)?singlecast_children:0;
            out_port_in[3]<=(routing_table_entry_MR[27:24]==3)?singlecast_children:0;
            out_port_in[4]<=(routing_table_entry_MR[27:24]==4)?singlecast_children:0;
            out_port_in[5]<=(routing_table_entry_MR[27:24]==5)?singlecast_children:0;
            out_port_in[6]<=(routing_table_entry_MR[27:24]==6)?singlecast_children:0;
        end
    end
    assign multicast_children[0]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],{4'b0},{7'b0,1'b1},weight_split[0],16'd0,input_fifo_out[PayloadLen-1:0]};// local pckt has the lowest priority and the table entry is a dont care value
    assign multicast_children[1]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[19:16],routing_table_entry[7:0],weight_split[1],multicast_table_entry[15:0],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[2]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[39:36],routing_table_entry[7:0],weight_split[2],multicast_table_entry[35:20],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[3]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[59:56],routing_table_entry[7:0],weight_split[3],multicast_table_entry[55:40],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[4]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[79:76],routing_table_entry[7:0],weight_split[4],multicast_table_entry[75:60],input_fifo_out[PayloadLen-1:0]};
    assign multicast_children[5]={input_fifo_out[DataWidth-1:ExitPos+ExitWidth],multicast_table_entry[99:96],routing_table_entry[7:0],weight_split[5],multicast_table_entry[95:80],input_fifo_out[PayloadLen-1:0]};

    always@(*) begin
        if(multicast_table_entry[19:16]==4'd1) begin
            perm_multicast[1]=1;
        end
        else if(multicast_table_entry[39:36]==4'd1) begin
            perm_multicast[1]=2;
        end
        else if(multicast_table_entry[59:56]==4'd1) begin
            perm_multicast[1]=3;
        end
        else if(multicast_table_entry[79:76]==4'd1) begin
            perm_multicast[1]=4;
        end
        else if(multicast_table_entry[99:96]==4'd1) begin
            perm_multicast[1]=5;
        end
        else begin
            perm_multicast[1]=7;
        end
    end

    always@(*) begin
        if(multicast_table_entry[19:16]==4'd2) begin
            perm_multicast[2]=1;
        end
        else if(multicast_table_entry[39:36]==4'd2) begin
            perm_multicast[2]=2;
        end
        else if(multicast_table_entry[59:56]==4'd2) begin
            perm_multicast[2]=3;
        end
        else if(multicast_table_entry[79:76]==4'd2) begin
            perm_multicast[2]=4;
        end
        else if(multicast_table_entry[99:96]==4'd2) begin
            perm_multicast[2]=5;
        end
        else begin
            perm_multicast[2]=7;
        end
    end
 
    always@(*) begin
        if(multicast_table_entry[19:16]==4'd3) begin
            perm_multicast[3]=1;
        end
        else if(multicast_table_entry[39:36]==4'd3) begin
            perm_multicast[3]=2;
        end
        else if(multicast_table_entry[59:56]==4'd3) begin
            perm_multicast[3]=3;
        end
        else if(multicast_table_entry[79:76]==4'd3) begin
            perm_multicast[3]=4;
        end
        else if(multicast_table_entry[99:96]==4'd3) begin
            perm_multicast[3]=5;
        end
        else begin
            perm_multicast[3]=7;
        end
    end
 
    always@(*) begin
        if(multicast_table_entry[19:16]==4'd4) begin
            perm_multicast[4]=1;
        end
        else if(multicast_table_entry[39:36]==4'd4) begin
            perm_multicast[4]=2;
        end
        else if(multicast_table_entry[59:56]==4'd4) begin
            perm_multicast[4]=3;
        end
        else if(multicast_table_entry[79:76]==4'd4) begin
            perm_multicast[4]=4;
        end
        else if(multicast_table_entry[99:96]==4'd4) begin
            perm_multicast[4]=5;
        end
        else begin
            perm_multicast[4]=7;
        end
    end

    always@(*) begin
        if(multicast_table_entry[19:16]==4'd5) begin
            perm_multicast[5]=1;
        end
        else if(multicast_table_entry[39:36]==4'd5) begin
            perm_multicast[5]=2;
        end
        else if(multicast_table_entry[59:56]==4'd5) begin
            perm_multicast[5]=3;
        end
        else if(multicast_table_entry[79:76]==4'd5) begin
            perm_multicast[5]=4;
        end
        else if(multicast_table_entry[99:96]==4'd5) begin
            perm_multicast[5]=5;
        end
        else begin
            perm_multicast[5]=7;
        end
    end

    always@(*) begin
        if(multicast_table_entry[19:16]==4'd6) begin
            perm_multicast[6]=1;
        end
        else if(multicast_table_entry[39:36]==4'd6) begin
            perm_multicast[6]=2;
        end
        else if(multicast_table_entry[59:56]==4'd6) begin
            perm_multicast[6]=3;
        end
        else if(multicast_table_entry[79:76]==4'd6) begin
            perm_multicast[6]=4;
        end
        else if(multicast_table_entry[99:96]==4'd6) begin
            perm_multicast[6]=5;
        end
        else begin
            perm_multicast[6]=7;
        end
    end













    


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

    always@(posedge clk) begin
        if(multicast_table_entry[19:16]==0

    

    always@(posedge clk) begin
        if(multicast_table_entry[19:16] && multicast_table_entry[39:36] && multicast_table_entry[59:56] &&  multicast_table_entry[79:76] && multicast_table_entry[99:96]) begin
            
            
        end
        else if(multicast[19:16]==7 && multicast[39:36]) begin
        
        end
    end        


endmodule

    

    
    

    


    
