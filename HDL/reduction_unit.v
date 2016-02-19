//Purpose: unit that can handle the reduction in the router
//this unit will collect the packets marked in the multicast entry to their destinations
//
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 15th 2015
//
////
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
//reduction table entry format
/*
* at most five fan-in for 3D-torus network.
for each fanin, format is as below:
|3-bit expect counter|3-bit arrival bookkeeping counter|dst   |table index| weight accumulator| payload accumulator|
|3 bits              | 3 bits                          |4 bits|16 bits    | 8 bits            | 128 bits           | 162 bits in total
* */
module reduction_unit
#(
    parameter srcID=3'd0,
    parameter X=8'd0,
    parameter Y=8'd0,
    parameter Z=8'd0,
    parameter CoordWidth=4,
    parameter SrcXCoordPos=230,
    parameter SrcYCoordPos=238,
    parameter SrcZCoordPos=246,
    parameter DstXCoordPos=194,
    parameter DstYCoordPos=202,
    parameter DstZCoordPos=210,
    parameter SrcPacketIDPos=222,
    parameter DstPacketIDPos=186,
    parameter PacketTypePos=218,
    parameter packet_count=256,
    parameter PayloadLen=128,
    parameter DataWidth=256,
    parameter ReductionBitPos=254,
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
    parameter ReductionTableWidth=19,
    parameter ReductionTablesize=256,
    parameter PcktTypeLen=4

)
(
    input clk,
    input rst,
    input EjectSlotAvail,
    input [DataWidth-1:0] reduction_eject,
    input [RoutingTableWidth-1:0] routing_table_entry, 
    output reduction_consume, //read signal to read data from either ejector0 or ejector1
    output ready,//all the expected data have arrived
    output hold,//assert when the reduction_eject is the reduction type
    output [DataWidth-1:0] eject_out_reduction
);
    
    reg[ReductionTableWidth-1:0] reduction_table[ReductionTablesize-1:0];
    wire[ReductionTableWidth-1:0] reduction_table_entry;
    wire[ReductionTableWidth-1:0] reduction_table_entry_next;

    wire [2:0] next_counter;


    wire [IndexWidth-1:0] reduction_table_index;

    assign next_counter=reduction_table_entry[158:156]+1;

    assign hold=reduction_eject[ReductionBitPos];//incoming packet is reduction packet
    assign reduction_table_index=reduction_eject[IndexPos+IndexWidth-1:IndexPos];


    assign reduction_table_entry_next={reduction_table_entry[161:159],next_counter,reduction_table_entry[155:136],(reduction_table_entry[135:128]+reduction_eject[WeightPos+WeightWidth-1:WeightPos]),(reduction_table_entry[PayloadLen-1:0]+reduction_eject[PayloadLen-1:0])};

    assign reduction_table_entry=reduction_table[reduction_table_index];//when the packet is not reduction, this is invalid
    
    //data is ready to sent to outside when all the expected packtes have arrived
    //
    assign ready=hold && (reduction_table_entry[ReductionTableWidth-1:ReductionTableWidth-3]==reduction_table_entry[ReductionTableWidth-4:ReductionTableWidth-6]+1);
     assign eject_out_reduction={reduction_eject[DataWidth-1:152],reduction_table_entry_next[135:128],reduction_table_entry_next[151:136],reduction_table_entry_next[127:0]};



    assign reduction_consume=hold;

    always@(posedge clk) begin
        if(reduction_consume) begin
            reduction_table[reduction_table_index]<=reduction_table_entry_next;
        end
    end

endmodule


    

    

