//Purpose: Injection unit to inject packet into network
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 9th 2015
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
module local_unit
#(
    parameter X=4'd0,
    parameter Y=4'd0,
    parameter Z=4'd0,
    parameter packet_count=256,
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
    input [DataWidth-1:0] eject_local,
    input eject_send_local,
    input InjectSlotAvail_Avail,

    output [DataWidth-1:0] inject_local,
    output inject_receive_local,
    output EjectSlotAvail_local
);
    wire local_fifo_full;
    wire local_fifo_empty;
    wire [DataWidth-1:0] local_fifo_out;
    wire [15:0] local_fifo_util;
    integer fd;
//local FIFO instantiated
    FIFO #(
        .FIFO_depth(packet_count),
        .FIFO_width(DataWidth)
    )
    local_fifo(
        .clk(clk),
        .rst(rst),
        .in(eject_local),
        .consume(1'b0),//read enabling to out port from FIFO
        .produce(eject_send_local),//write enabling to in port to FIFO 
        .out(local_fifo_out),
        .full(local_fifo_full),
        .empty(local_fifo_empty),
        .util(local_fifo_util)
    );
    
    assign EjectSlotAvail_local=~local_fifo_full;
    always@(posedge clk) begin
        if(eject_send_local && EjectSlotAvail_local)
        begin

	 

    
    
