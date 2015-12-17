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
	
	input clk,rst;
	input inject_receive_xpos, EjectSlotAvail_xpos;
	input inject_receive_xneg, EjectSlotAvail_xneg;
	input inject_receive_ypos, EjectSlotAvail_ypos;
	input inject_receive_yneg, EjectSlotAvail_yneg;
	input inject_receive_zpos, EjectSlotAvail_zpos;
	input inject_receive_zneg, EjectSlotAvail_zneg;
	
	output eject_send_xpos, InjectSlotAvail_xpos;
	output eject_send_xneg, InjectSlotAvail_xneg;
	output eject_send_ypos, InjectSlotAvail_ypos;
	output eject_send_yneg, InjectSlotAvail_yneg;
	output eject_send_zpos, InjectSlotAvail_zpos;
	output eject_send_zneg, InjectSlotAvail_zneg;
	
	input [DataWidth-1:0] inject_xpos, inject_xneg;
	input [DataWidth-1:0] inject_ypos, inject_yneg;
	input [DataWidth-1:0] inject_zpos, inject_zneg;
	output [DataWidth-1:0] eject_xpos, eject_xneg;
	output [DataWidth-1:0] eject_ypos, eject_yneg;
	output [DataWidth-1:0] eject_zpos, eject_zneg;
	
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
        .CounterClockwiseUtil( xpos_CounterClockwiseUtil),
        .ClockwiseUtil( xpos_ClockwiseUtil),
        .InjectUtil(xpos_InjectUtil)
    );

//input
	clk, rst,
	ClockwiseIn_xneg_xpos, 
	CounterClockwiseIn_ypos_xpos,
	inject_xpos,
	inject_receive_xpos,
	ClockwiseReceive_xneg_xpos,
	CounterClockwiseReceive_ypos_xpos,
	ClockwiseNextSlotAvail_xpos_ypos,
	CounterClockwiseNextSlotAvail_xpos_xneg,
	EjectSlotAvail_xpos,
//output
	ClockwiseOut_xpos_ypos,
	CounterClockwiseOut_xpos_xneg,
	eject_send_xpos,
	ClockwiseSend_xpos_ypos,
	CounterClockwiseSend_xpos_xneg,
	ClockwiseSlotAvail_xneg_xpos,
	CounterClockwiseSlotAvail_ypos_xpos,
	InjectSlotAvail_xpos,
	eject_xpos);
	
/*	assign ClockwiseIn_xneg_xpos=ClockwiseOut_xneg_xpos;
	assign CounterClockwiseIn_xpos_xneg=CounterClockwiseOut_xpos_xneg;
	assign CounterClockwiseReceive_xpos_xneg=CounterClockwiseSend_xpos_xneg;
	assign ClockwiseReceive_xneg_xpos=ClockwiseSend_xneg_xpos;
	assign ClockwiseNextSlotAvail_xneg_xpos=ClockwiseSlotAvail_xneg_xpos;
	assign CounterClockwiseSlotAvail_xpos_xneg=CounterClockwiseNextSlotAvail_xpos_xneg;
*/	
	defparam XNEG.srcID=4;
	//initial $readmemh("table1.txt",XNEG.routing_table);
	router XNEG(
//input
	clk, rst,
	ClockwiseIn_zpos_xneg, 
	CounterClockwiseIn_xpos_xneg,
	inject_xneg,
	inject_receive_xneg,
	ClockwiseReceive_zpos_xneg,
	CounterClockwiseReceive_xpos_xneg,
	ClockwiseNextSlotAvail_xneg_xpos,
	CounterClockwiseNextSlotAvail_xneg_zpos,
	EjectSlotAvail_xneg,
//output
	ClockwiseOut_xneg_xpos,
	CounterClockwiseOut_xneg_zpos,
	eject_send_xneg,
	ClockwiseSend_xneg_xpos,
	CounterClockwiseSend_xneg_zpos,
	ClockwiseSlotAvail_zpos_xneg,
	CounterClockwiseSlotAvail_xpos_xneg,
	InjectSlotAvail_xneg,
	eject_xneg);
	
/*	assign ClockwiseIn_zpos_xneg=ClockwiseOut_zpos_xneg;
	assign CounterClockwiseIn_xneg_zpos=CounterClockwiseOut_xneg_zpos;
	assign CounterClockwiseReceive_xneg_zpos=CounterClockwiseSend_xneg_zpos;
	assign ClockwiseReceive_zpos_xneg=ClockwiseSend_zpos_xneg;
	assign ClockwiseNextSlotAvail_zpos_xneg=ClockwiseSlotAvail_zpos_xneg;
	assign CounterClockwiseSlotAvail_xneg_zpos=CounterClockwiseNextSlotAvail_xneg_zpos;
	*/
	defparam ZPOS.srcID=5;
	//initial $readmemh("table1.txt",ZPOS.routing_table);
	router ZPOS(
//input
	clk, rst,
	ClockwiseIn_zneg_zpos, 
	CounterClockwiseIn_xneg_zpos,
	inject_zpos,
	inject_receive_zpos,
	ClockwiseReceive_zneg_zpos,
	CounterClockwiseReceive_xneg_zpos,
	ClockwiseNextSlotAvail_zpos_xneg,
	CounterClockwiseNextSlotAvail_zpos_zneg,
	EjectSlotAvail_zpos,
//output
	ClockwiseOut_zpos_xneg,
	CounterClockwiseOut_zpos_zneg,
	eject_send_zpos,
	ClockwiseSend_zpos_xneg,
	CounterClockwiseSend_zpos_zneg,
	ClockwiseSlotAvail_zneg_zpos,
	CounterClockwiseSlotAvail_xneg_zpos,
	InjectSlotAvail_zpos,
	eject_zpos);
/*	
	assign ClockwiseIn_zneg_zpos=ClockwiseOut_zneg_zpos;
	assign CounterClockwiseIn_zpos_zneg=CounterClockwiseOut_zpos_zneg;
	assign CounterClockwiseReceive_zpos_zneg=CounterClockwiseSend_zpos_zneg;
	assign ClockwiseReceive_zneg_zpos=ClockwiseSend_zneg_zpos;
	assign ClockwiseNextSlotAvail_zneg_zpos=ClockwiseSlotAvail_zneg_zpos;
	assign CounterClockwiseSlotAvail_zpos_zneg=CounterClockwiseNextSlotAvail_zpos_zneg;
	*/
	defparam ZNEG.srcID=6;
	//initial $readmemh("table",ZNEG.routing_table);
	router ZNEG(
//input
	clk, rst,
	ClockwiseIn_local_zneg, 
	CounterClockwiseIn_zpos_zneg,
	inject_zneg,
	inject_receive_zneg,
	ClockwiseReceive_local_zneg,
	CounterClockwiseReceive_zpos_zneg,
	ClockwiseNextSlotAvail_zneg_zpos,
	CounterClockwiseNextSlotAvail_zneg_local,
	EjectSlotAvail_zneg,
//output
	ClockwiseOut_zneg_zpos,
	CounterClockwiseOut_zneg_local,
	eject_send_zneg,
	ClockwiseSend_zneg_zpos,
	CounterClockwiseSend_zneg_local,
	ClockwiseSlotAvail_local_zneg,
	CounterClockwiseSlotAvail_zpos_zneg,
	InjectSlotAvail_zneg,
	eject_zneg);
/*	
	assign ClockwiseIn_local_zneg=ClockwiseOut_local_zneg;
	assign CounterClockwiseIn_zneg_local=CounterClockwiseOut_zneg_local;
	assign CounterClockwiseReceive_zneg_local=CounterClockwiseSend_zneg_local;
	assign ClockwiseReceive_local_zneg=ClockwiseSend_local_zneg;
	assign ClockwiseNextSlotAvail_local_zneg=ClockwiseSlotAvail_local_zneg;
	assign CounterClockwiseSlotAvail_zneg_local=CounterClockwiseNextSlotAvail_zneg_local;
	*/
	defparam LOCAL.srcID=0;
	//initial $readmemh("table1.txt",LOCAL.routing_table);
	router LOCAL(
//input
	clk, rst,
	ClockwiseIn_yneg_local, 
	CounterClockwiseIn_zneg_local,
	inject_local,
	inject_receive_local,
	ClockwiseReceive_yneg_local,
	CounterClockwiseReceive_zneg_local,
	ClockwiseNextSlotAvail_local_zneg,
	CounterClockwiseNextSlotAvail_local_yneg,
	EjectSlotAvail_local,
//output
	ClockwiseOut_local_zneg,
	CounterClockwiseOut_local_yneg,
	eject_send_local,
	ClockwiseSend_local_zneg,
	CounterClockwiseSend_local_yneg,
	ClockwiseSlotAvail_yneg_local,
	CounterClockwiseSlotAvail_zneg_local,
	InjectSlotAvail_local,
	eject_local);
	
/*
	assign ClockwiseIn_yneg_local=ClockwiseOut_yneg_local;
	assign CounterClockwiseIn_local_yneg=CounterClockwiseOut_local_yneg;
	assign CounterClockwiseReceive_local_yneg=CounterClockwiseSend_local_yneg;
	assign ClockwiseReceive_yneg_local=ClockwiseSend_yneg_local;
	assign ClockwiseNextSlotAvail_yneg_local=ClockwiseSlotAvail_yneg_local;
	assign CounterClockwiseSlotAvail_local_yneg=CounterClockwiseNextSlotAvail_local_yneg;
	*/
	defparam YNEG.srcID=1;
	//initial $readmemh("table1.txt",YNEG.routing_table);
	router YNEG(
//input
	clk, rst,
	ClockwiseIn_ypos_yneg, 
	CounterClockwiseIn_local_yneg,
	inject_yneg,
	inject_receive_yneg,
	ClockwiseReceive_ypos_yneg,
	CounterClockwiseReceive_local_yneg,
	ClockwiseNextSlotAvail_yneg_local,
	CounterClockwiseNextSlotAvail_yneg_ypos,
	EjectSlotAvail_yneg,
//output
	ClockwiseOut_yneg_local,
	CounterClockwiseOut_yneg_ypos,
	eject_send_yneg,
	ClockwiseSend_yneg_local,
	CounterClockwiseSend_yneg_ypos,
	ClockwiseSlotAvail_ypos_yneg,
	CounterClockwiseSlotAvail_local_yneg,
	InjectSlotAvail_yneg,
	eject_yneg);
/*	
	assign ClockwiseIn_ypos_yneg=ClockwiseOut_ypos_yneg;
	assign CounterClockwiseIn_yneg_ypos=CounterClockwiseOut_yneg_ypos;
	assign CounterClockwiseReceive_yneg_ypos=CounterClockwiseSend_yneg_ypos;
	assign ClockwiseReceive_ypos_yneg=ClockwiseSend_ypos_yneg;
	assign ClockwiseNextSlotAvail_ypos_yneg=ClockwiseSlotAvail_ypos_yneg;
	assign CounterClockwiseSlotAvail_yneg_ypos=CounterClockwiseNextSlotAvail_yneg_ypos;
	*/
	defparam YPOS.srcID=2;
	//initial $readmemh("table1.txt",YPOS.routing_table);
	router YPOS(
//input
	clk, rst,
	ClockwiseIn_xpos_ypos, 
	CounterClockwiseIn_yneg_ypos,
	inject_ypos,
	inject_receive_ypos,
	ClockwiseReceive_xpos_ypos,
	CounterClockwiseReceive_yneg_ypos,
	ClockwiseNextSlotAvail_ypos_yneg,
	CounterClockwiseNextSlotAvail_ypos_xpos,
	EjectSlotAvail_ypos,
//output
	ClockwiseOut_ypos_yneg,
	CounterClockwiseOut_ypos_xpos,
	eject_send_ypos,
	ClockwiseSend_ypos_yneg,
	CounterClockwiseSend_ypos_xpos,
	ClockwiseSlotAvail_xpos_ypos,
	CounterClockwiseSlotAvail_yneg_ypos,
	InjectSlotAvail_ypos,
	eject_ypos);
/*
	assign ClockwiseIn_xpos_ypos=ClockwiseOut_xpos_ypos;
	assign CounterClockwiseIn_ypos_xpos=CounterClockwiseOut_ypos_xpos;
	assign CounterClockwiseReceive_ypos_xpos=CounterClockwiseSend_ypos_xpos;
	assign ClockwiseReceive_xpos_ypos=ClockwiseSend_xpos_ypos;
	assign ClockwiseNextSlotAvail_xpos_ypos=ClockwiseSlotAvail_xpos_ypos;
	assign CounterClockwiseSlotAvail_ypos_xpos=CounterClockwiseNextSlotAvail_ypos_xpos;
*/	
	
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
	
	
	
	
	
