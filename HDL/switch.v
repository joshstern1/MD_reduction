//Purpose: ring-based switch that is composed of 7 routers
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 17th 2015
//
module switch
#(
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

)(

	input clk,
    input rst,
	input [DataWidth-1:0] inject_xpos,	
    input inject_receive_xpos, 
    input EjectSlotAvail_xpos,
	input [DataWidth-1:0] inject_xneg,	
    input inject_receive_xneg, 
    input EjectSlotAvail_xneg,
	input [DataWidth-1:0] inject_ypos,	
    input inject_receive_ypos, 
    input EjectSlotAvail_ypos,
	input [DataWidth-1:0] inject_yneg,	
    input inject_receive_yneg, 
    input EjectSlotAvail_yneg,
	input [DataWidth-1:0]inject_zpos,	
    input inject_receive_zpos, 
    input EjectSlotAvail_zpos,
	input [DataWidth-1:0] inject_zneg,	
    input inject_receive_zneg, 
    input EjectSlotAvail_zneg,
	
//output
	output [DataWidth-1:0] eject_xpos, 
    output eject_send_xpos, 
    output InjectSlotAvail_xpos,
	output [DataWidth-1:0] eject_xneg, 
    output eject_send_xneg, 
    output InjectSlotAvail_xneg,
	output [DataWidth-1:0] eject_ypos, 
    output eject_send_ypos, 
    output InjectSlotAvail_ypos,
	output [DataWidth-1:0] eject_yneg, 
    output eject_send_yneg, 
    output InjectSlotAvail_yneg,
	output [DataWidth-1:0] eject_zpos, 
    output eject_send_zpos, 
    output InjectSlotAvail_zpos,
	output [DataWidth-1:0] eject_zneg, 
    output eject_send_zneg, 
    output InjectSlotAvail_zneg,

    output [7:0] xpos_ClockwiseUtil, 
    output [7:0] xpos_CounterClockwiseUtil, 
    output [7:0] xpos_InjectUtil,
    output [7:0] xneg_ClockwiseUtil, 
    output [7:0] xneg_CounterClockwiseUtil, 
    output [7:0] xneg_InjectUtil,
    output [7:0] ypos_ClockwiseUtil, 
    output [7:0] ypos_CounterClockwiseUtil, 
    output [7:0] ypos_InjectUtil,
    output [7:0] yneg_ClockwiseUtil, 
    output [7:0] yneg_CounterClockwiseUtil, 
    output [7:0] yneg_InjectUtil,
    output [7:0] zpos_ClockwiseUtil, 
    output [7:0] zpos_CounterClockwiseUtil, 
    output [7:0] zpos_InjectUtil,
    output [7:0] zneg_ClockwiseUtil, 
    output [7:0] zneg_CounterClockwiseUtil, 
    output [7:0] zneg_InjectUtil
);
	

	
	wire inject_receive_local, eject_send_local;
	wire EjectSlotAvail_local, InjectSlotAvail_local;
	wire [DataWidth-1:0] inject_local, eject_local;
	
	wire [DataWidth-1:0] ClockwiseIn_xneg_xpos, ClockwiseOut_xneg_xpos;
	wire [DataWidth-1:0] CounterClockwiseIn_xpos_xneg, CounterClockwiseOut_xpos_xneg;
	wire CounterClockwiseReceive_xpos_xneg, CounterClockwiseSend_xpos_xneg;
	wire ClockwiseReceive_xneg_xpos, ClockwiseSend_xneg_xpos;
	wire ClockwiseNextSlotAvail_xneg_xpos, ClockwiseSlotAvail_xneg_xpos;
	wire CounterClockwiseNextSlotAvail_xpos_xneg, CounterClockwiseSlotAvail_xpos_xneg;
	//wire CounterClockwiseSlotAvail_xpos_xneg, CounterClockwiseNextSlotAvail_xpos_xneg;
	
	wire [DataWidth-1:0] ClockwiseIn_zpos_xneg, ClockwiseOut_zpos_xneg;
	wire [DataWidth-1:0] CounterClockwiseIn_xneg_zpos, CounterClockwiseOut_xneg_zpos;
	wire CounterClockwiseReceive_xneg_zpos, CounterClockwiseSend_xneg_zpos;
	wire ClockwiseReceive_zpos_xneg, ClockwiseSend_zpos_xneg;
	wire ClockwiseNextSlotAvail_zpos_xneg, ClockwiseSlotAvail_zpos_xneg;
	wire CounterClockwiseNextSlotAvail_xneg_zpos, CounterClockwiseSlotAvail_xneg_zpos;
	//wire CounterClockwiseSlotAvail_xneg_zpos, CounterClockwiseNextSlotAvail_xneg_zpos;
	
	wire [DataWidth-1:0] ClockwiseIn_zneg_zpos, ClockwiseOut_zneg_zpos;
	wire [DataWidth-1:0] CounterClockwiseIn_zpos_zneg, CounterClockwiseOut_zpos_zneg;
	wire CounterClockwiseReceive_zpos_zneg, CounterClockwiseSend_zpos_zneg;
	wire ClockwiseReceive_zneg_zpos, ClockwiseSend_zneg_zpos;
	wire ClockwiseNextSlotAvail_zneg_zpos, ClockwiseSlotAvail_zneg_zpos;
	wire CounterClockwiseNextSlotAvail_zpos_zneg, CounterClockwiseSlotAvail_zpos_zneg;
	//wire CounterClockwiseSlotAvail_zpos_zneg, CounterClockwiseNextSlotAvail_zpos_zneg;
	
	wire [DataWidth-1:0] ClockwiseIn_local_zneg, ClockwiseOut_local_zneg;
	wire [DataWidth-1:0] CounterClockwiseIn_zneg_local, CounterClockwiseOut_zneg_local;
	wire CounterClockwiseReceive_zneg_local, CounterClockwiseSend_zneg_local;
	wire ClockwiseReceive_local_zneg, ClockwiseSend_local_zneg;
	wire ClockwiseNextSlotAvail_local_zneg, ClockwiseSlotAvail_local_zneg;
	wire CounterClockwiseNextSlotAvail_zneg_local, CounterClockwiseSlotAvail_zneg_local;
	//wire CounterClockwiseSlotAvail_zneg_local, CounterClockwiseNextSlotAvail_zneg_local;
	
	wire [DataWidth-1:0] ClockwiseIn_yneg_local, ClockwiseOut_yneg_local;
	wire [DataWidth-1:0] CounterClockwiseIn_local_yneg, CounterClockwiseOut_local_yneg;
	wire CounterClockwiseReceive_local_yneg, CounterClockwiseSend_local_yneg;
	wire ClockwiseReceive_yneg_local, ClockwiseSend_yneg_local;
	wire ClockwiseNextSlotAvail_yneg_local, ClockwiseSlotAvail_yneg_local;
	wire CounterClockwiseNextSlotAvail_local_yneg, CounterClockwiseSlotAvail_local_yneg;
	//wire CounterClockwiseSlotAvail_local_yneg, CounterClockwiseNextSlotAvail_local_yneg;
	
	wire [DataWidth-1:0] ClockwiseIn_ypos_yneg, ClockwiseOut_ypos_yneg;
	wire [DataWidth-1:0] CounterClockwiseIn_yneg_ypos, CounterClockwiseOut_yneg_ypos;
	wire CounterClockwiseReceive_yneg_ypos, CounterClockwiseSend_yneg_ypos;
	wire ClockwiseReceive_ypos_yneg, ClockwiseSend_ypos_yneg;
	wire ClockwiseNextSlotAvail_ypos_yneg, ClockwiseSlotAvail_ypos_yneg;
	wire CounterClockwiseNextSlotAvail_yneg_ypos, CounterClockwiseSlotAvail_yneg_ypos;
	//wire CounterClockwiseSlotAvail_yneg_ypos, CounterClockwiseNextSlotAvail_yneg_ypos;
	
	wire [DataWidth-1:0] ClockwiseIn_xpos_ypos, ClockwiseOut_xpos_ypos;
	wire [DataWidth-1:0] CounterClockwiseIn_ypos_xpos, CounterClockwiseOut_ypos_xpos;
	wire CounterClockwiseReceive_ypos_xpos, CounterClockwiseSend_ypos_xpos;
	wire ClockwiseReceive_xpos_ypos, ClockwiseSend_xpos_ypos;
	wire ClockwiseNextSlotAvail_xpos_ypos, ClockwiseSlotAvail_xpos_ypos;
	wire CounterClockwiseNextSlotAvail_ypos_xpos, CounterClockwiseSlotAvail_ypos_xpos;
	//wire CounterClockwiseSlotAvail_ypos_xpos, CounterClockwiseNextSlotAvail_ypos_xpos;
	
	
	
	//the ID mapping on the ring is shown below
	//     +x     +y     -y
	//     ||     ||     ||
	//     3------2------1
	//     |              \
	//     |               \
	//     |                0==local
	//     |               /
	//     |              /
	//     4------5------6
	//     ||     ||     ||
	//     -x     +z     -z
	
	local_unit u0(clk,rst,eject_local,eject_send_local,InjectSlotAvail_local,
				inject_local,inject_receive_local,EjectSlotAvail_local);
	

	router #(
        .srcID(3),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    )
    XPOS(
        .clk(clk),
        .rst(rst),
        .ClockwiseIn(ClockwiseIn_xneg_xpos),
        .CounterClockwiseIn(CounterClockwiseIn_ypos_xpos),
        .inject(inject_xpos), //data injected from other node or local
        .inject_receive(inject_receive_xpos),//write signal at the inject port
        .ClockwiseReceive(ClockwiseReceive_xneg_xpos),//write signal at the clockwise port
        .CounterClockwiseReceive(CounterClockwiseReceive_ypos_xpos),//write signal at the CounterClockwise port
        .ClockwiseNextSlotAvail(ClockwiseNextSlotAvail_xpos_ypos),
        .CounterClockwiseNextSlotAvail(CounterClockwiseNextSlotAvail_xpos_xneg),
        .EjectSlotAvail(EjectSlotAvail_xpos),
//output
        .ClockwiseOut(ClockwiseOut_xpos_ypos),
        .CounterClockwiseOut(CounterClockwiseOut_xpos_xneg),
        .eject(eject_xpos),
        .eject_send(eject_send_xpos),
        .ClockwiseSend(ClockwiseSend_xpos_ypos),
        .CounterClockwiseSend(CounterClockwiseOut_xpos_xneg),
        .ClockwiseAvail(ClockwiseSlotAvail_xneg_xpos),
        .CounterClockwiseAvail(CounterClockwiseSlotAvail_ypos_xpos),
        .InjectSlotAvail(InjectSlotAvail_xpos),
        .CounterClockwiseUtil(xpos_CounterClockwiseUtil),
        .ClockwiseUtil(xpos_ClockwiseUtil),
        .InjectUtil(xpos_InjectUtil)
    );

	
/*	assign ClockwiseIn_xneg_xpos=ClockwiseOut_xneg_xpos;
	assign CounterClockwiseIn_xpos_xneg=CounterClockwiseOut_xpos_xneg;
	assign CounterClockwiseReceive_xpos_xneg=CounterClockwiseSend_xpos_xneg;
	assign ClockwiseReceive_xneg_xpos=ClockwiseSend_xneg_xpos;
	assign ClockwiseNextSlotAvail_xneg_xpos=ClockwiseSlotAvail_xneg_xpos;
	assign CounterClockwiseSlotAvail_xpos_xneg=CounterClockwiseNextSlotAvail_xpos_xneg;
*/	
	router #(
        .srcID(4),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    )XNEG(
//input
	    .clk(clk), 
        .rst(rst),
	    .ClockwiseIn(ClockwiseIn_zpos_xneg), 
	    .CounterClockwiseIn(CounterClockwiseIn_xpos_xneg),
	    .inject(inject_xneg),
	    .inject_receive(inject_receive_xneg),
    	.ClockwiseReceive(ClockwiseReceive_zpos_xneg),
	    .CounterClockwiseReceive(CounterClockwiseReceive_xpos_xneg),
	    .ClockwiseNextSlotAvail(ClockwiseNextSlotAvail_xneg_xpos),
	    .CounterClockwiseNextSlotAvail(CounterClockwiseNextSlotAvail_xneg_zpos),
	    .EjectSlotAvail(EjectSlotAvail_xneg),
//output
	    .ClockwiseOut(ClockwiseOut_xneg_xpos),
	    .CounterClockwiseOut(CounterClockwiseOut_xneg_zpos),
	    .eject_send(eject_send_xneg),
	    .ClockwiseSend(ClockwiseSend_xneg_xpos),
	    .CounterClockwiseSend(CounterClockwiseSend_xneg_zpos),
	    .ClockwiseAvail(ClockwiseSlotAvail_zpos_xneg),
	    .CounterClockwiseAvail(CounterClockwiseSlotAvail_xpos_xneg),
	    .InjectSlotAvail(InjectSlotAvail_xneg),
	    .eject(eject_xneg)
    );
	
	router #(
        .srcID(5),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    ) ZPOS(
//input
	    .clk(clk), 
        .rst(rst),
	    .ClockwiseIn(ClockwiseIn_zneg_zpos), 
	    .CounterClockwiseIn(CounterClockwiseIn_xneg_zpos),
	    .inject(inject_zpos),
	    .inject_receive(inject_receive_zpos),
	    .ClockwiseReceive(ClockwiseReceive_zneg_zpos),
	    .CounterClockwiseReceive(CounterClockwiseReceive_xneg_zpos),
	    .ClockwiseNextSlotAvail(ClockwiseNextSlotAvail_zpos_xneg),
	    .CounterClockwiseNextSlotAvail(CounterClockwiseNextSlotAvail_zpos_zneg),
	    .EjectSlotAvail(EjectSlotAvail_zpos),
//output
	    .ClockwiseOut(ClockwiseOut_zpos_xneg),
	    .CounterClockwiseOut(CounterClockwiseOut_zpos_zneg),
	    .eject_send(eject_send_zpos),
	    .ClockwiseSend(ClockwiseSend_zpos_xneg),
	    .CounterClockwiseSend(CounterClockwiseSend_zpos_zneg),
	    .ClockwiseAvail(ClockwiseSlotAvail_zneg_zpos),
	    .CounterClockwiseAvail(CounterClockwiseSlotAvail_xneg_zpos),
	    .InjectSlotAvail(InjectSlotAvail_zpos),
	    .eject(eject_zpos)
    );

    router#(
        .srcID(6),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    ) ZNEG(
//input
    	.clk(clk), 
        .rst(rst),
	    .ClockwiseIn(ClockwiseIn_local_zneg), 
	    .CounterClockwiseIn(CounterClockwiseIn_zpos_zneg),
	    .inject(inject_zneg),
	    .inject_receive(inject_receive_zneg),
	    .ClockwiseReceive(ClockwiseReceive_local_zneg),
	    .CounterClockwiseReceive(CounterClockwiseReceive_zpos_zneg),
	    .ClockwiseNextSlotAvail(ClockwiseNextSlotAvail_zneg_zpos),
	    .CounterClockwiseNextSlotAvail(CounterClockwiseNextSlotAvail_zneg_local),
	    .EjectSlotAvail(EjectSlotAvail_zneg),
//output
	    .ClockwiseOut(ClockwiseOut_zneg_zpos),
	    .CounterClockwiseOut(CounterClockwiseOut_zneg_local),
	    .eject_send(eject_send_zneg),
	    .ClockwiseSend(ClockwiseSend_zneg_zpos),
	    .CounterClockwiseSend(CounterClockwiseSend_zneg_local),
	    .ClockwiseAvail(ClockwiseSlotAvail_local_zneg),
	    .CounterClockwiseAvail(CounterClockwiseSlotAvail_zpos_zneg),
	    .InjectSlotAvail(InjectSlotAvail_zneg),
	    .eject(eject_zneg)
    );

    router #(
        .srcID(0),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    )LOCAL(
//input
	.clk(clk), 
    .rst(rst),
	.ClockwiseIn(ClockwiseIn_yneg_local), 
	.CounterClockwiseIn(CounterClockwiseIn_zneg_local),
	.inject(inject_local),
	.inject_receive(inject_receive_local),
	.ClockwiseReceive(ClockwiseReceive_yneg_local),
	.CounterClockwiseReceive(CounterClockwiseReceive_zneg_local),
	.ClockwiseNextSlotAvail(ClockwiseNextSlotAvail_local_zneg),
	.CounterClockwiseNextSlotAvail(CounterClockwiseNextSlotAvail_local_yneg),
	.EjectSlotAvail(EjectSlotAvail_local),
//output
	.ClockwiseOut(ClockwiseOut_local_zneg),
	.CounterClockwiseOut(CounterClockwiseOut_local_yneg),
	.eject_send(eject_send_local),
	.ClockwiseSend(ClockwiseSend_local_zneg),
    .CounterClockwiseSend(CounterClockwiseSend_local_yneg),
	.ClockwiseAvail(ClockwiseSlotAvail_yneg_local),
	.CounterClockwiseAvail(CounterClockwiseSlotAvail_zneg_local),
	.InjectSlotAvail(InjectSlotAvail_local),
	.eject(eject_local)
    );
	
	router #(
        .srcID(1),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    )YNEG(
//input
	.clk(clk), 
    .rst(rst),
	.ClockwiseIn(ClockwiseIn_ypos_yneg), 
	.CounterClockwiseIn(CounterClockwiseIn_local_yneg),
	.inject(inject_yneg),
	.inject_receive(inject_receive_yneg),
	.ClockwiseReceive(ClockwiseReceive_ypos_yneg),
	.CounterClockwiseReceive(CounterClockwiseReceive_local_yneg),
	.ClockwiseNextSlotAvail(ClockwiseNextSlotAvail_yneg_local),
	.CounterClockwiseNextSlotAvail(CounterClockwiseNextSlotAvail_yneg_ypos),
	.EjectSlotAvail(EjectSlotAvail_yneg),
//output
	.ClockwiseOut(ClockwiseOut_yneg_local),
	.CounterCLockwiseOut(CounterClockwiseOut_yneg_ypos),
	.eject_send(eject_send_yneg),
	.ClockwiseSend(ClockwiseSend_yneg_local),
	.CounterClockwiseSend(CounterClockwiseSend_yneg_ypos),
	.ClockwiseAvail(ClockwiseSlotAvail_ypos_yneg),
	.CounterClockwiseAvail(CounterClockwiseSlotAvail_local_yneg),
	.InjectSlotAvail(InjectSlotAvail_yneg),
	.eject(eject_yneg)
    );

    router #(
        .srcID(2),
        .PayloadLen(PayloadLen),
        .DataWidth(DataWidth),
        .WeightPos(WeightPos),
        .WeightWidth(WeightWidth),
        .IndexPos(IndexPos),
        .IndexWidth(IndexWidth),
        .PriorityPos(PriorityPos),
        .PriorityWidth(PriorityWidth),
        .ExitPos(ExitPos),
        .ExitWidth(ExitWidth),
        .InterNodeFIFODepth(InterNodeFIFODepth),
        .IntraNodeFIFODepth(IntraNodeFIFODepth),
        .RoutingTableWidth(RoutingTableWidth),
        .RoutingTablesize(RoutingTablesize),
        .MulticastTableWidth(MulticastTableWidth),
        .MulticastTablesize(MulticastTablesize),
        .ReductionTableWidth(ReductionTableWidth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    )YPOS(
//input
	.clk(clk), 
    .rst(rst),
	.ClockwiseIn(ClockwiseIn_xpos_ypos), 
	.CounterClockwiseIn(CounterClockwiseIn_yneg_ypos),
	.inject(inject_ypos),
	.inject_receive(inject_receive_ypos),
	.ClockwiseReceive(ClockwiseReceive_xpos_ypos),
	.CounterClockwiseReceive(CounterClockwiseReceive_yneg_ypos),
	.ClockwiseNextSlotAvail(ClockwiseNextSlotAvail_ypos_yneg),
	.CounterClockwiseNextSlotAvail(CounterClockwiseNextSlotAvail_ypos_xpos),
	.EjectSlotAvail(EjectSlotAvail_ypos),
//output
	.ClockwiseOut(ClockwiseOut_ypos_yneg),
	.CounterClockwiseOut(CounterClockwiseOut_ypos_xpos),
	.eject_send(eject_send_ypos),
	.ClockwiseSend(ClockwiseSend_ypos_yneg),
	.CounterClockwiseSend(CounterClockwiseSend_ypos_xpos),
	.ClockwiseSlotAvail(ClockwiseSlotAvail_xpos_ypos),
	.CounterClockwiseSlotAvail(CounterClockwiseSlotAvail_yneg_ypos),
	.InjectSlotAvail(InjectSlotAvail_ypos),
	.eject(eject_ypos)
    );

	
	assign ClockwiseIn_xneg_xpos=ClockwiseOut_xneg_xpos;
	assign CounterClockwiseIn_xpos_xneg=CounterClockwiseOut_xpos_xneg;
	assign CounterClockwiseReceive_xpos_xneg=CounterClockwiseSend_xpos_xneg;
	assign ClockwiseReceive_xneg_xpos=ClockwiseSend_xneg_xpos;
	assign ClockwiseNextSlotAvail_xneg_xpos=ClockwiseSlotAvail_xneg_xpos;
	assign CounterClockwiseNextSlotAvail_xpos_xneg=CounterClockwiseSlotAvail_xpos_xneg;
	
	assign ClockwiseIn_zpos_xneg=ClockwiseOut_zpos_xneg;
	assign CounterClockwiseIn_xneg_zpos=CounterClockwiseOut_xneg_zpos;
	assign CounterClockwiseReceive_xneg_zpos=CounterClockwiseSend_xneg_zpos;
	assign ClockwiseReceive_zpos_xneg=ClockwiseSend_zpos_xneg;
	assign ClockwiseNextSlotAvail_zpos_xneg=ClockwiseSlotAvail_zpos_xneg;
	assign CounterClockwiseNextSlotAvail_xneg_zpos=CounterClockwiseSlotAvail_xneg_zpos;
	
	assign ClockwiseIn_zneg_zpos=ClockwiseOut_zneg_zpos;
	assign CounterClockwiseIn_zpos_zneg=CounterClockwiseOut_zpos_zneg;
	assign CounterClockwiseReceive_zpos_zneg=CounterClockwiseSend_zpos_zneg;
	assign ClockwiseReceive_zneg_zpos=ClockwiseSend_zneg_zpos;
	assign ClockwiseNextSlotAvail_zneg_zpos=ClockwiseSlotAvail_zneg_zpos;
	assign CounterClockwiseNextSlotAvail_zpos_zneg=CounterClockwiseSlotAvail_zpos_zneg;
	
	assign ClockwiseIn_local_zneg=ClockwiseOut_local_zneg;
	assign CounterClockwiseIn_zneg_local=CounterClockwiseOut_zneg_local;
	assign CounterClockwiseReceive_zneg_local=CounterClockwiseSend_zneg_local;
	assign ClockwiseReceive_local_zneg=ClockwiseSend_local_zneg;
	assign ClockwiseNextSlotAvail_local_zneg=ClockwiseSlotAvail_local_zneg;
	assign CounterClockwiseNextSlotAvail_zneg_local=CounterClockwiseSlotAvail_zneg_local;
	
	assign ClockwiseIn_yneg_local=ClockwiseOut_yneg_local;
	assign CounterClockwiseIn_local_yneg=CounterClockwiseOut_local_yneg;
	assign CounterClockwiseReceive_local_yneg=CounterClockwiseSend_local_yneg;
	assign ClockwiseReceive_yneg_local=ClockwiseSend_yneg_local;
	assign ClockwiseNextSlotAvail_yneg_local=ClockwiseSlotAvail_yneg_local;
	assign CounterClockwiseNextSlotAvail_local_yneg=CounterClockwiseSlotAvail_local_yneg;
	
	assign ClockwiseIn_ypos_yneg=ClockwiseOut_ypos_yneg;
	assign CounterClockwiseIn_yneg_ypos=CounterClockwiseOut_yneg_ypos;
	assign CounterClockwiseReceive_yneg_ypos=CounterClockwiseSend_yneg_ypos;
	assign ClockwiseReceive_ypos_yneg=ClockwiseSend_ypos_yneg;
	assign ClockwiseNextSlotAvail_ypos_yneg=ClockwiseSlotAvail_ypos_yneg;
	assign CounterClockwiseNextSlotAvail_yneg_ypos=CounterClockwiseSlotAvail_yneg_ypos;
	
	assign ClockwiseIn_xpos_ypos=ClockwiseOut_xpos_ypos;
	assign CounterClockwiseIn_ypos_xpos=CounterClockwiseOut_ypos_xpos;
	assign CounterClockwiseReceive_ypos_xpos=CounterClockwiseSend_ypos_xpos;
	assign ClockwiseReceive_xpos_ypos=ClockwiseSend_xpos_ypos;
	assign ClockwiseNextSlotAvail_xpos_ypos=ClockwiseSlotAvail_xpos_ypos;
	assign CounterClockwiseNextSlotAvail_ypos_xpos=CounterClockwiseSlotAvail_ypos_xpos;
	
endmodule
	
	
	
	
	
