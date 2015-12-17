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
    input consume_inject,
    input [RoutingTableWidth-1:0] routing_table_entry, 
    output reg fifo2_consume_reduction,
    output reg ready,//all the expected data have arrived
    output hold,//assert when the input_fifo_out is the reduction type
    output reg [DataWidth-1:0] injector_in_reduction
);
    
    reg[ReductionTableWidth-1:0] reduction_table[ReductionTablesize-1:0];
    wire[ReductionTableWidth-1:0] reduction_table_entry;
    wire[ReductionTableWidth-1:0] reduction_table_entry_next;

    assign reduction_table_entry_next={reduction_table_entry[161:159],(reduction_table_entry[158:156]+1),reduction_table_entry[155:136],(reduction_table_entry+input_fifo_out[WeightPos+WeightWidth-1:WeightPos]),(reduction_table_entry[PayloadLen-1:0]+input_fifo_out[PayloadLen-1:0])};

    assign reduction_table_entry=reduction_table[routing_table_entry[23:8]];//when the packet is not reduction, this is invalid
    
    assign hold=routing_table_entry[RoutingTableWidth-1:RoutingTableWidth-PcktTypeLen]==3; //packet type equals to reduction
    //data is ready to sent to outside when all the expected packtes have arrived
    always@(posedge clk) begin
        if(~ready) begin
            if(hold) begin
                ready<=(reduction_table_entry[ReductionTableWidth-1:ReductionTableWidth-3]==reduction_table_entry[ReductionTableWidth-4:ReductionTableWidth-6]+1);//in next cycle, this table entry will have all data ready
            end
            else begin
                ready<=0;
            end
        end
        else begin
            if(consume_inject)
                ready<=0;
            else
                ready<=1;
        end

    end

    always@(posedge clk) begin
        if(hold) begin
            if(reduction_table_entry[ReductionTableWidth-1:ReductionTableWidth-3]==reduction_table_entry[ReductionTableWidth-4:ReductionTableWidth-6]+1)
                injector_in_reduction<={1'b1,91'd0,reduction_table_entry[155:152],input_fifo_out[PriorityPos+PriorityWidth-1:PriorityPos],reduction_table_entry[135:128],reduction_table_entry[151:136],reduction_table_entry[127:0]};
            else
                injector_in_reduction<=injector_in_reduction;
        end
        else
            injector_in_reduction<=injector_in_reduction;
    end

    always@(*) begin
        if(hold&&~ready) begin
            fifo2_consume_reduction=(reduction_table_entry[ReductionTableWidth-1:ReductionTableWidth-3]>reduction_table_entry[ReductionTableWidth-4:ReductionTableWidth-6]);
        end
        else begin
            fifo2_consume_reduction=0;
        end
    end

    always@(posedge clk) begin
        if(fifo2_consume_reduction) begin
            reduction_table[routing_table_entry[23:8]]<=reduction_table_entry_next;
        end
    end

endmodule


    

    
