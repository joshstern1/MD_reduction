module network#(
    parameter CoordWidth=4,
    parameter XCoordPos=243,
    parameter YCoordPos=247,
    parameter ZCoordPos=251,
    parameter PacketIDPos=227,
    parameter PacketTypePos=223,
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
    parameter PcktTypeLen=4,
    parameter profiling_freq=10
)(
    input clk,
    input rst
);
	reg[15:0] xpos_link_sum, xneg_link_sum, ypos_link_sum, yneg_link_sum, zpos_link_sum, zneg_link_sum;
	reg[15:0] xpos_ClockwiseUtil_sum, xneg_ClockwiseUtil_sum, ypos_ClockwiseUtil_sum, yneg_ClockwiseUtil_sum, zpos_ClockwiseUtil_sum, zneg_ClockwiseUtil_sum;
	reg[15:0] xpos_CounterClockwiseUtil_sum, xneg_CounterClockwiseUtil_sum, ypos_CounterClockwiseUtil_sum, yneg_CounterClockwiseUtil_sum, zpos_CounterClockwiseUtil_sum, zneg_CounterClockwiseUtil_sum;
	reg[15:0] xpos_InjectUtil_sum, xneg_InjectUtil_sum, ypos_InjectUtil_sum, yneg_InjectUtil_sum, zpos_InjectUtil_sum, zneg_InjectUtil_sum;
	reg[15:0] link_sum,Clockwise_sum,CounterClockwise_sum,Inject_sum,port_sum;
	reg[15:0] counter, time_counter;
	wire[DataWidth-1:0] inject_xpos_ser_0_0_0, eject_xpos_ser_0_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_0, eject_xneg_ser_0_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_0, eject_ypos_ser_0_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_0, eject_yneg_ser_0_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_0, eject_zpos_ser_0_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_0, eject_zneg_ser_0_0_0;
	wire[7:0] xpos_ClockwiseUtil_0_0_0,xpos_CounterClockwiseUtil_0_0_0,xpos_InjectUtil_0_0_0;
	wire[7:0] xneg_ClockwiseUtil_0_0_0,xneg_CounterClockwiseUtil_0_0_0,xneg_InjectUtil_0_0_0;
	wire[7:0] ypos_ClockwiseUtil_0_0_0,ypos_CounterClockwiseUtil_0_0_0,ypos_InjectUtil_0_0_0;
	wire[7:0] yneg_ClockwiseUtil_0_0_0,yneg_CounterClockwiseUtil_0_0_0,yneg_InjectUtil_0_0_0;
	wire[7:0] zpos_ClockwiseUtil_0_0_0,zpos_CounterClockwiseUtil_0_0_0,zpos_InjectUtil_0_0_0;
	wire[7:0] zneg_ClockwiseUtil_0_0_0,zneg_CounterClockwiseUtil_0_0_0,zneg_InjectUtil_0_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_0_1, eject_xpos_ser_0_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_1, eject_xneg_ser_0_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_1, eject_ypos_ser_0_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_1, eject_yneg_ser_0_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_1, eject_zpos_ser_0_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_1, eject_zneg_ser_0_0_1;
	wire[7:0] xpos_ClockwiseUtil_0_0_1,xpos_CounterClockwiseUtil_0_0_1,xpos_InjectUtil_0_0_1;
	wire[7:0] xneg_ClockwiseUtil_0_0_1,xneg_CounterClockwiseUtil_0_0_1,xneg_InjectUtil_0_0_1;
	wire[7:0] ypos_ClockwiseUtil_0_0_1,ypos_CounterClockwiseUtil_0_0_1,ypos_InjectUtil_0_0_1;
	wire[7:0] yneg_ClockwiseUtil_0_0_1,yneg_CounterClockwiseUtil_0_0_1,yneg_InjectUtil_0_0_1;
	wire[7:0] zpos_ClockwiseUtil_0_0_1,zpos_CounterClockwiseUtil_0_0_1,zpos_InjectUtil_0_0_1;
	wire[7:0] zneg_ClockwiseUtil_0_0_1,zneg_CounterClockwiseUtil_0_0_1,zneg_InjectUtil_0_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_0_2, eject_xpos_ser_0_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_2, eject_xneg_ser_0_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_2, eject_ypos_ser_0_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_2, eject_yneg_ser_0_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_2, eject_zpos_ser_0_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_2, eject_zneg_ser_0_0_2;
	wire[7:0] xpos_ClockwiseUtil_0_0_2,xpos_CounterClockwiseUtil_0_0_2,xpos_InjectUtil_0_0_2;
	wire[7:0] xneg_ClockwiseUtil_0_0_2,xneg_CounterClockwiseUtil_0_0_2,xneg_InjectUtil_0_0_2;
	wire[7:0] ypos_ClockwiseUtil_0_0_2,ypos_CounterClockwiseUtil_0_0_2,ypos_InjectUtil_0_0_2;
	wire[7:0] yneg_ClockwiseUtil_0_0_2,yneg_CounterClockwiseUtil_0_0_2,yneg_InjectUtil_0_0_2;
	wire[7:0] zpos_ClockwiseUtil_0_0_2,zpos_CounterClockwiseUtil_0_0_2,zpos_InjectUtil_0_0_2;
	wire[7:0] zneg_ClockwiseUtil_0_0_2,zneg_CounterClockwiseUtil_0_0_2,zneg_InjectUtil_0_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_0_3, eject_xpos_ser_0_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_3, eject_xneg_ser_0_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_3, eject_ypos_ser_0_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_3, eject_yneg_ser_0_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_3, eject_zpos_ser_0_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_3, eject_zneg_ser_0_0_3;
	wire[7:0] xpos_ClockwiseUtil_0_0_3,xpos_CounterClockwiseUtil_0_0_3,xpos_InjectUtil_0_0_3;
	wire[7:0] xneg_ClockwiseUtil_0_0_3,xneg_CounterClockwiseUtil_0_0_3,xneg_InjectUtil_0_0_3;
	wire[7:0] ypos_ClockwiseUtil_0_0_3,ypos_CounterClockwiseUtil_0_0_3,ypos_InjectUtil_0_0_3;
	wire[7:0] yneg_ClockwiseUtil_0_0_3,yneg_CounterClockwiseUtil_0_0_3,yneg_InjectUtil_0_0_3;
	wire[7:0] zpos_ClockwiseUtil_0_0_3,zpos_CounterClockwiseUtil_0_0_3,zpos_InjectUtil_0_0_3;
	wire[7:0] zneg_ClockwiseUtil_0_0_3,zneg_CounterClockwiseUtil_0_0_3,zneg_InjectUtil_0_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_0_4, eject_xpos_ser_0_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_4, eject_xneg_ser_0_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_4, eject_ypos_ser_0_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_4, eject_yneg_ser_0_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_4, eject_zpos_ser_0_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_4, eject_zneg_ser_0_0_4;
	wire[7:0] xpos_ClockwiseUtil_0_0_4,xpos_CounterClockwiseUtil_0_0_4,xpos_InjectUtil_0_0_4;
	wire[7:0] xneg_ClockwiseUtil_0_0_4,xneg_CounterClockwiseUtil_0_0_4,xneg_InjectUtil_0_0_4;
	wire[7:0] ypos_ClockwiseUtil_0_0_4,ypos_CounterClockwiseUtil_0_0_4,ypos_InjectUtil_0_0_4;
	wire[7:0] yneg_ClockwiseUtil_0_0_4,yneg_CounterClockwiseUtil_0_0_4,yneg_InjectUtil_0_0_4;
	wire[7:0] zpos_ClockwiseUtil_0_0_4,zpos_CounterClockwiseUtil_0_0_4,zpos_InjectUtil_0_0_4;
	wire[7:0] zneg_ClockwiseUtil_0_0_4,zneg_CounterClockwiseUtil_0_0_4,zneg_InjectUtil_0_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_0_5, eject_xpos_ser_0_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_5, eject_xneg_ser_0_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_5, eject_ypos_ser_0_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_5, eject_yneg_ser_0_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_5, eject_zpos_ser_0_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_5, eject_zneg_ser_0_0_5;
	wire[7:0] xpos_ClockwiseUtil_0_0_5,xpos_CounterClockwiseUtil_0_0_5,xpos_InjectUtil_0_0_5;
	wire[7:0] xneg_ClockwiseUtil_0_0_5,xneg_CounterClockwiseUtil_0_0_5,xneg_InjectUtil_0_0_5;
	wire[7:0] ypos_ClockwiseUtil_0_0_5,ypos_CounterClockwiseUtil_0_0_5,ypos_InjectUtil_0_0_5;
	wire[7:0] yneg_ClockwiseUtil_0_0_5,yneg_CounterClockwiseUtil_0_0_5,yneg_InjectUtil_0_0_5;
	wire[7:0] zpos_ClockwiseUtil_0_0_5,zpos_CounterClockwiseUtil_0_0_5,zpos_InjectUtil_0_0_5;
	wire[7:0] zneg_ClockwiseUtil_0_0_5,zneg_CounterClockwiseUtil_0_0_5,zneg_InjectUtil_0_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_0_6, eject_xpos_ser_0_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_6, eject_xneg_ser_0_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_6, eject_ypos_ser_0_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_6, eject_yneg_ser_0_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_6, eject_zpos_ser_0_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_6, eject_zneg_ser_0_0_6;
	wire[7:0] xpos_ClockwiseUtil_0_0_6,xpos_CounterClockwiseUtil_0_0_6,xpos_InjectUtil_0_0_6;
	wire[7:0] xneg_ClockwiseUtil_0_0_6,xneg_CounterClockwiseUtil_0_0_6,xneg_InjectUtil_0_0_6;
	wire[7:0] ypos_ClockwiseUtil_0_0_6,ypos_CounterClockwiseUtil_0_0_6,ypos_InjectUtil_0_0_6;
	wire[7:0] yneg_ClockwiseUtil_0_0_6,yneg_CounterClockwiseUtil_0_0_6,yneg_InjectUtil_0_0_6;
	wire[7:0] zpos_ClockwiseUtil_0_0_6,zpos_CounterClockwiseUtil_0_0_6,zpos_InjectUtil_0_0_6;
	wire[7:0] zneg_ClockwiseUtil_0_0_6,zneg_CounterClockwiseUtil_0_0_6,zneg_InjectUtil_0_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_0_7, eject_xpos_ser_0_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_0_7, eject_xneg_ser_0_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_0_7, eject_ypos_ser_0_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_0_7, eject_yneg_ser_0_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_0_7, eject_zpos_ser_0_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_0_7, eject_zneg_ser_0_0_7;
	wire[7:0] xpos_ClockwiseUtil_0_0_7,xpos_CounterClockwiseUtil_0_0_7,xpos_InjectUtil_0_0_7;
	wire[7:0] xneg_ClockwiseUtil_0_0_7,xneg_CounterClockwiseUtil_0_0_7,xneg_InjectUtil_0_0_7;
	wire[7:0] ypos_ClockwiseUtil_0_0_7,ypos_CounterClockwiseUtil_0_0_7,ypos_InjectUtil_0_0_7;
	wire[7:0] yneg_ClockwiseUtil_0_0_7,yneg_CounterClockwiseUtil_0_0_7,yneg_InjectUtil_0_0_7;
	wire[7:0] zpos_ClockwiseUtil_0_0_7,zpos_CounterClockwiseUtil_0_0_7,zpos_InjectUtil_0_0_7;
	wire[7:0] zneg_ClockwiseUtil_0_0_7,zneg_CounterClockwiseUtil_0_0_7,zneg_InjectUtil_0_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_0, eject_xpos_ser_0_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_0, eject_xneg_ser_0_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_0, eject_ypos_ser_0_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_0, eject_yneg_ser_0_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_0, eject_zpos_ser_0_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_0, eject_zneg_ser_0_1_0;
	wire[7:0] xpos_ClockwiseUtil_0_1_0,xpos_CounterClockwiseUtil_0_1_0,xpos_InjectUtil_0_1_0;
	wire[7:0] xneg_ClockwiseUtil_0_1_0,xneg_CounterClockwiseUtil_0_1_0,xneg_InjectUtil_0_1_0;
	wire[7:0] ypos_ClockwiseUtil_0_1_0,ypos_CounterClockwiseUtil_0_1_0,ypos_InjectUtil_0_1_0;
	wire[7:0] yneg_ClockwiseUtil_0_1_0,yneg_CounterClockwiseUtil_0_1_0,yneg_InjectUtil_0_1_0;
	wire[7:0] zpos_ClockwiseUtil_0_1_0,zpos_CounterClockwiseUtil_0_1_0,zpos_InjectUtil_0_1_0;
	wire[7:0] zneg_ClockwiseUtil_0_1_0,zneg_CounterClockwiseUtil_0_1_0,zneg_InjectUtil_0_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_1, eject_xpos_ser_0_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_1, eject_xneg_ser_0_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_1, eject_ypos_ser_0_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_1, eject_yneg_ser_0_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_1, eject_zpos_ser_0_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_1, eject_zneg_ser_0_1_1;
	wire[7:0] xpos_ClockwiseUtil_0_1_1,xpos_CounterClockwiseUtil_0_1_1,xpos_InjectUtil_0_1_1;
	wire[7:0] xneg_ClockwiseUtil_0_1_1,xneg_CounterClockwiseUtil_0_1_1,xneg_InjectUtil_0_1_1;
	wire[7:0] ypos_ClockwiseUtil_0_1_1,ypos_CounterClockwiseUtil_0_1_1,ypos_InjectUtil_0_1_1;
	wire[7:0] yneg_ClockwiseUtil_0_1_1,yneg_CounterClockwiseUtil_0_1_1,yneg_InjectUtil_0_1_1;
	wire[7:0] zpos_ClockwiseUtil_0_1_1,zpos_CounterClockwiseUtil_0_1_1,zpos_InjectUtil_0_1_1;
	wire[7:0] zneg_ClockwiseUtil_0_1_1,zneg_CounterClockwiseUtil_0_1_1,zneg_InjectUtil_0_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_2, eject_xpos_ser_0_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_2, eject_xneg_ser_0_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_2, eject_ypos_ser_0_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_2, eject_yneg_ser_0_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_2, eject_zpos_ser_0_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_2, eject_zneg_ser_0_1_2;
	wire[7:0] xpos_ClockwiseUtil_0_1_2,xpos_CounterClockwiseUtil_0_1_2,xpos_InjectUtil_0_1_2;
	wire[7:0] xneg_ClockwiseUtil_0_1_2,xneg_CounterClockwiseUtil_0_1_2,xneg_InjectUtil_0_1_2;
	wire[7:0] ypos_ClockwiseUtil_0_1_2,ypos_CounterClockwiseUtil_0_1_2,ypos_InjectUtil_0_1_2;
	wire[7:0] yneg_ClockwiseUtil_0_1_2,yneg_CounterClockwiseUtil_0_1_2,yneg_InjectUtil_0_1_2;
	wire[7:0] zpos_ClockwiseUtil_0_1_2,zpos_CounterClockwiseUtil_0_1_2,zpos_InjectUtil_0_1_2;
	wire[7:0] zneg_ClockwiseUtil_0_1_2,zneg_CounterClockwiseUtil_0_1_2,zneg_InjectUtil_0_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_3, eject_xpos_ser_0_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_3, eject_xneg_ser_0_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_3, eject_ypos_ser_0_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_3, eject_yneg_ser_0_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_3, eject_zpos_ser_0_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_3, eject_zneg_ser_0_1_3;
	wire[7:0] xpos_ClockwiseUtil_0_1_3,xpos_CounterClockwiseUtil_0_1_3,xpos_InjectUtil_0_1_3;
	wire[7:0] xneg_ClockwiseUtil_0_1_3,xneg_CounterClockwiseUtil_0_1_3,xneg_InjectUtil_0_1_3;
	wire[7:0] ypos_ClockwiseUtil_0_1_3,ypos_CounterClockwiseUtil_0_1_3,ypos_InjectUtil_0_1_3;
	wire[7:0] yneg_ClockwiseUtil_0_1_3,yneg_CounterClockwiseUtil_0_1_3,yneg_InjectUtil_0_1_3;
	wire[7:0] zpos_ClockwiseUtil_0_1_3,zpos_CounterClockwiseUtil_0_1_3,zpos_InjectUtil_0_1_3;
	wire[7:0] zneg_ClockwiseUtil_0_1_3,zneg_CounterClockwiseUtil_0_1_3,zneg_InjectUtil_0_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_4, eject_xpos_ser_0_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_4, eject_xneg_ser_0_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_4, eject_ypos_ser_0_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_4, eject_yneg_ser_0_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_4, eject_zpos_ser_0_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_4, eject_zneg_ser_0_1_4;
	wire[7:0] xpos_ClockwiseUtil_0_1_4,xpos_CounterClockwiseUtil_0_1_4,xpos_InjectUtil_0_1_4;
	wire[7:0] xneg_ClockwiseUtil_0_1_4,xneg_CounterClockwiseUtil_0_1_4,xneg_InjectUtil_0_1_4;
	wire[7:0] ypos_ClockwiseUtil_0_1_4,ypos_CounterClockwiseUtil_0_1_4,ypos_InjectUtil_0_1_4;
	wire[7:0] yneg_ClockwiseUtil_0_1_4,yneg_CounterClockwiseUtil_0_1_4,yneg_InjectUtil_0_1_4;
	wire[7:0] zpos_ClockwiseUtil_0_1_4,zpos_CounterClockwiseUtil_0_1_4,zpos_InjectUtil_0_1_4;
	wire[7:0] zneg_ClockwiseUtil_0_1_4,zneg_CounterClockwiseUtil_0_1_4,zneg_InjectUtil_0_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_5, eject_xpos_ser_0_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_5, eject_xneg_ser_0_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_5, eject_ypos_ser_0_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_5, eject_yneg_ser_0_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_5, eject_zpos_ser_0_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_5, eject_zneg_ser_0_1_5;
	wire[7:0] xpos_ClockwiseUtil_0_1_5,xpos_CounterClockwiseUtil_0_1_5,xpos_InjectUtil_0_1_5;
	wire[7:0] xneg_ClockwiseUtil_0_1_5,xneg_CounterClockwiseUtil_0_1_5,xneg_InjectUtil_0_1_5;
	wire[7:0] ypos_ClockwiseUtil_0_1_5,ypos_CounterClockwiseUtil_0_1_5,ypos_InjectUtil_0_1_5;
	wire[7:0] yneg_ClockwiseUtil_0_1_5,yneg_CounterClockwiseUtil_0_1_5,yneg_InjectUtil_0_1_5;
	wire[7:0] zpos_ClockwiseUtil_0_1_5,zpos_CounterClockwiseUtil_0_1_5,zpos_InjectUtil_0_1_5;
	wire[7:0] zneg_ClockwiseUtil_0_1_5,zneg_CounterClockwiseUtil_0_1_5,zneg_InjectUtil_0_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_6, eject_xpos_ser_0_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_6, eject_xneg_ser_0_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_6, eject_ypos_ser_0_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_6, eject_yneg_ser_0_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_6, eject_zpos_ser_0_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_6, eject_zneg_ser_0_1_6;
	wire[7:0] xpos_ClockwiseUtil_0_1_6,xpos_CounterClockwiseUtil_0_1_6,xpos_InjectUtil_0_1_6;
	wire[7:0] xneg_ClockwiseUtil_0_1_6,xneg_CounterClockwiseUtil_0_1_6,xneg_InjectUtil_0_1_6;
	wire[7:0] ypos_ClockwiseUtil_0_1_6,ypos_CounterClockwiseUtil_0_1_6,ypos_InjectUtil_0_1_6;
	wire[7:0] yneg_ClockwiseUtil_0_1_6,yneg_CounterClockwiseUtil_0_1_6,yneg_InjectUtil_0_1_6;
	wire[7:0] zpos_ClockwiseUtil_0_1_6,zpos_CounterClockwiseUtil_0_1_6,zpos_InjectUtil_0_1_6;
	wire[7:0] zneg_ClockwiseUtil_0_1_6,zneg_CounterClockwiseUtil_0_1_6,zneg_InjectUtil_0_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_1_7, eject_xpos_ser_0_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_1_7, eject_xneg_ser_0_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_1_7, eject_ypos_ser_0_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_1_7, eject_yneg_ser_0_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_1_7, eject_zpos_ser_0_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_1_7, eject_zneg_ser_0_1_7;
	wire[7:0] xpos_ClockwiseUtil_0_1_7,xpos_CounterClockwiseUtil_0_1_7,xpos_InjectUtil_0_1_7;
	wire[7:0] xneg_ClockwiseUtil_0_1_7,xneg_CounterClockwiseUtil_0_1_7,xneg_InjectUtil_0_1_7;
	wire[7:0] ypos_ClockwiseUtil_0_1_7,ypos_CounterClockwiseUtil_0_1_7,ypos_InjectUtil_0_1_7;
	wire[7:0] yneg_ClockwiseUtil_0_1_7,yneg_CounterClockwiseUtil_0_1_7,yneg_InjectUtil_0_1_7;
	wire[7:0] zpos_ClockwiseUtil_0_1_7,zpos_CounterClockwiseUtil_0_1_7,zpos_InjectUtil_0_1_7;
	wire[7:0] zneg_ClockwiseUtil_0_1_7,zneg_CounterClockwiseUtil_0_1_7,zneg_InjectUtil_0_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_0, eject_xpos_ser_0_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_0, eject_xneg_ser_0_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_0, eject_ypos_ser_0_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_0, eject_yneg_ser_0_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_0, eject_zpos_ser_0_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_0, eject_zneg_ser_0_2_0;
	wire[7:0] xpos_ClockwiseUtil_0_2_0,xpos_CounterClockwiseUtil_0_2_0,xpos_InjectUtil_0_2_0;
	wire[7:0] xneg_ClockwiseUtil_0_2_0,xneg_CounterClockwiseUtil_0_2_0,xneg_InjectUtil_0_2_0;
	wire[7:0] ypos_ClockwiseUtil_0_2_0,ypos_CounterClockwiseUtil_0_2_0,ypos_InjectUtil_0_2_0;
	wire[7:0] yneg_ClockwiseUtil_0_2_0,yneg_CounterClockwiseUtil_0_2_0,yneg_InjectUtil_0_2_0;
	wire[7:0] zpos_ClockwiseUtil_0_2_0,zpos_CounterClockwiseUtil_0_2_0,zpos_InjectUtil_0_2_0;
	wire[7:0] zneg_ClockwiseUtil_0_2_0,zneg_CounterClockwiseUtil_0_2_0,zneg_InjectUtil_0_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_1, eject_xpos_ser_0_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_1, eject_xneg_ser_0_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_1, eject_ypos_ser_0_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_1, eject_yneg_ser_0_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_1, eject_zpos_ser_0_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_1, eject_zneg_ser_0_2_1;
	wire[7:0] xpos_ClockwiseUtil_0_2_1,xpos_CounterClockwiseUtil_0_2_1,xpos_InjectUtil_0_2_1;
	wire[7:0] xneg_ClockwiseUtil_0_2_1,xneg_CounterClockwiseUtil_0_2_1,xneg_InjectUtil_0_2_1;
	wire[7:0] ypos_ClockwiseUtil_0_2_1,ypos_CounterClockwiseUtil_0_2_1,ypos_InjectUtil_0_2_1;
	wire[7:0] yneg_ClockwiseUtil_0_2_1,yneg_CounterClockwiseUtil_0_2_1,yneg_InjectUtil_0_2_1;
	wire[7:0] zpos_ClockwiseUtil_0_2_1,zpos_CounterClockwiseUtil_0_2_1,zpos_InjectUtil_0_2_1;
	wire[7:0] zneg_ClockwiseUtil_0_2_1,zneg_CounterClockwiseUtil_0_2_1,zneg_InjectUtil_0_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_2, eject_xpos_ser_0_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_2, eject_xneg_ser_0_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_2, eject_ypos_ser_0_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_2, eject_yneg_ser_0_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_2, eject_zpos_ser_0_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_2, eject_zneg_ser_0_2_2;
	wire[7:0] xpos_ClockwiseUtil_0_2_2,xpos_CounterClockwiseUtil_0_2_2,xpos_InjectUtil_0_2_2;
	wire[7:0] xneg_ClockwiseUtil_0_2_2,xneg_CounterClockwiseUtil_0_2_2,xneg_InjectUtil_0_2_2;
	wire[7:0] ypos_ClockwiseUtil_0_2_2,ypos_CounterClockwiseUtil_0_2_2,ypos_InjectUtil_0_2_2;
	wire[7:0] yneg_ClockwiseUtil_0_2_2,yneg_CounterClockwiseUtil_0_2_2,yneg_InjectUtil_0_2_2;
	wire[7:0] zpos_ClockwiseUtil_0_2_2,zpos_CounterClockwiseUtil_0_2_2,zpos_InjectUtil_0_2_2;
	wire[7:0] zneg_ClockwiseUtil_0_2_2,zneg_CounterClockwiseUtil_0_2_2,zneg_InjectUtil_0_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_3, eject_xpos_ser_0_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_3, eject_xneg_ser_0_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_3, eject_ypos_ser_0_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_3, eject_yneg_ser_0_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_3, eject_zpos_ser_0_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_3, eject_zneg_ser_0_2_3;
	wire[7:0] xpos_ClockwiseUtil_0_2_3,xpos_CounterClockwiseUtil_0_2_3,xpos_InjectUtil_0_2_3;
	wire[7:0] xneg_ClockwiseUtil_0_2_3,xneg_CounterClockwiseUtil_0_2_3,xneg_InjectUtil_0_2_3;
	wire[7:0] ypos_ClockwiseUtil_0_2_3,ypos_CounterClockwiseUtil_0_2_3,ypos_InjectUtil_0_2_3;
	wire[7:0] yneg_ClockwiseUtil_0_2_3,yneg_CounterClockwiseUtil_0_2_3,yneg_InjectUtil_0_2_3;
	wire[7:0] zpos_ClockwiseUtil_0_2_3,zpos_CounterClockwiseUtil_0_2_3,zpos_InjectUtil_0_2_3;
	wire[7:0] zneg_ClockwiseUtil_0_2_3,zneg_CounterClockwiseUtil_0_2_3,zneg_InjectUtil_0_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_4, eject_xpos_ser_0_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_4, eject_xneg_ser_0_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_4, eject_ypos_ser_0_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_4, eject_yneg_ser_0_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_4, eject_zpos_ser_0_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_4, eject_zneg_ser_0_2_4;
	wire[7:0] xpos_ClockwiseUtil_0_2_4,xpos_CounterClockwiseUtil_0_2_4,xpos_InjectUtil_0_2_4;
	wire[7:0] xneg_ClockwiseUtil_0_2_4,xneg_CounterClockwiseUtil_0_2_4,xneg_InjectUtil_0_2_4;
	wire[7:0] ypos_ClockwiseUtil_0_2_4,ypos_CounterClockwiseUtil_0_2_4,ypos_InjectUtil_0_2_4;
	wire[7:0] yneg_ClockwiseUtil_0_2_4,yneg_CounterClockwiseUtil_0_2_4,yneg_InjectUtil_0_2_4;
	wire[7:0] zpos_ClockwiseUtil_0_2_4,zpos_CounterClockwiseUtil_0_2_4,zpos_InjectUtil_0_2_4;
	wire[7:0] zneg_ClockwiseUtil_0_2_4,zneg_CounterClockwiseUtil_0_2_4,zneg_InjectUtil_0_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_5, eject_xpos_ser_0_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_5, eject_xneg_ser_0_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_5, eject_ypos_ser_0_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_5, eject_yneg_ser_0_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_5, eject_zpos_ser_0_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_5, eject_zneg_ser_0_2_5;
	wire[7:0] xpos_ClockwiseUtil_0_2_5,xpos_CounterClockwiseUtil_0_2_5,xpos_InjectUtil_0_2_5;
	wire[7:0] xneg_ClockwiseUtil_0_2_5,xneg_CounterClockwiseUtil_0_2_5,xneg_InjectUtil_0_2_5;
	wire[7:0] ypos_ClockwiseUtil_0_2_5,ypos_CounterClockwiseUtil_0_2_5,ypos_InjectUtil_0_2_5;
	wire[7:0] yneg_ClockwiseUtil_0_2_5,yneg_CounterClockwiseUtil_0_2_5,yneg_InjectUtil_0_2_5;
	wire[7:0] zpos_ClockwiseUtil_0_2_5,zpos_CounterClockwiseUtil_0_2_5,zpos_InjectUtil_0_2_5;
	wire[7:0] zneg_ClockwiseUtil_0_2_5,zneg_CounterClockwiseUtil_0_2_5,zneg_InjectUtil_0_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_6, eject_xpos_ser_0_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_6, eject_xneg_ser_0_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_6, eject_ypos_ser_0_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_6, eject_yneg_ser_0_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_6, eject_zpos_ser_0_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_6, eject_zneg_ser_0_2_6;
	wire[7:0] xpos_ClockwiseUtil_0_2_6,xpos_CounterClockwiseUtil_0_2_6,xpos_InjectUtil_0_2_6;
	wire[7:0] xneg_ClockwiseUtil_0_2_6,xneg_CounterClockwiseUtil_0_2_6,xneg_InjectUtil_0_2_6;
	wire[7:0] ypos_ClockwiseUtil_0_2_6,ypos_CounterClockwiseUtil_0_2_6,ypos_InjectUtil_0_2_6;
	wire[7:0] yneg_ClockwiseUtil_0_2_6,yneg_CounterClockwiseUtil_0_2_6,yneg_InjectUtil_0_2_6;
	wire[7:0] zpos_ClockwiseUtil_0_2_6,zpos_CounterClockwiseUtil_0_2_6,zpos_InjectUtil_0_2_6;
	wire[7:0] zneg_ClockwiseUtil_0_2_6,zneg_CounterClockwiseUtil_0_2_6,zneg_InjectUtil_0_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_2_7, eject_xpos_ser_0_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_2_7, eject_xneg_ser_0_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_2_7, eject_ypos_ser_0_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_2_7, eject_yneg_ser_0_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_2_7, eject_zpos_ser_0_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_2_7, eject_zneg_ser_0_2_7;
	wire[7:0] xpos_ClockwiseUtil_0_2_7,xpos_CounterClockwiseUtil_0_2_7,xpos_InjectUtil_0_2_7;
	wire[7:0] xneg_ClockwiseUtil_0_2_7,xneg_CounterClockwiseUtil_0_2_7,xneg_InjectUtil_0_2_7;
	wire[7:0] ypos_ClockwiseUtil_0_2_7,ypos_CounterClockwiseUtil_0_2_7,ypos_InjectUtil_0_2_7;
	wire[7:0] yneg_ClockwiseUtil_0_2_7,yneg_CounterClockwiseUtil_0_2_7,yneg_InjectUtil_0_2_7;
	wire[7:0] zpos_ClockwiseUtil_0_2_7,zpos_CounterClockwiseUtil_0_2_7,zpos_InjectUtil_0_2_7;
	wire[7:0] zneg_ClockwiseUtil_0_2_7,zneg_CounterClockwiseUtil_0_2_7,zneg_InjectUtil_0_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_0, eject_xpos_ser_0_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_0, eject_xneg_ser_0_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_0, eject_ypos_ser_0_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_0, eject_yneg_ser_0_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_0, eject_zpos_ser_0_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_0, eject_zneg_ser_0_3_0;
	wire[7:0] xpos_ClockwiseUtil_0_3_0,xpos_CounterClockwiseUtil_0_3_0,xpos_InjectUtil_0_3_0;
	wire[7:0] xneg_ClockwiseUtil_0_3_0,xneg_CounterClockwiseUtil_0_3_0,xneg_InjectUtil_0_3_0;
	wire[7:0] ypos_ClockwiseUtil_0_3_0,ypos_CounterClockwiseUtil_0_3_0,ypos_InjectUtil_0_3_0;
	wire[7:0] yneg_ClockwiseUtil_0_3_0,yneg_CounterClockwiseUtil_0_3_0,yneg_InjectUtil_0_3_0;
	wire[7:0] zpos_ClockwiseUtil_0_3_0,zpos_CounterClockwiseUtil_0_3_0,zpos_InjectUtil_0_3_0;
	wire[7:0] zneg_ClockwiseUtil_0_3_0,zneg_CounterClockwiseUtil_0_3_0,zneg_InjectUtil_0_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_1, eject_xpos_ser_0_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_1, eject_xneg_ser_0_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_1, eject_ypos_ser_0_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_1, eject_yneg_ser_0_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_1, eject_zpos_ser_0_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_1, eject_zneg_ser_0_3_1;
	wire[7:0] xpos_ClockwiseUtil_0_3_1,xpos_CounterClockwiseUtil_0_3_1,xpos_InjectUtil_0_3_1;
	wire[7:0] xneg_ClockwiseUtil_0_3_1,xneg_CounterClockwiseUtil_0_3_1,xneg_InjectUtil_0_3_1;
	wire[7:0] ypos_ClockwiseUtil_0_3_1,ypos_CounterClockwiseUtil_0_3_1,ypos_InjectUtil_0_3_1;
	wire[7:0] yneg_ClockwiseUtil_0_3_1,yneg_CounterClockwiseUtil_0_3_1,yneg_InjectUtil_0_3_1;
	wire[7:0] zpos_ClockwiseUtil_0_3_1,zpos_CounterClockwiseUtil_0_3_1,zpos_InjectUtil_0_3_1;
	wire[7:0] zneg_ClockwiseUtil_0_3_1,zneg_CounterClockwiseUtil_0_3_1,zneg_InjectUtil_0_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_2, eject_xpos_ser_0_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_2, eject_xneg_ser_0_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_2, eject_ypos_ser_0_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_2, eject_yneg_ser_0_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_2, eject_zpos_ser_0_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_2, eject_zneg_ser_0_3_2;
	wire[7:0] xpos_ClockwiseUtil_0_3_2,xpos_CounterClockwiseUtil_0_3_2,xpos_InjectUtil_0_3_2;
	wire[7:0] xneg_ClockwiseUtil_0_3_2,xneg_CounterClockwiseUtil_0_3_2,xneg_InjectUtil_0_3_2;
	wire[7:0] ypos_ClockwiseUtil_0_3_2,ypos_CounterClockwiseUtil_0_3_2,ypos_InjectUtil_0_3_2;
	wire[7:0] yneg_ClockwiseUtil_0_3_2,yneg_CounterClockwiseUtil_0_3_2,yneg_InjectUtil_0_3_2;
	wire[7:0] zpos_ClockwiseUtil_0_3_2,zpos_CounterClockwiseUtil_0_3_2,zpos_InjectUtil_0_3_2;
	wire[7:0] zneg_ClockwiseUtil_0_3_2,zneg_CounterClockwiseUtil_0_3_2,zneg_InjectUtil_0_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_3, eject_xpos_ser_0_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_3, eject_xneg_ser_0_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_3, eject_ypos_ser_0_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_3, eject_yneg_ser_0_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_3, eject_zpos_ser_0_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_3, eject_zneg_ser_0_3_3;
	wire[7:0] xpos_ClockwiseUtil_0_3_3,xpos_CounterClockwiseUtil_0_3_3,xpos_InjectUtil_0_3_3;
	wire[7:0] xneg_ClockwiseUtil_0_3_3,xneg_CounterClockwiseUtil_0_3_3,xneg_InjectUtil_0_3_3;
	wire[7:0] ypos_ClockwiseUtil_0_3_3,ypos_CounterClockwiseUtil_0_3_3,ypos_InjectUtil_0_3_3;
	wire[7:0] yneg_ClockwiseUtil_0_3_3,yneg_CounterClockwiseUtil_0_3_3,yneg_InjectUtil_0_3_3;
	wire[7:0] zpos_ClockwiseUtil_0_3_3,zpos_CounterClockwiseUtil_0_3_3,zpos_InjectUtil_0_3_3;
	wire[7:0] zneg_ClockwiseUtil_0_3_3,zneg_CounterClockwiseUtil_0_3_3,zneg_InjectUtil_0_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_4, eject_xpos_ser_0_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_4, eject_xneg_ser_0_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_4, eject_ypos_ser_0_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_4, eject_yneg_ser_0_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_4, eject_zpos_ser_0_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_4, eject_zneg_ser_0_3_4;
	wire[7:0] xpos_ClockwiseUtil_0_3_4,xpos_CounterClockwiseUtil_0_3_4,xpos_InjectUtil_0_3_4;
	wire[7:0] xneg_ClockwiseUtil_0_3_4,xneg_CounterClockwiseUtil_0_3_4,xneg_InjectUtil_0_3_4;
	wire[7:0] ypos_ClockwiseUtil_0_3_4,ypos_CounterClockwiseUtil_0_3_4,ypos_InjectUtil_0_3_4;
	wire[7:0] yneg_ClockwiseUtil_0_3_4,yneg_CounterClockwiseUtil_0_3_4,yneg_InjectUtil_0_3_4;
	wire[7:0] zpos_ClockwiseUtil_0_3_4,zpos_CounterClockwiseUtil_0_3_4,zpos_InjectUtil_0_3_4;
	wire[7:0] zneg_ClockwiseUtil_0_3_4,zneg_CounterClockwiseUtil_0_3_4,zneg_InjectUtil_0_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_5, eject_xpos_ser_0_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_5, eject_xneg_ser_0_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_5, eject_ypos_ser_0_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_5, eject_yneg_ser_0_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_5, eject_zpos_ser_0_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_5, eject_zneg_ser_0_3_5;
	wire[7:0] xpos_ClockwiseUtil_0_3_5,xpos_CounterClockwiseUtil_0_3_5,xpos_InjectUtil_0_3_5;
	wire[7:0] xneg_ClockwiseUtil_0_3_5,xneg_CounterClockwiseUtil_0_3_5,xneg_InjectUtil_0_3_5;
	wire[7:0] ypos_ClockwiseUtil_0_3_5,ypos_CounterClockwiseUtil_0_3_5,ypos_InjectUtil_0_3_5;
	wire[7:0] yneg_ClockwiseUtil_0_3_5,yneg_CounterClockwiseUtil_0_3_5,yneg_InjectUtil_0_3_5;
	wire[7:0] zpos_ClockwiseUtil_0_3_5,zpos_CounterClockwiseUtil_0_3_5,zpos_InjectUtil_0_3_5;
	wire[7:0] zneg_ClockwiseUtil_0_3_5,zneg_CounterClockwiseUtil_0_3_5,zneg_InjectUtil_0_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_6, eject_xpos_ser_0_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_6, eject_xneg_ser_0_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_6, eject_ypos_ser_0_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_6, eject_yneg_ser_0_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_6, eject_zpos_ser_0_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_6, eject_zneg_ser_0_3_6;
	wire[7:0] xpos_ClockwiseUtil_0_3_6,xpos_CounterClockwiseUtil_0_3_6,xpos_InjectUtil_0_3_6;
	wire[7:0] xneg_ClockwiseUtil_0_3_6,xneg_CounterClockwiseUtil_0_3_6,xneg_InjectUtil_0_3_6;
	wire[7:0] ypos_ClockwiseUtil_0_3_6,ypos_CounterClockwiseUtil_0_3_6,ypos_InjectUtil_0_3_6;
	wire[7:0] yneg_ClockwiseUtil_0_3_6,yneg_CounterClockwiseUtil_0_3_6,yneg_InjectUtil_0_3_6;
	wire[7:0] zpos_ClockwiseUtil_0_3_6,zpos_CounterClockwiseUtil_0_3_6,zpos_InjectUtil_0_3_6;
	wire[7:0] zneg_ClockwiseUtil_0_3_6,zneg_CounterClockwiseUtil_0_3_6,zneg_InjectUtil_0_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_3_7, eject_xpos_ser_0_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_3_7, eject_xneg_ser_0_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_3_7, eject_ypos_ser_0_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_3_7, eject_yneg_ser_0_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_3_7, eject_zpos_ser_0_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_3_7, eject_zneg_ser_0_3_7;
	wire[7:0] xpos_ClockwiseUtil_0_3_7,xpos_CounterClockwiseUtil_0_3_7,xpos_InjectUtil_0_3_7;
	wire[7:0] xneg_ClockwiseUtil_0_3_7,xneg_CounterClockwiseUtil_0_3_7,xneg_InjectUtil_0_3_7;
	wire[7:0] ypos_ClockwiseUtil_0_3_7,ypos_CounterClockwiseUtil_0_3_7,ypos_InjectUtil_0_3_7;
	wire[7:0] yneg_ClockwiseUtil_0_3_7,yneg_CounterClockwiseUtil_0_3_7,yneg_InjectUtil_0_3_7;
	wire[7:0] zpos_ClockwiseUtil_0_3_7,zpos_CounterClockwiseUtil_0_3_7,zpos_InjectUtil_0_3_7;
	wire[7:0] zneg_ClockwiseUtil_0_3_7,zneg_CounterClockwiseUtil_0_3_7,zneg_InjectUtil_0_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_0, eject_xpos_ser_0_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_0, eject_xneg_ser_0_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_0, eject_ypos_ser_0_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_0, eject_yneg_ser_0_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_0, eject_zpos_ser_0_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_0, eject_zneg_ser_0_4_0;
	wire[7:0] xpos_ClockwiseUtil_0_4_0,xpos_CounterClockwiseUtil_0_4_0,xpos_InjectUtil_0_4_0;
	wire[7:0] xneg_ClockwiseUtil_0_4_0,xneg_CounterClockwiseUtil_0_4_0,xneg_InjectUtil_0_4_0;
	wire[7:0] ypos_ClockwiseUtil_0_4_0,ypos_CounterClockwiseUtil_0_4_0,ypos_InjectUtil_0_4_0;
	wire[7:0] yneg_ClockwiseUtil_0_4_0,yneg_CounterClockwiseUtil_0_4_0,yneg_InjectUtil_0_4_0;
	wire[7:0] zpos_ClockwiseUtil_0_4_0,zpos_CounterClockwiseUtil_0_4_0,zpos_InjectUtil_0_4_0;
	wire[7:0] zneg_ClockwiseUtil_0_4_0,zneg_CounterClockwiseUtil_0_4_0,zneg_InjectUtil_0_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_1, eject_xpos_ser_0_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_1, eject_xneg_ser_0_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_1, eject_ypos_ser_0_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_1, eject_yneg_ser_0_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_1, eject_zpos_ser_0_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_1, eject_zneg_ser_0_4_1;
	wire[7:0] xpos_ClockwiseUtil_0_4_1,xpos_CounterClockwiseUtil_0_4_1,xpos_InjectUtil_0_4_1;
	wire[7:0] xneg_ClockwiseUtil_0_4_1,xneg_CounterClockwiseUtil_0_4_1,xneg_InjectUtil_0_4_1;
	wire[7:0] ypos_ClockwiseUtil_0_4_1,ypos_CounterClockwiseUtil_0_4_1,ypos_InjectUtil_0_4_1;
	wire[7:0] yneg_ClockwiseUtil_0_4_1,yneg_CounterClockwiseUtil_0_4_1,yneg_InjectUtil_0_4_1;
	wire[7:0] zpos_ClockwiseUtil_0_4_1,zpos_CounterClockwiseUtil_0_4_1,zpos_InjectUtil_0_4_1;
	wire[7:0] zneg_ClockwiseUtil_0_4_1,zneg_CounterClockwiseUtil_0_4_1,zneg_InjectUtil_0_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_2, eject_xpos_ser_0_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_2, eject_xneg_ser_0_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_2, eject_ypos_ser_0_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_2, eject_yneg_ser_0_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_2, eject_zpos_ser_0_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_2, eject_zneg_ser_0_4_2;
	wire[7:0] xpos_ClockwiseUtil_0_4_2,xpos_CounterClockwiseUtil_0_4_2,xpos_InjectUtil_0_4_2;
	wire[7:0] xneg_ClockwiseUtil_0_4_2,xneg_CounterClockwiseUtil_0_4_2,xneg_InjectUtil_0_4_2;
	wire[7:0] ypos_ClockwiseUtil_0_4_2,ypos_CounterClockwiseUtil_0_4_2,ypos_InjectUtil_0_4_2;
	wire[7:0] yneg_ClockwiseUtil_0_4_2,yneg_CounterClockwiseUtil_0_4_2,yneg_InjectUtil_0_4_2;
	wire[7:0] zpos_ClockwiseUtil_0_4_2,zpos_CounterClockwiseUtil_0_4_2,zpos_InjectUtil_0_4_2;
	wire[7:0] zneg_ClockwiseUtil_0_4_2,zneg_CounterClockwiseUtil_0_4_2,zneg_InjectUtil_0_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_3, eject_xpos_ser_0_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_3, eject_xneg_ser_0_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_3, eject_ypos_ser_0_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_3, eject_yneg_ser_0_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_3, eject_zpos_ser_0_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_3, eject_zneg_ser_0_4_3;
	wire[7:0] xpos_ClockwiseUtil_0_4_3,xpos_CounterClockwiseUtil_0_4_3,xpos_InjectUtil_0_4_3;
	wire[7:0] xneg_ClockwiseUtil_0_4_3,xneg_CounterClockwiseUtil_0_4_3,xneg_InjectUtil_0_4_3;
	wire[7:0] ypos_ClockwiseUtil_0_4_3,ypos_CounterClockwiseUtil_0_4_3,ypos_InjectUtil_0_4_3;
	wire[7:0] yneg_ClockwiseUtil_0_4_3,yneg_CounterClockwiseUtil_0_4_3,yneg_InjectUtil_0_4_3;
	wire[7:0] zpos_ClockwiseUtil_0_4_3,zpos_CounterClockwiseUtil_0_4_3,zpos_InjectUtil_0_4_3;
	wire[7:0] zneg_ClockwiseUtil_0_4_3,zneg_CounterClockwiseUtil_0_4_3,zneg_InjectUtil_0_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_4, eject_xpos_ser_0_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_4, eject_xneg_ser_0_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_4, eject_ypos_ser_0_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_4, eject_yneg_ser_0_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_4, eject_zpos_ser_0_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_4, eject_zneg_ser_0_4_4;
	wire[7:0] xpos_ClockwiseUtil_0_4_4,xpos_CounterClockwiseUtil_0_4_4,xpos_InjectUtil_0_4_4;
	wire[7:0] xneg_ClockwiseUtil_0_4_4,xneg_CounterClockwiseUtil_0_4_4,xneg_InjectUtil_0_4_4;
	wire[7:0] ypos_ClockwiseUtil_0_4_4,ypos_CounterClockwiseUtil_0_4_4,ypos_InjectUtil_0_4_4;
	wire[7:0] yneg_ClockwiseUtil_0_4_4,yneg_CounterClockwiseUtil_0_4_4,yneg_InjectUtil_0_4_4;
	wire[7:0] zpos_ClockwiseUtil_0_4_4,zpos_CounterClockwiseUtil_0_4_4,zpos_InjectUtil_0_4_4;
	wire[7:0] zneg_ClockwiseUtil_0_4_4,zneg_CounterClockwiseUtil_0_4_4,zneg_InjectUtil_0_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_5, eject_xpos_ser_0_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_5, eject_xneg_ser_0_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_5, eject_ypos_ser_0_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_5, eject_yneg_ser_0_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_5, eject_zpos_ser_0_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_5, eject_zneg_ser_0_4_5;
	wire[7:0] xpos_ClockwiseUtil_0_4_5,xpos_CounterClockwiseUtil_0_4_5,xpos_InjectUtil_0_4_5;
	wire[7:0] xneg_ClockwiseUtil_0_4_5,xneg_CounterClockwiseUtil_0_4_5,xneg_InjectUtil_0_4_5;
	wire[7:0] ypos_ClockwiseUtil_0_4_5,ypos_CounterClockwiseUtil_0_4_5,ypos_InjectUtil_0_4_5;
	wire[7:0] yneg_ClockwiseUtil_0_4_5,yneg_CounterClockwiseUtil_0_4_5,yneg_InjectUtil_0_4_5;
	wire[7:0] zpos_ClockwiseUtil_0_4_5,zpos_CounterClockwiseUtil_0_4_5,zpos_InjectUtil_0_4_5;
	wire[7:0] zneg_ClockwiseUtil_0_4_5,zneg_CounterClockwiseUtil_0_4_5,zneg_InjectUtil_0_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_6, eject_xpos_ser_0_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_6, eject_xneg_ser_0_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_6, eject_ypos_ser_0_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_6, eject_yneg_ser_0_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_6, eject_zpos_ser_0_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_6, eject_zneg_ser_0_4_6;
	wire[7:0] xpos_ClockwiseUtil_0_4_6,xpos_CounterClockwiseUtil_0_4_6,xpos_InjectUtil_0_4_6;
	wire[7:0] xneg_ClockwiseUtil_0_4_6,xneg_CounterClockwiseUtil_0_4_6,xneg_InjectUtil_0_4_6;
	wire[7:0] ypos_ClockwiseUtil_0_4_6,ypos_CounterClockwiseUtil_0_4_6,ypos_InjectUtil_0_4_6;
	wire[7:0] yneg_ClockwiseUtil_0_4_6,yneg_CounterClockwiseUtil_0_4_6,yneg_InjectUtil_0_4_6;
	wire[7:0] zpos_ClockwiseUtil_0_4_6,zpos_CounterClockwiseUtil_0_4_6,zpos_InjectUtil_0_4_6;
	wire[7:0] zneg_ClockwiseUtil_0_4_6,zneg_CounterClockwiseUtil_0_4_6,zneg_InjectUtil_0_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_4_7, eject_xpos_ser_0_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_4_7, eject_xneg_ser_0_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_4_7, eject_ypos_ser_0_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_4_7, eject_yneg_ser_0_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_4_7, eject_zpos_ser_0_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_4_7, eject_zneg_ser_0_4_7;
	wire[7:0] xpos_ClockwiseUtil_0_4_7,xpos_CounterClockwiseUtil_0_4_7,xpos_InjectUtil_0_4_7;
	wire[7:0] xneg_ClockwiseUtil_0_4_7,xneg_CounterClockwiseUtil_0_4_7,xneg_InjectUtil_0_4_7;
	wire[7:0] ypos_ClockwiseUtil_0_4_7,ypos_CounterClockwiseUtil_0_4_7,ypos_InjectUtil_0_4_7;
	wire[7:0] yneg_ClockwiseUtil_0_4_7,yneg_CounterClockwiseUtil_0_4_7,yneg_InjectUtil_0_4_7;
	wire[7:0] zpos_ClockwiseUtil_0_4_7,zpos_CounterClockwiseUtil_0_4_7,zpos_InjectUtil_0_4_7;
	wire[7:0] zneg_ClockwiseUtil_0_4_7,zneg_CounterClockwiseUtil_0_4_7,zneg_InjectUtil_0_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_0, eject_xpos_ser_0_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_0, eject_xneg_ser_0_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_0, eject_ypos_ser_0_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_0, eject_yneg_ser_0_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_0, eject_zpos_ser_0_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_0, eject_zneg_ser_0_5_0;
	wire[7:0] xpos_ClockwiseUtil_0_5_0,xpos_CounterClockwiseUtil_0_5_0,xpos_InjectUtil_0_5_0;
	wire[7:0] xneg_ClockwiseUtil_0_5_0,xneg_CounterClockwiseUtil_0_5_0,xneg_InjectUtil_0_5_0;
	wire[7:0] ypos_ClockwiseUtil_0_5_0,ypos_CounterClockwiseUtil_0_5_0,ypos_InjectUtil_0_5_0;
	wire[7:0] yneg_ClockwiseUtil_0_5_0,yneg_CounterClockwiseUtil_0_5_0,yneg_InjectUtil_0_5_0;
	wire[7:0] zpos_ClockwiseUtil_0_5_0,zpos_CounterClockwiseUtil_0_5_0,zpos_InjectUtil_0_5_0;
	wire[7:0] zneg_ClockwiseUtil_0_5_0,zneg_CounterClockwiseUtil_0_5_0,zneg_InjectUtil_0_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_1, eject_xpos_ser_0_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_1, eject_xneg_ser_0_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_1, eject_ypos_ser_0_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_1, eject_yneg_ser_0_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_1, eject_zpos_ser_0_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_1, eject_zneg_ser_0_5_1;
	wire[7:0] xpos_ClockwiseUtil_0_5_1,xpos_CounterClockwiseUtil_0_5_1,xpos_InjectUtil_0_5_1;
	wire[7:0] xneg_ClockwiseUtil_0_5_1,xneg_CounterClockwiseUtil_0_5_1,xneg_InjectUtil_0_5_1;
	wire[7:0] ypos_ClockwiseUtil_0_5_1,ypos_CounterClockwiseUtil_0_5_1,ypos_InjectUtil_0_5_1;
	wire[7:0] yneg_ClockwiseUtil_0_5_1,yneg_CounterClockwiseUtil_0_5_1,yneg_InjectUtil_0_5_1;
	wire[7:0] zpos_ClockwiseUtil_0_5_1,zpos_CounterClockwiseUtil_0_5_1,zpos_InjectUtil_0_5_1;
	wire[7:0] zneg_ClockwiseUtil_0_5_1,zneg_CounterClockwiseUtil_0_5_1,zneg_InjectUtil_0_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_2, eject_xpos_ser_0_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_2, eject_xneg_ser_0_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_2, eject_ypos_ser_0_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_2, eject_yneg_ser_0_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_2, eject_zpos_ser_0_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_2, eject_zneg_ser_0_5_2;
	wire[7:0] xpos_ClockwiseUtil_0_5_2,xpos_CounterClockwiseUtil_0_5_2,xpos_InjectUtil_0_5_2;
	wire[7:0] xneg_ClockwiseUtil_0_5_2,xneg_CounterClockwiseUtil_0_5_2,xneg_InjectUtil_0_5_2;
	wire[7:0] ypos_ClockwiseUtil_0_5_2,ypos_CounterClockwiseUtil_0_5_2,ypos_InjectUtil_0_5_2;
	wire[7:0] yneg_ClockwiseUtil_0_5_2,yneg_CounterClockwiseUtil_0_5_2,yneg_InjectUtil_0_5_2;
	wire[7:0] zpos_ClockwiseUtil_0_5_2,zpos_CounterClockwiseUtil_0_5_2,zpos_InjectUtil_0_5_2;
	wire[7:0] zneg_ClockwiseUtil_0_5_2,zneg_CounterClockwiseUtil_0_5_2,zneg_InjectUtil_0_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_3, eject_xpos_ser_0_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_3, eject_xneg_ser_0_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_3, eject_ypos_ser_0_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_3, eject_yneg_ser_0_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_3, eject_zpos_ser_0_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_3, eject_zneg_ser_0_5_3;
	wire[7:0] xpos_ClockwiseUtil_0_5_3,xpos_CounterClockwiseUtil_0_5_3,xpos_InjectUtil_0_5_3;
	wire[7:0] xneg_ClockwiseUtil_0_5_3,xneg_CounterClockwiseUtil_0_5_3,xneg_InjectUtil_0_5_3;
	wire[7:0] ypos_ClockwiseUtil_0_5_3,ypos_CounterClockwiseUtil_0_5_3,ypos_InjectUtil_0_5_3;
	wire[7:0] yneg_ClockwiseUtil_0_5_3,yneg_CounterClockwiseUtil_0_5_3,yneg_InjectUtil_0_5_3;
	wire[7:0] zpos_ClockwiseUtil_0_5_3,zpos_CounterClockwiseUtil_0_5_3,zpos_InjectUtil_0_5_3;
	wire[7:0] zneg_ClockwiseUtil_0_5_3,zneg_CounterClockwiseUtil_0_5_3,zneg_InjectUtil_0_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_4, eject_xpos_ser_0_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_4, eject_xneg_ser_0_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_4, eject_ypos_ser_0_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_4, eject_yneg_ser_0_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_4, eject_zpos_ser_0_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_4, eject_zneg_ser_0_5_4;
	wire[7:0] xpos_ClockwiseUtil_0_5_4,xpos_CounterClockwiseUtil_0_5_4,xpos_InjectUtil_0_5_4;
	wire[7:0] xneg_ClockwiseUtil_0_5_4,xneg_CounterClockwiseUtil_0_5_4,xneg_InjectUtil_0_5_4;
	wire[7:0] ypos_ClockwiseUtil_0_5_4,ypos_CounterClockwiseUtil_0_5_4,ypos_InjectUtil_0_5_4;
	wire[7:0] yneg_ClockwiseUtil_0_5_4,yneg_CounterClockwiseUtil_0_5_4,yneg_InjectUtil_0_5_4;
	wire[7:0] zpos_ClockwiseUtil_0_5_4,zpos_CounterClockwiseUtil_0_5_4,zpos_InjectUtil_0_5_4;
	wire[7:0] zneg_ClockwiseUtil_0_5_4,zneg_CounterClockwiseUtil_0_5_4,zneg_InjectUtil_0_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_5, eject_xpos_ser_0_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_5, eject_xneg_ser_0_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_5, eject_ypos_ser_0_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_5, eject_yneg_ser_0_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_5, eject_zpos_ser_0_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_5, eject_zneg_ser_0_5_5;
	wire[7:0] xpos_ClockwiseUtil_0_5_5,xpos_CounterClockwiseUtil_0_5_5,xpos_InjectUtil_0_5_5;
	wire[7:0] xneg_ClockwiseUtil_0_5_5,xneg_CounterClockwiseUtil_0_5_5,xneg_InjectUtil_0_5_5;
	wire[7:0] ypos_ClockwiseUtil_0_5_5,ypos_CounterClockwiseUtil_0_5_5,ypos_InjectUtil_0_5_5;
	wire[7:0] yneg_ClockwiseUtil_0_5_5,yneg_CounterClockwiseUtil_0_5_5,yneg_InjectUtil_0_5_5;
	wire[7:0] zpos_ClockwiseUtil_0_5_5,zpos_CounterClockwiseUtil_0_5_5,zpos_InjectUtil_0_5_5;
	wire[7:0] zneg_ClockwiseUtil_0_5_5,zneg_CounterClockwiseUtil_0_5_5,zneg_InjectUtil_0_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_6, eject_xpos_ser_0_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_6, eject_xneg_ser_0_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_6, eject_ypos_ser_0_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_6, eject_yneg_ser_0_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_6, eject_zpos_ser_0_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_6, eject_zneg_ser_0_5_6;
	wire[7:0] xpos_ClockwiseUtil_0_5_6,xpos_CounterClockwiseUtil_0_5_6,xpos_InjectUtil_0_5_6;
	wire[7:0] xneg_ClockwiseUtil_0_5_6,xneg_CounterClockwiseUtil_0_5_6,xneg_InjectUtil_0_5_6;
	wire[7:0] ypos_ClockwiseUtil_0_5_6,ypos_CounterClockwiseUtil_0_5_6,ypos_InjectUtil_0_5_6;
	wire[7:0] yneg_ClockwiseUtil_0_5_6,yneg_CounterClockwiseUtil_0_5_6,yneg_InjectUtil_0_5_6;
	wire[7:0] zpos_ClockwiseUtil_0_5_6,zpos_CounterClockwiseUtil_0_5_6,zpos_InjectUtil_0_5_6;
	wire[7:0] zneg_ClockwiseUtil_0_5_6,zneg_CounterClockwiseUtil_0_5_6,zneg_InjectUtil_0_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_5_7, eject_xpos_ser_0_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_5_7, eject_xneg_ser_0_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_5_7, eject_ypos_ser_0_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_5_7, eject_yneg_ser_0_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_5_7, eject_zpos_ser_0_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_5_7, eject_zneg_ser_0_5_7;
	wire[7:0] xpos_ClockwiseUtil_0_5_7,xpos_CounterClockwiseUtil_0_5_7,xpos_InjectUtil_0_5_7;
	wire[7:0] xneg_ClockwiseUtil_0_5_7,xneg_CounterClockwiseUtil_0_5_7,xneg_InjectUtil_0_5_7;
	wire[7:0] ypos_ClockwiseUtil_0_5_7,ypos_CounterClockwiseUtil_0_5_7,ypos_InjectUtil_0_5_7;
	wire[7:0] yneg_ClockwiseUtil_0_5_7,yneg_CounterClockwiseUtil_0_5_7,yneg_InjectUtil_0_5_7;
	wire[7:0] zpos_ClockwiseUtil_0_5_7,zpos_CounterClockwiseUtil_0_5_7,zpos_InjectUtil_0_5_7;
	wire[7:0] zneg_ClockwiseUtil_0_5_7,zneg_CounterClockwiseUtil_0_5_7,zneg_InjectUtil_0_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_0, eject_xpos_ser_0_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_0, eject_xneg_ser_0_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_0, eject_ypos_ser_0_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_0, eject_yneg_ser_0_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_0, eject_zpos_ser_0_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_0, eject_zneg_ser_0_6_0;
	wire[7:0] xpos_ClockwiseUtil_0_6_0,xpos_CounterClockwiseUtil_0_6_0,xpos_InjectUtil_0_6_0;
	wire[7:0] xneg_ClockwiseUtil_0_6_0,xneg_CounterClockwiseUtil_0_6_0,xneg_InjectUtil_0_6_0;
	wire[7:0] ypos_ClockwiseUtil_0_6_0,ypos_CounterClockwiseUtil_0_6_0,ypos_InjectUtil_0_6_0;
	wire[7:0] yneg_ClockwiseUtil_0_6_0,yneg_CounterClockwiseUtil_0_6_0,yneg_InjectUtil_0_6_0;
	wire[7:0] zpos_ClockwiseUtil_0_6_0,zpos_CounterClockwiseUtil_0_6_0,zpos_InjectUtil_0_6_0;
	wire[7:0] zneg_ClockwiseUtil_0_6_0,zneg_CounterClockwiseUtil_0_6_0,zneg_InjectUtil_0_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_1, eject_xpos_ser_0_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_1, eject_xneg_ser_0_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_1, eject_ypos_ser_0_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_1, eject_yneg_ser_0_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_1, eject_zpos_ser_0_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_1, eject_zneg_ser_0_6_1;
	wire[7:0] xpos_ClockwiseUtil_0_6_1,xpos_CounterClockwiseUtil_0_6_1,xpos_InjectUtil_0_6_1;
	wire[7:0] xneg_ClockwiseUtil_0_6_1,xneg_CounterClockwiseUtil_0_6_1,xneg_InjectUtil_0_6_1;
	wire[7:0] ypos_ClockwiseUtil_0_6_1,ypos_CounterClockwiseUtil_0_6_1,ypos_InjectUtil_0_6_1;
	wire[7:0] yneg_ClockwiseUtil_0_6_1,yneg_CounterClockwiseUtil_0_6_1,yneg_InjectUtil_0_6_1;
	wire[7:0] zpos_ClockwiseUtil_0_6_1,zpos_CounterClockwiseUtil_0_6_1,zpos_InjectUtil_0_6_1;
	wire[7:0] zneg_ClockwiseUtil_0_6_1,zneg_CounterClockwiseUtil_0_6_1,zneg_InjectUtil_0_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_2, eject_xpos_ser_0_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_2, eject_xneg_ser_0_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_2, eject_ypos_ser_0_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_2, eject_yneg_ser_0_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_2, eject_zpos_ser_0_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_2, eject_zneg_ser_0_6_2;
	wire[7:0] xpos_ClockwiseUtil_0_6_2,xpos_CounterClockwiseUtil_0_6_2,xpos_InjectUtil_0_6_2;
	wire[7:0] xneg_ClockwiseUtil_0_6_2,xneg_CounterClockwiseUtil_0_6_2,xneg_InjectUtil_0_6_2;
	wire[7:0] ypos_ClockwiseUtil_0_6_2,ypos_CounterClockwiseUtil_0_6_2,ypos_InjectUtil_0_6_2;
	wire[7:0] yneg_ClockwiseUtil_0_6_2,yneg_CounterClockwiseUtil_0_6_2,yneg_InjectUtil_0_6_2;
	wire[7:0] zpos_ClockwiseUtil_0_6_2,zpos_CounterClockwiseUtil_0_6_2,zpos_InjectUtil_0_6_2;
	wire[7:0] zneg_ClockwiseUtil_0_6_2,zneg_CounterClockwiseUtil_0_6_2,zneg_InjectUtil_0_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_3, eject_xpos_ser_0_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_3, eject_xneg_ser_0_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_3, eject_ypos_ser_0_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_3, eject_yneg_ser_0_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_3, eject_zpos_ser_0_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_3, eject_zneg_ser_0_6_3;
	wire[7:0] xpos_ClockwiseUtil_0_6_3,xpos_CounterClockwiseUtil_0_6_3,xpos_InjectUtil_0_6_3;
	wire[7:0] xneg_ClockwiseUtil_0_6_3,xneg_CounterClockwiseUtil_0_6_3,xneg_InjectUtil_0_6_3;
	wire[7:0] ypos_ClockwiseUtil_0_6_3,ypos_CounterClockwiseUtil_0_6_3,ypos_InjectUtil_0_6_3;
	wire[7:0] yneg_ClockwiseUtil_0_6_3,yneg_CounterClockwiseUtil_0_6_3,yneg_InjectUtil_0_6_3;
	wire[7:0] zpos_ClockwiseUtil_0_6_3,zpos_CounterClockwiseUtil_0_6_3,zpos_InjectUtil_0_6_3;
	wire[7:0] zneg_ClockwiseUtil_0_6_3,zneg_CounterClockwiseUtil_0_6_3,zneg_InjectUtil_0_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_4, eject_xpos_ser_0_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_4, eject_xneg_ser_0_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_4, eject_ypos_ser_0_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_4, eject_yneg_ser_0_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_4, eject_zpos_ser_0_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_4, eject_zneg_ser_0_6_4;
	wire[7:0] xpos_ClockwiseUtil_0_6_4,xpos_CounterClockwiseUtil_0_6_4,xpos_InjectUtil_0_6_4;
	wire[7:0] xneg_ClockwiseUtil_0_6_4,xneg_CounterClockwiseUtil_0_6_4,xneg_InjectUtil_0_6_4;
	wire[7:0] ypos_ClockwiseUtil_0_6_4,ypos_CounterClockwiseUtil_0_6_4,ypos_InjectUtil_0_6_4;
	wire[7:0] yneg_ClockwiseUtil_0_6_4,yneg_CounterClockwiseUtil_0_6_4,yneg_InjectUtil_0_6_4;
	wire[7:0] zpos_ClockwiseUtil_0_6_4,zpos_CounterClockwiseUtil_0_6_4,zpos_InjectUtil_0_6_4;
	wire[7:0] zneg_ClockwiseUtil_0_6_4,zneg_CounterClockwiseUtil_0_6_4,zneg_InjectUtil_0_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_5, eject_xpos_ser_0_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_5, eject_xneg_ser_0_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_5, eject_ypos_ser_0_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_5, eject_yneg_ser_0_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_5, eject_zpos_ser_0_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_5, eject_zneg_ser_0_6_5;
	wire[7:0] xpos_ClockwiseUtil_0_6_5,xpos_CounterClockwiseUtil_0_6_5,xpos_InjectUtil_0_6_5;
	wire[7:0] xneg_ClockwiseUtil_0_6_5,xneg_CounterClockwiseUtil_0_6_5,xneg_InjectUtil_0_6_5;
	wire[7:0] ypos_ClockwiseUtil_0_6_5,ypos_CounterClockwiseUtil_0_6_5,ypos_InjectUtil_0_6_5;
	wire[7:0] yneg_ClockwiseUtil_0_6_5,yneg_CounterClockwiseUtil_0_6_5,yneg_InjectUtil_0_6_5;
	wire[7:0] zpos_ClockwiseUtil_0_6_5,zpos_CounterClockwiseUtil_0_6_5,zpos_InjectUtil_0_6_5;
	wire[7:0] zneg_ClockwiseUtil_0_6_5,zneg_CounterClockwiseUtil_0_6_5,zneg_InjectUtil_0_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_6, eject_xpos_ser_0_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_6, eject_xneg_ser_0_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_6, eject_ypos_ser_0_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_6, eject_yneg_ser_0_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_6, eject_zpos_ser_0_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_6, eject_zneg_ser_0_6_6;
	wire[7:0] xpos_ClockwiseUtil_0_6_6,xpos_CounterClockwiseUtil_0_6_6,xpos_InjectUtil_0_6_6;
	wire[7:0] xneg_ClockwiseUtil_0_6_6,xneg_CounterClockwiseUtil_0_6_6,xneg_InjectUtil_0_6_6;
	wire[7:0] ypos_ClockwiseUtil_0_6_6,ypos_CounterClockwiseUtil_0_6_6,ypos_InjectUtil_0_6_6;
	wire[7:0] yneg_ClockwiseUtil_0_6_6,yneg_CounterClockwiseUtil_0_6_6,yneg_InjectUtil_0_6_6;
	wire[7:0] zpos_ClockwiseUtil_0_6_6,zpos_CounterClockwiseUtil_0_6_6,zpos_InjectUtil_0_6_6;
	wire[7:0] zneg_ClockwiseUtil_0_6_6,zneg_CounterClockwiseUtil_0_6_6,zneg_InjectUtil_0_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_6_7, eject_xpos_ser_0_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_6_7, eject_xneg_ser_0_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_6_7, eject_ypos_ser_0_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_6_7, eject_yneg_ser_0_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_6_7, eject_zpos_ser_0_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_6_7, eject_zneg_ser_0_6_7;
	wire[7:0] xpos_ClockwiseUtil_0_6_7,xpos_CounterClockwiseUtil_0_6_7,xpos_InjectUtil_0_6_7;
	wire[7:0] xneg_ClockwiseUtil_0_6_7,xneg_CounterClockwiseUtil_0_6_7,xneg_InjectUtil_0_6_7;
	wire[7:0] ypos_ClockwiseUtil_0_6_7,ypos_CounterClockwiseUtil_0_6_7,ypos_InjectUtil_0_6_7;
	wire[7:0] yneg_ClockwiseUtil_0_6_7,yneg_CounterClockwiseUtil_0_6_7,yneg_InjectUtil_0_6_7;
	wire[7:0] zpos_ClockwiseUtil_0_6_7,zpos_CounterClockwiseUtil_0_6_7,zpos_InjectUtil_0_6_7;
	wire[7:0] zneg_ClockwiseUtil_0_6_7,zneg_CounterClockwiseUtil_0_6_7,zneg_InjectUtil_0_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_0, eject_xpos_ser_0_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_0, eject_xneg_ser_0_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_0, eject_ypos_ser_0_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_0, eject_yneg_ser_0_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_0, eject_zpos_ser_0_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_0, eject_zneg_ser_0_7_0;
	wire[7:0] xpos_ClockwiseUtil_0_7_0,xpos_CounterClockwiseUtil_0_7_0,xpos_InjectUtil_0_7_0;
	wire[7:0] xneg_ClockwiseUtil_0_7_0,xneg_CounterClockwiseUtil_0_7_0,xneg_InjectUtil_0_7_0;
	wire[7:0] ypos_ClockwiseUtil_0_7_0,ypos_CounterClockwiseUtil_0_7_0,ypos_InjectUtil_0_7_0;
	wire[7:0] yneg_ClockwiseUtil_0_7_0,yneg_CounterClockwiseUtil_0_7_0,yneg_InjectUtil_0_7_0;
	wire[7:0] zpos_ClockwiseUtil_0_7_0,zpos_CounterClockwiseUtil_0_7_0,zpos_InjectUtil_0_7_0;
	wire[7:0] zneg_ClockwiseUtil_0_7_0,zneg_CounterClockwiseUtil_0_7_0,zneg_InjectUtil_0_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_1, eject_xpos_ser_0_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_1, eject_xneg_ser_0_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_1, eject_ypos_ser_0_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_1, eject_yneg_ser_0_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_1, eject_zpos_ser_0_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_1, eject_zneg_ser_0_7_1;
	wire[7:0] xpos_ClockwiseUtil_0_7_1,xpos_CounterClockwiseUtil_0_7_1,xpos_InjectUtil_0_7_1;
	wire[7:0] xneg_ClockwiseUtil_0_7_1,xneg_CounterClockwiseUtil_0_7_1,xneg_InjectUtil_0_7_1;
	wire[7:0] ypos_ClockwiseUtil_0_7_1,ypos_CounterClockwiseUtil_0_7_1,ypos_InjectUtil_0_7_1;
	wire[7:0] yneg_ClockwiseUtil_0_7_1,yneg_CounterClockwiseUtil_0_7_1,yneg_InjectUtil_0_7_1;
	wire[7:0] zpos_ClockwiseUtil_0_7_1,zpos_CounterClockwiseUtil_0_7_1,zpos_InjectUtil_0_7_1;
	wire[7:0] zneg_ClockwiseUtil_0_7_1,zneg_CounterClockwiseUtil_0_7_1,zneg_InjectUtil_0_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_2, eject_xpos_ser_0_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_2, eject_xneg_ser_0_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_2, eject_ypos_ser_0_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_2, eject_yneg_ser_0_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_2, eject_zpos_ser_0_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_2, eject_zneg_ser_0_7_2;
	wire[7:0] xpos_ClockwiseUtil_0_7_2,xpos_CounterClockwiseUtil_0_7_2,xpos_InjectUtil_0_7_2;
	wire[7:0] xneg_ClockwiseUtil_0_7_2,xneg_CounterClockwiseUtil_0_7_2,xneg_InjectUtil_0_7_2;
	wire[7:0] ypos_ClockwiseUtil_0_7_2,ypos_CounterClockwiseUtil_0_7_2,ypos_InjectUtil_0_7_2;
	wire[7:0] yneg_ClockwiseUtil_0_7_2,yneg_CounterClockwiseUtil_0_7_2,yneg_InjectUtil_0_7_2;
	wire[7:0] zpos_ClockwiseUtil_0_7_2,zpos_CounterClockwiseUtil_0_7_2,zpos_InjectUtil_0_7_2;
	wire[7:0] zneg_ClockwiseUtil_0_7_2,zneg_CounterClockwiseUtil_0_7_2,zneg_InjectUtil_0_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_3, eject_xpos_ser_0_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_3, eject_xneg_ser_0_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_3, eject_ypos_ser_0_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_3, eject_yneg_ser_0_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_3, eject_zpos_ser_0_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_3, eject_zneg_ser_0_7_3;
	wire[7:0] xpos_ClockwiseUtil_0_7_3,xpos_CounterClockwiseUtil_0_7_3,xpos_InjectUtil_0_7_3;
	wire[7:0] xneg_ClockwiseUtil_0_7_3,xneg_CounterClockwiseUtil_0_7_3,xneg_InjectUtil_0_7_3;
	wire[7:0] ypos_ClockwiseUtil_0_7_3,ypos_CounterClockwiseUtil_0_7_3,ypos_InjectUtil_0_7_3;
	wire[7:0] yneg_ClockwiseUtil_0_7_3,yneg_CounterClockwiseUtil_0_7_3,yneg_InjectUtil_0_7_3;
	wire[7:0] zpos_ClockwiseUtil_0_7_3,zpos_CounterClockwiseUtil_0_7_3,zpos_InjectUtil_0_7_3;
	wire[7:0] zneg_ClockwiseUtil_0_7_3,zneg_CounterClockwiseUtil_0_7_3,zneg_InjectUtil_0_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_4, eject_xpos_ser_0_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_4, eject_xneg_ser_0_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_4, eject_ypos_ser_0_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_4, eject_yneg_ser_0_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_4, eject_zpos_ser_0_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_4, eject_zneg_ser_0_7_4;
	wire[7:0] xpos_ClockwiseUtil_0_7_4,xpos_CounterClockwiseUtil_0_7_4,xpos_InjectUtil_0_7_4;
	wire[7:0] xneg_ClockwiseUtil_0_7_4,xneg_CounterClockwiseUtil_0_7_4,xneg_InjectUtil_0_7_4;
	wire[7:0] ypos_ClockwiseUtil_0_7_4,ypos_CounterClockwiseUtil_0_7_4,ypos_InjectUtil_0_7_4;
	wire[7:0] yneg_ClockwiseUtil_0_7_4,yneg_CounterClockwiseUtil_0_7_4,yneg_InjectUtil_0_7_4;
	wire[7:0] zpos_ClockwiseUtil_0_7_4,zpos_CounterClockwiseUtil_0_7_4,zpos_InjectUtil_0_7_4;
	wire[7:0] zneg_ClockwiseUtil_0_7_4,zneg_CounterClockwiseUtil_0_7_4,zneg_InjectUtil_0_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_5, eject_xpos_ser_0_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_5, eject_xneg_ser_0_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_5, eject_ypos_ser_0_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_5, eject_yneg_ser_0_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_5, eject_zpos_ser_0_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_5, eject_zneg_ser_0_7_5;
	wire[7:0] xpos_ClockwiseUtil_0_7_5,xpos_CounterClockwiseUtil_0_7_5,xpos_InjectUtil_0_7_5;
	wire[7:0] xneg_ClockwiseUtil_0_7_5,xneg_CounterClockwiseUtil_0_7_5,xneg_InjectUtil_0_7_5;
	wire[7:0] ypos_ClockwiseUtil_0_7_5,ypos_CounterClockwiseUtil_0_7_5,ypos_InjectUtil_0_7_5;
	wire[7:0] yneg_ClockwiseUtil_0_7_5,yneg_CounterClockwiseUtil_0_7_5,yneg_InjectUtil_0_7_5;
	wire[7:0] zpos_ClockwiseUtil_0_7_5,zpos_CounterClockwiseUtil_0_7_5,zpos_InjectUtil_0_7_5;
	wire[7:0] zneg_ClockwiseUtil_0_7_5,zneg_CounterClockwiseUtil_0_7_5,zneg_InjectUtil_0_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_6, eject_xpos_ser_0_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_6, eject_xneg_ser_0_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_6, eject_ypos_ser_0_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_6, eject_yneg_ser_0_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_6, eject_zpos_ser_0_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_6, eject_zneg_ser_0_7_6;
	wire[7:0] xpos_ClockwiseUtil_0_7_6,xpos_CounterClockwiseUtil_0_7_6,xpos_InjectUtil_0_7_6;
	wire[7:0] xneg_ClockwiseUtil_0_7_6,xneg_CounterClockwiseUtil_0_7_6,xneg_InjectUtil_0_7_6;
	wire[7:0] ypos_ClockwiseUtil_0_7_6,ypos_CounterClockwiseUtil_0_7_6,ypos_InjectUtil_0_7_6;
	wire[7:0] yneg_ClockwiseUtil_0_7_6,yneg_CounterClockwiseUtil_0_7_6,yneg_InjectUtil_0_7_6;
	wire[7:0] zpos_ClockwiseUtil_0_7_6,zpos_CounterClockwiseUtil_0_7_6,zpos_InjectUtil_0_7_6;
	wire[7:0] zneg_ClockwiseUtil_0_7_6,zneg_CounterClockwiseUtil_0_7_6,zneg_InjectUtil_0_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_0_7_7, eject_xpos_ser_0_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_0_7_7, eject_xneg_ser_0_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_0_7_7, eject_ypos_ser_0_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_0_7_7, eject_yneg_ser_0_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_0_7_7, eject_zpos_ser_0_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_0_7_7, eject_zneg_ser_0_7_7;
	wire[7:0] xpos_ClockwiseUtil_0_7_7,xpos_CounterClockwiseUtil_0_7_7,xpos_InjectUtil_0_7_7;
	wire[7:0] xneg_ClockwiseUtil_0_7_7,xneg_CounterClockwiseUtil_0_7_7,xneg_InjectUtil_0_7_7;
	wire[7:0] ypos_ClockwiseUtil_0_7_7,ypos_CounterClockwiseUtil_0_7_7,ypos_InjectUtil_0_7_7;
	wire[7:0] yneg_ClockwiseUtil_0_7_7,yneg_CounterClockwiseUtil_0_7_7,yneg_InjectUtil_0_7_7;
	wire[7:0] zpos_ClockwiseUtil_0_7_7,zpos_CounterClockwiseUtil_0_7_7,zpos_InjectUtil_0_7_7;
	wire[7:0] zneg_ClockwiseUtil_0_7_7,zneg_CounterClockwiseUtil_0_7_7,zneg_InjectUtil_0_7_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_0, eject_xpos_ser_1_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_0, eject_xneg_ser_1_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_0, eject_ypos_ser_1_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_0, eject_yneg_ser_1_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_0, eject_zpos_ser_1_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_0, eject_zneg_ser_1_0_0;
	wire[7:0] xpos_ClockwiseUtil_1_0_0,xpos_CounterClockwiseUtil_1_0_0,xpos_InjectUtil_1_0_0;
	wire[7:0] xneg_ClockwiseUtil_1_0_0,xneg_CounterClockwiseUtil_1_0_0,xneg_InjectUtil_1_0_0;
	wire[7:0] ypos_ClockwiseUtil_1_0_0,ypos_CounterClockwiseUtil_1_0_0,ypos_InjectUtil_1_0_0;
	wire[7:0] yneg_ClockwiseUtil_1_0_0,yneg_CounterClockwiseUtil_1_0_0,yneg_InjectUtil_1_0_0;
	wire[7:0] zpos_ClockwiseUtil_1_0_0,zpos_CounterClockwiseUtil_1_0_0,zpos_InjectUtil_1_0_0;
	wire[7:0] zneg_ClockwiseUtil_1_0_0,zneg_CounterClockwiseUtil_1_0_0,zneg_InjectUtil_1_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_1, eject_xpos_ser_1_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_1, eject_xneg_ser_1_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_1, eject_ypos_ser_1_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_1, eject_yneg_ser_1_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_1, eject_zpos_ser_1_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_1, eject_zneg_ser_1_0_1;
	wire[7:0] xpos_ClockwiseUtil_1_0_1,xpos_CounterClockwiseUtil_1_0_1,xpos_InjectUtil_1_0_1;
	wire[7:0] xneg_ClockwiseUtil_1_0_1,xneg_CounterClockwiseUtil_1_0_1,xneg_InjectUtil_1_0_1;
	wire[7:0] ypos_ClockwiseUtil_1_0_1,ypos_CounterClockwiseUtil_1_0_1,ypos_InjectUtil_1_0_1;
	wire[7:0] yneg_ClockwiseUtil_1_0_1,yneg_CounterClockwiseUtil_1_0_1,yneg_InjectUtil_1_0_1;
	wire[7:0] zpos_ClockwiseUtil_1_0_1,zpos_CounterClockwiseUtil_1_0_1,zpos_InjectUtil_1_0_1;
	wire[7:0] zneg_ClockwiseUtil_1_0_1,zneg_CounterClockwiseUtil_1_0_1,zneg_InjectUtil_1_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_2, eject_xpos_ser_1_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_2, eject_xneg_ser_1_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_2, eject_ypos_ser_1_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_2, eject_yneg_ser_1_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_2, eject_zpos_ser_1_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_2, eject_zneg_ser_1_0_2;
	wire[7:0] xpos_ClockwiseUtil_1_0_2,xpos_CounterClockwiseUtil_1_0_2,xpos_InjectUtil_1_0_2;
	wire[7:0] xneg_ClockwiseUtil_1_0_2,xneg_CounterClockwiseUtil_1_0_2,xneg_InjectUtil_1_0_2;
	wire[7:0] ypos_ClockwiseUtil_1_0_2,ypos_CounterClockwiseUtil_1_0_2,ypos_InjectUtil_1_0_2;
	wire[7:0] yneg_ClockwiseUtil_1_0_2,yneg_CounterClockwiseUtil_1_0_2,yneg_InjectUtil_1_0_2;
	wire[7:0] zpos_ClockwiseUtil_1_0_2,zpos_CounterClockwiseUtil_1_0_2,zpos_InjectUtil_1_0_2;
	wire[7:0] zneg_ClockwiseUtil_1_0_2,zneg_CounterClockwiseUtil_1_0_2,zneg_InjectUtil_1_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_3, eject_xpos_ser_1_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_3, eject_xneg_ser_1_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_3, eject_ypos_ser_1_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_3, eject_yneg_ser_1_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_3, eject_zpos_ser_1_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_3, eject_zneg_ser_1_0_3;
	wire[7:0] xpos_ClockwiseUtil_1_0_3,xpos_CounterClockwiseUtil_1_0_3,xpos_InjectUtil_1_0_3;
	wire[7:0] xneg_ClockwiseUtil_1_0_3,xneg_CounterClockwiseUtil_1_0_3,xneg_InjectUtil_1_0_3;
	wire[7:0] ypos_ClockwiseUtil_1_0_3,ypos_CounterClockwiseUtil_1_0_3,ypos_InjectUtil_1_0_3;
	wire[7:0] yneg_ClockwiseUtil_1_0_3,yneg_CounterClockwiseUtil_1_0_3,yneg_InjectUtil_1_0_3;
	wire[7:0] zpos_ClockwiseUtil_1_0_3,zpos_CounterClockwiseUtil_1_0_3,zpos_InjectUtil_1_0_3;
	wire[7:0] zneg_ClockwiseUtil_1_0_3,zneg_CounterClockwiseUtil_1_0_3,zneg_InjectUtil_1_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_4, eject_xpos_ser_1_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_4, eject_xneg_ser_1_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_4, eject_ypos_ser_1_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_4, eject_yneg_ser_1_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_4, eject_zpos_ser_1_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_4, eject_zneg_ser_1_0_4;
	wire[7:0] xpos_ClockwiseUtil_1_0_4,xpos_CounterClockwiseUtil_1_0_4,xpos_InjectUtil_1_0_4;
	wire[7:0] xneg_ClockwiseUtil_1_0_4,xneg_CounterClockwiseUtil_1_0_4,xneg_InjectUtil_1_0_4;
	wire[7:0] ypos_ClockwiseUtil_1_0_4,ypos_CounterClockwiseUtil_1_0_4,ypos_InjectUtil_1_0_4;
	wire[7:0] yneg_ClockwiseUtil_1_0_4,yneg_CounterClockwiseUtil_1_0_4,yneg_InjectUtil_1_0_4;
	wire[7:0] zpos_ClockwiseUtil_1_0_4,zpos_CounterClockwiseUtil_1_0_4,zpos_InjectUtil_1_0_4;
	wire[7:0] zneg_ClockwiseUtil_1_0_4,zneg_CounterClockwiseUtil_1_0_4,zneg_InjectUtil_1_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_5, eject_xpos_ser_1_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_5, eject_xneg_ser_1_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_5, eject_ypos_ser_1_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_5, eject_yneg_ser_1_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_5, eject_zpos_ser_1_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_5, eject_zneg_ser_1_0_5;
	wire[7:0] xpos_ClockwiseUtil_1_0_5,xpos_CounterClockwiseUtil_1_0_5,xpos_InjectUtil_1_0_5;
	wire[7:0] xneg_ClockwiseUtil_1_0_5,xneg_CounterClockwiseUtil_1_0_5,xneg_InjectUtil_1_0_5;
	wire[7:0] ypos_ClockwiseUtil_1_0_5,ypos_CounterClockwiseUtil_1_0_5,ypos_InjectUtil_1_0_5;
	wire[7:0] yneg_ClockwiseUtil_1_0_5,yneg_CounterClockwiseUtil_1_0_5,yneg_InjectUtil_1_0_5;
	wire[7:0] zpos_ClockwiseUtil_1_0_5,zpos_CounterClockwiseUtil_1_0_5,zpos_InjectUtil_1_0_5;
	wire[7:0] zneg_ClockwiseUtil_1_0_5,zneg_CounterClockwiseUtil_1_0_5,zneg_InjectUtil_1_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_6, eject_xpos_ser_1_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_6, eject_xneg_ser_1_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_6, eject_ypos_ser_1_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_6, eject_yneg_ser_1_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_6, eject_zpos_ser_1_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_6, eject_zneg_ser_1_0_6;
	wire[7:0] xpos_ClockwiseUtil_1_0_6,xpos_CounterClockwiseUtil_1_0_6,xpos_InjectUtil_1_0_6;
	wire[7:0] xneg_ClockwiseUtil_1_0_6,xneg_CounterClockwiseUtil_1_0_6,xneg_InjectUtil_1_0_6;
	wire[7:0] ypos_ClockwiseUtil_1_0_6,ypos_CounterClockwiseUtil_1_0_6,ypos_InjectUtil_1_0_6;
	wire[7:0] yneg_ClockwiseUtil_1_0_6,yneg_CounterClockwiseUtil_1_0_6,yneg_InjectUtil_1_0_6;
	wire[7:0] zpos_ClockwiseUtil_1_0_6,zpos_CounterClockwiseUtil_1_0_6,zpos_InjectUtil_1_0_6;
	wire[7:0] zneg_ClockwiseUtil_1_0_6,zneg_CounterClockwiseUtil_1_0_6,zneg_InjectUtil_1_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_0_7, eject_xpos_ser_1_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_0_7, eject_xneg_ser_1_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_0_7, eject_ypos_ser_1_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_0_7, eject_yneg_ser_1_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_0_7, eject_zpos_ser_1_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_0_7, eject_zneg_ser_1_0_7;
	wire[7:0] xpos_ClockwiseUtil_1_0_7,xpos_CounterClockwiseUtil_1_0_7,xpos_InjectUtil_1_0_7;
	wire[7:0] xneg_ClockwiseUtil_1_0_7,xneg_CounterClockwiseUtil_1_0_7,xneg_InjectUtil_1_0_7;
	wire[7:0] ypos_ClockwiseUtil_1_0_7,ypos_CounterClockwiseUtil_1_0_7,ypos_InjectUtil_1_0_7;
	wire[7:0] yneg_ClockwiseUtil_1_0_7,yneg_CounterClockwiseUtil_1_0_7,yneg_InjectUtil_1_0_7;
	wire[7:0] zpos_ClockwiseUtil_1_0_7,zpos_CounterClockwiseUtil_1_0_7,zpos_InjectUtil_1_0_7;
	wire[7:0] zneg_ClockwiseUtil_1_0_7,zneg_CounterClockwiseUtil_1_0_7,zneg_InjectUtil_1_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_0, eject_xpos_ser_1_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_0, eject_xneg_ser_1_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_0, eject_ypos_ser_1_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_0, eject_yneg_ser_1_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_0, eject_zpos_ser_1_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_0, eject_zneg_ser_1_1_0;
	wire[7:0] xpos_ClockwiseUtil_1_1_0,xpos_CounterClockwiseUtil_1_1_0,xpos_InjectUtil_1_1_0;
	wire[7:0] xneg_ClockwiseUtil_1_1_0,xneg_CounterClockwiseUtil_1_1_0,xneg_InjectUtil_1_1_0;
	wire[7:0] ypos_ClockwiseUtil_1_1_0,ypos_CounterClockwiseUtil_1_1_0,ypos_InjectUtil_1_1_0;
	wire[7:0] yneg_ClockwiseUtil_1_1_0,yneg_CounterClockwiseUtil_1_1_0,yneg_InjectUtil_1_1_0;
	wire[7:0] zpos_ClockwiseUtil_1_1_0,zpos_CounterClockwiseUtil_1_1_0,zpos_InjectUtil_1_1_0;
	wire[7:0] zneg_ClockwiseUtil_1_1_0,zneg_CounterClockwiseUtil_1_1_0,zneg_InjectUtil_1_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_1, eject_xpos_ser_1_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_1, eject_xneg_ser_1_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_1, eject_ypos_ser_1_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_1, eject_yneg_ser_1_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_1, eject_zpos_ser_1_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_1, eject_zneg_ser_1_1_1;
	wire[7:0] xpos_ClockwiseUtil_1_1_1,xpos_CounterClockwiseUtil_1_1_1,xpos_InjectUtil_1_1_1;
	wire[7:0] xneg_ClockwiseUtil_1_1_1,xneg_CounterClockwiseUtil_1_1_1,xneg_InjectUtil_1_1_1;
	wire[7:0] ypos_ClockwiseUtil_1_1_1,ypos_CounterClockwiseUtil_1_1_1,ypos_InjectUtil_1_1_1;
	wire[7:0] yneg_ClockwiseUtil_1_1_1,yneg_CounterClockwiseUtil_1_1_1,yneg_InjectUtil_1_1_1;
	wire[7:0] zpos_ClockwiseUtil_1_1_1,zpos_CounterClockwiseUtil_1_1_1,zpos_InjectUtil_1_1_1;
	wire[7:0] zneg_ClockwiseUtil_1_1_1,zneg_CounterClockwiseUtil_1_1_1,zneg_InjectUtil_1_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_2, eject_xpos_ser_1_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_2, eject_xneg_ser_1_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_2, eject_ypos_ser_1_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_2, eject_yneg_ser_1_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_2, eject_zpos_ser_1_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_2, eject_zneg_ser_1_1_2;
	wire[7:0] xpos_ClockwiseUtil_1_1_2,xpos_CounterClockwiseUtil_1_1_2,xpos_InjectUtil_1_1_2;
	wire[7:0] xneg_ClockwiseUtil_1_1_2,xneg_CounterClockwiseUtil_1_1_2,xneg_InjectUtil_1_1_2;
	wire[7:0] ypos_ClockwiseUtil_1_1_2,ypos_CounterClockwiseUtil_1_1_2,ypos_InjectUtil_1_1_2;
	wire[7:0] yneg_ClockwiseUtil_1_1_2,yneg_CounterClockwiseUtil_1_1_2,yneg_InjectUtil_1_1_2;
	wire[7:0] zpos_ClockwiseUtil_1_1_2,zpos_CounterClockwiseUtil_1_1_2,zpos_InjectUtil_1_1_2;
	wire[7:0] zneg_ClockwiseUtil_1_1_2,zneg_CounterClockwiseUtil_1_1_2,zneg_InjectUtil_1_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_3, eject_xpos_ser_1_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_3, eject_xneg_ser_1_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_3, eject_ypos_ser_1_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_3, eject_yneg_ser_1_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_3, eject_zpos_ser_1_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_3, eject_zneg_ser_1_1_3;
	wire[7:0] xpos_ClockwiseUtil_1_1_3,xpos_CounterClockwiseUtil_1_1_3,xpos_InjectUtil_1_1_3;
	wire[7:0] xneg_ClockwiseUtil_1_1_3,xneg_CounterClockwiseUtil_1_1_3,xneg_InjectUtil_1_1_3;
	wire[7:0] ypos_ClockwiseUtil_1_1_3,ypos_CounterClockwiseUtil_1_1_3,ypos_InjectUtil_1_1_3;
	wire[7:0] yneg_ClockwiseUtil_1_1_3,yneg_CounterClockwiseUtil_1_1_3,yneg_InjectUtil_1_1_3;
	wire[7:0] zpos_ClockwiseUtil_1_1_3,zpos_CounterClockwiseUtil_1_1_3,zpos_InjectUtil_1_1_3;
	wire[7:0] zneg_ClockwiseUtil_1_1_3,zneg_CounterClockwiseUtil_1_1_3,zneg_InjectUtil_1_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_4, eject_xpos_ser_1_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_4, eject_xneg_ser_1_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_4, eject_ypos_ser_1_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_4, eject_yneg_ser_1_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_4, eject_zpos_ser_1_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_4, eject_zneg_ser_1_1_4;
	wire[7:0] xpos_ClockwiseUtil_1_1_4,xpos_CounterClockwiseUtil_1_1_4,xpos_InjectUtil_1_1_4;
	wire[7:0] xneg_ClockwiseUtil_1_1_4,xneg_CounterClockwiseUtil_1_1_4,xneg_InjectUtil_1_1_4;
	wire[7:0] ypos_ClockwiseUtil_1_1_4,ypos_CounterClockwiseUtil_1_1_4,ypos_InjectUtil_1_1_4;
	wire[7:0] yneg_ClockwiseUtil_1_1_4,yneg_CounterClockwiseUtil_1_1_4,yneg_InjectUtil_1_1_4;
	wire[7:0] zpos_ClockwiseUtil_1_1_4,zpos_CounterClockwiseUtil_1_1_4,zpos_InjectUtil_1_1_4;
	wire[7:0] zneg_ClockwiseUtil_1_1_4,zneg_CounterClockwiseUtil_1_1_4,zneg_InjectUtil_1_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_5, eject_xpos_ser_1_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_5, eject_xneg_ser_1_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_5, eject_ypos_ser_1_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_5, eject_yneg_ser_1_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_5, eject_zpos_ser_1_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_5, eject_zneg_ser_1_1_5;
	wire[7:0] xpos_ClockwiseUtil_1_1_5,xpos_CounterClockwiseUtil_1_1_5,xpos_InjectUtil_1_1_5;
	wire[7:0] xneg_ClockwiseUtil_1_1_5,xneg_CounterClockwiseUtil_1_1_5,xneg_InjectUtil_1_1_5;
	wire[7:0] ypos_ClockwiseUtil_1_1_5,ypos_CounterClockwiseUtil_1_1_5,ypos_InjectUtil_1_1_5;
	wire[7:0] yneg_ClockwiseUtil_1_1_5,yneg_CounterClockwiseUtil_1_1_5,yneg_InjectUtil_1_1_5;
	wire[7:0] zpos_ClockwiseUtil_1_1_5,zpos_CounterClockwiseUtil_1_1_5,zpos_InjectUtil_1_1_5;
	wire[7:0] zneg_ClockwiseUtil_1_1_5,zneg_CounterClockwiseUtil_1_1_5,zneg_InjectUtil_1_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_6, eject_xpos_ser_1_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_6, eject_xneg_ser_1_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_6, eject_ypos_ser_1_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_6, eject_yneg_ser_1_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_6, eject_zpos_ser_1_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_6, eject_zneg_ser_1_1_6;
	wire[7:0] xpos_ClockwiseUtil_1_1_6,xpos_CounterClockwiseUtil_1_1_6,xpos_InjectUtil_1_1_6;
	wire[7:0] xneg_ClockwiseUtil_1_1_6,xneg_CounterClockwiseUtil_1_1_6,xneg_InjectUtil_1_1_6;
	wire[7:0] ypos_ClockwiseUtil_1_1_6,ypos_CounterClockwiseUtil_1_1_6,ypos_InjectUtil_1_1_6;
	wire[7:0] yneg_ClockwiseUtil_1_1_6,yneg_CounterClockwiseUtil_1_1_6,yneg_InjectUtil_1_1_6;
	wire[7:0] zpos_ClockwiseUtil_1_1_6,zpos_CounterClockwiseUtil_1_1_6,zpos_InjectUtil_1_1_6;
	wire[7:0] zneg_ClockwiseUtil_1_1_6,zneg_CounterClockwiseUtil_1_1_6,zneg_InjectUtil_1_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_1_7, eject_xpos_ser_1_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_1_7, eject_xneg_ser_1_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_1_7, eject_ypos_ser_1_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_1_7, eject_yneg_ser_1_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_1_7, eject_zpos_ser_1_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_1_7, eject_zneg_ser_1_1_7;
	wire[7:0] xpos_ClockwiseUtil_1_1_7,xpos_CounterClockwiseUtil_1_1_7,xpos_InjectUtil_1_1_7;
	wire[7:0] xneg_ClockwiseUtil_1_1_7,xneg_CounterClockwiseUtil_1_1_7,xneg_InjectUtil_1_1_7;
	wire[7:0] ypos_ClockwiseUtil_1_1_7,ypos_CounterClockwiseUtil_1_1_7,ypos_InjectUtil_1_1_7;
	wire[7:0] yneg_ClockwiseUtil_1_1_7,yneg_CounterClockwiseUtil_1_1_7,yneg_InjectUtil_1_1_7;
	wire[7:0] zpos_ClockwiseUtil_1_1_7,zpos_CounterClockwiseUtil_1_1_7,zpos_InjectUtil_1_1_7;
	wire[7:0] zneg_ClockwiseUtil_1_1_7,zneg_CounterClockwiseUtil_1_1_7,zneg_InjectUtil_1_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_0, eject_xpos_ser_1_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_0, eject_xneg_ser_1_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_0, eject_ypos_ser_1_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_0, eject_yneg_ser_1_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_0, eject_zpos_ser_1_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_0, eject_zneg_ser_1_2_0;
	wire[7:0] xpos_ClockwiseUtil_1_2_0,xpos_CounterClockwiseUtil_1_2_0,xpos_InjectUtil_1_2_0;
	wire[7:0] xneg_ClockwiseUtil_1_2_0,xneg_CounterClockwiseUtil_1_2_0,xneg_InjectUtil_1_2_0;
	wire[7:0] ypos_ClockwiseUtil_1_2_0,ypos_CounterClockwiseUtil_1_2_0,ypos_InjectUtil_1_2_0;
	wire[7:0] yneg_ClockwiseUtil_1_2_0,yneg_CounterClockwiseUtil_1_2_0,yneg_InjectUtil_1_2_0;
	wire[7:0] zpos_ClockwiseUtil_1_2_0,zpos_CounterClockwiseUtil_1_2_0,zpos_InjectUtil_1_2_0;
	wire[7:0] zneg_ClockwiseUtil_1_2_0,zneg_CounterClockwiseUtil_1_2_0,zneg_InjectUtil_1_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_1, eject_xpos_ser_1_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_1, eject_xneg_ser_1_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_1, eject_ypos_ser_1_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_1, eject_yneg_ser_1_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_1, eject_zpos_ser_1_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_1, eject_zneg_ser_1_2_1;
	wire[7:0] xpos_ClockwiseUtil_1_2_1,xpos_CounterClockwiseUtil_1_2_1,xpos_InjectUtil_1_2_1;
	wire[7:0] xneg_ClockwiseUtil_1_2_1,xneg_CounterClockwiseUtil_1_2_1,xneg_InjectUtil_1_2_1;
	wire[7:0] ypos_ClockwiseUtil_1_2_1,ypos_CounterClockwiseUtil_1_2_1,ypos_InjectUtil_1_2_1;
	wire[7:0] yneg_ClockwiseUtil_1_2_1,yneg_CounterClockwiseUtil_1_2_1,yneg_InjectUtil_1_2_1;
	wire[7:0] zpos_ClockwiseUtil_1_2_1,zpos_CounterClockwiseUtil_1_2_1,zpos_InjectUtil_1_2_1;
	wire[7:0] zneg_ClockwiseUtil_1_2_1,zneg_CounterClockwiseUtil_1_2_1,zneg_InjectUtil_1_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_2, eject_xpos_ser_1_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_2, eject_xneg_ser_1_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_2, eject_ypos_ser_1_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_2, eject_yneg_ser_1_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_2, eject_zpos_ser_1_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_2, eject_zneg_ser_1_2_2;
	wire[7:0] xpos_ClockwiseUtil_1_2_2,xpos_CounterClockwiseUtil_1_2_2,xpos_InjectUtil_1_2_2;
	wire[7:0] xneg_ClockwiseUtil_1_2_2,xneg_CounterClockwiseUtil_1_2_2,xneg_InjectUtil_1_2_2;
	wire[7:0] ypos_ClockwiseUtil_1_2_2,ypos_CounterClockwiseUtil_1_2_2,ypos_InjectUtil_1_2_2;
	wire[7:0] yneg_ClockwiseUtil_1_2_2,yneg_CounterClockwiseUtil_1_2_2,yneg_InjectUtil_1_2_2;
	wire[7:0] zpos_ClockwiseUtil_1_2_2,zpos_CounterClockwiseUtil_1_2_2,zpos_InjectUtil_1_2_2;
	wire[7:0] zneg_ClockwiseUtil_1_2_2,zneg_CounterClockwiseUtil_1_2_2,zneg_InjectUtil_1_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_3, eject_xpos_ser_1_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_3, eject_xneg_ser_1_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_3, eject_ypos_ser_1_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_3, eject_yneg_ser_1_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_3, eject_zpos_ser_1_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_3, eject_zneg_ser_1_2_3;
	wire[7:0] xpos_ClockwiseUtil_1_2_3,xpos_CounterClockwiseUtil_1_2_3,xpos_InjectUtil_1_2_3;
	wire[7:0] xneg_ClockwiseUtil_1_2_3,xneg_CounterClockwiseUtil_1_2_3,xneg_InjectUtil_1_2_3;
	wire[7:0] ypos_ClockwiseUtil_1_2_3,ypos_CounterClockwiseUtil_1_2_3,ypos_InjectUtil_1_2_3;
	wire[7:0] yneg_ClockwiseUtil_1_2_3,yneg_CounterClockwiseUtil_1_2_3,yneg_InjectUtil_1_2_3;
	wire[7:0] zpos_ClockwiseUtil_1_2_3,zpos_CounterClockwiseUtil_1_2_3,zpos_InjectUtil_1_2_3;
	wire[7:0] zneg_ClockwiseUtil_1_2_3,zneg_CounterClockwiseUtil_1_2_3,zneg_InjectUtil_1_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_4, eject_xpos_ser_1_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_4, eject_xneg_ser_1_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_4, eject_ypos_ser_1_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_4, eject_yneg_ser_1_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_4, eject_zpos_ser_1_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_4, eject_zneg_ser_1_2_4;
	wire[7:0] xpos_ClockwiseUtil_1_2_4,xpos_CounterClockwiseUtil_1_2_4,xpos_InjectUtil_1_2_4;
	wire[7:0] xneg_ClockwiseUtil_1_2_4,xneg_CounterClockwiseUtil_1_2_4,xneg_InjectUtil_1_2_4;
	wire[7:0] ypos_ClockwiseUtil_1_2_4,ypos_CounterClockwiseUtil_1_2_4,ypos_InjectUtil_1_2_4;
	wire[7:0] yneg_ClockwiseUtil_1_2_4,yneg_CounterClockwiseUtil_1_2_4,yneg_InjectUtil_1_2_4;
	wire[7:0] zpos_ClockwiseUtil_1_2_4,zpos_CounterClockwiseUtil_1_2_4,zpos_InjectUtil_1_2_4;
	wire[7:0] zneg_ClockwiseUtil_1_2_4,zneg_CounterClockwiseUtil_1_2_4,zneg_InjectUtil_1_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_5, eject_xpos_ser_1_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_5, eject_xneg_ser_1_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_5, eject_ypos_ser_1_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_5, eject_yneg_ser_1_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_5, eject_zpos_ser_1_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_5, eject_zneg_ser_1_2_5;
	wire[7:0] xpos_ClockwiseUtil_1_2_5,xpos_CounterClockwiseUtil_1_2_5,xpos_InjectUtil_1_2_5;
	wire[7:0] xneg_ClockwiseUtil_1_2_5,xneg_CounterClockwiseUtil_1_2_5,xneg_InjectUtil_1_2_5;
	wire[7:0] ypos_ClockwiseUtil_1_2_5,ypos_CounterClockwiseUtil_1_2_5,ypos_InjectUtil_1_2_5;
	wire[7:0] yneg_ClockwiseUtil_1_2_5,yneg_CounterClockwiseUtil_1_2_5,yneg_InjectUtil_1_2_5;
	wire[7:0] zpos_ClockwiseUtil_1_2_5,zpos_CounterClockwiseUtil_1_2_5,zpos_InjectUtil_1_2_5;
	wire[7:0] zneg_ClockwiseUtil_1_2_5,zneg_CounterClockwiseUtil_1_2_5,zneg_InjectUtil_1_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_6, eject_xpos_ser_1_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_6, eject_xneg_ser_1_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_6, eject_ypos_ser_1_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_6, eject_yneg_ser_1_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_6, eject_zpos_ser_1_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_6, eject_zneg_ser_1_2_6;
	wire[7:0] xpos_ClockwiseUtil_1_2_6,xpos_CounterClockwiseUtil_1_2_6,xpos_InjectUtil_1_2_6;
	wire[7:0] xneg_ClockwiseUtil_1_2_6,xneg_CounterClockwiseUtil_1_2_6,xneg_InjectUtil_1_2_6;
	wire[7:0] ypos_ClockwiseUtil_1_2_6,ypos_CounterClockwiseUtil_1_2_6,ypos_InjectUtil_1_2_6;
	wire[7:0] yneg_ClockwiseUtil_1_2_6,yneg_CounterClockwiseUtil_1_2_6,yneg_InjectUtil_1_2_6;
	wire[7:0] zpos_ClockwiseUtil_1_2_6,zpos_CounterClockwiseUtil_1_2_6,zpos_InjectUtil_1_2_6;
	wire[7:0] zneg_ClockwiseUtil_1_2_6,zneg_CounterClockwiseUtil_1_2_6,zneg_InjectUtil_1_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_2_7, eject_xpos_ser_1_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_2_7, eject_xneg_ser_1_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_2_7, eject_ypos_ser_1_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_2_7, eject_yneg_ser_1_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_2_7, eject_zpos_ser_1_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_2_7, eject_zneg_ser_1_2_7;
	wire[7:0] xpos_ClockwiseUtil_1_2_7,xpos_CounterClockwiseUtil_1_2_7,xpos_InjectUtil_1_2_7;
	wire[7:0] xneg_ClockwiseUtil_1_2_7,xneg_CounterClockwiseUtil_1_2_7,xneg_InjectUtil_1_2_7;
	wire[7:0] ypos_ClockwiseUtil_1_2_7,ypos_CounterClockwiseUtil_1_2_7,ypos_InjectUtil_1_2_7;
	wire[7:0] yneg_ClockwiseUtil_1_2_7,yneg_CounterClockwiseUtil_1_2_7,yneg_InjectUtil_1_2_7;
	wire[7:0] zpos_ClockwiseUtil_1_2_7,zpos_CounterClockwiseUtil_1_2_7,zpos_InjectUtil_1_2_7;
	wire[7:0] zneg_ClockwiseUtil_1_2_7,zneg_CounterClockwiseUtil_1_2_7,zneg_InjectUtil_1_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_0, eject_xpos_ser_1_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_0, eject_xneg_ser_1_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_0, eject_ypos_ser_1_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_0, eject_yneg_ser_1_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_0, eject_zpos_ser_1_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_0, eject_zneg_ser_1_3_0;
	wire[7:0] xpos_ClockwiseUtil_1_3_0,xpos_CounterClockwiseUtil_1_3_0,xpos_InjectUtil_1_3_0;
	wire[7:0] xneg_ClockwiseUtil_1_3_0,xneg_CounterClockwiseUtil_1_3_0,xneg_InjectUtil_1_3_0;
	wire[7:0] ypos_ClockwiseUtil_1_3_0,ypos_CounterClockwiseUtil_1_3_0,ypos_InjectUtil_1_3_0;
	wire[7:0] yneg_ClockwiseUtil_1_3_0,yneg_CounterClockwiseUtil_1_3_0,yneg_InjectUtil_1_3_0;
	wire[7:0] zpos_ClockwiseUtil_1_3_0,zpos_CounterClockwiseUtil_1_3_0,zpos_InjectUtil_1_3_0;
	wire[7:0] zneg_ClockwiseUtil_1_3_0,zneg_CounterClockwiseUtil_1_3_0,zneg_InjectUtil_1_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_1, eject_xpos_ser_1_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_1, eject_xneg_ser_1_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_1, eject_ypos_ser_1_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_1, eject_yneg_ser_1_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_1, eject_zpos_ser_1_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_1, eject_zneg_ser_1_3_1;
	wire[7:0] xpos_ClockwiseUtil_1_3_1,xpos_CounterClockwiseUtil_1_3_1,xpos_InjectUtil_1_3_1;
	wire[7:0] xneg_ClockwiseUtil_1_3_1,xneg_CounterClockwiseUtil_1_3_1,xneg_InjectUtil_1_3_1;
	wire[7:0] ypos_ClockwiseUtil_1_3_1,ypos_CounterClockwiseUtil_1_3_1,ypos_InjectUtil_1_3_1;
	wire[7:0] yneg_ClockwiseUtil_1_3_1,yneg_CounterClockwiseUtil_1_3_1,yneg_InjectUtil_1_3_1;
	wire[7:0] zpos_ClockwiseUtil_1_3_1,zpos_CounterClockwiseUtil_1_3_1,zpos_InjectUtil_1_3_1;
	wire[7:0] zneg_ClockwiseUtil_1_3_1,zneg_CounterClockwiseUtil_1_3_1,zneg_InjectUtil_1_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_2, eject_xpos_ser_1_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_2, eject_xneg_ser_1_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_2, eject_ypos_ser_1_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_2, eject_yneg_ser_1_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_2, eject_zpos_ser_1_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_2, eject_zneg_ser_1_3_2;
	wire[7:0] xpos_ClockwiseUtil_1_3_2,xpos_CounterClockwiseUtil_1_3_2,xpos_InjectUtil_1_3_2;
	wire[7:0] xneg_ClockwiseUtil_1_3_2,xneg_CounterClockwiseUtil_1_3_2,xneg_InjectUtil_1_3_2;
	wire[7:0] ypos_ClockwiseUtil_1_3_2,ypos_CounterClockwiseUtil_1_3_2,ypos_InjectUtil_1_3_2;
	wire[7:0] yneg_ClockwiseUtil_1_3_2,yneg_CounterClockwiseUtil_1_3_2,yneg_InjectUtil_1_3_2;
	wire[7:0] zpos_ClockwiseUtil_1_3_2,zpos_CounterClockwiseUtil_1_3_2,zpos_InjectUtil_1_3_2;
	wire[7:0] zneg_ClockwiseUtil_1_3_2,zneg_CounterClockwiseUtil_1_3_2,zneg_InjectUtil_1_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_3, eject_xpos_ser_1_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_3, eject_xneg_ser_1_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_3, eject_ypos_ser_1_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_3, eject_yneg_ser_1_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_3, eject_zpos_ser_1_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_3, eject_zneg_ser_1_3_3;
	wire[7:0] xpos_ClockwiseUtil_1_3_3,xpos_CounterClockwiseUtil_1_3_3,xpos_InjectUtil_1_3_3;
	wire[7:0] xneg_ClockwiseUtil_1_3_3,xneg_CounterClockwiseUtil_1_3_3,xneg_InjectUtil_1_3_3;
	wire[7:0] ypos_ClockwiseUtil_1_3_3,ypos_CounterClockwiseUtil_1_3_3,ypos_InjectUtil_1_3_3;
	wire[7:0] yneg_ClockwiseUtil_1_3_3,yneg_CounterClockwiseUtil_1_3_3,yneg_InjectUtil_1_3_3;
	wire[7:0] zpos_ClockwiseUtil_1_3_3,zpos_CounterClockwiseUtil_1_3_3,zpos_InjectUtil_1_3_3;
	wire[7:0] zneg_ClockwiseUtil_1_3_3,zneg_CounterClockwiseUtil_1_3_3,zneg_InjectUtil_1_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_4, eject_xpos_ser_1_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_4, eject_xneg_ser_1_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_4, eject_ypos_ser_1_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_4, eject_yneg_ser_1_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_4, eject_zpos_ser_1_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_4, eject_zneg_ser_1_3_4;
	wire[7:0] xpos_ClockwiseUtil_1_3_4,xpos_CounterClockwiseUtil_1_3_4,xpos_InjectUtil_1_3_4;
	wire[7:0] xneg_ClockwiseUtil_1_3_4,xneg_CounterClockwiseUtil_1_3_4,xneg_InjectUtil_1_3_4;
	wire[7:0] ypos_ClockwiseUtil_1_3_4,ypos_CounterClockwiseUtil_1_3_4,ypos_InjectUtil_1_3_4;
	wire[7:0] yneg_ClockwiseUtil_1_3_4,yneg_CounterClockwiseUtil_1_3_4,yneg_InjectUtil_1_3_4;
	wire[7:0] zpos_ClockwiseUtil_1_3_4,zpos_CounterClockwiseUtil_1_3_4,zpos_InjectUtil_1_3_4;
	wire[7:0] zneg_ClockwiseUtil_1_3_4,zneg_CounterClockwiseUtil_1_3_4,zneg_InjectUtil_1_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_5, eject_xpos_ser_1_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_5, eject_xneg_ser_1_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_5, eject_ypos_ser_1_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_5, eject_yneg_ser_1_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_5, eject_zpos_ser_1_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_5, eject_zneg_ser_1_3_5;
	wire[7:0] xpos_ClockwiseUtil_1_3_5,xpos_CounterClockwiseUtil_1_3_5,xpos_InjectUtil_1_3_5;
	wire[7:0] xneg_ClockwiseUtil_1_3_5,xneg_CounterClockwiseUtil_1_3_5,xneg_InjectUtil_1_3_5;
	wire[7:0] ypos_ClockwiseUtil_1_3_5,ypos_CounterClockwiseUtil_1_3_5,ypos_InjectUtil_1_3_5;
	wire[7:0] yneg_ClockwiseUtil_1_3_5,yneg_CounterClockwiseUtil_1_3_5,yneg_InjectUtil_1_3_5;
	wire[7:0] zpos_ClockwiseUtil_1_3_5,zpos_CounterClockwiseUtil_1_3_5,zpos_InjectUtil_1_3_5;
	wire[7:0] zneg_ClockwiseUtil_1_3_5,zneg_CounterClockwiseUtil_1_3_5,zneg_InjectUtil_1_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_6, eject_xpos_ser_1_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_6, eject_xneg_ser_1_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_6, eject_ypos_ser_1_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_6, eject_yneg_ser_1_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_6, eject_zpos_ser_1_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_6, eject_zneg_ser_1_3_6;
	wire[7:0] xpos_ClockwiseUtil_1_3_6,xpos_CounterClockwiseUtil_1_3_6,xpos_InjectUtil_1_3_6;
	wire[7:0] xneg_ClockwiseUtil_1_3_6,xneg_CounterClockwiseUtil_1_3_6,xneg_InjectUtil_1_3_6;
	wire[7:0] ypos_ClockwiseUtil_1_3_6,ypos_CounterClockwiseUtil_1_3_6,ypos_InjectUtil_1_3_6;
	wire[7:0] yneg_ClockwiseUtil_1_3_6,yneg_CounterClockwiseUtil_1_3_6,yneg_InjectUtil_1_3_6;
	wire[7:0] zpos_ClockwiseUtil_1_3_6,zpos_CounterClockwiseUtil_1_3_6,zpos_InjectUtil_1_3_6;
	wire[7:0] zneg_ClockwiseUtil_1_3_6,zneg_CounterClockwiseUtil_1_3_6,zneg_InjectUtil_1_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_3_7, eject_xpos_ser_1_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_3_7, eject_xneg_ser_1_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_3_7, eject_ypos_ser_1_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_3_7, eject_yneg_ser_1_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_3_7, eject_zpos_ser_1_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_3_7, eject_zneg_ser_1_3_7;
	wire[7:0] xpos_ClockwiseUtil_1_3_7,xpos_CounterClockwiseUtil_1_3_7,xpos_InjectUtil_1_3_7;
	wire[7:0] xneg_ClockwiseUtil_1_3_7,xneg_CounterClockwiseUtil_1_3_7,xneg_InjectUtil_1_3_7;
	wire[7:0] ypos_ClockwiseUtil_1_3_7,ypos_CounterClockwiseUtil_1_3_7,ypos_InjectUtil_1_3_7;
	wire[7:0] yneg_ClockwiseUtil_1_3_7,yneg_CounterClockwiseUtil_1_3_7,yneg_InjectUtil_1_3_7;
	wire[7:0] zpos_ClockwiseUtil_1_3_7,zpos_CounterClockwiseUtil_1_3_7,zpos_InjectUtil_1_3_7;
	wire[7:0] zneg_ClockwiseUtil_1_3_7,zneg_CounterClockwiseUtil_1_3_7,zneg_InjectUtil_1_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_0, eject_xpos_ser_1_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_0, eject_xneg_ser_1_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_0, eject_ypos_ser_1_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_0, eject_yneg_ser_1_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_0, eject_zpos_ser_1_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_0, eject_zneg_ser_1_4_0;
	wire[7:0] xpos_ClockwiseUtil_1_4_0,xpos_CounterClockwiseUtil_1_4_0,xpos_InjectUtil_1_4_0;
	wire[7:0] xneg_ClockwiseUtil_1_4_0,xneg_CounterClockwiseUtil_1_4_0,xneg_InjectUtil_1_4_0;
	wire[7:0] ypos_ClockwiseUtil_1_4_0,ypos_CounterClockwiseUtil_1_4_0,ypos_InjectUtil_1_4_0;
	wire[7:0] yneg_ClockwiseUtil_1_4_0,yneg_CounterClockwiseUtil_1_4_0,yneg_InjectUtil_1_4_0;
	wire[7:0] zpos_ClockwiseUtil_1_4_0,zpos_CounterClockwiseUtil_1_4_0,zpos_InjectUtil_1_4_0;
	wire[7:0] zneg_ClockwiseUtil_1_4_0,zneg_CounterClockwiseUtil_1_4_0,zneg_InjectUtil_1_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_1, eject_xpos_ser_1_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_1, eject_xneg_ser_1_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_1, eject_ypos_ser_1_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_1, eject_yneg_ser_1_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_1, eject_zpos_ser_1_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_1, eject_zneg_ser_1_4_1;
	wire[7:0] xpos_ClockwiseUtil_1_4_1,xpos_CounterClockwiseUtil_1_4_1,xpos_InjectUtil_1_4_1;
	wire[7:0] xneg_ClockwiseUtil_1_4_1,xneg_CounterClockwiseUtil_1_4_1,xneg_InjectUtil_1_4_1;
	wire[7:0] ypos_ClockwiseUtil_1_4_1,ypos_CounterClockwiseUtil_1_4_1,ypos_InjectUtil_1_4_1;
	wire[7:0] yneg_ClockwiseUtil_1_4_1,yneg_CounterClockwiseUtil_1_4_1,yneg_InjectUtil_1_4_1;
	wire[7:0] zpos_ClockwiseUtil_1_4_1,zpos_CounterClockwiseUtil_1_4_1,zpos_InjectUtil_1_4_1;
	wire[7:0] zneg_ClockwiseUtil_1_4_1,zneg_CounterClockwiseUtil_1_4_1,zneg_InjectUtil_1_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_2, eject_xpos_ser_1_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_2, eject_xneg_ser_1_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_2, eject_ypos_ser_1_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_2, eject_yneg_ser_1_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_2, eject_zpos_ser_1_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_2, eject_zneg_ser_1_4_2;
	wire[7:0] xpos_ClockwiseUtil_1_4_2,xpos_CounterClockwiseUtil_1_4_2,xpos_InjectUtil_1_4_2;
	wire[7:0] xneg_ClockwiseUtil_1_4_2,xneg_CounterClockwiseUtil_1_4_2,xneg_InjectUtil_1_4_2;
	wire[7:0] ypos_ClockwiseUtil_1_4_2,ypos_CounterClockwiseUtil_1_4_2,ypos_InjectUtil_1_4_2;
	wire[7:0] yneg_ClockwiseUtil_1_4_2,yneg_CounterClockwiseUtil_1_4_2,yneg_InjectUtil_1_4_2;
	wire[7:0] zpos_ClockwiseUtil_1_4_2,zpos_CounterClockwiseUtil_1_4_2,zpos_InjectUtil_1_4_2;
	wire[7:0] zneg_ClockwiseUtil_1_4_2,zneg_CounterClockwiseUtil_1_4_2,zneg_InjectUtil_1_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_3, eject_xpos_ser_1_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_3, eject_xneg_ser_1_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_3, eject_ypos_ser_1_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_3, eject_yneg_ser_1_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_3, eject_zpos_ser_1_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_3, eject_zneg_ser_1_4_3;
	wire[7:0] xpos_ClockwiseUtil_1_4_3,xpos_CounterClockwiseUtil_1_4_3,xpos_InjectUtil_1_4_3;
	wire[7:0] xneg_ClockwiseUtil_1_4_3,xneg_CounterClockwiseUtil_1_4_3,xneg_InjectUtil_1_4_3;
	wire[7:0] ypos_ClockwiseUtil_1_4_3,ypos_CounterClockwiseUtil_1_4_3,ypos_InjectUtil_1_4_3;
	wire[7:0] yneg_ClockwiseUtil_1_4_3,yneg_CounterClockwiseUtil_1_4_3,yneg_InjectUtil_1_4_3;
	wire[7:0] zpos_ClockwiseUtil_1_4_3,zpos_CounterClockwiseUtil_1_4_3,zpos_InjectUtil_1_4_3;
	wire[7:0] zneg_ClockwiseUtil_1_4_3,zneg_CounterClockwiseUtil_1_4_3,zneg_InjectUtil_1_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_4, eject_xpos_ser_1_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_4, eject_xneg_ser_1_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_4, eject_ypos_ser_1_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_4, eject_yneg_ser_1_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_4, eject_zpos_ser_1_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_4, eject_zneg_ser_1_4_4;
	wire[7:0] xpos_ClockwiseUtil_1_4_4,xpos_CounterClockwiseUtil_1_4_4,xpos_InjectUtil_1_4_4;
	wire[7:0] xneg_ClockwiseUtil_1_4_4,xneg_CounterClockwiseUtil_1_4_4,xneg_InjectUtil_1_4_4;
	wire[7:0] ypos_ClockwiseUtil_1_4_4,ypos_CounterClockwiseUtil_1_4_4,ypos_InjectUtil_1_4_4;
	wire[7:0] yneg_ClockwiseUtil_1_4_4,yneg_CounterClockwiseUtil_1_4_4,yneg_InjectUtil_1_4_4;
	wire[7:0] zpos_ClockwiseUtil_1_4_4,zpos_CounterClockwiseUtil_1_4_4,zpos_InjectUtil_1_4_4;
	wire[7:0] zneg_ClockwiseUtil_1_4_4,zneg_CounterClockwiseUtil_1_4_4,zneg_InjectUtil_1_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_5, eject_xpos_ser_1_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_5, eject_xneg_ser_1_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_5, eject_ypos_ser_1_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_5, eject_yneg_ser_1_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_5, eject_zpos_ser_1_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_5, eject_zneg_ser_1_4_5;
	wire[7:0] xpos_ClockwiseUtil_1_4_5,xpos_CounterClockwiseUtil_1_4_5,xpos_InjectUtil_1_4_5;
	wire[7:0] xneg_ClockwiseUtil_1_4_5,xneg_CounterClockwiseUtil_1_4_5,xneg_InjectUtil_1_4_5;
	wire[7:0] ypos_ClockwiseUtil_1_4_5,ypos_CounterClockwiseUtil_1_4_5,ypos_InjectUtil_1_4_5;
	wire[7:0] yneg_ClockwiseUtil_1_4_5,yneg_CounterClockwiseUtil_1_4_5,yneg_InjectUtil_1_4_5;
	wire[7:0] zpos_ClockwiseUtil_1_4_5,zpos_CounterClockwiseUtil_1_4_5,zpos_InjectUtil_1_4_5;
	wire[7:0] zneg_ClockwiseUtil_1_4_5,zneg_CounterClockwiseUtil_1_4_5,zneg_InjectUtil_1_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_6, eject_xpos_ser_1_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_6, eject_xneg_ser_1_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_6, eject_ypos_ser_1_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_6, eject_yneg_ser_1_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_6, eject_zpos_ser_1_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_6, eject_zneg_ser_1_4_6;
	wire[7:0] xpos_ClockwiseUtil_1_4_6,xpos_CounterClockwiseUtil_1_4_6,xpos_InjectUtil_1_4_6;
	wire[7:0] xneg_ClockwiseUtil_1_4_6,xneg_CounterClockwiseUtil_1_4_6,xneg_InjectUtil_1_4_6;
	wire[7:0] ypos_ClockwiseUtil_1_4_6,ypos_CounterClockwiseUtil_1_4_6,ypos_InjectUtil_1_4_6;
	wire[7:0] yneg_ClockwiseUtil_1_4_6,yneg_CounterClockwiseUtil_1_4_6,yneg_InjectUtil_1_4_6;
	wire[7:0] zpos_ClockwiseUtil_1_4_6,zpos_CounterClockwiseUtil_1_4_6,zpos_InjectUtil_1_4_6;
	wire[7:0] zneg_ClockwiseUtil_1_4_6,zneg_CounterClockwiseUtil_1_4_6,zneg_InjectUtil_1_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_4_7, eject_xpos_ser_1_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_4_7, eject_xneg_ser_1_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_4_7, eject_ypos_ser_1_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_4_7, eject_yneg_ser_1_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_4_7, eject_zpos_ser_1_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_4_7, eject_zneg_ser_1_4_7;
	wire[7:0] xpos_ClockwiseUtil_1_4_7,xpos_CounterClockwiseUtil_1_4_7,xpos_InjectUtil_1_4_7;
	wire[7:0] xneg_ClockwiseUtil_1_4_7,xneg_CounterClockwiseUtil_1_4_7,xneg_InjectUtil_1_4_7;
	wire[7:0] ypos_ClockwiseUtil_1_4_7,ypos_CounterClockwiseUtil_1_4_7,ypos_InjectUtil_1_4_7;
	wire[7:0] yneg_ClockwiseUtil_1_4_7,yneg_CounterClockwiseUtil_1_4_7,yneg_InjectUtil_1_4_7;
	wire[7:0] zpos_ClockwiseUtil_1_4_7,zpos_CounterClockwiseUtil_1_4_7,zpos_InjectUtil_1_4_7;
	wire[7:0] zneg_ClockwiseUtil_1_4_7,zneg_CounterClockwiseUtil_1_4_7,zneg_InjectUtil_1_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_0, eject_xpos_ser_1_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_0, eject_xneg_ser_1_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_0, eject_ypos_ser_1_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_0, eject_yneg_ser_1_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_0, eject_zpos_ser_1_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_0, eject_zneg_ser_1_5_0;
	wire[7:0] xpos_ClockwiseUtil_1_5_0,xpos_CounterClockwiseUtil_1_5_0,xpos_InjectUtil_1_5_0;
	wire[7:0] xneg_ClockwiseUtil_1_5_0,xneg_CounterClockwiseUtil_1_5_0,xneg_InjectUtil_1_5_0;
	wire[7:0] ypos_ClockwiseUtil_1_5_0,ypos_CounterClockwiseUtil_1_5_0,ypos_InjectUtil_1_5_0;
	wire[7:0] yneg_ClockwiseUtil_1_5_0,yneg_CounterClockwiseUtil_1_5_0,yneg_InjectUtil_1_5_0;
	wire[7:0] zpos_ClockwiseUtil_1_5_0,zpos_CounterClockwiseUtil_1_5_0,zpos_InjectUtil_1_5_0;
	wire[7:0] zneg_ClockwiseUtil_1_5_0,zneg_CounterClockwiseUtil_1_5_0,zneg_InjectUtil_1_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_1, eject_xpos_ser_1_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_1, eject_xneg_ser_1_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_1, eject_ypos_ser_1_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_1, eject_yneg_ser_1_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_1, eject_zpos_ser_1_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_1, eject_zneg_ser_1_5_1;
	wire[7:0] xpos_ClockwiseUtil_1_5_1,xpos_CounterClockwiseUtil_1_5_1,xpos_InjectUtil_1_5_1;
	wire[7:0] xneg_ClockwiseUtil_1_5_1,xneg_CounterClockwiseUtil_1_5_1,xneg_InjectUtil_1_5_1;
	wire[7:0] ypos_ClockwiseUtil_1_5_1,ypos_CounterClockwiseUtil_1_5_1,ypos_InjectUtil_1_5_1;
	wire[7:0] yneg_ClockwiseUtil_1_5_1,yneg_CounterClockwiseUtil_1_5_1,yneg_InjectUtil_1_5_1;
	wire[7:0] zpos_ClockwiseUtil_1_5_1,zpos_CounterClockwiseUtil_1_5_1,zpos_InjectUtil_1_5_1;
	wire[7:0] zneg_ClockwiseUtil_1_5_1,zneg_CounterClockwiseUtil_1_5_1,zneg_InjectUtil_1_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_2, eject_xpos_ser_1_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_2, eject_xneg_ser_1_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_2, eject_ypos_ser_1_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_2, eject_yneg_ser_1_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_2, eject_zpos_ser_1_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_2, eject_zneg_ser_1_5_2;
	wire[7:0] xpos_ClockwiseUtil_1_5_2,xpos_CounterClockwiseUtil_1_5_2,xpos_InjectUtil_1_5_2;
	wire[7:0] xneg_ClockwiseUtil_1_5_2,xneg_CounterClockwiseUtil_1_5_2,xneg_InjectUtil_1_5_2;
	wire[7:0] ypos_ClockwiseUtil_1_5_2,ypos_CounterClockwiseUtil_1_5_2,ypos_InjectUtil_1_5_2;
	wire[7:0] yneg_ClockwiseUtil_1_5_2,yneg_CounterClockwiseUtil_1_5_2,yneg_InjectUtil_1_5_2;
	wire[7:0] zpos_ClockwiseUtil_1_5_2,zpos_CounterClockwiseUtil_1_5_2,zpos_InjectUtil_1_5_2;
	wire[7:0] zneg_ClockwiseUtil_1_5_2,zneg_CounterClockwiseUtil_1_5_2,zneg_InjectUtil_1_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_3, eject_xpos_ser_1_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_3, eject_xneg_ser_1_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_3, eject_ypos_ser_1_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_3, eject_yneg_ser_1_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_3, eject_zpos_ser_1_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_3, eject_zneg_ser_1_5_3;
	wire[7:0] xpos_ClockwiseUtil_1_5_3,xpos_CounterClockwiseUtil_1_5_3,xpos_InjectUtil_1_5_3;
	wire[7:0] xneg_ClockwiseUtil_1_5_3,xneg_CounterClockwiseUtil_1_5_3,xneg_InjectUtil_1_5_3;
	wire[7:0] ypos_ClockwiseUtil_1_5_3,ypos_CounterClockwiseUtil_1_5_3,ypos_InjectUtil_1_5_3;
	wire[7:0] yneg_ClockwiseUtil_1_5_3,yneg_CounterClockwiseUtil_1_5_3,yneg_InjectUtil_1_5_3;
	wire[7:0] zpos_ClockwiseUtil_1_5_3,zpos_CounterClockwiseUtil_1_5_3,zpos_InjectUtil_1_5_3;
	wire[7:0] zneg_ClockwiseUtil_1_5_3,zneg_CounterClockwiseUtil_1_5_3,zneg_InjectUtil_1_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_4, eject_xpos_ser_1_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_4, eject_xneg_ser_1_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_4, eject_ypos_ser_1_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_4, eject_yneg_ser_1_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_4, eject_zpos_ser_1_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_4, eject_zneg_ser_1_5_4;
	wire[7:0] xpos_ClockwiseUtil_1_5_4,xpos_CounterClockwiseUtil_1_5_4,xpos_InjectUtil_1_5_4;
	wire[7:0] xneg_ClockwiseUtil_1_5_4,xneg_CounterClockwiseUtil_1_5_4,xneg_InjectUtil_1_5_4;
	wire[7:0] ypos_ClockwiseUtil_1_5_4,ypos_CounterClockwiseUtil_1_5_4,ypos_InjectUtil_1_5_4;
	wire[7:0] yneg_ClockwiseUtil_1_5_4,yneg_CounterClockwiseUtil_1_5_4,yneg_InjectUtil_1_5_4;
	wire[7:0] zpos_ClockwiseUtil_1_5_4,zpos_CounterClockwiseUtil_1_5_4,zpos_InjectUtil_1_5_4;
	wire[7:0] zneg_ClockwiseUtil_1_5_4,zneg_CounterClockwiseUtil_1_5_4,zneg_InjectUtil_1_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_5, eject_xpos_ser_1_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_5, eject_xneg_ser_1_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_5, eject_ypos_ser_1_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_5, eject_yneg_ser_1_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_5, eject_zpos_ser_1_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_5, eject_zneg_ser_1_5_5;
	wire[7:0] xpos_ClockwiseUtil_1_5_5,xpos_CounterClockwiseUtil_1_5_5,xpos_InjectUtil_1_5_5;
	wire[7:0] xneg_ClockwiseUtil_1_5_5,xneg_CounterClockwiseUtil_1_5_5,xneg_InjectUtil_1_5_5;
	wire[7:0] ypos_ClockwiseUtil_1_5_5,ypos_CounterClockwiseUtil_1_5_5,ypos_InjectUtil_1_5_5;
	wire[7:0] yneg_ClockwiseUtil_1_5_5,yneg_CounterClockwiseUtil_1_5_5,yneg_InjectUtil_1_5_5;
	wire[7:0] zpos_ClockwiseUtil_1_5_5,zpos_CounterClockwiseUtil_1_5_5,zpos_InjectUtil_1_5_5;
	wire[7:0] zneg_ClockwiseUtil_1_5_5,zneg_CounterClockwiseUtil_1_5_5,zneg_InjectUtil_1_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_6, eject_xpos_ser_1_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_6, eject_xneg_ser_1_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_6, eject_ypos_ser_1_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_6, eject_yneg_ser_1_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_6, eject_zpos_ser_1_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_6, eject_zneg_ser_1_5_6;
	wire[7:0] xpos_ClockwiseUtil_1_5_6,xpos_CounterClockwiseUtil_1_5_6,xpos_InjectUtil_1_5_6;
	wire[7:0] xneg_ClockwiseUtil_1_5_6,xneg_CounterClockwiseUtil_1_5_6,xneg_InjectUtil_1_5_6;
	wire[7:0] ypos_ClockwiseUtil_1_5_6,ypos_CounterClockwiseUtil_1_5_6,ypos_InjectUtil_1_5_6;
	wire[7:0] yneg_ClockwiseUtil_1_5_6,yneg_CounterClockwiseUtil_1_5_6,yneg_InjectUtil_1_5_6;
	wire[7:0] zpos_ClockwiseUtil_1_5_6,zpos_CounterClockwiseUtil_1_5_6,zpos_InjectUtil_1_5_6;
	wire[7:0] zneg_ClockwiseUtil_1_5_6,zneg_CounterClockwiseUtil_1_5_6,zneg_InjectUtil_1_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_5_7, eject_xpos_ser_1_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_5_7, eject_xneg_ser_1_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_5_7, eject_ypos_ser_1_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_5_7, eject_yneg_ser_1_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_5_7, eject_zpos_ser_1_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_5_7, eject_zneg_ser_1_5_7;
	wire[7:0] xpos_ClockwiseUtil_1_5_7,xpos_CounterClockwiseUtil_1_5_7,xpos_InjectUtil_1_5_7;
	wire[7:0] xneg_ClockwiseUtil_1_5_7,xneg_CounterClockwiseUtil_1_5_7,xneg_InjectUtil_1_5_7;
	wire[7:0] ypos_ClockwiseUtil_1_5_7,ypos_CounterClockwiseUtil_1_5_7,ypos_InjectUtil_1_5_7;
	wire[7:0] yneg_ClockwiseUtil_1_5_7,yneg_CounterClockwiseUtil_1_5_7,yneg_InjectUtil_1_5_7;
	wire[7:0] zpos_ClockwiseUtil_1_5_7,zpos_CounterClockwiseUtil_1_5_7,zpos_InjectUtil_1_5_7;
	wire[7:0] zneg_ClockwiseUtil_1_5_7,zneg_CounterClockwiseUtil_1_5_7,zneg_InjectUtil_1_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_0, eject_xpos_ser_1_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_0, eject_xneg_ser_1_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_0, eject_ypos_ser_1_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_0, eject_yneg_ser_1_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_0, eject_zpos_ser_1_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_0, eject_zneg_ser_1_6_0;
	wire[7:0] xpos_ClockwiseUtil_1_6_0,xpos_CounterClockwiseUtil_1_6_0,xpos_InjectUtil_1_6_0;
	wire[7:0] xneg_ClockwiseUtil_1_6_0,xneg_CounterClockwiseUtil_1_6_0,xneg_InjectUtil_1_6_0;
	wire[7:0] ypos_ClockwiseUtil_1_6_0,ypos_CounterClockwiseUtil_1_6_0,ypos_InjectUtil_1_6_0;
	wire[7:0] yneg_ClockwiseUtil_1_6_0,yneg_CounterClockwiseUtil_1_6_0,yneg_InjectUtil_1_6_0;
	wire[7:0] zpos_ClockwiseUtil_1_6_0,zpos_CounterClockwiseUtil_1_6_0,zpos_InjectUtil_1_6_0;
	wire[7:0] zneg_ClockwiseUtil_1_6_0,zneg_CounterClockwiseUtil_1_6_0,zneg_InjectUtil_1_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_1, eject_xpos_ser_1_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_1, eject_xneg_ser_1_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_1, eject_ypos_ser_1_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_1, eject_yneg_ser_1_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_1, eject_zpos_ser_1_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_1, eject_zneg_ser_1_6_1;
	wire[7:0] xpos_ClockwiseUtil_1_6_1,xpos_CounterClockwiseUtil_1_6_1,xpos_InjectUtil_1_6_1;
	wire[7:0] xneg_ClockwiseUtil_1_6_1,xneg_CounterClockwiseUtil_1_6_1,xneg_InjectUtil_1_6_1;
	wire[7:0] ypos_ClockwiseUtil_1_6_1,ypos_CounterClockwiseUtil_1_6_1,ypos_InjectUtil_1_6_1;
	wire[7:0] yneg_ClockwiseUtil_1_6_1,yneg_CounterClockwiseUtil_1_6_1,yneg_InjectUtil_1_6_1;
	wire[7:0] zpos_ClockwiseUtil_1_6_1,zpos_CounterClockwiseUtil_1_6_1,zpos_InjectUtil_1_6_1;
	wire[7:0] zneg_ClockwiseUtil_1_6_1,zneg_CounterClockwiseUtil_1_6_1,zneg_InjectUtil_1_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_2, eject_xpos_ser_1_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_2, eject_xneg_ser_1_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_2, eject_ypos_ser_1_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_2, eject_yneg_ser_1_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_2, eject_zpos_ser_1_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_2, eject_zneg_ser_1_6_2;
	wire[7:0] xpos_ClockwiseUtil_1_6_2,xpos_CounterClockwiseUtil_1_6_2,xpos_InjectUtil_1_6_2;
	wire[7:0] xneg_ClockwiseUtil_1_6_2,xneg_CounterClockwiseUtil_1_6_2,xneg_InjectUtil_1_6_2;
	wire[7:0] ypos_ClockwiseUtil_1_6_2,ypos_CounterClockwiseUtil_1_6_2,ypos_InjectUtil_1_6_2;
	wire[7:0] yneg_ClockwiseUtil_1_6_2,yneg_CounterClockwiseUtil_1_6_2,yneg_InjectUtil_1_6_2;
	wire[7:0] zpos_ClockwiseUtil_1_6_2,zpos_CounterClockwiseUtil_1_6_2,zpos_InjectUtil_1_6_2;
	wire[7:0] zneg_ClockwiseUtil_1_6_2,zneg_CounterClockwiseUtil_1_6_2,zneg_InjectUtil_1_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_3, eject_xpos_ser_1_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_3, eject_xneg_ser_1_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_3, eject_ypos_ser_1_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_3, eject_yneg_ser_1_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_3, eject_zpos_ser_1_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_3, eject_zneg_ser_1_6_3;
	wire[7:0] xpos_ClockwiseUtil_1_6_3,xpos_CounterClockwiseUtil_1_6_3,xpos_InjectUtil_1_6_3;
	wire[7:0] xneg_ClockwiseUtil_1_6_3,xneg_CounterClockwiseUtil_1_6_3,xneg_InjectUtil_1_6_3;
	wire[7:0] ypos_ClockwiseUtil_1_6_3,ypos_CounterClockwiseUtil_1_6_3,ypos_InjectUtil_1_6_3;
	wire[7:0] yneg_ClockwiseUtil_1_6_3,yneg_CounterClockwiseUtil_1_6_3,yneg_InjectUtil_1_6_3;
	wire[7:0] zpos_ClockwiseUtil_1_6_3,zpos_CounterClockwiseUtil_1_6_3,zpos_InjectUtil_1_6_3;
	wire[7:0] zneg_ClockwiseUtil_1_6_3,zneg_CounterClockwiseUtil_1_6_3,zneg_InjectUtil_1_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_4, eject_xpos_ser_1_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_4, eject_xneg_ser_1_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_4, eject_ypos_ser_1_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_4, eject_yneg_ser_1_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_4, eject_zpos_ser_1_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_4, eject_zneg_ser_1_6_4;
	wire[7:0] xpos_ClockwiseUtil_1_6_4,xpos_CounterClockwiseUtil_1_6_4,xpos_InjectUtil_1_6_4;
	wire[7:0] xneg_ClockwiseUtil_1_6_4,xneg_CounterClockwiseUtil_1_6_4,xneg_InjectUtil_1_6_4;
	wire[7:0] ypos_ClockwiseUtil_1_6_4,ypos_CounterClockwiseUtil_1_6_4,ypos_InjectUtil_1_6_4;
	wire[7:0] yneg_ClockwiseUtil_1_6_4,yneg_CounterClockwiseUtil_1_6_4,yneg_InjectUtil_1_6_4;
	wire[7:0] zpos_ClockwiseUtil_1_6_4,zpos_CounterClockwiseUtil_1_6_4,zpos_InjectUtil_1_6_4;
	wire[7:0] zneg_ClockwiseUtil_1_6_4,zneg_CounterClockwiseUtil_1_6_4,zneg_InjectUtil_1_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_5, eject_xpos_ser_1_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_5, eject_xneg_ser_1_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_5, eject_ypos_ser_1_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_5, eject_yneg_ser_1_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_5, eject_zpos_ser_1_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_5, eject_zneg_ser_1_6_5;
	wire[7:0] xpos_ClockwiseUtil_1_6_5,xpos_CounterClockwiseUtil_1_6_5,xpos_InjectUtil_1_6_5;
	wire[7:0] xneg_ClockwiseUtil_1_6_5,xneg_CounterClockwiseUtil_1_6_5,xneg_InjectUtil_1_6_5;
	wire[7:0] ypos_ClockwiseUtil_1_6_5,ypos_CounterClockwiseUtil_1_6_5,ypos_InjectUtil_1_6_5;
	wire[7:0] yneg_ClockwiseUtil_1_6_5,yneg_CounterClockwiseUtil_1_6_5,yneg_InjectUtil_1_6_5;
	wire[7:0] zpos_ClockwiseUtil_1_6_5,zpos_CounterClockwiseUtil_1_6_5,zpos_InjectUtil_1_6_5;
	wire[7:0] zneg_ClockwiseUtil_1_6_5,zneg_CounterClockwiseUtil_1_6_5,zneg_InjectUtil_1_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_6, eject_xpos_ser_1_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_6, eject_xneg_ser_1_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_6, eject_ypos_ser_1_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_6, eject_yneg_ser_1_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_6, eject_zpos_ser_1_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_6, eject_zneg_ser_1_6_6;
	wire[7:0] xpos_ClockwiseUtil_1_6_6,xpos_CounterClockwiseUtil_1_6_6,xpos_InjectUtil_1_6_6;
	wire[7:0] xneg_ClockwiseUtil_1_6_6,xneg_CounterClockwiseUtil_1_6_6,xneg_InjectUtil_1_6_6;
	wire[7:0] ypos_ClockwiseUtil_1_6_6,ypos_CounterClockwiseUtil_1_6_6,ypos_InjectUtil_1_6_6;
	wire[7:0] yneg_ClockwiseUtil_1_6_6,yneg_CounterClockwiseUtil_1_6_6,yneg_InjectUtil_1_6_6;
	wire[7:0] zpos_ClockwiseUtil_1_6_6,zpos_CounterClockwiseUtil_1_6_6,zpos_InjectUtil_1_6_6;
	wire[7:0] zneg_ClockwiseUtil_1_6_6,zneg_CounterClockwiseUtil_1_6_6,zneg_InjectUtil_1_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_6_7, eject_xpos_ser_1_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_6_7, eject_xneg_ser_1_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_6_7, eject_ypos_ser_1_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_6_7, eject_yneg_ser_1_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_6_7, eject_zpos_ser_1_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_6_7, eject_zneg_ser_1_6_7;
	wire[7:0] xpos_ClockwiseUtil_1_6_7,xpos_CounterClockwiseUtil_1_6_7,xpos_InjectUtil_1_6_7;
	wire[7:0] xneg_ClockwiseUtil_1_6_7,xneg_CounterClockwiseUtil_1_6_7,xneg_InjectUtil_1_6_7;
	wire[7:0] ypos_ClockwiseUtil_1_6_7,ypos_CounterClockwiseUtil_1_6_7,ypos_InjectUtil_1_6_7;
	wire[7:0] yneg_ClockwiseUtil_1_6_7,yneg_CounterClockwiseUtil_1_6_7,yneg_InjectUtil_1_6_7;
	wire[7:0] zpos_ClockwiseUtil_1_6_7,zpos_CounterClockwiseUtil_1_6_7,zpos_InjectUtil_1_6_7;
	wire[7:0] zneg_ClockwiseUtil_1_6_7,zneg_CounterClockwiseUtil_1_6_7,zneg_InjectUtil_1_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_0, eject_xpos_ser_1_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_0, eject_xneg_ser_1_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_0, eject_ypos_ser_1_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_0, eject_yneg_ser_1_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_0, eject_zpos_ser_1_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_0, eject_zneg_ser_1_7_0;
	wire[7:0] xpos_ClockwiseUtil_1_7_0,xpos_CounterClockwiseUtil_1_7_0,xpos_InjectUtil_1_7_0;
	wire[7:0] xneg_ClockwiseUtil_1_7_0,xneg_CounterClockwiseUtil_1_7_0,xneg_InjectUtil_1_7_0;
	wire[7:0] ypos_ClockwiseUtil_1_7_0,ypos_CounterClockwiseUtil_1_7_0,ypos_InjectUtil_1_7_0;
	wire[7:0] yneg_ClockwiseUtil_1_7_0,yneg_CounterClockwiseUtil_1_7_0,yneg_InjectUtil_1_7_0;
	wire[7:0] zpos_ClockwiseUtil_1_7_0,zpos_CounterClockwiseUtil_1_7_0,zpos_InjectUtil_1_7_0;
	wire[7:0] zneg_ClockwiseUtil_1_7_0,zneg_CounterClockwiseUtil_1_7_0,zneg_InjectUtil_1_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_1, eject_xpos_ser_1_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_1, eject_xneg_ser_1_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_1, eject_ypos_ser_1_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_1, eject_yneg_ser_1_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_1, eject_zpos_ser_1_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_1, eject_zneg_ser_1_7_1;
	wire[7:0] xpos_ClockwiseUtil_1_7_1,xpos_CounterClockwiseUtil_1_7_1,xpos_InjectUtil_1_7_1;
	wire[7:0] xneg_ClockwiseUtil_1_7_1,xneg_CounterClockwiseUtil_1_7_1,xneg_InjectUtil_1_7_1;
	wire[7:0] ypos_ClockwiseUtil_1_7_1,ypos_CounterClockwiseUtil_1_7_1,ypos_InjectUtil_1_7_1;
	wire[7:0] yneg_ClockwiseUtil_1_7_1,yneg_CounterClockwiseUtil_1_7_1,yneg_InjectUtil_1_7_1;
	wire[7:0] zpos_ClockwiseUtil_1_7_1,zpos_CounterClockwiseUtil_1_7_1,zpos_InjectUtil_1_7_1;
	wire[7:0] zneg_ClockwiseUtil_1_7_1,zneg_CounterClockwiseUtil_1_7_1,zneg_InjectUtil_1_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_2, eject_xpos_ser_1_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_2, eject_xneg_ser_1_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_2, eject_ypos_ser_1_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_2, eject_yneg_ser_1_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_2, eject_zpos_ser_1_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_2, eject_zneg_ser_1_7_2;
	wire[7:0] xpos_ClockwiseUtil_1_7_2,xpos_CounterClockwiseUtil_1_7_2,xpos_InjectUtil_1_7_2;
	wire[7:0] xneg_ClockwiseUtil_1_7_2,xneg_CounterClockwiseUtil_1_7_2,xneg_InjectUtil_1_7_2;
	wire[7:0] ypos_ClockwiseUtil_1_7_2,ypos_CounterClockwiseUtil_1_7_2,ypos_InjectUtil_1_7_2;
	wire[7:0] yneg_ClockwiseUtil_1_7_2,yneg_CounterClockwiseUtil_1_7_2,yneg_InjectUtil_1_7_2;
	wire[7:0] zpos_ClockwiseUtil_1_7_2,zpos_CounterClockwiseUtil_1_7_2,zpos_InjectUtil_1_7_2;
	wire[7:0] zneg_ClockwiseUtil_1_7_2,zneg_CounterClockwiseUtil_1_7_2,zneg_InjectUtil_1_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_3, eject_xpos_ser_1_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_3, eject_xneg_ser_1_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_3, eject_ypos_ser_1_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_3, eject_yneg_ser_1_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_3, eject_zpos_ser_1_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_3, eject_zneg_ser_1_7_3;
	wire[7:0] xpos_ClockwiseUtil_1_7_3,xpos_CounterClockwiseUtil_1_7_3,xpos_InjectUtil_1_7_3;
	wire[7:0] xneg_ClockwiseUtil_1_7_3,xneg_CounterClockwiseUtil_1_7_3,xneg_InjectUtil_1_7_3;
	wire[7:0] ypos_ClockwiseUtil_1_7_3,ypos_CounterClockwiseUtil_1_7_3,ypos_InjectUtil_1_7_3;
	wire[7:0] yneg_ClockwiseUtil_1_7_3,yneg_CounterClockwiseUtil_1_7_3,yneg_InjectUtil_1_7_3;
	wire[7:0] zpos_ClockwiseUtil_1_7_3,zpos_CounterClockwiseUtil_1_7_3,zpos_InjectUtil_1_7_3;
	wire[7:0] zneg_ClockwiseUtil_1_7_3,zneg_CounterClockwiseUtil_1_7_3,zneg_InjectUtil_1_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_4, eject_xpos_ser_1_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_4, eject_xneg_ser_1_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_4, eject_ypos_ser_1_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_4, eject_yneg_ser_1_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_4, eject_zpos_ser_1_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_4, eject_zneg_ser_1_7_4;
	wire[7:0] xpos_ClockwiseUtil_1_7_4,xpos_CounterClockwiseUtil_1_7_4,xpos_InjectUtil_1_7_4;
	wire[7:0] xneg_ClockwiseUtil_1_7_4,xneg_CounterClockwiseUtil_1_7_4,xneg_InjectUtil_1_7_4;
	wire[7:0] ypos_ClockwiseUtil_1_7_4,ypos_CounterClockwiseUtil_1_7_4,ypos_InjectUtil_1_7_4;
	wire[7:0] yneg_ClockwiseUtil_1_7_4,yneg_CounterClockwiseUtil_1_7_4,yneg_InjectUtil_1_7_4;
	wire[7:0] zpos_ClockwiseUtil_1_7_4,zpos_CounterClockwiseUtil_1_7_4,zpos_InjectUtil_1_7_4;
	wire[7:0] zneg_ClockwiseUtil_1_7_4,zneg_CounterClockwiseUtil_1_7_4,zneg_InjectUtil_1_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_5, eject_xpos_ser_1_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_5, eject_xneg_ser_1_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_5, eject_ypos_ser_1_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_5, eject_yneg_ser_1_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_5, eject_zpos_ser_1_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_5, eject_zneg_ser_1_7_5;
	wire[7:0] xpos_ClockwiseUtil_1_7_5,xpos_CounterClockwiseUtil_1_7_5,xpos_InjectUtil_1_7_5;
	wire[7:0] xneg_ClockwiseUtil_1_7_5,xneg_CounterClockwiseUtil_1_7_5,xneg_InjectUtil_1_7_5;
	wire[7:0] ypos_ClockwiseUtil_1_7_5,ypos_CounterClockwiseUtil_1_7_5,ypos_InjectUtil_1_7_5;
	wire[7:0] yneg_ClockwiseUtil_1_7_5,yneg_CounterClockwiseUtil_1_7_5,yneg_InjectUtil_1_7_5;
	wire[7:0] zpos_ClockwiseUtil_1_7_5,zpos_CounterClockwiseUtil_1_7_5,zpos_InjectUtil_1_7_5;
	wire[7:0] zneg_ClockwiseUtil_1_7_5,zneg_CounterClockwiseUtil_1_7_5,zneg_InjectUtil_1_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_6, eject_xpos_ser_1_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_6, eject_xneg_ser_1_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_6, eject_ypos_ser_1_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_6, eject_yneg_ser_1_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_6, eject_zpos_ser_1_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_6, eject_zneg_ser_1_7_6;
	wire[7:0] xpos_ClockwiseUtil_1_7_6,xpos_CounterClockwiseUtil_1_7_6,xpos_InjectUtil_1_7_6;
	wire[7:0] xneg_ClockwiseUtil_1_7_6,xneg_CounterClockwiseUtil_1_7_6,xneg_InjectUtil_1_7_6;
	wire[7:0] ypos_ClockwiseUtil_1_7_6,ypos_CounterClockwiseUtil_1_7_6,ypos_InjectUtil_1_7_6;
	wire[7:0] yneg_ClockwiseUtil_1_7_6,yneg_CounterClockwiseUtil_1_7_6,yneg_InjectUtil_1_7_6;
	wire[7:0] zpos_ClockwiseUtil_1_7_6,zpos_CounterClockwiseUtil_1_7_6,zpos_InjectUtil_1_7_6;
	wire[7:0] zneg_ClockwiseUtil_1_7_6,zneg_CounterClockwiseUtil_1_7_6,zneg_InjectUtil_1_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_1_7_7, eject_xpos_ser_1_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_1_7_7, eject_xneg_ser_1_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_1_7_7, eject_ypos_ser_1_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_1_7_7, eject_yneg_ser_1_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_1_7_7, eject_zpos_ser_1_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_1_7_7, eject_zneg_ser_1_7_7;
	wire[7:0] xpos_ClockwiseUtil_1_7_7,xpos_CounterClockwiseUtil_1_7_7,xpos_InjectUtil_1_7_7;
	wire[7:0] xneg_ClockwiseUtil_1_7_7,xneg_CounterClockwiseUtil_1_7_7,xneg_InjectUtil_1_7_7;
	wire[7:0] ypos_ClockwiseUtil_1_7_7,ypos_CounterClockwiseUtil_1_7_7,ypos_InjectUtil_1_7_7;
	wire[7:0] yneg_ClockwiseUtil_1_7_7,yneg_CounterClockwiseUtil_1_7_7,yneg_InjectUtil_1_7_7;
	wire[7:0] zpos_ClockwiseUtil_1_7_7,zpos_CounterClockwiseUtil_1_7_7,zpos_InjectUtil_1_7_7;
	wire[7:0] zneg_ClockwiseUtil_1_7_7,zneg_CounterClockwiseUtil_1_7_7,zneg_InjectUtil_1_7_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_0, eject_xpos_ser_2_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_0, eject_xneg_ser_2_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_0, eject_ypos_ser_2_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_0, eject_yneg_ser_2_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_0, eject_zpos_ser_2_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_0, eject_zneg_ser_2_0_0;
	wire[7:0] xpos_ClockwiseUtil_2_0_0,xpos_CounterClockwiseUtil_2_0_0,xpos_InjectUtil_2_0_0;
	wire[7:0] xneg_ClockwiseUtil_2_0_0,xneg_CounterClockwiseUtil_2_0_0,xneg_InjectUtil_2_0_0;
	wire[7:0] ypos_ClockwiseUtil_2_0_0,ypos_CounterClockwiseUtil_2_0_0,ypos_InjectUtil_2_0_0;
	wire[7:0] yneg_ClockwiseUtil_2_0_0,yneg_CounterClockwiseUtil_2_0_0,yneg_InjectUtil_2_0_0;
	wire[7:0] zpos_ClockwiseUtil_2_0_0,zpos_CounterClockwiseUtil_2_0_0,zpos_InjectUtil_2_0_0;
	wire[7:0] zneg_ClockwiseUtil_2_0_0,zneg_CounterClockwiseUtil_2_0_0,zneg_InjectUtil_2_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_1, eject_xpos_ser_2_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_1, eject_xneg_ser_2_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_1, eject_ypos_ser_2_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_1, eject_yneg_ser_2_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_1, eject_zpos_ser_2_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_1, eject_zneg_ser_2_0_1;
	wire[7:0] xpos_ClockwiseUtil_2_0_1,xpos_CounterClockwiseUtil_2_0_1,xpos_InjectUtil_2_0_1;
	wire[7:0] xneg_ClockwiseUtil_2_0_1,xneg_CounterClockwiseUtil_2_0_1,xneg_InjectUtil_2_0_1;
	wire[7:0] ypos_ClockwiseUtil_2_0_1,ypos_CounterClockwiseUtil_2_0_1,ypos_InjectUtil_2_0_1;
	wire[7:0] yneg_ClockwiseUtil_2_0_1,yneg_CounterClockwiseUtil_2_0_1,yneg_InjectUtil_2_0_1;
	wire[7:0] zpos_ClockwiseUtil_2_0_1,zpos_CounterClockwiseUtil_2_0_1,zpos_InjectUtil_2_0_1;
	wire[7:0] zneg_ClockwiseUtil_2_0_1,zneg_CounterClockwiseUtil_2_0_1,zneg_InjectUtil_2_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_2, eject_xpos_ser_2_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_2, eject_xneg_ser_2_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_2, eject_ypos_ser_2_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_2, eject_yneg_ser_2_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_2, eject_zpos_ser_2_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_2, eject_zneg_ser_2_0_2;
	wire[7:0] xpos_ClockwiseUtil_2_0_2,xpos_CounterClockwiseUtil_2_0_2,xpos_InjectUtil_2_0_2;
	wire[7:0] xneg_ClockwiseUtil_2_0_2,xneg_CounterClockwiseUtil_2_0_2,xneg_InjectUtil_2_0_2;
	wire[7:0] ypos_ClockwiseUtil_2_0_2,ypos_CounterClockwiseUtil_2_0_2,ypos_InjectUtil_2_0_2;
	wire[7:0] yneg_ClockwiseUtil_2_0_2,yneg_CounterClockwiseUtil_2_0_2,yneg_InjectUtil_2_0_2;
	wire[7:0] zpos_ClockwiseUtil_2_0_2,zpos_CounterClockwiseUtil_2_0_2,zpos_InjectUtil_2_0_2;
	wire[7:0] zneg_ClockwiseUtil_2_0_2,zneg_CounterClockwiseUtil_2_0_2,zneg_InjectUtil_2_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_3, eject_xpos_ser_2_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_3, eject_xneg_ser_2_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_3, eject_ypos_ser_2_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_3, eject_yneg_ser_2_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_3, eject_zpos_ser_2_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_3, eject_zneg_ser_2_0_3;
	wire[7:0] xpos_ClockwiseUtil_2_0_3,xpos_CounterClockwiseUtil_2_0_3,xpos_InjectUtil_2_0_3;
	wire[7:0] xneg_ClockwiseUtil_2_0_3,xneg_CounterClockwiseUtil_2_0_3,xneg_InjectUtil_2_0_3;
	wire[7:0] ypos_ClockwiseUtil_2_0_3,ypos_CounterClockwiseUtil_2_0_3,ypos_InjectUtil_2_0_3;
	wire[7:0] yneg_ClockwiseUtil_2_0_3,yneg_CounterClockwiseUtil_2_0_3,yneg_InjectUtil_2_0_3;
	wire[7:0] zpos_ClockwiseUtil_2_0_3,zpos_CounterClockwiseUtil_2_0_3,zpos_InjectUtil_2_0_3;
	wire[7:0] zneg_ClockwiseUtil_2_0_3,zneg_CounterClockwiseUtil_2_0_3,zneg_InjectUtil_2_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_4, eject_xpos_ser_2_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_4, eject_xneg_ser_2_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_4, eject_ypos_ser_2_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_4, eject_yneg_ser_2_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_4, eject_zpos_ser_2_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_4, eject_zneg_ser_2_0_4;
	wire[7:0] xpos_ClockwiseUtil_2_0_4,xpos_CounterClockwiseUtil_2_0_4,xpos_InjectUtil_2_0_4;
	wire[7:0] xneg_ClockwiseUtil_2_0_4,xneg_CounterClockwiseUtil_2_0_4,xneg_InjectUtil_2_0_4;
	wire[7:0] ypos_ClockwiseUtil_2_0_4,ypos_CounterClockwiseUtil_2_0_4,ypos_InjectUtil_2_0_4;
	wire[7:0] yneg_ClockwiseUtil_2_0_4,yneg_CounterClockwiseUtil_2_0_4,yneg_InjectUtil_2_0_4;
	wire[7:0] zpos_ClockwiseUtil_2_0_4,zpos_CounterClockwiseUtil_2_0_4,zpos_InjectUtil_2_0_4;
	wire[7:0] zneg_ClockwiseUtil_2_0_4,zneg_CounterClockwiseUtil_2_0_4,zneg_InjectUtil_2_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_5, eject_xpos_ser_2_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_5, eject_xneg_ser_2_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_5, eject_ypos_ser_2_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_5, eject_yneg_ser_2_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_5, eject_zpos_ser_2_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_5, eject_zneg_ser_2_0_5;
	wire[7:0] xpos_ClockwiseUtil_2_0_5,xpos_CounterClockwiseUtil_2_0_5,xpos_InjectUtil_2_0_5;
	wire[7:0] xneg_ClockwiseUtil_2_0_5,xneg_CounterClockwiseUtil_2_0_5,xneg_InjectUtil_2_0_5;
	wire[7:0] ypos_ClockwiseUtil_2_0_5,ypos_CounterClockwiseUtil_2_0_5,ypos_InjectUtil_2_0_5;
	wire[7:0] yneg_ClockwiseUtil_2_0_5,yneg_CounterClockwiseUtil_2_0_5,yneg_InjectUtil_2_0_5;
	wire[7:0] zpos_ClockwiseUtil_2_0_5,zpos_CounterClockwiseUtil_2_0_5,zpos_InjectUtil_2_0_5;
	wire[7:0] zneg_ClockwiseUtil_2_0_5,zneg_CounterClockwiseUtil_2_0_5,zneg_InjectUtil_2_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_6, eject_xpos_ser_2_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_6, eject_xneg_ser_2_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_6, eject_ypos_ser_2_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_6, eject_yneg_ser_2_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_6, eject_zpos_ser_2_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_6, eject_zneg_ser_2_0_6;
	wire[7:0] xpos_ClockwiseUtil_2_0_6,xpos_CounterClockwiseUtil_2_0_6,xpos_InjectUtil_2_0_6;
	wire[7:0] xneg_ClockwiseUtil_2_0_6,xneg_CounterClockwiseUtil_2_0_6,xneg_InjectUtil_2_0_6;
	wire[7:0] ypos_ClockwiseUtil_2_0_6,ypos_CounterClockwiseUtil_2_0_6,ypos_InjectUtil_2_0_6;
	wire[7:0] yneg_ClockwiseUtil_2_0_6,yneg_CounterClockwiseUtil_2_0_6,yneg_InjectUtil_2_0_6;
	wire[7:0] zpos_ClockwiseUtil_2_0_6,zpos_CounterClockwiseUtil_2_0_6,zpos_InjectUtil_2_0_6;
	wire[7:0] zneg_ClockwiseUtil_2_0_6,zneg_CounterClockwiseUtil_2_0_6,zneg_InjectUtil_2_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_0_7, eject_xpos_ser_2_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_0_7, eject_xneg_ser_2_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_0_7, eject_ypos_ser_2_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_0_7, eject_yneg_ser_2_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_0_7, eject_zpos_ser_2_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_0_7, eject_zneg_ser_2_0_7;
	wire[7:0] xpos_ClockwiseUtil_2_0_7,xpos_CounterClockwiseUtil_2_0_7,xpos_InjectUtil_2_0_7;
	wire[7:0] xneg_ClockwiseUtil_2_0_7,xneg_CounterClockwiseUtil_2_0_7,xneg_InjectUtil_2_0_7;
	wire[7:0] ypos_ClockwiseUtil_2_0_7,ypos_CounterClockwiseUtil_2_0_7,ypos_InjectUtil_2_0_7;
	wire[7:0] yneg_ClockwiseUtil_2_0_7,yneg_CounterClockwiseUtil_2_0_7,yneg_InjectUtil_2_0_7;
	wire[7:0] zpos_ClockwiseUtil_2_0_7,zpos_CounterClockwiseUtil_2_0_7,zpos_InjectUtil_2_0_7;
	wire[7:0] zneg_ClockwiseUtil_2_0_7,zneg_CounterClockwiseUtil_2_0_7,zneg_InjectUtil_2_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_0, eject_xpos_ser_2_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_0, eject_xneg_ser_2_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_0, eject_ypos_ser_2_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_0, eject_yneg_ser_2_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_0, eject_zpos_ser_2_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_0, eject_zneg_ser_2_1_0;
	wire[7:0] xpos_ClockwiseUtil_2_1_0,xpos_CounterClockwiseUtil_2_1_0,xpos_InjectUtil_2_1_0;
	wire[7:0] xneg_ClockwiseUtil_2_1_0,xneg_CounterClockwiseUtil_2_1_0,xneg_InjectUtil_2_1_0;
	wire[7:0] ypos_ClockwiseUtil_2_1_0,ypos_CounterClockwiseUtil_2_1_0,ypos_InjectUtil_2_1_0;
	wire[7:0] yneg_ClockwiseUtil_2_1_0,yneg_CounterClockwiseUtil_2_1_0,yneg_InjectUtil_2_1_0;
	wire[7:0] zpos_ClockwiseUtil_2_1_0,zpos_CounterClockwiseUtil_2_1_0,zpos_InjectUtil_2_1_0;
	wire[7:0] zneg_ClockwiseUtil_2_1_0,zneg_CounterClockwiseUtil_2_1_0,zneg_InjectUtil_2_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_1, eject_xpos_ser_2_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_1, eject_xneg_ser_2_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_1, eject_ypos_ser_2_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_1, eject_yneg_ser_2_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_1, eject_zpos_ser_2_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_1, eject_zneg_ser_2_1_1;
	wire[7:0] xpos_ClockwiseUtil_2_1_1,xpos_CounterClockwiseUtil_2_1_1,xpos_InjectUtil_2_1_1;
	wire[7:0] xneg_ClockwiseUtil_2_1_1,xneg_CounterClockwiseUtil_2_1_1,xneg_InjectUtil_2_1_1;
	wire[7:0] ypos_ClockwiseUtil_2_1_1,ypos_CounterClockwiseUtil_2_1_1,ypos_InjectUtil_2_1_1;
	wire[7:0] yneg_ClockwiseUtil_2_1_1,yneg_CounterClockwiseUtil_2_1_1,yneg_InjectUtil_2_1_1;
	wire[7:0] zpos_ClockwiseUtil_2_1_1,zpos_CounterClockwiseUtil_2_1_1,zpos_InjectUtil_2_1_1;
	wire[7:0] zneg_ClockwiseUtil_2_1_1,zneg_CounterClockwiseUtil_2_1_1,zneg_InjectUtil_2_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_2, eject_xpos_ser_2_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_2, eject_xneg_ser_2_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_2, eject_ypos_ser_2_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_2, eject_yneg_ser_2_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_2, eject_zpos_ser_2_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_2, eject_zneg_ser_2_1_2;
	wire[7:0] xpos_ClockwiseUtil_2_1_2,xpos_CounterClockwiseUtil_2_1_2,xpos_InjectUtil_2_1_2;
	wire[7:0] xneg_ClockwiseUtil_2_1_2,xneg_CounterClockwiseUtil_2_1_2,xneg_InjectUtil_2_1_2;
	wire[7:0] ypos_ClockwiseUtil_2_1_2,ypos_CounterClockwiseUtil_2_1_2,ypos_InjectUtil_2_1_2;
	wire[7:0] yneg_ClockwiseUtil_2_1_2,yneg_CounterClockwiseUtil_2_1_2,yneg_InjectUtil_2_1_2;
	wire[7:0] zpos_ClockwiseUtil_2_1_2,zpos_CounterClockwiseUtil_2_1_2,zpos_InjectUtil_2_1_2;
	wire[7:0] zneg_ClockwiseUtil_2_1_2,zneg_CounterClockwiseUtil_2_1_2,zneg_InjectUtil_2_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_3, eject_xpos_ser_2_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_3, eject_xneg_ser_2_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_3, eject_ypos_ser_2_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_3, eject_yneg_ser_2_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_3, eject_zpos_ser_2_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_3, eject_zneg_ser_2_1_3;
	wire[7:0] xpos_ClockwiseUtil_2_1_3,xpos_CounterClockwiseUtil_2_1_3,xpos_InjectUtil_2_1_3;
	wire[7:0] xneg_ClockwiseUtil_2_1_3,xneg_CounterClockwiseUtil_2_1_3,xneg_InjectUtil_2_1_3;
	wire[7:0] ypos_ClockwiseUtil_2_1_3,ypos_CounterClockwiseUtil_2_1_3,ypos_InjectUtil_2_1_3;
	wire[7:0] yneg_ClockwiseUtil_2_1_3,yneg_CounterClockwiseUtil_2_1_3,yneg_InjectUtil_2_1_3;
	wire[7:0] zpos_ClockwiseUtil_2_1_3,zpos_CounterClockwiseUtil_2_1_3,zpos_InjectUtil_2_1_3;
	wire[7:0] zneg_ClockwiseUtil_2_1_3,zneg_CounterClockwiseUtil_2_1_3,zneg_InjectUtil_2_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_4, eject_xpos_ser_2_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_4, eject_xneg_ser_2_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_4, eject_ypos_ser_2_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_4, eject_yneg_ser_2_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_4, eject_zpos_ser_2_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_4, eject_zneg_ser_2_1_4;
	wire[7:0] xpos_ClockwiseUtil_2_1_4,xpos_CounterClockwiseUtil_2_1_4,xpos_InjectUtil_2_1_4;
	wire[7:0] xneg_ClockwiseUtil_2_1_4,xneg_CounterClockwiseUtil_2_1_4,xneg_InjectUtil_2_1_4;
	wire[7:0] ypos_ClockwiseUtil_2_1_4,ypos_CounterClockwiseUtil_2_1_4,ypos_InjectUtil_2_1_4;
	wire[7:0] yneg_ClockwiseUtil_2_1_4,yneg_CounterClockwiseUtil_2_1_4,yneg_InjectUtil_2_1_4;
	wire[7:0] zpos_ClockwiseUtil_2_1_4,zpos_CounterClockwiseUtil_2_1_4,zpos_InjectUtil_2_1_4;
	wire[7:0] zneg_ClockwiseUtil_2_1_4,zneg_CounterClockwiseUtil_2_1_4,zneg_InjectUtil_2_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_5, eject_xpos_ser_2_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_5, eject_xneg_ser_2_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_5, eject_ypos_ser_2_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_5, eject_yneg_ser_2_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_5, eject_zpos_ser_2_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_5, eject_zneg_ser_2_1_5;
	wire[7:0] xpos_ClockwiseUtil_2_1_5,xpos_CounterClockwiseUtil_2_1_5,xpos_InjectUtil_2_1_5;
	wire[7:0] xneg_ClockwiseUtil_2_1_5,xneg_CounterClockwiseUtil_2_1_5,xneg_InjectUtil_2_1_5;
	wire[7:0] ypos_ClockwiseUtil_2_1_5,ypos_CounterClockwiseUtil_2_1_5,ypos_InjectUtil_2_1_5;
	wire[7:0] yneg_ClockwiseUtil_2_1_5,yneg_CounterClockwiseUtil_2_1_5,yneg_InjectUtil_2_1_5;
	wire[7:0] zpos_ClockwiseUtil_2_1_5,zpos_CounterClockwiseUtil_2_1_5,zpos_InjectUtil_2_1_5;
	wire[7:0] zneg_ClockwiseUtil_2_1_5,zneg_CounterClockwiseUtil_2_1_5,zneg_InjectUtil_2_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_6, eject_xpos_ser_2_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_6, eject_xneg_ser_2_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_6, eject_ypos_ser_2_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_6, eject_yneg_ser_2_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_6, eject_zpos_ser_2_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_6, eject_zneg_ser_2_1_6;
	wire[7:0] xpos_ClockwiseUtil_2_1_6,xpos_CounterClockwiseUtil_2_1_6,xpos_InjectUtil_2_1_6;
	wire[7:0] xneg_ClockwiseUtil_2_1_6,xneg_CounterClockwiseUtil_2_1_6,xneg_InjectUtil_2_1_6;
	wire[7:0] ypos_ClockwiseUtil_2_1_6,ypos_CounterClockwiseUtil_2_1_6,ypos_InjectUtil_2_1_6;
	wire[7:0] yneg_ClockwiseUtil_2_1_6,yneg_CounterClockwiseUtil_2_1_6,yneg_InjectUtil_2_1_6;
	wire[7:0] zpos_ClockwiseUtil_2_1_6,zpos_CounterClockwiseUtil_2_1_6,zpos_InjectUtil_2_1_6;
	wire[7:0] zneg_ClockwiseUtil_2_1_6,zneg_CounterClockwiseUtil_2_1_6,zneg_InjectUtil_2_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_1_7, eject_xpos_ser_2_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_1_7, eject_xneg_ser_2_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_1_7, eject_ypos_ser_2_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_1_7, eject_yneg_ser_2_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_1_7, eject_zpos_ser_2_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_1_7, eject_zneg_ser_2_1_7;
	wire[7:0] xpos_ClockwiseUtil_2_1_7,xpos_CounterClockwiseUtil_2_1_7,xpos_InjectUtil_2_1_7;
	wire[7:0] xneg_ClockwiseUtil_2_1_7,xneg_CounterClockwiseUtil_2_1_7,xneg_InjectUtil_2_1_7;
	wire[7:0] ypos_ClockwiseUtil_2_1_7,ypos_CounterClockwiseUtil_2_1_7,ypos_InjectUtil_2_1_7;
	wire[7:0] yneg_ClockwiseUtil_2_1_7,yneg_CounterClockwiseUtil_2_1_7,yneg_InjectUtil_2_1_7;
	wire[7:0] zpos_ClockwiseUtil_2_1_7,zpos_CounterClockwiseUtil_2_1_7,zpos_InjectUtil_2_1_7;
	wire[7:0] zneg_ClockwiseUtil_2_1_7,zneg_CounterClockwiseUtil_2_1_7,zneg_InjectUtil_2_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_0, eject_xpos_ser_2_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_0, eject_xneg_ser_2_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_0, eject_ypos_ser_2_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_0, eject_yneg_ser_2_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_0, eject_zpos_ser_2_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_0, eject_zneg_ser_2_2_0;
	wire[7:0] xpos_ClockwiseUtil_2_2_0,xpos_CounterClockwiseUtil_2_2_0,xpos_InjectUtil_2_2_0;
	wire[7:0] xneg_ClockwiseUtil_2_2_0,xneg_CounterClockwiseUtil_2_2_0,xneg_InjectUtil_2_2_0;
	wire[7:0] ypos_ClockwiseUtil_2_2_0,ypos_CounterClockwiseUtil_2_2_0,ypos_InjectUtil_2_2_0;
	wire[7:0] yneg_ClockwiseUtil_2_2_0,yneg_CounterClockwiseUtil_2_2_0,yneg_InjectUtil_2_2_0;
	wire[7:0] zpos_ClockwiseUtil_2_2_0,zpos_CounterClockwiseUtil_2_2_0,zpos_InjectUtil_2_2_0;
	wire[7:0] zneg_ClockwiseUtil_2_2_0,zneg_CounterClockwiseUtil_2_2_0,zneg_InjectUtil_2_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_1, eject_xpos_ser_2_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_1, eject_xneg_ser_2_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_1, eject_ypos_ser_2_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_1, eject_yneg_ser_2_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_1, eject_zpos_ser_2_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_1, eject_zneg_ser_2_2_1;
	wire[7:0] xpos_ClockwiseUtil_2_2_1,xpos_CounterClockwiseUtil_2_2_1,xpos_InjectUtil_2_2_1;
	wire[7:0] xneg_ClockwiseUtil_2_2_1,xneg_CounterClockwiseUtil_2_2_1,xneg_InjectUtil_2_2_1;
	wire[7:0] ypos_ClockwiseUtil_2_2_1,ypos_CounterClockwiseUtil_2_2_1,ypos_InjectUtil_2_2_1;
	wire[7:0] yneg_ClockwiseUtil_2_2_1,yneg_CounterClockwiseUtil_2_2_1,yneg_InjectUtil_2_2_1;
	wire[7:0] zpos_ClockwiseUtil_2_2_1,zpos_CounterClockwiseUtil_2_2_1,zpos_InjectUtil_2_2_1;
	wire[7:0] zneg_ClockwiseUtil_2_2_1,zneg_CounterClockwiseUtil_2_2_1,zneg_InjectUtil_2_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_2, eject_xpos_ser_2_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_2, eject_xneg_ser_2_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_2, eject_ypos_ser_2_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_2, eject_yneg_ser_2_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_2, eject_zpos_ser_2_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_2, eject_zneg_ser_2_2_2;
	wire[7:0] xpos_ClockwiseUtil_2_2_2,xpos_CounterClockwiseUtil_2_2_2,xpos_InjectUtil_2_2_2;
	wire[7:0] xneg_ClockwiseUtil_2_2_2,xneg_CounterClockwiseUtil_2_2_2,xneg_InjectUtil_2_2_2;
	wire[7:0] ypos_ClockwiseUtil_2_2_2,ypos_CounterClockwiseUtil_2_2_2,ypos_InjectUtil_2_2_2;
	wire[7:0] yneg_ClockwiseUtil_2_2_2,yneg_CounterClockwiseUtil_2_2_2,yneg_InjectUtil_2_2_2;
	wire[7:0] zpos_ClockwiseUtil_2_2_2,zpos_CounterClockwiseUtil_2_2_2,zpos_InjectUtil_2_2_2;
	wire[7:0] zneg_ClockwiseUtil_2_2_2,zneg_CounterClockwiseUtil_2_2_2,zneg_InjectUtil_2_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_3, eject_xpos_ser_2_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_3, eject_xneg_ser_2_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_3, eject_ypos_ser_2_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_3, eject_yneg_ser_2_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_3, eject_zpos_ser_2_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_3, eject_zneg_ser_2_2_3;
	wire[7:0] xpos_ClockwiseUtil_2_2_3,xpos_CounterClockwiseUtil_2_2_3,xpos_InjectUtil_2_2_3;
	wire[7:0] xneg_ClockwiseUtil_2_2_3,xneg_CounterClockwiseUtil_2_2_3,xneg_InjectUtil_2_2_3;
	wire[7:0] ypos_ClockwiseUtil_2_2_3,ypos_CounterClockwiseUtil_2_2_3,ypos_InjectUtil_2_2_3;
	wire[7:0] yneg_ClockwiseUtil_2_2_3,yneg_CounterClockwiseUtil_2_2_3,yneg_InjectUtil_2_2_3;
	wire[7:0] zpos_ClockwiseUtil_2_2_3,zpos_CounterClockwiseUtil_2_2_3,zpos_InjectUtil_2_2_3;
	wire[7:0] zneg_ClockwiseUtil_2_2_3,zneg_CounterClockwiseUtil_2_2_3,zneg_InjectUtil_2_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_4, eject_xpos_ser_2_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_4, eject_xneg_ser_2_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_4, eject_ypos_ser_2_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_4, eject_yneg_ser_2_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_4, eject_zpos_ser_2_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_4, eject_zneg_ser_2_2_4;
	wire[7:0] xpos_ClockwiseUtil_2_2_4,xpos_CounterClockwiseUtil_2_2_4,xpos_InjectUtil_2_2_4;
	wire[7:0] xneg_ClockwiseUtil_2_2_4,xneg_CounterClockwiseUtil_2_2_4,xneg_InjectUtil_2_2_4;
	wire[7:0] ypos_ClockwiseUtil_2_2_4,ypos_CounterClockwiseUtil_2_2_4,ypos_InjectUtil_2_2_4;
	wire[7:0] yneg_ClockwiseUtil_2_2_4,yneg_CounterClockwiseUtil_2_2_4,yneg_InjectUtil_2_2_4;
	wire[7:0] zpos_ClockwiseUtil_2_2_4,zpos_CounterClockwiseUtil_2_2_4,zpos_InjectUtil_2_2_4;
	wire[7:0] zneg_ClockwiseUtil_2_2_4,zneg_CounterClockwiseUtil_2_2_4,zneg_InjectUtil_2_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_5, eject_xpos_ser_2_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_5, eject_xneg_ser_2_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_5, eject_ypos_ser_2_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_5, eject_yneg_ser_2_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_5, eject_zpos_ser_2_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_5, eject_zneg_ser_2_2_5;
	wire[7:0] xpos_ClockwiseUtil_2_2_5,xpos_CounterClockwiseUtil_2_2_5,xpos_InjectUtil_2_2_5;
	wire[7:0] xneg_ClockwiseUtil_2_2_5,xneg_CounterClockwiseUtil_2_2_5,xneg_InjectUtil_2_2_5;
	wire[7:0] ypos_ClockwiseUtil_2_2_5,ypos_CounterClockwiseUtil_2_2_5,ypos_InjectUtil_2_2_5;
	wire[7:0] yneg_ClockwiseUtil_2_2_5,yneg_CounterClockwiseUtil_2_2_5,yneg_InjectUtil_2_2_5;
	wire[7:0] zpos_ClockwiseUtil_2_2_5,zpos_CounterClockwiseUtil_2_2_5,zpos_InjectUtil_2_2_5;
	wire[7:0] zneg_ClockwiseUtil_2_2_5,zneg_CounterClockwiseUtil_2_2_5,zneg_InjectUtil_2_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_6, eject_xpos_ser_2_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_6, eject_xneg_ser_2_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_6, eject_ypos_ser_2_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_6, eject_yneg_ser_2_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_6, eject_zpos_ser_2_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_6, eject_zneg_ser_2_2_6;
	wire[7:0] xpos_ClockwiseUtil_2_2_6,xpos_CounterClockwiseUtil_2_2_6,xpos_InjectUtil_2_2_6;
	wire[7:0] xneg_ClockwiseUtil_2_2_6,xneg_CounterClockwiseUtil_2_2_6,xneg_InjectUtil_2_2_6;
	wire[7:0] ypos_ClockwiseUtil_2_2_6,ypos_CounterClockwiseUtil_2_2_6,ypos_InjectUtil_2_2_6;
	wire[7:0] yneg_ClockwiseUtil_2_2_6,yneg_CounterClockwiseUtil_2_2_6,yneg_InjectUtil_2_2_6;
	wire[7:0] zpos_ClockwiseUtil_2_2_6,zpos_CounterClockwiseUtil_2_2_6,zpos_InjectUtil_2_2_6;
	wire[7:0] zneg_ClockwiseUtil_2_2_6,zneg_CounterClockwiseUtil_2_2_6,zneg_InjectUtil_2_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_2_7, eject_xpos_ser_2_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_2_7, eject_xneg_ser_2_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_2_7, eject_ypos_ser_2_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_2_7, eject_yneg_ser_2_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_2_7, eject_zpos_ser_2_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_2_7, eject_zneg_ser_2_2_7;
	wire[7:0] xpos_ClockwiseUtil_2_2_7,xpos_CounterClockwiseUtil_2_2_7,xpos_InjectUtil_2_2_7;
	wire[7:0] xneg_ClockwiseUtil_2_2_7,xneg_CounterClockwiseUtil_2_2_7,xneg_InjectUtil_2_2_7;
	wire[7:0] ypos_ClockwiseUtil_2_2_7,ypos_CounterClockwiseUtil_2_2_7,ypos_InjectUtil_2_2_7;
	wire[7:0] yneg_ClockwiseUtil_2_2_7,yneg_CounterClockwiseUtil_2_2_7,yneg_InjectUtil_2_2_7;
	wire[7:0] zpos_ClockwiseUtil_2_2_7,zpos_CounterClockwiseUtil_2_2_7,zpos_InjectUtil_2_2_7;
	wire[7:0] zneg_ClockwiseUtil_2_2_7,zneg_CounterClockwiseUtil_2_2_7,zneg_InjectUtil_2_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_0, eject_xpos_ser_2_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_0, eject_xneg_ser_2_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_0, eject_ypos_ser_2_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_0, eject_yneg_ser_2_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_0, eject_zpos_ser_2_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_0, eject_zneg_ser_2_3_0;
	wire[7:0] xpos_ClockwiseUtil_2_3_0,xpos_CounterClockwiseUtil_2_3_0,xpos_InjectUtil_2_3_0;
	wire[7:0] xneg_ClockwiseUtil_2_3_0,xneg_CounterClockwiseUtil_2_3_0,xneg_InjectUtil_2_3_0;
	wire[7:0] ypos_ClockwiseUtil_2_3_0,ypos_CounterClockwiseUtil_2_3_0,ypos_InjectUtil_2_3_0;
	wire[7:0] yneg_ClockwiseUtil_2_3_0,yneg_CounterClockwiseUtil_2_3_0,yneg_InjectUtil_2_3_0;
	wire[7:0] zpos_ClockwiseUtil_2_3_0,zpos_CounterClockwiseUtil_2_3_0,zpos_InjectUtil_2_3_0;
	wire[7:0] zneg_ClockwiseUtil_2_3_0,zneg_CounterClockwiseUtil_2_3_0,zneg_InjectUtil_2_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_1, eject_xpos_ser_2_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_1, eject_xneg_ser_2_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_1, eject_ypos_ser_2_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_1, eject_yneg_ser_2_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_1, eject_zpos_ser_2_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_1, eject_zneg_ser_2_3_1;
	wire[7:0] xpos_ClockwiseUtil_2_3_1,xpos_CounterClockwiseUtil_2_3_1,xpos_InjectUtil_2_3_1;
	wire[7:0] xneg_ClockwiseUtil_2_3_1,xneg_CounterClockwiseUtil_2_3_1,xneg_InjectUtil_2_3_1;
	wire[7:0] ypos_ClockwiseUtil_2_3_1,ypos_CounterClockwiseUtil_2_3_1,ypos_InjectUtil_2_3_1;
	wire[7:0] yneg_ClockwiseUtil_2_3_1,yneg_CounterClockwiseUtil_2_3_1,yneg_InjectUtil_2_3_1;
	wire[7:0] zpos_ClockwiseUtil_2_3_1,zpos_CounterClockwiseUtil_2_3_1,zpos_InjectUtil_2_3_1;
	wire[7:0] zneg_ClockwiseUtil_2_3_1,zneg_CounterClockwiseUtil_2_3_1,zneg_InjectUtil_2_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_2, eject_xpos_ser_2_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_2, eject_xneg_ser_2_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_2, eject_ypos_ser_2_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_2, eject_yneg_ser_2_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_2, eject_zpos_ser_2_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_2, eject_zneg_ser_2_3_2;
	wire[7:0] xpos_ClockwiseUtil_2_3_2,xpos_CounterClockwiseUtil_2_3_2,xpos_InjectUtil_2_3_2;
	wire[7:0] xneg_ClockwiseUtil_2_3_2,xneg_CounterClockwiseUtil_2_3_2,xneg_InjectUtil_2_3_2;
	wire[7:0] ypos_ClockwiseUtil_2_3_2,ypos_CounterClockwiseUtil_2_3_2,ypos_InjectUtil_2_3_2;
	wire[7:0] yneg_ClockwiseUtil_2_3_2,yneg_CounterClockwiseUtil_2_3_2,yneg_InjectUtil_2_3_2;
	wire[7:0] zpos_ClockwiseUtil_2_3_2,zpos_CounterClockwiseUtil_2_3_2,zpos_InjectUtil_2_3_2;
	wire[7:0] zneg_ClockwiseUtil_2_3_2,zneg_CounterClockwiseUtil_2_3_2,zneg_InjectUtil_2_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_3, eject_xpos_ser_2_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_3, eject_xneg_ser_2_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_3, eject_ypos_ser_2_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_3, eject_yneg_ser_2_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_3, eject_zpos_ser_2_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_3, eject_zneg_ser_2_3_3;
	wire[7:0] xpos_ClockwiseUtil_2_3_3,xpos_CounterClockwiseUtil_2_3_3,xpos_InjectUtil_2_3_3;
	wire[7:0] xneg_ClockwiseUtil_2_3_3,xneg_CounterClockwiseUtil_2_3_3,xneg_InjectUtil_2_3_3;
	wire[7:0] ypos_ClockwiseUtil_2_3_3,ypos_CounterClockwiseUtil_2_3_3,ypos_InjectUtil_2_3_3;
	wire[7:0] yneg_ClockwiseUtil_2_3_3,yneg_CounterClockwiseUtil_2_3_3,yneg_InjectUtil_2_3_3;
	wire[7:0] zpos_ClockwiseUtil_2_3_3,zpos_CounterClockwiseUtil_2_3_3,zpos_InjectUtil_2_3_3;
	wire[7:0] zneg_ClockwiseUtil_2_3_3,zneg_CounterClockwiseUtil_2_3_3,zneg_InjectUtil_2_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_4, eject_xpos_ser_2_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_4, eject_xneg_ser_2_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_4, eject_ypos_ser_2_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_4, eject_yneg_ser_2_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_4, eject_zpos_ser_2_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_4, eject_zneg_ser_2_3_4;
	wire[7:0] xpos_ClockwiseUtil_2_3_4,xpos_CounterClockwiseUtil_2_3_4,xpos_InjectUtil_2_3_4;
	wire[7:0] xneg_ClockwiseUtil_2_3_4,xneg_CounterClockwiseUtil_2_3_4,xneg_InjectUtil_2_3_4;
	wire[7:0] ypos_ClockwiseUtil_2_3_4,ypos_CounterClockwiseUtil_2_3_4,ypos_InjectUtil_2_3_4;
	wire[7:0] yneg_ClockwiseUtil_2_3_4,yneg_CounterClockwiseUtil_2_3_4,yneg_InjectUtil_2_3_4;
	wire[7:0] zpos_ClockwiseUtil_2_3_4,zpos_CounterClockwiseUtil_2_3_4,zpos_InjectUtil_2_3_4;
	wire[7:0] zneg_ClockwiseUtil_2_3_4,zneg_CounterClockwiseUtil_2_3_4,zneg_InjectUtil_2_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_5, eject_xpos_ser_2_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_5, eject_xneg_ser_2_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_5, eject_ypos_ser_2_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_5, eject_yneg_ser_2_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_5, eject_zpos_ser_2_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_5, eject_zneg_ser_2_3_5;
	wire[7:0] xpos_ClockwiseUtil_2_3_5,xpos_CounterClockwiseUtil_2_3_5,xpos_InjectUtil_2_3_5;
	wire[7:0] xneg_ClockwiseUtil_2_3_5,xneg_CounterClockwiseUtil_2_3_5,xneg_InjectUtil_2_3_5;
	wire[7:0] ypos_ClockwiseUtil_2_3_5,ypos_CounterClockwiseUtil_2_3_5,ypos_InjectUtil_2_3_5;
	wire[7:0] yneg_ClockwiseUtil_2_3_5,yneg_CounterClockwiseUtil_2_3_5,yneg_InjectUtil_2_3_5;
	wire[7:0] zpos_ClockwiseUtil_2_3_5,zpos_CounterClockwiseUtil_2_3_5,zpos_InjectUtil_2_3_5;
	wire[7:0] zneg_ClockwiseUtil_2_3_5,zneg_CounterClockwiseUtil_2_3_5,zneg_InjectUtil_2_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_6, eject_xpos_ser_2_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_6, eject_xneg_ser_2_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_6, eject_ypos_ser_2_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_6, eject_yneg_ser_2_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_6, eject_zpos_ser_2_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_6, eject_zneg_ser_2_3_6;
	wire[7:0] xpos_ClockwiseUtil_2_3_6,xpos_CounterClockwiseUtil_2_3_6,xpos_InjectUtil_2_3_6;
	wire[7:0] xneg_ClockwiseUtil_2_3_6,xneg_CounterClockwiseUtil_2_3_6,xneg_InjectUtil_2_3_6;
	wire[7:0] ypos_ClockwiseUtil_2_3_6,ypos_CounterClockwiseUtil_2_3_6,ypos_InjectUtil_2_3_6;
	wire[7:0] yneg_ClockwiseUtil_2_3_6,yneg_CounterClockwiseUtil_2_3_6,yneg_InjectUtil_2_3_6;
	wire[7:0] zpos_ClockwiseUtil_2_3_6,zpos_CounterClockwiseUtil_2_3_6,zpos_InjectUtil_2_3_6;
	wire[7:0] zneg_ClockwiseUtil_2_3_6,zneg_CounterClockwiseUtil_2_3_6,zneg_InjectUtil_2_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_3_7, eject_xpos_ser_2_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_3_7, eject_xneg_ser_2_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_3_7, eject_ypos_ser_2_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_3_7, eject_yneg_ser_2_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_3_7, eject_zpos_ser_2_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_3_7, eject_zneg_ser_2_3_7;
	wire[7:0] xpos_ClockwiseUtil_2_3_7,xpos_CounterClockwiseUtil_2_3_7,xpos_InjectUtil_2_3_7;
	wire[7:0] xneg_ClockwiseUtil_2_3_7,xneg_CounterClockwiseUtil_2_3_7,xneg_InjectUtil_2_3_7;
	wire[7:0] ypos_ClockwiseUtil_2_3_7,ypos_CounterClockwiseUtil_2_3_7,ypos_InjectUtil_2_3_7;
	wire[7:0] yneg_ClockwiseUtil_2_3_7,yneg_CounterClockwiseUtil_2_3_7,yneg_InjectUtil_2_3_7;
	wire[7:0] zpos_ClockwiseUtil_2_3_7,zpos_CounterClockwiseUtil_2_3_7,zpos_InjectUtil_2_3_7;
	wire[7:0] zneg_ClockwiseUtil_2_3_7,zneg_CounterClockwiseUtil_2_3_7,zneg_InjectUtil_2_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_0, eject_xpos_ser_2_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_0, eject_xneg_ser_2_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_0, eject_ypos_ser_2_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_0, eject_yneg_ser_2_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_0, eject_zpos_ser_2_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_0, eject_zneg_ser_2_4_0;
	wire[7:0] xpos_ClockwiseUtil_2_4_0,xpos_CounterClockwiseUtil_2_4_0,xpos_InjectUtil_2_4_0;
	wire[7:0] xneg_ClockwiseUtil_2_4_0,xneg_CounterClockwiseUtil_2_4_0,xneg_InjectUtil_2_4_0;
	wire[7:0] ypos_ClockwiseUtil_2_4_0,ypos_CounterClockwiseUtil_2_4_0,ypos_InjectUtil_2_4_0;
	wire[7:0] yneg_ClockwiseUtil_2_4_0,yneg_CounterClockwiseUtil_2_4_0,yneg_InjectUtil_2_4_0;
	wire[7:0] zpos_ClockwiseUtil_2_4_0,zpos_CounterClockwiseUtil_2_4_0,zpos_InjectUtil_2_4_0;
	wire[7:0] zneg_ClockwiseUtil_2_4_0,zneg_CounterClockwiseUtil_2_4_0,zneg_InjectUtil_2_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_1, eject_xpos_ser_2_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_1, eject_xneg_ser_2_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_1, eject_ypos_ser_2_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_1, eject_yneg_ser_2_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_1, eject_zpos_ser_2_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_1, eject_zneg_ser_2_4_1;
	wire[7:0] xpos_ClockwiseUtil_2_4_1,xpos_CounterClockwiseUtil_2_4_1,xpos_InjectUtil_2_4_1;
	wire[7:0] xneg_ClockwiseUtil_2_4_1,xneg_CounterClockwiseUtil_2_4_1,xneg_InjectUtil_2_4_1;
	wire[7:0] ypos_ClockwiseUtil_2_4_1,ypos_CounterClockwiseUtil_2_4_1,ypos_InjectUtil_2_4_1;
	wire[7:0] yneg_ClockwiseUtil_2_4_1,yneg_CounterClockwiseUtil_2_4_1,yneg_InjectUtil_2_4_1;
	wire[7:0] zpos_ClockwiseUtil_2_4_1,zpos_CounterClockwiseUtil_2_4_1,zpos_InjectUtil_2_4_1;
	wire[7:0] zneg_ClockwiseUtil_2_4_1,zneg_CounterClockwiseUtil_2_4_1,zneg_InjectUtil_2_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_2, eject_xpos_ser_2_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_2, eject_xneg_ser_2_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_2, eject_ypos_ser_2_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_2, eject_yneg_ser_2_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_2, eject_zpos_ser_2_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_2, eject_zneg_ser_2_4_2;
	wire[7:0] xpos_ClockwiseUtil_2_4_2,xpos_CounterClockwiseUtil_2_4_2,xpos_InjectUtil_2_4_2;
	wire[7:0] xneg_ClockwiseUtil_2_4_2,xneg_CounterClockwiseUtil_2_4_2,xneg_InjectUtil_2_4_2;
	wire[7:0] ypos_ClockwiseUtil_2_4_2,ypos_CounterClockwiseUtil_2_4_2,ypos_InjectUtil_2_4_2;
	wire[7:0] yneg_ClockwiseUtil_2_4_2,yneg_CounterClockwiseUtil_2_4_2,yneg_InjectUtil_2_4_2;
	wire[7:0] zpos_ClockwiseUtil_2_4_2,zpos_CounterClockwiseUtil_2_4_2,zpos_InjectUtil_2_4_2;
	wire[7:0] zneg_ClockwiseUtil_2_4_2,zneg_CounterClockwiseUtil_2_4_2,zneg_InjectUtil_2_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_3, eject_xpos_ser_2_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_3, eject_xneg_ser_2_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_3, eject_ypos_ser_2_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_3, eject_yneg_ser_2_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_3, eject_zpos_ser_2_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_3, eject_zneg_ser_2_4_3;
	wire[7:0] xpos_ClockwiseUtil_2_4_3,xpos_CounterClockwiseUtil_2_4_3,xpos_InjectUtil_2_4_3;
	wire[7:0] xneg_ClockwiseUtil_2_4_3,xneg_CounterClockwiseUtil_2_4_3,xneg_InjectUtil_2_4_3;
	wire[7:0] ypos_ClockwiseUtil_2_4_3,ypos_CounterClockwiseUtil_2_4_3,ypos_InjectUtil_2_4_3;
	wire[7:0] yneg_ClockwiseUtil_2_4_3,yneg_CounterClockwiseUtil_2_4_3,yneg_InjectUtil_2_4_3;
	wire[7:0] zpos_ClockwiseUtil_2_4_3,zpos_CounterClockwiseUtil_2_4_3,zpos_InjectUtil_2_4_3;
	wire[7:0] zneg_ClockwiseUtil_2_4_3,zneg_CounterClockwiseUtil_2_4_3,zneg_InjectUtil_2_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_4, eject_xpos_ser_2_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_4, eject_xneg_ser_2_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_4, eject_ypos_ser_2_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_4, eject_yneg_ser_2_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_4, eject_zpos_ser_2_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_4, eject_zneg_ser_2_4_4;
	wire[7:0] xpos_ClockwiseUtil_2_4_4,xpos_CounterClockwiseUtil_2_4_4,xpos_InjectUtil_2_4_4;
	wire[7:0] xneg_ClockwiseUtil_2_4_4,xneg_CounterClockwiseUtil_2_4_4,xneg_InjectUtil_2_4_4;
	wire[7:0] ypos_ClockwiseUtil_2_4_4,ypos_CounterClockwiseUtil_2_4_4,ypos_InjectUtil_2_4_4;
	wire[7:0] yneg_ClockwiseUtil_2_4_4,yneg_CounterClockwiseUtil_2_4_4,yneg_InjectUtil_2_4_4;
	wire[7:0] zpos_ClockwiseUtil_2_4_4,zpos_CounterClockwiseUtil_2_4_4,zpos_InjectUtil_2_4_4;
	wire[7:0] zneg_ClockwiseUtil_2_4_4,zneg_CounterClockwiseUtil_2_4_4,zneg_InjectUtil_2_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_5, eject_xpos_ser_2_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_5, eject_xneg_ser_2_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_5, eject_ypos_ser_2_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_5, eject_yneg_ser_2_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_5, eject_zpos_ser_2_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_5, eject_zneg_ser_2_4_5;
	wire[7:0] xpos_ClockwiseUtil_2_4_5,xpos_CounterClockwiseUtil_2_4_5,xpos_InjectUtil_2_4_5;
	wire[7:0] xneg_ClockwiseUtil_2_4_5,xneg_CounterClockwiseUtil_2_4_5,xneg_InjectUtil_2_4_5;
	wire[7:0] ypos_ClockwiseUtil_2_4_5,ypos_CounterClockwiseUtil_2_4_5,ypos_InjectUtil_2_4_5;
	wire[7:0] yneg_ClockwiseUtil_2_4_5,yneg_CounterClockwiseUtil_2_4_5,yneg_InjectUtil_2_4_5;
	wire[7:0] zpos_ClockwiseUtil_2_4_5,zpos_CounterClockwiseUtil_2_4_5,zpos_InjectUtil_2_4_5;
	wire[7:0] zneg_ClockwiseUtil_2_4_5,zneg_CounterClockwiseUtil_2_4_5,zneg_InjectUtil_2_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_6, eject_xpos_ser_2_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_6, eject_xneg_ser_2_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_6, eject_ypos_ser_2_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_6, eject_yneg_ser_2_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_6, eject_zpos_ser_2_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_6, eject_zneg_ser_2_4_6;
	wire[7:0] xpos_ClockwiseUtil_2_4_6,xpos_CounterClockwiseUtil_2_4_6,xpos_InjectUtil_2_4_6;
	wire[7:0] xneg_ClockwiseUtil_2_4_6,xneg_CounterClockwiseUtil_2_4_6,xneg_InjectUtil_2_4_6;
	wire[7:0] ypos_ClockwiseUtil_2_4_6,ypos_CounterClockwiseUtil_2_4_6,ypos_InjectUtil_2_4_6;
	wire[7:0] yneg_ClockwiseUtil_2_4_6,yneg_CounterClockwiseUtil_2_4_6,yneg_InjectUtil_2_4_6;
	wire[7:0] zpos_ClockwiseUtil_2_4_6,zpos_CounterClockwiseUtil_2_4_6,zpos_InjectUtil_2_4_6;
	wire[7:0] zneg_ClockwiseUtil_2_4_6,zneg_CounterClockwiseUtil_2_4_6,zneg_InjectUtil_2_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_4_7, eject_xpos_ser_2_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_4_7, eject_xneg_ser_2_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_4_7, eject_ypos_ser_2_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_4_7, eject_yneg_ser_2_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_4_7, eject_zpos_ser_2_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_4_7, eject_zneg_ser_2_4_7;
	wire[7:0] xpos_ClockwiseUtil_2_4_7,xpos_CounterClockwiseUtil_2_4_7,xpos_InjectUtil_2_4_7;
	wire[7:0] xneg_ClockwiseUtil_2_4_7,xneg_CounterClockwiseUtil_2_4_7,xneg_InjectUtil_2_4_7;
	wire[7:0] ypos_ClockwiseUtil_2_4_7,ypos_CounterClockwiseUtil_2_4_7,ypos_InjectUtil_2_4_7;
	wire[7:0] yneg_ClockwiseUtil_2_4_7,yneg_CounterClockwiseUtil_2_4_7,yneg_InjectUtil_2_4_7;
	wire[7:0] zpos_ClockwiseUtil_2_4_7,zpos_CounterClockwiseUtil_2_4_7,zpos_InjectUtil_2_4_7;
	wire[7:0] zneg_ClockwiseUtil_2_4_7,zneg_CounterClockwiseUtil_2_4_7,zneg_InjectUtil_2_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_0, eject_xpos_ser_2_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_0, eject_xneg_ser_2_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_0, eject_ypos_ser_2_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_0, eject_yneg_ser_2_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_0, eject_zpos_ser_2_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_0, eject_zneg_ser_2_5_0;
	wire[7:0] xpos_ClockwiseUtil_2_5_0,xpos_CounterClockwiseUtil_2_5_0,xpos_InjectUtil_2_5_0;
	wire[7:0] xneg_ClockwiseUtil_2_5_0,xneg_CounterClockwiseUtil_2_5_0,xneg_InjectUtil_2_5_0;
	wire[7:0] ypos_ClockwiseUtil_2_5_0,ypos_CounterClockwiseUtil_2_5_0,ypos_InjectUtil_2_5_0;
	wire[7:0] yneg_ClockwiseUtil_2_5_0,yneg_CounterClockwiseUtil_2_5_0,yneg_InjectUtil_2_5_0;
	wire[7:0] zpos_ClockwiseUtil_2_5_0,zpos_CounterClockwiseUtil_2_5_0,zpos_InjectUtil_2_5_0;
	wire[7:0] zneg_ClockwiseUtil_2_5_0,zneg_CounterClockwiseUtil_2_5_0,zneg_InjectUtil_2_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_1, eject_xpos_ser_2_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_1, eject_xneg_ser_2_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_1, eject_ypos_ser_2_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_1, eject_yneg_ser_2_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_1, eject_zpos_ser_2_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_1, eject_zneg_ser_2_5_1;
	wire[7:0] xpos_ClockwiseUtil_2_5_1,xpos_CounterClockwiseUtil_2_5_1,xpos_InjectUtil_2_5_1;
	wire[7:0] xneg_ClockwiseUtil_2_5_1,xneg_CounterClockwiseUtil_2_5_1,xneg_InjectUtil_2_5_1;
	wire[7:0] ypos_ClockwiseUtil_2_5_1,ypos_CounterClockwiseUtil_2_5_1,ypos_InjectUtil_2_5_1;
	wire[7:0] yneg_ClockwiseUtil_2_5_1,yneg_CounterClockwiseUtil_2_5_1,yneg_InjectUtil_2_5_1;
	wire[7:0] zpos_ClockwiseUtil_2_5_1,zpos_CounterClockwiseUtil_2_5_1,zpos_InjectUtil_2_5_1;
	wire[7:0] zneg_ClockwiseUtil_2_5_1,zneg_CounterClockwiseUtil_2_5_1,zneg_InjectUtil_2_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_2, eject_xpos_ser_2_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_2, eject_xneg_ser_2_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_2, eject_ypos_ser_2_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_2, eject_yneg_ser_2_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_2, eject_zpos_ser_2_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_2, eject_zneg_ser_2_5_2;
	wire[7:0] xpos_ClockwiseUtil_2_5_2,xpos_CounterClockwiseUtil_2_5_2,xpos_InjectUtil_2_5_2;
	wire[7:0] xneg_ClockwiseUtil_2_5_2,xneg_CounterClockwiseUtil_2_5_2,xneg_InjectUtil_2_5_2;
	wire[7:0] ypos_ClockwiseUtil_2_5_2,ypos_CounterClockwiseUtil_2_5_2,ypos_InjectUtil_2_5_2;
	wire[7:0] yneg_ClockwiseUtil_2_5_2,yneg_CounterClockwiseUtil_2_5_2,yneg_InjectUtil_2_5_2;
	wire[7:0] zpos_ClockwiseUtil_2_5_2,zpos_CounterClockwiseUtil_2_5_2,zpos_InjectUtil_2_5_2;
	wire[7:0] zneg_ClockwiseUtil_2_5_2,zneg_CounterClockwiseUtil_2_5_2,zneg_InjectUtil_2_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_3, eject_xpos_ser_2_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_3, eject_xneg_ser_2_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_3, eject_ypos_ser_2_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_3, eject_yneg_ser_2_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_3, eject_zpos_ser_2_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_3, eject_zneg_ser_2_5_3;
	wire[7:0] xpos_ClockwiseUtil_2_5_3,xpos_CounterClockwiseUtil_2_5_3,xpos_InjectUtil_2_5_3;
	wire[7:0] xneg_ClockwiseUtil_2_5_3,xneg_CounterClockwiseUtil_2_5_3,xneg_InjectUtil_2_5_3;
	wire[7:0] ypos_ClockwiseUtil_2_5_3,ypos_CounterClockwiseUtil_2_5_3,ypos_InjectUtil_2_5_3;
	wire[7:0] yneg_ClockwiseUtil_2_5_3,yneg_CounterClockwiseUtil_2_5_3,yneg_InjectUtil_2_5_3;
	wire[7:0] zpos_ClockwiseUtil_2_5_3,zpos_CounterClockwiseUtil_2_5_3,zpos_InjectUtil_2_5_3;
	wire[7:0] zneg_ClockwiseUtil_2_5_3,zneg_CounterClockwiseUtil_2_5_3,zneg_InjectUtil_2_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_4, eject_xpos_ser_2_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_4, eject_xneg_ser_2_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_4, eject_ypos_ser_2_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_4, eject_yneg_ser_2_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_4, eject_zpos_ser_2_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_4, eject_zneg_ser_2_5_4;
	wire[7:0] xpos_ClockwiseUtil_2_5_4,xpos_CounterClockwiseUtil_2_5_4,xpos_InjectUtil_2_5_4;
	wire[7:0] xneg_ClockwiseUtil_2_5_4,xneg_CounterClockwiseUtil_2_5_4,xneg_InjectUtil_2_5_4;
	wire[7:0] ypos_ClockwiseUtil_2_5_4,ypos_CounterClockwiseUtil_2_5_4,ypos_InjectUtil_2_5_4;
	wire[7:0] yneg_ClockwiseUtil_2_5_4,yneg_CounterClockwiseUtil_2_5_4,yneg_InjectUtil_2_5_4;
	wire[7:0] zpos_ClockwiseUtil_2_5_4,zpos_CounterClockwiseUtil_2_5_4,zpos_InjectUtil_2_5_4;
	wire[7:0] zneg_ClockwiseUtil_2_5_4,zneg_CounterClockwiseUtil_2_5_4,zneg_InjectUtil_2_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_5, eject_xpos_ser_2_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_5, eject_xneg_ser_2_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_5, eject_ypos_ser_2_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_5, eject_yneg_ser_2_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_5, eject_zpos_ser_2_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_5, eject_zneg_ser_2_5_5;
	wire[7:0] xpos_ClockwiseUtil_2_5_5,xpos_CounterClockwiseUtil_2_5_5,xpos_InjectUtil_2_5_5;
	wire[7:0] xneg_ClockwiseUtil_2_5_5,xneg_CounterClockwiseUtil_2_5_5,xneg_InjectUtil_2_5_5;
	wire[7:0] ypos_ClockwiseUtil_2_5_5,ypos_CounterClockwiseUtil_2_5_5,ypos_InjectUtil_2_5_5;
	wire[7:0] yneg_ClockwiseUtil_2_5_5,yneg_CounterClockwiseUtil_2_5_5,yneg_InjectUtil_2_5_5;
	wire[7:0] zpos_ClockwiseUtil_2_5_5,zpos_CounterClockwiseUtil_2_5_5,zpos_InjectUtil_2_5_5;
	wire[7:0] zneg_ClockwiseUtil_2_5_5,zneg_CounterClockwiseUtil_2_5_5,zneg_InjectUtil_2_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_6, eject_xpos_ser_2_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_6, eject_xneg_ser_2_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_6, eject_ypos_ser_2_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_6, eject_yneg_ser_2_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_6, eject_zpos_ser_2_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_6, eject_zneg_ser_2_5_6;
	wire[7:0] xpos_ClockwiseUtil_2_5_6,xpos_CounterClockwiseUtil_2_5_6,xpos_InjectUtil_2_5_6;
	wire[7:0] xneg_ClockwiseUtil_2_5_6,xneg_CounterClockwiseUtil_2_5_6,xneg_InjectUtil_2_5_6;
	wire[7:0] ypos_ClockwiseUtil_2_5_6,ypos_CounterClockwiseUtil_2_5_6,ypos_InjectUtil_2_5_6;
	wire[7:0] yneg_ClockwiseUtil_2_5_6,yneg_CounterClockwiseUtil_2_5_6,yneg_InjectUtil_2_5_6;
	wire[7:0] zpos_ClockwiseUtil_2_5_6,zpos_CounterClockwiseUtil_2_5_6,zpos_InjectUtil_2_5_6;
	wire[7:0] zneg_ClockwiseUtil_2_5_6,zneg_CounterClockwiseUtil_2_5_6,zneg_InjectUtil_2_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_5_7, eject_xpos_ser_2_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_5_7, eject_xneg_ser_2_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_5_7, eject_ypos_ser_2_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_5_7, eject_yneg_ser_2_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_5_7, eject_zpos_ser_2_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_5_7, eject_zneg_ser_2_5_7;
	wire[7:0] xpos_ClockwiseUtil_2_5_7,xpos_CounterClockwiseUtil_2_5_7,xpos_InjectUtil_2_5_7;
	wire[7:0] xneg_ClockwiseUtil_2_5_7,xneg_CounterClockwiseUtil_2_5_7,xneg_InjectUtil_2_5_7;
	wire[7:0] ypos_ClockwiseUtil_2_5_7,ypos_CounterClockwiseUtil_2_5_7,ypos_InjectUtil_2_5_7;
	wire[7:0] yneg_ClockwiseUtil_2_5_7,yneg_CounterClockwiseUtil_2_5_7,yneg_InjectUtil_2_5_7;
	wire[7:0] zpos_ClockwiseUtil_2_5_7,zpos_CounterClockwiseUtil_2_5_7,zpos_InjectUtil_2_5_7;
	wire[7:0] zneg_ClockwiseUtil_2_5_7,zneg_CounterClockwiseUtil_2_5_7,zneg_InjectUtil_2_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_0, eject_xpos_ser_2_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_0, eject_xneg_ser_2_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_0, eject_ypos_ser_2_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_0, eject_yneg_ser_2_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_0, eject_zpos_ser_2_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_0, eject_zneg_ser_2_6_0;
	wire[7:0] xpos_ClockwiseUtil_2_6_0,xpos_CounterClockwiseUtil_2_6_0,xpos_InjectUtil_2_6_0;
	wire[7:0] xneg_ClockwiseUtil_2_6_0,xneg_CounterClockwiseUtil_2_6_0,xneg_InjectUtil_2_6_0;
	wire[7:0] ypos_ClockwiseUtil_2_6_0,ypos_CounterClockwiseUtil_2_6_0,ypos_InjectUtil_2_6_0;
	wire[7:0] yneg_ClockwiseUtil_2_6_0,yneg_CounterClockwiseUtil_2_6_0,yneg_InjectUtil_2_6_0;
	wire[7:0] zpos_ClockwiseUtil_2_6_0,zpos_CounterClockwiseUtil_2_6_0,zpos_InjectUtil_2_6_0;
	wire[7:0] zneg_ClockwiseUtil_2_6_0,zneg_CounterClockwiseUtil_2_6_0,zneg_InjectUtil_2_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_1, eject_xpos_ser_2_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_1, eject_xneg_ser_2_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_1, eject_ypos_ser_2_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_1, eject_yneg_ser_2_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_1, eject_zpos_ser_2_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_1, eject_zneg_ser_2_6_1;
	wire[7:0] xpos_ClockwiseUtil_2_6_1,xpos_CounterClockwiseUtil_2_6_1,xpos_InjectUtil_2_6_1;
	wire[7:0] xneg_ClockwiseUtil_2_6_1,xneg_CounterClockwiseUtil_2_6_1,xneg_InjectUtil_2_6_1;
	wire[7:0] ypos_ClockwiseUtil_2_6_1,ypos_CounterClockwiseUtil_2_6_1,ypos_InjectUtil_2_6_1;
	wire[7:0] yneg_ClockwiseUtil_2_6_1,yneg_CounterClockwiseUtil_2_6_1,yneg_InjectUtil_2_6_1;
	wire[7:0] zpos_ClockwiseUtil_2_6_1,zpos_CounterClockwiseUtil_2_6_1,zpos_InjectUtil_2_6_1;
	wire[7:0] zneg_ClockwiseUtil_2_6_1,zneg_CounterClockwiseUtil_2_6_1,zneg_InjectUtil_2_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_2, eject_xpos_ser_2_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_2, eject_xneg_ser_2_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_2, eject_ypos_ser_2_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_2, eject_yneg_ser_2_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_2, eject_zpos_ser_2_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_2, eject_zneg_ser_2_6_2;
	wire[7:0] xpos_ClockwiseUtil_2_6_2,xpos_CounterClockwiseUtil_2_6_2,xpos_InjectUtil_2_6_2;
	wire[7:0] xneg_ClockwiseUtil_2_6_2,xneg_CounterClockwiseUtil_2_6_2,xneg_InjectUtil_2_6_2;
	wire[7:0] ypos_ClockwiseUtil_2_6_2,ypos_CounterClockwiseUtil_2_6_2,ypos_InjectUtil_2_6_2;
	wire[7:0] yneg_ClockwiseUtil_2_6_2,yneg_CounterClockwiseUtil_2_6_2,yneg_InjectUtil_2_6_2;
	wire[7:0] zpos_ClockwiseUtil_2_6_2,zpos_CounterClockwiseUtil_2_6_2,zpos_InjectUtil_2_6_2;
	wire[7:0] zneg_ClockwiseUtil_2_6_2,zneg_CounterClockwiseUtil_2_6_2,zneg_InjectUtil_2_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_3, eject_xpos_ser_2_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_3, eject_xneg_ser_2_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_3, eject_ypos_ser_2_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_3, eject_yneg_ser_2_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_3, eject_zpos_ser_2_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_3, eject_zneg_ser_2_6_3;
	wire[7:0] xpos_ClockwiseUtil_2_6_3,xpos_CounterClockwiseUtil_2_6_3,xpos_InjectUtil_2_6_3;
	wire[7:0] xneg_ClockwiseUtil_2_6_3,xneg_CounterClockwiseUtil_2_6_3,xneg_InjectUtil_2_6_3;
	wire[7:0] ypos_ClockwiseUtil_2_6_3,ypos_CounterClockwiseUtil_2_6_3,ypos_InjectUtil_2_6_3;
	wire[7:0] yneg_ClockwiseUtil_2_6_3,yneg_CounterClockwiseUtil_2_6_3,yneg_InjectUtil_2_6_3;
	wire[7:0] zpos_ClockwiseUtil_2_6_3,zpos_CounterClockwiseUtil_2_6_3,zpos_InjectUtil_2_6_3;
	wire[7:0] zneg_ClockwiseUtil_2_6_3,zneg_CounterClockwiseUtil_2_6_3,zneg_InjectUtil_2_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_4, eject_xpos_ser_2_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_4, eject_xneg_ser_2_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_4, eject_ypos_ser_2_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_4, eject_yneg_ser_2_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_4, eject_zpos_ser_2_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_4, eject_zneg_ser_2_6_4;
	wire[7:0] xpos_ClockwiseUtil_2_6_4,xpos_CounterClockwiseUtil_2_6_4,xpos_InjectUtil_2_6_4;
	wire[7:0] xneg_ClockwiseUtil_2_6_4,xneg_CounterClockwiseUtil_2_6_4,xneg_InjectUtil_2_6_4;
	wire[7:0] ypos_ClockwiseUtil_2_6_4,ypos_CounterClockwiseUtil_2_6_4,ypos_InjectUtil_2_6_4;
	wire[7:0] yneg_ClockwiseUtil_2_6_4,yneg_CounterClockwiseUtil_2_6_4,yneg_InjectUtil_2_6_4;
	wire[7:0] zpos_ClockwiseUtil_2_6_4,zpos_CounterClockwiseUtil_2_6_4,zpos_InjectUtil_2_6_4;
	wire[7:0] zneg_ClockwiseUtil_2_6_4,zneg_CounterClockwiseUtil_2_6_4,zneg_InjectUtil_2_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_5, eject_xpos_ser_2_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_5, eject_xneg_ser_2_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_5, eject_ypos_ser_2_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_5, eject_yneg_ser_2_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_5, eject_zpos_ser_2_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_5, eject_zneg_ser_2_6_5;
	wire[7:0] xpos_ClockwiseUtil_2_6_5,xpos_CounterClockwiseUtil_2_6_5,xpos_InjectUtil_2_6_5;
	wire[7:0] xneg_ClockwiseUtil_2_6_5,xneg_CounterClockwiseUtil_2_6_5,xneg_InjectUtil_2_6_5;
	wire[7:0] ypos_ClockwiseUtil_2_6_5,ypos_CounterClockwiseUtil_2_6_5,ypos_InjectUtil_2_6_5;
	wire[7:0] yneg_ClockwiseUtil_2_6_5,yneg_CounterClockwiseUtil_2_6_5,yneg_InjectUtil_2_6_5;
	wire[7:0] zpos_ClockwiseUtil_2_6_5,zpos_CounterClockwiseUtil_2_6_5,zpos_InjectUtil_2_6_5;
	wire[7:0] zneg_ClockwiseUtil_2_6_5,zneg_CounterClockwiseUtil_2_6_5,zneg_InjectUtil_2_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_6, eject_xpos_ser_2_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_6, eject_xneg_ser_2_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_6, eject_ypos_ser_2_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_6, eject_yneg_ser_2_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_6, eject_zpos_ser_2_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_6, eject_zneg_ser_2_6_6;
	wire[7:0] xpos_ClockwiseUtil_2_6_6,xpos_CounterClockwiseUtil_2_6_6,xpos_InjectUtil_2_6_6;
	wire[7:0] xneg_ClockwiseUtil_2_6_6,xneg_CounterClockwiseUtil_2_6_6,xneg_InjectUtil_2_6_6;
	wire[7:0] ypos_ClockwiseUtil_2_6_6,ypos_CounterClockwiseUtil_2_6_6,ypos_InjectUtil_2_6_6;
	wire[7:0] yneg_ClockwiseUtil_2_6_6,yneg_CounterClockwiseUtil_2_6_6,yneg_InjectUtil_2_6_6;
	wire[7:0] zpos_ClockwiseUtil_2_6_6,zpos_CounterClockwiseUtil_2_6_6,zpos_InjectUtil_2_6_6;
	wire[7:0] zneg_ClockwiseUtil_2_6_6,zneg_CounterClockwiseUtil_2_6_6,zneg_InjectUtil_2_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_6_7, eject_xpos_ser_2_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_6_7, eject_xneg_ser_2_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_6_7, eject_ypos_ser_2_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_6_7, eject_yneg_ser_2_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_6_7, eject_zpos_ser_2_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_6_7, eject_zneg_ser_2_6_7;
	wire[7:0] xpos_ClockwiseUtil_2_6_7,xpos_CounterClockwiseUtil_2_6_7,xpos_InjectUtil_2_6_7;
	wire[7:0] xneg_ClockwiseUtil_2_6_7,xneg_CounterClockwiseUtil_2_6_7,xneg_InjectUtil_2_6_7;
	wire[7:0] ypos_ClockwiseUtil_2_6_7,ypos_CounterClockwiseUtil_2_6_7,ypos_InjectUtil_2_6_7;
	wire[7:0] yneg_ClockwiseUtil_2_6_7,yneg_CounterClockwiseUtil_2_6_7,yneg_InjectUtil_2_6_7;
	wire[7:0] zpos_ClockwiseUtil_2_6_7,zpos_CounterClockwiseUtil_2_6_7,zpos_InjectUtil_2_6_7;
	wire[7:0] zneg_ClockwiseUtil_2_6_7,zneg_CounterClockwiseUtil_2_6_7,zneg_InjectUtil_2_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_0, eject_xpos_ser_2_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_0, eject_xneg_ser_2_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_0, eject_ypos_ser_2_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_0, eject_yneg_ser_2_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_0, eject_zpos_ser_2_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_0, eject_zneg_ser_2_7_0;
	wire[7:0] xpos_ClockwiseUtil_2_7_0,xpos_CounterClockwiseUtil_2_7_0,xpos_InjectUtil_2_7_0;
	wire[7:0] xneg_ClockwiseUtil_2_7_0,xneg_CounterClockwiseUtil_2_7_0,xneg_InjectUtil_2_7_0;
	wire[7:0] ypos_ClockwiseUtil_2_7_0,ypos_CounterClockwiseUtil_2_7_0,ypos_InjectUtil_2_7_0;
	wire[7:0] yneg_ClockwiseUtil_2_7_0,yneg_CounterClockwiseUtil_2_7_0,yneg_InjectUtil_2_7_0;
	wire[7:0] zpos_ClockwiseUtil_2_7_0,zpos_CounterClockwiseUtil_2_7_0,zpos_InjectUtil_2_7_0;
	wire[7:0] zneg_ClockwiseUtil_2_7_0,zneg_CounterClockwiseUtil_2_7_0,zneg_InjectUtil_2_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_1, eject_xpos_ser_2_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_1, eject_xneg_ser_2_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_1, eject_ypos_ser_2_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_1, eject_yneg_ser_2_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_1, eject_zpos_ser_2_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_1, eject_zneg_ser_2_7_1;
	wire[7:0] xpos_ClockwiseUtil_2_7_1,xpos_CounterClockwiseUtil_2_7_1,xpos_InjectUtil_2_7_1;
	wire[7:0] xneg_ClockwiseUtil_2_7_1,xneg_CounterClockwiseUtil_2_7_1,xneg_InjectUtil_2_7_1;
	wire[7:0] ypos_ClockwiseUtil_2_7_1,ypos_CounterClockwiseUtil_2_7_1,ypos_InjectUtil_2_7_1;
	wire[7:0] yneg_ClockwiseUtil_2_7_1,yneg_CounterClockwiseUtil_2_7_1,yneg_InjectUtil_2_7_1;
	wire[7:0] zpos_ClockwiseUtil_2_7_1,zpos_CounterClockwiseUtil_2_7_1,zpos_InjectUtil_2_7_1;
	wire[7:0] zneg_ClockwiseUtil_2_7_1,zneg_CounterClockwiseUtil_2_7_1,zneg_InjectUtil_2_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_2, eject_xpos_ser_2_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_2, eject_xneg_ser_2_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_2, eject_ypos_ser_2_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_2, eject_yneg_ser_2_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_2, eject_zpos_ser_2_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_2, eject_zneg_ser_2_7_2;
	wire[7:0] xpos_ClockwiseUtil_2_7_2,xpos_CounterClockwiseUtil_2_7_2,xpos_InjectUtil_2_7_2;
	wire[7:0] xneg_ClockwiseUtil_2_7_2,xneg_CounterClockwiseUtil_2_7_2,xneg_InjectUtil_2_7_2;
	wire[7:0] ypos_ClockwiseUtil_2_7_2,ypos_CounterClockwiseUtil_2_7_2,ypos_InjectUtil_2_7_2;
	wire[7:0] yneg_ClockwiseUtil_2_7_2,yneg_CounterClockwiseUtil_2_7_2,yneg_InjectUtil_2_7_2;
	wire[7:0] zpos_ClockwiseUtil_2_7_2,zpos_CounterClockwiseUtil_2_7_2,zpos_InjectUtil_2_7_2;
	wire[7:0] zneg_ClockwiseUtil_2_7_2,zneg_CounterClockwiseUtil_2_7_2,zneg_InjectUtil_2_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_3, eject_xpos_ser_2_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_3, eject_xneg_ser_2_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_3, eject_ypos_ser_2_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_3, eject_yneg_ser_2_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_3, eject_zpos_ser_2_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_3, eject_zneg_ser_2_7_3;
	wire[7:0] xpos_ClockwiseUtil_2_7_3,xpos_CounterClockwiseUtil_2_7_3,xpos_InjectUtil_2_7_3;
	wire[7:0] xneg_ClockwiseUtil_2_7_3,xneg_CounterClockwiseUtil_2_7_3,xneg_InjectUtil_2_7_3;
	wire[7:0] ypos_ClockwiseUtil_2_7_3,ypos_CounterClockwiseUtil_2_7_3,ypos_InjectUtil_2_7_3;
	wire[7:0] yneg_ClockwiseUtil_2_7_3,yneg_CounterClockwiseUtil_2_7_3,yneg_InjectUtil_2_7_3;
	wire[7:0] zpos_ClockwiseUtil_2_7_3,zpos_CounterClockwiseUtil_2_7_3,zpos_InjectUtil_2_7_3;
	wire[7:0] zneg_ClockwiseUtil_2_7_3,zneg_CounterClockwiseUtil_2_7_3,zneg_InjectUtil_2_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_4, eject_xpos_ser_2_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_4, eject_xneg_ser_2_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_4, eject_ypos_ser_2_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_4, eject_yneg_ser_2_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_4, eject_zpos_ser_2_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_4, eject_zneg_ser_2_7_4;
	wire[7:0] xpos_ClockwiseUtil_2_7_4,xpos_CounterClockwiseUtil_2_7_4,xpos_InjectUtil_2_7_4;
	wire[7:0] xneg_ClockwiseUtil_2_7_4,xneg_CounterClockwiseUtil_2_7_4,xneg_InjectUtil_2_7_4;
	wire[7:0] ypos_ClockwiseUtil_2_7_4,ypos_CounterClockwiseUtil_2_7_4,ypos_InjectUtil_2_7_4;
	wire[7:0] yneg_ClockwiseUtil_2_7_4,yneg_CounterClockwiseUtil_2_7_4,yneg_InjectUtil_2_7_4;
	wire[7:0] zpos_ClockwiseUtil_2_7_4,zpos_CounterClockwiseUtil_2_7_4,zpos_InjectUtil_2_7_4;
	wire[7:0] zneg_ClockwiseUtil_2_7_4,zneg_CounterClockwiseUtil_2_7_4,zneg_InjectUtil_2_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_5, eject_xpos_ser_2_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_5, eject_xneg_ser_2_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_5, eject_ypos_ser_2_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_5, eject_yneg_ser_2_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_5, eject_zpos_ser_2_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_5, eject_zneg_ser_2_7_5;
	wire[7:0] xpos_ClockwiseUtil_2_7_5,xpos_CounterClockwiseUtil_2_7_5,xpos_InjectUtil_2_7_5;
	wire[7:0] xneg_ClockwiseUtil_2_7_5,xneg_CounterClockwiseUtil_2_7_5,xneg_InjectUtil_2_7_5;
	wire[7:0] ypos_ClockwiseUtil_2_7_5,ypos_CounterClockwiseUtil_2_7_5,ypos_InjectUtil_2_7_5;
	wire[7:0] yneg_ClockwiseUtil_2_7_5,yneg_CounterClockwiseUtil_2_7_5,yneg_InjectUtil_2_7_5;
	wire[7:0] zpos_ClockwiseUtil_2_7_5,zpos_CounterClockwiseUtil_2_7_5,zpos_InjectUtil_2_7_5;
	wire[7:0] zneg_ClockwiseUtil_2_7_5,zneg_CounterClockwiseUtil_2_7_5,zneg_InjectUtil_2_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_6, eject_xpos_ser_2_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_6, eject_xneg_ser_2_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_6, eject_ypos_ser_2_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_6, eject_yneg_ser_2_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_6, eject_zpos_ser_2_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_6, eject_zneg_ser_2_7_6;
	wire[7:0] xpos_ClockwiseUtil_2_7_6,xpos_CounterClockwiseUtil_2_7_6,xpos_InjectUtil_2_7_6;
	wire[7:0] xneg_ClockwiseUtil_2_7_6,xneg_CounterClockwiseUtil_2_7_6,xneg_InjectUtil_2_7_6;
	wire[7:0] ypos_ClockwiseUtil_2_7_6,ypos_CounterClockwiseUtil_2_7_6,ypos_InjectUtil_2_7_6;
	wire[7:0] yneg_ClockwiseUtil_2_7_6,yneg_CounterClockwiseUtil_2_7_6,yneg_InjectUtil_2_7_6;
	wire[7:0] zpos_ClockwiseUtil_2_7_6,zpos_CounterClockwiseUtil_2_7_6,zpos_InjectUtil_2_7_6;
	wire[7:0] zneg_ClockwiseUtil_2_7_6,zneg_CounterClockwiseUtil_2_7_6,zneg_InjectUtil_2_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_2_7_7, eject_xpos_ser_2_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_2_7_7, eject_xneg_ser_2_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_2_7_7, eject_ypos_ser_2_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_2_7_7, eject_yneg_ser_2_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_2_7_7, eject_zpos_ser_2_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_2_7_7, eject_zneg_ser_2_7_7;
	wire[7:0] xpos_ClockwiseUtil_2_7_7,xpos_CounterClockwiseUtil_2_7_7,xpos_InjectUtil_2_7_7;
	wire[7:0] xneg_ClockwiseUtil_2_7_7,xneg_CounterClockwiseUtil_2_7_7,xneg_InjectUtil_2_7_7;
	wire[7:0] ypos_ClockwiseUtil_2_7_7,ypos_CounterClockwiseUtil_2_7_7,ypos_InjectUtil_2_7_7;
	wire[7:0] yneg_ClockwiseUtil_2_7_7,yneg_CounterClockwiseUtil_2_7_7,yneg_InjectUtil_2_7_7;
	wire[7:0] zpos_ClockwiseUtil_2_7_7,zpos_CounterClockwiseUtil_2_7_7,zpos_InjectUtil_2_7_7;
	wire[7:0] zneg_ClockwiseUtil_2_7_7,zneg_CounterClockwiseUtil_2_7_7,zneg_InjectUtil_2_7_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_0, eject_xpos_ser_3_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_0, eject_xneg_ser_3_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_0, eject_ypos_ser_3_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_0, eject_yneg_ser_3_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_0, eject_zpos_ser_3_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_0, eject_zneg_ser_3_0_0;
	wire[7:0] xpos_ClockwiseUtil_3_0_0,xpos_CounterClockwiseUtil_3_0_0,xpos_InjectUtil_3_0_0;
	wire[7:0] xneg_ClockwiseUtil_3_0_0,xneg_CounterClockwiseUtil_3_0_0,xneg_InjectUtil_3_0_0;
	wire[7:0] ypos_ClockwiseUtil_3_0_0,ypos_CounterClockwiseUtil_3_0_0,ypos_InjectUtil_3_0_0;
	wire[7:0] yneg_ClockwiseUtil_3_0_0,yneg_CounterClockwiseUtil_3_0_0,yneg_InjectUtil_3_0_0;
	wire[7:0] zpos_ClockwiseUtil_3_0_0,zpos_CounterClockwiseUtil_3_0_0,zpos_InjectUtil_3_0_0;
	wire[7:0] zneg_ClockwiseUtil_3_0_0,zneg_CounterClockwiseUtil_3_0_0,zneg_InjectUtil_3_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_1, eject_xpos_ser_3_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_1, eject_xneg_ser_3_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_1, eject_ypos_ser_3_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_1, eject_yneg_ser_3_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_1, eject_zpos_ser_3_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_1, eject_zneg_ser_3_0_1;
	wire[7:0] xpos_ClockwiseUtil_3_0_1,xpos_CounterClockwiseUtil_3_0_1,xpos_InjectUtil_3_0_1;
	wire[7:0] xneg_ClockwiseUtil_3_0_1,xneg_CounterClockwiseUtil_3_0_1,xneg_InjectUtil_3_0_1;
	wire[7:0] ypos_ClockwiseUtil_3_0_1,ypos_CounterClockwiseUtil_3_0_1,ypos_InjectUtil_3_0_1;
	wire[7:0] yneg_ClockwiseUtil_3_0_1,yneg_CounterClockwiseUtil_3_0_1,yneg_InjectUtil_3_0_1;
	wire[7:0] zpos_ClockwiseUtil_3_0_1,zpos_CounterClockwiseUtil_3_0_1,zpos_InjectUtil_3_0_1;
	wire[7:0] zneg_ClockwiseUtil_3_0_1,zneg_CounterClockwiseUtil_3_0_1,zneg_InjectUtil_3_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_2, eject_xpos_ser_3_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_2, eject_xneg_ser_3_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_2, eject_ypos_ser_3_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_2, eject_yneg_ser_3_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_2, eject_zpos_ser_3_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_2, eject_zneg_ser_3_0_2;
	wire[7:0] xpos_ClockwiseUtil_3_0_2,xpos_CounterClockwiseUtil_3_0_2,xpos_InjectUtil_3_0_2;
	wire[7:0] xneg_ClockwiseUtil_3_0_2,xneg_CounterClockwiseUtil_3_0_2,xneg_InjectUtil_3_0_2;
	wire[7:0] ypos_ClockwiseUtil_3_0_2,ypos_CounterClockwiseUtil_3_0_2,ypos_InjectUtil_3_0_2;
	wire[7:0] yneg_ClockwiseUtil_3_0_2,yneg_CounterClockwiseUtil_3_0_2,yneg_InjectUtil_3_0_2;
	wire[7:0] zpos_ClockwiseUtil_3_0_2,zpos_CounterClockwiseUtil_3_0_2,zpos_InjectUtil_3_0_2;
	wire[7:0] zneg_ClockwiseUtil_3_0_2,zneg_CounterClockwiseUtil_3_0_2,zneg_InjectUtil_3_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_3, eject_xpos_ser_3_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_3, eject_xneg_ser_3_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_3, eject_ypos_ser_3_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_3, eject_yneg_ser_3_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_3, eject_zpos_ser_3_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_3, eject_zneg_ser_3_0_3;
	wire[7:0] xpos_ClockwiseUtil_3_0_3,xpos_CounterClockwiseUtil_3_0_3,xpos_InjectUtil_3_0_3;
	wire[7:0] xneg_ClockwiseUtil_3_0_3,xneg_CounterClockwiseUtil_3_0_3,xneg_InjectUtil_3_0_3;
	wire[7:0] ypos_ClockwiseUtil_3_0_3,ypos_CounterClockwiseUtil_3_0_3,ypos_InjectUtil_3_0_3;
	wire[7:0] yneg_ClockwiseUtil_3_0_3,yneg_CounterClockwiseUtil_3_0_3,yneg_InjectUtil_3_0_3;
	wire[7:0] zpos_ClockwiseUtil_3_0_3,zpos_CounterClockwiseUtil_3_0_3,zpos_InjectUtil_3_0_3;
	wire[7:0] zneg_ClockwiseUtil_3_0_3,zneg_CounterClockwiseUtil_3_0_3,zneg_InjectUtil_3_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_4, eject_xpos_ser_3_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_4, eject_xneg_ser_3_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_4, eject_ypos_ser_3_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_4, eject_yneg_ser_3_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_4, eject_zpos_ser_3_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_4, eject_zneg_ser_3_0_4;
	wire[7:0] xpos_ClockwiseUtil_3_0_4,xpos_CounterClockwiseUtil_3_0_4,xpos_InjectUtil_3_0_4;
	wire[7:0] xneg_ClockwiseUtil_3_0_4,xneg_CounterClockwiseUtil_3_0_4,xneg_InjectUtil_3_0_4;
	wire[7:0] ypos_ClockwiseUtil_3_0_4,ypos_CounterClockwiseUtil_3_0_4,ypos_InjectUtil_3_0_4;
	wire[7:0] yneg_ClockwiseUtil_3_0_4,yneg_CounterClockwiseUtil_3_0_4,yneg_InjectUtil_3_0_4;
	wire[7:0] zpos_ClockwiseUtil_3_0_4,zpos_CounterClockwiseUtil_3_0_4,zpos_InjectUtil_3_0_4;
	wire[7:0] zneg_ClockwiseUtil_3_0_4,zneg_CounterClockwiseUtil_3_0_4,zneg_InjectUtil_3_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_5, eject_xpos_ser_3_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_5, eject_xneg_ser_3_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_5, eject_ypos_ser_3_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_5, eject_yneg_ser_3_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_5, eject_zpos_ser_3_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_5, eject_zneg_ser_3_0_5;
	wire[7:0] xpos_ClockwiseUtil_3_0_5,xpos_CounterClockwiseUtil_3_0_5,xpos_InjectUtil_3_0_5;
	wire[7:0] xneg_ClockwiseUtil_3_0_5,xneg_CounterClockwiseUtil_3_0_5,xneg_InjectUtil_3_0_5;
	wire[7:0] ypos_ClockwiseUtil_3_0_5,ypos_CounterClockwiseUtil_3_0_5,ypos_InjectUtil_3_0_5;
	wire[7:0] yneg_ClockwiseUtil_3_0_5,yneg_CounterClockwiseUtil_3_0_5,yneg_InjectUtil_3_0_5;
	wire[7:0] zpos_ClockwiseUtil_3_0_5,zpos_CounterClockwiseUtil_3_0_5,zpos_InjectUtil_3_0_5;
	wire[7:0] zneg_ClockwiseUtil_3_0_5,zneg_CounterClockwiseUtil_3_0_5,zneg_InjectUtil_3_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_6, eject_xpos_ser_3_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_6, eject_xneg_ser_3_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_6, eject_ypos_ser_3_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_6, eject_yneg_ser_3_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_6, eject_zpos_ser_3_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_6, eject_zneg_ser_3_0_6;
	wire[7:0] xpos_ClockwiseUtil_3_0_6,xpos_CounterClockwiseUtil_3_0_6,xpos_InjectUtil_3_0_6;
	wire[7:0] xneg_ClockwiseUtil_3_0_6,xneg_CounterClockwiseUtil_3_0_6,xneg_InjectUtil_3_0_6;
	wire[7:0] ypos_ClockwiseUtil_3_0_6,ypos_CounterClockwiseUtil_3_0_6,ypos_InjectUtil_3_0_6;
	wire[7:0] yneg_ClockwiseUtil_3_0_6,yneg_CounterClockwiseUtil_3_0_6,yneg_InjectUtil_3_0_6;
	wire[7:0] zpos_ClockwiseUtil_3_0_6,zpos_CounterClockwiseUtil_3_0_6,zpos_InjectUtil_3_0_6;
	wire[7:0] zneg_ClockwiseUtil_3_0_6,zneg_CounterClockwiseUtil_3_0_6,zneg_InjectUtil_3_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_0_7, eject_xpos_ser_3_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_0_7, eject_xneg_ser_3_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_0_7, eject_ypos_ser_3_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_0_7, eject_yneg_ser_3_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_0_7, eject_zpos_ser_3_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_0_7, eject_zneg_ser_3_0_7;
	wire[7:0] xpos_ClockwiseUtil_3_0_7,xpos_CounterClockwiseUtil_3_0_7,xpos_InjectUtil_3_0_7;
	wire[7:0] xneg_ClockwiseUtil_3_0_7,xneg_CounterClockwiseUtil_3_0_7,xneg_InjectUtil_3_0_7;
	wire[7:0] ypos_ClockwiseUtil_3_0_7,ypos_CounterClockwiseUtil_3_0_7,ypos_InjectUtil_3_0_7;
	wire[7:0] yneg_ClockwiseUtil_3_0_7,yneg_CounterClockwiseUtil_3_0_7,yneg_InjectUtil_3_0_7;
	wire[7:0] zpos_ClockwiseUtil_3_0_7,zpos_CounterClockwiseUtil_3_0_7,zpos_InjectUtil_3_0_7;
	wire[7:0] zneg_ClockwiseUtil_3_0_7,zneg_CounterClockwiseUtil_3_0_7,zneg_InjectUtil_3_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_0, eject_xpos_ser_3_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_0, eject_xneg_ser_3_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_0, eject_ypos_ser_3_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_0, eject_yneg_ser_3_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_0, eject_zpos_ser_3_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_0, eject_zneg_ser_3_1_0;
	wire[7:0] xpos_ClockwiseUtil_3_1_0,xpos_CounterClockwiseUtil_3_1_0,xpos_InjectUtil_3_1_0;
	wire[7:0] xneg_ClockwiseUtil_3_1_0,xneg_CounterClockwiseUtil_3_1_0,xneg_InjectUtil_3_1_0;
	wire[7:0] ypos_ClockwiseUtil_3_1_0,ypos_CounterClockwiseUtil_3_1_0,ypos_InjectUtil_3_1_0;
	wire[7:0] yneg_ClockwiseUtil_3_1_0,yneg_CounterClockwiseUtil_3_1_0,yneg_InjectUtil_3_1_0;
	wire[7:0] zpos_ClockwiseUtil_3_1_0,zpos_CounterClockwiseUtil_3_1_0,zpos_InjectUtil_3_1_0;
	wire[7:0] zneg_ClockwiseUtil_3_1_0,zneg_CounterClockwiseUtil_3_1_0,zneg_InjectUtil_3_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_1, eject_xpos_ser_3_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_1, eject_xneg_ser_3_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_1, eject_ypos_ser_3_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_1, eject_yneg_ser_3_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_1, eject_zpos_ser_3_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_1, eject_zneg_ser_3_1_1;
	wire[7:0] xpos_ClockwiseUtil_3_1_1,xpos_CounterClockwiseUtil_3_1_1,xpos_InjectUtil_3_1_1;
	wire[7:0] xneg_ClockwiseUtil_3_1_1,xneg_CounterClockwiseUtil_3_1_1,xneg_InjectUtil_3_1_1;
	wire[7:0] ypos_ClockwiseUtil_3_1_1,ypos_CounterClockwiseUtil_3_1_1,ypos_InjectUtil_3_1_1;
	wire[7:0] yneg_ClockwiseUtil_3_1_1,yneg_CounterClockwiseUtil_3_1_1,yneg_InjectUtil_3_1_1;
	wire[7:0] zpos_ClockwiseUtil_3_1_1,zpos_CounterClockwiseUtil_3_1_1,zpos_InjectUtil_3_1_1;
	wire[7:0] zneg_ClockwiseUtil_3_1_1,zneg_CounterClockwiseUtil_3_1_1,zneg_InjectUtil_3_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_2, eject_xpos_ser_3_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_2, eject_xneg_ser_3_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_2, eject_ypos_ser_3_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_2, eject_yneg_ser_3_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_2, eject_zpos_ser_3_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_2, eject_zneg_ser_3_1_2;
	wire[7:0] xpos_ClockwiseUtil_3_1_2,xpos_CounterClockwiseUtil_3_1_2,xpos_InjectUtil_3_1_2;
	wire[7:0] xneg_ClockwiseUtil_3_1_2,xneg_CounterClockwiseUtil_3_1_2,xneg_InjectUtil_3_1_2;
	wire[7:0] ypos_ClockwiseUtil_3_1_2,ypos_CounterClockwiseUtil_3_1_2,ypos_InjectUtil_3_1_2;
	wire[7:0] yneg_ClockwiseUtil_3_1_2,yneg_CounterClockwiseUtil_3_1_2,yneg_InjectUtil_3_1_2;
	wire[7:0] zpos_ClockwiseUtil_3_1_2,zpos_CounterClockwiseUtil_3_1_2,zpos_InjectUtil_3_1_2;
	wire[7:0] zneg_ClockwiseUtil_3_1_2,zneg_CounterClockwiseUtil_3_1_2,zneg_InjectUtil_3_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_3, eject_xpos_ser_3_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_3, eject_xneg_ser_3_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_3, eject_ypos_ser_3_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_3, eject_yneg_ser_3_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_3, eject_zpos_ser_3_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_3, eject_zneg_ser_3_1_3;
	wire[7:0] xpos_ClockwiseUtil_3_1_3,xpos_CounterClockwiseUtil_3_1_3,xpos_InjectUtil_3_1_3;
	wire[7:0] xneg_ClockwiseUtil_3_1_3,xneg_CounterClockwiseUtil_3_1_3,xneg_InjectUtil_3_1_3;
	wire[7:0] ypos_ClockwiseUtil_3_1_3,ypos_CounterClockwiseUtil_3_1_3,ypos_InjectUtil_3_1_3;
	wire[7:0] yneg_ClockwiseUtil_3_1_3,yneg_CounterClockwiseUtil_3_1_3,yneg_InjectUtil_3_1_3;
	wire[7:0] zpos_ClockwiseUtil_3_1_3,zpos_CounterClockwiseUtil_3_1_3,zpos_InjectUtil_3_1_3;
	wire[7:0] zneg_ClockwiseUtil_3_1_3,zneg_CounterClockwiseUtil_3_1_3,zneg_InjectUtil_3_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_4, eject_xpos_ser_3_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_4, eject_xneg_ser_3_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_4, eject_ypos_ser_3_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_4, eject_yneg_ser_3_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_4, eject_zpos_ser_3_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_4, eject_zneg_ser_3_1_4;
	wire[7:0] xpos_ClockwiseUtil_3_1_4,xpos_CounterClockwiseUtil_3_1_4,xpos_InjectUtil_3_1_4;
	wire[7:0] xneg_ClockwiseUtil_3_1_4,xneg_CounterClockwiseUtil_3_1_4,xneg_InjectUtil_3_1_4;
	wire[7:0] ypos_ClockwiseUtil_3_1_4,ypos_CounterClockwiseUtil_3_1_4,ypos_InjectUtil_3_1_4;
	wire[7:0] yneg_ClockwiseUtil_3_1_4,yneg_CounterClockwiseUtil_3_1_4,yneg_InjectUtil_3_1_4;
	wire[7:0] zpos_ClockwiseUtil_3_1_4,zpos_CounterClockwiseUtil_3_1_4,zpos_InjectUtil_3_1_4;
	wire[7:0] zneg_ClockwiseUtil_3_1_4,zneg_CounterClockwiseUtil_3_1_4,zneg_InjectUtil_3_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_5, eject_xpos_ser_3_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_5, eject_xneg_ser_3_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_5, eject_ypos_ser_3_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_5, eject_yneg_ser_3_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_5, eject_zpos_ser_3_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_5, eject_zneg_ser_3_1_5;
	wire[7:0] xpos_ClockwiseUtil_3_1_5,xpos_CounterClockwiseUtil_3_1_5,xpos_InjectUtil_3_1_5;
	wire[7:0] xneg_ClockwiseUtil_3_1_5,xneg_CounterClockwiseUtil_3_1_5,xneg_InjectUtil_3_1_5;
	wire[7:0] ypos_ClockwiseUtil_3_1_5,ypos_CounterClockwiseUtil_3_1_5,ypos_InjectUtil_3_1_5;
	wire[7:0] yneg_ClockwiseUtil_3_1_5,yneg_CounterClockwiseUtil_3_1_5,yneg_InjectUtil_3_1_5;
	wire[7:0] zpos_ClockwiseUtil_3_1_5,zpos_CounterClockwiseUtil_3_1_5,zpos_InjectUtil_3_1_5;
	wire[7:0] zneg_ClockwiseUtil_3_1_5,zneg_CounterClockwiseUtil_3_1_5,zneg_InjectUtil_3_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_6, eject_xpos_ser_3_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_6, eject_xneg_ser_3_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_6, eject_ypos_ser_3_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_6, eject_yneg_ser_3_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_6, eject_zpos_ser_3_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_6, eject_zneg_ser_3_1_6;
	wire[7:0] xpos_ClockwiseUtil_3_1_6,xpos_CounterClockwiseUtil_3_1_6,xpos_InjectUtil_3_1_6;
	wire[7:0] xneg_ClockwiseUtil_3_1_6,xneg_CounterClockwiseUtil_3_1_6,xneg_InjectUtil_3_1_6;
	wire[7:0] ypos_ClockwiseUtil_3_1_6,ypos_CounterClockwiseUtil_3_1_6,ypos_InjectUtil_3_1_6;
	wire[7:0] yneg_ClockwiseUtil_3_1_6,yneg_CounterClockwiseUtil_3_1_6,yneg_InjectUtil_3_1_6;
	wire[7:0] zpos_ClockwiseUtil_3_1_6,zpos_CounterClockwiseUtil_3_1_6,zpos_InjectUtil_3_1_6;
	wire[7:0] zneg_ClockwiseUtil_3_1_6,zneg_CounterClockwiseUtil_3_1_6,zneg_InjectUtil_3_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_1_7, eject_xpos_ser_3_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_1_7, eject_xneg_ser_3_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_1_7, eject_ypos_ser_3_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_1_7, eject_yneg_ser_3_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_1_7, eject_zpos_ser_3_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_1_7, eject_zneg_ser_3_1_7;
	wire[7:0] xpos_ClockwiseUtil_3_1_7,xpos_CounterClockwiseUtil_3_1_7,xpos_InjectUtil_3_1_7;
	wire[7:0] xneg_ClockwiseUtil_3_1_7,xneg_CounterClockwiseUtil_3_1_7,xneg_InjectUtil_3_1_7;
	wire[7:0] ypos_ClockwiseUtil_3_1_7,ypos_CounterClockwiseUtil_3_1_7,ypos_InjectUtil_3_1_7;
	wire[7:0] yneg_ClockwiseUtil_3_1_7,yneg_CounterClockwiseUtil_3_1_7,yneg_InjectUtil_3_1_7;
	wire[7:0] zpos_ClockwiseUtil_3_1_7,zpos_CounterClockwiseUtil_3_1_7,zpos_InjectUtil_3_1_7;
	wire[7:0] zneg_ClockwiseUtil_3_1_7,zneg_CounterClockwiseUtil_3_1_7,zneg_InjectUtil_3_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_0, eject_xpos_ser_3_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_0, eject_xneg_ser_3_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_0, eject_ypos_ser_3_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_0, eject_yneg_ser_3_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_0, eject_zpos_ser_3_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_0, eject_zneg_ser_3_2_0;
	wire[7:0] xpos_ClockwiseUtil_3_2_0,xpos_CounterClockwiseUtil_3_2_0,xpos_InjectUtil_3_2_0;
	wire[7:0] xneg_ClockwiseUtil_3_2_0,xneg_CounterClockwiseUtil_3_2_0,xneg_InjectUtil_3_2_0;
	wire[7:0] ypos_ClockwiseUtil_3_2_0,ypos_CounterClockwiseUtil_3_2_0,ypos_InjectUtil_3_2_0;
	wire[7:0] yneg_ClockwiseUtil_3_2_0,yneg_CounterClockwiseUtil_3_2_0,yneg_InjectUtil_3_2_0;
	wire[7:0] zpos_ClockwiseUtil_3_2_0,zpos_CounterClockwiseUtil_3_2_0,zpos_InjectUtil_3_2_0;
	wire[7:0] zneg_ClockwiseUtil_3_2_0,zneg_CounterClockwiseUtil_3_2_0,zneg_InjectUtil_3_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_1, eject_xpos_ser_3_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_1, eject_xneg_ser_3_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_1, eject_ypos_ser_3_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_1, eject_yneg_ser_3_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_1, eject_zpos_ser_3_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_1, eject_zneg_ser_3_2_1;
	wire[7:0] xpos_ClockwiseUtil_3_2_1,xpos_CounterClockwiseUtil_3_2_1,xpos_InjectUtil_3_2_1;
	wire[7:0] xneg_ClockwiseUtil_3_2_1,xneg_CounterClockwiseUtil_3_2_1,xneg_InjectUtil_3_2_1;
	wire[7:0] ypos_ClockwiseUtil_3_2_1,ypos_CounterClockwiseUtil_3_2_1,ypos_InjectUtil_3_2_1;
	wire[7:0] yneg_ClockwiseUtil_3_2_1,yneg_CounterClockwiseUtil_3_2_1,yneg_InjectUtil_3_2_1;
	wire[7:0] zpos_ClockwiseUtil_3_2_1,zpos_CounterClockwiseUtil_3_2_1,zpos_InjectUtil_3_2_1;
	wire[7:0] zneg_ClockwiseUtil_3_2_1,zneg_CounterClockwiseUtil_3_2_1,zneg_InjectUtil_3_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_2, eject_xpos_ser_3_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_2, eject_xneg_ser_3_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_2, eject_ypos_ser_3_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_2, eject_yneg_ser_3_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_2, eject_zpos_ser_3_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_2, eject_zneg_ser_3_2_2;
	wire[7:0] xpos_ClockwiseUtil_3_2_2,xpos_CounterClockwiseUtil_3_2_2,xpos_InjectUtil_3_2_2;
	wire[7:0] xneg_ClockwiseUtil_3_2_2,xneg_CounterClockwiseUtil_3_2_2,xneg_InjectUtil_3_2_2;
	wire[7:0] ypos_ClockwiseUtil_3_2_2,ypos_CounterClockwiseUtil_3_2_2,ypos_InjectUtil_3_2_2;
	wire[7:0] yneg_ClockwiseUtil_3_2_2,yneg_CounterClockwiseUtil_3_2_2,yneg_InjectUtil_3_2_2;
	wire[7:0] zpos_ClockwiseUtil_3_2_2,zpos_CounterClockwiseUtil_3_2_2,zpos_InjectUtil_3_2_2;
	wire[7:0] zneg_ClockwiseUtil_3_2_2,zneg_CounterClockwiseUtil_3_2_2,zneg_InjectUtil_3_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_3, eject_xpos_ser_3_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_3, eject_xneg_ser_3_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_3, eject_ypos_ser_3_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_3, eject_yneg_ser_3_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_3, eject_zpos_ser_3_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_3, eject_zneg_ser_3_2_3;
	wire[7:0] xpos_ClockwiseUtil_3_2_3,xpos_CounterClockwiseUtil_3_2_3,xpos_InjectUtil_3_2_3;
	wire[7:0] xneg_ClockwiseUtil_3_2_3,xneg_CounterClockwiseUtil_3_2_3,xneg_InjectUtil_3_2_3;
	wire[7:0] ypos_ClockwiseUtil_3_2_3,ypos_CounterClockwiseUtil_3_2_3,ypos_InjectUtil_3_2_3;
	wire[7:0] yneg_ClockwiseUtil_3_2_3,yneg_CounterClockwiseUtil_3_2_3,yneg_InjectUtil_3_2_3;
	wire[7:0] zpos_ClockwiseUtil_3_2_3,zpos_CounterClockwiseUtil_3_2_3,zpos_InjectUtil_3_2_3;
	wire[7:0] zneg_ClockwiseUtil_3_2_3,zneg_CounterClockwiseUtil_3_2_3,zneg_InjectUtil_3_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_4, eject_xpos_ser_3_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_4, eject_xneg_ser_3_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_4, eject_ypos_ser_3_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_4, eject_yneg_ser_3_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_4, eject_zpos_ser_3_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_4, eject_zneg_ser_3_2_4;
	wire[7:0] xpos_ClockwiseUtil_3_2_4,xpos_CounterClockwiseUtil_3_2_4,xpos_InjectUtil_3_2_4;
	wire[7:0] xneg_ClockwiseUtil_3_2_4,xneg_CounterClockwiseUtil_3_2_4,xneg_InjectUtil_3_2_4;
	wire[7:0] ypos_ClockwiseUtil_3_2_4,ypos_CounterClockwiseUtil_3_2_4,ypos_InjectUtil_3_2_4;
	wire[7:0] yneg_ClockwiseUtil_3_2_4,yneg_CounterClockwiseUtil_3_2_4,yneg_InjectUtil_3_2_4;
	wire[7:0] zpos_ClockwiseUtil_3_2_4,zpos_CounterClockwiseUtil_3_2_4,zpos_InjectUtil_3_2_4;
	wire[7:0] zneg_ClockwiseUtil_3_2_4,zneg_CounterClockwiseUtil_3_2_4,zneg_InjectUtil_3_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_5, eject_xpos_ser_3_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_5, eject_xneg_ser_3_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_5, eject_ypos_ser_3_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_5, eject_yneg_ser_3_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_5, eject_zpos_ser_3_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_5, eject_zneg_ser_3_2_5;
	wire[7:0] xpos_ClockwiseUtil_3_2_5,xpos_CounterClockwiseUtil_3_2_5,xpos_InjectUtil_3_2_5;
	wire[7:0] xneg_ClockwiseUtil_3_2_5,xneg_CounterClockwiseUtil_3_2_5,xneg_InjectUtil_3_2_5;
	wire[7:0] ypos_ClockwiseUtil_3_2_5,ypos_CounterClockwiseUtil_3_2_5,ypos_InjectUtil_3_2_5;
	wire[7:0] yneg_ClockwiseUtil_3_2_5,yneg_CounterClockwiseUtil_3_2_5,yneg_InjectUtil_3_2_5;
	wire[7:0] zpos_ClockwiseUtil_3_2_5,zpos_CounterClockwiseUtil_3_2_5,zpos_InjectUtil_3_2_5;
	wire[7:0] zneg_ClockwiseUtil_3_2_5,zneg_CounterClockwiseUtil_3_2_5,zneg_InjectUtil_3_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_6, eject_xpos_ser_3_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_6, eject_xneg_ser_3_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_6, eject_ypos_ser_3_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_6, eject_yneg_ser_3_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_6, eject_zpos_ser_3_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_6, eject_zneg_ser_3_2_6;
	wire[7:0] xpos_ClockwiseUtil_3_2_6,xpos_CounterClockwiseUtil_3_2_6,xpos_InjectUtil_3_2_6;
	wire[7:0] xneg_ClockwiseUtil_3_2_6,xneg_CounterClockwiseUtil_3_2_6,xneg_InjectUtil_3_2_6;
	wire[7:0] ypos_ClockwiseUtil_3_2_6,ypos_CounterClockwiseUtil_3_2_6,ypos_InjectUtil_3_2_6;
	wire[7:0] yneg_ClockwiseUtil_3_2_6,yneg_CounterClockwiseUtil_3_2_6,yneg_InjectUtil_3_2_6;
	wire[7:0] zpos_ClockwiseUtil_3_2_6,zpos_CounterClockwiseUtil_3_2_6,zpos_InjectUtil_3_2_6;
	wire[7:0] zneg_ClockwiseUtil_3_2_6,zneg_CounterClockwiseUtil_3_2_6,zneg_InjectUtil_3_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_2_7, eject_xpos_ser_3_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_2_7, eject_xneg_ser_3_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_2_7, eject_ypos_ser_3_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_2_7, eject_yneg_ser_3_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_2_7, eject_zpos_ser_3_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_2_7, eject_zneg_ser_3_2_7;
	wire[7:0] xpos_ClockwiseUtil_3_2_7,xpos_CounterClockwiseUtil_3_2_7,xpos_InjectUtil_3_2_7;
	wire[7:0] xneg_ClockwiseUtil_3_2_7,xneg_CounterClockwiseUtil_3_2_7,xneg_InjectUtil_3_2_7;
	wire[7:0] ypos_ClockwiseUtil_3_2_7,ypos_CounterClockwiseUtil_3_2_7,ypos_InjectUtil_3_2_7;
	wire[7:0] yneg_ClockwiseUtil_3_2_7,yneg_CounterClockwiseUtil_3_2_7,yneg_InjectUtil_3_2_7;
	wire[7:0] zpos_ClockwiseUtil_3_2_7,zpos_CounterClockwiseUtil_3_2_7,zpos_InjectUtil_3_2_7;
	wire[7:0] zneg_ClockwiseUtil_3_2_7,zneg_CounterClockwiseUtil_3_2_7,zneg_InjectUtil_3_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_0, eject_xpos_ser_3_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_0, eject_xneg_ser_3_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_0, eject_ypos_ser_3_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_0, eject_yneg_ser_3_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_0, eject_zpos_ser_3_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_0, eject_zneg_ser_3_3_0;
	wire[7:0] xpos_ClockwiseUtil_3_3_0,xpos_CounterClockwiseUtil_3_3_0,xpos_InjectUtil_3_3_0;
	wire[7:0] xneg_ClockwiseUtil_3_3_0,xneg_CounterClockwiseUtil_3_3_0,xneg_InjectUtil_3_3_0;
	wire[7:0] ypos_ClockwiseUtil_3_3_0,ypos_CounterClockwiseUtil_3_3_0,ypos_InjectUtil_3_3_0;
	wire[7:0] yneg_ClockwiseUtil_3_3_0,yneg_CounterClockwiseUtil_3_3_0,yneg_InjectUtil_3_3_0;
	wire[7:0] zpos_ClockwiseUtil_3_3_0,zpos_CounterClockwiseUtil_3_3_0,zpos_InjectUtil_3_3_0;
	wire[7:0] zneg_ClockwiseUtil_3_3_0,zneg_CounterClockwiseUtil_3_3_0,zneg_InjectUtil_3_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_1, eject_xpos_ser_3_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_1, eject_xneg_ser_3_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_1, eject_ypos_ser_3_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_1, eject_yneg_ser_3_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_1, eject_zpos_ser_3_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_1, eject_zneg_ser_3_3_1;
	wire[7:0] xpos_ClockwiseUtil_3_3_1,xpos_CounterClockwiseUtil_3_3_1,xpos_InjectUtil_3_3_1;
	wire[7:0] xneg_ClockwiseUtil_3_3_1,xneg_CounterClockwiseUtil_3_3_1,xneg_InjectUtil_3_3_1;
	wire[7:0] ypos_ClockwiseUtil_3_3_1,ypos_CounterClockwiseUtil_3_3_1,ypos_InjectUtil_3_3_1;
	wire[7:0] yneg_ClockwiseUtil_3_3_1,yneg_CounterClockwiseUtil_3_3_1,yneg_InjectUtil_3_3_1;
	wire[7:0] zpos_ClockwiseUtil_3_3_1,zpos_CounterClockwiseUtil_3_3_1,zpos_InjectUtil_3_3_1;
	wire[7:0] zneg_ClockwiseUtil_3_3_1,zneg_CounterClockwiseUtil_3_3_1,zneg_InjectUtil_3_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_2, eject_xpos_ser_3_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_2, eject_xneg_ser_3_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_2, eject_ypos_ser_3_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_2, eject_yneg_ser_3_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_2, eject_zpos_ser_3_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_2, eject_zneg_ser_3_3_2;
	wire[7:0] xpos_ClockwiseUtil_3_3_2,xpos_CounterClockwiseUtil_3_3_2,xpos_InjectUtil_3_3_2;
	wire[7:0] xneg_ClockwiseUtil_3_3_2,xneg_CounterClockwiseUtil_3_3_2,xneg_InjectUtil_3_3_2;
	wire[7:0] ypos_ClockwiseUtil_3_3_2,ypos_CounterClockwiseUtil_3_3_2,ypos_InjectUtil_3_3_2;
	wire[7:0] yneg_ClockwiseUtil_3_3_2,yneg_CounterClockwiseUtil_3_3_2,yneg_InjectUtil_3_3_2;
	wire[7:0] zpos_ClockwiseUtil_3_3_2,zpos_CounterClockwiseUtil_3_3_2,zpos_InjectUtil_3_3_2;
	wire[7:0] zneg_ClockwiseUtil_3_3_2,zneg_CounterClockwiseUtil_3_3_2,zneg_InjectUtil_3_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_3, eject_xpos_ser_3_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_3, eject_xneg_ser_3_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_3, eject_ypos_ser_3_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_3, eject_yneg_ser_3_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_3, eject_zpos_ser_3_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_3, eject_zneg_ser_3_3_3;
	wire[7:0] xpos_ClockwiseUtil_3_3_3,xpos_CounterClockwiseUtil_3_3_3,xpos_InjectUtil_3_3_3;
	wire[7:0] xneg_ClockwiseUtil_3_3_3,xneg_CounterClockwiseUtil_3_3_3,xneg_InjectUtil_3_3_3;
	wire[7:0] ypos_ClockwiseUtil_3_3_3,ypos_CounterClockwiseUtil_3_3_3,ypos_InjectUtil_3_3_3;
	wire[7:0] yneg_ClockwiseUtil_3_3_3,yneg_CounterClockwiseUtil_3_3_3,yneg_InjectUtil_3_3_3;
	wire[7:0] zpos_ClockwiseUtil_3_3_3,zpos_CounterClockwiseUtil_3_3_3,zpos_InjectUtil_3_3_3;
	wire[7:0] zneg_ClockwiseUtil_3_3_3,zneg_CounterClockwiseUtil_3_3_3,zneg_InjectUtil_3_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_4, eject_xpos_ser_3_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_4, eject_xneg_ser_3_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_4, eject_ypos_ser_3_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_4, eject_yneg_ser_3_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_4, eject_zpos_ser_3_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_4, eject_zneg_ser_3_3_4;
	wire[7:0] xpos_ClockwiseUtil_3_3_4,xpos_CounterClockwiseUtil_3_3_4,xpos_InjectUtil_3_3_4;
	wire[7:0] xneg_ClockwiseUtil_3_3_4,xneg_CounterClockwiseUtil_3_3_4,xneg_InjectUtil_3_3_4;
	wire[7:0] ypos_ClockwiseUtil_3_3_4,ypos_CounterClockwiseUtil_3_3_4,ypos_InjectUtil_3_3_4;
	wire[7:0] yneg_ClockwiseUtil_3_3_4,yneg_CounterClockwiseUtil_3_3_4,yneg_InjectUtil_3_3_4;
	wire[7:0] zpos_ClockwiseUtil_3_3_4,zpos_CounterClockwiseUtil_3_3_4,zpos_InjectUtil_3_3_4;
	wire[7:0] zneg_ClockwiseUtil_3_3_4,zneg_CounterClockwiseUtil_3_3_4,zneg_InjectUtil_3_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_5, eject_xpos_ser_3_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_5, eject_xneg_ser_3_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_5, eject_ypos_ser_3_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_5, eject_yneg_ser_3_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_5, eject_zpos_ser_3_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_5, eject_zneg_ser_3_3_5;
	wire[7:0] xpos_ClockwiseUtil_3_3_5,xpos_CounterClockwiseUtil_3_3_5,xpos_InjectUtil_3_3_5;
	wire[7:0] xneg_ClockwiseUtil_3_3_5,xneg_CounterClockwiseUtil_3_3_5,xneg_InjectUtil_3_3_5;
	wire[7:0] ypos_ClockwiseUtil_3_3_5,ypos_CounterClockwiseUtil_3_3_5,ypos_InjectUtil_3_3_5;
	wire[7:0] yneg_ClockwiseUtil_3_3_5,yneg_CounterClockwiseUtil_3_3_5,yneg_InjectUtil_3_3_5;
	wire[7:0] zpos_ClockwiseUtil_3_3_5,zpos_CounterClockwiseUtil_3_3_5,zpos_InjectUtil_3_3_5;
	wire[7:0] zneg_ClockwiseUtil_3_3_5,zneg_CounterClockwiseUtil_3_3_5,zneg_InjectUtil_3_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_6, eject_xpos_ser_3_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_6, eject_xneg_ser_3_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_6, eject_ypos_ser_3_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_6, eject_yneg_ser_3_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_6, eject_zpos_ser_3_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_6, eject_zneg_ser_3_3_6;
	wire[7:0] xpos_ClockwiseUtil_3_3_6,xpos_CounterClockwiseUtil_3_3_6,xpos_InjectUtil_3_3_6;
	wire[7:0] xneg_ClockwiseUtil_3_3_6,xneg_CounterClockwiseUtil_3_3_6,xneg_InjectUtil_3_3_6;
	wire[7:0] ypos_ClockwiseUtil_3_3_6,ypos_CounterClockwiseUtil_3_3_6,ypos_InjectUtil_3_3_6;
	wire[7:0] yneg_ClockwiseUtil_3_3_6,yneg_CounterClockwiseUtil_3_3_6,yneg_InjectUtil_3_3_6;
	wire[7:0] zpos_ClockwiseUtil_3_3_6,zpos_CounterClockwiseUtil_3_3_6,zpos_InjectUtil_3_3_6;
	wire[7:0] zneg_ClockwiseUtil_3_3_6,zneg_CounterClockwiseUtil_3_3_6,zneg_InjectUtil_3_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_3_7, eject_xpos_ser_3_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_3_7, eject_xneg_ser_3_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_3_7, eject_ypos_ser_3_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_3_7, eject_yneg_ser_3_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_3_7, eject_zpos_ser_3_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_3_7, eject_zneg_ser_3_3_7;
	wire[7:0] xpos_ClockwiseUtil_3_3_7,xpos_CounterClockwiseUtil_3_3_7,xpos_InjectUtil_3_3_7;
	wire[7:0] xneg_ClockwiseUtil_3_3_7,xneg_CounterClockwiseUtil_3_3_7,xneg_InjectUtil_3_3_7;
	wire[7:0] ypos_ClockwiseUtil_3_3_7,ypos_CounterClockwiseUtil_3_3_7,ypos_InjectUtil_3_3_7;
	wire[7:0] yneg_ClockwiseUtil_3_3_7,yneg_CounterClockwiseUtil_3_3_7,yneg_InjectUtil_3_3_7;
	wire[7:0] zpos_ClockwiseUtil_3_3_7,zpos_CounterClockwiseUtil_3_3_7,zpos_InjectUtil_3_3_7;
	wire[7:0] zneg_ClockwiseUtil_3_3_7,zneg_CounterClockwiseUtil_3_3_7,zneg_InjectUtil_3_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_0, eject_xpos_ser_3_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_0, eject_xneg_ser_3_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_0, eject_ypos_ser_3_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_0, eject_yneg_ser_3_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_0, eject_zpos_ser_3_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_0, eject_zneg_ser_3_4_0;
	wire[7:0] xpos_ClockwiseUtil_3_4_0,xpos_CounterClockwiseUtil_3_4_0,xpos_InjectUtil_3_4_0;
	wire[7:0] xneg_ClockwiseUtil_3_4_0,xneg_CounterClockwiseUtil_3_4_0,xneg_InjectUtil_3_4_0;
	wire[7:0] ypos_ClockwiseUtil_3_4_0,ypos_CounterClockwiseUtil_3_4_0,ypos_InjectUtil_3_4_0;
	wire[7:0] yneg_ClockwiseUtil_3_4_0,yneg_CounterClockwiseUtil_3_4_0,yneg_InjectUtil_3_4_0;
	wire[7:0] zpos_ClockwiseUtil_3_4_0,zpos_CounterClockwiseUtil_3_4_0,zpos_InjectUtil_3_4_0;
	wire[7:0] zneg_ClockwiseUtil_3_4_0,zneg_CounterClockwiseUtil_3_4_0,zneg_InjectUtil_3_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_1, eject_xpos_ser_3_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_1, eject_xneg_ser_3_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_1, eject_ypos_ser_3_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_1, eject_yneg_ser_3_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_1, eject_zpos_ser_3_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_1, eject_zneg_ser_3_4_1;
	wire[7:0] xpos_ClockwiseUtil_3_4_1,xpos_CounterClockwiseUtil_3_4_1,xpos_InjectUtil_3_4_1;
	wire[7:0] xneg_ClockwiseUtil_3_4_1,xneg_CounterClockwiseUtil_3_4_1,xneg_InjectUtil_3_4_1;
	wire[7:0] ypos_ClockwiseUtil_3_4_1,ypos_CounterClockwiseUtil_3_4_1,ypos_InjectUtil_3_4_1;
	wire[7:0] yneg_ClockwiseUtil_3_4_1,yneg_CounterClockwiseUtil_3_4_1,yneg_InjectUtil_3_4_1;
	wire[7:0] zpos_ClockwiseUtil_3_4_1,zpos_CounterClockwiseUtil_3_4_1,zpos_InjectUtil_3_4_1;
	wire[7:0] zneg_ClockwiseUtil_3_4_1,zneg_CounterClockwiseUtil_3_4_1,zneg_InjectUtil_3_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_2, eject_xpos_ser_3_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_2, eject_xneg_ser_3_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_2, eject_ypos_ser_3_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_2, eject_yneg_ser_3_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_2, eject_zpos_ser_3_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_2, eject_zneg_ser_3_4_2;
	wire[7:0] xpos_ClockwiseUtil_3_4_2,xpos_CounterClockwiseUtil_3_4_2,xpos_InjectUtil_3_4_2;
	wire[7:0] xneg_ClockwiseUtil_3_4_2,xneg_CounterClockwiseUtil_3_4_2,xneg_InjectUtil_3_4_2;
	wire[7:0] ypos_ClockwiseUtil_3_4_2,ypos_CounterClockwiseUtil_3_4_2,ypos_InjectUtil_3_4_2;
	wire[7:0] yneg_ClockwiseUtil_3_4_2,yneg_CounterClockwiseUtil_3_4_2,yneg_InjectUtil_3_4_2;
	wire[7:0] zpos_ClockwiseUtil_3_4_2,zpos_CounterClockwiseUtil_3_4_2,zpos_InjectUtil_3_4_2;
	wire[7:0] zneg_ClockwiseUtil_3_4_2,zneg_CounterClockwiseUtil_3_4_2,zneg_InjectUtil_3_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_3, eject_xpos_ser_3_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_3, eject_xneg_ser_3_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_3, eject_ypos_ser_3_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_3, eject_yneg_ser_3_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_3, eject_zpos_ser_3_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_3, eject_zneg_ser_3_4_3;
	wire[7:0] xpos_ClockwiseUtil_3_4_3,xpos_CounterClockwiseUtil_3_4_3,xpos_InjectUtil_3_4_3;
	wire[7:0] xneg_ClockwiseUtil_3_4_3,xneg_CounterClockwiseUtil_3_4_3,xneg_InjectUtil_3_4_3;
	wire[7:0] ypos_ClockwiseUtil_3_4_3,ypos_CounterClockwiseUtil_3_4_3,ypos_InjectUtil_3_4_3;
	wire[7:0] yneg_ClockwiseUtil_3_4_3,yneg_CounterClockwiseUtil_3_4_3,yneg_InjectUtil_3_4_3;
	wire[7:0] zpos_ClockwiseUtil_3_4_3,zpos_CounterClockwiseUtil_3_4_3,zpos_InjectUtil_3_4_3;
	wire[7:0] zneg_ClockwiseUtil_3_4_3,zneg_CounterClockwiseUtil_3_4_3,zneg_InjectUtil_3_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_4, eject_xpos_ser_3_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_4, eject_xneg_ser_3_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_4, eject_ypos_ser_3_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_4, eject_yneg_ser_3_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_4, eject_zpos_ser_3_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_4, eject_zneg_ser_3_4_4;
	wire[7:0] xpos_ClockwiseUtil_3_4_4,xpos_CounterClockwiseUtil_3_4_4,xpos_InjectUtil_3_4_4;
	wire[7:0] xneg_ClockwiseUtil_3_4_4,xneg_CounterClockwiseUtil_3_4_4,xneg_InjectUtil_3_4_4;
	wire[7:0] ypos_ClockwiseUtil_3_4_4,ypos_CounterClockwiseUtil_3_4_4,ypos_InjectUtil_3_4_4;
	wire[7:0] yneg_ClockwiseUtil_3_4_4,yneg_CounterClockwiseUtil_3_4_4,yneg_InjectUtil_3_4_4;
	wire[7:0] zpos_ClockwiseUtil_3_4_4,zpos_CounterClockwiseUtil_3_4_4,zpos_InjectUtil_3_4_4;
	wire[7:0] zneg_ClockwiseUtil_3_4_4,zneg_CounterClockwiseUtil_3_4_4,zneg_InjectUtil_3_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_5, eject_xpos_ser_3_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_5, eject_xneg_ser_3_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_5, eject_ypos_ser_3_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_5, eject_yneg_ser_3_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_5, eject_zpos_ser_3_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_5, eject_zneg_ser_3_4_5;
	wire[7:0] xpos_ClockwiseUtil_3_4_5,xpos_CounterClockwiseUtil_3_4_5,xpos_InjectUtil_3_4_5;
	wire[7:0] xneg_ClockwiseUtil_3_4_5,xneg_CounterClockwiseUtil_3_4_5,xneg_InjectUtil_3_4_5;
	wire[7:0] ypos_ClockwiseUtil_3_4_5,ypos_CounterClockwiseUtil_3_4_5,ypos_InjectUtil_3_4_5;
	wire[7:0] yneg_ClockwiseUtil_3_4_5,yneg_CounterClockwiseUtil_3_4_5,yneg_InjectUtil_3_4_5;
	wire[7:0] zpos_ClockwiseUtil_3_4_5,zpos_CounterClockwiseUtil_3_4_5,zpos_InjectUtil_3_4_5;
	wire[7:0] zneg_ClockwiseUtil_3_4_5,zneg_CounterClockwiseUtil_3_4_5,zneg_InjectUtil_3_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_6, eject_xpos_ser_3_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_6, eject_xneg_ser_3_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_6, eject_ypos_ser_3_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_6, eject_yneg_ser_3_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_6, eject_zpos_ser_3_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_6, eject_zneg_ser_3_4_6;
	wire[7:0] xpos_ClockwiseUtil_3_4_6,xpos_CounterClockwiseUtil_3_4_6,xpos_InjectUtil_3_4_6;
	wire[7:0] xneg_ClockwiseUtil_3_4_6,xneg_CounterClockwiseUtil_3_4_6,xneg_InjectUtil_3_4_6;
	wire[7:0] ypos_ClockwiseUtil_3_4_6,ypos_CounterClockwiseUtil_3_4_6,ypos_InjectUtil_3_4_6;
	wire[7:0] yneg_ClockwiseUtil_3_4_6,yneg_CounterClockwiseUtil_3_4_6,yneg_InjectUtil_3_4_6;
	wire[7:0] zpos_ClockwiseUtil_3_4_6,zpos_CounterClockwiseUtil_3_4_6,zpos_InjectUtil_3_4_6;
	wire[7:0] zneg_ClockwiseUtil_3_4_6,zneg_CounterClockwiseUtil_3_4_6,zneg_InjectUtil_3_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_4_7, eject_xpos_ser_3_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_4_7, eject_xneg_ser_3_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_4_7, eject_ypos_ser_3_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_4_7, eject_yneg_ser_3_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_4_7, eject_zpos_ser_3_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_4_7, eject_zneg_ser_3_4_7;
	wire[7:0] xpos_ClockwiseUtil_3_4_7,xpos_CounterClockwiseUtil_3_4_7,xpos_InjectUtil_3_4_7;
	wire[7:0] xneg_ClockwiseUtil_3_4_7,xneg_CounterClockwiseUtil_3_4_7,xneg_InjectUtil_3_4_7;
	wire[7:0] ypos_ClockwiseUtil_3_4_7,ypos_CounterClockwiseUtil_3_4_7,ypos_InjectUtil_3_4_7;
	wire[7:0] yneg_ClockwiseUtil_3_4_7,yneg_CounterClockwiseUtil_3_4_7,yneg_InjectUtil_3_4_7;
	wire[7:0] zpos_ClockwiseUtil_3_4_7,zpos_CounterClockwiseUtil_3_4_7,zpos_InjectUtil_3_4_7;
	wire[7:0] zneg_ClockwiseUtil_3_4_7,zneg_CounterClockwiseUtil_3_4_7,zneg_InjectUtil_3_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_0, eject_xpos_ser_3_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_0, eject_xneg_ser_3_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_0, eject_ypos_ser_3_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_0, eject_yneg_ser_3_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_0, eject_zpos_ser_3_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_0, eject_zneg_ser_3_5_0;
	wire[7:0] xpos_ClockwiseUtil_3_5_0,xpos_CounterClockwiseUtil_3_5_0,xpos_InjectUtil_3_5_0;
	wire[7:0] xneg_ClockwiseUtil_3_5_0,xneg_CounterClockwiseUtil_3_5_0,xneg_InjectUtil_3_5_0;
	wire[7:0] ypos_ClockwiseUtil_3_5_0,ypos_CounterClockwiseUtil_3_5_0,ypos_InjectUtil_3_5_0;
	wire[7:0] yneg_ClockwiseUtil_3_5_0,yneg_CounterClockwiseUtil_3_5_0,yneg_InjectUtil_3_5_0;
	wire[7:0] zpos_ClockwiseUtil_3_5_0,zpos_CounterClockwiseUtil_3_5_0,zpos_InjectUtil_3_5_0;
	wire[7:0] zneg_ClockwiseUtil_3_5_0,zneg_CounterClockwiseUtil_3_5_0,zneg_InjectUtil_3_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_1, eject_xpos_ser_3_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_1, eject_xneg_ser_3_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_1, eject_ypos_ser_3_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_1, eject_yneg_ser_3_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_1, eject_zpos_ser_3_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_1, eject_zneg_ser_3_5_1;
	wire[7:0] xpos_ClockwiseUtil_3_5_1,xpos_CounterClockwiseUtil_3_5_1,xpos_InjectUtil_3_5_1;
	wire[7:0] xneg_ClockwiseUtil_3_5_1,xneg_CounterClockwiseUtil_3_5_1,xneg_InjectUtil_3_5_1;
	wire[7:0] ypos_ClockwiseUtil_3_5_1,ypos_CounterClockwiseUtil_3_5_1,ypos_InjectUtil_3_5_1;
	wire[7:0] yneg_ClockwiseUtil_3_5_1,yneg_CounterClockwiseUtil_3_5_1,yneg_InjectUtil_3_5_1;
	wire[7:0] zpos_ClockwiseUtil_3_5_1,zpos_CounterClockwiseUtil_3_5_1,zpos_InjectUtil_3_5_1;
	wire[7:0] zneg_ClockwiseUtil_3_5_1,zneg_CounterClockwiseUtil_3_5_1,zneg_InjectUtil_3_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_2, eject_xpos_ser_3_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_2, eject_xneg_ser_3_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_2, eject_ypos_ser_3_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_2, eject_yneg_ser_3_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_2, eject_zpos_ser_3_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_2, eject_zneg_ser_3_5_2;
	wire[7:0] xpos_ClockwiseUtil_3_5_2,xpos_CounterClockwiseUtil_3_5_2,xpos_InjectUtil_3_5_2;
	wire[7:0] xneg_ClockwiseUtil_3_5_2,xneg_CounterClockwiseUtil_3_5_2,xneg_InjectUtil_3_5_2;
	wire[7:0] ypos_ClockwiseUtil_3_5_2,ypos_CounterClockwiseUtil_3_5_2,ypos_InjectUtil_3_5_2;
	wire[7:0] yneg_ClockwiseUtil_3_5_2,yneg_CounterClockwiseUtil_3_5_2,yneg_InjectUtil_3_5_2;
	wire[7:0] zpos_ClockwiseUtil_3_5_2,zpos_CounterClockwiseUtil_3_5_2,zpos_InjectUtil_3_5_2;
	wire[7:0] zneg_ClockwiseUtil_3_5_2,zneg_CounterClockwiseUtil_3_5_2,zneg_InjectUtil_3_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_3, eject_xpos_ser_3_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_3, eject_xneg_ser_3_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_3, eject_ypos_ser_3_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_3, eject_yneg_ser_3_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_3, eject_zpos_ser_3_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_3, eject_zneg_ser_3_5_3;
	wire[7:0] xpos_ClockwiseUtil_3_5_3,xpos_CounterClockwiseUtil_3_5_3,xpos_InjectUtil_3_5_3;
	wire[7:0] xneg_ClockwiseUtil_3_5_3,xneg_CounterClockwiseUtil_3_5_3,xneg_InjectUtil_3_5_3;
	wire[7:0] ypos_ClockwiseUtil_3_5_3,ypos_CounterClockwiseUtil_3_5_3,ypos_InjectUtil_3_5_3;
	wire[7:0] yneg_ClockwiseUtil_3_5_3,yneg_CounterClockwiseUtil_3_5_3,yneg_InjectUtil_3_5_3;
	wire[7:0] zpos_ClockwiseUtil_3_5_3,zpos_CounterClockwiseUtil_3_5_3,zpos_InjectUtil_3_5_3;
	wire[7:0] zneg_ClockwiseUtil_3_5_3,zneg_CounterClockwiseUtil_3_5_3,zneg_InjectUtil_3_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_4, eject_xpos_ser_3_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_4, eject_xneg_ser_3_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_4, eject_ypos_ser_3_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_4, eject_yneg_ser_3_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_4, eject_zpos_ser_3_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_4, eject_zneg_ser_3_5_4;
	wire[7:0] xpos_ClockwiseUtil_3_5_4,xpos_CounterClockwiseUtil_3_5_4,xpos_InjectUtil_3_5_4;
	wire[7:0] xneg_ClockwiseUtil_3_5_4,xneg_CounterClockwiseUtil_3_5_4,xneg_InjectUtil_3_5_4;
	wire[7:0] ypos_ClockwiseUtil_3_5_4,ypos_CounterClockwiseUtil_3_5_4,ypos_InjectUtil_3_5_4;
	wire[7:0] yneg_ClockwiseUtil_3_5_4,yneg_CounterClockwiseUtil_3_5_4,yneg_InjectUtil_3_5_4;
	wire[7:0] zpos_ClockwiseUtil_3_5_4,zpos_CounterClockwiseUtil_3_5_4,zpos_InjectUtil_3_5_4;
	wire[7:0] zneg_ClockwiseUtil_3_5_4,zneg_CounterClockwiseUtil_3_5_4,zneg_InjectUtil_3_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_5, eject_xpos_ser_3_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_5, eject_xneg_ser_3_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_5, eject_ypos_ser_3_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_5, eject_yneg_ser_3_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_5, eject_zpos_ser_3_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_5, eject_zneg_ser_3_5_5;
	wire[7:0] xpos_ClockwiseUtil_3_5_5,xpos_CounterClockwiseUtil_3_5_5,xpos_InjectUtil_3_5_5;
	wire[7:0] xneg_ClockwiseUtil_3_5_5,xneg_CounterClockwiseUtil_3_5_5,xneg_InjectUtil_3_5_5;
	wire[7:0] ypos_ClockwiseUtil_3_5_5,ypos_CounterClockwiseUtil_3_5_5,ypos_InjectUtil_3_5_5;
	wire[7:0] yneg_ClockwiseUtil_3_5_5,yneg_CounterClockwiseUtil_3_5_5,yneg_InjectUtil_3_5_5;
	wire[7:0] zpos_ClockwiseUtil_3_5_5,zpos_CounterClockwiseUtil_3_5_5,zpos_InjectUtil_3_5_5;
	wire[7:0] zneg_ClockwiseUtil_3_5_5,zneg_CounterClockwiseUtil_3_5_5,zneg_InjectUtil_3_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_6, eject_xpos_ser_3_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_6, eject_xneg_ser_3_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_6, eject_ypos_ser_3_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_6, eject_yneg_ser_3_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_6, eject_zpos_ser_3_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_6, eject_zneg_ser_3_5_6;
	wire[7:0] xpos_ClockwiseUtil_3_5_6,xpos_CounterClockwiseUtil_3_5_6,xpos_InjectUtil_3_5_6;
	wire[7:0] xneg_ClockwiseUtil_3_5_6,xneg_CounterClockwiseUtil_3_5_6,xneg_InjectUtil_3_5_6;
	wire[7:0] ypos_ClockwiseUtil_3_5_6,ypos_CounterClockwiseUtil_3_5_6,ypos_InjectUtil_3_5_6;
	wire[7:0] yneg_ClockwiseUtil_3_5_6,yneg_CounterClockwiseUtil_3_5_6,yneg_InjectUtil_3_5_6;
	wire[7:0] zpos_ClockwiseUtil_3_5_6,zpos_CounterClockwiseUtil_3_5_6,zpos_InjectUtil_3_5_6;
	wire[7:0] zneg_ClockwiseUtil_3_5_6,zneg_CounterClockwiseUtil_3_5_6,zneg_InjectUtil_3_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_5_7, eject_xpos_ser_3_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_5_7, eject_xneg_ser_3_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_5_7, eject_ypos_ser_3_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_5_7, eject_yneg_ser_3_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_5_7, eject_zpos_ser_3_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_5_7, eject_zneg_ser_3_5_7;
	wire[7:0] xpos_ClockwiseUtil_3_5_7,xpos_CounterClockwiseUtil_3_5_7,xpos_InjectUtil_3_5_7;
	wire[7:0] xneg_ClockwiseUtil_3_5_7,xneg_CounterClockwiseUtil_3_5_7,xneg_InjectUtil_3_5_7;
	wire[7:0] ypos_ClockwiseUtil_3_5_7,ypos_CounterClockwiseUtil_3_5_7,ypos_InjectUtil_3_5_7;
	wire[7:0] yneg_ClockwiseUtil_3_5_7,yneg_CounterClockwiseUtil_3_5_7,yneg_InjectUtil_3_5_7;
	wire[7:0] zpos_ClockwiseUtil_3_5_7,zpos_CounterClockwiseUtil_3_5_7,zpos_InjectUtil_3_5_7;
	wire[7:0] zneg_ClockwiseUtil_3_5_7,zneg_CounterClockwiseUtil_3_5_7,zneg_InjectUtil_3_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_0, eject_xpos_ser_3_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_0, eject_xneg_ser_3_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_0, eject_ypos_ser_3_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_0, eject_yneg_ser_3_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_0, eject_zpos_ser_3_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_0, eject_zneg_ser_3_6_0;
	wire[7:0] xpos_ClockwiseUtil_3_6_0,xpos_CounterClockwiseUtil_3_6_0,xpos_InjectUtil_3_6_0;
	wire[7:0] xneg_ClockwiseUtil_3_6_0,xneg_CounterClockwiseUtil_3_6_0,xneg_InjectUtil_3_6_0;
	wire[7:0] ypos_ClockwiseUtil_3_6_0,ypos_CounterClockwiseUtil_3_6_0,ypos_InjectUtil_3_6_0;
	wire[7:0] yneg_ClockwiseUtil_3_6_0,yneg_CounterClockwiseUtil_3_6_0,yneg_InjectUtil_3_6_0;
	wire[7:0] zpos_ClockwiseUtil_3_6_0,zpos_CounterClockwiseUtil_3_6_0,zpos_InjectUtil_3_6_0;
	wire[7:0] zneg_ClockwiseUtil_3_6_0,zneg_CounterClockwiseUtil_3_6_0,zneg_InjectUtil_3_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_1, eject_xpos_ser_3_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_1, eject_xneg_ser_3_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_1, eject_ypos_ser_3_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_1, eject_yneg_ser_3_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_1, eject_zpos_ser_3_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_1, eject_zneg_ser_3_6_1;
	wire[7:0] xpos_ClockwiseUtil_3_6_1,xpos_CounterClockwiseUtil_3_6_1,xpos_InjectUtil_3_6_1;
	wire[7:0] xneg_ClockwiseUtil_3_6_1,xneg_CounterClockwiseUtil_3_6_1,xneg_InjectUtil_3_6_1;
	wire[7:0] ypos_ClockwiseUtil_3_6_1,ypos_CounterClockwiseUtil_3_6_1,ypos_InjectUtil_3_6_1;
	wire[7:0] yneg_ClockwiseUtil_3_6_1,yneg_CounterClockwiseUtil_3_6_1,yneg_InjectUtil_3_6_1;
	wire[7:0] zpos_ClockwiseUtil_3_6_1,zpos_CounterClockwiseUtil_3_6_1,zpos_InjectUtil_3_6_1;
	wire[7:0] zneg_ClockwiseUtil_3_6_1,zneg_CounterClockwiseUtil_3_6_1,zneg_InjectUtil_3_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_2, eject_xpos_ser_3_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_2, eject_xneg_ser_3_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_2, eject_ypos_ser_3_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_2, eject_yneg_ser_3_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_2, eject_zpos_ser_3_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_2, eject_zneg_ser_3_6_2;
	wire[7:0] xpos_ClockwiseUtil_3_6_2,xpos_CounterClockwiseUtil_3_6_2,xpos_InjectUtil_3_6_2;
	wire[7:0] xneg_ClockwiseUtil_3_6_2,xneg_CounterClockwiseUtil_3_6_2,xneg_InjectUtil_3_6_2;
	wire[7:0] ypos_ClockwiseUtil_3_6_2,ypos_CounterClockwiseUtil_3_6_2,ypos_InjectUtil_3_6_2;
	wire[7:0] yneg_ClockwiseUtil_3_6_2,yneg_CounterClockwiseUtil_3_6_2,yneg_InjectUtil_3_6_2;
	wire[7:0] zpos_ClockwiseUtil_3_6_2,zpos_CounterClockwiseUtil_3_6_2,zpos_InjectUtil_3_6_2;
	wire[7:0] zneg_ClockwiseUtil_3_6_2,zneg_CounterClockwiseUtil_3_6_2,zneg_InjectUtil_3_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_3, eject_xpos_ser_3_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_3, eject_xneg_ser_3_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_3, eject_ypos_ser_3_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_3, eject_yneg_ser_3_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_3, eject_zpos_ser_3_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_3, eject_zneg_ser_3_6_3;
	wire[7:0] xpos_ClockwiseUtil_3_6_3,xpos_CounterClockwiseUtil_3_6_3,xpos_InjectUtil_3_6_3;
	wire[7:0] xneg_ClockwiseUtil_3_6_3,xneg_CounterClockwiseUtil_3_6_3,xneg_InjectUtil_3_6_3;
	wire[7:0] ypos_ClockwiseUtil_3_6_3,ypos_CounterClockwiseUtil_3_6_3,ypos_InjectUtil_3_6_3;
	wire[7:0] yneg_ClockwiseUtil_3_6_3,yneg_CounterClockwiseUtil_3_6_3,yneg_InjectUtil_3_6_3;
	wire[7:0] zpos_ClockwiseUtil_3_6_3,zpos_CounterClockwiseUtil_3_6_3,zpos_InjectUtil_3_6_3;
	wire[7:0] zneg_ClockwiseUtil_3_6_3,zneg_CounterClockwiseUtil_3_6_3,zneg_InjectUtil_3_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_4, eject_xpos_ser_3_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_4, eject_xneg_ser_3_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_4, eject_ypos_ser_3_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_4, eject_yneg_ser_3_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_4, eject_zpos_ser_3_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_4, eject_zneg_ser_3_6_4;
	wire[7:0] xpos_ClockwiseUtil_3_6_4,xpos_CounterClockwiseUtil_3_6_4,xpos_InjectUtil_3_6_4;
	wire[7:0] xneg_ClockwiseUtil_3_6_4,xneg_CounterClockwiseUtil_3_6_4,xneg_InjectUtil_3_6_4;
	wire[7:0] ypos_ClockwiseUtil_3_6_4,ypos_CounterClockwiseUtil_3_6_4,ypos_InjectUtil_3_6_4;
	wire[7:0] yneg_ClockwiseUtil_3_6_4,yneg_CounterClockwiseUtil_3_6_4,yneg_InjectUtil_3_6_4;
	wire[7:0] zpos_ClockwiseUtil_3_6_4,zpos_CounterClockwiseUtil_3_6_4,zpos_InjectUtil_3_6_4;
	wire[7:0] zneg_ClockwiseUtil_3_6_4,zneg_CounterClockwiseUtil_3_6_4,zneg_InjectUtil_3_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_5, eject_xpos_ser_3_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_5, eject_xneg_ser_3_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_5, eject_ypos_ser_3_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_5, eject_yneg_ser_3_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_5, eject_zpos_ser_3_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_5, eject_zneg_ser_3_6_5;
	wire[7:0] xpos_ClockwiseUtil_3_6_5,xpos_CounterClockwiseUtil_3_6_5,xpos_InjectUtil_3_6_5;
	wire[7:0] xneg_ClockwiseUtil_3_6_5,xneg_CounterClockwiseUtil_3_6_5,xneg_InjectUtil_3_6_5;
	wire[7:0] ypos_ClockwiseUtil_3_6_5,ypos_CounterClockwiseUtil_3_6_5,ypos_InjectUtil_3_6_5;
	wire[7:0] yneg_ClockwiseUtil_3_6_5,yneg_CounterClockwiseUtil_3_6_5,yneg_InjectUtil_3_6_5;
	wire[7:0] zpos_ClockwiseUtil_3_6_5,zpos_CounterClockwiseUtil_3_6_5,zpos_InjectUtil_3_6_5;
	wire[7:0] zneg_ClockwiseUtil_3_6_5,zneg_CounterClockwiseUtil_3_6_5,zneg_InjectUtil_3_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_6, eject_xpos_ser_3_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_6, eject_xneg_ser_3_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_6, eject_ypos_ser_3_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_6, eject_yneg_ser_3_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_6, eject_zpos_ser_3_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_6, eject_zneg_ser_3_6_6;
	wire[7:0] xpos_ClockwiseUtil_3_6_6,xpos_CounterClockwiseUtil_3_6_6,xpos_InjectUtil_3_6_6;
	wire[7:0] xneg_ClockwiseUtil_3_6_6,xneg_CounterClockwiseUtil_3_6_6,xneg_InjectUtil_3_6_6;
	wire[7:0] ypos_ClockwiseUtil_3_6_6,ypos_CounterClockwiseUtil_3_6_6,ypos_InjectUtil_3_6_6;
	wire[7:0] yneg_ClockwiseUtil_3_6_6,yneg_CounterClockwiseUtil_3_6_6,yneg_InjectUtil_3_6_6;
	wire[7:0] zpos_ClockwiseUtil_3_6_6,zpos_CounterClockwiseUtil_3_6_6,zpos_InjectUtil_3_6_6;
	wire[7:0] zneg_ClockwiseUtil_3_6_6,zneg_CounterClockwiseUtil_3_6_6,zneg_InjectUtil_3_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_6_7, eject_xpos_ser_3_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_6_7, eject_xneg_ser_3_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_6_7, eject_ypos_ser_3_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_6_7, eject_yneg_ser_3_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_6_7, eject_zpos_ser_3_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_6_7, eject_zneg_ser_3_6_7;
	wire[7:0] xpos_ClockwiseUtil_3_6_7,xpos_CounterClockwiseUtil_3_6_7,xpos_InjectUtil_3_6_7;
	wire[7:0] xneg_ClockwiseUtil_3_6_7,xneg_CounterClockwiseUtil_3_6_7,xneg_InjectUtil_3_6_7;
	wire[7:0] ypos_ClockwiseUtil_3_6_7,ypos_CounterClockwiseUtil_3_6_7,ypos_InjectUtil_3_6_7;
	wire[7:0] yneg_ClockwiseUtil_3_6_7,yneg_CounterClockwiseUtil_3_6_7,yneg_InjectUtil_3_6_7;
	wire[7:0] zpos_ClockwiseUtil_3_6_7,zpos_CounterClockwiseUtil_3_6_7,zpos_InjectUtil_3_6_7;
	wire[7:0] zneg_ClockwiseUtil_3_6_7,zneg_CounterClockwiseUtil_3_6_7,zneg_InjectUtil_3_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_0, eject_xpos_ser_3_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_0, eject_xneg_ser_3_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_0, eject_ypos_ser_3_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_0, eject_yneg_ser_3_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_0, eject_zpos_ser_3_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_0, eject_zneg_ser_3_7_0;
	wire[7:0] xpos_ClockwiseUtil_3_7_0,xpos_CounterClockwiseUtil_3_7_0,xpos_InjectUtil_3_7_0;
	wire[7:0] xneg_ClockwiseUtil_3_7_0,xneg_CounterClockwiseUtil_3_7_0,xneg_InjectUtil_3_7_0;
	wire[7:0] ypos_ClockwiseUtil_3_7_0,ypos_CounterClockwiseUtil_3_7_0,ypos_InjectUtil_3_7_0;
	wire[7:0] yneg_ClockwiseUtil_3_7_0,yneg_CounterClockwiseUtil_3_7_0,yneg_InjectUtil_3_7_0;
	wire[7:0] zpos_ClockwiseUtil_3_7_0,zpos_CounterClockwiseUtil_3_7_0,zpos_InjectUtil_3_7_0;
	wire[7:0] zneg_ClockwiseUtil_3_7_0,zneg_CounterClockwiseUtil_3_7_0,zneg_InjectUtil_3_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_1, eject_xpos_ser_3_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_1, eject_xneg_ser_3_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_1, eject_ypos_ser_3_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_1, eject_yneg_ser_3_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_1, eject_zpos_ser_3_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_1, eject_zneg_ser_3_7_1;
	wire[7:0] xpos_ClockwiseUtil_3_7_1,xpos_CounterClockwiseUtil_3_7_1,xpos_InjectUtil_3_7_1;
	wire[7:0] xneg_ClockwiseUtil_3_7_1,xneg_CounterClockwiseUtil_3_7_1,xneg_InjectUtil_3_7_1;
	wire[7:0] ypos_ClockwiseUtil_3_7_1,ypos_CounterClockwiseUtil_3_7_1,ypos_InjectUtil_3_7_1;
	wire[7:0] yneg_ClockwiseUtil_3_7_1,yneg_CounterClockwiseUtil_3_7_1,yneg_InjectUtil_3_7_1;
	wire[7:0] zpos_ClockwiseUtil_3_7_1,zpos_CounterClockwiseUtil_3_7_1,zpos_InjectUtil_3_7_1;
	wire[7:0] zneg_ClockwiseUtil_3_7_1,zneg_CounterClockwiseUtil_3_7_1,zneg_InjectUtil_3_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_2, eject_xpos_ser_3_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_2, eject_xneg_ser_3_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_2, eject_ypos_ser_3_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_2, eject_yneg_ser_3_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_2, eject_zpos_ser_3_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_2, eject_zneg_ser_3_7_2;
	wire[7:0] xpos_ClockwiseUtil_3_7_2,xpos_CounterClockwiseUtil_3_7_2,xpos_InjectUtil_3_7_2;
	wire[7:0] xneg_ClockwiseUtil_3_7_2,xneg_CounterClockwiseUtil_3_7_2,xneg_InjectUtil_3_7_2;
	wire[7:0] ypos_ClockwiseUtil_3_7_2,ypos_CounterClockwiseUtil_3_7_2,ypos_InjectUtil_3_7_2;
	wire[7:0] yneg_ClockwiseUtil_3_7_2,yneg_CounterClockwiseUtil_3_7_2,yneg_InjectUtil_3_7_2;
	wire[7:0] zpos_ClockwiseUtil_3_7_2,zpos_CounterClockwiseUtil_3_7_2,zpos_InjectUtil_3_7_2;
	wire[7:0] zneg_ClockwiseUtil_3_7_2,zneg_CounterClockwiseUtil_3_7_2,zneg_InjectUtil_3_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_3, eject_xpos_ser_3_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_3, eject_xneg_ser_3_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_3, eject_ypos_ser_3_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_3, eject_yneg_ser_3_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_3, eject_zpos_ser_3_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_3, eject_zneg_ser_3_7_3;
	wire[7:0] xpos_ClockwiseUtil_3_7_3,xpos_CounterClockwiseUtil_3_7_3,xpos_InjectUtil_3_7_3;
	wire[7:0] xneg_ClockwiseUtil_3_7_3,xneg_CounterClockwiseUtil_3_7_3,xneg_InjectUtil_3_7_3;
	wire[7:0] ypos_ClockwiseUtil_3_7_3,ypos_CounterClockwiseUtil_3_7_3,ypos_InjectUtil_3_7_3;
	wire[7:0] yneg_ClockwiseUtil_3_7_3,yneg_CounterClockwiseUtil_3_7_3,yneg_InjectUtil_3_7_3;
	wire[7:0] zpos_ClockwiseUtil_3_7_3,zpos_CounterClockwiseUtil_3_7_3,zpos_InjectUtil_3_7_3;
	wire[7:0] zneg_ClockwiseUtil_3_7_3,zneg_CounterClockwiseUtil_3_7_3,zneg_InjectUtil_3_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_4, eject_xpos_ser_3_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_4, eject_xneg_ser_3_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_4, eject_ypos_ser_3_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_4, eject_yneg_ser_3_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_4, eject_zpos_ser_3_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_4, eject_zneg_ser_3_7_4;
	wire[7:0] xpos_ClockwiseUtil_3_7_4,xpos_CounterClockwiseUtil_3_7_4,xpos_InjectUtil_3_7_4;
	wire[7:0] xneg_ClockwiseUtil_3_7_4,xneg_CounterClockwiseUtil_3_7_4,xneg_InjectUtil_3_7_4;
	wire[7:0] ypos_ClockwiseUtil_3_7_4,ypos_CounterClockwiseUtil_3_7_4,ypos_InjectUtil_3_7_4;
	wire[7:0] yneg_ClockwiseUtil_3_7_4,yneg_CounterClockwiseUtil_3_7_4,yneg_InjectUtil_3_7_4;
	wire[7:0] zpos_ClockwiseUtil_3_7_4,zpos_CounterClockwiseUtil_3_7_4,zpos_InjectUtil_3_7_4;
	wire[7:0] zneg_ClockwiseUtil_3_7_4,zneg_CounterClockwiseUtil_3_7_4,zneg_InjectUtil_3_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_5, eject_xpos_ser_3_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_5, eject_xneg_ser_3_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_5, eject_ypos_ser_3_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_5, eject_yneg_ser_3_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_5, eject_zpos_ser_3_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_5, eject_zneg_ser_3_7_5;
	wire[7:0] xpos_ClockwiseUtil_3_7_5,xpos_CounterClockwiseUtil_3_7_5,xpos_InjectUtil_3_7_5;
	wire[7:0] xneg_ClockwiseUtil_3_7_5,xneg_CounterClockwiseUtil_3_7_5,xneg_InjectUtil_3_7_5;
	wire[7:0] ypos_ClockwiseUtil_3_7_5,ypos_CounterClockwiseUtil_3_7_5,ypos_InjectUtil_3_7_5;
	wire[7:0] yneg_ClockwiseUtil_3_7_5,yneg_CounterClockwiseUtil_3_7_5,yneg_InjectUtil_3_7_5;
	wire[7:0] zpos_ClockwiseUtil_3_7_5,zpos_CounterClockwiseUtil_3_7_5,zpos_InjectUtil_3_7_5;
	wire[7:0] zneg_ClockwiseUtil_3_7_5,zneg_CounterClockwiseUtil_3_7_5,zneg_InjectUtil_3_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_6, eject_xpos_ser_3_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_6, eject_xneg_ser_3_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_6, eject_ypos_ser_3_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_6, eject_yneg_ser_3_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_6, eject_zpos_ser_3_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_6, eject_zneg_ser_3_7_6;
	wire[7:0] xpos_ClockwiseUtil_3_7_6,xpos_CounterClockwiseUtil_3_7_6,xpos_InjectUtil_3_7_6;
	wire[7:0] xneg_ClockwiseUtil_3_7_6,xneg_CounterClockwiseUtil_3_7_6,xneg_InjectUtil_3_7_6;
	wire[7:0] ypos_ClockwiseUtil_3_7_6,ypos_CounterClockwiseUtil_3_7_6,ypos_InjectUtil_3_7_6;
	wire[7:0] yneg_ClockwiseUtil_3_7_6,yneg_CounterClockwiseUtil_3_7_6,yneg_InjectUtil_3_7_6;
	wire[7:0] zpos_ClockwiseUtil_3_7_6,zpos_CounterClockwiseUtil_3_7_6,zpos_InjectUtil_3_7_6;
	wire[7:0] zneg_ClockwiseUtil_3_7_6,zneg_CounterClockwiseUtil_3_7_6,zneg_InjectUtil_3_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_3_7_7, eject_xpos_ser_3_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_3_7_7, eject_xneg_ser_3_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_3_7_7, eject_ypos_ser_3_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_3_7_7, eject_yneg_ser_3_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_3_7_7, eject_zpos_ser_3_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_3_7_7, eject_zneg_ser_3_7_7;
	wire[7:0] xpos_ClockwiseUtil_3_7_7,xpos_CounterClockwiseUtil_3_7_7,xpos_InjectUtil_3_7_7;
	wire[7:0] xneg_ClockwiseUtil_3_7_7,xneg_CounterClockwiseUtil_3_7_7,xneg_InjectUtil_3_7_7;
	wire[7:0] ypos_ClockwiseUtil_3_7_7,ypos_CounterClockwiseUtil_3_7_7,ypos_InjectUtil_3_7_7;
	wire[7:0] yneg_ClockwiseUtil_3_7_7,yneg_CounterClockwiseUtil_3_7_7,yneg_InjectUtil_3_7_7;
	wire[7:0] zpos_ClockwiseUtil_3_7_7,zpos_CounterClockwiseUtil_3_7_7,zpos_InjectUtil_3_7_7;
	wire[7:0] zneg_ClockwiseUtil_3_7_7,zneg_CounterClockwiseUtil_3_7_7,zneg_InjectUtil_3_7_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_0, eject_xpos_ser_4_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_0, eject_xneg_ser_4_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_0, eject_ypos_ser_4_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_0, eject_yneg_ser_4_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_0, eject_zpos_ser_4_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_0, eject_zneg_ser_4_0_0;
	wire[7:0] xpos_ClockwiseUtil_4_0_0,xpos_CounterClockwiseUtil_4_0_0,xpos_InjectUtil_4_0_0;
	wire[7:0] xneg_ClockwiseUtil_4_0_0,xneg_CounterClockwiseUtil_4_0_0,xneg_InjectUtil_4_0_0;
	wire[7:0] ypos_ClockwiseUtil_4_0_0,ypos_CounterClockwiseUtil_4_0_0,ypos_InjectUtil_4_0_0;
	wire[7:0] yneg_ClockwiseUtil_4_0_0,yneg_CounterClockwiseUtil_4_0_0,yneg_InjectUtil_4_0_0;
	wire[7:0] zpos_ClockwiseUtil_4_0_0,zpos_CounterClockwiseUtil_4_0_0,zpos_InjectUtil_4_0_0;
	wire[7:0] zneg_ClockwiseUtil_4_0_0,zneg_CounterClockwiseUtil_4_0_0,zneg_InjectUtil_4_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_1, eject_xpos_ser_4_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_1, eject_xneg_ser_4_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_1, eject_ypos_ser_4_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_1, eject_yneg_ser_4_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_1, eject_zpos_ser_4_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_1, eject_zneg_ser_4_0_1;
	wire[7:0] xpos_ClockwiseUtil_4_0_1,xpos_CounterClockwiseUtil_4_0_1,xpos_InjectUtil_4_0_1;
	wire[7:0] xneg_ClockwiseUtil_4_0_1,xneg_CounterClockwiseUtil_4_0_1,xneg_InjectUtil_4_0_1;
	wire[7:0] ypos_ClockwiseUtil_4_0_1,ypos_CounterClockwiseUtil_4_0_1,ypos_InjectUtil_4_0_1;
	wire[7:0] yneg_ClockwiseUtil_4_0_1,yneg_CounterClockwiseUtil_4_0_1,yneg_InjectUtil_4_0_1;
	wire[7:0] zpos_ClockwiseUtil_4_0_1,zpos_CounterClockwiseUtil_4_0_1,zpos_InjectUtil_4_0_1;
	wire[7:0] zneg_ClockwiseUtil_4_0_1,zneg_CounterClockwiseUtil_4_0_1,zneg_InjectUtil_4_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_2, eject_xpos_ser_4_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_2, eject_xneg_ser_4_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_2, eject_ypos_ser_4_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_2, eject_yneg_ser_4_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_2, eject_zpos_ser_4_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_2, eject_zneg_ser_4_0_2;
	wire[7:0] xpos_ClockwiseUtil_4_0_2,xpos_CounterClockwiseUtil_4_0_2,xpos_InjectUtil_4_0_2;
	wire[7:0] xneg_ClockwiseUtil_4_0_2,xneg_CounterClockwiseUtil_4_0_2,xneg_InjectUtil_4_0_2;
	wire[7:0] ypos_ClockwiseUtil_4_0_2,ypos_CounterClockwiseUtil_4_0_2,ypos_InjectUtil_4_0_2;
	wire[7:0] yneg_ClockwiseUtil_4_0_2,yneg_CounterClockwiseUtil_4_0_2,yneg_InjectUtil_4_0_2;
	wire[7:0] zpos_ClockwiseUtil_4_0_2,zpos_CounterClockwiseUtil_4_0_2,zpos_InjectUtil_4_0_2;
	wire[7:0] zneg_ClockwiseUtil_4_0_2,zneg_CounterClockwiseUtil_4_0_2,zneg_InjectUtil_4_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_3, eject_xpos_ser_4_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_3, eject_xneg_ser_4_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_3, eject_ypos_ser_4_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_3, eject_yneg_ser_4_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_3, eject_zpos_ser_4_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_3, eject_zneg_ser_4_0_3;
	wire[7:0] xpos_ClockwiseUtil_4_0_3,xpos_CounterClockwiseUtil_4_0_3,xpos_InjectUtil_4_0_3;
	wire[7:0] xneg_ClockwiseUtil_4_0_3,xneg_CounterClockwiseUtil_4_0_3,xneg_InjectUtil_4_0_3;
	wire[7:0] ypos_ClockwiseUtil_4_0_3,ypos_CounterClockwiseUtil_4_0_3,ypos_InjectUtil_4_0_3;
	wire[7:0] yneg_ClockwiseUtil_4_0_3,yneg_CounterClockwiseUtil_4_0_3,yneg_InjectUtil_4_0_3;
	wire[7:0] zpos_ClockwiseUtil_4_0_3,zpos_CounterClockwiseUtil_4_0_3,zpos_InjectUtil_4_0_3;
	wire[7:0] zneg_ClockwiseUtil_4_0_3,zneg_CounterClockwiseUtil_4_0_3,zneg_InjectUtil_4_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_4, eject_xpos_ser_4_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_4, eject_xneg_ser_4_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_4, eject_ypos_ser_4_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_4, eject_yneg_ser_4_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_4, eject_zpos_ser_4_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_4, eject_zneg_ser_4_0_4;
	wire[7:0] xpos_ClockwiseUtil_4_0_4,xpos_CounterClockwiseUtil_4_0_4,xpos_InjectUtil_4_0_4;
	wire[7:0] xneg_ClockwiseUtil_4_0_4,xneg_CounterClockwiseUtil_4_0_4,xneg_InjectUtil_4_0_4;
	wire[7:0] ypos_ClockwiseUtil_4_0_4,ypos_CounterClockwiseUtil_4_0_4,ypos_InjectUtil_4_0_4;
	wire[7:0] yneg_ClockwiseUtil_4_0_4,yneg_CounterClockwiseUtil_4_0_4,yneg_InjectUtil_4_0_4;
	wire[7:0] zpos_ClockwiseUtil_4_0_4,zpos_CounterClockwiseUtil_4_0_4,zpos_InjectUtil_4_0_4;
	wire[7:0] zneg_ClockwiseUtil_4_0_4,zneg_CounterClockwiseUtil_4_0_4,zneg_InjectUtil_4_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_5, eject_xpos_ser_4_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_5, eject_xneg_ser_4_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_5, eject_ypos_ser_4_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_5, eject_yneg_ser_4_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_5, eject_zpos_ser_4_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_5, eject_zneg_ser_4_0_5;
	wire[7:0] xpos_ClockwiseUtil_4_0_5,xpos_CounterClockwiseUtil_4_0_5,xpos_InjectUtil_4_0_5;
	wire[7:0] xneg_ClockwiseUtil_4_0_5,xneg_CounterClockwiseUtil_4_0_5,xneg_InjectUtil_4_0_5;
	wire[7:0] ypos_ClockwiseUtil_4_0_5,ypos_CounterClockwiseUtil_4_0_5,ypos_InjectUtil_4_0_5;
	wire[7:0] yneg_ClockwiseUtil_4_0_5,yneg_CounterClockwiseUtil_4_0_5,yneg_InjectUtil_4_0_5;
	wire[7:0] zpos_ClockwiseUtil_4_0_5,zpos_CounterClockwiseUtil_4_0_5,zpos_InjectUtil_4_0_5;
	wire[7:0] zneg_ClockwiseUtil_4_0_5,zneg_CounterClockwiseUtil_4_0_5,zneg_InjectUtil_4_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_6, eject_xpos_ser_4_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_6, eject_xneg_ser_4_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_6, eject_ypos_ser_4_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_6, eject_yneg_ser_4_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_6, eject_zpos_ser_4_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_6, eject_zneg_ser_4_0_6;
	wire[7:0] xpos_ClockwiseUtil_4_0_6,xpos_CounterClockwiseUtil_4_0_6,xpos_InjectUtil_4_0_6;
	wire[7:0] xneg_ClockwiseUtil_4_0_6,xneg_CounterClockwiseUtil_4_0_6,xneg_InjectUtil_4_0_6;
	wire[7:0] ypos_ClockwiseUtil_4_0_6,ypos_CounterClockwiseUtil_4_0_6,ypos_InjectUtil_4_0_6;
	wire[7:0] yneg_ClockwiseUtil_4_0_6,yneg_CounterClockwiseUtil_4_0_6,yneg_InjectUtil_4_0_6;
	wire[7:0] zpos_ClockwiseUtil_4_0_6,zpos_CounterClockwiseUtil_4_0_6,zpos_InjectUtil_4_0_6;
	wire[7:0] zneg_ClockwiseUtil_4_0_6,zneg_CounterClockwiseUtil_4_0_6,zneg_InjectUtil_4_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_0_7, eject_xpos_ser_4_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_0_7, eject_xneg_ser_4_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_0_7, eject_ypos_ser_4_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_0_7, eject_yneg_ser_4_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_0_7, eject_zpos_ser_4_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_0_7, eject_zneg_ser_4_0_7;
	wire[7:0] xpos_ClockwiseUtil_4_0_7,xpos_CounterClockwiseUtil_4_0_7,xpos_InjectUtil_4_0_7;
	wire[7:0] xneg_ClockwiseUtil_4_0_7,xneg_CounterClockwiseUtil_4_0_7,xneg_InjectUtil_4_0_7;
	wire[7:0] ypos_ClockwiseUtil_4_0_7,ypos_CounterClockwiseUtil_4_0_7,ypos_InjectUtil_4_0_7;
	wire[7:0] yneg_ClockwiseUtil_4_0_7,yneg_CounterClockwiseUtil_4_0_7,yneg_InjectUtil_4_0_7;
	wire[7:0] zpos_ClockwiseUtil_4_0_7,zpos_CounterClockwiseUtil_4_0_7,zpos_InjectUtil_4_0_7;
	wire[7:0] zneg_ClockwiseUtil_4_0_7,zneg_CounterClockwiseUtil_4_0_7,zneg_InjectUtil_4_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_0, eject_xpos_ser_4_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_0, eject_xneg_ser_4_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_0, eject_ypos_ser_4_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_0, eject_yneg_ser_4_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_0, eject_zpos_ser_4_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_0, eject_zneg_ser_4_1_0;
	wire[7:0] xpos_ClockwiseUtil_4_1_0,xpos_CounterClockwiseUtil_4_1_0,xpos_InjectUtil_4_1_0;
	wire[7:0] xneg_ClockwiseUtil_4_1_0,xneg_CounterClockwiseUtil_4_1_0,xneg_InjectUtil_4_1_0;
	wire[7:0] ypos_ClockwiseUtil_4_1_0,ypos_CounterClockwiseUtil_4_1_0,ypos_InjectUtil_4_1_0;
	wire[7:0] yneg_ClockwiseUtil_4_1_0,yneg_CounterClockwiseUtil_4_1_0,yneg_InjectUtil_4_1_0;
	wire[7:0] zpos_ClockwiseUtil_4_1_0,zpos_CounterClockwiseUtil_4_1_0,zpos_InjectUtil_4_1_0;
	wire[7:0] zneg_ClockwiseUtil_4_1_0,zneg_CounterClockwiseUtil_4_1_0,zneg_InjectUtil_4_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_1, eject_xpos_ser_4_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_1, eject_xneg_ser_4_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_1, eject_ypos_ser_4_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_1, eject_yneg_ser_4_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_1, eject_zpos_ser_4_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_1, eject_zneg_ser_4_1_1;
	wire[7:0] xpos_ClockwiseUtil_4_1_1,xpos_CounterClockwiseUtil_4_1_1,xpos_InjectUtil_4_1_1;
	wire[7:0] xneg_ClockwiseUtil_4_1_1,xneg_CounterClockwiseUtil_4_1_1,xneg_InjectUtil_4_1_1;
	wire[7:0] ypos_ClockwiseUtil_4_1_1,ypos_CounterClockwiseUtil_4_1_1,ypos_InjectUtil_4_1_1;
	wire[7:0] yneg_ClockwiseUtil_4_1_1,yneg_CounterClockwiseUtil_4_1_1,yneg_InjectUtil_4_1_1;
	wire[7:0] zpos_ClockwiseUtil_4_1_1,zpos_CounterClockwiseUtil_4_1_1,zpos_InjectUtil_4_1_1;
	wire[7:0] zneg_ClockwiseUtil_4_1_1,zneg_CounterClockwiseUtil_4_1_1,zneg_InjectUtil_4_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_2, eject_xpos_ser_4_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_2, eject_xneg_ser_4_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_2, eject_ypos_ser_4_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_2, eject_yneg_ser_4_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_2, eject_zpos_ser_4_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_2, eject_zneg_ser_4_1_2;
	wire[7:0] xpos_ClockwiseUtil_4_1_2,xpos_CounterClockwiseUtil_4_1_2,xpos_InjectUtil_4_1_2;
	wire[7:0] xneg_ClockwiseUtil_4_1_2,xneg_CounterClockwiseUtil_4_1_2,xneg_InjectUtil_4_1_2;
	wire[7:0] ypos_ClockwiseUtil_4_1_2,ypos_CounterClockwiseUtil_4_1_2,ypos_InjectUtil_4_1_2;
	wire[7:0] yneg_ClockwiseUtil_4_1_2,yneg_CounterClockwiseUtil_4_1_2,yneg_InjectUtil_4_1_2;
	wire[7:0] zpos_ClockwiseUtil_4_1_2,zpos_CounterClockwiseUtil_4_1_2,zpos_InjectUtil_4_1_2;
	wire[7:0] zneg_ClockwiseUtil_4_1_2,zneg_CounterClockwiseUtil_4_1_2,zneg_InjectUtil_4_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_3, eject_xpos_ser_4_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_3, eject_xneg_ser_4_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_3, eject_ypos_ser_4_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_3, eject_yneg_ser_4_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_3, eject_zpos_ser_4_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_3, eject_zneg_ser_4_1_3;
	wire[7:0] xpos_ClockwiseUtil_4_1_3,xpos_CounterClockwiseUtil_4_1_3,xpos_InjectUtil_4_1_3;
	wire[7:0] xneg_ClockwiseUtil_4_1_3,xneg_CounterClockwiseUtil_4_1_3,xneg_InjectUtil_4_1_3;
	wire[7:0] ypos_ClockwiseUtil_4_1_3,ypos_CounterClockwiseUtil_4_1_3,ypos_InjectUtil_4_1_3;
	wire[7:0] yneg_ClockwiseUtil_4_1_3,yneg_CounterClockwiseUtil_4_1_3,yneg_InjectUtil_4_1_3;
	wire[7:0] zpos_ClockwiseUtil_4_1_3,zpos_CounterClockwiseUtil_4_1_3,zpos_InjectUtil_4_1_3;
	wire[7:0] zneg_ClockwiseUtil_4_1_3,zneg_CounterClockwiseUtil_4_1_3,zneg_InjectUtil_4_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_4, eject_xpos_ser_4_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_4, eject_xneg_ser_4_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_4, eject_ypos_ser_4_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_4, eject_yneg_ser_4_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_4, eject_zpos_ser_4_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_4, eject_zneg_ser_4_1_4;
	wire[7:0] xpos_ClockwiseUtil_4_1_4,xpos_CounterClockwiseUtil_4_1_4,xpos_InjectUtil_4_1_4;
	wire[7:0] xneg_ClockwiseUtil_4_1_4,xneg_CounterClockwiseUtil_4_1_4,xneg_InjectUtil_4_1_4;
	wire[7:0] ypos_ClockwiseUtil_4_1_4,ypos_CounterClockwiseUtil_4_1_4,ypos_InjectUtil_4_1_4;
	wire[7:0] yneg_ClockwiseUtil_4_1_4,yneg_CounterClockwiseUtil_4_1_4,yneg_InjectUtil_4_1_4;
	wire[7:0] zpos_ClockwiseUtil_4_1_4,zpos_CounterClockwiseUtil_4_1_4,zpos_InjectUtil_4_1_4;
	wire[7:0] zneg_ClockwiseUtil_4_1_4,zneg_CounterClockwiseUtil_4_1_4,zneg_InjectUtil_4_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_5, eject_xpos_ser_4_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_5, eject_xneg_ser_4_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_5, eject_ypos_ser_4_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_5, eject_yneg_ser_4_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_5, eject_zpos_ser_4_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_5, eject_zneg_ser_4_1_5;
	wire[7:0] xpos_ClockwiseUtil_4_1_5,xpos_CounterClockwiseUtil_4_1_5,xpos_InjectUtil_4_1_5;
	wire[7:0] xneg_ClockwiseUtil_4_1_5,xneg_CounterClockwiseUtil_4_1_5,xneg_InjectUtil_4_1_5;
	wire[7:0] ypos_ClockwiseUtil_4_1_5,ypos_CounterClockwiseUtil_4_1_5,ypos_InjectUtil_4_1_5;
	wire[7:0] yneg_ClockwiseUtil_4_1_5,yneg_CounterClockwiseUtil_4_1_5,yneg_InjectUtil_4_1_5;
	wire[7:0] zpos_ClockwiseUtil_4_1_5,zpos_CounterClockwiseUtil_4_1_5,zpos_InjectUtil_4_1_5;
	wire[7:0] zneg_ClockwiseUtil_4_1_5,zneg_CounterClockwiseUtil_4_1_5,zneg_InjectUtil_4_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_6, eject_xpos_ser_4_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_6, eject_xneg_ser_4_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_6, eject_ypos_ser_4_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_6, eject_yneg_ser_4_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_6, eject_zpos_ser_4_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_6, eject_zneg_ser_4_1_6;
	wire[7:0] xpos_ClockwiseUtil_4_1_6,xpos_CounterClockwiseUtil_4_1_6,xpos_InjectUtil_4_1_6;
	wire[7:0] xneg_ClockwiseUtil_4_1_6,xneg_CounterClockwiseUtil_4_1_6,xneg_InjectUtil_4_1_6;
	wire[7:0] ypos_ClockwiseUtil_4_1_6,ypos_CounterClockwiseUtil_4_1_6,ypos_InjectUtil_4_1_6;
	wire[7:0] yneg_ClockwiseUtil_4_1_6,yneg_CounterClockwiseUtil_4_1_6,yneg_InjectUtil_4_1_6;
	wire[7:0] zpos_ClockwiseUtil_4_1_6,zpos_CounterClockwiseUtil_4_1_6,zpos_InjectUtil_4_1_6;
	wire[7:0] zneg_ClockwiseUtil_4_1_6,zneg_CounterClockwiseUtil_4_1_6,zneg_InjectUtil_4_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_1_7, eject_xpos_ser_4_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_1_7, eject_xneg_ser_4_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_1_7, eject_ypos_ser_4_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_1_7, eject_yneg_ser_4_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_1_7, eject_zpos_ser_4_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_1_7, eject_zneg_ser_4_1_7;
	wire[7:0] xpos_ClockwiseUtil_4_1_7,xpos_CounterClockwiseUtil_4_1_7,xpos_InjectUtil_4_1_7;
	wire[7:0] xneg_ClockwiseUtil_4_1_7,xneg_CounterClockwiseUtil_4_1_7,xneg_InjectUtil_4_1_7;
	wire[7:0] ypos_ClockwiseUtil_4_1_7,ypos_CounterClockwiseUtil_4_1_7,ypos_InjectUtil_4_1_7;
	wire[7:0] yneg_ClockwiseUtil_4_1_7,yneg_CounterClockwiseUtil_4_1_7,yneg_InjectUtil_4_1_7;
	wire[7:0] zpos_ClockwiseUtil_4_1_7,zpos_CounterClockwiseUtil_4_1_7,zpos_InjectUtil_4_1_7;
	wire[7:0] zneg_ClockwiseUtil_4_1_7,zneg_CounterClockwiseUtil_4_1_7,zneg_InjectUtil_4_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_0, eject_xpos_ser_4_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_0, eject_xneg_ser_4_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_0, eject_ypos_ser_4_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_0, eject_yneg_ser_4_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_0, eject_zpos_ser_4_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_0, eject_zneg_ser_4_2_0;
	wire[7:0] xpos_ClockwiseUtil_4_2_0,xpos_CounterClockwiseUtil_4_2_0,xpos_InjectUtil_4_2_0;
	wire[7:0] xneg_ClockwiseUtil_4_2_0,xneg_CounterClockwiseUtil_4_2_0,xneg_InjectUtil_4_2_0;
	wire[7:0] ypos_ClockwiseUtil_4_2_0,ypos_CounterClockwiseUtil_4_2_0,ypos_InjectUtil_4_2_0;
	wire[7:0] yneg_ClockwiseUtil_4_2_0,yneg_CounterClockwiseUtil_4_2_0,yneg_InjectUtil_4_2_0;
	wire[7:0] zpos_ClockwiseUtil_4_2_0,zpos_CounterClockwiseUtil_4_2_0,zpos_InjectUtil_4_2_0;
	wire[7:0] zneg_ClockwiseUtil_4_2_0,zneg_CounterClockwiseUtil_4_2_0,zneg_InjectUtil_4_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_1, eject_xpos_ser_4_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_1, eject_xneg_ser_4_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_1, eject_ypos_ser_4_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_1, eject_yneg_ser_4_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_1, eject_zpos_ser_4_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_1, eject_zneg_ser_4_2_1;
	wire[7:0] xpos_ClockwiseUtil_4_2_1,xpos_CounterClockwiseUtil_4_2_1,xpos_InjectUtil_4_2_1;
	wire[7:0] xneg_ClockwiseUtil_4_2_1,xneg_CounterClockwiseUtil_4_2_1,xneg_InjectUtil_4_2_1;
	wire[7:0] ypos_ClockwiseUtil_4_2_1,ypos_CounterClockwiseUtil_4_2_1,ypos_InjectUtil_4_2_1;
	wire[7:0] yneg_ClockwiseUtil_4_2_1,yneg_CounterClockwiseUtil_4_2_1,yneg_InjectUtil_4_2_1;
	wire[7:0] zpos_ClockwiseUtil_4_2_1,zpos_CounterClockwiseUtil_4_2_1,zpos_InjectUtil_4_2_1;
	wire[7:0] zneg_ClockwiseUtil_4_2_1,zneg_CounterClockwiseUtil_4_2_1,zneg_InjectUtil_4_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_2, eject_xpos_ser_4_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_2, eject_xneg_ser_4_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_2, eject_ypos_ser_4_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_2, eject_yneg_ser_4_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_2, eject_zpos_ser_4_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_2, eject_zneg_ser_4_2_2;
	wire[7:0] xpos_ClockwiseUtil_4_2_2,xpos_CounterClockwiseUtil_4_2_2,xpos_InjectUtil_4_2_2;
	wire[7:0] xneg_ClockwiseUtil_4_2_2,xneg_CounterClockwiseUtil_4_2_2,xneg_InjectUtil_4_2_2;
	wire[7:0] ypos_ClockwiseUtil_4_2_2,ypos_CounterClockwiseUtil_4_2_2,ypos_InjectUtil_4_2_2;
	wire[7:0] yneg_ClockwiseUtil_4_2_2,yneg_CounterClockwiseUtil_4_2_2,yneg_InjectUtil_4_2_2;
	wire[7:0] zpos_ClockwiseUtil_4_2_2,zpos_CounterClockwiseUtil_4_2_2,zpos_InjectUtil_4_2_2;
	wire[7:0] zneg_ClockwiseUtil_4_2_2,zneg_CounterClockwiseUtil_4_2_2,zneg_InjectUtil_4_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_3, eject_xpos_ser_4_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_3, eject_xneg_ser_4_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_3, eject_ypos_ser_4_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_3, eject_yneg_ser_4_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_3, eject_zpos_ser_4_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_3, eject_zneg_ser_4_2_3;
	wire[7:0] xpos_ClockwiseUtil_4_2_3,xpos_CounterClockwiseUtil_4_2_3,xpos_InjectUtil_4_2_3;
	wire[7:0] xneg_ClockwiseUtil_4_2_3,xneg_CounterClockwiseUtil_4_2_3,xneg_InjectUtil_4_2_3;
	wire[7:0] ypos_ClockwiseUtil_4_2_3,ypos_CounterClockwiseUtil_4_2_3,ypos_InjectUtil_4_2_3;
	wire[7:0] yneg_ClockwiseUtil_4_2_3,yneg_CounterClockwiseUtil_4_2_3,yneg_InjectUtil_4_2_3;
	wire[7:0] zpos_ClockwiseUtil_4_2_3,zpos_CounterClockwiseUtil_4_2_3,zpos_InjectUtil_4_2_3;
	wire[7:0] zneg_ClockwiseUtil_4_2_3,zneg_CounterClockwiseUtil_4_2_3,zneg_InjectUtil_4_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_4, eject_xpos_ser_4_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_4, eject_xneg_ser_4_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_4, eject_ypos_ser_4_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_4, eject_yneg_ser_4_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_4, eject_zpos_ser_4_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_4, eject_zneg_ser_4_2_4;
	wire[7:0] xpos_ClockwiseUtil_4_2_4,xpos_CounterClockwiseUtil_4_2_4,xpos_InjectUtil_4_2_4;
	wire[7:0] xneg_ClockwiseUtil_4_2_4,xneg_CounterClockwiseUtil_4_2_4,xneg_InjectUtil_4_2_4;
	wire[7:0] ypos_ClockwiseUtil_4_2_4,ypos_CounterClockwiseUtil_4_2_4,ypos_InjectUtil_4_2_4;
	wire[7:0] yneg_ClockwiseUtil_4_2_4,yneg_CounterClockwiseUtil_4_2_4,yneg_InjectUtil_4_2_4;
	wire[7:0] zpos_ClockwiseUtil_4_2_4,zpos_CounterClockwiseUtil_4_2_4,zpos_InjectUtil_4_2_4;
	wire[7:0] zneg_ClockwiseUtil_4_2_4,zneg_CounterClockwiseUtil_4_2_4,zneg_InjectUtil_4_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_5, eject_xpos_ser_4_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_5, eject_xneg_ser_4_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_5, eject_ypos_ser_4_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_5, eject_yneg_ser_4_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_5, eject_zpos_ser_4_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_5, eject_zneg_ser_4_2_5;
	wire[7:0] xpos_ClockwiseUtil_4_2_5,xpos_CounterClockwiseUtil_4_2_5,xpos_InjectUtil_4_2_5;
	wire[7:0] xneg_ClockwiseUtil_4_2_5,xneg_CounterClockwiseUtil_4_2_5,xneg_InjectUtil_4_2_5;
	wire[7:0] ypos_ClockwiseUtil_4_2_5,ypos_CounterClockwiseUtil_4_2_5,ypos_InjectUtil_4_2_5;
	wire[7:0] yneg_ClockwiseUtil_4_2_5,yneg_CounterClockwiseUtil_4_2_5,yneg_InjectUtil_4_2_5;
	wire[7:0] zpos_ClockwiseUtil_4_2_5,zpos_CounterClockwiseUtil_4_2_5,zpos_InjectUtil_4_2_5;
	wire[7:0] zneg_ClockwiseUtil_4_2_5,zneg_CounterClockwiseUtil_4_2_5,zneg_InjectUtil_4_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_6, eject_xpos_ser_4_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_6, eject_xneg_ser_4_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_6, eject_ypos_ser_4_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_6, eject_yneg_ser_4_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_6, eject_zpos_ser_4_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_6, eject_zneg_ser_4_2_6;
	wire[7:0] xpos_ClockwiseUtil_4_2_6,xpos_CounterClockwiseUtil_4_2_6,xpos_InjectUtil_4_2_6;
	wire[7:0] xneg_ClockwiseUtil_4_2_6,xneg_CounterClockwiseUtil_4_2_6,xneg_InjectUtil_4_2_6;
	wire[7:0] ypos_ClockwiseUtil_4_2_6,ypos_CounterClockwiseUtil_4_2_6,ypos_InjectUtil_4_2_6;
	wire[7:0] yneg_ClockwiseUtil_4_2_6,yneg_CounterClockwiseUtil_4_2_6,yneg_InjectUtil_4_2_6;
	wire[7:0] zpos_ClockwiseUtil_4_2_6,zpos_CounterClockwiseUtil_4_2_6,zpos_InjectUtil_4_2_6;
	wire[7:0] zneg_ClockwiseUtil_4_2_6,zneg_CounterClockwiseUtil_4_2_6,zneg_InjectUtil_4_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_2_7, eject_xpos_ser_4_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_2_7, eject_xneg_ser_4_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_2_7, eject_ypos_ser_4_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_2_7, eject_yneg_ser_4_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_2_7, eject_zpos_ser_4_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_2_7, eject_zneg_ser_4_2_7;
	wire[7:0] xpos_ClockwiseUtil_4_2_7,xpos_CounterClockwiseUtil_4_2_7,xpos_InjectUtil_4_2_7;
	wire[7:0] xneg_ClockwiseUtil_4_2_7,xneg_CounterClockwiseUtil_4_2_7,xneg_InjectUtil_4_2_7;
	wire[7:0] ypos_ClockwiseUtil_4_2_7,ypos_CounterClockwiseUtil_4_2_7,ypos_InjectUtil_4_2_7;
	wire[7:0] yneg_ClockwiseUtil_4_2_7,yneg_CounterClockwiseUtil_4_2_7,yneg_InjectUtil_4_2_7;
	wire[7:0] zpos_ClockwiseUtil_4_2_7,zpos_CounterClockwiseUtil_4_2_7,zpos_InjectUtil_4_2_7;
	wire[7:0] zneg_ClockwiseUtil_4_2_7,zneg_CounterClockwiseUtil_4_2_7,zneg_InjectUtil_4_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_0, eject_xpos_ser_4_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_0, eject_xneg_ser_4_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_0, eject_ypos_ser_4_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_0, eject_yneg_ser_4_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_0, eject_zpos_ser_4_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_0, eject_zneg_ser_4_3_0;
	wire[7:0] xpos_ClockwiseUtil_4_3_0,xpos_CounterClockwiseUtil_4_3_0,xpos_InjectUtil_4_3_0;
	wire[7:0] xneg_ClockwiseUtil_4_3_0,xneg_CounterClockwiseUtil_4_3_0,xneg_InjectUtil_4_3_0;
	wire[7:0] ypos_ClockwiseUtil_4_3_0,ypos_CounterClockwiseUtil_4_3_0,ypos_InjectUtil_4_3_0;
	wire[7:0] yneg_ClockwiseUtil_4_3_0,yneg_CounterClockwiseUtil_4_3_0,yneg_InjectUtil_4_3_0;
	wire[7:0] zpos_ClockwiseUtil_4_3_0,zpos_CounterClockwiseUtil_4_3_0,zpos_InjectUtil_4_3_0;
	wire[7:0] zneg_ClockwiseUtil_4_3_0,zneg_CounterClockwiseUtil_4_3_0,zneg_InjectUtil_4_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_1, eject_xpos_ser_4_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_1, eject_xneg_ser_4_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_1, eject_ypos_ser_4_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_1, eject_yneg_ser_4_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_1, eject_zpos_ser_4_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_1, eject_zneg_ser_4_3_1;
	wire[7:0] xpos_ClockwiseUtil_4_3_1,xpos_CounterClockwiseUtil_4_3_1,xpos_InjectUtil_4_3_1;
	wire[7:0] xneg_ClockwiseUtil_4_3_1,xneg_CounterClockwiseUtil_4_3_1,xneg_InjectUtil_4_3_1;
	wire[7:0] ypos_ClockwiseUtil_4_3_1,ypos_CounterClockwiseUtil_4_3_1,ypos_InjectUtil_4_3_1;
	wire[7:0] yneg_ClockwiseUtil_4_3_1,yneg_CounterClockwiseUtil_4_3_1,yneg_InjectUtil_4_3_1;
	wire[7:0] zpos_ClockwiseUtil_4_3_1,zpos_CounterClockwiseUtil_4_3_1,zpos_InjectUtil_4_3_1;
	wire[7:0] zneg_ClockwiseUtil_4_3_1,zneg_CounterClockwiseUtil_4_3_1,zneg_InjectUtil_4_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_2, eject_xpos_ser_4_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_2, eject_xneg_ser_4_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_2, eject_ypos_ser_4_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_2, eject_yneg_ser_4_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_2, eject_zpos_ser_4_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_2, eject_zneg_ser_4_3_2;
	wire[7:0] xpos_ClockwiseUtil_4_3_2,xpos_CounterClockwiseUtil_4_3_2,xpos_InjectUtil_4_3_2;
	wire[7:0] xneg_ClockwiseUtil_4_3_2,xneg_CounterClockwiseUtil_4_3_2,xneg_InjectUtil_4_3_2;
	wire[7:0] ypos_ClockwiseUtil_4_3_2,ypos_CounterClockwiseUtil_4_3_2,ypos_InjectUtil_4_3_2;
	wire[7:0] yneg_ClockwiseUtil_4_3_2,yneg_CounterClockwiseUtil_4_3_2,yneg_InjectUtil_4_3_2;
	wire[7:0] zpos_ClockwiseUtil_4_3_2,zpos_CounterClockwiseUtil_4_3_2,zpos_InjectUtil_4_3_2;
	wire[7:0] zneg_ClockwiseUtil_4_3_2,zneg_CounterClockwiseUtil_4_3_2,zneg_InjectUtil_4_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_3, eject_xpos_ser_4_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_3, eject_xneg_ser_4_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_3, eject_ypos_ser_4_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_3, eject_yneg_ser_4_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_3, eject_zpos_ser_4_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_3, eject_zneg_ser_4_3_3;
	wire[7:0] xpos_ClockwiseUtil_4_3_3,xpos_CounterClockwiseUtil_4_3_3,xpos_InjectUtil_4_3_3;
	wire[7:0] xneg_ClockwiseUtil_4_3_3,xneg_CounterClockwiseUtil_4_3_3,xneg_InjectUtil_4_3_3;
	wire[7:0] ypos_ClockwiseUtil_4_3_3,ypos_CounterClockwiseUtil_4_3_3,ypos_InjectUtil_4_3_3;
	wire[7:0] yneg_ClockwiseUtil_4_3_3,yneg_CounterClockwiseUtil_4_3_3,yneg_InjectUtil_4_3_3;
	wire[7:0] zpos_ClockwiseUtil_4_3_3,zpos_CounterClockwiseUtil_4_3_3,zpos_InjectUtil_4_3_3;
	wire[7:0] zneg_ClockwiseUtil_4_3_3,zneg_CounterClockwiseUtil_4_3_3,zneg_InjectUtil_4_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_4, eject_xpos_ser_4_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_4, eject_xneg_ser_4_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_4, eject_ypos_ser_4_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_4, eject_yneg_ser_4_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_4, eject_zpos_ser_4_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_4, eject_zneg_ser_4_3_4;
	wire[7:0] xpos_ClockwiseUtil_4_3_4,xpos_CounterClockwiseUtil_4_3_4,xpos_InjectUtil_4_3_4;
	wire[7:0] xneg_ClockwiseUtil_4_3_4,xneg_CounterClockwiseUtil_4_3_4,xneg_InjectUtil_4_3_4;
	wire[7:0] ypos_ClockwiseUtil_4_3_4,ypos_CounterClockwiseUtil_4_3_4,ypos_InjectUtil_4_3_4;
	wire[7:0] yneg_ClockwiseUtil_4_3_4,yneg_CounterClockwiseUtil_4_3_4,yneg_InjectUtil_4_3_4;
	wire[7:0] zpos_ClockwiseUtil_4_3_4,zpos_CounterClockwiseUtil_4_3_4,zpos_InjectUtil_4_3_4;
	wire[7:0] zneg_ClockwiseUtil_4_3_4,zneg_CounterClockwiseUtil_4_3_4,zneg_InjectUtil_4_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_5, eject_xpos_ser_4_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_5, eject_xneg_ser_4_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_5, eject_ypos_ser_4_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_5, eject_yneg_ser_4_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_5, eject_zpos_ser_4_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_5, eject_zneg_ser_4_3_5;
	wire[7:0] xpos_ClockwiseUtil_4_3_5,xpos_CounterClockwiseUtil_4_3_5,xpos_InjectUtil_4_3_5;
	wire[7:0] xneg_ClockwiseUtil_4_3_5,xneg_CounterClockwiseUtil_4_3_5,xneg_InjectUtil_4_3_5;
	wire[7:0] ypos_ClockwiseUtil_4_3_5,ypos_CounterClockwiseUtil_4_3_5,ypos_InjectUtil_4_3_5;
	wire[7:0] yneg_ClockwiseUtil_4_3_5,yneg_CounterClockwiseUtil_4_3_5,yneg_InjectUtil_4_3_5;
	wire[7:0] zpos_ClockwiseUtil_4_3_5,zpos_CounterClockwiseUtil_4_3_5,zpos_InjectUtil_4_3_5;
	wire[7:0] zneg_ClockwiseUtil_4_3_5,zneg_CounterClockwiseUtil_4_3_5,zneg_InjectUtil_4_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_6, eject_xpos_ser_4_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_6, eject_xneg_ser_4_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_6, eject_ypos_ser_4_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_6, eject_yneg_ser_4_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_6, eject_zpos_ser_4_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_6, eject_zneg_ser_4_3_6;
	wire[7:0] xpos_ClockwiseUtil_4_3_6,xpos_CounterClockwiseUtil_4_3_6,xpos_InjectUtil_4_3_6;
	wire[7:0] xneg_ClockwiseUtil_4_3_6,xneg_CounterClockwiseUtil_4_3_6,xneg_InjectUtil_4_3_6;
	wire[7:0] ypos_ClockwiseUtil_4_3_6,ypos_CounterClockwiseUtil_4_3_6,ypos_InjectUtil_4_3_6;
	wire[7:0] yneg_ClockwiseUtil_4_3_6,yneg_CounterClockwiseUtil_4_3_6,yneg_InjectUtil_4_3_6;
	wire[7:0] zpos_ClockwiseUtil_4_3_6,zpos_CounterClockwiseUtil_4_3_6,zpos_InjectUtil_4_3_6;
	wire[7:0] zneg_ClockwiseUtil_4_3_6,zneg_CounterClockwiseUtil_4_3_6,zneg_InjectUtil_4_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_3_7, eject_xpos_ser_4_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_3_7, eject_xneg_ser_4_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_3_7, eject_ypos_ser_4_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_3_7, eject_yneg_ser_4_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_3_7, eject_zpos_ser_4_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_3_7, eject_zneg_ser_4_3_7;
	wire[7:0] xpos_ClockwiseUtil_4_3_7,xpos_CounterClockwiseUtil_4_3_7,xpos_InjectUtil_4_3_7;
	wire[7:0] xneg_ClockwiseUtil_4_3_7,xneg_CounterClockwiseUtil_4_3_7,xneg_InjectUtil_4_3_7;
	wire[7:0] ypos_ClockwiseUtil_4_3_7,ypos_CounterClockwiseUtil_4_3_7,ypos_InjectUtil_4_3_7;
	wire[7:0] yneg_ClockwiseUtil_4_3_7,yneg_CounterClockwiseUtil_4_3_7,yneg_InjectUtil_4_3_7;
	wire[7:0] zpos_ClockwiseUtil_4_3_7,zpos_CounterClockwiseUtil_4_3_7,zpos_InjectUtil_4_3_7;
	wire[7:0] zneg_ClockwiseUtil_4_3_7,zneg_CounterClockwiseUtil_4_3_7,zneg_InjectUtil_4_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_0, eject_xpos_ser_4_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_0, eject_xneg_ser_4_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_0, eject_ypos_ser_4_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_0, eject_yneg_ser_4_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_0, eject_zpos_ser_4_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_0, eject_zneg_ser_4_4_0;
	wire[7:0] xpos_ClockwiseUtil_4_4_0,xpos_CounterClockwiseUtil_4_4_0,xpos_InjectUtil_4_4_0;
	wire[7:0] xneg_ClockwiseUtil_4_4_0,xneg_CounterClockwiseUtil_4_4_0,xneg_InjectUtil_4_4_0;
	wire[7:0] ypos_ClockwiseUtil_4_4_0,ypos_CounterClockwiseUtil_4_4_0,ypos_InjectUtil_4_4_0;
	wire[7:0] yneg_ClockwiseUtil_4_4_0,yneg_CounterClockwiseUtil_4_4_0,yneg_InjectUtil_4_4_0;
	wire[7:0] zpos_ClockwiseUtil_4_4_0,zpos_CounterClockwiseUtil_4_4_0,zpos_InjectUtil_4_4_0;
	wire[7:0] zneg_ClockwiseUtil_4_4_0,zneg_CounterClockwiseUtil_4_4_0,zneg_InjectUtil_4_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_1, eject_xpos_ser_4_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_1, eject_xneg_ser_4_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_1, eject_ypos_ser_4_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_1, eject_yneg_ser_4_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_1, eject_zpos_ser_4_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_1, eject_zneg_ser_4_4_1;
	wire[7:0] xpos_ClockwiseUtil_4_4_1,xpos_CounterClockwiseUtil_4_4_1,xpos_InjectUtil_4_4_1;
	wire[7:0] xneg_ClockwiseUtil_4_4_1,xneg_CounterClockwiseUtil_4_4_1,xneg_InjectUtil_4_4_1;
	wire[7:0] ypos_ClockwiseUtil_4_4_1,ypos_CounterClockwiseUtil_4_4_1,ypos_InjectUtil_4_4_1;
	wire[7:0] yneg_ClockwiseUtil_4_4_1,yneg_CounterClockwiseUtil_4_4_1,yneg_InjectUtil_4_4_1;
	wire[7:0] zpos_ClockwiseUtil_4_4_1,zpos_CounterClockwiseUtil_4_4_1,zpos_InjectUtil_4_4_1;
	wire[7:0] zneg_ClockwiseUtil_4_4_1,zneg_CounterClockwiseUtil_4_4_1,zneg_InjectUtil_4_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_2, eject_xpos_ser_4_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_2, eject_xneg_ser_4_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_2, eject_ypos_ser_4_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_2, eject_yneg_ser_4_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_2, eject_zpos_ser_4_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_2, eject_zneg_ser_4_4_2;
	wire[7:0] xpos_ClockwiseUtil_4_4_2,xpos_CounterClockwiseUtil_4_4_2,xpos_InjectUtil_4_4_2;
	wire[7:0] xneg_ClockwiseUtil_4_4_2,xneg_CounterClockwiseUtil_4_4_2,xneg_InjectUtil_4_4_2;
	wire[7:0] ypos_ClockwiseUtil_4_4_2,ypos_CounterClockwiseUtil_4_4_2,ypos_InjectUtil_4_4_2;
	wire[7:0] yneg_ClockwiseUtil_4_4_2,yneg_CounterClockwiseUtil_4_4_2,yneg_InjectUtil_4_4_2;
	wire[7:0] zpos_ClockwiseUtil_4_4_2,zpos_CounterClockwiseUtil_4_4_2,zpos_InjectUtil_4_4_2;
	wire[7:0] zneg_ClockwiseUtil_4_4_2,zneg_CounterClockwiseUtil_4_4_2,zneg_InjectUtil_4_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_3, eject_xpos_ser_4_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_3, eject_xneg_ser_4_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_3, eject_ypos_ser_4_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_3, eject_yneg_ser_4_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_3, eject_zpos_ser_4_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_3, eject_zneg_ser_4_4_3;
	wire[7:0] xpos_ClockwiseUtil_4_4_3,xpos_CounterClockwiseUtil_4_4_3,xpos_InjectUtil_4_4_3;
	wire[7:0] xneg_ClockwiseUtil_4_4_3,xneg_CounterClockwiseUtil_4_4_3,xneg_InjectUtil_4_4_3;
	wire[7:0] ypos_ClockwiseUtil_4_4_3,ypos_CounterClockwiseUtil_4_4_3,ypos_InjectUtil_4_4_3;
	wire[7:0] yneg_ClockwiseUtil_4_4_3,yneg_CounterClockwiseUtil_4_4_3,yneg_InjectUtil_4_4_3;
	wire[7:0] zpos_ClockwiseUtil_4_4_3,zpos_CounterClockwiseUtil_4_4_3,zpos_InjectUtil_4_4_3;
	wire[7:0] zneg_ClockwiseUtil_4_4_3,zneg_CounterClockwiseUtil_4_4_3,zneg_InjectUtil_4_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_4, eject_xpos_ser_4_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_4, eject_xneg_ser_4_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_4, eject_ypos_ser_4_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_4, eject_yneg_ser_4_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_4, eject_zpos_ser_4_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_4, eject_zneg_ser_4_4_4;
	wire[7:0] xpos_ClockwiseUtil_4_4_4,xpos_CounterClockwiseUtil_4_4_4,xpos_InjectUtil_4_4_4;
	wire[7:0] xneg_ClockwiseUtil_4_4_4,xneg_CounterClockwiseUtil_4_4_4,xneg_InjectUtil_4_4_4;
	wire[7:0] ypos_ClockwiseUtil_4_4_4,ypos_CounterClockwiseUtil_4_4_4,ypos_InjectUtil_4_4_4;
	wire[7:0] yneg_ClockwiseUtil_4_4_4,yneg_CounterClockwiseUtil_4_4_4,yneg_InjectUtil_4_4_4;
	wire[7:0] zpos_ClockwiseUtil_4_4_4,zpos_CounterClockwiseUtil_4_4_4,zpos_InjectUtil_4_4_4;
	wire[7:0] zneg_ClockwiseUtil_4_4_4,zneg_CounterClockwiseUtil_4_4_4,zneg_InjectUtil_4_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_5, eject_xpos_ser_4_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_5, eject_xneg_ser_4_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_5, eject_ypos_ser_4_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_5, eject_yneg_ser_4_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_5, eject_zpos_ser_4_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_5, eject_zneg_ser_4_4_5;
	wire[7:0] xpos_ClockwiseUtil_4_4_5,xpos_CounterClockwiseUtil_4_4_5,xpos_InjectUtil_4_4_5;
	wire[7:0] xneg_ClockwiseUtil_4_4_5,xneg_CounterClockwiseUtil_4_4_5,xneg_InjectUtil_4_4_5;
	wire[7:0] ypos_ClockwiseUtil_4_4_5,ypos_CounterClockwiseUtil_4_4_5,ypos_InjectUtil_4_4_5;
	wire[7:0] yneg_ClockwiseUtil_4_4_5,yneg_CounterClockwiseUtil_4_4_5,yneg_InjectUtil_4_4_5;
	wire[7:0] zpos_ClockwiseUtil_4_4_5,zpos_CounterClockwiseUtil_4_4_5,zpos_InjectUtil_4_4_5;
	wire[7:0] zneg_ClockwiseUtil_4_4_5,zneg_CounterClockwiseUtil_4_4_5,zneg_InjectUtil_4_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_6, eject_xpos_ser_4_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_6, eject_xneg_ser_4_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_6, eject_ypos_ser_4_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_6, eject_yneg_ser_4_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_6, eject_zpos_ser_4_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_6, eject_zneg_ser_4_4_6;
	wire[7:0] xpos_ClockwiseUtil_4_4_6,xpos_CounterClockwiseUtil_4_4_6,xpos_InjectUtil_4_4_6;
	wire[7:0] xneg_ClockwiseUtil_4_4_6,xneg_CounterClockwiseUtil_4_4_6,xneg_InjectUtil_4_4_6;
	wire[7:0] ypos_ClockwiseUtil_4_4_6,ypos_CounterClockwiseUtil_4_4_6,ypos_InjectUtil_4_4_6;
	wire[7:0] yneg_ClockwiseUtil_4_4_6,yneg_CounterClockwiseUtil_4_4_6,yneg_InjectUtil_4_4_6;
	wire[7:0] zpos_ClockwiseUtil_4_4_6,zpos_CounterClockwiseUtil_4_4_6,zpos_InjectUtil_4_4_6;
	wire[7:0] zneg_ClockwiseUtil_4_4_6,zneg_CounterClockwiseUtil_4_4_6,zneg_InjectUtil_4_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_4_7, eject_xpos_ser_4_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_4_7, eject_xneg_ser_4_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_4_7, eject_ypos_ser_4_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_4_7, eject_yneg_ser_4_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_4_7, eject_zpos_ser_4_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_4_7, eject_zneg_ser_4_4_7;
	wire[7:0] xpos_ClockwiseUtil_4_4_7,xpos_CounterClockwiseUtil_4_4_7,xpos_InjectUtil_4_4_7;
	wire[7:0] xneg_ClockwiseUtil_4_4_7,xneg_CounterClockwiseUtil_4_4_7,xneg_InjectUtil_4_4_7;
	wire[7:0] ypos_ClockwiseUtil_4_4_7,ypos_CounterClockwiseUtil_4_4_7,ypos_InjectUtil_4_4_7;
	wire[7:0] yneg_ClockwiseUtil_4_4_7,yneg_CounterClockwiseUtil_4_4_7,yneg_InjectUtil_4_4_7;
	wire[7:0] zpos_ClockwiseUtil_4_4_7,zpos_CounterClockwiseUtil_4_4_7,zpos_InjectUtil_4_4_7;
	wire[7:0] zneg_ClockwiseUtil_4_4_7,zneg_CounterClockwiseUtil_4_4_7,zneg_InjectUtil_4_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_0, eject_xpos_ser_4_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_0, eject_xneg_ser_4_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_0, eject_ypos_ser_4_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_0, eject_yneg_ser_4_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_0, eject_zpos_ser_4_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_0, eject_zneg_ser_4_5_0;
	wire[7:0] xpos_ClockwiseUtil_4_5_0,xpos_CounterClockwiseUtil_4_5_0,xpos_InjectUtil_4_5_0;
	wire[7:0] xneg_ClockwiseUtil_4_5_0,xneg_CounterClockwiseUtil_4_5_0,xneg_InjectUtil_4_5_0;
	wire[7:0] ypos_ClockwiseUtil_4_5_0,ypos_CounterClockwiseUtil_4_5_0,ypos_InjectUtil_4_5_0;
	wire[7:0] yneg_ClockwiseUtil_4_5_0,yneg_CounterClockwiseUtil_4_5_0,yneg_InjectUtil_4_5_0;
	wire[7:0] zpos_ClockwiseUtil_4_5_0,zpos_CounterClockwiseUtil_4_5_0,zpos_InjectUtil_4_5_0;
	wire[7:0] zneg_ClockwiseUtil_4_5_0,zneg_CounterClockwiseUtil_4_5_0,zneg_InjectUtil_4_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_1, eject_xpos_ser_4_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_1, eject_xneg_ser_4_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_1, eject_ypos_ser_4_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_1, eject_yneg_ser_4_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_1, eject_zpos_ser_4_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_1, eject_zneg_ser_4_5_1;
	wire[7:0] xpos_ClockwiseUtil_4_5_1,xpos_CounterClockwiseUtil_4_5_1,xpos_InjectUtil_4_5_1;
	wire[7:0] xneg_ClockwiseUtil_4_5_1,xneg_CounterClockwiseUtil_4_5_1,xneg_InjectUtil_4_5_1;
	wire[7:0] ypos_ClockwiseUtil_4_5_1,ypos_CounterClockwiseUtil_4_5_1,ypos_InjectUtil_4_5_1;
	wire[7:0] yneg_ClockwiseUtil_4_5_1,yneg_CounterClockwiseUtil_4_5_1,yneg_InjectUtil_4_5_1;
	wire[7:0] zpos_ClockwiseUtil_4_5_1,zpos_CounterClockwiseUtil_4_5_1,zpos_InjectUtil_4_5_1;
	wire[7:0] zneg_ClockwiseUtil_4_5_1,zneg_CounterClockwiseUtil_4_5_1,zneg_InjectUtil_4_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_2, eject_xpos_ser_4_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_2, eject_xneg_ser_4_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_2, eject_ypos_ser_4_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_2, eject_yneg_ser_4_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_2, eject_zpos_ser_4_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_2, eject_zneg_ser_4_5_2;
	wire[7:0] xpos_ClockwiseUtil_4_5_2,xpos_CounterClockwiseUtil_4_5_2,xpos_InjectUtil_4_5_2;
	wire[7:0] xneg_ClockwiseUtil_4_5_2,xneg_CounterClockwiseUtil_4_5_2,xneg_InjectUtil_4_5_2;
	wire[7:0] ypos_ClockwiseUtil_4_5_2,ypos_CounterClockwiseUtil_4_5_2,ypos_InjectUtil_4_5_2;
	wire[7:0] yneg_ClockwiseUtil_4_5_2,yneg_CounterClockwiseUtil_4_5_2,yneg_InjectUtil_4_5_2;
	wire[7:0] zpos_ClockwiseUtil_4_5_2,zpos_CounterClockwiseUtil_4_5_2,zpos_InjectUtil_4_5_2;
	wire[7:0] zneg_ClockwiseUtil_4_5_2,zneg_CounterClockwiseUtil_4_5_2,zneg_InjectUtil_4_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_3, eject_xpos_ser_4_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_3, eject_xneg_ser_4_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_3, eject_ypos_ser_4_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_3, eject_yneg_ser_4_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_3, eject_zpos_ser_4_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_3, eject_zneg_ser_4_5_3;
	wire[7:0] xpos_ClockwiseUtil_4_5_3,xpos_CounterClockwiseUtil_4_5_3,xpos_InjectUtil_4_5_3;
	wire[7:0] xneg_ClockwiseUtil_4_5_3,xneg_CounterClockwiseUtil_4_5_3,xneg_InjectUtil_4_5_3;
	wire[7:0] ypos_ClockwiseUtil_4_5_3,ypos_CounterClockwiseUtil_4_5_3,ypos_InjectUtil_4_5_3;
	wire[7:0] yneg_ClockwiseUtil_4_5_3,yneg_CounterClockwiseUtil_4_5_3,yneg_InjectUtil_4_5_3;
	wire[7:0] zpos_ClockwiseUtil_4_5_3,zpos_CounterClockwiseUtil_4_5_3,zpos_InjectUtil_4_5_3;
	wire[7:0] zneg_ClockwiseUtil_4_5_3,zneg_CounterClockwiseUtil_4_5_3,zneg_InjectUtil_4_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_4, eject_xpos_ser_4_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_4, eject_xneg_ser_4_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_4, eject_ypos_ser_4_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_4, eject_yneg_ser_4_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_4, eject_zpos_ser_4_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_4, eject_zneg_ser_4_5_4;
	wire[7:0] xpos_ClockwiseUtil_4_5_4,xpos_CounterClockwiseUtil_4_5_4,xpos_InjectUtil_4_5_4;
	wire[7:0] xneg_ClockwiseUtil_4_5_4,xneg_CounterClockwiseUtil_4_5_4,xneg_InjectUtil_4_5_4;
	wire[7:0] ypos_ClockwiseUtil_4_5_4,ypos_CounterClockwiseUtil_4_5_4,ypos_InjectUtil_4_5_4;
	wire[7:0] yneg_ClockwiseUtil_4_5_4,yneg_CounterClockwiseUtil_4_5_4,yneg_InjectUtil_4_5_4;
	wire[7:0] zpos_ClockwiseUtil_4_5_4,zpos_CounterClockwiseUtil_4_5_4,zpos_InjectUtil_4_5_4;
	wire[7:0] zneg_ClockwiseUtil_4_5_4,zneg_CounterClockwiseUtil_4_5_4,zneg_InjectUtil_4_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_5, eject_xpos_ser_4_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_5, eject_xneg_ser_4_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_5, eject_ypos_ser_4_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_5, eject_yneg_ser_4_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_5, eject_zpos_ser_4_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_5, eject_zneg_ser_4_5_5;
	wire[7:0] xpos_ClockwiseUtil_4_5_5,xpos_CounterClockwiseUtil_4_5_5,xpos_InjectUtil_4_5_5;
	wire[7:0] xneg_ClockwiseUtil_4_5_5,xneg_CounterClockwiseUtil_4_5_5,xneg_InjectUtil_4_5_5;
	wire[7:0] ypos_ClockwiseUtil_4_5_5,ypos_CounterClockwiseUtil_4_5_5,ypos_InjectUtil_4_5_5;
	wire[7:0] yneg_ClockwiseUtil_4_5_5,yneg_CounterClockwiseUtil_4_5_5,yneg_InjectUtil_4_5_5;
	wire[7:0] zpos_ClockwiseUtil_4_5_5,zpos_CounterClockwiseUtil_4_5_5,zpos_InjectUtil_4_5_5;
	wire[7:0] zneg_ClockwiseUtil_4_5_5,zneg_CounterClockwiseUtil_4_5_5,zneg_InjectUtil_4_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_6, eject_xpos_ser_4_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_6, eject_xneg_ser_4_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_6, eject_ypos_ser_4_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_6, eject_yneg_ser_4_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_6, eject_zpos_ser_4_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_6, eject_zneg_ser_4_5_6;
	wire[7:0] xpos_ClockwiseUtil_4_5_6,xpos_CounterClockwiseUtil_4_5_6,xpos_InjectUtil_4_5_6;
	wire[7:0] xneg_ClockwiseUtil_4_5_6,xneg_CounterClockwiseUtil_4_5_6,xneg_InjectUtil_4_5_6;
	wire[7:0] ypos_ClockwiseUtil_4_5_6,ypos_CounterClockwiseUtil_4_5_6,ypos_InjectUtil_4_5_6;
	wire[7:0] yneg_ClockwiseUtil_4_5_6,yneg_CounterClockwiseUtil_4_5_6,yneg_InjectUtil_4_5_6;
	wire[7:0] zpos_ClockwiseUtil_4_5_6,zpos_CounterClockwiseUtil_4_5_6,zpos_InjectUtil_4_5_6;
	wire[7:0] zneg_ClockwiseUtil_4_5_6,zneg_CounterClockwiseUtil_4_5_6,zneg_InjectUtil_4_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_5_7, eject_xpos_ser_4_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_5_7, eject_xneg_ser_4_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_5_7, eject_ypos_ser_4_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_5_7, eject_yneg_ser_4_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_5_7, eject_zpos_ser_4_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_5_7, eject_zneg_ser_4_5_7;
	wire[7:0] xpos_ClockwiseUtil_4_5_7,xpos_CounterClockwiseUtil_4_5_7,xpos_InjectUtil_4_5_7;
	wire[7:0] xneg_ClockwiseUtil_4_5_7,xneg_CounterClockwiseUtil_4_5_7,xneg_InjectUtil_4_5_7;
	wire[7:0] ypos_ClockwiseUtil_4_5_7,ypos_CounterClockwiseUtil_4_5_7,ypos_InjectUtil_4_5_7;
	wire[7:0] yneg_ClockwiseUtil_4_5_7,yneg_CounterClockwiseUtil_4_5_7,yneg_InjectUtil_4_5_7;
	wire[7:0] zpos_ClockwiseUtil_4_5_7,zpos_CounterClockwiseUtil_4_5_7,zpos_InjectUtil_4_5_7;
	wire[7:0] zneg_ClockwiseUtil_4_5_7,zneg_CounterClockwiseUtil_4_5_7,zneg_InjectUtil_4_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_0, eject_xpos_ser_4_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_0, eject_xneg_ser_4_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_0, eject_ypos_ser_4_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_0, eject_yneg_ser_4_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_0, eject_zpos_ser_4_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_0, eject_zneg_ser_4_6_0;
	wire[7:0] xpos_ClockwiseUtil_4_6_0,xpos_CounterClockwiseUtil_4_6_0,xpos_InjectUtil_4_6_0;
	wire[7:0] xneg_ClockwiseUtil_4_6_0,xneg_CounterClockwiseUtil_4_6_0,xneg_InjectUtil_4_6_0;
	wire[7:0] ypos_ClockwiseUtil_4_6_0,ypos_CounterClockwiseUtil_4_6_0,ypos_InjectUtil_4_6_0;
	wire[7:0] yneg_ClockwiseUtil_4_6_0,yneg_CounterClockwiseUtil_4_6_0,yneg_InjectUtil_4_6_0;
	wire[7:0] zpos_ClockwiseUtil_4_6_0,zpos_CounterClockwiseUtil_4_6_0,zpos_InjectUtil_4_6_0;
	wire[7:0] zneg_ClockwiseUtil_4_6_0,zneg_CounterClockwiseUtil_4_6_0,zneg_InjectUtil_4_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_1, eject_xpos_ser_4_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_1, eject_xneg_ser_4_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_1, eject_ypos_ser_4_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_1, eject_yneg_ser_4_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_1, eject_zpos_ser_4_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_1, eject_zneg_ser_4_6_1;
	wire[7:0] xpos_ClockwiseUtil_4_6_1,xpos_CounterClockwiseUtil_4_6_1,xpos_InjectUtil_4_6_1;
	wire[7:0] xneg_ClockwiseUtil_4_6_1,xneg_CounterClockwiseUtil_4_6_1,xneg_InjectUtil_4_6_1;
	wire[7:0] ypos_ClockwiseUtil_4_6_1,ypos_CounterClockwiseUtil_4_6_1,ypos_InjectUtil_4_6_1;
	wire[7:0] yneg_ClockwiseUtil_4_6_1,yneg_CounterClockwiseUtil_4_6_1,yneg_InjectUtil_4_6_1;
	wire[7:0] zpos_ClockwiseUtil_4_6_1,zpos_CounterClockwiseUtil_4_6_1,zpos_InjectUtil_4_6_1;
	wire[7:0] zneg_ClockwiseUtil_4_6_1,zneg_CounterClockwiseUtil_4_6_1,zneg_InjectUtil_4_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_2, eject_xpos_ser_4_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_2, eject_xneg_ser_4_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_2, eject_ypos_ser_4_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_2, eject_yneg_ser_4_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_2, eject_zpos_ser_4_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_2, eject_zneg_ser_4_6_2;
	wire[7:0] xpos_ClockwiseUtil_4_6_2,xpos_CounterClockwiseUtil_4_6_2,xpos_InjectUtil_4_6_2;
	wire[7:0] xneg_ClockwiseUtil_4_6_2,xneg_CounterClockwiseUtil_4_6_2,xneg_InjectUtil_4_6_2;
	wire[7:0] ypos_ClockwiseUtil_4_6_2,ypos_CounterClockwiseUtil_4_6_2,ypos_InjectUtil_4_6_2;
	wire[7:0] yneg_ClockwiseUtil_4_6_2,yneg_CounterClockwiseUtil_4_6_2,yneg_InjectUtil_4_6_2;
	wire[7:0] zpos_ClockwiseUtil_4_6_2,zpos_CounterClockwiseUtil_4_6_2,zpos_InjectUtil_4_6_2;
	wire[7:0] zneg_ClockwiseUtil_4_6_2,zneg_CounterClockwiseUtil_4_6_2,zneg_InjectUtil_4_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_3, eject_xpos_ser_4_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_3, eject_xneg_ser_4_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_3, eject_ypos_ser_4_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_3, eject_yneg_ser_4_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_3, eject_zpos_ser_4_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_3, eject_zneg_ser_4_6_3;
	wire[7:0] xpos_ClockwiseUtil_4_6_3,xpos_CounterClockwiseUtil_4_6_3,xpos_InjectUtil_4_6_3;
	wire[7:0] xneg_ClockwiseUtil_4_6_3,xneg_CounterClockwiseUtil_4_6_3,xneg_InjectUtil_4_6_3;
	wire[7:0] ypos_ClockwiseUtil_4_6_3,ypos_CounterClockwiseUtil_4_6_3,ypos_InjectUtil_4_6_3;
	wire[7:0] yneg_ClockwiseUtil_4_6_3,yneg_CounterClockwiseUtil_4_6_3,yneg_InjectUtil_4_6_3;
	wire[7:0] zpos_ClockwiseUtil_4_6_3,zpos_CounterClockwiseUtil_4_6_3,zpos_InjectUtil_4_6_3;
	wire[7:0] zneg_ClockwiseUtil_4_6_3,zneg_CounterClockwiseUtil_4_6_3,zneg_InjectUtil_4_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_4, eject_xpos_ser_4_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_4, eject_xneg_ser_4_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_4, eject_ypos_ser_4_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_4, eject_yneg_ser_4_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_4, eject_zpos_ser_4_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_4, eject_zneg_ser_4_6_4;
	wire[7:0] xpos_ClockwiseUtil_4_6_4,xpos_CounterClockwiseUtil_4_6_4,xpos_InjectUtil_4_6_4;
	wire[7:0] xneg_ClockwiseUtil_4_6_4,xneg_CounterClockwiseUtil_4_6_4,xneg_InjectUtil_4_6_4;
	wire[7:0] ypos_ClockwiseUtil_4_6_4,ypos_CounterClockwiseUtil_4_6_4,ypos_InjectUtil_4_6_4;
	wire[7:0] yneg_ClockwiseUtil_4_6_4,yneg_CounterClockwiseUtil_4_6_4,yneg_InjectUtil_4_6_4;
	wire[7:0] zpos_ClockwiseUtil_4_6_4,zpos_CounterClockwiseUtil_4_6_4,zpos_InjectUtil_4_6_4;
	wire[7:0] zneg_ClockwiseUtil_4_6_4,zneg_CounterClockwiseUtil_4_6_4,zneg_InjectUtil_4_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_5, eject_xpos_ser_4_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_5, eject_xneg_ser_4_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_5, eject_ypos_ser_4_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_5, eject_yneg_ser_4_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_5, eject_zpos_ser_4_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_5, eject_zneg_ser_4_6_5;
	wire[7:0] xpos_ClockwiseUtil_4_6_5,xpos_CounterClockwiseUtil_4_6_5,xpos_InjectUtil_4_6_5;
	wire[7:0] xneg_ClockwiseUtil_4_6_5,xneg_CounterClockwiseUtil_4_6_5,xneg_InjectUtil_4_6_5;
	wire[7:0] ypos_ClockwiseUtil_4_6_5,ypos_CounterClockwiseUtil_4_6_5,ypos_InjectUtil_4_6_5;
	wire[7:0] yneg_ClockwiseUtil_4_6_5,yneg_CounterClockwiseUtil_4_6_5,yneg_InjectUtil_4_6_5;
	wire[7:0] zpos_ClockwiseUtil_4_6_5,zpos_CounterClockwiseUtil_4_6_5,zpos_InjectUtil_4_6_5;
	wire[7:0] zneg_ClockwiseUtil_4_6_5,zneg_CounterClockwiseUtil_4_6_5,zneg_InjectUtil_4_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_6, eject_xpos_ser_4_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_6, eject_xneg_ser_4_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_6, eject_ypos_ser_4_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_6, eject_yneg_ser_4_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_6, eject_zpos_ser_4_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_6, eject_zneg_ser_4_6_6;
	wire[7:0] xpos_ClockwiseUtil_4_6_6,xpos_CounterClockwiseUtil_4_6_6,xpos_InjectUtil_4_6_6;
	wire[7:0] xneg_ClockwiseUtil_4_6_6,xneg_CounterClockwiseUtil_4_6_6,xneg_InjectUtil_4_6_6;
	wire[7:0] ypos_ClockwiseUtil_4_6_6,ypos_CounterClockwiseUtil_4_6_6,ypos_InjectUtil_4_6_6;
	wire[7:0] yneg_ClockwiseUtil_4_6_6,yneg_CounterClockwiseUtil_4_6_6,yneg_InjectUtil_4_6_6;
	wire[7:0] zpos_ClockwiseUtil_4_6_6,zpos_CounterClockwiseUtil_4_6_6,zpos_InjectUtil_4_6_6;
	wire[7:0] zneg_ClockwiseUtil_4_6_6,zneg_CounterClockwiseUtil_4_6_6,zneg_InjectUtil_4_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_6_7, eject_xpos_ser_4_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_6_7, eject_xneg_ser_4_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_6_7, eject_ypos_ser_4_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_6_7, eject_yneg_ser_4_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_6_7, eject_zpos_ser_4_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_6_7, eject_zneg_ser_4_6_7;
	wire[7:0] xpos_ClockwiseUtil_4_6_7,xpos_CounterClockwiseUtil_4_6_7,xpos_InjectUtil_4_6_7;
	wire[7:0] xneg_ClockwiseUtil_4_6_7,xneg_CounterClockwiseUtil_4_6_7,xneg_InjectUtil_4_6_7;
	wire[7:0] ypos_ClockwiseUtil_4_6_7,ypos_CounterClockwiseUtil_4_6_7,ypos_InjectUtil_4_6_7;
	wire[7:0] yneg_ClockwiseUtil_4_6_7,yneg_CounterClockwiseUtil_4_6_7,yneg_InjectUtil_4_6_7;
	wire[7:0] zpos_ClockwiseUtil_4_6_7,zpos_CounterClockwiseUtil_4_6_7,zpos_InjectUtil_4_6_7;
	wire[7:0] zneg_ClockwiseUtil_4_6_7,zneg_CounterClockwiseUtil_4_6_7,zneg_InjectUtil_4_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_0, eject_xpos_ser_4_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_0, eject_xneg_ser_4_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_0, eject_ypos_ser_4_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_0, eject_yneg_ser_4_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_0, eject_zpos_ser_4_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_0, eject_zneg_ser_4_7_0;
	wire[7:0] xpos_ClockwiseUtil_4_7_0,xpos_CounterClockwiseUtil_4_7_0,xpos_InjectUtil_4_7_0;
	wire[7:0] xneg_ClockwiseUtil_4_7_0,xneg_CounterClockwiseUtil_4_7_0,xneg_InjectUtil_4_7_0;
	wire[7:0] ypos_ClockwiseUtil_4_7_0,ypos_CounterClockwiseUtil_4_7_0,ypos_InjectUtil_4_7_0;
	wire[7:0] yneg_ClockwiseUtil_4_7_0,yneg_CounterClockwiseUtil_4_7_0,yneg_InjectUtil_4_7_0;
	wire[7:0] zpos_ClockwiseUtil_4_7_0,zpos_CounterClockwiseUtil_4_7_0,zpos_InjectUtil_4_7_0;
	wire[7:0] zneg_ClockwiseUtil_4_7_0,zneg_CounterClockwiseUtil_4_7_0,zneg_InjectUtil_4_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_1, eject_xpos_ser_4_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_1, eject_xneg_ser_4_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_1, eject_ypos_ser_4_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_1, eject_yneg_ser_4_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_1, eject_zpos_ser_4_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_1, eject_zneg_ser_4_7_1;
	wire[7:0] xpos_ClockwiseUtil_4_7_1,xpos_CounterClockwiseUtil_4_7_1,xpos_InjectUtil_4_7_1;
	wire[7:0] xneg_ClockwiseUtil_4_7_1,xneg_CounterClockwiseUtil_4_7_1,xneg_InjectUtil_4_7_1;
	wire[7:0] ypos_ClockwiseUtil_4_7_1,ypos_CounterClockwiseUtil_4_7_1,ypos_InjectUtil_4_7_1;
	wire[7:0] yneg_ClockwiseUtil_4_7_1,yneg_CounterClockwiseUtil_4_7_1,yneg_InjectUtil_4_7_1;
	wire[7:0] zpos_ClockwiseUtil_4_7_1,zpos_CounterClockwiseUtil_4_7_1,zpos_InjectUtil_4_7_1;
	wire[7:0] zneg_ClockwiseUtil_4_7_1,zneg_CounterClockwiseUtil_4_7_1,zneg_InjectUtil_4_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_2, eject_xpos_ser_4_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_2, eject_xneg_ser_4_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_2, eject_ypos_ser_4_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_2, eject_yneg_ser_4_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_2, eject_zpos_ser_4_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_2, eject_zneg_ser_4_7_2;
	wire[7:0] xpos_ClockwiseUtil_4_7_2,xpos_CounterClockwiseUtil_4_7_2,xpos_InjectUtil_4_7_2;
	wire[7:0] xneg_ClockwiseUtil_4_7_2,xneg_CounterClockwiseUtil_4_7_2,xneg_InjectUtil_4_7_2;
	wire[7:0] ypos_ClockwiseUtil_4_7_2,ypos_CounterClockwiseUtil_4_7_2,ypos_InjectUtil_4_7_2;
	wire[7:0] yneg_ClockwiseUtil_4_7_2,yneg_CounterClockwiseUtil_4_7_2,yneg_InjectUtil_4_7_2;
	wire[7:0] zpos_ClockwiseUtil_4_7_2,zpos_CounterClockwiseUtil_4_7_2,zpos_InjectUtil_4_7_2;
	wire[7:0] zneg_ClockwiseUtil_4_7_2,zneg_CounterClockwiseUtil_4_7_2,zneg_InjectUtil_4_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_3, eject_xpos_ser_4_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_3, eject_xneg_ser_4_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_3, eject_ypos_ser_4_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_3, eject_yneg_ser_4_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_3, eject_zpos_ser_4_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_3, eject_zneg_ser_4_7_3;
	wire[7:0] xpos_ClockwiseUtil_4_7_3,xpos_CounterClockwiseUtil_4_7_3,xpos_InjectUtil_4_7_3;
	wire[7:0] xneg_ClockwiseUtil_4_7_3,xneg_CounterClockwiseUtil_4_7_3,xneg_InjectUtil_4_7_3;
	wire[7:0] ypos_ClockwiseUtil_4_7_3,ypos_CounterClockwiseUtil_4_7_3,ypos_InjectUtil_4_7_3;
	wire[7:0] yneg_ClockwiseUtil_4_7_3,yneg_CounterClockwiseUtil_4_7_3,yneg_InjectUtil_4_7_3;
	wire[7:0] zpos_ClockwiseUtil_4_7_3,zpos_CounterClockwiseUtil_4_7_3,zpos_InjectUtil_4_7_3;
	wire[7:0] zneg_ClockwiseUtil_4_7_3,zneg_CounterClockwiseUtil_4_7_3,zneg_InjectUtil_4_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_4, eject_xpos_ser_4_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_4, eject_xneg_ser_4_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_4, eject_ypos_ser_4_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_4, eject_yneg_ser_4_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_4, eject_zpos_ser_4_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_4, eject_zneg_ser_4_7_4;
	wire[7:0] xpos_ClockwiseUtil_4_7_4,xpos_CounterClockwiseUtil_4_7_4,xpos_InjectUtil_4_7_4;
	wire[7:0] xneg_ClockwiseUtil_4_7_4,xneg_CounterClockwiseUtil_4_7_4,xneg_InjectUtil_4_7_4;
	wire[7:0] ypos_ClockwiseUtil_4_7_4,ypos_CounterClockwiseUtil_4_7_4,ypos_InjectUtil_4_7_4;
	wire[7:0] yneg_ClockwiseUtil_4_7_4,yneg_CounterClockwiseUtil_4_7_4,yneg_InjectUtil_4_7_4;
	wire[7:0] zpos_ClockwiseUtil_4_7_4,zpos_CounterClockwiseUtil_4_7_4,zpos_InjectUtil_4_7_4;
	wire[7:0] zneg_ClockwiseUtil_4_7_4,zneg_CounterClockwiseUtil_4_7_4,zneg_InjectUtil_4_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_5, eject_xpos_ser_4_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_5, eject_xneg_ser_4_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_5, eject_ypos_ser_4_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_5, eject_yneg_ser_4_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_5, eject_zpos_ser_4_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_5, eject_zneg_ser_4_7_5;
	wire[7:0] xpos_ClockwiseUtil_4_7_5,xpos_CounterClockwiseUtil_4_7_5,xpos_InjectUtil_4_7_5;
	wire[7:0] xneg_ClockwiseUtil_4_7_5,xneg_CounterClockwiseUtil_4_7_5,xneg_InjectUtil_4_7_5;
	wire[7:0] ypos_ClockwiseUtil_4_7_5,ypos_CounterClockwiseUtil_4_7_5,ypos_InjectUtil_4_7_5;
	wire[7:0] yneg_ClockwiseUtil_4_7_5,yneg_CounterClockwiseUtil_4_7_5,yneg_InjectUtil_4_7_5;
	wire[7:0] zpos_ClockwiseUtil_4_7_5,zpos_CounterClockwiseUtil_4_7_5,zpos_InjectUtil_4_7_5;
	wire[7:0] zneg_ClockwiseUtil_4_7_5,zneg_CounterClockwiseUtil_4_7_5,zneg_InjectUtil_4_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_6, eject_xpos_ser_4_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_6, eject_xneg_ser_4_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_6, eject_ypos_ser_4_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_6, eject_yneg_ser_4_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_6, eject_zpos_ser_4_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_6, eject_zneg_ser_4_7_6;
	wire[7:0] xpos_ClockwiseUtil_4_7_6,xpos_CounterClockwiseUtil_4_7_6,xpos_InjectUtil_4_7_6;
	wire[7:0] xneg_ClockwiseUtil_4_7_6,xneg_CounterClockwiseUtil_4_7_6,xneg_InjectUtil_4_7_6;
	wire[7:0] ypos_ClockwiseUtil_4_7_6,ypos_CounterClockwiseUtil_4_7_6,ypos_InjectUtil_4_7_6;
	wire[7:0] yneg_ClockwiseUtil_4_7_6,yneg_CounterClockwiseUtil_4_7_6,yneg_InjectUtil_4_7_6;
	wire[7:0] zpos_ClockwiseUtil_4_7_6,zpos_CounterClockwiseUtil_4_7_6,zpos_InjectUtil_4_7_6;
	wire[7:0] zneg_ClockwiseUtil_4_7_6,zneg_CounterClockwiseUtil_4_7_6,zneg_InjectUtil_4_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_4_7_7, eject_xpos_ser_4_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_4_7_7, eject_xneg_ser_4_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_4_7_7, eject_ypos_ser_4_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_4_7_7, eject_yneg_ser_4_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_4_7_7, eject_zpos_ser_4_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_4_7_7, eject_zneg_ser_4_7_7;
	wire[7:0] xpos_ClockwiseUtil_4_7_7,xpos_CounterClockwiseUtil_4_7_7,xpos_InjectUtil_4_7_7;
	wire[7:0] xneg_ClockwiseUtil_4_7_7,xneg_CounterClockwiseUtil_4_7_7,xneg_InjectUtil_4_7_7;
	wire[7:0] ypos_ClockwiseUtil_4_7_7,ypos_CounterClockwiseUtil_4_7_7,ypos_InjectUtil_4_7_7;
	wire[7:0] yneg_ClockwiseUtil_4_7_7,yneg_CounterClockwiseUtil_4_7_7,yneg_InjectUtil_4_7_7;
	wire[7:0] zpos_ClockwiseUtil_4_7_7,zpos_CounterClockwiseUtil_4_7_7,zpos_InjectUtil_4_7_7;
	wire[7:0] zneg_ClockwiseUtil_4_7_7,zneg_CounterClockwiseUtil_4_7_7,zneg_InjectUtil_4_7_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_0, eject_xpos_ser_5_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_0, eject_xneg_ser_5_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_0, eject_ypos_ser_5_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_0, eject_yneg_ser_5_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_0, eject_zpos_ser_5_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_0, eject_zneg_ser_5_0_0;
	wire[7:0] xpos_ClockwiseUtil_5_0_0,xpos_CounterClockwiseUtil_5_0_0,xpos_InjectUtil_5_0_0;
	wire[7:0] xneg_ClockwiseUtil_5_0_0,xneg_CounterClockwiseUtil_5_0_0,xneg_InjectUtil_5_0_0;
	wire[7:0] ypos_ClockwiseUtil_5_0_0,ypos_CounterClockwiseUtil_5_0_0,ypos_InjectUtil_5_0_0;
	wire[7:0] yneg_ClockwiseUtil_5_0_0,yneg_CounterClockwiseUtil_5_0_0,yneg_InjectUtil_5_0_0;
	wire[7:0] zpos_ClockwiseUtil_5_0_0,zpos_CounterClockwiseUtil_5_0_0,zpos_InjectUtil_5_0_0;
	wire[7:0] zneg_ClockwiseUtil_5_0_0,zneg_CounterClockwiseUtil_5_0_0,zneg_InjectUtil_5_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_1, eject_xpos_ser_5_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_1, eject_xneg_ser_5_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_1, eject_ypos_ser_5_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_1, eject_yneg_ser_5_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_1, eject_zpos_ser_5_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_1, eject_zneg_ser_5_0_1;
	wire[7:0] xpos_ClockwiseUtil_5_0_1,xpos_CounterClockwiseUtil_5_0_1,xpos_InjectUtil_5_0_1;
	wire[7:0] xneg_ClockwiseUtil_5_0_1,xneg_CounterClockwiseUtil_5_0_1,xneg_InjectUtil_5_0_1;
	wire[7:0] ypos_ClockwiseUtil_5_0_1,ypos_CounterClockwiseUtil_5_0_1,ypos_InjectUtil_5_0_1;
	wire[7:0] yneg_ClockwiseUtil_5_0_1,yneg_CounterClockwiseUtil_5_0_1,yneg_InjectUtil_5_0_1;
	wire[7:0] zpos_ClockwiseUtil_5_0_1,zpos_CounterClockwiseUtil_5_0_1,zpos_InjectUtil_5_0_1;
	wire[7:0] zneg_ClockwiseUtil_5_0_1,zneg_CounterClockwiseUtil_5_0_1,zneg_InjectUtil_5_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_2, eject_xpos_ser_5_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_2, eject_xneg_ser_5_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_2, eject_ypos_ser_5_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_2, eject_yneg_ser_5_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_2, eject_zpos_ser_5_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_2, eject_zneg_ser_5_0_2;
	wire[7:0] xpos_ClockwiseUtil_5_0_2,xpos_CounterClockwiseUtil_5_0_2,xpos_InjectUtil_5_0_2;
	wire[7:0] xneg_ClockwiseUtil_5_0_2,xneg_CounterClockwiseUtil_5_0_2,xneg_InjectUtil_5_0_2;
	wire[7:0] ypos_ClockwiseUtil_5_0_2,ypos_CounterClockwiseUtil_5_0_2,ypos_InjectUtil_5_0_2;
	wire[7:0] yneg_ClockwiseUtil_5_0_2,yneg_CounterClockwiseUtil_5_0_2,yneg_InjectUtil_5_0_2;
	wire[7:0] zpos_ClockwiseUtil_5_0_2,zpos_CounterClockwiseUtil_5_0_2,zpos_InjectUtil_5_0_2;
	wire[7:0] zneg_ClockwiseUtil_5_0_2,zneg_CounterClockwiseUtil_5_0_2,zneg_InjectUtil_5_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_3, eject_xpos_ser_5_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_3, eject_xneg_ser_5_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_3, eject_ypos_ser_5_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_3, eject_yneg_ser_5_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_3, eject_zpos_ser_5_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_3, eject_zneg_ser_5_0_3;
	wire[7:0] xpos_ClockwiseUtil_5_0_3,xpos_CounterClockwiseUtil_5_0_3,xpos_InjectUtil_5_0_3;
	wire[7:0] xneg_ClockwiseUtil_5_0_3,xneg_CounterClockwiseUtil_5_0_3,xneg_InjectUtil_5_0_3;
	wire[7:0] ypos_ClockwiseUtil_5_0_3,ypos_CounterClockwiseUtil_5_0_3,ypos_InjectUtil_5_0_3;
	wire[7:0] yneg_ClockwiseUtil_5_0_3,yneg_CounterClockwiseUtil_5_0_3,yneg_InjectUtil_5_0_3;
	wire[7:0] zpos_ClockwiseUtil_5_0_3,zpos_CounterClockwiseUtil_5_0_3,zpos_InjectUtil_5_0_3;
	wire[7:0] zneg_ClockwiseUtil_5_0_3,zneg_CounterClockwiseUtil_5_0_3,zneg_InjectUtil_5_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_4, eject_xpos_ser_5_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_4, eject_xneg_ser_5_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_4, eject_ypos_ser_5_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_4, eject_yneg_ser_5_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_4, eject_zpos_ser_5_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_4, eject_zneg_ser_5_0_4;
	wire[7:0] xpos_ClockwiseUtil_5_0_4,xpos_CounterClockwiseUtil_5_0_4,xpos_InjectUtil_5_0_4;
	wire[7:0] xneg_ClockwiseUtil_5_0_4,xneg_CounterClockwiseUtil_5_0_4,xneg_InjectUtil_5_0_4;
	wire[7:0] ypos_ClockwiseUtil_5_0_4,ypos_CounterClockwiseUtil_5_0_4,ypos_InjectUtil_5_0_4;
	wire[7:0] yneg_ClockwiseUtil_5_0_4,yneg_CounterClockwiseUtil_5_0_4,yneg_InjectUtil_5_0_4;
	wire[7:0] zpos_ClockwiseUtil_5_0_4,zpos_CounterClockwiseUtil_5_0_4,zpos_InjectUtil_5_0_4;
	wire[7:0] zneg_ClockwiseUtil_5_0_4,zneg_CounterClockwiseUtil_5_0_4,zneg_InjectUtil_5_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_5, eject_xpos_ser_5_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_5, eject_xneg_ser_5_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_5, eject_ypos_ser_5_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_5, eject_yneg_ser_5_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_5, eject_zpos_ser_5_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_5, eject_zneg_ser_5_0_5;
	wire[7:0] xpos_ClockwiseUtil_5_0_5,xpos_CounterClockwiseUtil_5_0_5,xpos_InjectUtil_5_0_5;
	wire[7:0] xneg_ClockwiseUtil_5_0_5,xneg_CounterClockwiseUtil_5_0_5,xneg_InjectUtil_5_0_5;
	wire[7:0] ypos_ClockwiseUtil_5_0_5,ypos_CounterClockwiseUtil_5_0_5,ypos_InjectUtil_5_0_5;
	wire[7:0] yneg_ClockwiseUtil_5_0_5,yneg_CounterClockwiseUtil_5_0_5,yneg_InjectUtil_5_0_5;
	wire[7:0] zpos_ClockwiseUtil_5_0_5,zpos_CounterClockwiseUtil_5_0_5,zpos_InjectUtil_5_0_5;
	wire[7:0] zneg_ClockwiseUtil_5_0_5,zneg_CounterClockwiseUtil_5_0_5,zneg_InjectUtil_5_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_6, eject_xpos_ser_5_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_6, eject_xneg_ser_5_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_6, eject_ypos_ser_5_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_6, eject_yneg_ser_5_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_6, eject_zpos_ser_5_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_6, eject_zneg_ser_5_0_6;
	wire[7:0] xpos_ClockwiseUtil_5_0_6,xpos_CounterClockwiseUtil_5_0_6,xpos_InjectUtil_5_0_6;
	wire[7:0] xneg_ClockwiseUtil_5_0_6,xneg_CounterClockwiseUtil_5_0_6,xneg_InjectUtil_5_0_6;
	wire[7:0] ypos_ClockwiseUtil_5_0_6,ypos_CounterClockwiseUtil_5_0_6,ypos_InjectUtil_5_0_6;
	wire[7:0] yneg_ClockwiseUtil_5_0_6,yneg_CounterClockwiseUtil_5_0_6,yneg_InjectUtil_5_0_6;
	wire[7:0] zpos_ClockwiseUtil_5_0_6,zpos_CounterClockwiseUtil_5_0_6,zpos_InjectUtil_5_0_6;
	wire[7:0] zneg_ClockwiseUtil_5_0_6,zneg_CounterClockwiseUtil_5_0_6,zneg_InjectUtil_5_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_0_7, eject_xpos_ser_5_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_0_7, eject_xneg_ser_5_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_0_7, eject_ypos_ser_5_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_0_7, eject_yneg_ser_5_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_0_7, eject_zpos_ser_5_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_0_7, eject_zneg_ser_5_0_7;
	wire[7:0] xpos_ClockwiseUtil_5_0_7,xpos_CounterClockwiseUtil_5_0_7,xpos_InjectUtil_5_0_7;
	wire[7:0] xneg_ClockwiseUtil_5_0_7,xneg_CounterClockwiseUtil_5_0_7,xneg_InjectUtil_5_0_7;
	wire[7:0] ypos_ClockwiseUtil_5_0_7,ypos_CounterClockwiseUtil_5_0_7,ypos_InjectUtil_5_0_7;
	wire[7:0] yneg_ClockwiseUtil_5_0_7,yneg_CounterClockwiseUtil_5_0_7,yneg_InjectUtil_5_0_7;
	wire[7:0] zpos_ClockwiseUtil_5_0_7,zpos_CounterClockwiseUtil_5_0_7,zpos_InjectUtil_5_0_7;
	wire[7:0] zneg_ClockwiseUtil_5_0_7,zneg_CounterClockwiseUtil_5_0_7,zneg_InjectUtil_5_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_0, eject_xpos_ser_5_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_0, eject_xneg_ser_5_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_0, eject_ypos_ser_5_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_0, eject_yneg_ser_5_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_0, eject_zpos_ser_5_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_0, eject_zneg_ser_5_1_0;
	wire[7:0] xpos_ClockwiseUtil_5_1_0,xpos_CounterClockwiseUtil_5_1_0,xpos_InjectUtil_5_1_0;
	wire[7:0] xneg_ClockwiseUtil_5_1_0,xneg_CounterClockwiseUtil_5_1_0,xneg_InjectUtil_5_1_0;
	wire[7:0] ypos_ClockwiseUtil_5_1_0,ypos_CounterClockwiseUtil_5_1_0,ypos_InjectUtil_5_1_0;
	wire[7:0] yneg_ClockwiseUtil_5_1_0,yneg_CounterClockwiseUtil_5_1_0,yneg_InjectUtil_5_1_0;
	wire[7:0] zpos_ClockwiseUtil_5_1_0,zpos_CounterClockwiseUtil_5_1_0,zpos_InjectUtil_5_1_0;
	wire[7:0] zneg_ClockwiseUtil_5_1_0,zneg_CounterClockwiseUtil_5_1_0,zneg_InjectUtil_5_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_1, eject_xpos_ser_5_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_1, eject_xneg_ser_5_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_1, eject_ypos_ser_5_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_1, eject_yneg_ser_5_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_1, eject_zpos_ser_5_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_1, eject_zneg_ser_5_1_1;
	wire[7:0] xpos_ClockwiseUtil_5_1_1,xpos_CounterClockwiseUtil_5_1_1,xpos_InjectUtil_5_1_1;
	wire[7:0] xneg_ClockwiseUtil_5_1_1,xneg_CounterClockwiseUtil_5_1_1,xneg_InjectUtil_5_1_1;
	wire[7:0] ypos_ClockwiseUtil_5_1_1,ypos_CounterClockwiseUtil_5_1_1,ypos_InjectUtil_5_1_1;
	wire[7:0] yneg_ClockwiseUtil_5_1_1,yneg_CounterClockwiseUtil_5_1_1,yneg_InjectUtil_5_1_1;
	wire[7:0] zpos_ClockwiseUtil_5_1_1,zpos_CounterClockwiseUtil_5_1_1,zpos_InjectUtil_5_1_1;
	wire[7:0] zneg_ClockwiseUtil_5_1_1,zneg_CounterClockwiseUtil_5_1_1,zneg_InjectUtil_5_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_2, eject_xpos_ser_5_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_2, eject_xneg_ser_5_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_2, eject_ypos_ser_5_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_2, eject_yneg_ser_5_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_2, eject_zpos_ser_5_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_2, eject_zneg_ser_5_1_2;
	wire[7:0] xpos_ClockwiseUtil_5_1_2,xpos_CounterClockwiseUtil_5_1_2,xpos_InjectUtil_5_1_2;
	wire[7:0] xneg_ClockwiseUtil_5_1_2,xneg_CounterClockwiseUtil_5_1_2,xneg_InjectUtil_5_1_2;
	wire[7:0] ypos_ClockwiseUtil_5_1_2,ypos_CounterClockwiseUtil_5_1_2,ypos_InjectUtil_5_1_2;
	wire[7:0] yneg_ClockwiseUtil_5_1_2,yneg_CounterClockwiseUtil_5_1_2,yneg_InjectUtil_5_1_2;
	wire[7:0] zpos_ClockwiseUtil_5_1_2,zpos_CounterClockwiseUtil_5_1_2,zpos_InjectUtil_5_1_2;
	wire[7:0] zneg_ClockwiseUtil_5_1_2,zneg_CounterClockwiseUtil_5_1_2,zneg_InjectUtil_5_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_3, eject_xpos_ser_5_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_3, eject_xneg_ser_5_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_3, eject_ypos_ser_5_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_3, eject_yneg_ser_5_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_3, eject_zpos_ser_5_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_3, eject_zneg_ser_5_1_3;
	wire[7:0] xpos_ClockwiseUtil_5_1_3,xpos_CounterClockwiseUtil_5_1_3,xpos_InjectUtil_5_1_3;
	wire[7:0] xneg_ClockwiseUtil_5_1_3,xneg_CounterClockwiseUtil_5_1_3,xneg_InjectUtil_5_1_3;
	wire[7:0] ypos_ClockwiseUtil_5_1_3,ypos_CounterClockwiseUtil_5_1_3,ypos_InjectUtil_5_1_3;
	wire[7:0] yneg_ClockwiseUtil_5_1_3,yneg_CounterClockwiseUtil_5_1_3,yneg_InjectUtil_5_1_3;
	wire[7:0] zpos_ClockwiseUtil_5_1_3,zpos_CounterClockwiseUtil_5_1_3,zpos_InjectUtil_5_1_3;
	wire[7:0] zneg_ClockwiseUtil_5_1_3,zneg_CounterClockwiseUtil_5_1_3,zneg_InjectUtil_5_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_4, eject_xpos_ser_5_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_4, eject_xneg_ser_5_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_4, eject_ypos_ser_5_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_4, eject_yneg_ser_5_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_4, eject_zpos_ser_5_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_4, eject_zneg_ser_5_1_4;
	wire[7:0] xpos_ClockwiseUtil_5_1_4,xpos_CounterClockwiseUtil_5_1_4,xpos_InjectUtil_5_1_4;
	wire[7:0] xneg_ClockwiseUtil_5_1_4,xneg_CounterClockwiseUtil_5_1_4,xneg_InjectUtil_5_1_4;
	wire[7:0] ypos_ClockwiseUtil_5_1_4,ypos_CounterClockwiseUtil_5_1_4,ypos_InjectUtil_5_1_4;
	wire[7:0] yneg_ClockwiseUtil_5_1_4,yneg_CounterClockwiseUtil_5_1_4,yneg_InjectUtil_5_1_4;
	wire[7:0] zpos_ClockwiseUtil_5_1_4,zpos_CounterClockwiseUtil_5_1_4,zpos_InjectUtil_5_1_4;
	wire[7:0] zneg_ClockwiseUtil_5_1_4,zneg_CounterClockwiseUtil_5_1_4,zneg_InjectUtil_5_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_5, eject_xpos_ser_5_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_5, eject_xneg_ser_5_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_5, eject_ypos_ser_5_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_5, eject_yneg_ser_5_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_5, eject_zpos_ser_5_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_5, eject_zneg_ser_5_1_5;
	wire[7:0] xpos_ClockwiseUtil_5_1_5,xpos_CounterClockwiseUtil_5_1_5,xpos_InjectUtil_5_1_5;
	wire[7:0] xneg_ClockwiseUtil_5_1_5,xneg_CounterClockwiseUtil_5_1_5,xneg_InjectUtil_5_1_5;
	wire[7:0] ypos_ClockwiseUtil_5_1_5,ypos_CounterClockwiseUtil_5_1_5,ypos_InjectUtil_5_1_5;
	wire[7:0] yneg_ClockwiseUtil_5_1_5,yneg_CounterClockwiseUtil_5_1_5,yneg_InjectUtil_5_1_5;
	wire[7:0] zpos_ClockwiseUtil_5_1_5,zpos_CounterClockwiseUtil_5_1_5,zpos_InjectUtil_5_1_5;
	wire[7:0] zneg_ClockwiseUtil_5_1_5,zneg_CounterClockwiseUtil_5_1_5,zneg_InjectUtil_5_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_6, eject_xpos_ser_5_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_6, eject_xneg_ser_5_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_6, eject_ypos_ser_5_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_6, eject_yneg_ser_5_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_6, eject_zpos_ser_5_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_6, eject_zneg_ser_5_1_6;
	wire[7:0] xpos_ClockwiseUtil_5_1_6,xpos_CounterClockwiseUtil_5_1_6,xpos_InjectUtil_5_1_6;
	wire[7:0] xneg_ClockwiseUtil_5_1_6,xneg_CounterClockwiseUtil_5_1_6,xneg_InjectUtil_5_1_6;
	wire[7:0] ypos_ClockwiseUtil_5_1_6,ypos_CounterClockwiseUtil_5_1_6,ypos_InjectUtil_5_1_6;
	wire[7:0] yneg_ClockwiseUtil_5_1_6,yneg_CounterClockwiseUtil_5_1_6,yneg_InjectUtil_5_1_6;
	wire[7:0] zpos_ClockwiseUtil_5_1_6,zpos_CounterClockwiseUtil_5_1_6,zpos_InjectUtil_5_1_6;
	wire[7:0] zneg_ClockwiseUtil_5_1_6,zneg_CounterClockwiseUtil_5_1_6,zneg_InjectUtil_5_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_1_7, eject_xpos_ser_5_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_1_7, eject_xneg_ser_5_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_1_7, eject_ypos_ser_5_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_1_7, eject_yneg_ser_5_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_1_7, eject_zpos_ser_5_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_1_7, eject_zneg_ser_5_1_7;
	wire[7:0] xpos_ClockwiseUtil_5_1_7,xpos_CounterClockwiseUtil_5_1_7,xpos_InjectUtil_5_1_7;
	wire[7:0] xneg_ClockwiseUtil_5_1_7,xneg_CounterClockwiseUtil_5_1_7,xneg_InjectUtil_5_1_7;
	wire[7:0] ypos_ClockwiseUtil_5_1_7,ypos_CounterClockwiseUtil_5_1_7,ypos_InjectUtil_5_1_7;
	wire[7:0] yneg_ClockwiseUtil_5_1_7,yneg_CounterClockwiseUtil_5_1_7,yneg_InjectUtil_5_1_7;
	wire[7:0] zpos_ClockwiseUtil_5_1_7,zpos_CounterClockwiseUtil_5_1_7,zpos_InjectUtil_5_1_7;
	wire[7:0] zneg_ClockwiseUtil_5_1_7,zneg_CounterClockwiseUtil_5_1_7,zneg_InjectUtil_5_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_0, eject_xpos_ser_5_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_0, eject_xneg_ser_5_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_0, eject_ypos_ser_5_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_0, eject_yneg_ser_5_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_0, eject_zpos_ser_5_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_0, eject_zneg_ser_5_2_0;
	wire[7:0] xpos_ClockwiseUtil_5_2_0,xpos_CounterClockwiseUtil_5_2_0,xpos_InjectUtil_5_2_0;
	wire[7:0] xneg_ClockwiseUtil_5_2_0,xneg_CounterClockwiseUtil_5_2_0,xneg_InjectUtil_5_2_0;
	wire[7:0] ypos_ClockwiseUtil_5_2_0,ypos_CounterClockwiseUtil_5_2_0,ypos_InjectUtil_5_2_0;
	wire[7:0] yneg_ClockwiseUtil_5_2_0,yneg_CounterClockwiseUtil_5_2_0,yneg_InjectUtil_5_2_0;
	wire[7:0] zpos_ClockwiseUtil_5_2_0,zpos_CounterClockwiseUtil_5_2_0,zpos_InjectUtil_5_2_0;
	wire[7:0] zneg_ClockwiseUtil_5_2_0,zneg_CounterClockwiseUtil_5_2_0,zneg_InjectUtil_5_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_1, eject_xpos_ser_5_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_1, eject_xneg_ser_5_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_1, eject_ypos_ser_5_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_1, eject_yneg_ser_5_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_1, eject_zpos_ser_5_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_1, eject_zneg_ser_5_2_1;
	wire[7:0] xpos_ClockwiseUtil_5_2_1,xpos_CounterClockwiseUtil_5_2_1,xpos_InjectUtil_5_2_1;
	wire[7:0] xneg_ClockwiseUtil_5_2_1,xneg_CounterClockwiseUtil_5_2_1,xneg_InjectUtil_5_2_1;
	wire[7:0] ypos_ClockwiseUtil_5_2_1,ypos_CounterClockwiseUtil_5_2_1,ypos_InjectUtil_5_2_1;
	wire[7:0] yneg_ClockwiseUtil_5_2_1,yneg_CounterClockwiseUtil_5_2_1,yneg_InjectUtil_5_2_1;
	wire[7:0] zpos_ClockwiseUtil_5_2_1,zpos_CounterClockwiseUtil_5_2_1,zpos_InjectUtil_5_2_1;
	wire[7:0] zneg_ClockwiseUtil_5_2_1,zneg_CounterClockwiseUtil_5_2_1,zneg_InjectUtil_5_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_2, eject_xpos_ser_5_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_2, eject_xneg_ser_5_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_2, eject_ypos_ser_5_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_2, eject_yneg_ser_5_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_2, eject_zpos_ser_5_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_2, eject_zneg_ser_5_2_2;
	wire[7:0] xpos_ClockwiseUtil_5_2_2,xpos_CounterClockwiseUtil_5_2_2,xpos_InjectUtil_5_2_2;
	wire[7:0] xneg_ClockwiseUtil_5_2_2,xneg_CounterClockwiseUtil_5_2_2,xneg_InjectUtil_5_2_2;
	wire[7:0] ypos_ClockwiseUtil_5_2_2,ypos_CounterClockwiseUtil_5_2_2,ypos_InjectUtil_5_2_2;
	wire[7:0] yneg_ClockwiseUtil_5_2_2,yneg_CounterClockwiseUtil_5_2_2,yneg_InjectUtil_5_2_2;
	wire[7:0] zpos_ClockwiseUtil_5_2_2,zpos_CounterClockwiseUtil_5_2_2,zpos_InjectUtil_5_2_2;
	wire[7:0] zneg_ClockwiseUtil_5_2_2,zneg_CounterClockwiseUtil_5_2_2,zneg_InjectUtil_5_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_3, eject_xpos_ser_5_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_3, eject_xneg_ser_5_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_3, eject_ypos_ser_5_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_3, eject_yneg_ser_5_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_3, eject_zpos_ser_5_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_3, eject_zneg_ser_5_2_3;
	wire[7:0] xpos_ClockwiseUtil_5_2_3,xpos_CounterClockwiseUtil_5_2_3,xpos_InjectUtil_5_2_3;
	wire[7:0] xneg_ClockwiseUtil_5_2_3,xneg_CounterClockwiseUtil_5_2_3,xneg_InjectUtil_5_2_3;
	wire[7:0] ypos_ClockwiseUtil_5_2_3,ypos_CounterClockwiseUtil_5_2_3,ypos_InjectUtil_5_2_3;
	wire[7:0] yneg_ClockwiseUtil_5_2_3,yneg_CounterClockwiseUtil_5_2_3,yneg_InjectUtil_5_2_3;
	wire[7:0] zpos_ClockwiseUtil_5_2_3,zpos_CounterClockwiseUtil_5_2_3,zpos_InjectUtil_5_2_3;
	wire[7:0] zneg_ClockwiseUtil_5_2_3,zneg_CounterClockwiseUtil_5_2_3,zneg_InjectUtil_5_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_4, eject_xpos_ser_5_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_4, eject_xneg_ser_5_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_4, eject_ypos_ser_5_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_4, eject_yneg_ser_5_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_4, eject_zpos_ser_5_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_4, eject_zneg_ser_5_2_4;
	wire[7:0] xpos_ClockwiseUtil_5_2_4,xpos_CounterClockwiseUtil_5_2_4,xpos_InjectUtil_5_2_4;
	wire[7:0] xneg_ClockwiseUtil_5_2_4,xneg_CounterClockwiseUtil_5_2_4,xneg_InjectUtil_5_2_4;
	wire[7:0] ypos_ClockwiseUtil_5_2_4,ypos_CounterClockwiseUtil_5_2_4,ypos_InjectUtil_5_2_4;
	wire[7:0] yneg_ClockwiseUtil_5_2_4,yneg_CounterClockwiseUtil_5_2_4,yneg_InjectUtil_5_2_4;
	wire[7:0] zpos_ClockwiseUtil_5_2_4,zpos_CounterClockwiseUtil_5_2_4,zpos_InjectUtil_5_2_4;
	wire[7:0] zneg_ClockwiseUtil_5_2_4,zneg_CounterClockwiseUtil_5_2_4,zneg_InjectUtil_5_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_5, eject_xpos_ser_5_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_5, eject_xneg_ser_5_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_5, eject_ypos_ser_5_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_5, eject_yneg_ser_5_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_5, eject_zpos_ser_5_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_5, eject_zneg_ser_5_2_5;
	wire[7:0] xpos_ClockwiseUtil_5_2_5,xpos_CounterClockwiseUtil_5_2_5,xpos_InjectUtil_5_2_5;
	wire[7:0] xneg_ClockwiseUtil_5_2_5,xneg_CounterClockwiseUtil_5_2_5,xneg_InjectUtil_5_2_5;
	wire[7:0] ypos_ClockwiseUtil_5_2_5,ypos_CounterClockwiseUtil_5_2_5,ypos_InjectUtil_5_2_5;
	wire[7:0] yneg_ClockwiseUtil_5_2_5,yneg_CounterClockwiseUtil_5_2_5,yneg_InjectUtil_5_2_5;
	wire[7:0] zpos_ClockwiseUtil_5_2_5,zpos_CounterClockwiseUtil_5_2_5,zpos_InjectUtil_5_2_5;
	wire[7:0] zneg_ClockwiseUtil_5_2_5,zneg_CounterClockwiseUtil_5_2_5,zneg_InjectUtil_5_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_6, eject_xpos_ser_5_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_6, eject_xneg_ser_5_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_6, eject_ypos_ser_5_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_6, eject_yneg_ser_5_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_6, eject_zpos_ser_5_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_6, eject_zneg_ser_5_2_6;
	wire[7:0] xpos_ClockwiseUtil_5_2_6,xpos_CounterClockwiseUtil_5_2_6,xpos_InjectUtil_5_2_6;
	wire[7:0] xneg_ClockwiseUtil_5_2_6,xneg_CounterClockwiseUtil_5_2_6,xneg_InjectUtil_5_2_6;
	wire[7:0] ypos_ClockwiseUtil_5_2_6,ypos_CounterClockwiseUtil_5_2_6,ypos_InjectUtil_5_2_6;
	wire[7:0] yneg_ClockwiseUtil_5_2_6,yneg_CounterClockwiseUtil_5_2_6,yneg_InjectUtil_5_2_6;
	wire[7:0] zpos_ClockwiseUtil_5_2_6,zpos_CounterClockwiseUtil_5_2_6,zpos_InjectUtil_5_2_6;
	wire[7:0] zneg_ClockwiseUtil_5_2_6,zneg_CounterClockwiseUtil_5_2_6,zneg_InjectUtil_5_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_2_7, eject_xpos_ser_5_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_2_7, eject_xneg_ser_5_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_2_7, eject_ypos_ser_5_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_2_7, eject_yneg_ser_5_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_2_7, eject_zpos_ser_5_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_2_7, eject_zneg_ser_5_2_7;
	wire[7:0] xpos_ClockwiseUtil_5_2_7,xpos_CounterClockwiseUtil_5_2_7,xpos_InjectUtil_5_2_7;
	wire[7:0] xneg_ClockwiseUtil_5_2_7,xneg_CounterClockwiseUtil_5_2_7,xneg_InjectUtil_5_2_7;
	wire[7:0] ypos_ClockwiseUtil_5_2_7,ypos_CounterClockwiseUtil_5_2_7,ypos_InjectUtil_5_2_7;
	wire[7:0] yneg_ClockwiseUtil_5_2_7,yneg_CounterClockwiseUtil_5_2_7,yneg_InjectUtil_5_2_7;
	wire[7:0] zpos_ClockwiseUtil_5_2_7,zpos_CounterClockwiseUtil_5_2_7,zpos_InjectUtil_5_2_7;
	wire[7:0] zneg_ClockwiseUtil_5_2_7,zneg_CounterClockwiseUtil_5_2_7,zneg_InjectUtil_5_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_0, eject_xpos_ser_5_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_0, eject_xneg_ser_5_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_0, eject_ypos_ser_5_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_0, eject_yneg_ser_5_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_0, eject_zpos_ser_5_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_0, eject_zneg_ser_5_3_0;
	wire[7:0] xpos_ClockwiseUtil_5_3_0,xpos_CounterClockwiseUtil_5_3_0,xpos_InjectUtil_5_3_0;
	wire[7:0] xneg_ClockwiseUtil_5_3_0,xneg_CounterClockwiseUtil_5_3_0,xneg_InjectUtil_5_3_0;
	wire[7:0] ypos_ClockwiseUtil_5_3_0,ypos_CounterClockwiseUtil_5_3_0,ypos_InjectUtil_5_3_0;
	wire[7:0] yneg_ClockwiseUtil_5_3_0,yneg_CounterClockwiseUtil_5_3_0,yneg_InjectUtil_5_3_0;
	wire[7:0] zpos_ClockwiseUtil_5_3_0,zpos_CounterClockwiseUtil_5_3_0,zpos_InjectUtil_5_3_0;
	wire[7:0] zneg_ClockwiseUtil_5_3_0,zneg_CounterClockwiseUtil_5_3_0,zneg_InjectUtil_5_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_1, eject_xpos_ser_5_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_1, eject_xneg_ser_5_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_1, eject_ypos_ser_5_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_1, eject_yneg_ser_5_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_1, eject_zpos_ser_5_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_1, eject_zneg_ser_5_3_1;
	wire[7:0] xpos_ClockwiseUtil_5_3_1,xpos_CounterClockwiseUtil_5_3_1,xpos_InjectUtil_5_3_1;
	wire[7:0] xneg_ClockwiseUtil_5_3_1,xneg_CounterClockwiseUtil_5_3_1,xneg_InjectUtil_5_3_1;
	wire[7:0] ypos_ClockwiseUtil_5_3_1,ypos_CounterClockwiseUtil_5_3_1,ypos_InjectUtil_5_3_1;
	wire[7:0] yneg_ClockwiseUtil_5_3_1,yneg_CounterClockwiseUtil_5_3_1,yneg_InjectUtil_5_3_1;
	wire[7:0] zpos_ClockwiseUtil_5_3_1,zpos_CounterClockwiseUtil_5_3_1,zpos_InjectUtil_5_3_1;
	wire[7:0] zneg_ClockwiseUtil_5_3_1,zneg_CounterClockwiseUtil_5_3_1,zneg_InjectUtil_5_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_2, eject_xpos_ser_5_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_2, eject_xneg_ser_5_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_2, eject_ypos_ser_5_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_2, eject_yneg_ser_5_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_2, eject_zpos_ser_5_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_2, eject_zneg_ser_5_3_2;
	wire[7:0] xpos_ClockwiseUtil_5_3_2,xpos_CounterClockwiseUtil_5_3_2,xpos_InjectUtil_5_3_2;
	wire[7:0] xneg_ClockwiseUtil_5_3_2,xneg_CounterClockwiseUtil_5_3_2,xneg_InjectUtil_5_3_2;
	wire[7:0] ypos_ClockwiseUtil_5_3_2,ypos_CounterClockwiseUtil_5_3_2,ypos_InjectUtil_5_3_2;
	wire[7:0] yneg_ClockwiseUtil_5_3_2,yneg_CounterClockwiseUtil_5_3_2,yneg_InjectUtil_5_3_2;
	wire[7:0] zpos_ClockwiseUtil_5_3_2,zpos_CounterClockwiseUtil_5_3_2,zpos_InjectUtil_5_3_2;
	wire[7:0] zneg_ClockwiseUtil_5_3_2,zneg_CounterClockwiseUtil_5_3_2,zneg_InjectUtil_5_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_3, eject_xpos_ser_5_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_3, eject_xneg_ser_5_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_3, eject_ypos_ser_5_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_3, eject_yneg_ser_5_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_3, eject_zpos_ser_5_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_3, eject_zneg_ser_5_3_3;
	wire[7:0] xpos_ClockwiseUtil_5_3_3,xpos_CounterClockwiseUtil_5_3_3,xpos_InjectUtil_5_3_3;
	wire[7:0] xneg_ClockwiseUtil_5_3_3,xneg_CounterClockwiseUtil_5_3_3,xneg_InjectUtil_5_3_3;
	wire[7:0] ypos_ClockwiseUtil_5_3_3,ypos_CounterClockwiseUtil_5_3_3,ypos_InjectUtil_5_3_3;
	wire[7:0] yneg_ClockwiseUtil_5_3_3,yneg_CounterClockwiseUtil_5_3_3,yneg_InjectUtil_5_3_3;
	wire[7:0] zpos_ClockwiseUtil_5_3_3,zpos_CounterClockwiseUtil_5_3_3,zpos_InjectUtil_5_3_3;
	wire[7:0] zneg_ClockwiseUtil_5_3_3,zneg_CounterClockwiseUtil_5_3_3,zneg_InjectUtil_5_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_4, eject_xpos_ser_5_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_4, eject_xneg_ser_5_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_4, eject_ypos_ser_5_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_4, eject_yneg_ser_5_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_4, eject_zpos_ser_5_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_4, eject_zneg_ser_5_3_4;
	wire[7:0] xpos_ClockwiseUtil_5_3_4,xpos_CounterClockwiseUtil_5_3_4,xpos_InjectUtil_5_3_4;
	wire[7:0] xneg_ClockwiseUtil_5_3_4,xneg_CounterClockwiseUtil_5_3_4,xneg_InjectUtil_5_3_4;
	wire[7:0] ypos_ClockwiseUtil_5_3_4,ypos_CounterClockwiseUtil_5_3_4,ypos_InjectUtil_5_3_4;
	wire[7:0] yneg_ClockwiseUtil_5_3_4,yneg_CounterClockwiseUtil_5_3_4,yneg_InjectUtil_5_3_4;
	wire[7:0] zpos_ClockwiseUtil_5_3_4,zpos_CounterClockwiseUtil_5_3_4,zpos_InjectUtil_5_3_4;
	wire[7:0] zneg_ClockwiseUtil_5_3_4,zneg_CounterClockwiseUtil_5_3_4,zneg_InjectUtil_5_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_5, eject_xpos_ser_5_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_5, eject_xneg_ser_5_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_5, eject_ypos_ser_5_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_5, eject_yneg_ser_5_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_5, eject_zpos_ser_5_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_5, eject_zneg_ser_5_3_5;
	wire[7:0] xpos_ClockwiseUtil_5_3_5,xpos_CounterClockwiseUtil_5_3_5,xpos_InjectUtil_5_3_5;
	wire[7:0] xneg_ClockwiseUtil_5_3_5,xneg_CounterClockwiseUtil_5_3_5,xneg_InjectUtil_5_3_5;
	wire[7:0] ypos_ClockwiseUtil_5_3_5,ypos_CounterClockwiseUtil_5_3_5,ypos_InjectUtil_5_3_5;
	wire[7:0] yneg_ClockwiseUtil_5_3_5,yneg_CounterClockwiseUtil_5_3_5,yneg_InjectUtil_5_3_5;
	wire[7:0] zpos_ClockwiseUtil_5_3_5,zpos_CounterClockwiseUtil_5_3_5,zpos_InjectUtil_5_3_5;
	wire[7:0] zneg_ClockwiseUtil_5_3_5,zneg_CounterClockwiseUtil_5_3_5,zneg_InjectUtil_5_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_6, eject_xpos_ser_5_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_6, eject_xneg_ser_5_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_6, eject_ypos_ser_5_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_6, eject_yneg_ser_5_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_6, eject_zpos_ser_5_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_6, eject_zneg_ser_5_3_6;
	wire[7:0] xpos_ClockwiseUtil_5_3_6,xpos_CounterClockwiseUtil_5_3_6,xpos_InjectUtil_5_3_6;
	wire[7:0] xneg_ClockwiseUtil_5_3_6,xneg_CounterClockwiseUtil_5_3_6,xneg_InjectUtil_5_3_6;
	wire[7:0] ypos_ClockwiseUtil_5_3_6,ypos_CounterClockwiseUtil_5_3_6,ypos_InjectUtil_5_3_6;
	wire[7:0] yneg_ClockwiseUtil_5_3_6,yneg_CounterClockwiseUtil_5_3_6,yneg_InjectUtil_5_3_6;
	wire[7:0] zpos_ClockwiseUtil_5_3_6,zpos_CounterClockwiseUtil_5_3_6,zpos_InjectUtil_5_3_6;
	wire[7:0] zneg_ClockwiseUtil_5_3_6,zneg_CounterClockwiseUtil_5_3_6,zneg_InjectUtil_5_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_3_7, eject_xpos_ser_5_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_3_7, eject_xneg_ser_5_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_3_7, eject_ypos_ser_5_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_3_7, eject_yneg_ser_5_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_3_7, eject_zpos_ser_5_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_3_7, eject_zneg_ser_5_3_7;
	wire[7:0] xpos_ClockwiseUtil_5_3_7,xpos_CounterClockwiseUtil_5_3_7,xpos_InjectUtil_5_3_7;
	wire[7:0] xneg_ClockwiseUtil_5_3_7,xneg_CounterClockwiseUtil_5_3_7,xneg_InjectUtil_5_3_7;
	wire[7:0] ypos_ClockwiseUtil_5_3_7,ypos_CounterClockwiseUtil_5_3_7,ypos_InjectUtil_5_3_7;
	wire[7:0] yneg_ClockwiseUtil_5_3_7,yneg_CounterClockwiseUtil_5_3_7,yneg_InjectUtil_5_3_7;
	wire[7:0] zpos_ClockwiseUtil_5_3_7,zpos_CounterClockwiseUtil_5_3_7,zpos_InjectUtil_5_3_7;
	wire[7:0] zneg_ClockwiseUtil_5_3_7,zneg_CounterClockwiseUtil_5_3_7,zneg_InjectUtil_5_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_0, eject_xpos_ser_5_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_0, eject_xneg_ser_5_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_0, eject_ypos_ser_5_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_0, eject_yneg_ser_5_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_0, eject_zpos_ser_5_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_0, eject_zneg_ser_5_4_0;
	wire[7:0] xpos_ClockwiseUtil_5_4_0,xpos_CounterClockwiseUtil_5_4_0,xpos_InjectUtil_5_4_0;
	wire[7:0] xneg_ClockwiseUtil_5_4_0,xneg_CounterClockwiseUtil_5_4_0,xneg_InjectUtil_5_4_0;
	wire[7:0] ypos_ClockwiseUtil_5_4_0,ypos_CounterClockwiseUtil_5_4_0,ypos_InjectUtil_5_4_0;
	wire[7:0] yneg_ClockwiseUtil_5_4_0,yneg_CounterClockwiseUtil_5_4_0,yneg_InjectUtil_5_4_0;
	wire[7:0] zpos_ClockwiseUtil_5_4_0,zpos_CounterClockwiseUtil_5_4_0,zpos_InjectUtil_5_4_0;
	wire[7:0] zneg_ClockwiseUtil_5_4_0,zneg_CounterClockwiseUtil_5_4_0,zneg_InjectUtil_5_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_1, eject_xpos_ser_5_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_1, eject_xneg_ser_5_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_1, eject_ypos_ser_5_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_1, eject_yneg_ser_5_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_1, eject_zpos_ser_5_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_1, eject_zneg_ser_5_4_1;
	wire[7:0] xpos_ClockwiseUtil_5_4_1,xpos_CounterClockwiseUtil_5_4_1,xpos_InjectUtil_5_4_1;
	wire[7:0] xneg_ClockwiseUtil_5_4_1,xneg_CounterClockwiseUtil_5_4_1,xneg_InjectUtil_5_4_1;
	wire[7:0] ypos_ClockwiseUtil_5_4_1,ypos_CounterClockwiseUtil_5_4_1,ypos_InjectUtil_5_4_1;
	wire[7:0] yneg_ClockwiseUtil_5_4_1,yneg_CounterClockwiseUtil_5_4_1,yneg_InjectUtil_5_4_1;
	wire[7:0] zpos_ClockwiseUtil_5_4_1,zpos_CounterClockwiseUtil_5_4_1,zpos_InjectUtil_5_4_1;
	wire[7:0] zneg_ClockwiseUtil_5_4_1,zneg_CounterClockwiseUtil_5_4_1,zneg_InjectUtil_5_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_2, eject_xpos_ser_5_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_2, eject_xneg_ser_5_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_2, eject_ypos_ser_5_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_2, eject_yneg_ser_5_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_2, eject_zpos_ser_5_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_2, eject_zneg_ser_5_4_2;
	wire[7:0] xpos_ClockwiseUtil_5_4_2,xpos_CounterClockwiseUtil_5_4_2,xpos_InjectUtil_5_4_2;
	wire[7:0] xneg_ClockwiseUtil_5_4_2,xneg_CounterClockwiseUtil_5_4_2,xneg_InjectUtil_5_4_2;
	wire[7:0] ypos_ClockwiseUtil_5_4_2,ypos_CounterClockwiseUtil_5_4_2,ypos_InjectUtil_5_4_2;
	wire[7:0] yneg_ClockwiseUtil_5_4_2,yneg_CounterClockwiseUtil_5_4_2,yneg_InjectUtil_5_4_2;
	wire[7:0] zpos_ClockwiseUtil_5_4_2,zpos_CounterClockwiseUtil_5_4_2,zpos_InjectUtil_5_4_2;
	wire[7:0] zneg_ClockwiseUtil_5_4_2,zneg_CounterClockwiseUtil_5_4_2,zneg_InjectUtil_5_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_3, eject_xpos_ser_5_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_3, eject_xneg_ser_5_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_3, eject_ypos_ser_5_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_3, eject_yneg_ser_5_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_3, eject_zpos_ser_5_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_3, eject_zneg_ser_5_4_3;
	wire[7:0] xpos_ClockwiseUtil_5_4_3,xpos_CounterClockwiseUtil_5_4_3,xpos_InjectUtil_5_4_3;
	wire[7:0] xneg_ClockwiseUtil_5_4_3,xneg_CounterClockwiseUtil_5_4_3,xneg_InjectUtil_5_4_3;
	wire[7:0] ypos_ClockwiseUtil_5_4_3,ypos_CounterClockwiseUtil_5_4_3,ypos_InjectUtil_5_4_3;
	wire[7:0] yneg_ClockwiseUtil_5_4_3,yneg_CounterClockwiseUtil_5_4_3,yneg_InjectUtil_5_4_3;
	wire[7:0] zpos_ClockwiseUtil_5_4_3,zpos_CounterClockwiseUtil_5_4_3,zpos_InjectUtil_5_4_3;
	wire[7:0] zneg_ClockwiseUtil_5_4_3,zneg_CounterClockwiseUtil_5_4_3,zneg_InjectUtil_5_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_4, eject_xpos_ser_5_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_4, eject_xneg_ser_5_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_4, eject_ypos_ser_5_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_4, eject_yneg_ser_5_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_4, eject_zpos_ser_5_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_4, eject_zneg_ser_5_4_4;
	wire[7:0] xpos_ClockwiseUtil_5_4_4,xpos_CounterClockwiseUtil_5_4_4,xpos_InjectUtil_5_4_4;
	wire[7:0] xneg_ClockwiseUtil_5_4_4,xneg_CounterClockwiseUtil_5_4_4,xneg_InjectUtil_5_4_4;
	wire[7:0] ypos_ClockwiseUtil_5_4_4,ypos_CounterClockwiseUtil_5_4_4,ypos_InjectUtil_5_4_4;
	wire[7:0] yneg_ClockwiseUtil_5_4_4,yneg_CounterClockwiseUtil_5_4_4,yneg_InjectUtil_5_4_4;
	wire[7:0] zpos_ClockwiseUtil_5_4_4,zpos_CounterClockwiseUtil_5_4_4,zpos_InjectUtil_5_4_4;
	wire[7:0] zneg_ClockwiseUtil_5_4_4,zneg_CounterClockwiseUtil_5_4_4,zneg_InjectUtil_5_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_5, eject_xpos_ser_5_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_5, eject_xneg_ser_5_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_5, eject_ypos_ser_5_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_5, eject_yneg_ser_5_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_5, eject_zpos_ser_5_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_5, eject_zneg_ser_5_4_5;
	wire[7:0] xpos_ClockwiseUtil_5_4_5,xpos_CounterClockwiseUtil_5_4_5,xpos_InjectUtil_5_4_5;
	wire[7:0] xneg_ClockwiseUtil_5_4_5,xneg_CounterClockwiseUtil_5_4_5,xneg_InjectUtil_5_4_5;
	wire[7:0] ypos_ClockwiseUtil_5_4_5,ypos_CounterClockwiseUtil_5_4_5,ypos_InjectUtil_5_4_5;
	wire[7:0] yneg_ClockwiseUtil_5_4_5,yneg_CounterClockwiseUtil_5_4_5,yneg_InjectUtil_5_4_5;
	wire[7:0] zpos_ClockwiseUtil_5_4_5,zpos_CounterClockwiseUtil_5_4_5,zpos_InjectUtil_5_4_5;
	wire[7:0] zneg_ClockwiseUtil_5_4_5,zneg_CounterClockwiseUtil_5_4_5,zneg_InjectUtil_5_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_6, eject_xpos_ser_5_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_6, eject_xneg_ser_5_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_6, eject_ypos_ser_5_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_6, eject_yneg_ser_5_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_6, eject_zpos_ser_5_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_6, eject_zneg_ser_5_4_6;
	wire[7:0] xpos_ClockwiseUtil_5_4_6,xpos_CounterClockwiseUtil_5_4_6,xpos_InjectUtil_5_4_6;
	wire[7:0] xneg_ClockwiseUtil_5_4_6,xneg_CounterClockwiseUtil_5_4_6,xneg_InjectUtil_5_4_6;
	wire[7:0] ypos_ClockwiseUtil_5_4_6,ypos_CounterClockwiseUtil_5_4_6,ypos_InjectUtil_5_4_6;
	wire[7:0] yneg_ClockwiseUtil_5_4_6,yneg_CounterClockwiseUtil_5_4_6,yneg_InjectUtil_5_4_6;
	wire[7:0] zpos_ClockwiseUtil_5_4_6,zpos_CounterClockwiseUtil_5_4_6,zpos_InjectUtil_5_4_6;
	wire[7:0] zneg_ClockwiseUtil_5_4_6,zneg_CounterClockwiseUtil_5_4_6,zneg_InjectUtil_5_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_4_7, eject_xpos_ser_5_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_4_7, eject_xneg_ser_5_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_4_7, eject_ypos_ser_5_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_4_7, eject_yneg_ser_5_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_4_7, eject_zpos_ser_5_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_4_7, eject_zneg_ser_5_4_7;
	wire[7:0] xpos_ClockwiseUtil_5_4_7,xpos_CounterClockwiseUtil_5_4_7,xpos_InjectUtil_5_4_7;
	wire[7:0] xneg_ClockwiseUtil_5_4_7,xneg_CounterClockwiseUtil_5_4_7,xneg_InjectUtil_5_4_7;
	wire[7:0] ypos_ClockwiseUtil_5_4_7,ypos_CounterClockwiseUtil_5_4_7,ypos_InjectUtil_5_4_7;
	wire[7:0] yneg_ClockwiseUtil_5_4_7,yneg_CounterClockwiseUtil_5_4_7,yneg_InjectUtil_5_4_7;
	wire[7:0] zpos_ClockwiseUtil_5_4_7,zpos_CounterClockwiseUtil_5_4_7,zpos_InjectUtil_5_4_7;
	wire[7:0] zneg_ClockwiseUtil_5_4_7,zneg_CounterClockwiseUtil_5_4_7,zneg_InjectUtil_5_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_0, eject_xpos_ser_5_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_0, eject_xneg_ser_5_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_0, eject_ypos_ser_5_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_0, eject_yneg_ser_5_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_0, eject_zpos_ser_5_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_0, eject_zneg_ser_5_5_0;
	wire[7:0] xpos_ClockwiseUtil_5_5_0,xpos_CounterClockwiseUtil_5_5_0,xpos_InjectUtil_5_5_0;
	wire[7:0] xneg_ClockwiseUtil_5_5_0,xneg_CounterClockwiseUtil_5_5_0,xneg_InjectUtil_5_5_0;
	wire[7:0] ypos_ClockwiseUtil_5_5_0,ypos_CounterClockwiseUtil_5_5_0,ypos_InjectUtil_5_5_0;
	wire[7:0] yneg_ClockwiseUtil_5_5_0,yneg_CounterClockwiseUtil_5_5_0,yneg_InjectUtil_5_5_0;
	wire[7:0] zpos_ClockwiseUtil_5_5_0,zpos_CounterClockwiseUtil_5_5_0,zpos_InjectUtil_5_5_0;
	wire[7:0] zneg_ClockwiseUtil_5_5_0,zneg_CounterClockwiseUtil_5_5_0,zneg_InjectUtil_5_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_1, eject_xpos_ser_5_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_1, eject_xneg_ser_5_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_1, eject_ypos_ser_5_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_1, eject_yneg_ser_5_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_1, eject_zpos_ser_5_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_1, eject_zneg_ser_5_5_1;
	wire[7:0] xpos_ClockwiseUtil_5_5_1,xpos_CounterClockwiseUtil_5_5_1,xpos_InjectUtil_5_5_1;
	wire[7:0] xneg_ClockwiseUtil_5_5_1,xneg_CounterClockwiseUtil_5_5_1,xneg_InjectUtil_5_5_1;
	wire[7:0] ypos_ClockwiseUtil_5_5_1,ypos_CounterClockwiseUtil_5_5_1,ypos_InjectUtil_5_5_1;
	wire[7:0] yneg_ClockwiseUtil_5_5_1,yneg_CounterClockwiseUtil_5_5_1,yneg_InjectUtil_5_5_1;
	wire[7:0] zpos_ClockwiseUtil_5_5_1,zpos_CounterClockwiseUtil_5_5_1,zpos_InjectUtil_5_5_1;
	wire[7:0] zneg_ClockwiseUtil_5_5_1,zneg_CounterClockwiseUtil_5_5_1,zneg_InjectUtil_5_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_2, eject_xpos_ser_5_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_2, eject_xneg_ser_5_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_2, eject_ypos_ser_5_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_2, eject_yneg_ser_5_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_2, eject_zpos_ser_5_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_2, eject_zneg_ser_5_5_2;
	wire[7:0] xpos_ClockwiseUtil_5_5_2,xpos_CounterClockwiseUtil_5_5_2,xpos_InjectUtil_5_5_2;
	wire[7:0] xneg_ClockwiseUtil_5_5_2,xneg_CounterClockwiseUtil_5_5_2,xneg_InjectUtil_5_5_2;
	wire[7:0] ypos_ClockwiseUtil_5_5_2,ypos_CounterClockwiseUtil_5_5_2,ypos_InjectUtil_5_5_2;
	wire[7:0] yneg_ClockwiseUtil_5_5_2,yneg_CounterClockwiseUtil_5_5_2,yneg_InjectUtil_5_5_2;
	wire[7:0] zpos_ClockwiseUtil_5_5_2,zpos_CounterClockwiseUtil_5_5_2,zpos_InjectUtil_5_5_2;
	wire[7:0] zneg_ClockwiseUtil_5_5_2,zneg_CounterClockwiseUtil_5_5_2,zneg_InjectUtil_5_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_3, eject_xpos_ser_5_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_3, eject_xneg_ser_5_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_3, eject_ypos_ser_5_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_3, eject_yneg_ser_5_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_3, eject_zpos_ser_5_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_3, eject_zneg_ser_5_5_3;
	wire[7:0] xpos_ClockwiseUtil_5_5_3,xpos_CounterClockwiseUtil_5_5_3,xpos_InjectUtil_5_5_3;
	wire[7:0] xneg_ClockwiseUtil_5_5_3,xneg_CounterClockwiseUtil_5_5_3,xneg_InjectUtil_5_5_3;
	wire[7:0] ypos_ClockwiseUtil_5_5_3,ypos_CounterClockwiseUtil_5_5_3,ypos_InjectUtil_5_5_3;
	wire[7:0] yneg_ClockwiseUtil_5_5_3,yneg_CounterClockwiseUtil_5_5_3,yneg_InjectUtil_5_5_3;
	wire[7:0] zpos_ClockwiseUtil_5_5_3,zpos_CounterClockwiseUtil_5_5_3,zpos_InjectUtil_5_5_3;
	wire[7:0] zneg_ClockwiseUtil_5_5_3,zneg_CounterClockwiseUtil_5_5_3,zneg_InjectUtil_5_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_4, eject_xpos_ser_5_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_4, eject_xneg_ser_5_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_4, eject_ypos_ser_5_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_4, eject_yneg_ser_5_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_4, eject_zpos_ser_5_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_4, eject_zneg_ser_5_5_4;
	wire[7:0] xpos_ClockwiseUtil_5_5_4,xpos_CounterClockwiseUtil_5_5_4,xpos_InjectUtil_5_5_4;
	wire[7:0] xneg_ClockwiseUtil_5_5_4,xneg_CounterClockwiseUtil_5_5_4,xneg_InjectUtil_5_5_4;
	wire[7:0] ypos_ClockwiseUtil_5_5_4,ypos_CounterClockwiseUtil_5_5_4,ypos_InjectUtil_5_5_4;
	wire[7:0] yneg_ClockwiseUtil_5_5_4,yneg_CounterClockwiseUtil_5_5_4,yneg_InjectUtil_5_5_4;
	wire[7:0] zpos_ClockwiseUtil_5_5_4,zpos_CounterClockwiseUtil_5_5_4,zpos_InjectUtil_5_5_4;
	wire[7:0] zneg_ClockwiseUtil_5_5_4,zneg_CounterClockwiseUtil_5_5_4,zneg_InjectUtil_5_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_5, eject_xpos_ser_5_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_5, eject_xneg_ser_5_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_5, eject_ypos_ser_5_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_5, eject_yneg_ser_5_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_5, eject_zpos_ser_5_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_5, eject_zneg_ser_5_5_5;
	wire[7:0] xpos_ClockwiseUtil_5_5_5,xpos_CounterClockwiseUtil_5_5_5,xpos_InjectUtil_5_5_5;
	wire[7:0] xneg_ClockwiseUtil_5_5_5,xneg_CounterClockwiseUtil_5_5_5,xneg_InjectUtil_5_5_5;
	wire[7:0] ypos_ClockwiseUtil_5_5_5,ypos_CounterClockwiseUtil_5_5_5,ypos_InjectUtil_5_5_5;
	wire[7:0] yneg_ClockwiseUtil_5_5_5,yneg_CounterClockwiseUtil_5_5_5,yneg_InjectUtil_5_5_5;
	wire[7:0] zpos_ClockwiseUtil_5_5_5,zpos_CounterClockwiseUtil_5_5_5,zpos_InjectUtil_5_5_5;
	wire[7:0] zneg_ClockwiseUtil_5_5_5,zneg_CounterClockwiseUtil_5_5_5,zneg_InjectUtil_5_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_6, eject_xpos_ser_5_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_6, eject_xneg_ser_5_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_6, eject_ypos_ser_5_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_6, eject_yneg_ser_5_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_6, eject_zpos_ser_5_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_6, eject_zneg_ser_5_5_6;
	wire[7:0] xpos_ClockwiseUtil_5_5_6,xpos_CounterClockwiseUtil_5_5_6,xpos_InjectUtil_5_5_6;
	wire[7:0] xneg_ClockwiseUtil_5_5_6,xneg_CounterClockwiseUtil_5_5_6,xneg_InjectUtil_5_5_6;
	wire[7:0] ypos_ClockwiseUtil_5_5_6,ypos_CounterClockwiseUtil_5_5_6,ypos_InjectUtil_5_5_6;
	wire[7:0] yneg_ClockwiseUtil_5_5_6,yneg_CounterClockwiseUtil_5_5_6,yneg_InjectUtil_5_5_6;
	wire[7:0] zpos_ClockwiseUtil_5_5_6,zpos_CounterClockwiseUtil_5_5_6,zpos_InjectUtil_5_5_6;
	wire[7:0] zneg_ClockwiseUtil_5_5_6,zneg_CounterClockwiseUtil_5_5_6,zneg_InjectUtil_5_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_5_7, eject_xpos_ser_5_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_5_7, eject_xneg_ser_5_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_5_7, eject_ypos_ser_5_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_5_7, eject_yneg_ser_5_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_5_7, eject_zpos_ser_5_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_5_7, eject_zneg_ser_5_5_7;
	wire[7:0] xpos_ClockwiseUtil_5_5_7,xpos_CounterClockwiseUtil_5_5_7,xpos_InjectUtil_5_5_7;
	wire[7:0] xneg_ClockwiseUtil_5_5_7,xneg_CounterClockwiseUtil_5_5_7,xneg_InjectUtil_5_5_7;
	wire[7:0] ypos_ClockwiseUtil_5_5_7,ypos_CounterClockwiseUtil_5_5_7,ypos_InjectUtil_5_5_7;
	wire[7:0] yneg_ClockwiseUtil_5_5_7,yneg_CounterClockwiseUtil_5_5_7,yneg_InjectUtil_5_5_7;
	wire[7:0] zpos_ClockwiseUtil_5_5_7,zpos_CounterClockwiseUtil_5_5_7,zpos_InjectUtil_5_5_7;
	wire[7:0] zneg_ClockwiseUtil_5_5_7,zneg_CounterClockwiseUtil_5_5_7,zneg_InjectUtil_5_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_0, eject_xpos_ser_5_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_0, eject_xneg_ser_5_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_0, eject_ypos_ser_5_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_0, eject_yneg_ser_5_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_0, eject_zpos_ser_5_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_0, eject_zneg_ser_5_6_0;
	wire[7:0] xpos_ClockwiseUtil_5_6_0,xpos_CounterClockwiseUtil_5_6_0,xpos_InjectUtil_5_6_0;
	wire[7:0] xneg_ClockwiseUtil_5_6_0,xneg_CounterClockwiseUtil_5_6_0,xneg_InjectUtil_5_6_0;
	wire[7:0] ypos_ClockwiseUtil_5_6_0,ypos_CounterClockwiseUtil_5_6_0,ypos_InjectUtil_5_6_0;
	wire[7:0] yneg_ClockwiseUtil_5_6_0,yneg_CounterClockwiseUtil_5_6_0,yneg_InjectUtil_5_6_0;
	wire[7:0] zpos_ClockwiseUtil_5_6_0,zpos_CounterClockwiseUtil_5_6_0,zpos_InjectUtil_5_6_0;
	wire[7:0] zneg_ClockwiseUtil_5_6_0,zneg_CounterClockwiseUtil_5_6_0,zneg_InjectUtil_5_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_1, eject_xpos_ser_5_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_1, eject_xneg_ser_5_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_1, eject_ypos_ser_5_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_1, eject_yneg_ser_5_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_1, eject_zpos_ser_5_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_1, eject_zneg_ser_5_6_1;
	wire[7:0] xpos_ClockwiseUtil_5_6_1,xpos_CounterClockwiseUtil_5_6_1,xpos_InjectUtil_5_6_1;
	wire[7:0] xneg_ClockwiseUtil_5_6_1,xneg_CounterClockwiseUtil_5_6_1,xneg_InjectUtil_5_6_1;
	wire[7:0] ypos_ClockwiseUtil_5_6_1,ypos_CounterClockwiseUtil_5_6_1,ypos_InjectUtil_5_6_1;
	wire[7:0] yneg_ClockwiseUtil_5_6_1,yneg_CounterClockwiseUtil_5_6_1,yneg_InjectUtil_5_6_1;
	wire[7:0] zpos_ClockwiseUtil_5_6_1,zpos_CounterClockwiseUtil_5_6_1,zpos_InjectUtil_5_6_1;
	wire[7:0] zneg_ClockwiseUtil_5_6_1,zneg_CounterClockwiseUtil_5_6_1,zneg_InjectUtil_5_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_2, eject_xpos_ser_5_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_2, eject_xneg_ser_5_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_2, eject_ypos_ser_5_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_2, eject_yneg_ser_5_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_2, eject_zpos_ser_5_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_2, eject_zneg_ser_5_6_2;
	wire[7:0] xpos_ClockwiseUtil_5_6_2,xpos_CounterClockwiseUtil_5_6_2,xpos_InjectUtil_5_6_2;
	wire[7:0] xneg_ClockwiseUtil_5_6_2,xneg_CounterClockwiseUtil_5_6_2,xneg_InjectUtil_5_6_2;
	wire[7:0] ypos_ClockwiseUtil_5_6_2,ypos_CounterClockwiseUtil_5_6_2,ypos_InjectUtil_5_6_2;
	wire[7:0] yneg_ClockwiseUtil_5_6_2,yneg_CounterClockwiseUtil_5_6_2,yneg_InjectUtil_5_6_2;
	wire[7:0] zpos_ClockwiseUtil_5_6_2,zpos_CounterClockwiseUtil_5_6_2,zpos_InjectUtil_5_6_2;
	wire[7:0] zneg_ClockwiseUtil_5_6_2,zneg_CounterClockwiseUtil_5_6_2,zneg_InjectUtil_5_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_3, eject_xpos_ser_5_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_3, eject_xneg_ser_5_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_3, eject_ypos_ser_5_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_3, eject_yneg_ser_5_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_3, eject_zpos_ser_5_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_3, eject_zneg_ser_5_6_3;
	wire[7:0] xpos_ClockwiseUtil_5_6_3,xpos_CounterClockwiseUtil_5_6_3,xpos_InjectUtil_5_6_3;
	wire[7:0] xneg_ClockwiseUtil_5_6_3,xneg_CounterClockwiseUtil_5_6_3,xneg_InjectUtil_5_6_3;
	wire[7:0] ypos_ClockwiseUtil_5_6_3,ypos_CounterClockwiseUtil_5_6_3,ypos_InjectUtil_5_6_3;
	wire[7:0] yneg_ClockwiseUtil_5_6_3,yneg_CounterClockwiseUtil_5_6_3,yneg_InjectUtil_5_6_3;
	wire[7:0] zpos_ClockwiseUtil_5_6_3,zpos_CounterClockwiseUtil_5_6_3,zpos_InjectUtil_5_6_3;
	wire[7:0] zneg_ClockwiseUtil_5_6_3,zneg_CounterClockwiseUtil_5_6_3,zneg_InjectUtil_5_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_4, eject_xpos_ser_5_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_4, eject_xneg_ser_5_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_4, eject_ypos_ser_5_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_4, eject_yneg_ser_5_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_4, eject_zpos_ser_5_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_4, eject_zneg_ser_5_6_4;
	wire[7:0] xpos_ClockwiseUtil_5_6_4,xpos_CounterClockwiseUtil_5_6_4,xpos_InjectUtil_5_6_4;
	wire[7:0] xneg_ClockwiseUtil_5_6_4,xneg_CounterClockwiseUtil_5_6_4,xneg_InjectUtil_5_6_4;
	wire[7:0] ypos_ClockwiseUtil_5_6_4,ypos_CounterClockwiseUtil_5_6_4,ypos_InjectUtil_5_6_4;
	wire[7:0] yneg_ClockwiseUtil_5_6_4,yneg_CounterClockwiseUtil_5_6_4,yneg_InjectUtil_5_6_4;
	wire[7:0] zpos_ClockwiseUtil_5_6_4,zpos_CounterClockwiseUtil_5_6_4,zpos_InjectUtil_5_6_4;
	wire[7:0] zneg_ClockwiseUtil_5_6_4,zneg_CounterClockwiseUtil_5_6_4,zneg_InjectUtil_5_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_5, eject_xpos_ser_5_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_5, eject_xneg_ser_5_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_5, eject_ypos_ser_5_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_5, eject_yneg_ser_5_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_5, eject_zpos_ser_5_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_5, eject_zneg_ser_5_6_5;
	wire[7:0] xpos_ClockwiseUtil_5_6_5,xpos_CounterClockwiseUtil_5_6_5,xpos_InjectUtil_5_6_5;
	wire[7:0] xneg_ClockwiseUtil_5_6_5,xneg_CounterClockwiseUtil_5_6_5,xneg_InjectUtil_5_6_5;
	wire[7:0] ypos_ClockwiseUtil_5_6_5,ypos_CounterClockwiseUtil_5_6_5,ypos_InjectUtil_5_6_5;
	wire[7:0] yneg_ClockwiseUtil_5_6_5,yneg_CounterClockwiseUtil_5_6_5,yneg_InjectUtil_5_6_5;
	wire[7:0] zpos_ClockwiseUtil_5_6_5,zpos_CounterClockwiseUtil_5_6_5,zpos_InjectUtil_5_6_5;
	wire[7:0] zneg_ClockwiseUtil_5_6_5,zneg_CounterClockwiseUtil_5_6_5,zneg_InjectUtil_5_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_6, eject_xpos_ser_5_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_6, eject_xneg_ser_5_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_6, eject_ypos_ser_5_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_6, eject_yneg_ser_5_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_6, eject_zpos_ser_5_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_6, eject_zneg_ser_5_6_6;
	wire[7:0] xpos_ClockwiseUtil_5_6_6,xpos_CounterClockwiseUtil_5_6_6,xpos_InjectUtil_5_6_6;
	wire[7:0] xneg_ClockwiseUtil_5_6_6,xneg_CounterClockwiseUtil_5_6_6,xneg_InjectUtil_5_6_6;
	wire[7:0] ypos_ClockwiseUtil_5_6_6,ypos_CounterClockwiseUtil_5_6_6,ypos_InjectUtil_5_6_6;
	wire[7:0] yneg_ClockwiseUtil_5_6_6,yneg_CounterClockwiseUtil_5_6_6,yneg_InjectUtil_5_6_6;
	wire[7:0] zpos_ClockwiseUtil_5_6_6,zpos_CounterClockwiseUtil_5_6_6,zpos_InjectUtil_5_6_6;
	wire[7:0] zneg_ClockwiseUtil_5_6_6,zneg_CounterClockwiseUtil_5_6_6,zneg_InjectUtil_5_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_6_7, eject_xpos_ser_5_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_6_7, eject_xneg_ser_5_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_6_7, eject_ypos_ser_5_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_6_7, eject_yneg_ser_5_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_6_7, eject_zpos_ser_5_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_6_7, eject_zneg_ser_5_6_7;
	wire[7:0] xpos_ClockwiseUtil_5_6_7,xpos_CounterClockwiseUtil_5_6_7,xpos_InjectUtil_5_6_7;
	wire[7:0] xneg_ClockwiseUtil_5_6_7,xneg_CounterClockwiseUtil_5_6_7,xneg_InjectUtil_5_6_7;
	wire[7:0] ypos_ClockwiseUtil_5_6_7,ypos_CounterClockwiseUtil_5_6_7,ypos_InjectUtil_5_6_7;
	wire[7:0] yneg_ClockwiseUtil_5_6_7,yneg_CounterClockwiseUtil_5_6_7,yneg_InjectUtil_5_6_7;
	wire[7:0] zpos_ClockwiseUtil_5_6_7,zpos_CounterClockwiseUtil_5_6_7,zpos_InjectUtil_5_6_7;
	wire[7:0] zneg_ClockwiseUtil_5_6_7,zneg_CounterClockwiseUtil_5_6_7,zneg_InjectUtil_5_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_0, eject_xpos_ser_5_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_0, eject_xneg_ser_5_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_0, eject_ypos_ser_5_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_0, eject_yneg_ser_5_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_0, eject_zpos_ser_5_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_0, eject_zneg_ser_5_7_0;
	wire[7:0] xpos_ClockwiseUtil_5_7_0,xpos_CounterClockwiseUtil_5_7_0,xpos_InjectUtil_5_7_0;
	wire[7:0] xneg_ClockwiseUtil_5_7_0,xneg_CounterClockwiseUtil_5_7_0,xneg_InjectUtil_5_7_0;
	wire[7:0] ypos_ClockwiseUtil_5_7_0,ypos_CounterClockwiseUtil_5_7_0,ypos_InjectUtil_5_7_0;
	wire[7:0] yneg_ClockwiseUtil_5_7_0,yneg_CounterClockwiseUtil_5_7_0,yneg_InjectUtil_5_7_0;
	wire[7:0] zpos_ClockwiseUtil_5_7_0,zpos_CounterClockwiseUtil_5_7_0,zpos_InjectUtil_5_7_0;
	wire[7:0] zneg_ClockwiseUtil_5_7_0,zneg_CounterClockwiseUtil_5_7_0,zneg_InjectUtil_5_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_1, eject_xpos_ser_5_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_1, eject_xneg_ser_5_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_1, eject_ypos_ser_5_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_1, eject_yneg_ser_5_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_1, eject_zpos_ser_5_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_1, eject_zneg_ser_5_7_1;
	wire[7:0] xpos_ClockwiseUtil_5_7_1,xpos_CounterClockwiseUtil_5_7_1,xpos_InjectUtil_5_7_1;
	wire[7:0] xneg_ClockwiseUtil_5_7_1,xneg_CounterClockwiseUtil_5_7_1,xneg_InjectUtil_5_7_1;
	wire[7:0] ypos_ClockwiseUtil_5_7_1,ypos_CounterClockwiseUtil_5_7_1,ypos_InjectUtil_5_7_1;
	wire[7:0] yneg_ClockwiseUtil_5_7_1,yneg_CounterClockwiseUtil_5_7_1,yneg_InjectUtil_5_7_1;
	wire[7:0] zpos_ClockwiseUtil_5_7_1,zpos_CounterClockwiseUtil_5_7_1,zpos_InjectUtil_5_7_1;
	wire[7:0] zneg_ClockwiseUtil_5_7_1,zneg_CounterClockwiseUtil_5_7_1,zneg_InjectUtil_5_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_2, eject_xpos_ser_5_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_2, eject_xneg_ser_5_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_2, eject_ypos_ser_5_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_2, eject_yneg_ser_5_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_2, eject_zpos_ser_5_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_2, eject_zneg_ser_5_7_2;
	wire[7:0] xpos_ClockwiseUtil_5_7_2,xpos_CounterClockwiseUtil_5_7_2,xpos_InjectUtil_5_7_2;
	wire[7:0] xneg_ClockwiseUtil_5_7_2,xneg_CounterClockwiseUtil_5_7_2,xneg_InjectUtil_5_7_2;
	wire[7:0] ypos_ClockwiseUtil_5_7_2,ypos_CounterClockwiseUtil_5_7_2,ypos_InjectUtil_5_7_2;
	wire[7:0] yneg_ClockwiseUtil_5_7_2,yneg_CounterClockwiseUtil_5_7_2,yneg_InjectUtil_5_7_2;
	wire[7:0] zpos_ClockwiseUtil_5_7_2,zpos_CounterClockwiseUtil_5_7_2,zpos_InjectUtil_5_7_2;
	wire[7:0] zneg_ClockwiseUtil_5_7_2,zneg_CounterClockwiseUtil_5_7_2,zneg_InjectUtil_5_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_3, eject_xpos_ser_5_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_3, eject_xneg_ser_5_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_3, eject_ypos_ser_5_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_3, eject_yneg_ser_5_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_3, eject_zpos_ser_5_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_3, eject_zneg_ser_5_7_3;
	wire[7:0] xpos_ClockwiseUtil_5_7_3,xpos_CounterClockwiseUtil_5_7_3,xpos_InjectUtil_5_7_3;
	wire[7:0] xneg_ClockwiseUtil_5_7_3,xneg_CounterClockwiseUtil_5_7_3,xneg_InjectUtil_5_7_3;
	wire[7:0] ypos_ClockwiseUtil_5_7_3,ypos_CounterClockwiseUtil_5_7_3,ypos_InjectUtil_5_7_3;
	wire[7:0] yneg_ClockwiseUtil_5_7_3,yneg_CounterClockwiseUtil_5_7_3,yneg_InjectUtil_5_7_3;
	wire[7:0] zpos_ClockwiseUtil_5_7_3,zpos_CounterClockwiseUtil_5_7_3,zpos_InjectUtil_5_7_3;
	wire[7:0] zneg_ClockwiseUtil_5_7_3,zneg_CounterClockwiseUtil_5_7_3,zneg_InjectUtil_5_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_4, eject_xpos_ser_5_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_4, eject_xneg_ser_5_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_4, eject_ypos_ser_5_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_4, eject_yneg_ser_5_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_4, eject_zpos_ser_5_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_4, eject_zneg_ser_5_7_4;
	wire[7:0] xpos_ClockwiseUtil_5_7_4,xpos_CounterClockwiseUtil_5_7_4,xpos_InjectUtil_5_7_4;
	wire[7:0] xneg_ClockwiseUtil_5_7_4,xneg_CounterClockwiseUtil_5_7_4,xneg_InjectUtil_5_7_4;
	wire[7:0] ypos_ClockwiseUtil_5_7_4,ypos_CounterClockwiseUtil_5_7_4,ypos_InjectUtil_5_7_4;
	wire[7:0] yneg_ClockwiseUtil_5_7_4,yneg_CounterClockwiseUtil_5_7_4,yneg_InjectUtil_5_7_4;
	wire[7:0] zpos_ClockwiseUtil_5_7_4,zpos_CounterClockwiseUtil_5_7_4,zpos_InjectUtil_5_7_4;
	wire[7:0] zneg_ClockwiseUtil_5_7_4,zneg_CounterClockwiseUtil_5_7_4,zneg_InjectUtil_5_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_5, eject_xpos_ser_5_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_5, eject_xneg_ser_5_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_5, eject_ypos_ser_5_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_5, eject_yneg_ser_5_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_5, eject_zpos_ser_5_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_5, eject_zneg_ser_5_7_5;
	wire[7:0] xpos_ClockwiseUtil_5_7_5,xpos_CounterClockwiseUtil_5_7_5,xpos_InjectUtil_5_7_5;
	wire[7:0] xneg_ClockwiseUtil_5_7_5,xneg_CounterClockwiseUtil_5_7_5,xneg_InjectUtil_5_7_5;
	wire[7:0] ypos_ClockwiseUtil_5_7_5,ypos_CounterClockwiseUtil_5_7_5,ypos_InjectUtil_5_7_5;
	wire[7:0] yneg_ClockwiseUtil_5_7_5,yneg_CounterClockwiseUtil_5_7_5,yneg_InjectUtil_5_7_5;
	wire[7:0] zpos_ClockwiseUtil_5_7_5,zpos_CounterClockwiseUtil_5_7_5,zpos_InjectUtil_5_7_5;
	wire[7:0] zneg_ClockwiseUtil_5_7_5,zneg_CounterClockwiseUtil_5_7_5,zneg_InjectUtil_5_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_6, eject_xpos_ser_5_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_6, eject_xneg_ser_5_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_6, eject_ypos_ser_5_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_6, eject_yneg_ser_5_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_6, eject_zpos_ser_5_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_6, eject_zneg_ser_5_7_6;
	wire[7:0] xpos_ClockwiseUtil_5_7_6,xpos_CounterClockwiseUtil_5_7_6,xpos_InjectUtil_5_7_6;
	wire[7:0] xneg_ClockwiseUtil_5_7_6,xneg_CounterClockwiseUtil_5_7_6,xneg_InjectUtil_5_7_6;
	wire[7:0] ypos_ClockwiseUtil_5_7_6,ypos_CounterClockwiseUtil_5_7_6,ypos_InjectUtil_5_7_6;
	wire[7:0] yneg_ClockwiseUtil_5_7_6,yneg_CounterClockwiseUtil_5_7_6,yneg_InjectUtil_5_7_6;
	wire[7:0] zpos_ClockwiseUtil_5_7_6,zpos_CounterClockwiseUtil_5_7_6,zpos_InjectUtil_5_7_6;
	wire[7:0] zneg_ClockwiseUtil_5_7_6,zneg_CounterClockwiseUtil_5_7_6,zneg_InjectUtil_5_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_5_7_7, eject_xpos_ser_5_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_5_7_7, eject_xneg_ser_5_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_5_7_7, eject_ypos_ser_5_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_5_7_7, eject_yneg_ser_5_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_5_7_7, eject_zpos_ser_5_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_5_7_7, eject_zneg_ser_5_7_7;
	wire[7:0] xpos_ClockwiseUtil_5_7_7,xpos_CounterClockwiseUtil_5_7_7,xpos_InjectUtil_5_7_7;
	wire[7:0] xneg_ClockwiseUtil_5_7_7,xneg_CounterClockwiseUtil_5_7_7,xneg_InjectUtil_5_7_7;
	wire[7:0] ypos_ClockwiseUtil_5_7_7,ypos_CounterClockwiseUtil_5_7_7,ypos_InjectUtil_5_7_7;
	wire[7:0] yneg_ClockwiseUtil_5_7_7,yneg_CounterClockwiseUtil_5_7_7,yneg_InjectUtil_5_7_7;
	wire[7:0] zpos_ClockwiseUtil_5_7_7,zpos_CounterClockwiseUtil_5_7_7,zpos_InjectUtil_5_7_7;
	wire[7:0] zneg_ClockwiseUtil_5_7_7,zneg_CounterClockwiseUtil_5_7_7,zneg_InjectUtil_5_7_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_0, eject_xpos_ser_6_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_0, eject_xneg_ser_6_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_0, eject_ypos_ser_6_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_0, eject_yneg_ser_6_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_0, eject_zpos_ser_6_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_0, eject_zneg_ser_6_0_0;
	wire[7:0] xpos_ClockwiseUtil_6_0_0,xpos_CounterClockwiseUtil_6_0_0,xpos_InjectUtil_6_0_0;
	wire[7:0] xneg_ClockwiseUtil_6_0_0,xneg_CounterClockwiseUtil_6_0_0,xneg_InjectUtil_6_0_0;
	wire[7:0] ypos_ClockwiseUtil_6_0_0,ypos_CounterClockwiseUtil_6_0_0,ypos_InjectUtil_6_0_0;
	wire[7:0] yneg_ClockwiseUtil_6_0_0,yneg_CounterClockwiseUtil_6_0_0,yneg_InjectUtil_6_0_0;
	wire[7:0] zpos_ClockwiseUtil_6_0_0,zpos_CounterClockwiseUtil_6_0_0,zpos_InjectUtil_6_0_0;
	wire[7:0] zneg_ClockwiseUtil_6_0_0,zneg_CounterClockwiseUtil_6_0_0,zneg_InjectUtil_6_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_1, eject_xpos_ser_6_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_1, eject_xneg_ser_6_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_1, eject_ypos_ser_6_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_1, eject_yneg_ser_6_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_1, eject_zpos_ser_6_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_1, eject_zneg_ser_6_0_1;
	wire[7:0] xpos_ClockwiseUtil_6_0_1,xpos_CounterClockwiseUtil_6_0_1,xpos_InjectUtil_6_0_1;
	wire[7:0] xneg_ClockwiseUtil_6_0_1,xneg_CounterClockwiseUtil_6_0_1,xneg_InjectUtil_6_0_1;
	wire[7:0] ypos_ClockwiseUtil_6_0_1,ypos_CounterClockwiseUtil_6_0_1,ypos_InjectUtil_6_0_1;
	wire[7:0] yneg_ClockwiseUtil_6_0_1,yneg_CounterClockwiseUtil_6_0_1,yneg_InjectUtil_6_0_1;
	wire[7:0] zpos_ClockwiseUtil_6_0_1,zpos_CounterClockwiseUtil_6_0_1,zpos_InjectUtil_6_0_1;
	wire[7:0] zneg_ClockwiseUtil_6_0_1,zneg_CounterClockwiseUtil_6_0_1,zneg_InjectUtil_6_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_2, eject_xpos_ser_6_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_2, eject_xneg_ser_6_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_2, eject_ypos_ser_6_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_2, eject_yneg_ser_6_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_2, eject_zpos_ser_6_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_2, eject_zneg_ser_6_0_2;
	wire[7:0] xpos_ClockwiseUtil_6_0_2,xpos_CounterClockwiseUtil_6_0_2,xpos_InjectUtil_6_0_2;
	wire[7:0] xneg_ClockwiseUtil_6_0_2,xneg_CounterClockwiseUtil_6_0_2,xneg_InjectUtil_6_0_2;
	wire[7:0] ypos_ClockwiseUtil_6_0_2,ypos_CounterClockwiseUtil_6_0_2,ypos_InjectUtil_6_0_2;
	wire[7:0] yneg_ClockwiseUtil_6_0_2,yneg_CounterClockwiseUtil_6_0_2,yneg_InjectUtil_6_0_2;
	wire[7:0] zpos_ClockwiseUtil_6_0_2,zpos_CounterClockwiseUtil_6_0_2,zpos_InjectUtil_6_0_2;
	wire[7:0] zneg_ClockwiseUtil_6_0_2,zneg_CounterClockwiseUtil_6_0_2,zneg_InjectUtil_6_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_3, eject_xpos_ser_6_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_3, eject_xneg_ser_6_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_3, eject_ypos_ser_6_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_3, eject_yneg_ser_6_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_3, eject_zpos_ser_6_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_3, eject_zneg_ser_6_0_3;
	wire[7:0] xpos_ClockwiseUtil_6_0_3,xpos_CounterClockwiseUtil_6_0_3,xpos_InjectUtil_6_0_3;
	wire[7:0] xneg_ClockwiseUtil_6_0_3,xneg_CounterClockwiseUtil_6_0_3,xneg_InjectUtil_6_0_3;
	wire[7:0] ypos_ClockwiseUtil_6_0_3,ypos_CounterClockwiseUtil_6_0_3,ypos_InjectUtil_6_0_3;
	wire[7:0] yneg_ClockwiseUtil_6_0_3,yneg_CounterClockwiseUtil_6_0_3,yneg_InjectUtil_6_0_3;
	wire[7:0] zpos_ClockwiseUtil_6_0_3,zpos_CounterClockwiseUtil_6_0_3,zpos_InjectUtil_6_0_3;
	wire[7:0] zneg_ClockwiseUtil_6_0_3,zneg_CounterClockwiseUtil_6_0_3,zneg_InjectUtil_6_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_4, eject_xpos_ser_6_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_4, eject_xneg_ser_6_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_4, eject_ypos_ser_6_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_4, eject_yneg_ser_6_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_4, eject_zpos_ser_6_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_4, eject_zneg_ser_6_0_4;
	wire[7:0] xpos_ClockwiseUtil_6_0_4,xpos_CounterClockwiseUtil_6_0_4,xpos_InjectUtil_6_0_4;
	wire[7:0] xneg_ClockwiseUtil_6_0_4,xneg_CounterClockwiseUtil_6_0_4,xneg_InjectUtil_6_0_4;
	wire[7:0] ypos_ClockwiseUtil_6_0_4,ypos_CounterClockwiseUtil_6_0_4,ypos_InjectUtil_6_0_4;
	wire[7:0] yneg_ClockwiseUtil_6_0_4,yneg_CounterClockwiseUtil_6_0_4,yneg_InjectUtil_6_0_4;
	wire[7:0] zpos_ClockwiseUtil_6_0_4,zpos_CounterClockwiseUtil_6_0_4,zpos_InjectUtil_6_0_4;
	wire[7:0] zneg_ClockwiseUtil_6_0_4,zneg_CounterClockwiseUtil_6_0_4,zneg_InjectUtil_6_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_5, eject_xpos_ser_6_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_5, eject_xneg_ser_6_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_5, eject_ypos_ser_6_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_5, eject_yneg_ser_6_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_5, eject_zpos_ser_6_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_5, eject_zneg_ser_6_0_5;
	wire[7:0] xpos_ClockwiseUtil_6_0_5,xpos_CounterClockwiseUtil_6_0_5,xpos_InjectUtil_6_0_5;
	wire[7:0] xneg_ClockwiseUtil_6_0_5,xneg_CounterClockwiseUtil_6_0_5,xneg_InjectUtil_6_0_5;
	wire[7:0] ypos_ClockwiseUtil_6_0_5,ypos_CounterClockwiseUtil_6_0_5,ypos_InjectUtil_6_0_5;
	wire[7:0] yneg_ClockwiseUtil_6_0_5,yneg_CounterClockwiseUtil_6_0_5,yneg_InjectUtil_6_0_5;
	wire[7:0] zpos_ClockwiseUtil_6_0_5,zpos_CounterClockwiseUtil_6_0_5,zpos_InjectUtil_6_0_5;
	wire[7:0] zneg_ClockwiseUtil_6_0_5,zneg_CounterClockwiseUtil_6_0_5,zneg_InjectUtil_6_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_6, eject_xpos_ser_6_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_6, eject_xneg_ser_6_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_6, eject_ypos_ser_6_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_6, eject_yneg_ser_6_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_6, eject_zpos_ser_6_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_6, eject_zneg_ser_6_0_6;
	wire[7:0] xpos_ClockwiseUtil_6_0_6,xpos_CounterClockwiseUtil_6_0_6,xpos_InjectUtil_6_0_6;
	wire[7:0] xneg_ClockwiseUtil_6_0_6,xneg_CounterClockwiseUtil_6_0_6,xneg_InjectUtil_6_0_6;
	wire[7:0] ypos_ClockwiseUtil_6_0_6,ypos_CounterClockwiseUtil_6_0_6,ypos_InjectUtil_6_0_6;
	wire[7:0] yneg_ClockwiseUtil_6_0_6,yneg_CounterClockwiseUtil_6_0_6,yneg_InjectUtil_6_0_6;
	wire[7:0] zpos_ClockwiseUtil_6_0_6,zpos_CounterClockwiseUtil_6_0_6,zpos_InjectUtil_6_0_6;
	wire[7:0] zneg_ClockwiseUtil_6_0_6,zneg_CounterClockwiseUtil_6_0_6,zneg_InjectUtil_6_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_0_7, eject_xpos_ser_6_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_0_7, eject_xneg_ser_6_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_0_7, eject_ypos_ser_6_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_0_7, eject_yneg_ser_6_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_0_7, eject_zpos_ser_6_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_0_7, eject_zneg_ser_6_0_7;
	wire[7:0] xpos_ClockwiseUtil_6_0_7,xpos_CounterClockwiseUtil_6_0_7,xpos_InjectUtil_6_0_7;
	wire[7:0] xneg_ClockwiseUtil_6_0_7,xneg_CounterClockwiseUtil_6_0_7,xneg_InjectUtil_6_0_7;
	wire[7:0] ypos_ClockwiseUtil_6_0_7,ypos_CounterClockwiseUtil_6_0_7,ypos_InjectUtil_6_0_7;
	wire[7:0] yneg_ClockwiseUtil_6_0_7,yneg_CounterClockwiseUtil_6_0_7,yneg_InjectUtil_6_0_7;
	wire[7:0] zpos_ClockwiseUtil_6_0_7,zpos_CounterClockwiseUtil_6_0_7,zpos_InjectUtil_6_0_7;
	wire[7:0] zneg_ClockwiseUtil_6_0_7,zneg_CounterClockwiseUtil_6_0_7,zneg_InjectUtil_6_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_0, eject_xpos_ser_6_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_0, eject_xneg_ser_6_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_0, eject_ypos_ser_6_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_0, eject_yneg_ser_6_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_0, eject_zpos_ser_6_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_0, eject_zneg_ser_6_1_0;
	wire[7:0] xpos_ClockwiseUtil_6_1_0,xpos_CounterClockwiseUtil_6_1_0,xpos_InjectUtil_6_1_0;
	wire[7:0] xneg_ClockwiseUtil_6_1_0,xneg_CounterClockwiseUtil_6_1_0,xneg_InjectUtil_6_1_0;
	wire[7:0] ypos_ClockwiseUtil_6_1_0,ypos_CounterClockwiseUtil_6_1_0,ypos_InjectUtil_6_1_0;
	wire[7:0] yneg_ClockwiseUtil_6_1_0,yneg_CounterClockwiseUtil_6_1_0,yneg_InjectUtil_6_1_0;
	wire[7:0] zpos_ClockwiseUtil_6_1_0,zpos_CounterClockwiseUtil_6_1_0,zpos_InjectUtil_6_1_0;
	wire[7:0] zneg_ClockwiseUtil_6_1_0,zneg_CounterClockwiseUtil_6_1_0,zneg_InjectUtil_6_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_1, eject_xpos_ser_6_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_1, eject_xneg_ser_6_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_1, eject_ypos_ser_6_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_1, eject_yneg_ser_6_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_1, eject_zpos_ser_6_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_1, eject_zneg_ser_6_1_1;
	wire[7:0] xpos_ClockwiseUtil_6_1_1,xpos_CounterClockwiseUtil_6_1_1,xpos_InjectUtil_6_1_1;
	wire[7:0] xneg_ClockwiseUtil_6_1_1,xneg_CounterClockwiseUtil_6_1_1,xneg_InjectUtil_6_1_1;
	wire[7:0] ypos_ClockwiseUtil_6_1_1,ypos_CounterClockwiseUtil_6_1_1,ypos_InjectUtil_6_1_1;
	wire[7:0] yneg_ClockwiseUtil_6_1_1,yneg_CounterClockwiseUtil_6_1_1,yneg_InjectUtil_6_1_1;
	wire[7:0] zpos_ClockwiseUtil_6_1_1,zpos_CounterClockwiseUtil_6_1_1,zpos_InjectUtil_6_1_1;
	wire[7:0] zneg_ClockwiseUtil_6_1_1,zneg_CounterClockwiseUtil_6_1_1,zneg_InjectUtil_6_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_2, eject_xpos_ser_6_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_2, eject_xneg_ser_6_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_2, eject_ypos_ser_6_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_2, eject_yneg_ser_6_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_2, eject_zpos_ser_6_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_2, eject_zneg_ser_6_1_2;
	wire[7:0] xpos_ClockwiseUtil_6_1_2,xpos_CounterClockwiseUtil_6_1_2,xpos_InjectUtil_6_1_2;
	wire[7:0] xneg_ClockwiseUtil_6_1_2,xneg_CounterClockwiseUtil_6_1_2,xneg_InjectUtil_6_1_2;
	wire[7:0] ypos_ClockwiseUtil_6_1_2,ypos_CounterClockwiseUtil_6_1_2,ypos_InjectUtil_6_1_2;
	wire[7:0] yneg_ClockwiseUtil_6_1_2,yneg_CounterClockwiseUtil_6_1_2,yneg_InjectUtil_6_1_2;
	wire[7:0] zpos_ClockwiseUtil_6_1_2,zpos_CounterClockwiseUtil_6_1_2,zpos_InjectUtil_6_1_2;
	wire[7:0] zneg_ClockwiseUtil_6_1_2,zneg_CounterClockwiseUtil_6_1_2,zneg_InjectUtil_6_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_3, eject_xpos_ser_6_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_3, eject_xneg_ser_6_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_3, eject_ypos_ser_6_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_3, eject_yneg_ser_6_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_3, eject_zpos_ser_6_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_3, eject_zneg_ser_6_1_3;
	wire[7:0] xpos_ClockwiseUtil_6_1_3,xpos_CounterClockwiseUtil_6_1_3,xpos_InjectUtil_6_1_3;
	wire[7:0] xneg_ClockwiseUtil_6_1_3,xneg_CounterClockwiseUtil_6_1_3,xneg_InjectUtil_6_1_3;
	wire[7:0] ypos_ClockwiseUtil_6_1_3,ypos_CounterClockwiseUtil_6_1_3,ypos_InjectUtil_6_1_3;
	wire[7:0] yneg_ClockwiseUtil_6_1_3,yneg_CounterClockwiseUtil_6_1_3,yneg_InjectUtil_6_1_3;
	wire[7:0] zpos_ClockwiseUtil_6_1_3,zpos_CounterClockwiseUtil_6_1_3,zpos_InjectUtil_6_1_3;
	wire[7:0] zneg_ClockwiseUtil_6_1_3,zneg_CounterClockwiseUtil_6_1_3,zneg_InjectUtil_6_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_4, eject_xpos_ser_6_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_4, eject_xneg_ser_6_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_4, eject_ypos_ser_6_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_4, eject_yneg_ser_6_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_4, eject_zpos_ser_6_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_4, eject_zneg_ser_6_1_4;
	wire[7:0] xpos_ClockwiseUtil_6_1_4,xpos_CounterClockwiseUtil_6_1_4,xpos_InjectUtil_6_1_4;
	wire[7:0] xneg_ClockwiseUtil_6_1_4,xneg_CounterClockwiseUtil_6_1_4,xneg_InjectUtil_6_1_4;
	wire[7:0] ypos_ClockwiseUtil_6_1_4,ypos_CounterClockwiseUtil_6_1_4,ypos_InjectUtil_6_1_4;
	wire[7:0] yneg_ClockwiseUtil_6_1_4,yneg_CounterClockwiseUtil_6_1_4,yneg_InjectUtil_6_1_4;
	wire[7:0] zpos_ClockwiseUtil_6_1_4,zpos_CounterClockwiseUtil_6_1_4,zpos_InjectUtil_6_1_4;
	wire[7:0] zneg_ClockwiseUtil_6_1_4,zneg_CounterClockwiseUtil_6_1_4,zneg_InjectUtil_6_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_5, eject_xpos_ser_6_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_5, eject_xneg_ser_6_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_5, eject_ypos_ser_6_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_5, eject_yneg_ser_6_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_5, eject_zpos_ser_6_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_5, eject_zneg_ser_6_1_5;
	wire[7:0] xpos_ClockwiseUtil_6_1_5,xpos_CounterClockwiseUtil_6_1_5,xpos_InjectUtil_6_1_5;
	wire[7:0] xneg_ClockwiseUtil_6_1_5,xneg_CounterClockwiseUtil_6_1_5,xneg_InjectUtil_6_1_5;
	wire[7:0] ypos_ClockwiseUtil_6_1_5,ypos_CounterClockwiseUtil_6_1_5,ypos_InjectUtil_6_1_5;
	wire[7:0] yneg_ClockwiseUtil_6_1_5,yneg_CounterClockwiseUtil_6_1_5,yneg_InjectUtil_6_1_5;
	wire[7:0] zpos_ClockwiseUtil_6_1_5,zpos_CounterClockwiseUtil_6_1_5,zpos_InjectUtil_6_1_5;
	wire[7:0] zneg_ClockwiseUtil_6_1_5,zneg_CounterClockwiseUtil_6_1_5,zneg_InjectUtil_6_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_6, eject_xpos_ser_6_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_6, eject_xneg_ser_6_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_6, eject_ypos_ser_6_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_6, eject_yneg_ser_6_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_6, eject_zpos_ser_6_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_6, eject_zneg_ser_6_1_6;
	wire[7:0] xpos_ClockwiseUtil_6_1_6,xpos_CounterClockwiseUtil_6_1_6,xpos_InjectUtil_6_1_6;
	wire[7:0] xneg_ClockwiseUtil_6_1_6,xneg_CounterClockwiseUtil_6_1_6,xneg_InjectUtil_6_1_6;
	wire[7:0] ypos_ClockwiseUtil_6_1_6,ypos_CounterClockwiseUtil_6_1_6,ypos_InjectUtil_6_1_6;
	wire[7:0] yneg_ClockwiseUtil_6_1_6,yneg_CounterClockwiseUtil_6_1_6,yneg_InjectUtil_6_1_6;
	wire[7:0] zpos_ClockwiseUtil_6_1_6,zpos_CounterClockwiseUtil_6_1_6,zpos_InjectUtil_6_1_6;
	wire[7:0] zneg_ClockwiseUtil_6_1_6,zneg_CounterClockwiseUtil_6_1_6,zneg_InjectUtil_6_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_1_7, eject_xpos_ser_6_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_1_7, eject_xneg_ser_6_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_1_7, eject_ypos_ser_6_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_1_7, eject_yneg_ser_6_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_1_7, eject_zpos_ser_6_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_1_7, eject_zneg_ser_6_1_7;
	wire[7:0] xpos_ClockwiseUtil_6_1_7,xpos_CounterClockwiseUtil_6_1_7,xpos_InjectUtil_6_1_7;
	wire[7:0] xneg_ClockwiseUtil_6_1_7,xneg_CounterClockwiseUtil_6_1_7,xneg_InjectUtil_6_1_7;
	wire[7:0] ypos_ClockwiseUtil_6_1_7,ypos_CounterClockwiseUtil_6_1_7,ypos_InjectUtil_6_1_7;
	wire[7:0] yneg_ClockwiseUtil_6_1_7,yneg_CounterClockwiseUtil_6_1_7,yneg_InjectUtil_6_1_7;
	wire[7:0] zpos_ClockwiseUtil_6_1_7,zpos_CounterClockwiseUtil_6_1_7,zpos_InjectUtil_6_1_7;
	wire[7:0] zneg_ClockwiseUtil_6_1_7,zneg_CounterClockwiseUtil_6_1_7,zneg_InjectUtil_6_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_0, eject_xpos_ser_6_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_0, eject_xneg_ser_6_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_0, eject_ypos_ser_6_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_0, eject_yneg_ser_6_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_0, eject_zpos_ser_6_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_0, eject_zneg_ser_6_2_0;
	wire[7:0] xpos_ClockwiseUtil_6_2_0,xpos_CounterClockwiseUtil_6_2_0,xpos_InjectUtil_6_2_0;
	wire[7:0] xneg_ClockwiseUtil_6_2_0,xneg_CounterClockwiseUtil_6_2_0,xneg_InjectUtil_6_2_0;
	wire[7:0] ypos_ClockwiseUtil_6_2_0,ypos_CounterClockwiseUtil_6_2_0,ypos_InjectUtil_6_2_0;
	wire[7:0] yneg_ClockwiseUtil_6_2_0,yneg_CounterClockwiseUtil_6_2_0,yneg_InjectUtil_6_2_0;
	wire[7:0] zpos_ClockwiseUtil_6_2_0,zpos_CounterClockwiseUtil_6_2_0,zpos_InjectUtil_6_2_0;
	wire[7:0] zneg_ClockwiseUtil_6_2_0,zneg_CounterClockwiseUtil_6_2_0,zneg_InjectUtil_6_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_1, eject_xpos_ser_6_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_1, eject_xneg_ser_6_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_1, eject_ypos_ser_6_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_1, eject_yneg_ser_6_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_1, eject_zpos_ser_6_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_1, eject_zneg_ser_6_2_1;
	wire[7:0] xpos_ClockwiseUtil_6_2_1,xpos_CounterClockwiseUtil_6_2_1,xpos_InjectUtil_6_2_1;
	wire[7:0] xneg_ClockwiseUtil_6_2_1,xneg_CounterClockwiseUtil_6_2_1,xneg_InjectUtil_6_2_1;
	wire[7:0] ypos_ClockwiseUtil_6_2_1,ypos_CounterClockwiseUtil_6_2_1,ypos_InjectUtil_6_2_1;
	wire[7:0] yneg_ClockwiseUtil_6_2_1,yneg_CounterClockwiseUtil_6_2_1,yneg_InjectUtil_6_2_1;
	wire[7:0] zpos_ClockwiseUtil_6_2_1,zpos_CounterClockwiseUtil_6_2_1,zpos_InjectUtil_6_2_1;
	wire[7:0] zneg_ClockwiseUtil_6_2_1,zneg_CounterClockwiseUtil_6_2_1,zneg_InjectUtil_6_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_2, eject_xpos_ser_6_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_2, eject_xneg_ser_6_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_2, eject_ypos_ser_6_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_2, eject_yneg_ser_6_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_2, eject_zpos_ser_6_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_2, eject_zneg_ser_6_2_2;
	wire[7:0] xpos_ClockwiseUtil_6_2_2,xpos_CounterClockwiseUtil_6_2_2,xpos_InjectUtil_6_2_2;
	wire[7:0] xneg_ClockwiseUtil_6_2_2,xneg_CounterClockwiseUtil_6_2_2,xneg_InjectUtil_6_2_2;
	wire[7:0] ypos_ClockwiseUtil_6_2_2,ypos_CounterClockwiseUtil_6_2_2,ypos_InjectUtil_6_2_2;
	wire[7:0] yneg_ClockwiseUtil_6_2_2,yneg_CounterClockwiseUtil_6_2_2,yneg_InjectUtil_6_2_2;
	wire[7:0] zpos_ClockwiseUtil_6_2_2,zpos_CounterClockwiseUtil_6_2_2,zpos_InjectUtil_6_2_2;
	wire[7:0] zneg_ClockwiseUtil_6_2_2,zneg_CounterClockwiseUtil_6_2_2,zneg_InjectUtil_6_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_3, eject_xpos_ser_6_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_3, eject_xneg_ser_6_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_3, eject_ypos_ser_6_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_3, eject_yneg_ser_6_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_3, eject_zpos_ser_6_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_3, eject_zneg_ser_6_2_3;
	wire[7:0] xpos_ClockwiseUtil_6_2_3,xpos_CounterClockwiseUtil_6_2_3,xpos_InjectUtil_6_2_3;
	wire[7:0] xneg_ClockwiseUtil_6_2_3,xneg_CounterClockwiseUtil_6_2_3,xneg_InjectUtil_6_2_3;
	wire[7:0] ypos_ClockwiseUtil_6_2_3,ypos_CounterClockwiseUtil_6_2_3,ypos_InjectUtil_6_2_3;
	wire[7:0] yneg_ClockwiseUtil_6_2_3,yneg_CounterClockwiseUtil_6_2_3,yneg_InjectUtil_6_2_3;
	wire[7:0] zpos_ClockwiseUtil_6_2_3,zpos_CounterClockwiseUtil_6_2_3,zpos_InjectUtil_6_2_3;
	wire[7:0] zneg_ClockwiseUtil_6_2_3,zneg_CounterClockwiseUtil_6_2_3,zneg_InjectUtil_6_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_4, eject_xpos_ser_6_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_4, eject_xneg_ser_6_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_4, eject_ypos_ser_6_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_4, eject_yneg_ser_6_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_4, eject_zpos_ser_6_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_4, eject_zneg_ser_6_2_4;
	wire[7:0] xpos_ClockwiseUtil_6_2_4,xpos_CounterClockwiseUtil_6_2_4,xpos_InjectUtil_6_2_4;
	wire[7:0] xneg_ClockwiseUtil_6_2_4,xneg_CounterClockwiseUtil_6_2_4,xneg_InjectUtil_6_2_4;
	wire[7:0] ypos_ClockwiseUtil_6_2_4,ypos_CounterClockwiseUtil_6_2_4,ypos_InjectUtil_6_2_4;
	wire[7:0] yneg_ClockwiseUtil_6_2_4,yneg_CounterClockwiseUtil_6_2_4,yneg_InjectUtil_6_2_4;
	wire[7:0] zpos_ClockwiseUtil_6_2_4,zpos_CounterClockwiseUtil_6_2_4,zpos_InjectUtil_6_2_4;
	wire[7:0] zneg_ClockwiseUtil_6_2_4,zneg_CounterClockwiseUtil_6_2_4,zneg_InjectUtil_6_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_5, eject_xpos_ser_6_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_5, eject_xneg_ser_6_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_5, eject_ypos_ser_6_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_5, eject_yneg_ser_6_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_5, eject_zpos_ser_6_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_5, eject_zneg_ser_6_2_5;
	wire[7:0] xpos_ClockwiseUtil_6_2_5,xpos_CounterClockwiseUtil_6_2_5,xpos_InjectUtil_6_2_5;
	wire[7:0] xneg_ClockwiseUtil_6_2_5,xneg_CounterClockwiseUtil_6_2_5,xneg_InjectUtil_6_2_5;
	wire[7:0] ypos_ClockwiseUtil_6_2_5,ypos_CounterClockwiseUtil_6_2_5,ypos_InjectUtil_6_2_5;
	wire[7:0] yneg_ClockwiseUtil_6_2_5,yneg_CounterClockwiseUtil_6_2_5,yneg_InjectUtil_6_2_5;
	wire[7:0] zpos_ClockwiseUtil_6_2_5,zpos_CounterClockwiseUtil_6_2_5,zpos_InjectUtil_6_2_5;
	wire[7:0] zneg_ClockwiseUtil_6_2_5,zneg_CounterClockwiseUtil_6_2_5,zneg_InjectUtil_6_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_6, eject_xpos_ser_6_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_6, eject_xneg_ser_6_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_6, eject_ypos_ser_6_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_6, eject_yneg_ser_6_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_6, eject_zpos_ser_6_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_6, eject_zneg_ser_6_2_6;
	wire[7:0] xpos_ClockwiseUtil_6_2_6,xpos_CounterClockwiseUtil_6_2_6,xpos_InjectUtil_6_2_6;
	wire[7:0] xneg_ClockwiseUtil_6_2_6,xneg_CounterClockwiseUtil_6_2_6,xneg_InjectUtil_6_2_6;
	wire[7:0] ypos_ClockwiseUtil_6_2_6,ypos_CounterClockwiseUtil_6_2_6,ypos_InjectUtil_6_2_6;
	wire[7:0] yneg_ClockwiseUtil_6_2_6,yneg_CounterClockwiseUtil_6_2_6,yneg_InjectUtil_6_2_6;
	wire[7:0] zpos_ClockwiseUtil_6_2_6,zpos_CounterClockwiseUtil_6_2_6,zpos_InjectUtil_6_2_6;
	wire[7:0] zneg_ClockwiseUtil_6_2_6,zneg_CounterClockwiseUtil_6_2_6,zneg_InjectUtil_6_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_2_7, eject_xpos_ser_6_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_2_7, eject_xneg_ser_6_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_2_7, eject_ypos_ser_6_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_2_7, eject_yneg_ser_6_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_2_7, eject_zpos_ser_6_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_2_7, eject_zneg_ser_6_2_7;
	wire[7:0] xpos_ClockwiseUtil_6_2_7,xpos_CounterClockwiseUtil_6_2_7,xpos_InjectUtil_6_2_7;
	wire[7:0] xneg_ClockwiseUtil_6_2_7,xneg_CounterClockwiseUtil_6_2_7,xneg_InjectUtil_6_2_7;
	wire[7:0] ypos_ClockwiseUtil_6_2_7,ypos_CounterClockwiseUtil_6_2_7,ypos_InjectUtil_6_2_7;
	wire[7:0] yneg_ClockwiseUtil_6_2_7,yneg_CounterClockwiseUtil_6_2_7,yneg_InjectUtil_6_2_7;
	wire[7:0] zpos_ClockwiseUtil_6_2_7,zpos_CounterClockwiseUtil_6_2_7,zpos_InjectUtil_6_2_7;
	wire[7:0] zneg_ClockwiseUtil_6_2_7,zneg_CounterClockwiseUtil_6_2_7,zneg_InjectUtil_6_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_0, eject_xpos_ser_6_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_0, eject_xneg_ser_6_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_0, eject_ypos_ser_6_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_0, eject_yneg_ser_6_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_0, eject_zpos_ser_6_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_0, eject_zneg_ser_6_3_0;
	wire[7:0] xpos_ClockwiseUtil_6_3_0,xpos_CounterClockwiseUtil_6_3_0,xpos_InjectUtil_6_3_0;
	wire[7:0] xneg_ClockwiseUtil_6_3_0,xneg_CounterClockwiseUtil_6_3_0,xneg_InjectUtil_6_3_0;
	wire[7:0] ypos_ClockwiseUtil_6_3_0,ypos_CounterClockwiseUtil_6_3_0,ypos_InjectUtil_6_3_0;
	wire[7:0] yneg_ClockwiseUtil_6_3_0,yneg_CounterClockwiseUtil_6_3_0,yneg_InjectUtil_6_3_0;
	wire[7:0] zpos_ClockwiseUtil_6_3_0,zpos_CounterClockwiseUtil_6_3_0,zpos_InjectUtil_6_3_0;
	wire[7:0] zneg_ClockwiseUtil_6_3_0,zneg_CounterClockwiseUtil_6_3_0,zneg_InjectUtil_6_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_1, eject_xpos_ser_6_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_1, eject_xneg_ser_6_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_1, eject_ypos_ser_6_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_1, eject_yneg_ser_6_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_1, eject_zpos_ser_6_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_1, eject_zneg_ser_6_3_1;
	wire[7:0] xpos_ClockwiseUtil_6_3_1,xpos_CounterClockwiseUtil_6_3_1,xpos_InjectUtil_6_3_1;
	wire[7:0] xneg_ClockwiseUtil_6_3_1,xneg_CounterClockwiseUtil_6_3_1,xneg_InjectUtil_6_3_1;
	wire[7:0] ypos_ClockwiseUtil_6_3_1,ypos_CounterClockwiseUtil_6_3_1,ypos_InjectUtil_6_3_1;
	wire[7:0] yneg_ClockwiseUtil_6_3_1,yneg_CounterClockwiseUtil_6_3_1,yneg_InjectUtil_6_3_1;
	wire[7:0] zpos_ClockwiseUtil_6_3_1,zpos_CounterClockwiseUtil_6_3_1,zpos_InjectUtil_6_3_1;
	wire[7:0] zneg_ClockwiseUtil_6_3_1,zneg_CounterClockwiseUtil_6_3_1,zneg_InjectUtil_6_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_2, eject_xpos_ser_6_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_2, eject_xneg_ser_6_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_2, eject_ypos_ser_6_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_2, eject_yneg_ser_6_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_2, eject_zpos_ser_6_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_2, eject_zneg_ser_6_3_2;
	wire[7:0] xpos_ClockwiseUtil_6_3_2,xpos_CounterClockwiseUtil_6_3_2,xpos_InjectUtil_6_3_2;
	wire[7:0] xneg_ClockwiseUtil_6_3_2,xneg_CounterClockwiseUtil_6_3_2,xneg_InjectUtil_6_3_2;
	wire[7:0] ypos_ClockwiseUtil_6_3_2,ypos_CounterClockwiseUtil_6_3_2,ypos_InjectUtil_6_3_2;
	wire[7:0] yneg_ClockwiseUtil_6_3_2,yneg_CounterClockwiseUtil_6_3_2,yneg_InjectUtil_6_3_2;
	wire[7:0] zpos_ClockwiseUtil_6_3_2,zpos_CounterClockwiseUtil_6_3_2,zpos_InjectUtil_6_3_2;
	wire[7:0] zneg_ClockwiseUtil_6_3_2,zneg_CounterClockwiseUtil_6_3_2,zneg_InjectUtil_6_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_3, eject_xpos_ser_6_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_3, eject_xneg_ser_6_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_3, eject_ypos_ser_6_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_3, eject_yneg_ser_6_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_3, eject_zpos_ser_6_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_3, eject_zneg_ser_6_3_3;
	wire[7:0] xpos_ClockwiseUtil_6_3_3,xpos_CounterClockwiseUtil_6_3_3,xpos_InjectUtil_6_3_3;
	wire[7:0] xneg_ClockwiseUtil_6_3_3,xneg_CounterClockwiseUtil_6_3_3,xneg_InjectUtil_6_3_3;
	wire[7:0] ypos_ClockwiseUtil_6_3_3,ypos_CounterClockwiseUtil_6_3_3,ypos_InjectUtil_6_3_3;
	wire[7:0] yneg_ClockwiseUtil_6_3_3,yneg_CounterClockwiseUtil_6_3_3,yneg_InjectUtil_6_3_3;
	wire[7:0] zpos_ClockwiseUtil_6_3_3,zpos_CounterClockwiseUtil_6_3_3,zpos_InjectUtil_6_3_3;
	wire[7:0] zneg_ClockwiseUtil_6_3_3,zneg_CounterClockwiseUtil_6_3_3,zneg_InjectUtil_6_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_4, eject_xpos_ser_6_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_4, eject_xneg_ser_6_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_4, eject_ypos_ser_6_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_4, eject_yneg_ser_6_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_4, eject_zpos_ser_6_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_4, eject_zneg_ser_6_3_4;
	wire[7:0] xpos_ClockwiseUtil_6_3_4,xpos_CounterClockwiseUtil_6_3_4,xpos_InjectUtil_6_3_4;
	wire[7:0] xneg_ClockwiseUtil_6_3_4,xneg_CounterClockwiseUtil_6_3_4,xneg_InjectUtil_6_3_4;
	wire[7:0] ypos_ClockwiseUtil_6_3_4,ypos_CounterClockwiseUtil_6_3_4,ypos_InjectUtil_6_3_4;
	wire[7:0] yneg_ClockwiseUtil_6_3_4,yneg_CounterClockwiseUtil_6_3_4,yneg_InjectUtil_6_3_4;
	wire[7:0] zpos_ClockwiseUtil_6_3_4,zpos_CounterClockwiseUtil_6_3_4,zpos_InjectUtil_6_3_4;
	wire[7:0] zneg_ClockwiseUtil_6_3_4,zneg_CounterClockwiseUtil_6_3_4,zneg_InjectUtil_6_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_5, eject_xpos_ser_6_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_5, eject_xneg_ser_6_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_5, eject_ypos_ser_6_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_5, eject_yneg_ser_6_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_5, eject_zpos_ser_6_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_5, eject_zneg_ser_6_3_5;
	wire[7:0] xpos_ClockwiseUtil_6_3_5,xpos_CounterClockwiseUtil_6_3_5,xpos_InjectUtil_6_3_5;
	wire[7:0] xneg_ClockwiseUtil_6_3_5,xneg_CounterClockwiseUtil_6_3_5,xneg_InjectUtil_6_3_5;
	wire[7:0] ypos_ClockwiseUtil_6_3_5,ypos_CounterClockwiseUtil_6_3_5,ypos_InjectUtil_6_3_5;
	wire[7:0] yneg_ClockwiseUtil_6_3_5,yneg_CounterClockwiseUtil_6_3_5,yneg_InjectUtil_6_3_5;
	wire[7:0] zpos_ClockwiseUtil_6_3_5,zpos_CounterClockwiseUtil_6_3_5,zpos_InjectUtil_6_3_5;
	wire[7:0] zneg_ClockwiseUtil_6_3_5,zneg_CounterClockwiseUtil_6_3_5,zneg_InjectUtil_6_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_6, eject_xpos_ser_6_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_6, eject_xneg_ser_6_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_6, eject_ypos_ser_6_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_6, eject_yneg_ser_6_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_6, eject_zpos_ser_6_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_6, eject_zneg_ser_6_3_6;
	wire[7:0] xpos_ClockwiseUtil_6_3_6,xpos_CounterClockwiseUtil_6_3_6,xpos_InjectUtil_6_3_6;
	wire[7:0] xneg_ClockwiseUtil_6_3_6,xneg_CounterClockwiseUtil_6_3_6,xneg_InjectUtil_6_3_6;
	wire[7:0] ypos_ClockwiseUtil_6_3_6,ypos_CounterClockwiseUtil_6_3_6,ypos_InjectUtil_6_3_6;
	wire[7:0] yneg_ClockwiseUtil_6_3_6,yneg_CounterClockwiseUtil_6_3_6,yneg_InjectUtil_6_3_6;
	wire[7:0] zpos_ClockwiseUtil_6_3_6,zpos_CounterClockwiseUtil_6_3_6,zpos_InjectUtil_6_3_6;
	wire[7:0] zneg_ClockwiseUtil_6_3_6,zneg_CounterClockwiseUtil_6_3_6,zneg_InjectUtil_6_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_3_7, eject_xpos_ser_6_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_3_7, eject_xneg_ser_6_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_3_7, eject_ypos_ser_6_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_3_7, eject_yneg_ser_6_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_3_7, eject_zpos_ser_6_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_3_7, eject_zneg_ser_6_3_7;
	wire[7:0] xpos_ClockwiseUtil_6_3_7,xpos_CounterClockwiseUtil_6_3_7,xpos_InjectUtil_6_3_7;
	wire[7:0] xneg_ClockwiseUtil_6_3_7,xneg_CounterClockwiseUtil_6_3_7,xneg_InjectUtil_6_3_7;
	wire[7:0] ypos_ClockwiseUtil_6_3_7,ypos_CounterClockwiseUtil_6_3_7,ypos_InjectUtil_6_3_7;
	wire[7:0] yneg_ClockwiseUtil_6_3_7,yneg_CounterClockwiseUtil_6_3_7,yneg_InjectUtil_6_3_7;
	wire[7:0] zpos_ClockwiseUtil_6_3_7,zpos_CounterClockwiseUtil_6_3_7,zpos_InjectUtil_6_3_7;
	wire[7:0] zneg_ClockwiseUtil_6_3_7,zneg_CounterClockwiseUtil_6_3_7,zneg_InjectUtil_6_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_0, eject_xpos_ser_6_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_0, eject_xneg_ser_6_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_0, eject_ypos_ser_6_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_0, eject_yneg_ser_6_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_0, eject_zpos_ser_6_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_0, eject_zneg_ser_6_4_0;
	wire[7:0] xpos_ClockwiseUtil_6_4_0,xpos_CounterClockwiseUtil_6_4_0,xpos_InjectUtil_6_4_0;
	wire[7:0] xneg_ClockwiseUtil_6_4_0,xneg_CounterClockwiseUtil_6_4_0,xneg_InjectUtil_6_4_0;
	wire[7:0] ypos_ClockwiseUtil_6_4_0,ypos_CounterClockwiseUtil_6_4_0,ypos_InjectUtil_6_4_0;
	wire[7:0] yneg_ClockwiseUtil_6_4_0,yneg_CounterClockwiseUtil_6_4_0,yneg_InjectUtil_6_4_0;
	wire[7:0] zpos_ClockwiseUtil_6_4_0,zpos_CounterClockwiseUtil_6_4_0,zpos_InjectUtil_6_4_0;
	wire[7:0] zneg_ClockwiseUtil_6_4_0,zneg_CounterClockwiseUtil_6_4_0,zneg_InjectUtil_6_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_1, eject_xpos_ser_6_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_1, eject_xneg_ser_6_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_1, eject_ypos_ser_6_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_1, eject_yneg_ser_6_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_1, eject_zpos_ser_6_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_1, eject_zneg_ser_6_4_1;
	wire[7:0] xpos_ClockwiseUtil_6_4_1,xpos_CounterClockwiseUtil_6_4_1,xpos_InjectUtil_6_4_1;
	wire[7:0] xneg_ClockwiseUtil_6_4_1,xneg_CounterClockwiseUtil_6_4_1,xneg_InjectUtil_6_4_1;
	wire[7:0] ypos_ClockwiseUtil_6_4_1,ypos_CounterClockwiseUtil_6_4_1,ypos_InjectUtil_6_4_1;
	wire[7:0] yneg_ClockwiseUtil_6_4_1,yneg_CounterClockwiseUtil_6_4_1,yneg_InjectUtil_6_4_1;
	wire[7:0] zpos_ClockwiseUtil_6_4_1,zpos_CounterClockwiseUtil_6_4_1,zpos_InjectUtil_6_4_1;
	wire[7:0] zneg_ClockwiseUtil_6_4_1,zneg_CounterClockwiseUtil_6_4_1,zneg_InjectUtil_6_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_2, eject_xpos_ser_6_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_2, eject_xneg_ser_6_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_2, eject_ypos_ser_6_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_2, eject_yneg_ser_6_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_2, eject_zpos_ser_6_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_2, eject_zneg_ser_6_4_2;
	wire[7:0] xpos_ClockwiseUtil_6_4_2,xpos_CounterClockwiseUtil_6_4_2,xpos_InjectUtil_6_4_2;
	wire[7:0] xneg_ClockwiseUtil_6_4_2,xneg_CounterClockwiseUtil_6_4_2,xneg_InjectUtil_6_4_2;
	wire[7:0] ypos_ClockwiseUtil_6_4_2,ypos_CounterClockwiseUtil_6_4_2,ypos_InjectUtil_6_4_2;
	wire[7:0] yneg_ClockwiseUtil_6_4_2,yneg_CounterClockwiseUtil_6_4_2,yneg_InjectUtil_6_4_2;
	wire[7:0] zpos_ClockwiseUtil_6_4_2,zpos_CounterClockwiseUtil_6_4_2,zpos_InjectUtil_6_4_2;
	wire[7:0] zneg_ClockwiseUtil_6_4_2,zneg_CounterClockwiseUtil_6_4_2,zneg_InjectUtil_6_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_3, eject_xpos_ser_6_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_3, eject_xneg_ser_6_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_3, eject_ypos_ser_6_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_3, eject_yneg_ser_6_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_3, eject_zpos_ser_6_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_3, eject_zneg_ser_6_4_3;
	wire[7:0] xpos_ClockwiseUtil_6_4_3,xpos_CounterClockwiseUtil_6_4_3,xpos_InjectUtil_6_4_3;
	wire[7:0] xneg_ClockwiseUtil_6_4_3,xneg_CounterClockwiseUtil_6_4_3,xneg_InjectUtil_6_4_3;
	wire[7:0] ypos_ClockwiseUtil_6_4_3,ypos_CounterClockwiseUtil_6_4_3,ypos_InjectUtil_6_4_3;
	wire[7:0] yneg_ClockwiseUtil_6_4_3,yneg_CounterClockwiseUtil_6_4_3,yneg_InjectUtil_6_4_3;
	wire[7:0] zpos_ClockwiseUtil_6_4_3,zpos_CounterClockwiseUtil_6_4_3,zpos_InjectUtil_6_4_3;
	wire[7:0] zneg_ClockwiseUtil_6_4_3,zneg_CounterClockwiseUtil_6_4_3,zneg_InjectUtil_6_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_4, eject_xpos_ser_6_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_4, eject_xneg_ser_6_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_4, eject_ypos_ser_6_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_4, eject_yneg_ser_6_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_4, eject_zpos_ser_6_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_4, eject_zneg_ser_6_4_4;
	wire[7:0] xpos_ClockwiseUtil_6_4_4,xpos_CounterClockwiseUtil_6_4_4,xpos_InjectUtil_6_4_4;
	wire[7:0] xneg_ClockwiseUtil_6_4_4,xneg_CounterClockwiseUtil_6_4_4,xneg_InjectUtil_6_4_4;
	wire[7:0] ypos_ClockwiseUtil_6_4_4,ypos_CounterClockwiseUtil_6_4_4,ypos_InjectUtil_6_4_4;
	wire[7:0] yneg_ClockwiseUtil_6_4_4,yneg_CounterClockwiseUtil_6_4_4,yneg_InjectUtil_6_4_4;
	wire[7:0] zpos_ClockwiseUtil_6_4_4,zpos_CounterClockwiseUtil_6_4_4,zpos_InjectUtil_6_4_4;
	wire[7:0] zneg_ClockwiseUtil_6_4_4,zneg_CounterClockwiseUtil_6_4_4,zneg_InjectUtil_6_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_5, eject_xpos_ser_6_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_5, eject_xneg_ser_6_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_5, eject_ypos_ser_6_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_5, eject_yneg_ser_6_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_5, eject_zpos_ser_6_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_5, eject_zneg_ser_6_4_5;
	wire[7:0] xpos_ClockwiseUtil_6_4_5,xpos_CounterClockwiseUtil_6_4_5,xpos_InjectUtil_6_4_5;
	wire[7:0] xneg_ClockwiseUtil_6_4_5,xneg_CounterClockwiseUtil_6_4_5,xneg_InjectUtil_6_4_5;
	wire[7:0] ypos_ClockwiseUtil_6_4_5,ypos_CounterClockwiseUtil_6_4_5,ypos_InjectUtil_6_4_5;
	wire[7:0] yneg_ClockwiseUtil_6_4_5,yneg_CounterClockwiseUtil_6_4_5,yneg_InjectUtil_6_4_5;
	wire[7:0] zpos_ClockwiseUtil_6_4_5,zpos_CounterClockwiseUtil_6_4_5,zpos_InjectUtil_6_4_5;
	wire[7:0] zneg_ClockwiseUtil_6_4_5,zneg_CounterClockwiseUtil_6_4_5,zneg_InjectUtil_6_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_6, eject_xpos_ser_6_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_6, eject_xneg_ser_6_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_6, eject_ypos_ser_6_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_6, eject_yneg_ser_6_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_6, eject_zpos_ser_6_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_6, eject_zneg_ser_6_4_6;
	wire[7:0] xpos_ClockwiseUtil_6_4_6,xpos_CounterClockwiseUtil_6_4_6,xpos_InjectUtil_6_4_6;
	wire[7:0] xneg_ClockwiseUtil_6_4_6,xneg_CounterClockwiseUtil_6_4_6,xneg_InjectUtil_6_4_6;
	wire[7:0] ypos_ClockwiseUtil_6_4_6,ypos_CounterClockwiseUtil_6_4_6,ypos_InjectUtil_6_4_6;
	wire[7:0] yneg_ClockwiseUtil_6_4_6,yneg_CounterClockwiseUtil_6_4_6,yneg_InjectUtil_6_4_6;
	wire[7:0] zpos_ClockwiseUtil_6_4_6,zpos_CounterClockwiseUtil_6_4_6,zpos_InjectUtil_6_4_6;
	wire[7:0] zneg_ClockwiseUtil_6_4_6,zneg_CounterClockwiseUtil_6_4_6,zneg_InjectUtil_6_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_4_7, eject_xpos_ser_6_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_4_7, eject_xneg_ser_6_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_4_7, eject_ypos_ser_6_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_4_7, eject_yneg_ser_6_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_4_7, eject_zpos_ser_6_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_4_7, eject_zneg_ser_6_4_7;
	wire[7:0] xpos_ClockwiseUtil_6_4_7,xpos_CounterClockwiseUtil_6_4_7,xpos_InjectUtil_6_4_7;
	wire[7:0] xneg_ClockwiseUtil_6_4_7,xneg_CounterClockwiseUtil_6_4_7,xneg_InjectUtil_6_4_7;
	wire[7:0] ypos_ClockwiseUtil_6_4_7,ypos_CounterClockwiseUtil_6_4_7,ypos_InjectUtil_6_4_7;
	wire[7:0] yneg_ClockwiseUtil_6_4_7,yneg_CounterClockwiseUtil_6_4_7,yneg_InjectUtil_6_4_7;
	wire[7:0] zpos_ClockwiseUtil_6_4_7,zpos_CounterClockwiseUtil_6_4_7,zpos_InjectUtil_6_4_7;
	wire[7:0] zneg_ClockwiseUtil_6_4_7,zneg_CounterClockwiseUtil_6_4_7,zneg_InjectUtil_6_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_0, eject_xpos_ser_6_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_0, eject_xneg_ser_6_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_0, eject_ypos_ser_6_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_0, eject_yneg_ser_6_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_0, eject_zpos_ser_6_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_0, eject_zneg_ser_6_5_0;
	wire[7:0] xpos_ClockwiseUtil_6_5_0,xpos_CounterClockwiseUtil_6_5_0,xpos_InjectUtil_6_5_0;
	wire[7:0] xneg_ClockwiseUtil_6_5_0,xneg_CounterClockwiseUtil_6_5_0,xneg_InjectUtil_6_5_0;
	wire[7:0] ypos_ClockwiseUtil_6_5_0,ypos_CounterClockwiseUtil_6_5_0,ypos_InjectUtil_6_5_0;
	wire[7:0] yneg_ClockwiseUtil_6_5_0,yneg_CounterClockwiseUtil_6_5_0,yneg_InjectUtil_6_5_0;
	wire[7:0] zpos_ClockwiseUtil_6_5_0,zpos_CounterClockwiseUtil_6_5_0,zpos_InjectUtil_6_5_0;
	wire[7:0] zneg_ClockwiseUtil_6_5_0,zneg_CounterClockwiseUtil_6_5_0,zneg_InjectUtil_6_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_1, eject_xpos_ser_6_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_1, eject_xneg_ser_6_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_1, eject_ypos_ser_6_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_1, eject_yneg_ser_6_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_1, eject_zpos_ser_6_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_1, eject_zneg_ser_6_5_1;
	wire[7:0] xpos_ClockwiseUtil_6_5_1,xpos_CounterClockwiseUtil_6_5_1,xpos_InjectUtil_6_5_1;
	wire[7:0] xneg_ClockwiseUtil_6_5_1,xneg_CounterClockwiseUtil_6_5_1,xneg_InjectUtil_6_5_1;
	wire[7:0] ypos_ClockwiseUtil_6_5_1,ypos_CounterClockwiseUtil_6_5_1,ypos_InjectUtil_6_5_1;
	wire[7:0] yneg_ClockwiseUtil_6_5_1,yneg_CounterClockwiseUtil_6_5_1,yneg_InjectUtil_6_5_1;
	wire[7:0] zpos_ClockwiseUtil_6_5_1,zpos_CounterClockwiseUtil_6_5_1,zpos_InjectUtil_6_5_1;
	wire[7:0] zneg_ClockwiseUtil_6_5_1,zneg_CounterClockwiseUtil_6_5_1,zneg_InjectUtil_6_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_2, eject_xpos_ser_6_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_2, eject_xneg_ser_6_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_2, eject_ypos_ser_6_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_2, eject_yneg_ser_6_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_2, eject_zpos_ser_6_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_2, eject_zneg_ser_6_5_2;
	wire[7:0] xpos_ClockwiseUtil_6_5_2,xpos_CounterClockwiseUtil_6_5_2,xpos_InjectUtil_6_5_2;
	wire[7:0] xneg_ClockwiseUtil_6_5_2,xneg_CounterClockwiseUtil_6_5_2,xneg_InjectUtil_6_5_2;
	wire[7:0] ypos_ClockwiseUtil_6_5_2,ypos_CounterClockwiseUtil_6_5_2,ypos_InjectUtil_6_5_2;
	wire[7:0] yneg_ClockwiseUtil_6_5_2,yneg_CounterClockwiseUtil_6_5_2,yneg_InjectUtil_6_5_2;
	wire[7:0] zpos_ClockwiseUtil_6_5_2,zpos_CounterClockwiseUtil_6_5_2,zpos_InjectUtil_6_5_2;
	wire[7:0] zneg_ClockwiseUtil_6_5_2,zneg_CounterClockwiseUtil_6_5_2,zneg_InjectUtil_6_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_3, eject_xpos_ser_6_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_3, eject_xneg_ser_6_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_3, eject_ypos_ser_6_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_3, eject_yneg_ser_6_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_3, eject_zpos_ser_6_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_3, eject_zneg_ser_6_5_3;
	wire[7:0] xpos_ClockwiseUtil_6_5_3,xpos_CounterClockwiseUtil_6_5_3,xpos_InjectUtil_6_5_3;
	wire[7:0] xneg_ClockwiseUtil_6_5_3,xneg_CounterClockwiseUtil_6_5_3,xneg_InjectUtil_6_5_3;
	wire[7:0] ypos_ClockwiseUtil_6_5_3,ypos_CounterClockwiseUtil_6_5_3,ypos_InjectUtil_6_5_3;
	wire[7:0] yneg_ClockwiseUtil_6_5_3,yneg_CounterClockwiseUtil_6_5_3,yneg_InjectUtil_6_5_3;
	wire[7:0] zpos_ClockwiseUtil_6_5_3,zpos_CounterClockwiseUtil_6_5_3,zpos_InjectUtil_6_5_3;
	wire[7:0] zneg_ClockwiseUtil_6_5_3,zneg_CounterClockwiseUtil_6_5_3,zneg_InjectUtil_6_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_4, eject_xpos_ser_6_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_4, eject_xneg_ser_6_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_4, eject_ypos_ser_6_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_4, eject_yneg_ser_6_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_4, eject_zpos_ser_6_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_4, eject_zneg_ser_6_5_4;
	wire[7:0] xpos_ClockwiseUtil_6_5_4,xpos_CounterClockwiseUtil_6_5_4,xpos_InjectUtil_6_5_4;
	wire[7:0] xneg_ClockwiseUtil_6_5_4,xneg_CounterClockwiseUtil_6_5_4,xneg_InjectUtil_6_5_4;
	wire[7:0] ypos_ClockwiseUtil_6_5_4,ypos_CounterClockwiseUtil_6_5_4,ypos_InjectUtil_6_5_4;
	wire[7:0] yneg_ClockwiseUtil_6_5_4,yneg_CounterClockwiseUtil_6_5_4,yneg_InjectUtil_6_5_4;
	wire[7:0] zpos_ClockwiseUtil_6_5_4,zpos_CounterClockwiseUtil_6_5_4,zpos_InjectUtil_6_5_4;
	wire[7:0] zneg_ClockwiseUtil_6_5_4,zneg_CounterClockwiseUtil_6_5_4,zneg_InjectUtil_6_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_5, eject_xpos_ser_6_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_5, eject_xneg_ser_6_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_5, eject_ypos_ser_6_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_5, eject_yneg_ser_6_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_5, eject_zpos_ser_6_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_5, eject_zneg_ser_6_5_5;
	wire[7:0] xpos_ClockwiseUtil_6_5_5,xpos_CounterClockwiseUtil_6_5_5,xpos_InjectUtil_6_5_5;
	wire[7:0] xneg_ClockwiseUtil_6_5_5,xneg_CounterClockwiseUtil_6_5_5,xneg_InjectUtil_6_5_5;
	wire[7:0] ypos_ClockwiseUtil_6_5_5,ypos_CounterClockwiseUtil_6_5_5,ypos_InjectUtil_6_5_5;
	wire[7:0] yneg_ClockwiseUtil_6_5_5,yneg_CounterClockwiseUtil_6_5_5,yneg_InjectUtil_6_5_5;
	wire[7:0] zpos_ClockwiseUtil_6_5_5,zpos_CounterClockwiseUtil_6_5_5,zpos_InjectUtil_6_5_5;
	wire[7:0] zneg_ClockwiseUtil_6_5_5,zneg_CounterClockwiseUtil_6_5_5,zneg_InjectUtil_6_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_6, eject_xpos_ser_6_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_6, eject_xneg_ser_6_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_6, eject_ypos_ser_6_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_6, eject_yneg_ser_6_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_6, eject_zpos_ser_6_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_6, eject_zneg_ser_6_5_6;
	wire[7:0] xpos_ClockwiseUtil_6_5_6,xpos_CounterClockwiseUtil_6_5_6,xpos_InjectUtil_6_5_6;
	wire[7:0] xneg_ClockwiseUtil_6_5_6,xneg_CounterClockwiseUtil_6_5_6,xneg_InjectUtil_6_5_6;
	wire[7:0] ypos_ClockwiseUtil_6_5_6,ypos_CounterClockwiseUtil_6_5_6,ypos_InjectUtil_6_5_6;
	wire[7:0] yneg_ClockwiseUtil_6_5_6,yneg_CounterClockwiseUtil_6_5_6,yneg_InjectUtil_6_5_6;
	wire[7:0] zpos_ClockwiseUtil_6_5_6,zpos_CounterClockwiseUtil_6_5_6,zpos_InjectUtil_6_5_6;
	wire[7:0] zneg_ClockwiseUtil_6_5_6,zneg_CounterClockwiseUtil_6_5_6,zneg_InjectUtil_6_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_5_7, eject_xpos_ser_6_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_5_7, eject_xneg_ser_6_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_5_7, eject_ypos_ser_6_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_5_7, eject_yneg_ser_6_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_5_7, eject_zpos_ser_6_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_5_7, eject_zneg_ser_6_5_7;
	wire[7:0] xpos_ClockwiseUtil_6_5_7,xpos_CounterClockwiseUtil_6_5_7,xpos_InjectUtil_6_5_7;
	wire[7:0] xneg_ClockwiseUtil_6_5_7,xneg_CounterClockwiseUtil_6_5_7,xneg_InjectUtil_6_5_7;
	wire[7:0] ypos_ClockwiseUtil_6_5_7,ypos_CounterClockwiseUtil_6_5_7,ypos_InjectUtil_6_5_7;
	wire[7:0] yneg_ClockwiseUtil_6_5_7,yneg_CounterClockwiseUtil_6_5_7,yneg_InjectUtil_6_5_7;
	wire[7:0] zpos_ClockwiseUtil_6_5_7,zpos_CounterClockwiseUtil_6_5_7,zpos_InjectUtil_6_5_7;
	wire[7:0] zneg_ClockwiseUtil_6_5_7,zneg_CounterClockwiseUtil_6_5_7,zneg_InjectUtil_6_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_0, eject_xpos_ser_6_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_0, eject_xneg_ser_6_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_0, eject_ypos_ser_6_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_0, eject_yneg_ser_6_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_0, eject_zpos_ser_6_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_0, eject_zneg_ser_6_6_0;
	wire[7:0] xpos_ClockwiseUtil_6_6_0,xpos_CounterClockwiseUtil_6_6_0,xpos_InjectUtil_6_6_0;
	wire[7:0] xneg_ClockwiseUtil_6_6_0,xneg_CounterClockwiseUtil_6_6_0,xneg_InjectUtil_6_6_0;
	wire[7:0] ypos_ClockwiseUtil_6_6_0,ypos_CounterClockwiseUtil_6_6_0,ypos_InjectUtil_6_6_0;
	wire[7:0] yneg_ClockwiseUtil_6_6_0,yneg_CounterClockwiseUtil_6_6_0,yneg_InjectUtil_6_6_0;
	wire[7:0] zpos_ClockwiseUtil_6_6_0,zpos_CounterClockwiseUtil_6_6_0,zpos_InjectUtil_6_6_0;
	wire[7:0] zneg_ClockwiseUtil_6_6_0,zneg_CounterClockwiseUtil_6_6_0,zneg_InjectUtil_6_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_1, eject_xpos_ser_6_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_1, eject_xneg_ser_6_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_1, eject_ypos_ser_6_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_1, eject_yneg_ser_6_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_1, eject_zpos_ser_6_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_1, eject_zneg_ser_6_6_1;
	wire[7:0] xpos_ClockwiseUtil_6_6_1,xpos_CounterClockwiseUtil_6_6_1,xpos_InjectUtil_6_6_1;
	wire[7:0] xneg_ClockwiseUtil_6_6_1,xneg_CounterClockwiseUtil_6_6_1,xneg_InjectUtil_6_6_1;
	wire[7:0] ypos_ClockwiseUtil_6_6_1,ypos_CounterClockwiseUtil_6_6_1,ypos_InjectUtil_6_6_1;
	wire[7:0] yneg_ClockwiseUtil_6_6_1,yneg_CounterClockwiseUtil_6_6_1,yneg_InjectUtil_6_6_1;
	wire[7:0] zpos_ClockwiseUtil_6_6_1,zpos_CounterClockwiseUtil_6_6_1,zpos_InjectUtil_6_6_1;
	wire[7:0] zneg_ClockwiseUtil_6_6_1,zneg_CounterClockwiseUtil_6_6_1,zneg_InjectUtil_6_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_2, eject_xpos_ser_6_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_2, eject_xneg_ser_6_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_2, eject_ypos_ser_6_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_2, eject_yneg_ser_6_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_2, eject_zpos_ser_6_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_2, eject_zneg_ser_6_6_2;
	wire[7:0] xpos_ClockwiseUtil_6_6_2,xpos_CounterClockwiseUtil_6_6_2,xpos_InjectUtil_6_6_2;
	wire[7:0] xneg_ClockwiseUtil_6_6_2,xneg_CounterClockwiseUtil_6_6_2,xneg_InjectUtil_6_6_2;
	wire[7:0] ypos_ClockwiseUtil_6_6_2,ypos_CounterClockwiseUtil_6_6_2,ypos_InjectUtil_6_6_2;
	wire[7:0] yneg_ClockwiseUtil_6_6_2,yneg_CounterClockwiseUtil_6_6_2,yneg_InjectUtil_6_6_2;
	wire[7:0] zpos_ClockwiseUtil_6_6_2,zpos_CounterClockwiseUtil_6_6_2,zpos_InjectUtil_6_6_2;
	wire[7:0] zneg_ClockwiseUtil_6_6_2,zneg_CounterClockwiseUtil_6_6_2,zneg_InjectUtil_6_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_3, eject_xpos_ser_6_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_3, eject_xneg_ser_6_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_3, eject_ypos_ser_6_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_3, eject_yneg_ser_6_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_3, eject_zpos_ser_6_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_3, eject_zneg_ser_6_6_3;
	wire[7:0] xpos_ClockwiseUtil_6_6_3,xpos_CounterClockwiseUtil_6_6_3,xpos_InjectUtil_6_6_3;
	wire[7:0] xneg_ClockwiseUtil_6_6_3,xneg_CounterClockwiseUtil_6_6_3,xneg_InjectUtil_6_6_3;
	wire[7:0] ypos_ClockwiseUtil_6_6_3,ypos_CounterClockwiseUtil_6_6_3,ypos_InjectUtil_6_6_3;
	wire[7:0] yneg_ClockwiseUtil_6_6_3,yneg_CounterClockwiseUtil_6_6_3,yneg_InjectUtil_6_6_3;
	wire[7:0] zpos_ClockwiseUtil_6_6_3,zpos_CounterClockwiseUtil_6_6_3,zpos_InjectUtil_6_6_3;
	wire[7:0] zneg_ClockwiseUtil_6_6_3,zneg_CounterClockwiseUtil_6_6_3,zneg_InjectUtil_6_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_4, eject_xpos_ser_6_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_4, eject_xneg_ser_6_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_4, eject_ypos_ser_6_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_4, eject_yneg_ser_6_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_4, eject_zpos_ser_6_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_4, eject_zneg_ser_6_6_4;
	wire[7:0] xpos_ClockwiseUtil_6_6_4,xpos_CounterClockwiseUtil_6_6_4,xpos_InjectUtil_6_6_4;
	wire[7:0] xneg_ClockwiseUtil_6_6_4,xneg_CounterClockwiseUtil_6_6_4,xneg_InjectUtil_6_6_4;
	wire[7:0] ypos_ClockwiseUtil_6_6_4,ypos_CounterClockwiseUtil_6_6_4,ypos_InjectUtil_6_6_4;
	wire[7:0] yneg_ClockwiseUtil_6_6_4,yneg_CounterClockwiseUtil_6_6_4,yneg_InjectUtil_6_6_4;
	wire[7:0] zpos_ClockwiseUtil_6_6_4,zpos_CounterClockwiseUtil_6_6_4,zpos_InjectUtil_6_6_4;
	wire[7:0] zneg_ClockwiseUtil_6_6_4,zneg_CounterClockwiseUtil_6_6_4,zneg_InjectUtil_6_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_5, eject_xpos_ser_6_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_5, eject_xneg_ser_6_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_5, eject_ypos_ser_6_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_5, eject_yneg_ser_6_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_5, eject_zpos_ser_6_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_5, eject_zneg_ser_6_6_5;
	wire[7:0] xpos_ClockwiseUtil_6_6_5,xpos_CounterClockwiseUtil_6_6_5,xpos_InjectUtil_6_6_5;
	wire[7:0] xneg_ClockwiseUtil_6_6_5,xneg_CounterClockwiseUtil_6_6_5,xneg_InjectUtil_6_6_5;
	wire[7:0] ypos_ClockwiseUtil_6_6_5,ypos_CounterClockwiseUtil_6_6_5,ypos_InjectUtil_6_6_5;
	wire[7:0] yneg_ClockwiseUtil_6_6_5,yneg_CounterClockwiseUtil_6_6_5,yneg_InjectUtil_6_6_5;
	wire[7:0] zpos_ClockwiseUtil_6_6_5,zpos_CounterClockwiseUtil_6_6_5,zpos_InjectUtil_6_6_5;
	wire[7:0] zneg_ClockwiseUtil_6_6_5,zneg_CounterClockwiseUtil_6_6_5,zneg_InjectUtil_6_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_6, eject_xpos_ser_6_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_6, eject_xneg_ser_6_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_6, eject_ypos_ser_6_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_6, eject_yneg_ser_6_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_6, eject_zpos_ser_6_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_6, eject_zneg_ser_6_6_6;
	wire[7:0] xpos_ClockwiseUtil_6_6_6,xpos_CounterClockwiseUtil_6_6_6,xpos_InjectUtil_6_6_6;
	wire[7:0] xneg_ClockwiseUtil_6_6_6,xneg_CounterClockwiseUtil_6_6_6,xneg_InjectUtil_6_6_6;
	wire[7:0] ypos_ClockwiseUtil_6_6_6,ypos_CounterClockwiseUtil_6_6_6,ypos_InjectUtil_6_6_6;
	wire[7:0] yneg_ClockwiseUtil_6_6_6,yneg_CounterClockwiseUtil_6_6_6,yneg_InjectUtil_6_6_6;
	wire[7:0] zpos_ClockwiseUtil_6_6_6,zpos_CounterClockwiseUtil_6_6_6,zpos_InjectUtil_6_6_6;
	wire[7:0] zneg_ClockwiseUtil_6_6_6,zneg_CounterClockwiseUtil_6_6_6,zneg_InjectUtil_6_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_6_7, eject_xpos_ser_6_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_6_7, eject_xneg_ser_6_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_6_7, eject_ypos_ser_6_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_6_7, eject_yneg_ser_6_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_6_7, eject_zpos_ser_6_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_6_7, eject_zneg_ser_6_6_7;
	wire[7:0] xpos_ClockwiseUtil_6_6_7,xpos_CounterClockwiseUtil_6_6_7,xpos_InjectUtil_6_6_7;
	wire[7:0] xneg_ClockwiseUtil_6_6_7,xneg_CounterClockwiseUtil_6_6_7,xneg_InjectUtil_6_6_7;
	wire[7:0] ypos_ClockwiseUtil_6_6_7,ypos_CounterClockwiseUtil_6_6_7,ypos_InjectUtil_6_6_7;
	wire[7:0] yneg_ClockwiseUtil_6_6_7,yneg_CounterClockwiseUtil_6_6_7,yneg_InjectUtil_6_6_7;
	wire[7:0] zpos_ClockwiseUtil_6_6_7,zpos_CounterClockwiseUtil_6_6_7,zpos_InjectUtil_6_6_7;
	wire[7:0] zneg_ClockwiseUtil_6_6_7,zneg_CounterClockwiseUtil_6_6_7,zneg_InjectUtil_6_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_0, eject_xpos_ser_6_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_0, eject_xneg_ser_6_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_0, eject_ypos_ser_6_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_0, eject_yneg_ser_6_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_0, eject_zpos_ser_6_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_0, eject_zneg_ser_6_7_0;
	wire[7:0] xpos_ClockwiseUtil_6_7_0,xpos_CounterClockwiseUtil_6_7_0,xpos_InjectUtil_6_7_0;
	wire[7:0] xneg_ClockwiseUtil_6_7_0,xneg_CounterClockwiseUtil_6_7_0,xneg_InjectUtil_6_7_0;
	wire[7:0] ypos_ClockwiseUtil_6_7_0,ypos_CounterClockwiseUtil_6_7_0,ypos_InjectUtil_6_7_0;
	wire[7:0] yneg_ClockwiseUtil_6_7_0,yneg_CounterClockwiseUtil_6_7_0,yneg_InjectUtil_6_7_0;
	wire[7:0] zpos_ClockwiseUtil_6_7_0,zpos_CounterClockwiseUtil_6_7_0,zpos_InjectUtil_6_7_0;
	wire[7:0] zneg_ClockwiseUtil_6_7_0,zneg_CounterClockwiseUtil_6_7_0,zneg_InjectUtil_6_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_1, eject_xpos_ser_6_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_1, eject_xneg_ser_6_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_1, eject_ypos_ser_6_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_1, eject_yneg_ser_6_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_1, eject_zpos_ser_6_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_1, eject_zneg_ser_6_7_1;
	wire[7:0] xpos_ClockwiseUtil_6_7_1,xpos_CounterClockwiseUtil_6_7_1,xpos_InjectUtil_6_7_1;
	wire[7:0] xneg_ClockwiseUtil_6_7_1,xneg_CounterClockwiseUtil_6_7_1,xneg_InjectUtil_6_7_1;
	wire[7:0] ypos_ClockwiseUtil_6_7_1,ypos_CounterClockwiseUtil_6_7_1,ypos_InjectUtil_6_7_1;
	wire[7:0] yneg_ClockwiseUtil_6_7_1,yneg_CounterClockwiseUtil_6_7_1,yneg_InjectUtil_6_7_1;
	wire[7:0] zpos_ClockwiseUtil_6_7_1,zpos_CounterClockwiseUtil_6_7_1,zpos_InjectUtil_6_7_1;
	wire[7:0] zneg_ClockwiseUtil_6_7_1,zneg_CounterClockwiseUtil_6_7_1,zneg_InjectUtil_6_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_2, eject_xpos_ser_6_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_2, eject_xneg_ser_6_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_2, eject_ypos_ser_6_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_2, eject_yneg_ser_6_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_2, eject_zpos_ser_6_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_2, eject_zneg_ser_6_7_2;
	wire[7:0] xpos_ClockwiseUtil_6_7_2,xpos_CounterClockwiseUtil_6_7_2,xpos_InjectUtil_6_7_2;
	wire[7:0] xneg_ClockwiseUtil_6_7_2,xneg_CounterClockwiseUtil_6_7_2,xneg_InjectUtil_6_7_2;
	wire[7:0] ypos_ClockwiseUtil_6_7_2,ypos_CounterClockwiseUtil_6_7_2,ypos_InjectUtil_6_7_2;
	wire[7:0] yneg_ClockwiseUtil_6_7_2,yneg_CounterClockwiseUtil_6_7_2,yneg_InjectUtil_6_7_2;
	wire[7:0] zpos_ClockwiseUtil_6_7_2,zpos_CounterClockwiseUtil_6_7_2,zpos_InjectUtil_6_7_2;
	wire[7:0] zneg_ClockwiseUtil_6_7_2,zneg_CounterClockwiseUtil_6_7_2,zneg_InjectUtil_6_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_3, eject_xpos_ser_6_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_3, eject_xneg_ser_6_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_3, eject_ypos_ser_6_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_3, eject_yneg_ser_6_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_3, eject_zpos_ser_6_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_3, eject_zneg_ser_6_7_3;
	wire[7:0] xpos_ClockwiseUtil_6_7_3,xpos_CounterClockwiseUtil_6_7_3,xpos_InjectUtil_6_7_3;
	wire[7:0] xneg_ClockwiseUtil_6_7_3,xneg_CounterClockwiseUtil_6_7_3,xneg_InjectUtil_6_7_3;
	wire[7:0] ypos_ClockwiseUtil_6_7_3,ypos_CounterClockwiseUtil_6_7_3,ypos_InjectUtil_6_7_3;
	wire[7:0] yneg_ClockwiseUtil_6_7_3,yneg_CounterClockwiseUtil_6_7_3,yneg_InjectUtil_6_7_3;
	wire[7:0] zpos_ClockwiseUtil_6_7_3,zpos_CounterClockwiseUtil_6_7_3,zpos_InjectUtil_6_7_3;
	wire[7:0] zneg_ClockwiseUtil_6_7_3,zneg_CounterClockwiseUtil_6_7_3,zneg_InjectUtil_6_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_4, eject_xpos_ser_6_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_4, eject_xneg_ser_6_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_4, eject_ypos_ser_6_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_4, eject_yneg_ser_6_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_4, eject_zpos_ser_6_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_4, eject_zneg_ser_6_7_4;
	wire[7:0] xpos_ClockwiseUtil_6_7_4,xpos_CounterClockwiseUtil_6_7_4,xpos_InjectUtil_6_7_4;
	wire[7:0] xneg_ClockwiseUtil_6_7_4,xneg_CounterClockwiseUtil_6_7_4,xneg_InjectUtil_6_7_4;
	wire[7:0] ypos_ClockwiseUtil_6_7_4,ypos_CounterClockwiseUtil_6_7_4,ypos_InjectUtil_6_7_4;
	wire[7:0] yneg_ClockwiseUtil_6_7_4,yneg_CounterClockwiseUtil_6_7_4,yneg_InjectUtil_6_7_4;
	wire[7:0] zpos_ClockwiseUtil_6_7_4,zpos_CounterClockwiseUtil_6_7_4,zpos_InjectUtil_6_7_4;
	wire[7:0] zneg_ClockwiseUtil_6_7_4,zneg_CounterClockwiseUtil_6_7_4,zneg_InjectUtil_6_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_5, eject_xpos_ser_6_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_5, eject_xneg_ser_6_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_5, eject_ypos_ser_6_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_5, eject_yneg_ser_6_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_5, eject_zpos_ser_6_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_5, eject_zneg_ser_6_7_5;
	wire[7:0] xpos_ClockwiseUtil_6_7_5,xpos_CounterClockwiseUtil_6_7_5,xpos_InjectUtil_6_7_5;
	wire[7:0] xneg_ClockwiseUtil_6_7_5,xneg_CounterClockwiseUtil_6_7_5,xneg_InjectUtil_6_7_5;
	wire[7:0] ypos_ClockwiseUtil_6_7_5,ypos_CounterClockwiseUtil_6_7_5,ypos_InjectUtil_6_7_5;
	wire[7:0] yneg_ClockwiseUtil_6_7_5,yneg_CounterClockwiseUtil_6_7_5,yneg_InjectUtil_6_7_5;
	wire[7:0] zpos_ClockwiseUtil_6_7_5,zpos_CounterClockwiseUtil_6_7_5,zpos_InjectUtil_6_7_5;
	wire[7:0] zneg_ClockwiseUtil_6_7_5,zneg_CounterClockwiseUtil_6_7_5,zneg_InjectUtil_6_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_6, eject_xpos_ser_6_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_6, eject_xneg_ser_6_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_6, eject_ypos_ser_6_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_6, eject_yneg_ser_6_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_6, eject_zpos_ser_6_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_6, eject_zneg_ser_6_7_6;
	wire[7:0] xpos_ClockwiseUtil_6_7_6,xpos_CounterClockwiseUtil_6_7_6,xpos_InjectUtil_6_7_6;
	wire[7:0] xneg_ClockwiseUtil_6_7_6,xneg_CounterClockwiseUtil_6_7_6,xneg_InjectUtil_6_7_6;
	wire[7:0] ypos_ClockwiseUtil_6_7_6,ypos_CounterClockwiseUtil_6_7_6,ypos_InjectUtil_6_7_6;
	wire[7:0] yneg_ClockwiseUtil_6_7_6,yneg_CounterClockwiseUtil_6_7_6,yneg_InjectUtil_6_7_6;
	wire[7:0] zpos_ClockwiseUtil_6_7_6,zpos_CounterClockwiseUtil_6_7_6,zpos_InjectUtil_6_7_6;
	wire[7:0] zneg_ClockwiseUtil_6_7_6,zneg_CounterClockwiseUtil_6_7_6,zneg_InjectUtil_6_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_6_7_7, eject_xpos_ser_6_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_6_7_7, eject_xneg_ser_6_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_6_7_7, eject_ypos_ser_6_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_6_7_7, eject_yneg_ser_6_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_6_7_7, eject_zpos_ser_6_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_6_7_7, eject_zneg_ser_6_7_7;
	wire[7:0] xpos_ClockwiseUtil_6_7_7,xpos_CounterClockwiseUtil_6_7_7,xpos_InjectUtil_6_7_7;
	wire[7:0] xneg_ClockwiseUtil_6_7_7,xneg_CounterClockwiseUtil_6_7_7,xneg_InjectUtil_6_7_7;
	wire[7:0] ypos_ClockwiseUtil_6_7_7,ypos_CounterClockwiseUtil_6_7_7,ypos_InjectUtil_6_7_7;
	wire[7:0] yneg_ClockwiseUtil_6_7_7,yneg_CounterClockwiseUtil_6_7_7,yneg_InjectUtil_6_7_7;
	wire[7:0] zpos_ClockwiseUtil_6_7_7,zpos_CounterClockwiseUtil_6_7_7,zpos_InjectUtil_6_7_7;
	wire[7:0] zneg_ClockwiseUtil_6_7_7,zneg_CounterClockwiseUtil_6_7_7,zneg_InjectUtil_6_7_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_0, eject_xpos_ser_7_0_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_0, eject_xneg_ser_7_0_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_0, eject_ypos_ser_7_0_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_0, eject_yneg_ser_7_0_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_0, eject_zpos_ser_7_0_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_0, eject_zneg_ser_7_0_0;
	wire[7:0] xpos_ClockwiseUtil_7_0_0,xpos_CounterClockwiseUtil_7_0_0,xpos_InjectUtil_7_0_0;
	wire[7:0] xneg_ClockwiseUtil_7_0_0,xneg_CounterClockwiseUtil_7_0_0,xneg_InjectUtil_7_0_0;
	wire[7:0] ypos_ClockwiseUtil_7_0_0,ypos_CounterClockwiseUtil_7_0_0,ypos_InjectUtil_7_0_0;
	wire[7:0] yneg_ClockwiseUtil_7_0_0,yneg_CounterClockwiseUtil_7_0_0,yneg_InjectUtil_7_0_0;
	wire[7:0] zpos_ClockwiseUtil_7_0_0,zpos_CounterClockwiseUtil_7_0_0,zpos_InjectUtil_7_0_0;
	wire[7:0] zneg_ClockwiseUtil_7_0_0,zneg_CounterClockwiseUtil_7_0_0,zneg_InjectUtil_7_0_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_1, eject_xpos_ser_7_0_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_1, eject_xneg_ser_7_0_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_1, eject_ypos_ser_7_0_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_1, eject_yneg_ser_7_0_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_1, eject_zpos_ser_7_0_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_1, eject_zneg_ser_7_0_1;
	wire[7:0] xpos_ClockwiseUtil_7_0_1,xpos_CounterClockwiseUtil_7_0_1,xpos_InjectUtil_7_0_1;
	wire[7:0] xneg_ClockwiseUtil_7_0_1,xneg_CounterClockwiseUtil_7_0_1,xneg_InjectUtil_7_0_1;
	wire[7:0] ypos_ClockwiseUtil_7_0_1,ypos_CounterClockwiseUtil_7_0_1,ypos_InjectUtil_7_0_1;
	wire[7:0] yneg_ClockwiseUtil_7_0_1,yneg_CounterClockwiseUtil_7_0_1,yneg_InjectUtil_7_0_1;
	wire[7:0] zpos_ClockwiseUtil_7_0_1,zpos_CounterClockwiseUtil_7_0_1,zpos_InjectUtil_7_0_1;
	wire[7:0] zneg_ClockwiseUtil_7_0_1,zneg_CounterClockwiseUtil_7_0_1,zneg_InjectUtil_7_0_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_2, eject_xpos_ser_7_0_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_2, eject_xneg_ser_7_0_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_2, eject_ypos_ser_7_0_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_2, eject_yneg_ser_7_0_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_2, eject_zpos_ser_7_0_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_2, eject_zneg_ser_7_0_2;
	wire[7:0] xpos_ClockwiseUtil_7_0_2,xpos_CounterClockwiseUtil_7_0_2,xpos_InjectUtil_7_0_2;
	wire[7:0] xneg_ClockwiseUtil_7_0_2,xneg_CounterClockwiseUtil_7_0_2,xneg_InjectUtil_7_0_2;
	wire[7:0] ypos_ClockwiseUtil_7_0_2,ypos_CounterClockwiseUtil_7_0_2,ypos_InjectUtil_7_0_2;
	wire[7:0] yneg_ClockwiseUtil_7_0_2,yneg_CounterClockwiseUtil_7_0_2,yneg_InjectUtil_7_0_2;
	wire[7:0] zpos_ClockwiseUtil_7_0_2,zpos_CounterClockwiseUtil_7_0_2,zpos_InjectUtil_7_0_2;
	wire[7:0] zneg_ClockwiseUtil_7_0_2,zneg_CounterClockwiseUtil_7_0_2,zneg_InjectUtil_7_0_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_3, eject_xpos_ser_7_0_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_3, eject_xneg_ser_7_0_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_3, eject_ypos_ser_7_0_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_3, eject_yneg_ser_7_0_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_3, eject_zpos_ser_7_0_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_3, eject_zneg_ser_7_0_3;
	wire[7:0] xpos_ClockwiseUtil_7_0_3,xpos_CounterClockwiseUtil_7_0_3,xpos_InjectUtil_7_0_3;
	wire[7:0] xneg_ClockwiseUtil_7_0_3,xneg_CounterClockwiseUtil_7_0_3,xneg_InjectUtil_7_0_3;
	wire[7:0] ypos_ClockwiseUtil_7_0_3,ypos_CounterClockwiseUtil_7_0_3,ypos_InjectUtil_7_0_3;
	wire[7:0] yneg_ClockwiseUtil_7_0_3,yneg_CounterClockwiseUtil_7_0_3,yneg_InjectUtil_7_0_3;
	wire[7:0] zpos_ClockwiseUtil_7_0_3,zpos_CounterClockwiseUtil_7_0_3,zpos_InjectUtil_7_0_3;
	wire[7:0] zneg_ClockwiseUtil_7_0_3,zneg_CounterClockwiseUtil_7_0_3,zneg_InjectUtil_7_0_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_4, eject_xpos_ser_7_0_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_4, eject_xneg_ser_7_0_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_4, eject_ypos_ser_7_0_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_4, eject_yneg_ser_7_0_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_4, eject_zpos_ser_7_0_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_4, eject_zneg_ser_7_0_4;
	wire[7:0] xpos_ClockwiseUtil_7_0_4,xpos_CounterClockwiseUtil_7_0_4,xpos_InjectUtil_7_0_4;
	wire[7:0] xneg_ClockwiseUtil_7_0_4,xneg_CounterClockwiseUtil_7_0_4,xneg_InjectUtil_7_0_4;
	wire[7:0] ypos_ClockwiseUtil_7_0_4,ypos_CounterClockwiseUtil_7_0_4,ypos_InjectUtil_7_0_4;
	wire[7:0] yneg_ClockwiseUtil_7_0_4,yneg_CounterClockwiseUtil_7_0_4,yneg_InjectUtil_7_0_4;
	wire[7:0] zpos_ClockwiseUtil_7_0_4,zpos_CounterClockwiseUtil_7_0_4,zpos_InjectUtil_7_0_4;
	wire[7:0] zneg_ClockwiseUtil_7_0_4,zneg_CounterClockwiseUtil_7_0_4,zneg_InjectUtil_7_0_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_5, eject_xpos_ser_7_0_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_5, eject_xneg_ser_7_0_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_5, eject_ypos_ser_7_0_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_5, eject_yneg_ser_7_0_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_5, eject_zpos_ser_7_0_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_5, eject_zneg_ser_7_0_5;
	wire[7:0] xpos_ClockwiseUtil_7_0_5,xpos_CounterClockwiseUtil_7_0_5,xpos_InjectUtil_7_0_5;
	wire[7:0] xneg_ClockwiseUtil_7_0_5,xneg_CounterClockwiseUtil_7_0_5,xneg_InjectUtil_7_0_5;
	wire[7:0] ypos_ClockwiseUtil_7_0_5,ypos_CounterClockwiseUtil_7_0_5,ypos_InjectUtil_7_0_5;
	wire[7:0] yneg_ClockwiseUtil_7_0_5,yneg_CounterClockwiseUtil_7_0_5,yneg_InjectUtil_7_0_5;
	wire[7:0] zpos_ClockwiseUtil_7_0_5,zpos_CounterClockwiseUtil_7_0_5,zpos_InjectUtil_7_0_5;
	wire[7:0] zneg_ClockwiseUtil_7_0_5,zneg_CounterClockwiseUtil_7_0_5,zneg_InjectUtil_7_0_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_6, eject_xpos_ser_7_0_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_6, eject_xneg_ser_7_0_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_6, eject_ypos_ser_7_0_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_6, eject_yneg_ser_7_0_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_6, eject_zpos_ser_7_0_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_6, eject_zneg_ser_7_0_6;
	wire[7:0] xpos_ClockwiseUtil_7_0_6,xpos_CounterClockwiseUtil_7_0_6,xpos_InjectUtil_7_0_6;
	wire[7:0] xneg_ClockwiseUtil_7_0_6,xneg_CounterClockwiseUtil_7_0_6,xneg_InjectUtil_7_0_6;
	wire[7:0] ypos_ClockwiseUtil_7_0_6,ypos_CounterClockwiseUtil_7_0_6,ypos_InjectUtil_7_0_6;
	wire[7:0] yneg_ClockwiseUtil_7_0_6,yneg_CounterClockwiseUtil_7_0_6,yneg_InjectUtil_7_0_6;
	wire[7:0] zpos_ClockwiseUtil_7_0_6,zpos_CounterClockwiseUtil_7_0_6,zpos_InjectUtil_7_0_6;
	wire[7:0] zneg_ClockwiseUtil_7_0_6,zneg_CounterClockwiseUtil_7_0_6,zneg_InjectUtil_7_0_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_0_7, eject_xpos_ser_7_0_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_0_7, eject_xneg_ser_7_0_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_0_7, eject_ypos_ser_7_0_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_0_7, eject_yneg_ser_7_0_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_0_7, eject_zpos_ser_7_0_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_0_7, eject_zneg_ser_7_0_7;
	wire[7:0] xpos_ClockwiseUtil_7_0_7,xpos_CounterClockwiseUtil_7_0_7,xpos_InjectUtil_7_0_7;
	wire[7:0] xneg_ClockwiseUtil_7_0_7,xneg_CounterClockwiseUtil_7_0_7,xneg_InjectUtil_7_0_7;
	wire[7:0] ypos_ClockwiseUtil_7_0_7,ypos_CounterClockwiseUtil_7_0_7,ypos_InjectUtil_7_0_7;
	wire[7:0] yneg_ClockwiseUtil_7_0_7,yneg_CounterClockwiseUtil_7_0_7,yneg_InjectUtil_7_0_7;
	wire[7:0] zpos_ClockwiseUtil_7_0_7,zpos_CounterClockwiseUtil_7_0_7,zpos_InjectUtil_7_0_7;
	wire[7:0] zneg_ClockwiseUtil_7_0_7,zneg_CounterClockwiseUtil_7_0_7,zneg_InjectUtil_7_0_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_0, eject_xpos_ser_7_1_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_0, eject_xneg_ser_7_1_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_0, eject_ypos_ser_7_1_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_0, eject_yneg_ser_7_1_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_0, eject_zpos_ser_7_1_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_0, eject_zneg_ser_7_1_0;
	wire[7:0] xpos_ClockwiseUtil_7_1_0,xpos_CounterClockwiseUtil_7_1_0,xpos_InjectUtil_7_1_0;
	wire[7:0] xneg_ClockwiseUtil_7_1_0,xneg_CounterClockwiseUtil_7_1_0,xneg_InjectUtil_7_1_0;
	wire[7:0] ypos_ClockwiseUtil_7_1_0,ypos_CounterClockwiseUtil_7_1_0,ypos_InjectUtil_7_1_0;
	wire[7:0] yneg_ClockwiseUtil_7_1_0,yneg_CounterClockwiseUtil_7_1_0,yneg_InjectUtil_7_1_0;
	wire[7:0] zpos_ClockwiseUtil_7_1_0,zpos_CounterClockwiseUtil_7_1_0,zpos_InjectUtil_7_1_0;
	wire[7:0] zneg_ClockwiseUtil_7_1_0,zneg_CounterClockwiseUtil_7_1_0,zneg_InjectUtil_7_1_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_1, eject_xpos_ser_7_1_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_1, eject_xneg_ser_7_1_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_1, eject_ypos_ser_7_1_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_1, eject_yneg_ser_7_1_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_1, eject_zpos_ser_7_1_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_1, eject_zneg_ser_7_1_1;
	wire[7:0] xpos_ClockwiseUtil_7_1_1,xpos_CounterClockwiseUtil_7_1_1,xpos_InjectUtil_7_1_1;
	wire[7:0] xneg_ClockwiseUtil_7_1_1,xneg_CounterClockwiseUtil_7_1_1,xneg_InjectUtil_7_1_1;
	wire[7:0] ypos_ClockwiseUtil_7_1_1,ypos_CounterClockwiseUtil_7_1_1,ypos_InjectUtil_7_1_1;
	wire[7:0] yneg_ClockwiseUtil_7_1_1,yneg_CounterClockwiseUtil_7_1_1,yneg_InjectUtil_7_1_1;
	wire[7:0] zpos_ClockwiseUtil_7_1_1,zpos_CounterClockwiseUtil_7_1_1,zpos_InjectUtil_7_1_1;
	wire[7:0] zneg_ClockwiseUtil_7_1_1,zneg_CounterClockwiseUtil_7_1_1,zneg_InjectUtil_7_1_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_2, eject_xpos_ser_7_1_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_2, eject_xneg_ser_7_1_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_2, eject_ypos_ser_7_1_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_2, eject_yneg_ser_7_1_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_2, eject_zpos_ser_7_1_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_2, eject_zneg_ser_7_1_2;
	wire[7:0] xpos_ClockwiseUtil_7_1_2,xpos_CounterClockwiseUtil_7_1_2,xpos_InjectUtil_7_1_2;
	wire[7:0] xneg_ClockwiseUtil_7_1_2,xneg_CounterClockwiseUtil_7_1_2,xneg_InjectUtil_7_1_2;
	wire[7:0] ypos_ClockwiseUtil_7_1_2,ypos_CounterClockwiseUtil_7_1_2,ypos_InjectUtil_7_1_2;
	wire[7:0] yneg_ClockwiseUtil_7_1_2,yneg_CounterClockwiseUtil_7_1_2,yneg_InjectUtil_7_1_2;
	wire[7:0] zpos_ClockwiseUtil_7_1_2,zpos_CounterClockwiseUtil_7_1_2,zpos_InjectUtil_7_1_2;
	wire[7:0] zneg_ClockwiseUtil_7_1_2,zneg_CounterClockwiseUtil_7_1_2,zneg_InjectUtil_7_1_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_3, eject_xpos_ser_7_1_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_3, eject_xneg_ser_7_1_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_3, eject_ypos_ser_7_1_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_3, eject_yneg_ser_7_1_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_3, eject_zpos_ser_7_1_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_3, eject_zneg_ser_7_1_3;
	wire[7:0] xpos_ClockwiseUtil_7_1_3,xpos_CounterClockwiseUtil_7_1_3,xpos_InjectUtil_7_1_3;
	wire[7:0] xneg_ClockwiseUtil_7_1_3,xneg_CounterClockwiseUtil_7_1_3,xneg_InjectUtil_7_1_3;
	wire[7:0] ypos_ClockwiseUtil_7_1_3,ypos_CounterClockwiseUtil_7_1_3,ypos_InjectUtil_7_1_3;
	wire[7:0] yneg_ClockwiseUtil_7_1_3,yneg_CounterClockwiseUtil_7_1_3,yneg_InjectUtil_7_1_3;
	wire[7:0] zpos_ClockwiseUtil_7_1_3,zpos_CounterClockwiseUtil_7_1_3,zpos_InjectUtil_7_1_3;
	wire[7:0] zneg_ClockwiseUtil_7_1_3,zneg_CounterClockwiseUtil_7_1_3,zneg_InjectUtil_7_1_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_4, eject_xpos_ser_7_1_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_4, eject_xneg_ser_7_1_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_4, eject_ypos_ser_7_1_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_4, eject_yneg_ser_7_1_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_4, eject_zpos_ser_7_1_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_4, eject_zneg_ser_7_1_4;
	wire[7:0] xpos_ClockwiseUtil_7_1_4,xpos_CounterClockwiseUtil_7_1_4,xpos_InjectUtil_7_1_4;
	wire[7:0] xneg_ClockwiseUtil_7_1_4,xneg_CounterClockwiseUtil_7_1_4,xneg_InjectUtil_7_1_4;
	wire[7:0] ypos_ClockwiseUtil_7_1_4,ypos_CounterClockwiseUtil_7_1_4,ypos_InjectUtil_7_1_4;
	wire[7:0] yneg_ClockwiseUtil_7_1_4,yneg_CounterClockwiseUtil_7_1_4,yneg_InjectUtil_7_1_4;
	wire[7:0] zpos_ClockwiseUtil_7_1_4,zpos_CounterClockwiseUtil_7_1_4,zpos_InjectUtil_7_1_4;
	wire[7:0] zneg_ClockwiseUtil_7_1_4,zneg_CounterClockwiseUtil_7_1_4,zneg_InjectUtil_7_1_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_5, eject_xpos_ser_7_1_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_5, eject_xneg_ser_7_1_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_5, eject_ypos_ser_7_1_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_5, eject_yneg_ser_7_1_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_5, eject_zpos_ser_7_1_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_5, eject_zneg_ser_7_1_5;
	wire[7:0] xpos_ClockwiseUtil_7_1_5,xpos_CounterClockwiseUtil_7_1_5,xpos_InjectUtil_7_1_5;
	wire[7:0] xneg_ClockwiseUtil_7_1_5,xneg_CounterClockwiseUtil_7_1_5,xneg_InjectUtil_7_1_5;
	wire[7:0] ypos_ClockwiseUtil_7_1_5,ypos_CounterClockwiseUtil_7_1_5,ypos_InjectUtil_7_1_5;
	wire[7:0] yneg_ClockwiseUtil_7_1_5,yneg_CounterClockwiseUtil_7_1_5,yneg_InjectUtil_7_1_5;
	wire[7:0] zpos_ClockwiseUtil_7_1_5,zpos_CounterClockwiseUtil_7_1_5,zpos_InjectUtil_7_1_5;
	wire[7:0] zneg_ClockwiseUtil_7_1_5,zneg_CounterClockwiseUtil_7_1_5,zneg_InjectUtil_7_1_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_6, eject_xpos_ser_7_1_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_6, eject_xneg_ser_7_1_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_6, eject_ypos_ser_7_1_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_6, eject_yneg_ser_7_1_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_6, eject_zpos_ser_7_1_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_6, eject_zneg_ser_7_1_6;
	wire[7:0] xpos_ClockwiseUtil_7_1_6,xpos_CounterClockwiseUtil_7_1_6,xpos_InjectUtil_7_1_6;
	wire[7:0] xneg_ClockwiseUtil_7_1_6,xneg_CounterClockwiseUtil_7_1_6,xneg_InjectUtil_7_1_6;
	wire[7:0] ypos_ClockwiseUtil_7_1_6,ypos_CounterClockwiseUtil_7_1_6,ypos_InjectUtil_7_1_6;
	wire[7:0] yneg_ClockwiseUtil_7_1_6,yneg_CounterClockwiseUtil_7_1_6,yneg_InjectUtil_7_1_6;
	wire[7:0] zpos_ClockwiseUtil_7_1_6,zpos_CounterClockwiseUtil_7_1_6,zpos_InjectUtil_7_1_6;
	wire[7:0] zneg_ClockwiseUtil_7_1_6,zneg_CounterClockwiseUtil_7_1_6,zneg_InjectUtil_7_1_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_1_7, eject_xpos_ser_7_1_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_1_7, eject_xneg_ser_7_1_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_1_7, eject_ypos_ser_7_1_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_1_7, eject_yneg_ser_7_1_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_1_7, eject_zpos_ser_7_1_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_1_7, eject_zneg_ser_7_1_7;
	wire[7:0] xpos_ClockwiseUtil_7_1_7,xpos_CounterClockwiseUtil_7_1_7,xpos_InjectUtil_7_1_7;
	wire[7:0] xneg_ClockwiseUtil_7_1_7,xneg_CounterClockwiseUtil_7_1_7,xneg_InjectUtil_7_1_7;
	wire[7:0] ypos_ClockwiseUtil_7_1_7,ypos_CounterClockwiseUtil_7_1_7,ypos_InjectUtil_7_1_7;
	wire[7:0] yneg_ClockwiseUtil_7_1_7,yneg_CounterClockwiseUtil_7_1_7,yneg_InjectUtil_7_1_7;
	wire[7:0] zpos_ClockwiseUtil_7_1_7,zpos_CounterClockwiseUtil_7_1_7,zpos_InjectUtil_7_1_7;
	wire[7:0] zneg_ClockwiseUtil_7_1_7,zneg_CounterClockwiseUtil_7_1_7,zneg_InjectUtil_7_1_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_0, eject_xpos_ser_7_2_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_0, eject_xneg_ser_7_2_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_0, eject_ypos_ser_7_2_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_0, eject_yneg_ser_7_2_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_0, eject_zpos_ser_7_2_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_0, eject_zneg_ser_7_2_0;
	wire[7:0] xpos_ClockwiseUtil_7_2_0,xpos_CounterClockwiseUtil_7_2_0,xpos_InjectUtil_7_2_0;
	wire[7:0] xneg_ClockwiseUtil_7_2_0,xneg_CounterClockwiseUtil_7_2_0,xneg_InjectUtil_7_2_0;
	wire[7:0] ypos_ClockwiseUtil_7_2_0,ypos_CounterClockwiseUtil_7_2_0,ypos_InjectUtil_7_2_0;
	wire[7:0] yneg_ClockwiseUtil_7_2_0,yneg_CounterClockwiseUtil_7_2_0,yneg_InjectUtil_7_2_0;
	wire[7:0] zpos_ClockwiseUtil_7_2_0,zpos_CounterClockwiseUtil_7_2_0,zpos_InjectUtil_7_2_0;
	wire[7:0] zneg_ClockwiseUtil_7_2_0,zneg_CounterClockwiseUtil_7_2_0,zneg_InjectUtil_7_2_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_1, eject_xpos_ser_7_2_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_1, eject_xneg_ser_7_2_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_1, eject_ypos_ser_7_2_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_1, eject_yneg_ser_7_2_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_1, eject_zpos_ser_7_2_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_1, eject_zneg_ser_7_2_1;
	wire[7:0] xpos_ClockwiseUtil_7_2_1,xpos_CounterClockwiseUtil_7_2_1,xpos_InjectUtil_7_2_1;
	wire[7:0] xneg_ClockwiseUtil_7_2_1,xneg_CounterClockwiseUtil_7_2_1,xneg_InjectUtil_7_2_1;
	wire[7:0] ypos_ClockwiseUtil_7_2_1,ypos_CounterClockwiseUtil_7_2_1,ypos_InjectUtil_7_2_1;
	wire[7:0] yneg_ClockwiseUtil_7_2_1,yneg_CounterClockwiseUtil_7_2_1,yneg_InjectUtil_7_2_1;
	wire[7:0] zpos_ClockwiseUtil_7_2_1,zpos_CounterClockwiseUtil_7_2_1,zpos_InjectUtil_7_2_1;
	wire[7:0] zneg_ClockwiseUtil_7_2_1,zneg_CounterClockwiseUtil_7_2_1,zneg_InjectUtil_7_2_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_2, eject_xpos_ser_7_2_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_2, eject_xneg_ser_7_2_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_2, eject_ypos_ser_7_2_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_2, eject_yneg_ser_7_2_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_2, eject_zpos_ser_7_2_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_2, eject_zneg_ser_7_2_2;
	wire[7:0] xpos_ClockwiseUtil_7_2_2,xpos_CounterClockwiseUtil_7_2_2,xpos_InjectUtil_7_2_2;
	wire[7:0] xneg_ClockwiseUtil_7_2_2,xneg_CounterClockwiseUtil_7_2_2,xneg_InjectUtil_7_2_2;
	wire[7:0] ypos_ClockwiseUtil_7_2_2,ypos_CounterClockwiseUtil_7_2_2,ypos_InjectUtil_7_2_2;
	wire[7:0] yneg_ClockwiseUtil_7_2_2,yneg_CounterClockwiseUtil_7_2_2,yneg_InjectUtil_7_2_2;
	wire[7:0] zpos_ClockwiseUtil_7_2_2,zpos_CounterClockwiseUtil_7_2_2,zpos_InjectUtil_7_2_2;
	wire[7:0] zneg_ClockwiseUtil_7_2_2,zneg_CounterClockwiseUtil_7_2_2,zneg_InjectUtil_7_2_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_3, eject_xpos_ser_7_2_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_3, eject_xneg_ser_7_2_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_3, eject_ypos_ser_7_2_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_3, eject_yneg_ser_7_2_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_3, eject_zpos_ser_7_2_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_3, eject_zneg_ser_7_2_3;
	wire[7:0] xpos_ClockwiseUtil_7_2_3,xpos_CounterClockwiseUtil_7_2_3,xpos_InjectUtil_7_2_3;
	wire[7:0] xneg_ClockwiseUtil_7_2_3,xneg_CounterClockwiseUtil_7_2_3,xneg_InjectUtil_7_2_3;
	wire[7:0] ypos_ClockwiseUtil_7_2_3,ypos_CounterClockwiseUtil_7_2_3,ypos_InjectUtil_7_2_3;
	wire[7:0] yneg_ClockwiseUtil_7_2_3,yneg_CounterClockwiseUtil_7_2_3,yneg_InjectUtil_7_2_3;
	wire[7:0] zpos_ClockwiseUtil_7_2_3,zpos_CounterClockwiseUtil_7_2_3,zpos_InjectUtil_7_2_3;
	wire[7:0] zneg_ClockwiseUtil_7_2_3,zneg_CounterClockwiseUtil_7_2_3,zneg_InjectUtil_7_2_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_4, eject_xpos_ser_7_2_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_4, eject_xneg_ser_7_2_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_4, eject_ypos_ser_7_2_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_4, eject_yneg_ser_7_2_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_4, eject_zpos_ser_7_2_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_4, eject_zneg_ser_7_2_4;
	wire[7:0] xpos_ClockwiseUtil_7_2_4,xpos_CounterClockwiseUtil_7_2_4,xpos_InjectUtil_7_2_4;
	wire[7:0] xneg_ClockwiseUtil_7_2_4,xneg_CounterClockwiseUtil_7_2_4,xneg_InjectUtil_7_2_4;
	wire[7:0] ypos_ClockwiseUtil_7_2_4,ypos_CounterClockwiseUtil_7_2_4,ypos_InjectUtil_7_2_4;
	wire[7:0] yneg_ClockwiseUtil_7_2_4,yneg_CounterClockwiseUtil_7_2_4,yneg_InjectUtil_7_2_4;
	wire[7:0] zpos_ClockwiseUtil_7_2_4,zpos_CounterClockwiseUtil_7_2_4,zpos_InjectUtil_7_2_4;
	wire[7:0] zneg_ClockwiseUtil_7_2_4,zneg_CounterClockwiseUtil_7_2_4,zneg_InjectUtil_7_2_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_5, eject_xpos_ser_7_2_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_5, eject_xneg_ser_7_2_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_5, eject_ypos_ser_7_2_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_5, eject_yneg_ser_7_2_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_5, eject_zpos_ser_7_2_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_5, eject_zneg_ser_7_2_5;
	wire[7:0] xpos_ClockwiseUtil_7_2_5,xpos_CounterClockwiseUtil_7_2_5,xpos_InjectUtil_7_2_5;
	wire[7:0] xneg_ClockwiseUtil_7_2_5,xneg_CounterClockwiseUtil_7_2_5,xneg_InjectUtil_7_2_5;
	wire[7:0] ypos_ClockwiseUtil_7_2_5,ypos_CounterClockwiseUtil_7_2_5,ypos_InjectUtil_7_2_5;
	wire[7:0] yneg_ClockwiseUtil_7_2_5,yneg_CounterClockwiseUtil_7_2_5,yneg_InjectUtil_7_2_5;
	wire[7:0] zpos_ClockwiseUtil_7_2_5,zpos_CounterClockwiseUtil_7_2_5,zpos_InjectUtil_7_2_5;
	wire[7:0] zneg_ClockwiseUtil_7_2_5,zneg_CounterClockwiseUtil_7_2_5,zneg_InjectUtil_7_2_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_6, eject_xpos_ser_7_2_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_6, eject_xneg_ser_7_2_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_6, eject_ypos_ser_7_2_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_6, eject_yneg_ser_7_2_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_6, eject_zpos_ser_7_2_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_6, eject_zneg_ser_7_2_6;
	wire[7:0] xpos_ClockwiseUtil_7_2_6,xpos_CounterClockwiseUtil_7_2_6,xpos_InjectUtil_7_2_6;
	wire[7:0] xneg_ClockwiseUtil_7_2_6,xneg_CounterClockwiseUtil_7_2_6,xneg_InjectUtil_7_2_6;
	wire[7:0] ypos_ClockwiseUtil_7_2_6,ypos_CounterClockwiseUtil_7_2_6,ypos_InjectUtil_7_2_6;
	wire[7:0] yneg_ClockwiseUtil_7_2_6,yneg_CounterClockwiseUtil_7_2_6,yneg_InjectUtil_7_2_6;
	wire[7:0] zpos_ClockwiseUtil_7_2_6,zpos_CounterClockwiseUtil_7_2_6,zpos_InjectUtil_7_2_6;
	wire[7:0] zneg_ClockwiseUtil_7_2_6,zneg_CounterClockwiseUtil_7_2_6,zneg_InjectUtil_7_2_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_2_7, eject_xpos_ser_7_2_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_2_7, eject_xneg_ser_7_2_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_2_7, eject_ypos_ser_7_2_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_2_7, eject_yneg_ser_7_2_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_2_7, eject_zpos_ser_7_2_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_2_7, eject_zneg_ser_7_2_7;
	wire[7:0] xpos_ClockwiseUtil_7_2_7,xpos_CounterClockwiseUtil_7_2_7,xpos_InjectUtil_7_2_7;
	wire[7:0] xneg_ClockwiseUtil_7_2_7,xneg_CounterClockwiseUtil_7_2_7,xneg_InjectUtil_7_2_7;
	wire[7:0] ypos_ClockwiseUtil_7_2_7,ypos_CounterClockwiseUtil_7_2_7,ypos_InjectUtil_7_2_7;
	wire[7:0] yneg_ClockwiseUtil_7_2_7,yneg_CounterClockwiseUtil_7_2_7,yneg_InjectUtil_7_2_7;
	wire[7:0] zpos_ClockwiseUtil_7_2_7,zpos_CounterClockwiseUtil_7_2_7,zpos_InjectUtil_7_2_7;
	wire[7:0] zneg_ClockwiseUtil_7_2_7,zneg_CounterClockwiseUtil_7_2_7,zneg_InjectUtil_7_2_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_0, eject_xpos_ser_7_3_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_0, eject_xneg_ser_7_3_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_0, eject_ypos_ser_7_3_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_0, eject_yneg_ser_7_3_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_0, eject_zpos_ser_7_3_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_0, eject_zneg_ser_7_3_0;
	wire[7:0] xpos_ClockwiseUtil_7_3_0,xpos_CounterClockwiseUtil_7_3_0,xpos_InjectUtil_7_3_0;
	wire[7:0] xneg_ClockwiseUtil_7_3_0,xneg_CounterClockwiseUtil_7_3_0,xneg_InjectUtil_7_3_0;
	wire[7:0] ypos_ClockwiseUtil_7_3_0,ypos_CounterClockwiseUtil_7_3_0,ypos_InjectUtil_7_3_0;
	wire[7:0] yneg_ClockwiseUtil_7_3_0,yneg_CounterClockwiseUtil_7_3_0,yneg_InjectUtil_7_3_0;
	wire[7:0] zpos_ClockwiseUtil_7_3_0,zpos_CounterClockwiseUtil_7_3_0,zpos_InjectUtil_7_3_0;
	wire[7:0] zneg_ClockwiseUtil_7_3_0,zneg_CounterClockwiseUtil_7_3_0,zneg_InjectUtil_7_3_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_1, eject_xpos_ser_7_3_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_1, eject_xneg_ser_7_3_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_1, eject_ypos_ser_7_3_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_1, eject_yneg_ser_7_3_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_1, eject_zpos_ser_7_3_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_1, eject_zneg_ser_7_3_1;
	wire[7:0] xpos_ClockwiseUtil_7_3_1,xpos_CounterClockwiseUtil_7_3_1,xpos_InjectUtil_7_3_1;
	wire[7:0] xneg_ClockwiseUtil_7_3_1,xneg_CounterClockwiseUtil_7_3_1,xneg_InjectUtil_7_3_1;
	wire[7:0] ypos_ClockwiseUtil_7_3_1,ypos_CounterClockwiseUtil_7_3_1,ypos_InjectUtil_7_3_1;
	wire[7:0] yneg_ClockwiseUtil_7_3_1,yneg_CounterClockwiseUtil_7_3_1,yneg_InjectUtil_7_3_1;
	wire[7:0] zpos_ClockwiseUtil_7_3_1,zpos_CounterClockwiseUtil_7_3_1,zpos_InjectUtil_7_3_1;
	wire[7:0] zneg_ClockwiseUtil_7_3_1,zneg_CounterClockwiseUtil_7_3_1,zneg_InjectUtil_7_3_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_2, eject_xpos_ser_7_3_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_2, eject_xneg_ser_7_3_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_2, eject_ypos_ser_7_3_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_2, eject_yneg_ser_7_3_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_2, eject_zpos_ser_7_3_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_2, eject_zneg_ser_7_3_2;
	wire[7:0] xpos_ClockwiseUtil_7_3_2,xpos_CounterClockwiseUtil_7_3_2,xpos_InjectUtil_7_3_2;
	wire[7:0] xneg_ClockwiseUtil_7_3_2,xneg_CounterClockwiseUtil_7_3_2,xneg_InjectUtil_7_3_2;
	wire[7:0] ypos_ClockwiseUtil_7_3_2,ypos_CounterClockwiseUtil_7_3_2,ypos_InjectUtil_7_3_2;
	wire[7:0] yneg_ClockwiseUtil_7_3_2,yneg_CounterClockwiseUtil_7_3_2,yneg_InjectUtil_7_3_2;
	wire[7:0] zpos_ClockwiseUtil_7_3_2,zpos_CounterClockwiseUtil_7_3_2,zpos_InjectUtil_7_3_2;
	wire[7:0] zneg_ClockwiseUtil_7_3_2,zneg_CounterClockwiseUtil_7_3_2,zneg_InjectUtil_7_3_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_3, eject_xpos_ser_7_3_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_3, eject_xneg_ser_7_3_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_3, eject_ypos_ser_7_3_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_3, eject_yneg_ser_7_3_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_3, eject_zpos_ser_7_3_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_3, eject_zneg_ser_7_3_3;
	wire[7:0] xpos_ClockwiseUtil_7_3_3,xpos_CounterClockwiseUtil_7_3_3,xpos_InjectUtil_7_3_3;
	wire[7:0] xneg_ClockwiseUtil_7_3_3,xneg_CounterClockwiseUtil_7_3_3,xneg_InjectUtil_7_3_3;
	wire[7:0] ypos_ClockwiseUtil_7_3_3,ypos_CounterClockwiseUtil_7_3_3,ypos_InjectUtil_7_3_3;
	wire[7:0] yneg_ClockwiseUtil_7_3_3,yneg_CounterClockwiseUtil_7_3_3,yneg_InjectUtil_7_3_3;
	wire[7:0] zpos_ClockwiseUtil_7_3_3,zpos_CounterClockwiseUtil_7_3_3,zpos_InjectUtil_7_3_3;
	wire[7:0] zneg_ClockwiseUtil_7_3_3,zneg_CounterClockwiseUtil_7_3_3,zneg_InjectUtil_7_3_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_4, eject_xpos_ser_7_3_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_4, eject_xneg_ser_7_3_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_4, eject_ypos_ser_7_3_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_4, eject_yneg_ser_7_3_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_4, eject_zpos_ser_7_3_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_4, eject_zneg_ser_7_3_4;
	wire[7:0] xpos_ClockwiseUtil_7_3_4,xpos_CounterClockwiseUtil_7_3_4,xpos_InjectUtil_7_3_4;
	wire[7:0] xneg_ClockwiseUtil_7_3_4,xneg_CounterClockwiseUtil_7_3_4,xneg_InjectUtil_7_3_4;
	wire[7:0] ypos_ClockwiseUtil_7_3_4,ypos_CounterClockwiseUtil_7_3_4,ypos_InjectUtil_7_3_4;
	wire[7:0] yneg_ClockwiseUtil_7_3_4,yneg_CounterClockwiseUtil_7_3_4,yneg_InjectUtil_7_3_4;
	wire[7:0] zpos_ClockwiseUtil_7_3_4,zpos_CounterClockwiseUtil_7_3_4,zpos_InjectUtil_7_3_4;
	wire[7:0] zneg_ClockwiseUtil_7_3_4,zneg_CounterClockwiseUtil_7_3_4,zneg_InjectUtil_7_3_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_5, eject_xpos_ser_7_3_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_5, eject_xneg_ser_7_3_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_5, eject_ypos_ser_7_3_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_5, eject_yneg_ser_7_3_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_5, eject_zpos_ser_7_3_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_5, eject_zneg_ser_7_3_5;
	wire[7:0] xpos_ClockwiseUtil_7_3_5,xpos_CounterClockwiseUtil_7_3_5,xpos_InjectUtil_7_3_5;
	wire[7:0] xneg_ClockwiseUtil_7_3_5,xneg_CounterClockwiseUtil_7_3_5,xneg_InjectUtil_7_3_5;
	wire[7:0] ypos_ClockwiseUtil_7_3_5,ypos_CounterClockwiseUtil_7_3_5,ypos_InjectUtil_7_3_5;
	wire[7:0] yneg_ClockwiseUtil_7_3_5,yneg_CounterClockwiseUtil_7_3_5,yneg_InjectUtil_7_3_5;
	wire[7:0] zpos_ClockwiseUtil_7_3_5,zpos_CounterClockwiseUtil_7_3_5,zpos_InjectUtil_7_3_5;
	wire[7:0] zneg_ClockwiseUtil_7_3_5,zneg_CounterClockwiseUtil_7_3_5,zneg_InjectUtil_7_3_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_6, eject_xpos_ser_7_3_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_6, eject_xneg_ser_7_3_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_6, eject_ypos_ser_7_3_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_6, eject_yneg_ser_7_3_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_6, eject_zpos_ser_7_3_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_6, eject_zneg_ser_7_3_6;
	wire[7:0] xpos_ClockwiseUtil_7_3_6,xpos_CounterClockwiseUtil_7_3_6,xpos_InjectUtil_7_3_6;
	wire[7:0] xneg_ClockwiseUtil_7_3_6,xneg_CounterClockwiseUtil_7_3_6,xneg_InjectUtil_7_3_6;
	wire[7:0] ypos_ClockwiseUtil_7_3_6,ypos_CounterClockwiseUtil_7_3_6,ypos_InjectUtil_7_3_6;
	wire[7:0] yneg_ClockwiseUtil_7_3_6,yneg_CounterClockwiseUtil_7_3_6,yneg_InjectUtil_7_3_6;
	wire[7:0] zpos_ClockwiseUtil_7_3_6,zpos_CounterClockwiseUtil_7_3_6,zpos_InjectUtil_7_3_6;
	wire[7:0] zneg_ClockwiseUtil_7_3_6,zneg_CounterClockwiseUtil_7_3_6,zneg_InjectUtil_7_3_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_3_7, eject_xpos_ser_7_3_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_3_7, eject_xneg_ser_7_3_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_3_7, eject_ypos_ser_7_3_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_3_7, eject_yneg_ser_7_3_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_3_7, eject_zpos_ser_7_3_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_3_7, eject_zneg_ser_7_3_7;
	wire[7:0] xpos_ClockwiseUtil_7_3_7,xpos_CounterClockwiseUtil_7_3_7,xpos_InjectUtil_7_3_7;
	wire[7:0] xneg_ClockwiseUtil_7_3_7,xneg_CounterClockwiseUtil_7_3_7,xneg_InjectUtil_7_3_7;
	wire[7:0] ypos_ClockwiseUtil_7_3_7,ypos_CounterClockwiseUtil_7_3_7,ypos_InjectUtil_7_3_7;
	wire[7:0] yneg_ClockwiseUtil_7_3_7,yneg_CounterClockwiseUtil_7_3_7,yneg_InjectUtil_7_3_7;
	wire[7:0] zpos_ClockwiseUtil_7_3_7,zpos_CounterClockwiseUtil_7_3_7,zpos_InjectUtil_7_3_7;
	wire[7:0] zneg_ClockwiseUtil_7_3_7,zneg_CounterClockwiseUtil_7_3_7,zneg_InjectUtil_7_3_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_0, eject_xpos_ser_7_4_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_0, eject_xneg_ser_7_4_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_0, eject_ypos_ser_7_4_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_0, eject_yneg_ser_7_4_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_0, eject_zpos_ser_7_4_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_0, eject_zneg_ser_7_4_0;
	wire[7:0] xpos_ClockwiseUtil_7_4_0,xpos_CounterClockwiseUtil_7_4_0,xpos_InjectUtil_7_4_0;
	wire[7:0] xneg_ClockwiseUtil_7_4_0,xneg_CounterClockwiseUtil_7_4_0,xneg_InjectUtil_7_4_0;
	wire[7:0] ypos_ClockwiseUtil_7_4_0,ypos_CounterClockwiseUtil_7_4_0,ypos_InjectUtil_7_4_0;
	wire[7:0] yneg_ClockwiseUtil_7_4_0,yneg_CounterClockwiseUtil_7_4_0,yneg_InjectUtil_7_4_0;
	wire[7:0] zpos_ClockwiseUtil_7_4_0,zpos_CounterClockwiseUtil_7_4_0,zpos_InjectUtil_7_4_0;
	wire[7:0] zneg_ClockwiseUtil_7_4_0,zneg_CounterClockwiseUtil_7_4_0,zneg_InjectUtil_7_4_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_1, eject_xpos_ser_7_4_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_1, eject_xneg_ser_7_4_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_1, eject_ypos_ser_7_4_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_1, eject_yneg_ser_7_4_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_1, eject_zpos_ser_7_4_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_1, eject_zneg_ser_7_4_1;
	wire[7:0] xpos_ClockwiseUtil_7_4_1,xpos_CounterClockwiseUtil_7_4_1,xpos_InjectUtil_7_4_1;
	wire[7:0] xneg_ClockwiseUtil_7_4_1,xneg_CounterClockwiseUtil_7_4_1,xneg_InjectUtil_7_4_1;
	wire[7:0] ypos_ClockwiseUtil_7_4_1,ypos_CounterClockwiseUtil_7_4_1,ypos_InjectUtil_7_4_1;
	wire[7:0] yneg_ClockwiseUtil_7_4_1,yneg_CounterClockwiseUtil_7_4_1,yneg_InjectUtil_7_4_1;
	wire[7:0] zpos_ClockwiseUtil_7_4_1,zpos_CounterClockwiseUtil_7_4_1,zpos_InjectUtil_7_4_1;
	wire[7:0] zneg_ClockwiseUtil_7_4_1,zneg_CounterClockwiseUtil_7_4_1,zneg_InjectUtil_7_4_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_2, eject_xpos_ser_7_4_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_2, eject_xneg_ser_7_4_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_2, eject_ypos_ser_7_4_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_2, eject_yneg_ser_7_4_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_2, eject_zpos_ser_7_4_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_2, eject_zneg_ser_7_4_2;
	wire[7:0] xpos_ClockwiseUtil_7_4_2,xpos_CounterClockwiseUtil_7_4_2,xpos_InjectUtil_7_4_2;
	wire[7:0] xneg_ClockwiseUtil_7_4_2,xneg_CounterClockwiseUtil_7_4_2,xneg_InjectUtil_7_4_2;
	wire[7:0] ypos_ClockwiseUtil_7_4_2,ypos_CounterClockwiseUtil_7_4_2,ypos_InjectUtil_7_4_2;
	wire[7:0] yneg_ClockwiseUtil_7_4_2,yneg_CounterClockwiseUtil_7_4_2,yneg_InjectUtil_7_4_2;
	wire[7:0] zpos_ClockwiseUtil_7_4_2,zpos_CounterClockwiseUtil_7_4_2,zpos_InjectUtil_7_4_2;
	wire[7:0] zneg_ClockwiseUtil_7_4_2,zneg_CounterClockwiseUtil_7_4_2,zneg_InjectUtil_7_4_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_3, eject_xpos_ser_7_4_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_3, eject_xneg_ser_7_4_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_3, eject_ypos_ser_7_4_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_3, eject_yneg_ser_7_4_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_3, eject_zpos_ser_7_4_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_3, eject_zneg_ser_7_4_3;
	wire[7:0] xpos_ClockwiseUtil_7_4_3,xpos_CounterClockwiseUtil_7_4_3,xpos_InjectUtil_7_4_3;
	wire[7:0] xneg_ClockwiseUtil_7_4_3,xneg_CounterClockwiseUtil_7_4_3,xneg_InjectUtil_7_4_3;
	wire[7:0] ypos_ClockwiseUtil_7_4_3,ypos_CounterClockwiseUtil_7_4_3,ypos_InjectUtil_7_4_3;
	wire[7:0] yneg_ClockwiseUtil_7_4_3,yneg_CounterClockwiseUtil_7_4_3,yneg_InjectUtil_7_4_3;
	wire[7:0] zpos_ClockwiseUtil_7_4_3,zpos_CounterClockwiseUtil_7_4_3,zpos_InjectUtil_7_4_3;
	wire[7:0] zneg_ClockwiseUtil_7_4_3,zneg_CounterClockwiseUtil_7_4_3,zneg_InjectUtil_7_4_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_4, eject_xpos_ser_7_4_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_4, eject_xneg_ser_7_4_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_4, eject_ypos_ser_7_4_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_4, eject_yneg_ser_7_4_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_4, eject_zpos_ser_7_4_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_4, eject_zneg_ser_7_4_4;
	wire[7:0] xpos_ClockwiseUtil_7_4_4,xpos_CounterClockwiseUtil_7_4_4,xpos_InjectUtil_7_4_4;
	wire[7:0] xneg_ClockwiseUtil_7_4_4,xneg_CounterClockwiseUtil_7_4_4,xneg_InjectUtil_7_4_4;
	wire[7:0] ypos_ClockwiseUtil_7_4_4,ypos_CounterClockwiseUtil_7_4_4,ypos_InjectUtil_7_4_4;
	wire[7:0] yneg_ClockwiseUtil_7_4_4,yneg_CounterClockwiseUtil_7_4_4,yneg_InjectUtil_7_4_4;
	wire[7:0] zpos_ClockwiseUtil_7_4_4,zpos_CounterClockwiseUtil_7_4_4,zpos_InjectUtil_7_4_4;
	wire[7:0] zneg_ClockwiseUtil_7_4_4,zneg_CounterClockwiseUtil_7_4_4,zneg_InjectUtil_7_4_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_5, eject_xpos_ser_7_4_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_5, eject_xneg_ser_7_4_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_5, eject_ypos_ser_7_4_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_5, eject_yneg_ser_7_4_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_5, eject_zpos_ser_7_4_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_5, eject_zneg_ser_7_4_5;
	wire[7:0] xpos_ClockwiseUtil_7_4_5,xpos_CounterClockwiseUtil_7_4_5,xpos_InjectUtil_7_4_5;
	wire[7:0] xneg_ClockwiseUtil_7_4_5,xneg_CounterClockwiseUtil_7_4_5,xneg_InjectUtil_7_4_5;
	wire[7:0] ypos_ClockwiseUtil_7_4_5,ypos_CounterClockwiseUtil_7_4_5,ypos_InjectUtil_7_4_5;
	wire[7:0] yneg_ClockwiseUtil_7_4_5,yneg_CounterClockwiseUtil_7_4_5,yneg_InjectUtil_7_4_5;
	wire[7:0] zpos_ClockwiseUtil_7_4_5,zpos_CounterClockwiseUtil_7_4_5,zpos_InjectUtil_7_4_5;
	wire[7:0] zneg_ClockwiseUtil_7_4_5,zneg_CounterClockwiseUtil_7_4_5,zneg_InjectUtil_7_4_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_6, eject_xpos_ser_7_4_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_6, eject_xneg_ser_7_4_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_6, eject_ypos_ser_7_4_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_6, eject_yneg_ser_7_4_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_6, eject_zpos_ser_7_4_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_6, eject_zneg_ser_7_4_6;
	wire[7:0] xpos_ClockwiseUtil_7_4_6,xpos_CounterClockwiseUtil_7_4_6,xpos_InjectUtil_7_4_6;
	wire[7:0] xneg_ClockwiseUtil_7_4_6,xneg_CounterClockwiseUtil_7_4_6,xneg_InjectUtil_7_4_6;
	wire[7:0] ypos_ClockwiseUtil_7_4_6,ypos_CounterClockwiseUtil_7_4_6,ypos_InjectUtil_7_4_6;
	wire[7:0] yneg_ClockwiseUtil_7_4_6,yneg_CounterClockwiseUtil_7_4_6,yneg_InjectUtil_7_4_6;
	wire[7:0] zpos_ClockwiseUtil_7_4_6,zpos_CounterClockwiseUtil_7_4_6,zpos_InjectUtil_7_4_6;
	wire[7:0] zneg_ClockwiseUtil_7_4_6,zneg_CounterClockwiseUtil_7_4_6,zneg_InjectUtil_7_4_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_4_7, eject_xpos_ser_7_4_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_4_7, eject_xneg_ser_7_4_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_4_7, eject_ypos_ser_7_4_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_4_7, eject_yneg_ser_7_4_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_4_7, eject_zpos_ser_7_4_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_4_7, eject_zneg_ser_7_4_7;
	wire[7:0] xpos_ClockwiseUtil_7_4_7,xpos_CounterClockwiseUtil_7_4_7,xpos_InjectUtil_7_4_7;
	wire[7:0] xneg_ClockwiseUtil_7_4_7,xneg_CounterClockwiseUtil_7_4_7,xneg_InjectUtil_7_4_7;
	wire[7:0] ypos_ClockwiseUtil_7_4_7,ypos_CounterClockwiseUtil_7_4_7,ypos_InjectUtil_7_4_7;
	wire[7:0] yneg_ClockwiseUtil_7_4_7,yneg_CounterClockwiseUtil_7_4_7,yneg_InjectUtil_7_4_7;
	wire[7:0] zpos_ClockwiseUtil_7_4_7,zpos_CounterClockwiseUtil_7_4_7,zpos_InjectUtil_7_4_7;
	wire[7:0] zneg_ClockwiseUtil_7_4_7,zneg_CounterClockwiseUtil_7_4_7,zneg_InjectUtil_7_4_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_0, eject_xpos_ser_7_5_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_0, eject_xneg_ser_7_5_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_0, eject_ypos_ser_7_5_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_0, eject_yneg_ser_7_5_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_0, eject_zpos_ser_7_5_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_0, eject_zneg_ser_7_5_0;
	wire[7:0] xpos_ClockwiseUtil_7_5_0,xpos_CounterClockwiseUtil_7_5_0,xpos_InjectUtil_7_5_0;
	wire[7:0] xneg_ClockwiseUtil_7_5_0,xneg_CounterClockwiseUtil_7_5_0,xneg_InjectUtil_7_5_0;
	wire[7:0] ypos_ClockwiseUtil_7_5_0,ypos_CounterClockwiseUtil_7_5_0,ypos_InjectUtil_7_5_0;
	wire[7:0] yneg_ClockwiseUtil_7_5_0,yneg_CounterClockwiseUtil_7_5_0,yneg_InjectUtil_7_5_0;
	wire[7:0] zpos_ClockwiseUtil_7_5_0,zpos_CounterClockwiseUtil_7_5_0,zpos_InjectUtil_7_5_0;
	wire[7:0] zneg_ClockwiseUtil_7_5_0,zneg_CounterClockwiseUtil_7_5_0,zneg_InjectUtil_7_5_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_1, eject_xpos_ser_7_5_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_1, eject_xneg_ser_7_5_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_1, eject_ypos_ser_7_5_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_1, eject_yneg_ser_7_5_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_1, eject_zpos_ser_7_5_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_1, eject_zneg_ser_7_5_1;
	wire[7:0] xpos_ClockwiseUtil_7_5_1,xpos_CounterClockwiseUtil_7_5_1,xpos_InjectUtil_7_5_1;
	wire[7:0] xneg_ClockwiseUtil_7_5_1,xneg_CounterClockwiseUtil_7_5_1,xneg_InjectUtil_7_5_1;
	wire[7:0] ypos_ClockwiseUtil_7_5_1,ypos_CounterClockwiseUtil_7_5_1,ypos_InjectUtil_7_5_1;
	wire[7:0] yneg_ClockwiseUtil_7_5_1,yneg_CounterClockwiseUtil_7_5_1,yneg_InjectUtil_7_5_1;
	wire[7:0] zpos_ClockwiseUtil_7_5_1,zpos_CounterClockwiseUtil_7_5_1,zpos_InjectUtil_7_5_1;
	wire[7:0] zneg_ClockwiseUtil_7_5_1,zneg_CounterClockwiseUtil_7_5_1,zneg_InjectUtil_7_5_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_2, eject_xpos_ser_7_5_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_2, eject_xneg_ser_7_5_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_2, eject_ypos_ser_7_5_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_2, eject_yneg_ser_7_5_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_2, eject_zpos_ser_7_5_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_2, eject_zneg_ser_7_5_2;
	wire[7:0] xpos_ClockwiseUtil_7_5_2,xpos_CounterClockwiseUtil_7_5_2,xpos_InjectUtil_7_5_2;
	wire[7:0] xneg_ClockwiseUtil_7_5_2,xneg_CounterClockwiseUtil_7_5_2,xneg_InjectUtil_7_5_2;
	wire[7:0] ypos_ClockwiseUtil_7_5_2,ypos_CounterClockwiseUtil_7_5_2,ypos_InjectUtil_7_5_2;
	wire[7:0] yneg_ClockwiseUtil_7_5_2,yneg_CounterClockwiseUtil_7_5_2,yneg_InjectUtil_7_5_2;
	wire[7:0] zpos_ClockwiseUtil_7_5_2,zpos_CounterClockwiseUtil_7_5_2,zpos_InjectUtil_7_5_2;
	wire[7:0] zneg_ClockwiseUtil_7_5_2,zneg_CounterClockwiseUtil_7_5_2,zneg_InjectUtil_7_5_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_3, eject_xpos_ser_7_5_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_3, eject_xneg_ser_7_5_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_3, eject_ypos_ser_7_5_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_3, eject_yneg_ser_7_5_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_3, eject_zpos_ser_7_5_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_3, eject_zneg_ser_7_5_3;
	wire[7:0] xpos_ClockwiseUtil_7_5_3,xpos_CounterClockwiseUtil_7_5_3,xpos_InjectUtil_7_5_3;
	wire[7:0] xneg_ClockwiseUtil_7_5_3,xneg_CounterClockwiseUtil_7_5_3,xneg_InjectUtil_7_5_3;
	wire[7:0] ypos_ClockwiseUtil_7_5_3,ypos_CounterClockwiseUtil_7_5_3,ypos_InjectUtil_7_5_3;
	wire[7:0] yneg_ClockwiseUtil_7_5_3,yneg_CounterClockwiseUtil_7_5_3,yneg_InjectUtil_7_5_3;
	wire[7:0] zpos_ClockwiseUtil_7_5_3,zpos_CounterClockwiseUtil_7_5_3,zpos_InjectUtil_7_5_3;
	wire[7:0] zneg_ClockwiseUtil_7_5_3,zneg_CounterClockwiseUtil_7_5_3,zneg_InjectUtil_7_5_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_4, eject_xpos_ser_7_5_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_4, eject_xneg_ser_7_5_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_4, eject_ypos_ser_7_5_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_4, eject_yneg_ser_7_5_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_4, eject_zpos_ser_7_5_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_4, eject_zneg_ser_7_5_4;
	wire[7:0] xpos_ClockwiseUtil_7_5_4,xpos_CounterClockwiseUtil_7_5_4,xpos_InjectUtil_7_5_4;
	wire[7:0] xneg_ClockwiseUtil_7_5_4,xneg_CounterClockwiseUtil_7_5_4,xneg_InjectUtil_7_5_4;
	wire[7:0] ypos_ClockwiseUtil_7_5_4,ypos_CounterClockwiseUtil_7_5_4,ypos_InjectUtil_7_5_4;
	wire[7:0] yneg_ClockwiseUtil_7_5_4,yneg_CounterClockwiseUtil_7_5_4,yneg_InjectUtil_7_5_4;
	wire[7:0] zpos_ClockwiseUtil_7_5_4,zpos_CounterClockwiseUtil_7_5_4,zpos_InjectUtil_7_5_4;
	wire[7:0] zneg_ClockwiseUtil_7_5_4,zneg_CounterClockwiseUtil_7_5_4,zneg_InjectUtil_7_5_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_5, eject_xpos_ser_7_5_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_5, eject_xneg_ser_7_5_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_5, eject_ypos_ser_7_5_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_5, eject_yneg_ser_7_5_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_5, eject_zpos_ser_7_5_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_5, eject_zneg_ser_7_5_5;
	wire[7:0] xpos_ClockwiseUtil_7_5_5,xpos_CounterClockwiseUtil_7_5_5,xpos_InjectUtil_7_5_5;
	wire[7:0] xneg_ClockwiseUtil_7_5_5,xneg_CounterClockwiseUtil_7_5_5,xneg_InjectUtil_7_5_5;
	wire[7:0] ypos_ClockwiseUtil_7_5_5,ypos_CounterClockwiseUtil_7_5_5,ypos_InjectUtil_7_5_5;
	wire[7:0] yneg_ClockwiseUtil_7_5_5,yneg_CounterClockwiseUtil_7_5_5,yneg_InjectUtil_7_5_5;
	wire[7:0] zpos_ClockwiseUtil_7_5_5,zpos_CounterClockwiseUtil_7_5_5,zpos_InjectUtil_7_5_5;
	wire[7:0] zneg_ClockwiseUtil_7_5_5,zneg_CounterClockwiseUtil_7_5_5,zneg_InjectUtil_7_5_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_6, eject_xpos_ser_7_5_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_6, eject_xneg_ser_7_5_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_6, eject_ypos_ser_7_5_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_6, eject_yneg_ser_7_5_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_6, eject_zpos_ser_7_5_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_6, eject_zneg_ser_7_5_6;
	wire[7:0] xpos_ClockwiseUtil_7_5_6,xpos_CounterClockwiseUtil_7_5_6,xpos_InjectUtil_7_5_6;
	wire[7:0] xneg_ClockwiseUtil_7_5_6,xneg_CounterClockwiseUtil_7_5_6,xneg_InjectUtil_7_5_6;
	wire[7:0] ypos_ClockwiseUtil_7_5_6,ypos_CounterClockwiseUtil_7_5_6,ypos_InjectUtil_7_5_6;
	wire[7:0] yneg_ClockwiseUtil_7_5_6,yneg_CounterClockwiseUtil_7_5_6,yneg_InjectUtil_7_5_6;
	wire[7:0] zpos_ClockwiseUtil_7_5_6,zpos_CounterClockwiseUtil_7_5_6,zpos_InjectUtil_7_5_6;
	wire[7:0] zneg_ClockwiseUtil_7_5_6,zneg_CounterClockwiseUtil_7_5_6,zneg_InjectUtil_7_5_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_5_7, eject_xpos_ser_7_5_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_5_7, eject_xneg_ser_7_5_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_5_7, eject_ypos_ser_7_5_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_5_7, eject_yneg_ser_7_5_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_5_7, eject_zpos_ser_7_5_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_5_7, eject_zneg_ser_7_5_7;
	wire[7:0] xpos_ClockwiseUtil_7_5_7,xpos_CounterClockwiseUtil_7_5_7,xpos_InjectUtil_7_5_7;
	wire[7:0] xneg_ClockwiseUtil_7_5_7,xneg_CounterClockwiseUtil_7_5_7,xneg_InjectUtil_7_5_7;
	wire[7:0] ypos_ClockwiseUtil_7_5_7,ypos_CounterClockwiseUtil_7_5_7,ypos_InjectUtil_7_5_7;
	wire[7:0] yneg_ClockwiseUtil_7_5_7,yneg_CounterClockwiseUtil_7_5_7,yneg_InjectUtil_7_5_7;
	wire[7:0] zpos_ClockwiseUtil_7_5_7,zpos_CounterClockwiseUtil_7_5_7,zpos_InjectUtil_7_5_7;
	wire[7:0] zneg_ClockwiseUtil_7_5_7,zneg_CounterClockwiseUtil_7_5_7,zneg_InjectUtil_7_5_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_0, eject_xpos_ser_7_6_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_0, eject_xneg_ser_7_6_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_0, eject_ypos_ser_7_6_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_0, eject_yneg_ser_7_6_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_0, eject_zpos_ser_7_6_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_0, eject_zneg_ser_7_6_0;
	wire[7:0] xpos_ClockwiseUtil_7_6_0,xpos_CounterClockwiseUtil_7_6_0,xpos_InjectUtil_7_6_0;
	wire[7:0] xneg_ClockwiseUtil_7_6_0,xneg_CounterClockwiseUtil_7_6_0,xneg_InjectUtil_7_6_0;
	wire[7:0] ypos_ClockwiseUtil_7_6_0,ypos_CounterClockwiseUtil_7_6_0,ypos_InjectUtil_7_6_0;
	wire[7:0] yneg_ClockwiseUtil_7_6_0,yneg_CounterClockwiseUtil_7_6_0,yneg_InjectUtil_7_6_0;
	wire[7:0] zpos_ClockwiseUtil_7_6_0,zpos_CounterClockwiseUtil_7_6_0,zpos_InjectUtil_7_6_0;
	wire[7:0] zneg_ClockwiseUtil_7_6_0,zneg_CounterClockwiseUtil_7_6_0,zneg_InjectUtil_7_6_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_1, eject_xpos_ser_7_6_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_1, eject_xneg_ser_7_6_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_1, eject_ypos_ser_7_6_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_1, eject_yneg_ser_7_6_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_1, eject_zpos_ser_7_6_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_1, eject_zneg_ser_7_6_1;
	wire[7:0] xpos_ClockwiseUtil_7_6_1,xpos_CounterClockwiseUtil_7_6_1,xpos_InjectUtil_7_6_1;
	wire[7:0] xneg_ClockwiseUtil_7_6_1,xneg_CounterClockwiseUtil_7_6_1,xneg_InjectUtil_7_6_1;
	wire[7:0] ypos_ClockwiseUtil_7_6_1,ypos_CounterClockwiseUtil_7_6_1,ypos_InjectUtil_7_6_1;
	wire[7:0] yneg_ClockwiseUtil_7_6_1,yneg_CounterClockwiseUtil_7_6_1,yneg_InjectUtil_7_6_1;
	wire[7:0] zpos_ClockwiseUtil_7_6_1,zpos_CounterClockwiseUtil_7_6_1,zpos_InjectUtil_7_6_1;
	wire[7:0] zneg_ClockwiseUtil_7_6_1,zneg_CounterClockwiseUtil_7_6_1,zneg_InjectUtil_7_6_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_2, eject_xpos_ser_7_6_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_2, eject_xneg_ser_7_6_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_2, eject_ypos_ser_7_6_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_2, eject_yneg_ser_7_6_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_2, eject_zpos_ser_7_6_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_2, eject_zneg_ser_7_6_2;
	wire[7:0] xpos_ClockwiseUtil_7_6_2,xpos_CounterClockwiseUtil_7_6_2,xpos_InjectUtil_7_6_2;
	wire[7:0] xneg_ClockwiseUtil_7_6_2,xneg_CounterClockwiseUtil_7_6_2,xneg_InjectUtil_7_6_2;
	wire[7:0] ypos_ClockwiseUtil_7_6_2,ypos_CounterClockwiseUtil_7_6_2,ypos_InjectUtil_7_6_2;
	wire[7:0] yneg_ClockwiseUtil_7_6_2,yneg_CounterClockwiseUtil_7_6_2,yneg_InjectUtil_7_6_2;
	wire[7:0] zpos_ClockwiseUtil_7_6_2,zpos_CounterClockwiseUtil_7_6_2,zpos_InjectUtil_7_6_2;
	wire[7:0] zneg_ClockwiseUtil_7_6_2,zneg_CounterClockwiseUtil_7_6_2,zneg_InjectUtil_7_6_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_3, eject_xpos_ser_7_6_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_3, eject_xneg_ser_7_6_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_3, eject_ypos_ser_7_6_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_3, eject_yneg_ser_7_6_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_3, eject_zpos_ser_7_6_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_3, eject_zneg_ser_7_6_3;
	wire[7:0] xpos_ClockwiseUtil_7_6_3,xpos_CounterClockwiseUtil_7_6_3,xpos_InjectUtil_7_6_3;
	wire[7:0] xneg_ClockwiseUtil_7_6_3,xneg_CounterClockwiseUtil_7_6_3,xneg_InjectUtil_7_6_3;
	wire[7:0] ypos_ClockwiseUtil_7_6_3,ypos_CounterClockwiseUtil_7_6_3,ypos_InjectUtil_7_6_3;
	wire[7:0] yneg_ClockwiseUtil_7_6_3,yneg_CounterClockwiseUtil_7_6_3,yneg_InjectUtil_7_6_3;
	wire[7:0] zpos_ClockwiseUtil_7_6_3,zpos_CounterClockwiseUtil_7_6_3,zpos_InjectUtil_7_6_3;
	wire[7:0] zneg_ClockwiseUtil_7_6_3,zneg_CounterClockwiseUtil_7_6_3,zneg_InjectUtil_7_6_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_4, eject_xpos_ser_7_6_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_4, eject_xneg_ser_7_6_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_4, eject_ypos_ser_7_6_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_4, eject_yneg_ser_7_6_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_4, eject_zpos_ser_7_6_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_4, eject_zneg_ser_7_6_4;
	wire[7:0] xpos_ClockwiseUtil_7_6_4,xpos_CounterClockwiseUtil_7_6_4,xpos_InjectUtil_7_6_4;
	wire[7:0] xneg_ClockwiseUtil_7_6_4,xneg_CounterClockwiseUtil_7_6_4,xneg_InjectUtil_7_6_4;
	wire[7:0] ypos_ClockwiseUtil_7_6_4,ypos_CounterClockwiseUtil_7_6_4,ypos_InjectUtil_7_6_4;
	wire[7:0] yneg_ClockwiseUtil_7_6_4,yneg_CounterClockwiseUtil_7_6_4,yneg_InjectUtil_7_6_4;
	wire[7:0] zpos_ClockwiseUtil_7_6_4,zpos_CounterClockwiseUtil_7_6_4,zpos_InjectUtil_7_6_4;
	wire[7:0] zneg_ClockwiseUtil_7_6_4,zneg_CounterClockwiseUtil_7_6_4,zneg_InjectUtil_7_6_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_5, eject_xpos_ser_7_6_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_5, eject_xneg_ser_7_6_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_5, eject_ypos_ser_7_6_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_5, eject_yneg_ser_7_6_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_5, eject_zpos_ser_7_6_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_5, eject_zneg_ser_7_6_5;
	wire[7:0] xpos_ClockwiseUtil_7_6_5,xpos_CounterClockwiseUtil_7_6_5,xpos_InjectUtil_7_6_5;
	wire[7:0] xneg_ClockwiseUtil_7_6_5,xneg_CounterClockwiseUtil_7_6_5,xneg_InjectUtil_7_6_5;
	wire[7:0] ypos_ClockwiseUtil_7_6_5,ypos_CounterClockwiseUtil_7_6_5,ypos_InjectUtil_7_6_5;
	wire[7:0] yneg_ClockwiseUtil_7_6_5,yneg_CounterClockwiseUtil_7_6_5,yneg_InjectUtil_7_6_5;
	wire[7:0] zpos_ClockwiseUtil_7_6_5,zpos_CounterClockwiseUtil_7_6_5,zpos_InjectUtil_7_6_5;
	wire[7:0] zneg_ClockwiseUtil_7_6_5,zneg_CounterClockwiseUtil_7_6_5,zneg_InjectUtil_7_6_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_6, eject_xpos_ser_7_6_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_6, eject_xneg_ser_7_6_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_6, eject_ypos_ser_7_6_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_6, eject_yneg_ser_7_6_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_6, eject_zpos_ser_7_6_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_6, eject_zneg_ser_7_6_6;
	wire[7:0] xpos_ClockwiseUtil_7_6_6,xpos_CounterClockwiseUtil_7_6_6,xpos_InjectUtil_7_6_6;
	wire[7:0] xneg_ClockwiseUtil_7_6_6,xneg_CounterClockwiseUtil_7_6_6,xneg_InjectUtil_7_6_6;
	wire[7:0] ypos_ClockwiseUtil_7_6_6,ypos_CounterClockwiseUtil_7_6_6,ypos_InjectUtil_7_6_6;
	wire[7:0] yneg_ClockwiseUtil_7_6_6,yneg_CounterClockwiseUtil_7_6_6,yneg_InjectUtil_7_6_6;
	wire[7:0] zpos_ClockwiseUtil_7_6_6,zpos_CounterClockwiseUtil_7_6_6,zpos_InjectUtil_7_6_6;
	wire[7:0] zneg_ClockwiseUtil_7_6_6,zneg_CounterClockwiseUtil_7_6_6,zneg_InjectUtil_7_6_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_6_7, eject_xpos_ser_7_6_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_6_7, eject_xneg_ser_7_6_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_6_7, eject_ypos_ser_7_6_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_6_7, eject_yneg_ser_7_6_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_6_7, eject_zpos_ser_7_6_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_6_7, eject_zneg_ser_7_6_7;
	wire[7:0] xpos_ClockwiseUtil_7_6_7,xpos_CounterClockwiseUtil_7_6_7,xpos_InjectUtil_7_6_7;
	wire[7:0] xneg_ClockwiseUtil_7_6_7,xneg_CounterClockwiseUtil_7_6_7,xneg_InjectUtil_7_6_7;
	wire[7:0] ypos_ClockwiseUtil_7_6_7,ypos_CounterClockwiseUtil_7_6_7,ypos_InjectUtil_7_6_7;
	wire[7:0] yneg_ClockwiseUtil_7_6_7,yneg_CounterClockwiseUtil_7_6_7,yneg_InjectUtil_7_6_7;
	wire[7:0] zpos_ClockwiseUtil_7_6_7,zpos_CounterClockwiseUtil_7_6_7,zpos_InjectUtil_7_6_7;
	wire[7:0] zneg_ClockwiseUtil_7_6_7,zneg_CounterClockwiseUtil_7_6_7,zneg_InjectUtil_7_6_7;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_0, eject_xpos_ser_7_7_0;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_0, eject_xneg_ser_7_7_0;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_0, eject_ypos_ser_7_7_0;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_0, eject_yneg_ser_7_7_0;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_0, eject_zpos_ser_7_7_0;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_0, eject_zneg_ser_7_7_0;
	wire[7:0] xpos_ClockwiseUtil_7_7_0,xpos_CounterClockwiseUtil_7_7_0,xpos_InjectUtil_7_7_0;
	wire[7:0] xneg_ClockwiseUtil_7_7_0,xneg_CounterClockwiseUtil_7_7_0,xneg_InjectUtil_7_7_0;
	wire[7:0] ypos_ClockwiseUtil_7_7_0,ypos_CounterClockwiseUtil_7_7_0,ypos_InjectUtil_7_7_0;
	wire[7:0] yneg_ClockwiseUtil_7_7_0,yneg_CounterClockwiseUtil_7_7_0,yneg_InjectUtil_7_7_0;
	wire[7:0] zpos_ClockwiseUtil_7_7_0,zpos_CounterClockwiseUtil_7_7_0,zpos_InjectUtil_7_7_0;
	wire[7:0] zneg_ClockwiseUtil_7_7_0,zneg_CounterClockwiseUtil_7_7_0,zneg_InjectUtil_7_7_0;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_1, eject_xpos_ser_7_7_1;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_1, eject_xneg_ser_7_7_1;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_1, eject_ypos_ser_7_7_1;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_1, eject_yneg_ser_7_7_1;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_1, eject_zpos_ser_7_7_1;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_1, eject_zneg_ser_7_7_1;
	wire[7:0] xpos_ClockwiseUtil_7_7_1,xpos_CounterClockwiseUtil_7_7_1,xpos_InjectUtil_7_7_1;
	wire[7:0] xneg_ClockwiseUtil_7_7_1,xneg_CounterClockwiseUtil_7_7_1,xneg_InjectUtil_7_7_1;
	wire[7:0] ypos_ClockwiseUtil_7_7_1,ypos_CounterClockwiseUtil_7_7_1,ypos_InjectUtil_7_7_1;
	wire[7:0] yneg_ClockwiseUtil_7_7_1,yneg_CounterClockwiseUtil_7_7_1,yneg_InjectUtil_7_7_1;
	wire[7:0] zpos_ClockwiseUtil_7_7_1,zpos_CounterClockwiseUtil_7_7_1,zpos_InjectUtil_7_7_1;
	wire[7:0] zneg_ClockwiseUtil_7_7_1,zneg_CounterClockwiseUtil_7_7_1,zneg_InjectUtil_7_7_1;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_2, eject_xpos_ser_7_7_2;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_2, eject_xneg_ser_7_7_2;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_2, eject_ypos_ser_7_7_2;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_2, eject_yneg_ser_7_7_2;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_2, eject_zpos_ser_7_7_2;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_2, eject_zneg_ser_7_7_2;
	wire[7:0] xpos_ClockwiseUtil_7_7_2,xpos_CounterClockwiseUtil_7_7_2,xpos_InjectUtil_7_7_2;
	wire[7:0] xneg_ClockwiseUtil_7_7_2,xneg_CounterClockwiseUtil_7_7_2,xneg_InjectUtil_7_7_2;
	wire[7:0] ypos_ClockwiseUtil_7_7_2,ypos_CounterClockwiseUtil_7_7_2,ypos_InjectUtil_7_7_2;
	wire[7:0] yneg_ClockwiseUtil_7_7_2,yneg_CounterClockwiseUtil_7_7_2,yneg_InjectUtil_7_7_2;
	wire[7:0] zpos_ClockwiseUtil_7_7_2,zpos_CounterClockwiseUtil_7_7_2,zpos_InjectUtil_7_7_2;
	wire[7:0] zneg_ClockwiseUtil_7_7_2,zneg_CounterClockwiseUtil_7_7_2,zneg_InjectUtil_7_7_2;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_3, eject_xpos_ser_7_7_3;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_3, eject_xneg_ser_7_7_3;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_3, eject_ypos_ser_7_7_3;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_3, eject_yneg_ser_7_7_3;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_3, eject_zpos_ser_7_7_3;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_3, eject_zneg_ser_7_7_3;
	wire[7:0] xpos_ClockwiseUtil_7_7_3,xpos_CounterClockwiseUtil_7_7_3,xpos_InjectUtil_7_7_3;
	wire[7:0] xneg_ClockwiseUtil_7_7_3,xneg_CounterClockwiseUtil_7_7_3,xneg_InjectUtil_7_7_3;
	wire[7:0] ypos_ClockwiseUtil_7_7_3,ypos_CounterClockwiseUtil_7_7_3,ypos_InjectUtil_7_7_3;
	wire[7:0] yneg_ClockwiseUtil_7_7_3,yneg_CounterClockwiseUtil_7_7_3,yneg_InjectUtil_7_7_3;
	wire[7:0] zpos_ClockwiseUtil_7_7_3,zpos_CounterClockwiseUtil_7_7_3,zpos_InjectUtil_7_7_3;
	wire[7:0] zneg_ClockwiseUtil_7_7_3,zneg_CounterClockwiseUtil_7_7_3,zneg_InjectUtil_7_7_3;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_4, eject_xpos_ser_7_7_4;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_4, eject_xneg_ser_7_7_4;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_4, eject_ypos_ser_7_7_4;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_4, eject_yneg_ser_7_7_4;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_4, eject_zpos_ser_7_7_4;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_4, eject_zneg_ser_7_7_4;
	wire[7:0] xpos_ClockwiseUtil_7_7_4,xpos_CounterClockwiseUtil_7_7_4,xpos_InjectUtil_7_7_4;
	wire[7:0] xneg_ClockwiseUtil_7_7_4,xneg_CounterClockwiseUtil_7_7_4,xneg_InjectUtil_7_7_4;
	wire[7:0] ypos_ClockwiseUtil_7_7_4,ypos_CounterClockwiseUtil_7_7_4,ypos_InjectUtil_7_7_4;
	wire[7:0] yneg_ClockwiseUtil_7_7_4,yneg_CounterClockwiseUtil_7_7_4,yneg_InjectUtil_7_7_4;
	wire[7:0] zpos_ClockwiseUtil_7_7_4,zpos_CounterClockwiseUtil_7_7_4,zpos_InjectUtil_7_7_4;
	wire[7:0] zneg_ClockwiseUtil_7_7_4,zneg_CounterClockwiseUtil_7_7_4,zneg_InjectUtil_7_7_4;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_5, eject_xpos_ser_7_7_5;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_5, eject_xneg_ser_7_7_5;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_5, eject_ypos_ser_7_7_5;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_5, eject_yneg_ser_7_7_5;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_5, eject_zpos_ser_7_7_5;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_5, eject_zneg_ser_7_7_5;
	wire[7:0] xpos_ClockwiseUtil_7_7_5,xpos_CounterClockwiseUtil_7_7_5,xpos_InjectUtil_7_7_5;
	wire[7:0] xneg_ClockwiseUtil_7_7_5,xneg_CounterClockwiseUtil_7_7_5,xneg_InjectUtil_7_7_5;
	wire[7:0] ypos_ClockwiseUtil_7_7_5,ypos_CounterClockwiseUtil_7_7_5,ypos_InjectUtil_7_7_5;
	wire[7:0] yneg_ClockwiseUtil_7_7_5,yneg_CounterClockwiseUtil_7_7_5,yneg_InjectUtil_7_7_5;
	wire[7:0] zpos_ClockwiseUtil_7_7_5,zpos_CounterClockwiseUtil_7_7_5,zpos_InjectUtil_7_7_5;
	wire[7:0] zneg_ClockwiseUtil_7_7_5,zneg_CounterClockwiseUtil_7_7_5,zneg_InjectUtil_7_7_5;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_6, eject_xpos_ser_7_7_6;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_6, eject_xneg_ser_7_7_6;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_6, eject_ypos_ser_7_7_6;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_6, eject_yneg_ser_7_7_6;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_6, eject_zpos_ser_7_7_6;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_6, eject_zneg_ser_7_7_6;
	wire[7:0] xpos_ClockwiseUtil_7_7_6,xpos_CounterClockwiseUtil_7_7_6,xpos_InjectUtil_7_7_6;
	wire[7:0] xneg_ClockwiseUtil_7_7_6,xneg_CounterClockwiseUtil_7_7_6,xneg_InjectUtil_7_7_6;
	wire[7:0] ypos_ClockwiseUtil_7_7_6,ypos_CounterClockwiseUtil_7_7_6,ypos_InjectUtil_7_7_6;
	wire[7:0] yneg_ClockwiseUtil_7_7_6,yneg_CounterClockwiseUtil_7_7_6,yneg_InjectUtil_7_7_6;
	wire[7:0] zpos_ClockwiseUtil_7_7_6,zpos_CounterClockwiseUtil_7_7_6,zpos_InjectUtil_7_7_6;
	wire[7:0] zneg_ClockwiseUtil_7_7_6,zneg_CounterClockwiseUtil_7_7_6,zneg_InjectUtil_7_7_6;

	wire[DataWidth-1:0] inject_xpos_ser_7_7_7, eject_xpos_ser_7_7_7;
	wire[DataWidth-1:0] inject_xneg_ser_7_7_7, eject_xneg_ser_7_7_7;
	wire[DataWidth-1:0] inject_ypos_ser_7_7_7, eject_ypos_ser_7_7_7;
	wire[DataWidth-1:0] inject_yneg_ser_7_7_7, eject_yneg_ser_7_7_7;
	wire[DataWidth-1:0] inject_zpos_ser_7_7_7, eject_zpos_ser_7_7_7;
	wire[DataWidth-1:0] inject_zneg_ser_7_7_7, eject_zneg_ser_7_7_7;
	wire[7:0] xpos_ClockwiseUtil_7_7_7,xpos_CounterClockwiseUtil_7_7_7,xpos_InjectUtil_7_7_7;
	wire[7:0] xneg_ClockwiseUtil_7_7_7,xneg_CounterClockwiseUtil_7_7_7,xneg_InjectUtil_7_7_7;
	wire[7:0] ypos_ClockwiseUtil_7_7_7,ypos_CounterClockwiseUtil_7_7_7,ypos_InjectUtil_7_7_7;
	wire[7:0] yneg_ClockwiseUtil_7_7_7,yneg_CounterClockwiseUtil_7_7_7,yneg_InjectUtil_7_7_7;
	wire[7:0] zpos_ClockwiseUtil_7_7_7,zpos_CounterClockwiseUtil_7_7_7,zpos_InjectUtil_7_7_7;
	wire[7:0] zneg_ClockwiseUtil_7_7_7,zneg_CounterClockwiseUtil_7_7_7,zneg_InjectUtil_7_7_7;

	assign inject_xpos_ser_0_0_0=eject_xneg_ser_1_0_0;
	assign inject_xneg_ser_0_0_0=eject_xpos_ser_7_0_0;
	assign inject_xpos_ser_0_0_1=eject_xneg_ser_1_0_1;
	assign inject_xneg_ser_0_0_1=eject_xpos_ser_7_0_1;
	assign inject_xpos_ser_0_0_2=eject_xneg_ser_1_0_2;
	assign inject_xneg_ser_0_0_2=eject_xpos_ser_7_0_2;
	assign inject_xpos_ser_0_0_3=eject_xneg_ser_1_0_3;
	assign inject_xneg_ser_0_0_3=eject_xpos_ser_7_0_3;
	assign inject_xpos_ser_0_0_4=eject_xneg_ser_1_0_4;
	assign inject_xneg_ser_0_0_4=eject_xpos_ser_7_0_4;
	assign inject_xpos_ser_0_0_5=eject_xneg_ser_1_0_5;
	assign inject_xneg_ser_0_0_5=eject_xpos_ser_7_0_5;
	assign inject_xpos_ser_0_0_6=eject_xneg_ser_1_0_6;
	assign inject_xneg_ser_0_0_6=eject_xpos_ser_7_0_6;
	assign inject_xpos_ser_0_0_7=eject_xneg_ser_1_0_7;
	assign inject_xneg_ser_0_0_7=eject_xpos_ser_7_0_7;
	assign inject_xpos_ser_0_1_0=eject_xneg_ser_1_1_0;
	assign inject_xneg_ser_0_1_0=eject_xpos_ser_7_1_0;
	assign inject_xpos_ser_0_1_1=eject_xneg_ser_1_1_1;
	assign inject_xneg_ser_0_1_1=eject_xpos_ser_7_1_1;
	assign inject_xpos_ser_0_1_2=eject_xneg_ser_1_1_2;
	assign inject_xneg_ser_0_1_2=eject_xpos_ser_7_1_2;
	assign inject_xpos_ser_0_1_3=eject_xneg_ser_1_1_3;
	assign inject_xneg_ser_0_1_3=eject_xpos_ser_7_1_3;
	assign inject_xpos_ser_0_1_4=eject_xneg_ser_1_1_4;
	assign inject_xneg_ser_0_1_4=eject_xpos_ser_7_1_4;
	assign inject_xpos_ser_0_1_5=eject_xneg_ser_1_1_5;
	assign inject_xneg_ser_0_1_5=eject_xpos_ser_7_1_5;
	assign inject_xpos_ser_0_1_6=eject_xneg_ser_1_1_6;
	assign inject_xneg_ser_0_1_6=eject_xpos_ser_7_1_6;
	assign inject_xpos_ser_0_1_7=eject_xneg_ser_1_1_7;
	assign inject_xneg_ser_0_1_7=eject_xpos_ser_7_1_7;
	assign inject_xpos_ser_0_2_0=eject_xneg_ser_1_2_0;
	assign inject_xneg_ser_0_2_0=eject_xpos_ser_7_2_0;
	assign inject_xpos_ser_0_2_1=eject_xneg_ser_1_2_1;
	assign inject_xneg_ser_0_2_1=eject_xpos_ser_7_2_1;
	assign inject_xpos_ser_0_2_2=eject_xneg_ser_1_2_2;
	assign inject_xneg_ser_0_2_2=eject_xpos_ser_7_2_2;
	assign inject_xpos_ser_0_2_3=eject_xneg_ser_1_2_3;
	assign inject_xneg_ser_0_2_3=eject_xpos_ser_7_2_3;
	assign inject_xpos_ser_0_2_4=eject_xneg_ser_1_2_4;
	assign inject_xneg_ser_0_2_4=eject_xpos_ser_7_2_4;
	assign inject_xpos_ser_0_2_5=eject_xneg_ser_1_2_5;
	assign inject_xneg_ser_0_2_5=eject_xpos_ser_7_2_5;
	assign inject_xpos_ser_0_2_6=eject_xneg_ser_1_2_6;
	assign inject_xneg_ser_0_2_6=eject_xpos_ser_7_2_6;
	assign inject_xpos_ser_0_2_7=eject_xneg_ser_1_2_7;
	assign inject_xneg_ser_0_2_7=eject_xpos_ser_7_2_7;
	assign inject_xpos_ser_0_3_0=eject_xneg_ser_1_3_0;
	assign inject_xneg_ser_0_3_0=eject_xpos_ser_7_3_0;
	assign inject_xpos_ser_0_3_1=eject_xneg_ser_1_3_1;
	assign inject_xneg_ser_0_3_1=eject_xpos_ser_7_3_1;
	assign inject_xpos_ser_0_3_2=eject_xneg_ser_1_3_2;
	assign inject_xneg_ser_0_3_2=eject_xpos_ser_7_3_2;
	assign inject_xpos_ser_0_3_3=eject_xneg_ser_1_3_3;
	assign inject_xneg_ser_0_3_3=eject_xpos_ser_7_3_3;
	assign inject_xpos_ser_0_3_4=eject_xneg_ser_1_3_4;
	assign inject_xneg_ser_0_3_4=eject_xpos_ser_7_3_4;
	assign inject_xpos_ser_0_3_5=eject_xneg_ser_1_3_5;
	assign inject_xneg_ser_0_3_5=eject_xpos_ser_7_3_5;
	assign inject_xpos_ser_0_3_6=eject_xneg_ser_1_3_6;
	assign inject_xneg_ser_0_3_6=eject_xpos_ser_7_3_6;
	assign inject_xpos_ser_0_3_7=eject_xneg_ser_1_3_7;
	assign inject_xneg_ser_0_3_7=eject_xpos_ser_7_3_7;
	assign inject_xpos_ser_0_4_0=eject_xneg_ser_1_4_0;
	assign inject_xneg_ser_0_4_0=eject_xpos_ser_7_4_0;
	assign inject_xpos_ser_0_4_1=eject_xneg_ser_1_4_1;
	assign inject_xneg_ser_0_4_1=eject_xpos_ser_7_4_1;
	assign inject_xpos_ser_0_4_2=eject_xneg_ser_1_4_2;
	assign inject_xneg_ser_0_4_2=eject_xpos_ser_7_4_2;
	assign inject_xpos_ser_0_4_3=eject_xneg_ser_1_4_3;
	assign inject_xneg_ser_0_4_3=eject_xpos_ser_7_4_3;
	assign inject_xpos_ser_0_4_4=eject_xneg_ser_1_4_4;
	assign inject_xneg_ser_0_4_4=eject_xpos_ser_7_4_4;
	assign inject_xpos_ser_0_4_5=eject_xneg_ser_1_4_5;
	assign inject_xneg_ser_0_4_5=eject_xpos_ser_7_4_5;
	assign inject_xpos_ser_0_4_6=eject_xneg_ser_1_4_6;
	assign inject_xneg_ser_0_4_6=eject_xpos_ser_7_4_6;
	assign inject_xpos_ser_0_4_7=eject_xneg_ser_1_4_7;
	assign inject_xneg_ser_0_4_7=eject_xpos_ser_7_4_7;
	assign inject_xpos_ser_0_5_0=eject_xneg_ser_1_5_0;
	assign inject_xneg_ser_0_5_0=eject_xpos_ser_7_5_0;
	assign inject_xpos_ser_0_5_1=eject_xneg_ser_1_5_1;
	assign inject_xneg_ser_0_5_1=eject_xpos_ser_7_5_1;
	assign inject_xpos_ser_0_5_2=eject_xneg_ser_1_5_2;
	assign inject_xneg_ser_0_5_2=eject_xpos_ser_7_5_2;
	assign inject_xpos_ser_0_5_3=eject_xneg_ser_1_5_3;
	assign inject_xneg_ser_0_5_3=eject_xpos_ser_7_5_3;
	assign inject_xpos_ser_0_5_4=eject_xneg_ser_1_5_4;
	assign inject_xneg_ser_0_5_4=eject_xpos_ser_7_5_4;
	assign inject_xpos_ser_0_5_5=eject_xneg_ser_1_5_5;
	assign inject_xneg_ser_0_5_5=eject_xpos_ser_7_5_5;
	assign inject_xpos_ser_0_5_6=eject_xneg_ser_1_5_6;
	assign inject_xneg_ser_0_5_6=eject_xpos_ser_7_5_6;
	assign inject_xpos_ser_0_5_7=eject_xneg_ser_1_5_7;
	assign inject_xneg_ser_0_5_7=eject_xpos_ser_7_5_7;
	assign inject_xpos_ser_0_6_0=eject_xneg_ser_1_6_0;
	assign inject_xneg_ser_0_6_0=eject_xpos_ser_7_6_0;
	assign inject_xpos_ser_0_6_1=eject_xneg_ser_1_6_1;
	assign inject_xneg_ser_0_6_1=eject_xpos_ser_7_6_1;
	assign inject_xpos_ser_0_6_2=eject_xneg_ser_1_6_2;
	assign inject_xneg_ser_0_6_2=eject_xpos_ser_7_6_2;
	assign inject_xpos_ser_0_6_3=eject_xneg_ser_1_6_3;
	assign inject_xneg_ser_0_6_3=eject_xpos_ser_7_6_3;
	assign inject_xpos_ser_0_6_4=eject_xneg_ser_1_6_4;
	assign inject_xneg_ser_0_6_4=eject_xpos_ser_7_6_4;
	assign inject_xpos_ser_0_6_5=eject_xneg_ser_1_6_5;
	assign inject_xneg_ser_0_6_5=eject_xpos_ser_7_6_5;
	assign inject_xpos_ser_0_6_6=eject_xneg_ser_1_6_6;
	assign inject_xneg_ser_0_6_6=eject_xpos_ser_7_6_6;
	assign inject_xpos_ser_0_6_7=eject_xneg_ser_1_6_7;
	assign inject_xneg_ser_0_6_7=eject_xpos_ser_7_6_7;
	assign inject_xpos_ser_0_7_0=eject_xneg_ser_1_7_0;
	assign inject_xneg_ser_0_7_0=eject_xpos_ser_7_7_0;
	assign inject_xpos_ser_0_7_1=eject_xneg_ser_1_7_1;
	assign inject_xneg_ser_0_7_1=eject_xpos_ser_7_7_1;
	assign inject_xpos_ser_0_7_2=eject_xneg_ser_1_7_2;
	assign inject_xneg_ser_0_7_2=eject_xpos_ser_7_7_2;
	assign inject_xpos_ser_0_7_3=eject_xneg_ser_1_7_3;
	assign inject_xneg_ser_0_7_3=eject_xpos_ser_7_7_3;
	assign inject_xpos_ser_0_7_4=eject_xneg_ser_1_7_4;
	assign inject_xneg_ser_0_7_4=eject_xpos_ser_7_7_4;
	assign inject_xpos_ser_0_7_5=eject_xneg_ser_1_7_5;
	assign inject_xneg_ser_0_7_5=eject_xpos_ser_7_7_5;
	assign inject_xpos_ser_0_7_6=eject_xneg_ser_1_7_6;
	assign inject_xneg_ser_0_7_6=eject_xpos_ser_7_7_6;
	assign inject_xpos_ser_0_7_7=eject_xneg_ser_1_7_7;
	assign inject_xneg_ser_0_7_7=eject_xpos_ser_7_7_7;
	assign inject_xpos_ser_1_0_0=eject_xneg_ser_2_0_0;
	assign inject_xneg_ser_1_0_0=eject_xpos_ser_0_0_0;
	assign inject_xpos_ser_1_0_1=eject_xneg_ser_2_0_1;
	assign inject_xneg_ser_1_0_1=eject_xpos_ser_0_0_1;
	assign inject_xpos_ser_1_0_2=eject_xneg_ser_2_0_2;
	assign inject_xneg_ser_1_0_2=eject_xpos_ser_0_0_2;
	assign inject_xpos_ser_1_0_3=eject_xneg_ser_2_0_3;
	assign inject_xneg_ser_1_0_3=eject_xpos_ser_0_0_3;
	assign inject_xpos_ser_1_0_4=eject_xneg_ser_2_0_4;
	assign inject_xneg_ser_1_0_4=eject_xpos_ser_0_0_4;
	assign inject_xpos_ser_1_0_5=eject_xneg_ser_2_0_5;
	assign inject_xneg_ser_1_0_5=eject_xpos_ser_0_0_5;
	assign inject_xpos_ser_1_0_6=eject_xneg_ser_2_0_6;
	assign inject_xneg_ser_1_0_6=eject_xpos_ser_0_0_6;
	assign inject_xpos_ser_1_0_7=eject_xneg_ser_2_0_7;
	assign inject_xneg_ser_1_0_7=eject_xpos_ser_0_0_7;
	assign inject_xpos_ser_1_1_0=eject_xneg_ser_2_1_0;
	assign inject_xneg_ser_1_1_0=eject_xpos_ser_0_1_0;
	assign inject_xpos_ser_1_1_1=eject_xneg_ser_2_1_1;
	assign inject_xneg_ser_1_1_1=eject_xpos_ser_0_1_1;
	assign inject_xpos_ser_1_1_2=eject_xneg_ser_2_1_2;
	assign inject_xneg_ser_1_1_2=eject_xpos_ser_0_1_2;
	assign inject_xpos_ser_1_1_3=eject_xneg_ser_2_1_3;
	assign inject_xneg_ser_1_1_3=eject_xpos_ser_0_1_3;
	assign inject_xpos_ser_1_1_4=eject_xneg_ser_2_1_4;
	assign inject_xneg_ser_1_1_4=eject_xpos_ser_0_1_4;
	assign inject_xpos_ser_1_1_5=eject_xneg_ser_2_1_5;
	assign inject_xneg_ser_1_1_5=eject_xpos_ser_0_1_5;
	assign inject_xpos_ser_1_1_6=eject_xneg_ser_2_1_6;
	assign inject_xneg_ser_1_1_6=eject_xpos_ser_0_1_6;
	assign inject_xpos_ser_1_1_7=eject_xneg_ser_2_1_7;
	assign inject_xneg_ser_1_1_7=eject_xpos_ser_0_1_7;
	assign inject_xpos_ser_1_2_0=eject_xneg_ser_2_2_0;
	assign inject_xneg_ser_1_2_0=eject_xpos_ser_0_2_0;
	assign inject_xpos_ser_1_2_1=eject_xneg_ser_2_2_1;
	assign inject_xneg_ser_1_2_1=eject_xpos_ser_0_2_1;
	assign inject_xpos_ser_1_2_2=eject_xneg_ser_2_2_2;
	assign inject_xneg_ser_1_2_2=eject_xpos_ser_0_2_2;
	assign inject_xpos_ser_1_2_3=eject_xneg_ser_2_2_3;
	assign inject_xneg_ser_1_2_3=eject_xpos_ser_0_2_3;
	assign inject_xpos_ser_1_2_4=eject_xneg_ser_2_2_4;
	assign inject_xneg_ser_1_2_4=eject_xpos_ser_0_2_4;
	assign inject_xpos_ser_1_2_5=eject_xneg_ser_2_2_5;
	assign inject_xneg_ser_1_2_5=eject_xpos_ser_0_2_5;
	assign inject_xpos_ser_1_2_6=eject_xneg_ser_2_2_6;
	assign inject_xneg_ser_1_2_6=eject_xpos_ser_0_2_6;
	assign inject_xpos_ser_1_2_7=eject_xneg_ser_2_2_7;
	assign inject_xneg_ser_1_2_7=eject_xpos_ser_0_2_7;
	assign inject_xpos_ser_1_3_0=eject_xneg_ser_2_3_0;
	assign inject_xneg_ser_1_3_0=eject_xpos_ser_0_3_0;
	assign inject_xpos_ser_1_3_1=eject_xneg_ser_2_3_1;
	assign inject_xneg_ser_1_3_1=eject_xpos_ser_0_3_1;
	assign inject_xpos_ser_1_3_2=eject_xneg_ser_2_3_2;
	assign inject_xneg_ser_1_3_2=eject_xpos_ser_0_3_2;
	assign inject_xpos_ser_1_3_3=eject_xneg_ser_2_3_3;
	assign inject_xneg_ser_1_3_3=eject_xpos_ser_0_3_3;
	assign inject_xpos_ser_1_3_4=eject_xneg_ser_2_3_4;
	assign inject_xneg_ser_1_3_4=eject_xpos_ser_0_3_4;
	assign inject_xpos_ser_1_3_5=eject_xneg_ser_2_3_5;
	assign inject_xneg_ser_1_3_5=eject_xpos_ser_0_3_5;
	assign inject_xpos_ser_1_3_6=eject_xneg_ser_2_3_6;
	assign inject_xneg_ser_1_3_6=eject_xpos_ser_0_3_6;
	assign inject_xpos_ser_1_3_7=eject_xneg_ser_2_3_7;
	assign inject_xneg_ser_1_3_7=eject_xpos_ser_0_3_7;
	assign inject_xpos_ser_1_4_0=eject_xneg_ser_2_4_0;
	assign inject_xneg_ser_1_4_0=eject_xpos_ser_0_4_0;
	assign inject_xpos_ser_1_4_1=eject_xneg_ser_2_4_1;
	assign inject_xneg_ser_1_4_1=eject_xpos_ser_0_4_1;
	assign inject_xpos_ser_1_4_2=eject_xneg_ser_2_4_2;
	assign inject_xneg_ser_1_4_2=eject_xpos_ser_0_4_2;
	assign inject_xpos_ser_1_4_3=eject_xneg_ser_2_4_3;
	assign inject_xneg_ser_1_4_3=eject_xpos_ser_0_4_3;
	assign inject_xpos_ser_1_4_4=eject_xneg_ser_2_4_4;
	assign inject_xneg_ser_1_4_4=eject_xpos_ser_0_4_4;
	assign inject_xpos_ser_1_4_5=eject_xneg_ser_2_4_5;
	assign inject_xneg_ser_1_4_5=eject_xpos_ser_0_4_5;
	assign inject_xpos_ser_1_4_6=eject_xneg_ser_2_4_6;
	assign inject_xneg_ser_1_4_6=eject_xpos_ser_0_4_6;
	assign inject_xpos_ser_1_4_7=eject_xneg_ser_2_4_7;
	assign inject_xneg_ser_1_4_7=eject_xpos_ser_0_4_7;
	assign inject_xpos_ser_1_5_0=eject_xneg_ser_2_5_0;
	assign inject_xneg_ser_1_5_0=eject_xpos_ser_0_5_0;
	assign inject_xpos_ser_1_5_1=eject_xneg_ser_2_5_1;
	assign inject_xneg_ser_1_5_1=eject_xpos_ser_0_5_1;
	assign inject_xpos_ser_1_5_2=eject_xneg_ser_2_5_2;
	assign inject_xneg_ser_1_5_2=eject_xpos_ser_0_5_2;
	assign inject_xpos_ser_1_5_3=eject_xneg_ser_2_5_3;
	assign inject_xneg_ser_1_5_3=eject_xpos_ser_0_5_3;
	assign inject_xpos_ser_1_5_4=eject_xneg_ser_2_5_4;
	assign inject_xneg_ser_1_5_4=eject_xpos_ser_0_5_4;
	assign inject_xpos_ser_1_5_5=eject_xneg_ser_2_5_5;
	assign inject_xneg_ser_1_5_5=eject_xpos_ser_0_5_5;
	assign inject_xpos_ser_1_5_6=eject_xneg_ser_2_5_6;
	assign inject_xneg_ser_1_5_6=eject_xpos_ser_0_5_6;
	assign inject_xpos_ser_1_5_7=eject_xneg_ser_2_5_7;
	assign inject_xneg_ser_1_5_7=eject_xpos_ser_0_5_7;
	assign inject_xpos_ser_1_6_0=eject_xneg_ser_2_6_0;
	assign inject_xneg_ser_1_6_0=eject_xpos_ser_0_6_0;
	assign inject_xpos_ser_1_6_1=eject_xneg_ser_2_6_1;
	assign inject_xneg_ser_1_6_1=eject_xpos_ser_0_6_1;
	assign inject_xpos_ser_1_6_2=eject_xneg_ser_2_6_2;
	assign inject_xneg_ser_1_6_2=eject_xpos_ser_0_6_2;
	assign inject_xpos_ser_1_6_3=eject_xneg_ser_2_6_3;
	assign inject_xneg_ser_1_6_3=eject_xpos_ser_0_6_3;
	assign inject_xpos_ser_1_6_4=eject_xneg_ser_2_6_4;
	assign inject_xneg_ser_1_6_4=eject_xpos_ser_0_6_4;
	assign inject_xpos_ser_1_6_5=eject_xneg_ser_2_6_5;
	assign inject_xneg_ser_1_6_5=eject_xpos_ser_0_6_5;
	assign inject_xpos_ser_1_6_6=eject_xneg_ser_2_6_6;
	assign inject_xneg_ser_1_6_6=eject_xpos_ser_0_6_6;
	assign inject_xpos_ser_1_6_7=eject_xneg_ser_2_6_7;
	assign inject_xneg_ser_1_6_7=eject_xpos_ser_0_6_7;
	assign inject_xpos_ser_1_7_0=eject_xneg_ser_2_7_0;
	assign inject_xneg_ser_1_7_0=eject_xpos_ser_0_7_0;
	assign inject_xpos_ser_1_7_1=eject_xneg_ser_2_7_1;
	assign inject_xneg_ser_1_7_1=eject_xpos_ser_0_7_1;
	assign inject_xpos_ser_1_7_2=eject_xneg_ser_2_7_2;
	assign inject_xneg_ser_1_7_2=eject_xpos_ser_0_7_2;
	assign inject_xpos_ser_1_7_3=eject_xneg_ser_2_7_3;
	assign inject_xneg_ser_1_7_3=eject_xpos_ser_0_7_3;
	assign inject_xpos_ser_1_7_4=eject_xneg_ser_2_7_4;
	assign inject_xneg_ser_1_7_4=eject_xpos_ser_0_7_4;
	assign inject_xpos_ser_1_7_5=eject_xneg_ser_2_7_5;
	assign inject_xneg_ser_1_7_5=eject_xpos_ser_0_7_5;
	assign inject_xpos_ser_1_7_6=eject_xneg_ser_2_7_6;
	assign inject_xneg_ser_1_7_6=eject_xpos_ser_0_7_6;
	assign inject_xpos_ser_1_7_7=eject_xneg_ser_2_7_7;
	assign inject_xneg_ser_1_7_7=eject_xpos_ser_0_7_7;
	assign inject_xpos_ser_2_0_0=eject_xneg_ser_3_0_0;
	assign inject_xneg_ser_2_0_0=eject_xpos_ser_1_0_0;
	assign inject_xpos_ser_2_0_1=eject_xneg_ser_3_0_1;
	assign inject_xneg_ser_2_0_1=eject_xpos_ser_1_0_1;
	assign inject_xpos_ser_2_0_2=eject_xneg_ser_3_0_2;
	assign inject_xneg_ser_2_0_2=eject_xpos_ser_1_0_2;
	assign inject_xpos_ser_2_0_3=eject_xneg_ser_3_0_3;
	assign inject_xneg_ser_2_0_3=eject_xpos_ser_1_0_3;
	assign inject_xpos_ser_2_0_4=eject_xneg_ser_3_0_4;
	assign inject_xneg_ser_2_0_4=eject_xpos_ser_1_0_4;
	assign inject_xpos_ser_2_0_5=eject_xneg_ser_3_0_5;
	assign inject_xneg_ser_2_0_5=eject_xpos_ser_1_0_5;
	assign inject_xpos_ser_2_0_6=eject_xneg_ser_3_0_6;
	assign inject_xneg_ser_2_0_6=eject_xpos_ser_1_0_6;
	assign inject_xpos_ser_2_0_7=eject_xneg_ser_3_0_7;
	assign inject_xneg_ser_2_0_7=eject_xpos_ser_1_0_7;
	assign inject_xpos_ser_2_1_0=eject_xneg_ser_3_1_0;
	assign inject_xneg_ser_2_1_0=eject_xpos_ser_1_1_0;
	assign inject_xpos_ser_2_1_1=eject_xneg_ser_3_1_1;
	assign inject_xneg_ser_2_1_1=eject_xpos_ser_1_1_1;
	assign inject_xpos_ser_2_1_2=eject_xneg_ser_3_1_2;
	assign inject_xneg_ser_2_1_2=eject_xpos_ser_1_1_2;
	assign inject_xpos_ser_2_1_3=eject_xneg_ser_3_1_3;
	assign inject_xneg_ser_2_1_3=eject_xpos_ser_1_1_3;
	assign inject_xpos_ser_2_1_4=eject_xneg_ser_3_1_4;
	assign inject_xneg_ser_2_1_4=eject_xpos_ser_1_1_4;
	assign inject_xpos_ser_2_1_5=eject_xneg_ser_3_1_5;
	assign inject_xneg_ser_2_1_5=eject_xpos_ser_1_1_5;
	assign inject_xpos_ser_2_1_6=eject_xneg_ser_3_1_6;
	assign inject_xneg_ser_2_1_6=eject_xpos_ser_1_1_6;
	assign inject_xpos_ser_2_1_7=eject_xneg_ser_3_1_7;
	assign inject_xneg_ser_2_1_7=eject_xpos_ser_1_1_7;
	assign inject_xpos_ser_2_2_0=eject_xneg_ser_3_2_0;
	assign inject_xneg_ser_2_2_0=eject_xpos_ser_1_2_0;
	assign inject_xpos_ser_2_2_1=eject_xneg_ser_3_2_1;
	assign inject_xneg_ser_2_2_1=eject_xpos_ser_1_2_1;
	assign inject_xpos_ser_2_2_2=eject_xneg_ser_3_2_2;
	assign inject_xneg_ser_2_2_2=eject_xpos_ser_1_2_2;
	assign inject_xpos_ser_2_2_3=eject_xneg_ser_3_2_3;
	assign inject_xneg_ser_2_2_3=eject_xpos_ser_1_2_3;
	assign inject_xpos_ser_2_2_4=eject_xneg_ser_3_2_4;
	assign inject_xneg_ser_2_2_4=eject_xpos_ser_1_2_4;
	assign inject_xpos_ser_2_2_5=eject_xneg_ser_3_2_5;
	assign inject_xneg_ser_2_2_5=eject_xpos_ser_1_2_5;
	assign inject_xpos_ser_2_2_6=eject_xneg_ser_3_2_6;
	assign inject_xneg_ser_2_2_6=eject_xpos_ser_1_2_6;
	assign inject_xpos_ser_2_2_7=eject_xneg_ser_3_2_7;
	assign inject_xneg_ser_2_2_7=eject_xpos_ser_1_2_7;
	assign inject_xpos_ser_2_3_0=eject_xneg_ser_3_3_0;
	assign inject_xneg_ser_2_3_0=eject_xpos_ser_1_3_0;
	assign inject_xpos_ser_2_3_1=eject_xneg_ser_3_3_1;
	assign inject_xneg_ser_2_3_1=eject_xpos_ser_1_3_1;
	assign inject_xpos_ser_2_3_2=eject_xneg_ser_3_3_2;
	assign inject_xneg_ser_2_3_2=eject_xpos_ser_1_3_2;
	assign inject_xpos_ser_2_3_3=eject_xneg_ser_3_3_3;
	assign inject_xneg_ser_2_3_3=eject_xpos_ser_1_3_3;
	assign inject_xpos_ser_2_3_4=eject_xneg_ser_3_3_4;
	assign inject_xneg_ser_2_3_4=eject_xpos_ser_1_3_4;
	assign inject_xpos_ser_2_3_5=eject_xneg_ser_3_3_5;
	assign inject_xneg_ser_2_3_5=eject_xpos_ser_1_3_5;
	assign inject_xpos_ser_2_3_6=eject_xneg_ser_3_3_6;
	assign inject_xneg_ser_2_3_6=eject_xpos_ser_1_3_6;
	assign inject_xpos_ser_2_3_7=eject_xneg_ser_3_3_7;
	assign inject_xneg_ser_2_3_7=eject_xpos_ser_1_3_7;
	assign inject_xpos_ser_2_4_0=eject_xneg_ser_3_4_0;
	assign inject_xneg_ser_2_4_0=eject_xpos_ser_1_4_0;
	assign inject_xpos_ser_2_4_1=eject_xneg_ser_3_4_1;
	assign inject_xneg_ser_2_4_1=eject_xpos_ser_1_4_1;
	assign inject_xpos_ser_2_4_2=eject_xneg_ser_3_4_2;
	assign inject_xneg_ser_2_4_2=eject_xpos_ser_1_4_2;
	assign inject_xpos_ser_2_4_3=eject_xneg_ser_3_4_3;
	assign inject_xneg_ser_2_4_3=eject_xpos_ser_1_4_3;
	assign inject_xpos_ser_2_4_4=eject_xneg_ser_3_4_4;
	assign inject_xneg_ser_2_4_4=eject_xpos_ser_1_4_4;
	assign inject_xpos_ser_2_4_5=eject_xneg_ser_3_4_5;
	assign inject_xneg_ser_2_4_5=eject_xpos_ser_1_4_5;
	assign inject_xpos_ser_2_4_6=eject_xneg_ser_3_4_6;
	assign inject_xneg_ser_2_4_6=eject_xpos_ser_1_4_6;
	assign inject_xpos_ser_2_4_7=eject_xneg_ser_3_4_7;
	assign inject_xneg_ser_2_4_7=eject_xpos_ser_1_4_7;
	assign inject_xpos_ser_2_5_0=eject_xneg_ser_3_5_0;
	assign inject_xneg_ser_2_5_0=eject_xpos_ser_1_5_0;
	assign inject_xpos_ser_2_5_1=eject_xneg_ser_3_5_1;
	assign inject_xneg_ser_2_5_1=eject_xpos_ser_1_5_1;
	assign inject_xpos_ser_2_5_2=eject_xneg_ser_3_5_2;
	assign inject_xneg_ser_2_5_2=eject_xpos_ser_1_5_2;
	assign inject_xpos_ser_2_5_3=eject_xneg_ser_3_5_3;
	assign inject_xneg_ser_2_5_3=eject_xpos_ser_1_5_3;
	assign inject_xpos_ser_2_5_4=eject_xneg_ser_3_5_4;
	assign inject_xneg_ser_2_5_4=eject_xpos_ser_1_5_4;
	assign inject_xpos_ser_2_5_5=eject_xneg_ser_3_5_5;
	assign inject_xneg_ser_2_5_5=eject_xpos_ser_1_5_5;
	assign inject_xpos_ser_2_5_6=eject_xneg_ser_3_5_6;
	assign inject_xneg_ser_2_5_6=eject_xpos_ser_1_5_6;
	assign inject_xpos_ser_2_5_7=eject_xneg_ser_3_5_7;
	assign inject_xneg_ser_2_5_7=eject_xpos_ser_1_5_7;
	assign inject_xpos_ser_2_6_0=eject_xneg_ser_3_6_0;
	assign inject_xneg_ser_2_6_0=eject_xpos_ser_1_6_0;
	assign inject_xpos_ser_2_6_1=eject_xneg_ser_3_6_1;
	assign inject_xneg_ser_2_6_1=eject_xpos_ser_1_6_1;
	assign inject_xpos_ser_2_6_2=eject_xneg_ser_3_6_2;
	assign inject_xneg_ser_2_6_2=eject_xpos_ser_1_6_2;
	assign inject_xpos_ser_2_6_3=eject_xneg_ser_3_6_3;
	assign inject_xneg_ser_2_6_3=eject_xpos_ser_1_6_3;
	assign inject_xpos_ser_2_6_4=eject_xneg_ser_3_6_4;
	assign inject_xneg_ser_2_6_4=eject_xpos_ser_1_6_4;
	assign inject_xpos_ser_2_6_5=eject_xneg_ser_3_6_5;
	assign inject_xneg_ser_2_6_5=eject_xpos_ser_1_6_5;
	assign inject_xpos_ser_2_6_6=eject_xneg_ser_3_6_6;
	assign inject_xneg_ser_2_6_6=eject_xpos_ser_1_6_6;
	assign inject_xpos_ser_2_6_7=eject_xneg_ser_3_6_7;
	assign inject_xneg_ser_2_6_7=eject_xpos_ser_1_6_7;
	assign inject_xpos_ser_2_7_0=eject_xneg_ser_3_7_0;
	assign inject_xneg_ser_2_7_0=eject_xpos_ser_1_7_0;
	assign inject_xpos_ser_2_7_1=eject_xneg_ser_3_7_1;
	assign inject_xneg_ser_2_7_1=eject_xpos_ser_1_7_1;
	assign inject_xpos_ser_2_7_2=eject_xneg_ser_3_7_2;
	assign inject_xneg_ser_2_7_2=eject_xpos_ser_1_7_2;
	assign inject_xpos_ser_2_7_3=eject_xneg_ser_3_7_3;
	assign inject_xneg_ser_2_7_3=eject_xpos_ser_1_7_3;
	assign inject_xpos_ser_2_7_4=eject_xneg_ser_3_7_4;
	assign inject_xneg_ser_2_7_4=eject_xpos_ser_1_7_4;
	assign inject_xpos_ser_2_7_5=eject_xneg_ser_3_7_5;
	assign inject_xneg_ser_2_7_5=eject_xpos_ser_1_7_5;
	assign inject_xpos_ser_2_7_6=eject_xneg_ser_3_7_6;
	assign inject_xneg_ser_2_7_6=eject_xpos_ser_1_7_6;
	assign inject_xpos_ser_2_7_7=eject_xneg_ser_3_7_7;
	assign inject_xneg_ser_2_7_7=eject_xpos_ser_1_7_7;
	assign inject_xpos_ser_3_0_0=eject_xneg_ser_4_0_0;
	assign inject_xneg_ser_3_0_0=eject_xpos_ser_2_0_0;
	assign inject_xpos_ser_3_0_1=eject_xneg_ser_4_0_1;
	assign inject_xneg_ser_3_0_1=eject_xpos_ser_2_0_1;
	assign inject_xpos_ser_3_0_2=eject_xneg_ser_4_0_2;
	assign inject_xneg_ser_3_0_2=eject_xpos_ser_2_0_2;
	assign inject_xpos_ser_3_0_3=eject_xneg_ser_4_0_3;
	assign inject_xneg_ser_3_0_3=eject_xpos_ser_2_0_3;
	assign inject_xpos_ser_3_0_4=eject_xneg_ser_4_0_4;
	assign inject_xneg_ser_3_0_4=eject_xpos_ser_2_0_4;
	assign inject_xpos_ser_3_0_5=eject_xneg_ser_4_0_5;
	assign inject_xneg_ser_3_0_5=eject_xpos_ser_2_0_5;
	assign inject_xpos_ser_3_0_6=eject_xneg_ser_4_0_6;
	assign inject_xneg_ser_3_0_6=eject_xpos_ser_2_0_6;
	assign inject_xpos_ser_3_0_7=eject_xneg_ser_4_0_7;
	assign inject_xneg_ser_3_0_7=eject_xpos_ser_2_0_7;
	assign inject_xpos_ser_3_1_0=eject_xneg_ser_4_1_0;
	assign inject_xneg_ser_3_1_0=eject_xpos_ser_2_1_0;
	assign inject_xpos_ser_3_1_1=eject_xneg_ser_4_1_1;
	assign inject_xneg_ser_3_1_1=eject_xpos_ser_2_1_1;
	assign inject_xpos_ser_3_1_2=eject_xneg_ser_4_1_2;
	assign inject_xneg_ser_3_1_2=eject_xpos_ser_2_1_2;
	assign inject_xpos_ser_3_1_3=eject_xneg_ser_4_1_3;
	assign inject_xneg_ser_3_1_3=eject_xpos_ser_2_1_3;
	assign inject_xpos_ser_3_1_4=eject_xneg_ser_4_1_4;
	assign inject_xneg_ser_3_1_4=eject_xpos_ser_2_1_4;
	assign inject_xpos_ser_3_1_5=eject_xneg_ser_4_1_5;
	assign inject_xneg_ser_3_1_5=eject_xpos_ser_2_1_5;
	assign inject_xpos_ser_3_1_6=eject_xneg_ser_4_1_6;
	assign inject_xneg_ser_3_1_6=eject_xpos_ser_2_1_6;
	assign inject_xpos_ser_3_1_7=eject_xneg_ser_4_1_7;
	assign inject_xneg_ser_3_1_7=eject_xpos_ser_2_1_7;
	assign inject_xpos_ser_3_2_0=eject_xneg_ser_4_2_0;
	assign inject_xneg_ser_3_2_0=eject_xpos_ser_2_2_0;
	assign inject_xpos_ser_3_2_1=eject_xneg_ser_4_2_1;
	assign inject_xneg_ser_3_2_1=eject_xpos_ser_2_2_1;
	assign inject_xpos_ser_3_2_2=eject_xneg_ser_4_2_2;
	assign inject_xneg_ser_3_2_2=eject_xpos_ser_2_2_2;
	assign inject_xpos_ser_3_2_3=eject_xneg_ser_4_2_3;
	assign inject_xneg_ser_3_2_3=eject_xpos_ser_2_2_3;
	assign inject_xpos_ser_3_2_4=eject_xneg_ser_4_2_4;
	assign inject_xneg_ser_3_2_4=eject_xpos_ser_2_2_4;
	assign inject_xpos_ser_3_2_5=eject_xneg_ser_4_2_5;
	assign inject_xneg_ser_3_2_5=eject_xpos_ser_2_2_5;
	assign inject_xpos_ser_3_2_6=eject_xneg_ser_4_2_6;
	assign inject_xneg_ser_3_2_6=eject_xpos_ser_2_2_6;
	assign inject_xpos_ser_3_2_7=eject_xneg_ser_4_2_7;
	assign inject_xneg_ser_3_2_7=eject_xpos_ser_2_2_7;
	assign inject_xpos_ser_3_3_0=eject_xneg_ser_4_3_0;
	assign inject_xneg_ser_3_3_0=eject_xpos_ser_2_3_0;
	assign inject_xpos_ser_3_3_1=eject_xneg_ser_4_3_1;
	assign inject_xneg_ser_3_3_1=eject_xpos_ser_2_3_1;
	assign inject_xpos_ser_3_3_2=eject_xneg_ser_4_3_2;
	assign inject_xneg_ser_3_3_2=eject_xpos_ser_2_3_2;
	assign inject_xpos_ser_3_3_3=eject_xneg_ser_4_3_3;
	assign inject_xneg_ser_3_3_3=eject_xpos_ser_2_3_3;
	assign inject_xpos_ser_3_3_4=eject_xneg_ser_4_3_4;
	assign inject_xneg_ser_3_3_4=eject_xpos_ser_2_3_4;
	assign inject_xpos_ser_3_3_5=eject_xneg_ser_4_3_5;
	assign inject_xneg_ser_3_3_5=eject_xpos_ser_2_3_5;
	assign inject_xpos_ser_3_3_6=eject_xneg_ser_4_3_6;
	assign inject_xneg_ser_3_3_6=eject_xpos_ser_2_3_6;
	assign inject_xpos_ser_3_3_7=eject_xneg_ser_4_3_7;
	assign inject_xneg_ser_3_3_7=eject_xpos_ser_2_3_7;
	assign inject_xpos_ser_3_4_0=eject_xneg_ser_4_4_0;
	assign inject_xneg_ser_3_4_0=eject_xpos_ser_2_4_0;
	assign inject_xpos_ser_3_4_1=eject_xneg_ser_4_4_1;
	assign inject_xneg_ser_3_4_1=eject_xpos_ser_2_4_1;
	assign inject_xpos_ser_3_4_2=eject_xneg_ser_4_4_2;
	assign inject_xneg_ser_3_4_2=eject_xpos_ser_2_4_2;
	assign inject_xpos_ser_3_4_3=eject_xneg_ser_4_4_3;
	assign inject_xneg_ser_3_4_3=eject_xpos_ser_2_4_3;
	assign inject_xpos_ser_3_4_4=eject_xneg_ser_4_4_4;
	assign inject_xneg_ser_3_4_4=eject_xpos_ser_2_4_4;
	assign inject_xpos_ser_3_4_5=eject_xneg_ser_4_4_5;
	assign inject_xneg_ser_3_4_5=eject_xpos_ser_2_4_5;
	assign inject_xpos_ser_3_4_6=eject_xneg_ser_4_4_6;
	assign inject_xneg_ser_3_4_6=eject_xpos_ser_2_4_6;
	assign inject_xpos_ser_3_4_7=eject_xneg_ser_4_4_7;
	assign inject_xneg_ser_3_4_7=eject_xpos_ser_2_4_7;
	assign inject_xpos_ser_3_5_0=eject_xneg_ser_4_5_0;
	assign inject_xneg_ser_3_5_0=eject_xpos_ser_2_5_0;
	assign inject_xpos_ser_3_5_1=eject_xneg_ser_4_5_1;
	assign inject_xneg_ser_3_5_1=eject_xpos_ser_2_5_1;
	assign inject_xpos_ser_3_5_2=eject_xneg_ser_4_5_2;
	assign inject_xneg_ser_3_5_2=eject_xpos_ser_2_5_2;
	assign inject_xpos_ser_3_5_3=eject_xneg_ser_4_5_3;
	assign inject_xneg_ser_3_5_3=eject_xpos_ser_2_5_3;
	assign inject_xpos_ser_3_5_4=eject_xneg_ser_4_5_4;
	assign inject_xneg_ser_3_5_4=eject_xpos_ser_2_5_4;
	assign inject_xpos_ser_3_5_5=eject_xneg_ser_4_5_5;
	assign inject_xneg_ser_3_5_5=eject_xpos_ser_2_5_5;
	assign inject_xpos_ser_3_5_6=eject_xneg_ser_4_5_6;
	assign inject_xneg_ser_3_5_6=eject_xpos_ser_2_5_6;
	assign inject_xpos_ser_3_5_7=eject_xneg_ser_4_5_7;
	assign inject_xneg_ser_3_5_7=eject_xpos_ser_2_5_7;
	assign inject_xpos_ser_3_6_0=eject_xneg_ser_4_6_0;
	assign inject_xneg_ser_3_6_0=eject_xpos_ser_2_6_0;
	assign inject_xpos_ser_3_6_1=eject_xneg_ser_4_6_1;
	assign inject_xneg_ser_3_6_1=eject_xpos_ser_2_6_1;
	assign inject_xpos_ser_3_6_2=eject_xneg_ser_4_6_2;
	assign inject_xneg_ser_3_6_2=eject_xpos_ser_2_6_2;
	assign inject_xpos_ser_3_6_3=eject_xneg_ser_4_6_3;
	assign inject_xneg_ser_3_6_3=eject_xpos_ser_2_6_3;
	assign inject_xpos_ser_3_6_4=eject_xneg_ser_4_6_4;
	assign inject_xneg_ser_3_6_4=eject_xpos_ser_2_6_4;
	assign inject_xpos_ser_3_6_5=eject_xneg_ser_4_6_5;
	assign inject_xneg_ser_3_6_5=eject_xpos_ser_2_6_5;
	assign inject_xpos_ser_3_6_6=eject_xneg_ser_4_6_6;
	assign inject_xneg_ser_3_6_6=eject_xpos_ser_2_6_6;
	assign inject_xpos_ser_3_6_7=eject_xneg_ser_4_6_7;
	assign inject_xneg_ser_3_6_7=eject_xpos_ser_2_6_7;
	assign inject_xpos_ser_3_7_0=eject_xneg_ser_4_7_0;
	assign inject_xneg_ser_3_7_0=eject_xpos_ser_2_7_0;
	assign inject_xpos_ser_3_7_1=eject_xneg_ser_4_7_1;
	assign inject_xneg_ser_3_7_1=eject_xpos_ser_2_7_1;
	assign inject_xpos_ser_3_7_2=eject_xneg_ser_4_7_2;
	assign inject_xneg_ser_3_7_2=eject_xpos_ser_2_7_2;
	assign inject_xpos_ser_3_7_3=eject_xneg_ser_4_7_3;
	assign inject_xneg_ser_3_7_3=eject_xpos_ser_2_7_3;
	assign inject_xpos_ser_3_7_4=eject_xneg_ser_4_7_4;
	assign inject_xneg_ser_3_7_4=eject_xpos_ser_2_7_4;
	assign inject_xpos_ser_3_7_5=eject_xneg_ser_4_7_5;
	assign inject_xneg_ser_3_7_5=eject_xpos_ser_2_7_5;
	assign inject_xpos_ser_3_7_6=eject_xneg_ser_4_7_6;
	assign inject_xneg_ser_3_7_6=eject_xpos_ser_2_7_6;
	assign inject_xpos_ser_3_7_7=eject_xneg_ser_4_7_7;
	assign inject_xneg_ser_3_7_7=eject_xpos_ser_2_7_7;
	assign inject_xpos_ser_4_0_0=eject_xneg_ser_5_0_0;
	assign inject_xneg_ser_4_0_0=eject_xpos_ser_3_0_0;
	assign inject_xpos_ser_4_0_1=eject_xneg_ser_5_0_1;
	assign inject_xneg_ser_4_0_1=eject_xpos_ser_3_0_1;
	assign inject_xpos_ser_4_0_2=eject_xneg_ser_5_0_2;
	assign inject_xneg_ser_4_0_2=eject_xpos_ser_3_0_2;
	assign inject_xpos_ser_4_0_3=eject_xneg_ser_5_0_3;
	assign inject_xneg_ser_4_0_3=eject_xpos_ser_3_0_3;
	assign inject_xpos_ser_4_0_4=eject_xneg_ser_5_0_4;
	assign inject_xneg_ser_4_0_4=eject_xpos_ser_3_0_4;
	assign inject_xpos_ser_4_0_5=eject_xneg_ser_5_0_5;
	assign inject_xneg_ser_4_0_5=eject_xpos_ser_3_0_5;
	assign inject_xpos_ser_4_0_6=eject_xneg_ser_5_0_6;
	assign inject_xneg_ser_4_0_6=eject_xpos_ser_3_0_6;
	assign inject_xpos_ser_4_0_7=eject_xneg_ser_5_0_7;
	assign inject_xneg_ser_4_0_7=eject_xpos_ser_3_0_7;
	assign inject_xpos_ser_4_1_0=eject_xneg_ser_5_1_0;
	assign inject_xneg_ser_4_1_0=eject_xpos_ser_3_1_0;
	assign inject_xpos_ser_4_1_1=eject_xneg_ser_5_1_1;
	assign inject_xneg_ser_4_1_1=eject_xpos_ser_3_1_1;
	assign inject_xpos_ser_4_1_2=eject_xneg_ser_5_1_2;
	assign inject_xneg_ser_4_1_2=eject_xpos_ser_3_1_2;
	assign inject_xpos_ser_4_1_3=eject_xneg_ser_5_1_3;
	assign inject_xneg_ser_4_1_3=eject_xpos_ser_3_1_3;
	assign inject_xpos_ser_4_1_4=eject_xneg_ser_5_1_4;
	assign inject_xneg_ser_4_1_4=eject_xpos_ser_3_1_4;
	assign inject_xpos_ser_4_1_5=eject_xneg_ser_5_1_5;
	assign inject_xneg_ser_4_1_5=eject_xpos_ser_3_1_5;
	assign inject_xpos_ser_4_1_6=eject_xneg_ser_5_1_6;
	assign inject_xneg_ser_4_1_6=eject_xpos_ser_3_1_6;
	assign inject_xpos_ser_4_1_7=eject_xneg_ser_5_1_7;
	assign inject_xneg_ser_4_1_7=eject_xpos_ser_3_1_7;
	assign inject_xpos_ser_4_2_0=eject_xneg_ser_5_2_0;
	assign inject_xneg_ser_4_2_0=eject_xpos_ser_3_2_0;
	assign inject_xpos_ser_4_2_1=eject_xneg_ser_5_2_1;
	assign inject_xneg_ser_4_2_1=eject_xpos_ser_3_2_1;
	assign inject_xpos_ser_4_2_2=eject_xneg_ser_5_2_2;
	assign inject_xneg_ser_4_2_2=eject_xpos_ser_3_2_2;
	assign inject_xpos_ser_4_2_3=eject_xneg_ser_5_2_3;
	assign inject_xneg_ser_4_2_3=eject_xpos_ser_3_2_3;
	assign inject_xpos_ser_4_2_4=eject_xneg_ser_5_2_4;
	assign inject_xneg_ser_4_2_4=eject_xpos_ser_3_2_4;
	assign inject_xpos_ser_4_2_5=eject_xneg_ser_5_2_5;
	assign inject_xneg_ser_4_2_5=eject_xpos_ser_3_2_5;
	assign inject_xpos_ser_4_2_6=eject_xneg_ser_5_2_6;
	assign inject_xneg_ser_4_2_6=eject_xpos_ser_3_2_6;
	assign inject_xpos_ser_4_2_7=eject_xneg_ser_5_2_7;
	assign inject_xneg_ser_4_2_7=eject_xpos_ser_3_2_7;
	assign inject_xpos_ser_4_3_0=eject_xneg_ser_5_3_0;
	assign inject_xneg_ser_4_3_0=eject_xpos_ser_3_3_0;
	assign inject_xpos_ser_4_3_1=eject_xneg_ser_5_3_1;
	assign inject_xneg_ser_4_3_1=eject_xpos_ser_3_3_1;
	assign inject_xpos_ser_4_3_2=eject_xneg_ser_5_3_2;
	assign inject_xneg_ser_4_3_2=eject_xpos_ser_3_3_2;
	assign inject_xpos_ser_4_3_3=eject_xneg_ser_5_3_3;
	assign inject_xneg_ser_4_3_3=eject_xpos_ser_3_3_3;
	assign inject_xpos_ser_4_3_4=eject_xneg_ser_5_3_4;
	assign inject_xneg_ser_4_3_4=eject_xpos_ser_3_3_4;
	assign inject_xpos_ser_4_3_5=eject_xneg_ser_5_3_5;
	assign inject_xneg_ser_4_3_5=eject_xpos_ser_3_3_5;
	assign inject_xpos_ser_4_3_6=eject_xneg_ser_5_3_6;
	assign inject_xneg_ser_4_3_6=eject_xpos_ser_3_3_6;
	assign inject_xpos_ser_4_3_7=eject_xneg_ser_5_3_7;
	assign inject_xneg_ser_4_3_7=eject_xpos_ser_3_3_7;
	assign inject_xpos_ser_4_4_0=eject_xneg_ser_5_4_0;
	assign inject_xneg_ser_4_4_0=eject_xpos_ser_3_4_0;
	assign inject_xpos_ser_4_4_1=eject_xneg_ser_5_4_1;
	assign inject_xneg_ser_4_4_1=eject_xpos_ser_3_4_1;
	assign inject_xpos_ser_4_4_2=eject_xneg_ser_5_4_2;
	assign inject_xneg_ser_4_4_2=eject_xpos_ser_3_4_2;
	assign inject_xpos_ser_4_4_3=eject_xneg_ser_5_4_3;
	assign inject_xneg_ser_4_4_3=eject_xpos_ser_3_4_3;
	assign inject_xpos_ser_4_4_4=eject_xneg_ser_5_4_4;
	assign inject_xneg_ser_4_4_4=eject_xpos_ser_3_4_4;
	assign inject_xpos_ser_4_4_5=eject_xneg_ser_5_4_5;
	assign inject_xneg_ser_4_4_5=eject_xpos_ser_3_4_5;
	assign inject_xpos_ser_4_4_6=eject_xneg_ser_5_4_6;
	assign inject_xneg_ser_4_4_6=eject_xpos_ser_3_4_6;
	assign inject_xpos_ser_4_4_7=eject_xneg_ser_5_4_7;
	assign inject_xneg_ser_4_4_7=eject_xpos_ser_3_4_7;
	assign inject_xpos_ser_4_5_0=eject_xneg_ser_5_5_0;
	assign inject_xneg_ser_4_5_0=eject_xpos_ser_3_5_0;
	assign inject_xpos_ser_4_5_1=eject_xneg_ser_5_5_1;
	assign inject_xneg_ser_4_5_1=eject_xpos_ser_3_5_1;
	assign inject_xpos_ser_4_5_2=eject_xneg_ser_5_5_2;
	assign inject_xneg_ser_4_5_2=eject_xpos_ser_3_5_2;
	assign inject_xpos_ser_4_5_3=eject_xneg_ser_5_5_3;
	assign inject_xneg_ser_4_5_3=eject_xpos_ser_3_5_3;
	assign inject_xpos_ser_4_5_4=eject_xneg_ser_5_5_4;
	assign inject_xneg_ser_4_5_4=eject_xpos_ser_3_5_4;
	assign inject_xpos_ser_4_5_5=eject_xneg_ser_5_5_5;
	assign inject_xneg_ser_4_5_5=eject_xpos_ser_3_5_5;
	assign inject_xpos_ser_4_5_6=eject_xneg_ser_5_5_6;
	assign inject_xneg_ser_4_5_6=eject_xpos_ser_3_5_6;
	assign inject_xpos_ser_4_5_7=eject_xneg_ser_5_5_7;
	assign inject_xneg_ser_4_5_7=eject_xpos_ser_3_5_7;
	assign inject_xpos_ser_4_6_0=eject_xneg_ser_5_6_0;
	assign inject_xneg_ser_4_6_0=eject_xpos_ser_3_6_0;
	assign inject_xpos_ser_4_6_1=eject_xneg_ser_5_6_1;
	assign inject_xneg_ser_4_6_1=eject_xpos_ser_3_6_1;
	assign inject_xpos_ser_4_6_2=eject_xneg_ser_5_6_2;
	assign inject_xneg_ser_4_6_2=eject_xpos_ser_3_6_2;
	assign inject_xpos_ser_4_6_3=eject_xneg_ser_5_6_3;
	assign inject_xneg_ser_4_6_3=eject_xpos_ser_3_6_3;
	assign inject_xpos_ser_4_6_4=eject_xneg_ser_5_6_4;
	assign inject_xneg_ser_4_6_4=eject_xpos_ser_3_6_4;
	assign inject_xpos_ser_4_6_5=eject_xneg_ser_5_6_5;
	assign inject_xneg_ser_4_6_5=eject_xpos_ser_3_6_5;
	assign inject_xpos_ser_4_6_6=eject_xneg_ser_5_6_6;
	assign inject_xneg_ser_4_6_6=eject_xpos_ser_3_6_6;
	assign inject_xpos_ser_4_6_7=eject_xneg_ser_5_6_7;
	assign inject_xneg_ser_4_6_7=eject_xpos_ser_3_6_7;
	assign inject_xpos_ser_4_7_0=eject_xneg_ser_5_7_0;
	assign inject_xneg_ser_4_7_0=eject_xpos_ser_3_7_0;
	assign inject_xpos_ser_4_7_1=eject_xneg_ser_5_7_1;
	assign inject_xneg_ser_4_7_1=eject_xpos_ser_3_7_1;
	assign inject_xpos_ser_4_7_2=eject_xneg_ser_5_7_2;
	assign inject_xneg_ser_4_7_2=eject_xpos_ser_3_7_2;
	assign inject_xpos_ser_4_7_3=eject_xneg_ser_5_7_3;
	assign inject_xneg_ser_4_7_3=eject_xpos_ser_3_7_3;
	assign inject_xpos_ser_4_7_4=eject_xneg_ser_5_7_4;
	assign inject_xneg_ser_4_7_4=eject_xpos_ser_3_7_4;
	assign inject_xpos_ser_4_7_5=eject_xneg_ser_5_7_5;
	assign inject_xneg_ser_4_7_5=eject_xpos_ser_3_7_5;
	assign inject_xpos_ser_4_7_6=eject_xneg_ser_5_7_6;
	assign inject_xneg_ser_4_7_6=eject_xpos_ser_3_7_6;
	assign inject_xpos_ser_4_7_7=eject_xneg_ser_5_7_7;
	assign inject_xneg_ser_4_7_7=eject_xpos_ser_3_7_7;
	assign inject_xpos_ser_5_0_0=eject_xneg_ser_6_0_0;
	assign inject_xneg_ser_5_0_0=eject_xpos_ser_4_0_0;
	assign inject_xpos_ser_5_0_1=eject_xneg_ser_6_0_1;
	assign inject_xneg_ser_5_0_1=eject_xpos_ser_4_0_1;
	assign inject_xpos_ser_5_0_2=eject_xneg_ser_6_0_2;
	assign inject_xneg_ser_5_0_2=eject_xpos_ser_4_0_2;
	assign inject_xpos_ser_5_0_3=eject_xneg_ser_6_0_3;
	assign inject_xneg_ser_5_0_3=eject_xpos_ser_4_0_3;
	assign inject_xpos_ser_5_0_4=eject_xneg_ser_6_0_4;
	assign inject_xneg_ser_5_0_4=eject_xpos_ser_4_0_4;
	assign inject_xpos_ser_5_0_5=eject_xneg_ser_6_0_5;
	assign inject_xneg_ser_5_0_5=eject_xpos_ser_4_0_5;
	assign inject_xpos_ser_5_0_6=eject_xneg_ser_6_0_6;
	assign inject_xneg_ser_5_0_6=eject_xpos_ser_4_0_6;
	assign inject_xpos_ser_5_0_7=eject_xneg_ser_6_0_7;
	assign inject_xneg_ser_5_0_7=eject_xpos_ser_4_0_7;
	assign inject_xpos_ser_5_1_0=eject_xneg_ser_6_1_0;
	assign inject_xneg_ser_5_1_0=eject_xpos_ser_4_1_0;
	assign inject_xpos_ser_5_1_1=eject_xneg_ser_6_1_1;
	assign inject_xneg_ser_5_1_1=eject_xpos_ser_4_1_1;
	assign inject_xpos_ser_5_1_2=eject_xneg_ser_6_1_2;
	assign inject_xneg_ser_5_1_2=eject_xpos_ser_4_1_2;
	assign inject_xpos_ser_5_1_3=eject_xneg_ser_6_1_3;
	assign inject_xneg_ser_5_1_3=eject_xpos_ser_4_1_3;
	assign inject_xpos_ser_5_1_4=eject_xneg_ser_6_1_4;
	assign inject_xneg_ser_5_1_4=eject_xpos_ser_4_1_4;
	assign inject_xpos_ser_5_1_5=eject_xneg_ser_6_1_5;
	assign inject_xneg_ser_5_1_5=eject_xpos_ser_4_1_5;
	assign inject_xpos_ser_5_1_6=eject_xneg_ser_6_1_6;
	assign inject_xneg_ser_5_1_6=eject_xpos_ser_4_1_6;
	assign inject_xpos_ser_5_1_7=eject_xneg_ser_6_1_7;
	assign inject_xneg_ser_5_1_7=eject_xpos_ser_4_1_7;
	assign inject_xpos_ser_5_2_0=eject_xneg_ser_6_2_0;
	assign inject_xneg_ser_5_2_0=eject_xpos_ser_4_2_0;
	assign inject_xpos_ser_5_2_1=eject_xneg_ser_6_2_1;
	assign inject_xneg_ser_5_2_1=eject_xpos_ser_4_2_1;
	assign inject_xpos_ser_5_2_2=eject_xneg_ser_6_2_2;
	assign inject_xneg_ser_5_2_2=eject_xpos_ser_4_2_2;
	assign inject_xpos_ser_5_2_3=eject_xneg_ser_6_2_3;
	assign inject_xneg_ser_5_2_3=eject_xpos_ser_4_2_3;
	assign inject_xpos_ser_5_2_4=eject_xneg_ser_6_2_4;
	assign inject_xneg_ser_5_2_4=eject_xpos_ser_4_2_4;
	assign inject_xpos_ser_5_2_5=eject_xneg_ser_6_2_5;
	assign inject_xneg_ser_5_2_5=eject_xpos_ser_4_2_5;
	assign inject_xpos_ser_5_2_6=eject_xneg_ser_6_2_6;
	assign inject_xneg_ser_5_2_6=eject_xpos_ser_4_2_6;
	assign inject_xpos_ser_5_2_7=eject_xneg_ser_6_2_7;
	assign inject_xneg_ser_5_2_7=eject_xpos_ser_4_2_7;
	assign inject_xpos_ser_5_3_0=eject_xneg_ser_6_3_0;
	assign inject_xneg_ser_5_3_0=eject_xpos_ser_4_3_0;
	assign inject_xpos_ser_5_3_1=eject_xneg_ser_6_3_1;
	assign inject_xneg_ser_5_3_1=eject_xpos_ser_4_3_1;
	assign inject_xpos_ser_5_3_2=eject_xneg_ser_6_3_2;
	assign inject_xneg_ser_5_3_2=eject_xpos_ser_4_3_2;
	assign inject_xpos_ser_5_3_3=eject_xneg_ser_6_3_3;
	assign inject_xneg_ser_5_3_3=eject_xpos_ser_4_3_3;
	assign inject_xpos_ser_5_3_4=eject_xneg_ser_6_3_4;
	assign inject_xneg_ser_5_3_4=eject_xpos_ser_4_3_4;
	assign inject_xpos_ser_5_3_5=eject_xneg_ser_6_3_5;
	assign inject_xneg_ser_5_3_5=eject_xpos_ser_4_3_5;
	assign inject_xpos_ser_5_3_6=eject_xneg_ser_6_3_6;
	assign inject_xneg_ser_5_3_6=eject_xpos_ser_4_3_6;
	assign inject_xpos_ser_5_3_7=eject_xneg_ser_6_3_7;
	assign inject_xneg_ser_5_3_7=eject_xpos_ser_4_3_7;
	assign inject_xpos_ser_5_4_0=eject_xneg_ser_6_4_0;
	assign inject_xneg_ser_5_4_0=eject_xpos_ser_4_4_0;
	assign inject_xpos_ser_5_4_1=eject_xneg_ser_6_4_1;
	assign inject_xneg_ser_5_4_1=eject_xpos_ser_4_4_1;
	assign inject_xpos_ser_5_4_2=eject_xneg_ser_6_4_2;
	assign inject_xneg_ser_5_4_2=eject_xpos_ser_4_4_2;
	assign inject_xpos_ser_5_4_3=eject_xneg_ser_6_4_3;
	assign inject_xneg_ser_5_4_3=eject_xpos_ser_4_4_3;
	assign inject_xpos_ser_5_4_4=eject_xneg_ser_6_4_4;
	assign inject_xneg_ser_5_4_4=eject_xpos_ser_4_4_4;
	assign inject_xpos_ser_5_4_5=eject_xneg_ser_6_4_5;
	assign inject_xneg_ser_5_4_5=eject_xpos_ser_4_4_5;
	assign inject_xpos_ser_5_4_6=eject_xneg_ser_6_4_6;
	assign inject_xneg_ser_5_4_6=eject_xpos_ser_4_4_6;
	assign inject_xpos_ser_5_4_7=eject_xneg_ser_6_4_7;
	assign inject_xneg_ser_5_4_7=eject_xpos_ser_4_4_7;
	assign inject_xpos_ser_5_5_0=eject_xneg_ser_6_5_0;
	assign inject_xneg_ser_5_5_0=eject_xpos_ser_4_5_0;
	assign inject_xpos_ser_5_5_1=eject_xneg_ser_6_5_1;
	assign inject_xneg_ser_5_5_1=eject_xpos_ser_4_5_1;
	assign inject_xpos_ser_5_5_2=eject_xneg_ser_6_5_2;
	assign inject_xneg_ser_5_5_2=eject_xpos_ser_4_5_2;
	assign inject_xpos_ser_5_5_3=eject_xneg_ser_6_5_3;
	assign inject_xneg_ser_5_5_3=eject_xpos_ser_4_5_3;
	assign inject_xpos_ser_5_5_4=eject_xneg_ser_6_5_4;
	assign inject_xneg_ser_5_5_4=eject_xpos_ser_4_5_4;
	assign inject_xpos_ser_5_5_5=eject_xneg_ser_6_5_5;
	assign inject_xneg_ser_5_5_5=eject_xpos_ser_4_5_5;
	assign inject_xpos_ser_5_5_6=eject_xneg_ser_6_5_6;
	assign inject_xneg_ser_5_5_6=eject_xpos_ser_4_5_6;
	assign inject_xpos_ser_5_5_7=eject_xneg_ser_6_5_7;
	assign inject_xneg_ser_5_5_7=eject_xpos_ser_4_5_7;
	assign inject_xpos_ser_5_6_0=eject_xneg_ser_6_6_0;
	assign inject_xneg_ser_5_6_0=eject_xpos_ser_4_6_0;
	assign inject_xpos_ser_5_6_1=eject_xneg_ser_6_6_1;
	assign inject_xneg_ser_5_6_1=eject_xpos_ser_4_6_1;
	assign inject_xpos_ser_5_6_2=eject_xneg_ser_6_6_2;
	assign inject_xneg_ser_5_6_2=eject_xpos_ser_4_6_2;
	assign inject_xpos_ser_5_6_3=eject_xneg_ser_6_6_3;
	assign inject_xneg_ser_5_6_3=eject_xpos_ser_4_6_3;
	assign inject_xpos_ser_5_6_4=eject_xneg_ser_6_6_4;
	assign inject_xneg_ser_5_6_4=eject_xpos_ser_4_6_4;
	assign inject_xpos_ser_5_6_5=eject_xneg_ser_6_6_5;
	assign inject_xneg_ser_5_6_5=eject_xpos_ser_4_6_5;
	assign inject_xpos_ser_5_6_6=eject_xneg_ser_6_6_6;
	assign inject_xneg_ser_5_6_6=eject_xpos_ser_4_6_6;
	assign inject_xpos_ser_5_6_7=eject_xneg_ser_6_6_7;
	assign inject_xneg_ser_5_6_7=eject_xpos_ser_4_6_7;
	assign inject_xpos_ser_5_7_0=eject_xneg_ser_6_7_0;
	assign inject_xneg_ser_5_7_0=eject_xpos_ser_4_7_0;
	assign inject_xpos_ser_5_7_1=eject_xneg_ser_6_7_1;
	assign inject_xneg_ser_5_7_1=eject_xpos_ser_4_7_1;
	assign inject_xpos_ser_5_7_2=eject_xneg_ser_6_7_2;
	assign inject_xneg_ser_5_7_2=eject_xpos_ser_4_7_2;
	assign inject_xpos_ser_5_7_3=eject_xneg_ser_6_7_3;
	assign inject_xneg_ser_5_7_3=eject_xpos_ser_4_7_3;
	assign inject_xpos_ser_5_7_4=eject_xneg_ser_6_7_4;
	assign inject_xneg_ser_5_7_4=eject_xpos_ser_4_7_4;
	assign inject_xpos_ser_5_7_5=eject_xneg_ser_6_7_5;
	assign inject_xneg_ser_5_7_5=eject_xpos_ser_4_7_5;
	assign inject_xpos_ser_5_7_6=eject_xneg_ser_6_7_6;
	assign inject_xneg_ser_5_7_6=eject_xpos_ser_4_7_6;
	assign inject_xpos_ser_5_7_7=eject_xneg_ser_6_7_7;
	assign inject_xneg_ser_5_7_7=eject_xpos_ser_4_7_7;
	assign inject_xpos_ser_6_0_0=eject_xneg_ser_7_0_0;
	assign inject_xneg_ser_6_0_0=eject_xpos_ser_5_0_0;
	assign inject_xpos_ser_6_0_1=eject_xneg_ser_7_0_1;
	assign inject_xneg_ser_6_0_1=eject_xpos_ser_5_0_1;
	assign inject_xpos_ser_6_0_2=eject_xneg_ser_7_0_2;
	assign inject_xneg_ser_6_0_2=eject_xpos_ser_5_0_2;
	assign inject_xpos_ser_6_0_3=eject_xneg_ser_7_0_3;
	assign inject_xneg_ser_6_0_3=eject_xpos_ser_5_0_3;
	assign inject_xpos_ser_6_0_4=eject_xneg_ser_7_0_4;
	assign inject_xneg_ser_6_0_4=eject_xpos_ser_5_0_4;
	assign inject_xpos_ser_6_0_5=eject_xneg_ser_7_0_5;
	assign inject_xneg_ser_6_0_5=eject_xpos_ser_5_0_5;
	assign inject_xpos_ser_6_0_6=eject_xneg_ser_7_0_6;
	assign inject_xneg_ser_6_0_6=eject_xpos_ser_5_0_6;
	assign inject_xpos_ser_6_0_7=eject_xneg_ser_7_0_7;
	assign inject_xneg_ser_6_0_7=eject_xpos_ser_5_0_7;
	assign inject_xpos_ser_6_1_0=eject_xneg_ser_7_1_0;
	assign inject_xneg_ser_6_1_0=eject_xpos_ser_5_1_0;
	assign inject_xpos_ser_6_1_1=eject_xneg_ser_7_1_1;
	assign inject_xneg_ser_6_1_1=eject_xpos_ser_5_1_1;
	assign inject_xpos_ser_6_1_2=eject_xneg_ser_7_1_2;
	assign inject_xneg_ser_6_1_2=eject_xpos_ser_5_1_2;
	assign inject_xpos_ser_6_1_3=eject_xneg_ser_7_1_3;
	assign inject_xneg_ser_6_1_3=eject_xpos_ser_5_1_3;
	assign inject_xpos_ser_6_1_4=eject_xneg_ser_7_1_4;
	assign inject_xneg_ser_6_1_4=eject_xpos_ser_5_1_4;
	assign inject_xpos_ser_6_1_5=eject_xneg_ser_7_1_5;
	assign inject_xneg_ser_6_1_5=eject_xpos_ser_5_1_5;
	assign inject_xpos_ser_6_1_6=eject_xneg_ser_7_1_6;
	assign inject_xneg_ser_6_1_6=eject_xpos_ser_5_1_6;
	assign inject_xpos_ser_6_1_7=eject_xneg_ser_7_1_7;
	assign inject_xneg_ser_6_1_7=eject_xpos_ser_5_1_7;
	assign inject_xpos_ser_6_2_0=eject_xneg_ser_7_2_0;
	assign inject_xneg_ser_6_2_0=eject_xpos_ser_5_2_0;
	assign inject_xpos_ser_6_2_1=eject_xneg_ser_7_2_1;
	assign inject_xneg_ser_6_2_1=eject_xpos_ser_5_2_1;
	assign inject_xpos_ser_6_2_2=eject_xneg_ser_7_2_2;
	assign inject_xneg_ser_6_2_2=eject_xpos_ser_5_2_2;
	assign inject_xpos_ser_6_2_3=eject_xneg_ser_7_2_3;
	assign inject_xneg_ser_6_2_3=eject_xpos_ser_5_2_3;
	assign inject_xpos_ser_6_2_4=eject_xneg_ser_7_2_4;
	assign inject_xneg_ser_6_2_4=eject_xpos_ser_5_2_4;
	assign inject_xpos_ser_6_2_5=eject_xneg_ser_7_2_5;
	assign inject_xneg_ser_6_2_5=eject_xpos_ser_5_2_5;
	assign inject_xpos_ser_6_2_6=eject_xneg_ser_7_2_6;
	assign inject_xneg_ser_6_2_6=eject_xpos_ser_5_2_6;
	assign inject_xpos_ser_6_2_7=eject_xneg_ser_7_2_7;
	assign inject_xneg_ser_6_2_7=eject_xpos_ser_5_2_7;
	assign inject_xpos_ser_6_3_0=eject_xneg_ser_7_3_0;
	assign inject_xneg_ser_6_3_0=eject_xpos_ser_5_3_0;
	assign inject_xpos_ser_6_3_1=eject_xneg_ser_7_3_1;
	assign inject_xneg_ser_6_3_1=eject_xpos_ser_5_3_1;
	assign inject_xpos_ser_6_3_2=eject_xneg_ser_7_3_2;
	assign inject_xneg_ser_6_3_2=eject_xpos_ser_5_3_2;
	assign inject_xpos_ser_6_3_3=eject_xneg_ser_7_3_3;
	assign inject_xneg_ser_6_3_3=eject_xpos_ser_5_3_3;
	assign inject_xpos_ser_6_3_4=eject_xneg_ser_7_3_4;
	assign inject_xneg_ser_6_3_4=eject_xpos_ser_5_3_4;
	assign inject_xpos_ser_6_3_5=eject_xneg_ser_7_3_5;
	assign inject_xneg_ser_6_3_5=eject_xpos_ser_5_3_5;
	assign inject_xpos_ser_6_3_6=eject_xneg_ser_7_3_6;
	assign inject_xneg_ser_6_3_6=eject_xpos_ser_5_3_6;
	assign inject_xpos_ser_6_3_7=eject_xneg_ser_7_3_7;
	assign inject_xneg_ser_6_3_7=eject_xpos_ser_5_3_7;
	assign inject_xpos_ser_6_4_0=eject_xneg_ser_7_4_0;
	assign inject_xneg_ser_6_4_0=eject_xpos_ser_5_4_0;
	assign inject_xpos_ser_6_4_1=eject_xneg_ser_7_4_1;
	assign inject_xneg_ser_6_4_1=eject_xpos_ser_5_4_1;
	assign inject_xpos_ser_6_4_2=eject_xneg_ser_7_4_2;
	assign inject_xneg_ser_6_4_2=eject_xpos_ser_5_4_2;
	assign inject_xpos_ser_6_4_3=eject_xneg_ser_7_4_3;
	assign inject_xneg_ser_6_4_3=eject_xpos_ser_5_4_3;
	assign inject_xpos_ser_6_4_4=eject_xneg_ser_7_4_4;
	assign inject_xneg_ser_6_4_4=eject_xpos_ser_5_4_4;
	assign inject_xpos_ser_6_4_5=eject_xneg_ser_7_4_5;
	assign inject_xneg_ser_6_4_5=eject_xpos_ser_5_4_5;
	assign inject_xpos_ser_6_4_6=eject_xneg_ser_7_4_6;
	assign inject_xneg_ser_6_4_6=eject_xpos_ser_5_4_6;
	assign inject_xpos_ser_6_4_7=eject_xneg_ser_7_4_7;
	assign inject_xneg_ser_6_4_7=eject_xpos_ser_5_4_7;
	assign inject_xpos_ser_6_5_0=eject_xneg_ser_7_5_0;
	assign inject_xneg_ser_6_5_0=eject_xpos_ser_5_5_0;
	assign inject_xpos_ser_6_5_1=eject_xneg_ser_7_5_1;
	assign inject_xneg_ser_6_5_1=eject_xpos_ser_5_5_1;
	assign inject_xpos_ser_6_5_2=eject_xneg_ser_7_5_2;
	assign inject_xneg_ser_6_5_2=eject_xpos_ser_5_5_2;
	assign inject_xpos_ser_6_5_3=eject_xneg_ser_7_5_3;
	assign inject_xneg_ser_6_5_3=eject_xpos_ser_5_5_3;
	assign inject_xpos_ser_6_5_4=eject_xneg_ser_7_5_4;
	assign inject_xneg_ser_6_5_4=eject_xpos_ser_5_5_4;
	assign inject_xpos_ser_6_5_5=eject_xneg_ser_7_5_5;
	assign inject_xneg_ser_6_5_5=eject_xpos_ser_5_5_5;
	assign inject_xpos_ser_6_5_6=eject_xneg_ser_7_5_6;
	assign inject_xneg_ser_6_5_6=eject_xpos_ser_5_5_6;
	assign inject_xpos_ser_6_5_7=eject_xneg_ser_7_5_7;
	assign inject_xneg_ser_6_5_7=eject_xpos_ser_5_5_7;
	assign inject_xpos_ser_6_6_0=eject_xneg_ser_7_6_0;
	assign inject_xneg_ser_6_6_0=eject_xpos_ser_5_6_0;
	assign inject_xpos_ser_6_6_1=eject_xneg_ser_7_6_1;
	assign inject_xneg_ser_6_6_1=eject_xpos_ser_5_6_1;
	assign inject_xpos_ser_6_6_2=eject_xneg_ser_7_6_2;
	assign inject_xneg_ser_6_6_2=eject_xpos_ser_5_6_2;
	assign inject_xpos_ser_6_6_3=eject_xneg_ser_7_6_3;
	assign inject_xneg_ser_6_6_3=eject_xpos_ser_5_6_3;
	assign inject_xpos_ser_6_6_4=eject_xneg_ser_7_6_4;
	assign inject_xneg_ser_6_6_4=eject_xpos_ser_5_6_4;
	assign inject_xpos_ser_6_6_5=eject_xneg_ser_7_6_5;
	assign inject_xneg_ser_6_6_5=eject_xpos_ser_5_6_5;
	assign inject_xpos_ser_6_6_6=eject_xneg_ser_7_6_6;
	assign inject_xneg_ser_6_6_6=eject_xpos_ser_5_6_6;
	assign inject_xpos_ser_6_6_7=eject_xneg_ser_7_6_7;
	assign inject_xneg_ser_6_6_7=eject_xpos_ser_5_6_7;
	assign inject_xpos_ser_6_7_0=eject_xneg_ser_7_7_0;
	assign inject_xneg_ser_6_7_0=eject_xpos_ser_5_7_0;
	assign inject_xpos_ser_6_7_1=eject_xneg_ser_7_7_1;
	assign inject_xneg_ser_6_7_1=eject_xpos_ser_5_7_1;
	assign inject_xpos_ser_6_7_2=eject_xneg_ser_7_7_2;
	assign inject_xneg_ser_6_7_2=eject_xpos_ser_5_7_2;
	assign inject_xpos_ser_6_7_3=eject_xneg_ser_7_7_3;
	assign inject_xneg_ser_6_7_3=eject_xpos_ser_5_7_3;
	assign inject_xpos_ser_6_7_4=eject_xneg_ser_7_7_4;
	assign inject_xneg_ser_6_7_4=eject_xpos_ser_5_7_4;
	assign inject_xpos_ser_6_7_5=eject_xneg_ser_7_7_5;
	assign inject_xneg_ser_6_7_5=eject_xpos_ser_5_7_5;
	assign inject_xpos_ser_6_7_6=eject_xneg_ser_7_7_6;
	assign inject_xneg_ser_6_7_6=eject_xpos_ser_5_7_6;
	assign inject_xpos_ser_6_7_7=eject_xneg_ser_7_7_7;
	assign inject_xneg_ser_6_7_7=eject_xpos_ser_5_7_7;
	assign inject_xpos_ser_7_0_0=eject_xneg_ser_0_0_0;
	assign inject_xneg_ser_7_0_0=eject_xpos_ser_6_0_0;
	assign inject_xpos_ser_7_0_1=eject_xneg_ser_0_0_1;
	assign inject_xneg_ser_7_0_1=eject_xpos_ser_6_0_1;
	assign inject_xpos_ser_7_0_2=eject_xneg_ser_0_0_2;
	assign inject_xneg_ser_7_0_2=eject_xpos_ser_6_0_2;
	assign inject_xpos_ser_7_0_3=eject_xneg_ser_0_0_3;
	assign inject_xneg_ser_7_0_3=eject_xpos_ser_6_0_3;
	assign inject_xpos_ser_7_0_4=eject_xneg_ser_0_0_4;
	assign inject_xneg_ser_7_0_4=eject_xpos_ser_6_0_4;
	assign inject_xpos_ser_7_0_5=eject_xneg_ser_0_0_5;
	assign inject_xneg_ser_7_0_5=eject_xpos_ser_6_0_5;
	assign inject_xpos_ser_7_0_6=eject_xneg_ser_0_0_6;
	assign inject_xneg_ser_7_0_6=eject_xpos_ser_6_0_6;
	assign inject_xpos_ser_7_0_7=eject_xneg_ser_0_0_7;
	assign inject_xneg_ser_7_0_7=eject_xpos_ser_6_0_7;
	assign inject_xpos_ser_7_1_0=eject_xneg_ser_0_1_0;
	assign inject_xneg_ser_7_1_0=eject_xpos_ser_6_1_0;
	assign inject_xpos_ser_7_1_1=eject_xneg_ser_0_1_1;
	assign inject_xneg_ser_7_1_1=eject_xpos_ser_6_1_1;
	assign inject_xpos_ser_7_1_2=eject_xneg_ser_0_1_2;
	assign inject_xneg_ser_7_1_2=eject_xpos_ser_6_1_2;
	assign inject_xpos_ser_7_1_3=eject_xneg_ser_0_1_3;
	assign inject_xneg_ser_7_1_3=eject_xpos_ser_6_1_3;
	assign inject_xpos_ser_7_1_4=eject_xneg_ser_0_1_4;
	assign inject_xneg_ser_7_1_4=eject_xpos_ser_6_1_4;
	assign inject_xpos_ser_7_1_5=eject_xneg_ser_0_1_5;
	assign inject_xneg_ser_7_1_5=eject_xpos_ser_6_1_5;
	assign inject_xpos_ser_7_1_6=eject_xneg_ser_0_1_6;
	assign inject_xneg_ser_7_1_6=eject_xpos_ser_6_1_6;
	assign inject_xpos_ser_7_1_7=eject_xneg_ser_0_1_7;
	assign inject_xneg_ser_7_1_7=eject_xpos_ser_6_1_7;
	assign inject_xpos_ser_7_2_0=eject_xneg_ser_0_2_0;
	assign inject_xneg_ser_7_2_0=eject_xpos_ser_6_2_0;
	assign inject_xpos_ser_7_2_1=eject_xneg_ser_0_2_1;
	assign inject_xneg_ser_7_2_1=eject_xpos_ser_6_2_1;
	assign inject_xpos_ser_7_2_2=eject_xneg_ser_0_2_2;
	assign inject_xneg_ser_7_2_2=eject_xpos_ser_6_2_2;
	assign inject_xpos_ser_7_2_3=eject_xneg_ser_0_2_3;
	assign inject_xneg_ser_7_2_3=eject_xpos_ser_6_2_3;
	assign inject_xpos_ser_7_2_4=eject_xneg_ser_0_2_4;
	assign inject_xneg_ser_7_2_4=eject_xpos_ser_6_2_4;
	assign inject_xpos_ser_7_2_5=eject_xneg_ser_0_2_5;
	assign inject_xneg_ser_7_2_5=eject_xpos_ser_6_2_5;
	assign inject_xpos_ser_7_2_6=eject_xneg_ser_0_2_6;
	assign inject_xneg_ser_7_2_6=eject_xpos_ser_6_2_6;
	assign inject_xpos_ser_7_2_7=eject_xneg_ser_0_2_7;
	assign inject_xneg_ser_7_2_7=eject_xpos_ser_6_2_7;
	assign inject_xpos_ser_7_3_0=eject_xneg_ser_0_3_0;
	assign inject_xneg_ser_7_3_0=eject_xpos_ser_6_3_0;
	assign inject_xpos_ser_7_3_1=eject_xneg_ser_0_3_1;
	assign inject_xneg_ser_7_3_1=eject_xpos_ser_6_3_1;
	assign inject_xpos_ser_7_3_2=eject_xneg_ser_0_3_2;
	assign inject_xneg_ser_7_3_2=eject_xpos_ser_6_3_2;
	assign inject_xpos_ser_7_3_3=eject_xneg_ser_0_3_3;
	assign inject_xneg_ser_7_3_3=eject_xpos_ser_6_3_3;
	assign inject_xpos_ser_7_3_4=eject_xneg_ser_0_3_4;
	assign inject_xneg_ser_7_3_4=eject_xpos_ser_6_3_4;
	assign inject_xpos_ser_7_3_5=eject_xneg_ser_0_3_5;
	assign inject_xneg_ser_7_3_5=eject_xpos_ser_6_3_5;
	assign inject_xpos_ser_7_3_6=eject_xneg_ser_0_3_6;
	assign inject_xneg_ser_7_3_6=eject_xpos_ser_6_3_6;
	assign inject_xpos_ser_7_3_7=eject_xneg_ser_0_3_7;
	assign inject_xneg_ser_7_3_7=eject_xpos_ser_6_3_7;
	assign inject_xpos_ser_7_4_0=eject_xneg_ser_0_4_0;
	assign inject_xneg_ser_7_4_0=eject_xpos_ser_6_4_0;
	assign inject_xpos_ser_7_4_1=eject_xneg_ser_0_4_1;
	assign inject_xneg_ser_7_4_1=eject_xpos_ser_6_4_1;
	assign inject_xpos_ser_7_4_2=eject_xneg_ser_0_4_2;
	assign inject_xneg_ser_7_4_2=eject_xpos_ser_6_4_2;
	assign inject_xpos_ser_7_4_3=eject_xneg_ser_0_4_3;
	assign inject_xneg_ser_7_4_3=eject_xpos_ser_6_4_3;
	assign inject_xpos_ser_7_4_4=eject_xneg_ser_0_4_4;
	assign inject_xneg_ser_7_4_4=eject_xpos_ser_6_4_4;
	assign inject_xpos_ser_7_4_5=eject_xneg_ser_0_4_5;
	assign inject_xneg_ser_7_4_5=eject_xpos_ser_6_4_5;
	assign inject_xpos_ser_7_4_6=eject_xneg_ser_0_4_6;
	assign inject_xneg_ser_7_4_6=eject_xpos_ser_6_4_6;
	assign inject_xpos_ser_7_4_7=eject_xneg_ser_0_4_7;
	assign inject_xneg_ser_7_4_7=eject_xpos_ser_6_4_7;
	assign inject_xpos_ser_7_5_0=eject_xneg_ser_0_5_0;
	assign inject_xneg_ser_7_5_0=eject_xpos_ser_6_5_0;
	assign inject_xpos_ser_7_5_1=eject_xneg_ser_0_5_1;
	assign inject_xneg_ser_7_5_1=eject_xpos_ser_6_5_1;
	assign inject_xpos_ser_7_5_2=eject_xneg_ser_0_5_2;
	assign inject_xneg_ser_7_5_2=eject_xpos_ser_6_5_2;
	assign inject_xpos_ser_7_5_3=eject_xneg_ser_0_5_3;
	assign inject_xneg_ser_7_5_3=eject_xpos_ser_6_5_3;
	assign inject_xpos_ser_7_5_4=eject_xneg_ser_0_5_4;
	assign inject_xneg_ser_7_5_4=eject_xpos_ser_6_5_4;
	assign inject_xpos_ser_7_5_5=eject_xneg_ser_0_5_5;
	assign inject_xneg_ser_7_5_5=eject_xpos_ser_6_5_5;
	assign inject_xpos_ser_7_5_6=eject_xneg_ser_0_5_6;
	assign inject_xneg_ser_7_5_6=eject_xpos_ser_6_5_6;
	assign inject_xpos_ser_7_5_7=eject_xneg_ser_0_5_7;
	assign inject_xneg_ser_7_5_7=eject_xpos_ser_6_5_7;
	assign inject_xpos_ser_7_6_0=eject_xneg_ser_0_6_0;
	assign inject_xneg_ser_7_6_0=eject_xpos_ser_6_6_0;
	assign inject_xpos_ser_7_6_1=eject_xneg_ser_0_6_1;
	assign inject_xneg_ser_7_6_1=eject_xpos_ser_6_6_1;
	assign inject_xpos_ser_7_6_2=eject_xneg_ser_0_6_2;
	assign inject_xneg_ser_7_6_2=eject_xpos_ser_6_6_2;
	assign inject_xpos_ser_7_6_3=eject_xneg_ser_0_6_3;
	assign inject_xneg_ser_7_6_3=eject_xpos_ser_6_6_3;
	assign inject_xpos_ser_7_6_4=eject_xneg_ser_0_6_4;
	assign inject_xneg_ser_7_6_4=eject_xpos_ser_6_6_4;
	assign inject_xpos_ser_7_6_5=eject_xneg_ser_0_6_5;
	assign inject_xneg_ser_7_6_5=eject_xpos_ser_6_6_5;
	assign inject_xpos_ser_7_6_6=eject_xneg_ser_0_6_6;
	assign inject_xneg_ser_7_6_6=eject_xpos_ser_6_6_6;
	assign inject_xpos_ser_7_6_7=eject_xneg_ser_0_6_7;
	assign inject_xneg_ser_7_6_7=eject_xpos_ser_6_6_7;
	assign inject_xpos_ser_7_7_0=eject_xneg_ser_0_7_0;
	assign inject_xneg_ser_7_7_0=eject_xpos_ser_6_7_0;
	assign inject_xpos_ser_7_7_1=eject_xneg_ser_0_7_1;
	assign inject_xneg_ser_7_7_1=eject_xpos_ser_6_7_1;
	assign inject_xpos_ser_7_7_2=eject_xneg_ser_0_7_2;
	assign inject_xneg_ser_7_7_2=eject_xpos_ser_6_7_2;
	assign inject_xpos_ser_7_7_3=eject_xneg_ser_0_7_3;
	assign inject_xneg_ser_7_7_3=eject_xpos_ser_6_7_3;
	assign inject_xpos_ser_7_7_4=eject_xneg_ser_0_7_4;
	assign inject_xneg_ser_7_7_4=eject_xpos_ser_6_7_4;
	assign inject_xpos_ser_7_7_5=eject_xneg_ser_0_7_5;
	assign inject_xneg_ser_7_7_5=eject_xpos_ser_6_7_5;
	assign inject_xpos_ser_7_7_6=eject_xneg_ser_0_7_6;
	assign inject_xneg_ser_7_7_6=eject_xpos_ser_6_7_6;
	assign inject_xpos_ser_7_7_7=eject_xneg_ser_0_7_7;
	assign inject_xneg_ser_7_7_7=eject_xpos_ser_6_7_7;
	assign inject_ypos_ser_0_0_0=eject_yneg_ser_0_1_0;
	assign inject_yneg_ser_0_0_0=eject_ypos_ser_0_7_0;
	assign inject_ypos_ser_0_0_1=eject_yneg_ser_0_1_1;
	assign inject_yneg_ser_0_0_1=eject_ypos_ser_0_7_1;
	assign inject_ypos_ser_0_0_2=eject_yneg_ser_0_1_2;
	assign inject_yneg_ser_0_0_2=eject_ypos_ser_0_7_2;
	assign inject_ypos_ser_0_0_3=eject_yneg_ser_0_1_3;
	assign inject_yneg_ser_0_0_3=eject_ypos_ser_0_7_3;
	assign inject_ypos_ser_0_0_4=eject_yneg_ser_0_1_4;
	assign inject_yneg_ser_0_0_4=eject_ypos_ser_0_7_4;
	assign inject_ypos_ser_0_0_5=eject_yneg_ser_0_1_5;
	assign inject_yneg_ser_0_0_5=eject_ypos_ser_0_7_5;
	assign inject_ypos_ser_0_0_6=eject_yneg_ser_0_1_6;
	assign inject_yneg_ser_0_0_6=eject_ypos_ser_0_7_6;
	assign inject_ypos_ser_0_0_7=eject_yneg_ser_0_1_7;
	assign inject_yneg_ser_0_0_7=eject_ypos_ser_0_7_7;
	assign inject_ypos_ser_0_1_0=eject_yneg_ser_0_2_0;
	assign inject_yneg_ser_0_1_0=eject_ypos_ser_0_0_0;
	assign inject_ypos_ser_0_1_1=eject_yneg_ser_0_2_1;
	assign inject_yneg_ser_0_1_1=eject_ypos_ser_0_0_1;
	assign inject_ypos_ser_0_1_2=eject_yneg_ser_0_2_2;
	assign inject_yneg_ser_0_1_2=eject_ypos_ser_0_0_2;
	assign inject_ypos_ser_0_1_3=eject_yneg_ser_0_2_3;
	assign inject_yneg_ser_0_1_3=eject_ypos_ser_0_0_3;
	assign inject_ypos_ser_0_1_4=eject_yneg_ser_0_2_4;
	assign inject_yneg_ser_0_1_4=eject_ypos_ser_0_0_4;
	assign inject_ypos_ser_0_1_5=eject_yneg_ser_0_2_5;
	assign inject_yneg_ser_0_1_5=eject_ypos_ser_0_0_5;
	assign inject_ypos_ser_0_1_6=eject_yneg_ser_0_2_6;
	assign inject_yneg_ser_0_1_6=eject_ypos_ser_0_0_6;
	assign inject_ypos_ser_0_1_7=eject_yneg_ser_0_2_7;
	assign inject_yneg_ser_0_1_7=eject_ypos_ser_0_0_7;
	assign inject_ypos_ser_0_2_0=eject_yneg_ser_0_3_0;
	assign inject_yneg_ser_0_2_0=eject_ypos_ser_0_1_0;
	assign inject_ypos_ser_0_2_1=eject_yneg_ser_0_3_1;
	assign inject_yneg_ser_0_2_1=eject_ypos_ser_0_1_1;
	assign inject_ypos_ser_0_2_2=eject_yneg_ser_0_3_2;
	assign inject_yneg_ser_0_2_2=eject_ypos_ser_0_1_2;
	assign inject_ypos_ser_0_2_3=eject_yneg_ser_0_3_3;
	assign inject_yneg_ser_0_2_3=eject_ypos_ser_0_1_3;
	assign inject_ypos_ser_0_2_4=eject_yneg_ser_0_3_4;
	assign inject_yneg_ser_0_2_4=eject_ypos_ser_0_1_4;
	assign inject_ypos_ser_0_2_5=eject_yneg_ser_0_3_5;
	assign inject_yneg_ser_0_2_5=eject_ypos_ser_0_1_5;
	assign inject_ypos_ser_0_2_6=eject_yneg_ser_0_3_6;
	assign inject_yneg_ser_0_2_6=eject_ypos_ser_0_1_6;
	assign inject_ypos_ser_0_2_7=eject_yneg_ser_0_3_7;
	assign inject_yneg_ser_0_2_7=eject_ypos_ser_0_1_7;
	assign inject_ypos_ser_0_3_0=eject_yneg_ser_0_4_0;
	assign inject_yneg_ser_0_3_0=eject_ypos_ser_0_2_0;
	assign inject_ypos_ser_0_3_1=eject_yneg_ser_0_4_1;
	assign inject_yneg_ser_0_3_1=eject_ypos_ser_0_2_1;
	assign inject_ypos_ser_0_3_2=eject_yneg_ser_0_4_2;
	assign inject_yneg_ser_0_3_2=eject_ypos_ser_0_2_2;
	assign inject_ypos_ser_0_3_3=eject_yneg_ser_0_4_3;
	assign inject_yneg_ser_0_3_3=eject_ypos_ser_0_2_3;
	assign inject_ypos_ser_0_3_4=eject_yneg_ser_0_4_4;
	assign inject_yneg_ser_0_3_4=eject_ypos_ser_0_2_4;
	assign inject_ypos_ser_0_3_5=eject_yneg_ser_0_4_5;
	assign inject_yneg_ser_0_3_5=eject_ypos_ser_0_2_5;
	assign inject_ypos_ser_0_3_6=eject_yneg_ser_0_4_6;
	assign inject_yneg_ser_0_3_6=eject_ypos_ser_0_2_6;
	assign inject_ypos_ser_0_3_7=eject_yneg_ser_0_4_7;
	assign inject_yneg_ser_0_3_7=eject_ypos_ser_0_2_7;
	assign inject_ypos_ser_0_4_0=eject_yneg_ser_0_5_0;
	assign inject_yneg_ser_0_4_0=eject_ypos_ser_0_3_0;
	assign inject_ypos_ser_0_4_1=eject_yneg_ser_0_5_1;
	assign inject_yneg_ser_0_4_1=eject_ypos_ser_0_3_1;
	assign inject_ypos_ser_0_4_2=eject_yneg_ser_0_5_2;
	assign inject_yneg_ser_0_4_2=eject_ypos_ser_0_3_2;
	assign inject_ypos_ser_0_4_3=eject_yneg_ser_0_5_3;
	assign inject_yneg_ser_0_4_3=eject_ypos_ser_0_3_3;
	assign inject_ypos_ser_0_4_4=eject_yneg_ser_0_5_4;
	assign inject_yneg_ser_0_4_4=eject_ypos_ser_0_3_4;
	assign inject_ypos_ser_0_4_5=eject_yneg_ser_0_5_5;
	assign inject_yneg_ser_0_4_5=eject_ypos_ser_0_3_5;
	assign inject_ypos_ser_0_4_6=eject_yneg_ser_0_5_6;
	assign inject_yneg_ser_0_4_6=eject_ypos_ser_0_3_6;
	assign inject_ypos_ser_0_4_7=eject_yneg_ser_0_5_7;
	assign inject_yneg_ser_0_4_7=eject_ypos_ser_0_3_7;
	assign inject_ypos_ser_0_5_0=eject_yneg_ser_0_6_0;
	assign inject_yneg_ser_0_5_0=eject_ypos_ser_0_4_0;
	assign inject_ypos_ser_0_5_1=eject_yneg_ser_0_6_1;
	assign inject_yneg_ser_0_5_1=eject_ypos_ser_0_4_1;
	assign inject_ypos_ser_0_5_2=eject_yneg_ser_0_6_2;
	assign inject_yneg_ser_0_5_2=eject_ypos_ser_0_4_2;
	assign inject_ypos_ser_0_5_3=eject_yneg_ser_0_6_3;
	assign inject_yneg_ser_0_5_3=eject_ypos_ser_0_4_3;
	assign inject_ypos_ser_0_5_4=eject_yneg_ser_0_6_4;
	assign inject_yneg_ser_0_5_4=eject_ypos_ser_0_4_4;
	assign inject_ypos_ser_0_5_5=eject_yneg_ser_0_6_5;
	assign inject_yneg_ser_0_5_5=eject_ypos_ser_0_4_5;
	assign inject_ypos_ser_0_5_6=eject_yneg_ser_0_6_6;
	assign inject_yneg_ser_0_5_6=eject_ypos_ser_0_4_6;
	assign inject_ypos_ser_0_5_7=eject_yneg_ser_0_6_7;
	assign inject_yneg_ser_0_5_7=eject_ypos_ser_0_4_7;
	assign inject_ypos_ser_0_6_0=eject_yneg_ser_0_7_0;
	assign inject_yneg_ser_0_6_0=eject_ypos_ser_0_5_0;
	assign inject_ypos_ser_0_6_1=eject_yneg_ser_0_7_1;
	assign inject_yneg_ser_0_6_1=eject_ypos_ser_0_5_1;
	assign inject_ypos_ser_0_6_2=eject_yneg_ser_0_7_2;
	assign inject_yneg_ser_0_6_2=eject_ypos_ser_0_5_2;
	assign inject_ypos_ser_0_6_3=eject_yneg_ser_0_7_3;
	assign inject_yneg_ser_0_6_3=eject_ypos_ser_0_5_3;
	assign inject_ypos_ser_0_6_4=eject_yneg_ser_0_7_4;
	assign inject_yneg_ser_0_6_4=eject_ypos_ser_0_5_4;
	assign inject_ypos_ser_0_6_5=eject_yneg_ser_0_7_5;
	assign inject_yneg_ser_0_6_5=eject_ypos_ser_0_5_5;
	assign inject_ypos_ser_0_6_6=eject_yneg_ser_0_7_6;
	assign inject_yneg_ser_0_6_6=eject_ypos_ser_0_5_6;
	assign inject_ypos_ser_0_6_7=eject_yneg_ser_0_7_7;
	assign inject_yneg_ser_0_6_7=eject_ypos_ser_0_5_7;
	assign inject_ypos_ser_0_7_0=eject_yneg_ser_0_0_0;
	assign inject_yneg_ser_0_7_0=eject_ypos_ser_0_6_0;
	assign inject_ypos_ser_0_7_1=eject_yneg_ser_0_0_1;
	assign inject_yneg_ser_0_7_1=eject_ypos_ser_0_6_1;
	assign inject_ypos_ser_0_7_2=eject_yneg_ser_0_0_2;
	assign inject_yneg_ser_0_7_2=eject_ypos_ser_0_6_2;
	assign inject_ypos_ser_0_7_3=eject_yneg_ser_0_0_3;
	assign inject_yneg_ser_0_7_3=eject_ypos_ser_0_6_3;
	assign inject_ypos_ser_0_7_4=eject_yneg_ser_0_0_4;
	assign inject_yneg_ser_0_7_4=eject_ypos_ser_0_6_4;
	assign inject_ypos_ser_0_7_5=eject_yneg_ser_0_0_5;
	assign inject_yneg_ser_0_7_5=eject_ypos_ser_0_6_5;
	assign inject_ypos_ser_0_7_6=eject_yneg_ser_0_0_6;
	assign inject_yneg_ser_0_7_6=eject_ypos_ser_0_6_6;
	assign inject_ypos_ser_0_7_7=eject_yneg_ser_0_0_7;
	assign inject_yneg_ser_0_7_7=eject_ypos_ser_0_6_7;
	assign inject_ypos_ser_1_0_0=eject_yneg_ser_1_1_0;
	assign inject_yneg_ser_1_0_0=eject_ypos_ser_1_7_0;
	assign inject_ypos_ser_1_0_1=eject_yneg_ser_1_1_1;
	assign inject_yneg_ser_1_0_1=eject_ypos_ser_1_7_1;
	assign inject_ypos_ser_1_0_2=eject_yneg_ser_1_1_2;
	assign inject_yneg_ser_1_0_2=eject_ypos_ser_1_7_2;
	assign inject_ypos_ser_1_0_3=eject_yneg_ser_1_1_3;
	assign inject_yneg_ser_1_0_3=eject_ypos_ser_1_7_3;
	assign inject_ypos_ser_1_0_4=eject_yneg_ser_1_1_4;
	assign inject_yneg_ser_1_0_4=eject_ypos_ser_1_7_4;
	assign inject_ypos_ser_1_0_5=eject_yneg_ser_1_1_5;
	assign inject_yneg_ser_1_0_5=eject_ypos_ser_1_7_5;
	assign inject_ypos_ser_1_0_6=eject_yneg_ser_1_1_6;
	assign inject_yneg_ser_1_0_6=eject_ypos_ser_1_7_6;
	assign inject_ypos_ser_1_0_7=eject_yneg_ser_1_1_7;
	assign inject_yneg_ser_1_0_7=eject_ypos_ser_1_7_7;
	assign inject_ypos_ser_1_1_0=eject_yneg_ser_1_2_0;
	assign inject_yneg_ser_1_1_0=eject_ypos_ser_1_0_0;
	assign inject_ypos_ser_1_1_1=eject_yneg_ser_1_2_1;
	assign inject_yneg_ser_1_1_1=eject_ypos_ser_1_0_1;
	assign inject_ypos_ser_1_1_2=eject_yneg_ser_1_2_2;
	assign inject_yneg_ser_1_1_2=eject_ypos_ser_1_0_2;
	assign inject_ypos_ser_1_1_3=eject_yneg_ser_1_2_3;
	assign inject_yneg_ser_1_1_3=eject_ypos_ser_1_0_3;
	assign inject_ypos_ser_1_1_4=eject_yneg_ser_1_2_4;
	assign inject_yneg_ser_1_1_4=eject_ypos_ser_1_0_4;
	assign inject_ypos_ser_1_1_5=eject_yneg_ser_1_2_5;
	assign inject_yneg_ser_1_1_5=eject_ypos_ser_1_0_5;
	assign inject_ypos_ser_1_1_6=eject_yneg_ser_1_2_6;
	assign inject_yneg_ser_1_1_6=eject_ypos_ser_1_0_6;
	assign inject_ypos_ser_1_1_7=eject_yneg_ser_1_2_7;
	assign inject_yneg_ser_1_1_7=eject_ypos_ser_1_0_7;
	assign inject_ypos_ser_1_2_0=eject_yneg_ser_1_3_0;
	assign inject_yneg_ser_1_2_0=eject_ypos_ser_1_1_0;
	assign inject_ypos_ser_1_2_1=eject_yneg_ser_1_3_1;
	assign inject_yneg_ser_1_2_1=eject_ypos_ser_1_1_1;
	assign inject_ypos_ser_1_2_2=eject_yneg_ser_1_3_2;
	assign inject_yneg_ser_1_2_2=eject_ypos_ser_1_1_2;
	assign inject_ypos_ser_1_2_3=eject_yneg_ser_1_3_3;
	assign inject_yneg_ser_1_2_3=eject_ypos_ser_1_1_3;
	assign inject_ypos_ser_1_2_4=eject_yneg_ser_1_3_4;
	assign inject_yneg_ser_1_2_4=eject_ypos_ser_1_1_4;
	assign inject_ypos_ser_1_2_5=eject_yneg_ser_1_3_5;
	assign inject_yneg_ser_1_2_5=eject_ypos_ser_1_1_5;
	assign inject_ypos_ser_1_2_6=eject_yneg_ser_1_3_6;
	assign inject_yneg_ser_1_2_6=eject_ypos_ser_1_1_6;
	assign inject_ypos_ser_1_2_7=eject_yneg_ser_1_3_7;
	assign inject_yneg_ser_1_2_7=eject_ypos_ser_1_1_7;
	assign inject_ypos_ser_1_3_0=eject_yneg_ser_1_4_0;
	assign inject_yneg_ser_1_3_0=eject_ypos_ser_1_2_0;
	assign inject_ypos_ser_1_3_1=eject_yneg_ser_1_4_1;
	assign inject_yneg_ser_1_3_1=eject_ypos_ser_1_2_1;
	assign inject_ypos_ser_1_3_2=eject_yneg_ser_1_4_2;
	assign inject_yneg_ser_1_3_2=eject_ypos_ser_1_2_2;
	assign inject_ypos_ser_1_3_3=eject_yneg_ser_1_4_3;
	assign inject_yneg_ser_1_3_3=eject_ypos_ser_1_2_3;
	assign inject_ypos_ser_1_3_4=eject_yneg_ser_1_4_4;
	assign inject_yneg_ser_1_3_4=eject_ypos_ser_1_2_4;
	assign inject_ypos_ser_1_3_5=eject_yneg_ser_1_4_5;
	assign inject_yneg_ser_1_3_5=eject_ypos_ser_1_2_5;
	assign inject_ypos_ser_1_3_6=eject_yneg_ser_1_4_6;
	assign inject_yneg_ser_1_3_6=eject_ypos_ser_1_2_6;
	assign inject_ypos_ser_1_3_7=eject_yneg_ser_1_4_7;
	assign inject_yneg_ser_1_3_7=eject_ypos_ser_1_2_7;
	assign inject_ypos_ser_1_4_0=eject_yneg_ser_1_5_0;
	assign inject_yneg_ser_1_4_0=eject_ypos_ser_1_3_0;
	assign inject_ypos_ser_1_4_1=eject_yneg_ser_1_5_1;
	assign inject_yneg_ser_1_4_1=eject_ypos_ser_1_3_1;
	assign inject_ypos_ser_1_4_2=eject_yneg_ser_1_5_2;
	assign inject_yneg_ser_1_4_2=eject_ypos_ser_1_3_2;
	assign inject_ypos_ser_1_4_3=eject_yneg_ser_1_5_3;
	assign inject_yneg_ser_1_4_3=eject_ypos_ser_1_3_3;
	assign inject_ypos_ser_1_4_4=eject_yneg_ser_1_5_4;
	assign inject_yneg_ser_1_4_4=eject_ypos_ser_1_3_4;
	assign inject_ypos_ser_1_4_5=eject_yneg_ser_1_5_5;
	assign inject_yneg_ser_1_4_5=eject_ypos_ser_1_3_5;
	assign inject_ypos_ser_1_4_6=eject_yneg_ser_1_5_6;
	assign inject_yneg_ser_1_4_6=eject_ypos_ser_1_3_6;
	assign inject_ypos_ser_1_4_7=eject_yneg_ser_1_5_7;
	assign inject_yneg_ser_1_4_7=eject_ypos_ser_1_3_7;
	assign inject_ypos_ser_1_5_0=eject_yneg_ser_1_6_0;
	assign inject_yneg_ser_1_5_0=eject_ypos_ser_1_4_0;
	assign inject_ypos_ser_1_5_1=eject_yneg_ser_1_6_1;
	assign inject_yneg_ser_1_5_1=eject_ypos_ser_1_4_1;
	assign inject_ypos_ser_1_5_2=eject_yneg_ser_1_6_2;
	assign inject_yneg_ser_1_5_2=eject_ypos_ser_1_4_2;
	assign inject_ypos_ser_1_5_3=eject_yneg_ser_1_6_3;
	assign inject_yneg_ser_1_5_3=eject_ypos_ser_1_4_3;
	assign inject_ypos_ser_1_5_4=eject_yneg_ser_1_6_4;
	assign inject_yneg_ser_1_5_4=eject_ypos_ser_1_4_4;
	assign inject_ypos_ser_1_5_5=eject_yneg_ser_1_6_5;
	assign inject_yneg_ser_1_5_5=eject_ypos_ser_1_4_5;
	assign inject_ypos_ser_1_5_6=eject_yneg_ser_1_6_6;
	assign inject_yneg_ser_1_5_6=eject_ypos_ser_1_4_6;
	assign inject_ypos_ser_1_5_7=eject_yneg_ser_1_6_7;
	assign inject_yneg_ser_1_5_7=eject_ypos_ser_1_4_7;
	assign inject_ypos_ser_1_6_0=eject_yneg_ser_1_7_0;
	assign inject_yneg_ser_1_6_0=eject_ypos_ser_1_5_0;
	assign inject_ypos_ser_1_6_1=eject_yneg_ser_1_7_1;
	assign inject_yneg_ser_1_6_1=eject_ypos_ser_1_5_1;
	assign inject_ypos_ser_1_6_2=eject_yneg_ser_1_7_2;
	assign inject_yneg_ser_1_6_2=eject_ypos_ser_1_5_2;
	assign inject_ypos_ser_1_6_3=eject_yneg_ser_1_7_3;
	assign inject_yneg_ser_1_6_3=eject_ypos_ser_1_5_3;
	assign inject_ypos_ser_1_6_4=eject_yneg_ser_1_7_4;
	assign inject_yneg_ser_1_6_4=eject_ypos_ser_1_5_4;
	assign inject_ypos_ser_1_6_5=eject_yneg_ser_1_7_5;
	assign inject_yneg_ser_1_6_5=eject_ypos_ser_1_5_5;
	assign inject_ypos_ser_1_6_6=eject_yneg_ser_1_7_6;
	assign inject_yneg_ser_1_6_6=eject_ypos_ser_1_5_6;
	assign inject_ypos_ser_1_6_7=eject_yneg_ser_1_7_7;
	assign inject_yneg_ser_1_6_7=eject_ypos_ser_1_5_7;
	assign inject_ypos_ser_1_7_0=eject_yneg_ser_1_0_0;
	assign inject_yneg_ser_1_7_0=eject_ypos_ser_1_6_0;
	assign inject_ypos_ser_1_7_1=eject_yneg_ser_1_0_1;
	assign inject_yneg_ser_1_7_1=eject_ypos_ser_1_6_1;
	assign inject_ypos_ser_1_7_2=eject_yneg_ser_1_0_2;
	assign inject_yneg_ser_1_7_2=eject_ypos_ser_1_6_2;
	assign inject_ypos_ser_1_7_3=eject_yneg_ser_1_0_3;
	assign inject_yneg_ser_1_7_3=eject_ypos_ser_1_6_3;
	assign inject_ypos_ser_1_7_4=eject_yneg_ser_1_0_4;
	assign inject_yneg_ser_1_7_4=eject_ypos_ser_1_6_4;
	assign inject_ypos_ser_1_7_5=eject_yneg_ser_1_0_5;
	assign inject_yneg_ser_1_7_5=eject_ypos_ser_1_6_5;
	assign inject_ypos_ser_1_7_6=eject_yneg_ser_1_0_6;
	assign inject_yneg_ser_1_7_6=eject_ypos_ser_1_6_6;
	assign inject_ypos_ser_1_7_7=eject_yneg_ser_1_0_7;
	assign inject_yneg_ser_1_7_7=eject_ypos_ser_1_6_7;
	assign inject_ypos_ser_2_0_0=eject_yneg_ser_2_1_0;
	assign inject_yneg_ser_2_0_0=eject_ypos_ser_2_7_0;
	assign inject_ypos_ser_2_0_1=eject_yneg_ser_2_1_1;
	assign inject_yneg_ser_2_0_1=eject_ypos_ser_2_7_1;
	assign inject_ypos_ser_2_0_2=eject_yneg_ser_2_1_2;
	assign inject_yneg_ser_2_0_2=eject_ypos_ser_2_7_2;
	assign inject_ypos_ser_2_0_3=eject_yneg_ser_2_1_3;
	assign inject_yneg_ser_2_0_3=eject_ypos_ser_2_7_3;
	assign inject_ypos_ser_2_0_4=eject_yneg_ser_2_1_4;
	assign inject_yneg_ser_2_0_4=eject_ypos_ser_2_7_4;
	assign inject_ypos_ser_2_0_5=eject_yneg_ser_2_1_5;
	assign inject_yneg_ser_2_0_5=eject_ypos_ser_2_7_5;
	assign inject_ypos_ser_2_0_6=eject_yneg_ser_2_1_6;
	assign inject_yneg_ser_2_0_6=eject_ypos_ser_2_7_6;
	assign inject_ypos_ser_2_0_7=eject_yneg_ser_2_1_7;
	assign inject_yneg_ser_2_0_7=eject_ypos_ser_2_7_7;
	assign inject_ypos_ser_2_1_0=eject_yneg_ser_2_2_0;
	assign inject_yneg_ser_2_1_0=eject_ypos_ser_2_0_0;
	assign inject_ypos_ser_2_1_1=eject_yneg_ser_2_2_1;
	assign inject_yneg_ser_2_1_1=eject_ypos_ser_2_0_1;
	assign inject_ypos_ser_2_1_2=eject_yneg_ser_2_2_2;
	assign inject_yneg_ser_2_1_2=eject_ypos_ser_2_0_2;
	assign inject_ypos_ser_2_1_3=eject_yneg_ser_2_2_3;
	assign inject_yneg_ser_2_1_3=eject_ypos_ser_2_0_3;
	assign inject_ypos_ser_2_1_4=eject_yneg_ser_2_2_4;
	assign inject_yneg_ser_2_1_4=eject_ypos_ser_2_0_4;
	assign inject_ypos_ser_2_1_5=eject_yneg_ser_2_2_5;
	assign inject_yneg_ser_2_1_5=eject_ypos_ser_2_0_5;
	assign inject_ypos_ser_2_1_6=eject_yneg_ser_2_2_6;
	assign inject_yneg_ser_2_1_6=eject_ypos_ser_2_0_6;
	assign inject_ypos_ser_2_1_7=eject_yneg_ser_2_2_7;
	assign inject_yneg_ser_2_1_7=eject_ypos_ser_2_0_7;
	assign inject_ypos_ser_2_2_0=eject_yneg_ser_2_3_0;
	assign inject_yneg_ser_2_2_0=eject_ypos_ser_2_1_0;
	assign inject_ypos_ser_2_2_1=eject_yneg_ser_2_3_1;
	assign inject_yneg_ser_2_2_1=eject_ypos_ser_2_1_1;
	assign inject_ypos_ser_2_2_2=eject_yneg_ser_2_3_2;
	assign inject_yneg_ser_2_2_2=eject_ypos_ser_2_1_2;
	assign inject_ypos_ser_2_2_3=eject_yneg_ser_2_3_3;
	assign inject_yneg_ser_2_2_3=eject_ypos_ser_2_1_3;
	assign inject_ypos_ser_2_2_4=eject_yneg_ser_2_3_4;
	assign inject_yneg_ser_2_2_4=eject_ypos_ser_2_1_4;
	assign inject_ypos_ser_2_2_5=eject_yneg_ser_2_3_5;
	assign inject_yneg_ser_2_2_5=eject_ypos_ser_2_1_5;
	assign inject_ypos_ser_2_2_6=eject_yneg_ser_2_3_6;
	assign inject_yneg_ser_2_2_6=eject_ypos_ser_2_1_6;
	assign inject_ypos_ser_2_2_7=eject_yneg_ser_2_3_7;
	assign inject_yneg_ser_2_2_7=eject_ypos_ser_2_1_7;
	assign inject_ypos_ser_2_3_0=eject_yneg_ser_2_4_0;
	assign inject_yneg_ser_2_3_0=eject_ypos_ser_2_2_0;
	assign inject_ypos_ser_2_3_1=eject_yneg_ser_2_4_1;
	assign inject_yneg_ser_2_3_1=eject_ypos_ser_2_2_1;
	assign inject_ypos_ser_2_3_2=eject_yneg_ser_2_4_2;
	assign inject_yneg_ser_2_3_2=eject_ypos_ser_2_2_2;
	assign inject_ypos_ser_2_3_3=eject_yneg_ser_2_4_3;
	assign inject_yneg_ser_2_3_3=eject_ypos_ser_2_2_3;
	assign inject_ypos_ser_2_3_4=eject_yneg_ser_2_4_4;
	assign inject_yneg_ser_2_3_4=eject_ypos_ser_2_2_4;
	assign inject_ypos_ser_2_3_5=eject_yneg_ser_2_4_5;
	assign inject_yneg_ser_2_3_5=eject_ypos_ser_2_2_5;
	assign inject_ypos_ser_2_3_6=eject_yneg_ser_2_4_6;
	assign inject_yneg_ser_2_3_6=eject_ypos_ser_2_2_6;
	assign inject_ypos_ser_2_3_7=eject_yneg_ser_2_4_7;
	assign inject_yneg_ser_2_3_7=eject_ypos_ser_2_2_7;
	assign inject_ypos_ser_2_4_0=eject_yneg_ser_2_5_0;
	assign inject_yneg_ser_2_4_0=eject_ypos_ser_2_3_0;
	assign inject_ypos_ser_2_4_1=eject_yneg_ser_2_5_1;
	assign inject_yneg_ser_2_4_1=eject_ypos_ser_2_3_1;
	assign inject_ypos_ser_2_4_2=eject_yneg_ser_2_5_2;
	assign inject_yneg_ser_2_4_2=eject_ypos_ser_2_3_2;
	assign inject_ypos_ser_2_4_3=eject_yneg_ser_2_5_3;
	assign inject_yneg_ser_2_4_3=eject_ypos_ser_2_3_3;
	assign inject_ypos_ser_2_4_4=eject_yneg_ser_2_5_4;
	assign inject_yneg_ser_2_4_4=eject_ypos_ser_2_3_4;
	assign inject_ypos_ser_2_4_5=eject_yneg_ser_2_5_5;
	assign inject_yneg_ser_2_4_5=eject_ypos_ser_2_3_5;
	assign inject_ypos_ser_2_4_6=eject_yneg_ser_2_5_6;
	assign inject_yneg_ser_2_4_6=eject_ypos_ser_2_3_6;
	assign inject_ypos_ser_2_4_7=eject_yneg_ser_2_5_7;
	assign inject_yneg_ser_2_4_7=eject_ypos_ser_2_3_7;
	assign inject_ypos_ser_2_5_0=eject_yneg_ser_2_6_0;
	assign inject_yneg_ser_2_5_0=eject_ypos_ser_2_4_0;
	assign inject_ypos_ser_2_5_1=eject_yneg_ser_2_6_1;
	assign inject_yneg_ser_2_5_1=eject_ypos_ser_2_4_1;
	assign inject_ypos_ser_2_5_2=eject_yneg_ser_2_6_2;
	assign inject_yneg_ser_2_5_2=eject_ypos_ser_2_4_2;
	assign inject_ypos_ser_2_5_3=eject_yneg_ser_2_6_3;
	assign inject_yneg_ser_2_5_3=eject_ypos_ser_2_4_3;
	assign inject_ypos_ser_2_5_4=eject_yneg_ser_2_6_4;
	assign inject_yneg_ser_2_5_4=eject_ypos_ser_2_4_4;
	assign inject_ypos_ser_2_5_5=eject_yneg_ser_2_6_5;
	assign inject_yneg_ser_2_5_5=eject_ypos_ser_2_4_5;
	assign inject_ypos_ser_2_5_6=eject_yneg_ser_2_6_6;
	assign inject_yneg_ser_2_5_6=eject_ypos_ser_2_4_6;
	assign inject_ypos_ser_2_5_7=eject_yneg_ser_2_6_7;
	assign inject_yneg_ser_2_5_7=eject_ypos_ser_2_4_7;
	assign inject_ypos_ser_2_6_0=eject_yneg_ser_2_7_0;
	assign inject_yneg_ser_2_6_0=eject_ypos_ser_2_5_0;
	assign inject_ypos_ser_2_6_1=eject_yneg_ser_2_7_1;
	assign inject_yneg_ser_2_6_1=eject_ypos_ser_2_5_1;
	assign inject_ypos_ser_2_6_2=eject_yneg_ser_2_7_2;
	assign inject_yneg_ser_2_6_2=eject_ypos_ser_2_5_2;
	assign inject_ypos_ser_2_6_3=eject_yneg_ser_2_7_3;
	assign inject_yneg_ser_2_6_3=eject_ypos_ser_2_5_3;
	assign inject_ypos_ser_2_6_4=eject_yneg_ser_2_7_4;
	assign inject_yneg_ser_2_6_4=eject_ypos_ser_2_5_4;
	assign inject_ypos_ser_2_6_5=eject_yneg_ser_2_7_5;
	assign inject_yneg_ser_2_6_5=eject_ypos_ser_2_5_5;
	assign inject_ypos_ser_2_6_6=eject_yneg_ser_2_7_6;
	assign inject_yneg_ser_2_6_6=eject_ypos_ser_2_5_6;
	assign inject_ypos_ser_2_6_7=eject_yneg_ser_2_7_7;
	assign inject_yneg_ser_2_6_7=eject_ypos_ser_2_5_7;
	assign inject_ypos_ser_2_7_0=eject_yneg_ser_2_0_0;
	assign inject_yneg_ser_2_7_0=eject_ypos_ser_2_6_0;
	assign inject_ypos_ser_2_7_1=eject_yneg_ser_2_0_1;
	assign inject_yneg_ser_2_7_1=eject_ypos_ser_2_6_1;
	assign inject_ypos_ser_2_7_2=eject_yneg_ser_2_0_2;
	assign inject_yneg_ser_2_7_2=eject_ypos_ser_2_6_2;
	assign inject_ypos_ser_2_7_3=eject_yneg_ser_2_0_3;
	assign inject_yneg_ser_2_7_3=eject_ypos_ser_2_6_3;
	assign inject_ypos_ser_2_7_4=eject_yneg_ser_2_0_4;
	assign inject_yneg_ser_2_7_4=eject_ypos_ser_2_6_4;
	assign inject_ypos_ser_2_7_5=eject_yneg_ser_2_0_5;
	assign inject_yneg_ser_2_7_5=eject_ypos_ser_2_6_5;
	assign inject_ypos_ser_2_7_6=eject_yneg_ser_2_0_6;
	assign inject_yneg_ser_2_7_6=eject_ypos_ser_2_6_6;
	assign inject_ypos_ser_2_7_7=eject_yneg_ser_2_0_7;
	assign inject_yneg_ser_2_7_7=eject_ypos_ser_2_6_7;
	assign inject_ypos_ser_3_0_0=eject_yneg_ser_3_1_0;
	assign inject_yneg_ser_3_0_0=eject_ypos_ser_3_7_0;
	assign inject_ypos_ser_3_0_1=eject_yneg_ser_3_1_1;
	assign inject_yneg_ser_3_0_1=eject_ypos_ser_3_7_1;
	assign inject_ypos_ser_3_0_2=eject_yneg_ser_3_1_2;
	assign inject_yneg_ser_3_0_2=eject_ypos_ser_3_7_2;
	assign inject_ypos_ser_3_0_3=eject_yneg_ser_3_1_3;
	assign inject_yneg_ser_3_0_3=eject_ypos_ser_3_7_3;
	assign inject_ypos_ser_3_0_4=eject_yneg_ser_3_1_4;
	assign inject_yneg_ser_3_0_4=eject_ypos_ser_3_7_4;
	assign inject_ypos_ser_3_0_5=eject_yneg_ser_3_1_5;
	assign inject_yneg_ser_3_0_5=eject_ypos_ser_3_7_5;
	assign inject_ypos_ser_3_0_6=eject_yneg_ser_3_1_6;
	assign inject_yneg_ser_3_0_6=eject_ypos_ser_3_7_6;
	assign inject_ypos_ser_3_0_7=eject_yneg_ser_3_1_7;
	assign inject_yneg_ser_3_0_7=eject_ypos_ser_3_7_7;
	assign inject_ypos_ser_3_1_0=eject_yneg_ser_3_2_0;
	assign inject_yneg_ser_3_1_0=eject_ypos_ser_3_0_0;
	assign inject_ypos_ser_3_1_1=eject_yneg_ser_3_2_1;
	assign inject_yneg_ser_3_1_1=eject_ypos_ser_3_0_1;
	assign inject_ypos_ser_3_1_2=eject_yneg_ser_3_2_2;
	assign inject_yneg_ser_3_1_2=eject_ypos_ser_3_0_2;
	assign inject_ypos_ser_3_1_3=eject_yneg_ser_3_2_3;
	assign inject_yneg_ser_3_1_3=eject_ypos_ser_3_0_3;
	assign inject_ypos_ser_3_1_4=eject_yneg_ser_3_2_4;
	assign inject_yneg_ser_3_1_4=eject_ypos_ser_3_0_4;
	assign inject_ypos_ser_3_1_5=eject_yneg_ser_3_2_5;
	assign inject_yneg_ser_3_1_5=eject_ypos_ser_3_0_5;
	assign inject_ypos_ser_3_1_6=eject_yneg_ser_3_2_6;
	assign inject_yneg_ser_3_1_6=eject_ypos_ser_3_0_6;
	assign inject_ypos_ser_3_1_7=eject_yneg_ser_3_2_7;
	assign inject_yneg_ser_3_1_7=eject_ypos_ser_3_0_7;
	assign inject_ypos_ser_3_2_0=eject_yneg_ser_3_3_0;
	assign inject_yneg_ser_3_2_0=eject_ypos_ser_3_1_0;
	assign inject_ypos_ser_3_2_1=eject_yneg_ser_3_3_1;
	assign inject_yneg_ser_3_2_1=eject_ypos_ser_3_1_1;
	assign inject_ypos_ser_3_2_2=eject_yneg_ser_3_3_2;
	assign inject_yneg_ser_3_2_2=eject_ypos_ser_3_1_2;
	assign inject_ypos_ser_3_2_3=eject_yneg_ser_3_3_3;
	assign inject_yneg_ser_3_2_3=eject_ypos_ser_3_1_3;
	assign inject_ypos_ser_3_2_4=eject_yneg_ser_3_3_4;
	assign inject_yneg_ser_3_2_4=eject_ypos_ser_3_1_4;
	assign inject_ypos_ser_3_2_5=eject_yneg_ser_3_3_5;
	assign inject_yneg_ser_3_2_5=eject_ypos_ser_3_1_5;
	assign inject_ypos_ser_3_2_6=eject_yneg_ser_3_3_6;
	assign inject_yneg_ser_3_2_6=eject_ypos_ser_3_1_6;
	assign inject_ypos_ser_3_2_7=eject_yneg_ser_3_3_7;
	assign inject_yneg_ser_3_2_7=eject_ypos_ser_3_1_7;
	assign inject_ypos_ser_3_3_0=eject_yneg_ser_3_4_0;
	assign inject_yneg_ser_3_3_0=eject_ypos_ser_3_2_0;
	assign inject_ypos_ser_3_3_1=eject_yneg_ser_3_4_1;
	assign inject_yneg_ser_3_3_1=eject_ypos_ser_3_2_1;
	assign inject_ypos_ser_3_3_2=eject_yneg_ser_3_4_2;
	assign inject_yneg_ser_3_3_2=eject_ypos_ser_3_2_2;
	assign inject_ypos_ser_3_3_3=eject_yneg_ser_3_4_3;
	assign inject_yneg_ser_3_3_3=eject_ypos_ser_3_2_3;
	assign inject_ypos_ser_3_3_4=eject_yneg_ser_3_4_4;
	assign inject_yneg_ser_3_3_4=eject_ypos_ser_3_2_4;
	assign inject_ypos_ser_3_3_5=eject_yneg_ser_3_4_5;
	assign inject_yneg_ser_3_3_5=eject_ypos_ser_3_2_5;
	assign inject_ypos_ser_3_3_6=eject_yneg_ser_3_4_6;
	assign inject_yneg_ser_3_3_6=eject_ypos_ser_3_2_6;
	assign inject_ypos_ser_3_3_7=eject_yneg_ser_3_4_7;
	assign inject_yneg_ser_3_3_7=eject_ypos_ser_3_2_7;
	assign inject_ypos_ser_3_4_0=eject_yneg_ser_3_5_0;
	assign inject_yneg_ser_3_4_0=eject_ypos_ser_3_3_0;
	assign inject_ypos_ser_3_4_1=eject_yneg_ser_3_5_1;
	assign inject_yneg_ser_3_4_1=eject_ypos_ser_3_3_1;
	assign inject_ypos_ser_3_4_2=eject_yneg_ser_3_5_2;
	assign inject_yneg_ser_3_4_2=eject_ypos_ser_3_3_2;
	assign inject_ypos_ser_3_4_3=eject_yneg_ser_3_5_3;
	assign inject_yneg_ser_3_4_3=eject_ypos_ser_3_3_3;
	assign inject_ypos_ser_3_4_4=eject_yneg_ser_3_5_4;
	assign inject_yneg_ser_3_4_4=eject_ypos_ser_3_3_4;
	assign inject_ypos_ser_3_4_5=eject_yneg_ser_3_5_5;
	assign inject_yneg_ser_3_4_5=eject_ypos_ser_3_3_5;
	assign inject_ypos_ser_3_4_6=eject_yneg_ser_3_5_6;
	assign inject_yneg_ser_3_4_6=eject_ypos_ser_3_3_6;
	assign inject_ypos_ser_3_4_7=eject_yneg_ser_3_5_7;
	assign inject_yneg_ser_3_4_7=eject_ypos_ser_3_3_7;
	assign inject_ypos_ser_3_5_0=eject_yneg_ser_3_6_0;
	assign inject_yneg_ser_3_5_0=eject_ypos_ser_3_4_0;
	assign inject_ypos_ser_3_5_1=eject_yneg_ser_3_6_1;
	assign inject_yneg_ser_3_5_1=eject_ypos_ser_3_4_1;
	assign inject_ypos_ser_3_5_2=eject_yneg_ser_3_6_2;
	assign inject_yneg_ser_3_5_2=eject_ypos_ser_3_4_2;
	assign inject_ypos_ser_3_5_3=eject_yneg_ser_3_6_3;
	assign inject_yneg_ser_3_5_3=eject_ypos_ser_3_4_3;
	assign inject_ypos_ser_3_5_4=eject_yneg_ser_3_6_4;
	assign inject_yneg_ser_3_5_4=eject_ypos_ser_3_4_4;
	assign inject_ypos_ser_3_5_5=eject_yneg_ser_3_6_5;
	assign inject_yneg_ser_3_5_5=eject_ypos_ser_3_4_5;
	assign inject_ypos_ser_3_5_6=eject_yneg_ser_3_6_6;
	assign inject_yneg_ser_3_5_6=eject_ypos_ser_3_4_6;
	assign inject_ypos_ser_3_5_7=eject_yneg_ser_3_6_7;
	assign inject_yneg_ser_3_5_7=eject_ypos_ser_3_4_7;
	assign inject_ypos_ser_3_6_0=eject_yneg_ser_3_7_0;
	assign inject_yneg_ser_3_6_0=eject_ypos_ser_3_5_0;
	assign inject_ypos_ser_3_6_1=eject_yneg_ser_3_7_1;
	assign inject_yneg_ser_3_6_1=eject_ypos_ser_3_5_1;
	assign inject_ypos_ser_3_6_2=eject_yneg_ser_3_7_2;
	assign inject_yneg_ser_3_6_2=eject_ypos_ser_3_5_2;
	assign inject_ypos_ser_3_6_3=eject_yneg_ser_3_7_3;
	assign inject_yneg_ser_3_6_3=eject_ypos_ser_3_5_3;
	assign inject_ypos_ser_3_6_4=eject_yneg_ser_3_7_4;
	assign inject_yneg_ser_3_6_4=eject_ypos_ser_3_5_4;
	assign inject_ypos_ser_3_6_5=eject_yneg_ser_3_7_5;
	assign inject_yneg_ser_3_6_5=eject_ypos_ser_3_5_5;
	assign inject_ypos_ser_3_6_6=eject_yneg_ser_3_7_6;
	assign inject_yneg_ser_3_6_6=eject_ypos_ser_3_5_6;
	assign inject_ypos_ser_3_6_7=eject_yneg_ser_3_7_7;
	assign inject_yneg_ser_3_6_7=eject_ypos_ser_3_5_7;
	assign inject_ypos_ser_3_7_0=eject_yneg_ser_3_0_0;
	assign inject_yneg_ser_3_7_0=eject_ypos_ser_3_6_0;
	assign inject_ypos_ser_3_7_1=eject_yneg_ser_3_0_1;
	assign inject_yneg_ser_3_7_1=eject_ypos_ser_3_6_1;
	assign inject_ypos_ser_3_7_2=eject_yneg_ser_3_0_2;
	assign inject_yneg_ser_3_7_2=eject_ypos_ser_3_6_2;
	assign inject_ypos_ser_3_7_3=eject_yneg_ser_3_0_3;
	assign inject_yneg_ser_3_7_3=eject_ypos_ser_3_6_3;
	assign inject_ypos_ser_3_7_4=eject_yneg_ser_3_0_4;
	assign inject_yneg_ser_3_7_4=eject_ypos_ser_3_6_4;
	assign inject_ypos_ser_3_7_5=eject_yneg_ser_3_0_5;
	assign inject_yneg_ser_3_7_5=eject_ypos_ser_3_6_5;
	assign inject_ypos_ser_3_7_6=eject_yneg_ser_3_0_6;
	assign inject_yneg_ser_3_7_6=eject_ypos_ser_3_6_6;
	assign inject_ypos_ser_3_7_7=eject_yneg_ser_3_0_7;
	assign inject_yneg_ser_3_7_7=eject_ypos_ser_3_6_7;
	assign inject_ypos_ser_4_0_0=eject_yneg_ser_4_1_0;
	assign inject_yneg_ser_4_0_0=eject_ypos_ser_4_7_0;
	assign inject_ypos_ser_4_0_1=eject_yneg_ser_4_1_1;
	assign inject_yneg_ser_4_0_1=eject_ypos_ser_4_7_1;
	assign inject_ypos_ser_4_0_2=eject_yneg_ser_4_1_2;
	assign inject_yneg_ser_4_0_2=eject_ypos_ser_4_7_2;
	assign inject_ypos_ser_4_0_3=eject_yneg_ser_4_1_3;
	assign inject_yneg_ser_4_0_3=eject_ypos_ser_4_7_3;
	assign inject_ypos_ser_4_0_4=eject_yneg_ser_4_1_4;
	assign inject_yneg_ser_4_0_4=eject_ypos_ser_4_7_4;
	assign inject_ypos_ser_4_0_5=eject_yneg_ser_4_1_5;
	assign inject_yneg_ser_4_0_5=eject_ypos_ser_4_7_5;
	assign inject_ypos_ser_4_0_6=eject_yneg_ser_4_1_6;
	assign inject_yneg_ser_4_0_6=eject_ypos_ser_4_7_6;
	assign inject_ypos_ser_4_0_7=eject_yneg_ser_4_1_7;
	assign inject_yneg_ser_4_0_7=eject_ypos_ser_4_7_7;
	assign inject_ypos_ser_4_1_0=eject_yneg_ser_4_2_0;
	assign inject_yneg_ser_4_1_0=eject_ypos_ser_4_0_0;
	assign inject_ypos_ser_4_1_1=eject_yneg_ser_4_2_1;
	assign inject_yneg_ser_4_1_1=eject_ypos_ser_4_0_1;
	assign inject_ypos_ser_4_1_2=eject_yneg_ser_4_2_2;
	assign inject_yneg_ser_4_1_2=eject_ypos_ser_4_0_2;
	assign inject_ypos_ser_4_1_3=eject_yneg_ser_4_2_3;
	assign inject_yneg_ser_4_1_3=eject_ypos_ser_4_0_3;
	assign inject_ypos_ser_4_1_4=eject_yneg_ser_4_2_4;
	assign inject_yneg_ser_4_1_4=eject_ypos_ser_4_0_4;
	assign inject_ypos_ser_4_1_5=eject_yneg_ser_4_2_5;
	assign inject_yneg_ser_4_1_5=eject_ypos_ser_4_0_5;
	assign inject_ypos_ser_4_1_6=eject_yneg_ser_4_2_6;
	assign inject_yneg_ser_4_1_6=eject_ypos_ser_4_0_6;
	assign inject_ypos_ser_4_1_7=eject_yneg_ser_4_2_7;
	assign inject_yneg_ser_4_1_7=eject_ypos_ser_4_0_7;
	assign inject_ypos_ser_4_2_0=eject_yneg_ser_4_3_0;
	assign inject_yneg_ser_4_2_0=eject_ypos_ser_4_1_0;
	assign inject_ypos_ser_4_2_1=eject_yneg_ser_4_3_1;
	assign inject_yneg_ser_4_2_1=eject_ypos_ser_4_1_1;
	assign inject_ypos_ser_4_2_2=eject_yneg_ser_4_3_2;
	assign inject_yneg_ser_4_2_2=eject_ypos_ser_4_1_2;
	assign inject_ypos_ser_4_2_3=eject_yneg_ser_4_3_3;
	assign inject_yneg_ser_4_2_3=eject_ypos_ser_4_1_3;
	assign inject_ypos_ser_4_2_4=eject_yneg_ser_4_3_4;
	assign inject_yneg_ser_4_2_4=eject_ypos_ser_4_1_4;
	assign inject_ypos_ser_4_2_5=eject_yneg_ser_4_3_5;
	assign inject_yneg_ser_4_2_5=eject_ypos_ser_4_1_5;
	assign inject_ypos_ser_4_2_6=eject_yneg_ser_4_3_6;
	assign inject_yneg_ser_4_2_6=eject_ypos_ser_4_1_6;
	assign inject_ypos_ser_4_2_7=eject_yneg_ser_4_3_7;
	assign inject_yneg_ser_4_2_7=eject_ypos_ser_4_1_7;
	assign inject_ypos_ser_4_3_0=eject_yneg_ser_4_4_0;
	assign inject_yneg_ser_4_3_0=eject_ypos_ser_4_2_0;
	assign inject_ypos_ser_4_3_1=eject_yneg_ser_4_4_1;
	assign inject_yneg_ser_4_3_1=eject_ypos_ser_4_2_1;
	assign inject_ypos_ser_4_3_2=eject_yneg_ser_4_4_2;
	assign inject_yneg_ser_4_3_2=eject_ypos_ser_4_2_2;
	assign inject_ypos_ser_4_3_3=eject_yneg_ser_4_4_3;
	assign inject_yneg_ser_4_3_3=eject_ypos_ser_4_2_3;
	assign inject_ypos_ser_4_3_4=eject_yneg_ser_4_4_4;
	assign inject_yneg_ser_4_3_4=eject_ypos_ser_4_2_4;
	assign inject_ypos_ser_4_3_5=eject_yneg_ser_4_4_5;
	assign inject_yneg_ser_4_3_5=eject_ypos_ser_4_2_5;
	assign inject_ypos_ser_4_3_6=eject_yneg_ser_4_4_6;
	assign inject_yneg_ser_4_3_6=eject_ypos_ser_4_2_6;
	assign inject_ypos_ser_4_3_7=eject_yneg_ser_4_4_7;
	assign inject_yneg_ser_4_3_7=eject_ypos_ser_4_2_7;
	assign inject_ypos_ser_4_4_0=eject_yneg_ser_4_5_0;
	assign inject_yneg_ser_4_4_0=eject_ypos_ser_4_3_0;
	assign inject_ypos_ser_4_4_1=eject_yneg_ser_4_5_1;
	assign inject_yneg_ser_4_4_1=eject_ypos_ser_4_3_1;
	assign inject_ypos_ser_4_4_2=eject_yneg_ser_4_5_2;
	assign inject_yneg_ser_4_4_2=eject_ypos_ser_4_3_2;
	assign inject_ypos_ser_4_4_3=eject_yneg_ser_4_5_3;
	assign inject_yneg_ser_4_4_3=eject_ypos_ser_4_3_3;
	assign inject_ypos_ser_4_4_4=eject_yneg_ser_4_5_4;
	assign inject_yneg_ser_4_4_4=eject_ypos_ser_4_3_4;
	assign inject_ypos_ser_4_4_5=eject_yneg_ser_4_5_5;
	assign inject_yneg_ser_4_4_5=eject_ypos_ser_4_3_5;
	assign inject_ypos_ser_4_4_6=eject_yneg_ser_4_5_6;
	assign inject_yneg_ser_4_4_6=eject_ypos_ser_4_3_6;
	assign inject_ypos_ser_4_4_7=eject_yneg_ser_4_5_7;
	assign inject_yneg_ser_4_4_7=eject_ypos_ser_4_3_7;
	assign inject_ypos_ser_4_5_0=eject_yneg_ser_4_6_0;
	assign inject_yneg_ser_4_5_0=eject_ypos_ser_4_4_0;
	assign inject_ypos_ser_4_5_1=eject_yneg_ser_4_6_1;
	assign inject_yneg_ser_4_5_1=eject_ypos_ser_4_4_1;
	assign inject_ypos_ser_4_5_2=eject_yneg_ser_4_6_2;
	assign inject_yneg_ser_4_5_2=eject_ypos_ser_4_4_2;
	assign inject_ypos_ser_4_5_3=eject_yneg_ser_4_6_3;
	assign inject_yneg_ser_4_5_3=eject_ypos_ser_4_4_3;
	assign inject_ypos_ser_4_5_4=eject_yneg_ser_4_6_4;
	assign inject_yneg_ser_4_5_4=eject_ypos_ser_4_4_4;
	assign inject_ypos_ser_4_5_5=eject_yneg_ser_4_6_5;
	assign inject_yneg_ser_4_5_5=eject_ypos_ser_4_4_5;
	assign inject_ypos_ser_4_5_6=eject_yneg_ser_4_6_6;
	assign inject_yneg_ser_4_5_6=eject_ypos_ser_4_4_6;
	assign inject_ypos_ser_4_5_7=eject_yneg_ser_4_6_7;
	assign inject_yneg_ser_4_5_7=eject_ypos_ser_4_4_7;
	assign inject_ypos_ser_4_6_0=eject_yneg_ser_4_7_0;
	assign inject_yneg_ser_4_6_0=eject_ypos_ser_4_5_0;
	assign inject_ypos_ser_4_6_1=eject_yneg_ser_4_7_1;
	assign inject_yneg_ser_4_6_1=eject_ypos_ser_4_5_1;
	assign inject_ypos_ser_4_6_2=eject_yneg_ser_4_7_2;
	assign inject_yneg_ser_4_6_2=eject_ypos_ser_4_5_2;
	assign inject_ypos_ser_4_6_3=eject_yneg_ser_4_7_3;
	assign inject_yneg_ser_4_6_3=eject_ypos_ser_4_5_3;
	assign inject_ypos_ser_4_6_4=eject_yneg_ser_4_7_4;
	assign inject_yneg_ser_4_6_4=eject_ypos_ser_4_5_4;
	assign inject_ypos_ser_4_6_5=eject_yneg_ser_4_7_5;
	assign inject_yneg_ser_4_6_5=eject_ypos_ser_4_5_5;
	assign inject_ypos_ser_4_6_6=eject_yneg_ser_4_7_6;
	assign inject_yneg_ser_4_6_6=eject_ypos_ser_4_5_6;
	assign inject_ypos_ser_4_6_7=eject_yneg_ser_4_7_7;
	assign inject_yneg_ser_4_6_7=eject_ypos_ser_4_5_7;
	assign inject_ypos_ser_4_7_0=eject_yneg_ser_4_0_0;
	assign inject_yneg_ser_4_7_0=eject_ypos_ser_4_6_0;
	assign inject_ypos_ser_4_7_1=eject_yneg_ser_4_0_1;
	assign inject_yneg_ser_4_7_1=eject_ypos_ser_4_6_1;
	assign inject_ypos_ser_4_7_2=eject_yneg_ser_4_0_2;
	assign inject_yneg_ser_4_7_2=eject_ypos_ser_4_6_2;
	assign inject_ypos_ser_4_7_3=eject_yneg_ser_4_0_3;
	assign inject_yneg_ser_4_7_3=eject_ypos_ser_4_6_3;
	assign inject_ypos_ser_4_7_4=eject_yneg_ser_4_0_4;
	assign inject_yneg_ser_4_7_4=eject_ypos_ser_4_6_4;
	assign inject_ypos_ser_4_7_5=eject_yneg_ser_4_0_5;
	assign inject_yneg_ser_4_7_5=eject_ypos_ser_4_6_5;
	assign inject_ypos_ser_4_7_6=eject_yneg_ser_4_0_6;
	assign inject_yneg_ser_4_7_6=eject_ypos_ser_4_6_6;
	assign inject_ypos_ser_4_7_7=eject_yneg_ser_4_0_7;
	assign inject_yneg_ser_4_7_7=eject_ypos_ser_4_6_7;
	assign inject_ypos_ser_5_0_0=eject_yneg_ser_5_1_0;
	assign inject_yneg_ser_5_0_0=eject_ypos_ser_5_7_0;
	assign inject_ypos_ser_5_0_1=eject_yneg_ser_5_1_1;
	assign inject_yneg_ser_5_0_1=eject_ypos_ser_5_7_1;
	assign inject_ypos_ser_5_0_2=eject_yneg_ser_5_1_2;
	assign inject_yneg_ser_5_0_2=eject_ypos_ser_5_7_2;
	assign inject_ypos_ser_5_0_3=eject_yneg_ser_5_1_3;
	assign inject_yneg_ser_5_0_3=eject_ypos_ser_5_7_3;
	assign inject_ypos_ser_5_0_4=eject_yneg_ser_5_1_4;
	assign inject_yneg_ser_5_0_4=eject_ypos_ser_5_7_4;
	assign inject_ypos_ser_5_0_5=eject_yneg_ser_5_1_5;
	assign inject_yneg_ser_5_0_5=eject_ypos_ser_5_7_5;
	assign inject_ypos_ser_5_0_6=eject_yneg_ser_5_1_6;
	assign inject_yneg_ser_5_0_6=eject_ypos_ser_5_7_6;
	assign inject_ypos_ser_5_0_7=eject_yneg_ser_5_1_7;
	assign inject_yneg_ser_5_0_7=eject_ypos_ser_5_7_7;
	assign inject_ypos_ser_5_1_0=eject_yneg_ser_5_2_0;
	assign inject_yneg_ser_5_1_0=eject_ypos_ser_5_0_0;
	assign inject_ypos_ser_5_1_1=eject_yneg_ser_5_2_1;
	assign inject_yneg_ser_5_1_1=eject_ypos_ser_5_0_1;
	assign inject_ypos_ser_5_1_2=eject_yneg_ser_5_2_2;
	assign inject_yneg_ser_5_1_2=eject_ypos_ser_5_0_2;
	assign inject_ypos_ser_5_1_3=eject_yneg_ser_5_2_3;
	assign inject_yneg_ser_5_1_3=eject_ypos_ser_5_0_3;
	assign inject_ypos_ser_5_1_4=eject_yneg_ser_5_2_4;
	assign inject_yneg_ser_5_1_4=eject_ypos_ser_5_0_4;
	assign inject_ypos_ser_5_1_5=eject_yneg_ser_5_2_5;
	assign inject_yneg_ser_5_1_5=eject_ypos_ser_5_0_5;
	assign inject_ypos_ser_5_1_6=eject_yneg_ser_5_2_6;
	assign inject_yneg_ser_5_1_6=eject_ypos_ser_5_0_6;
	assign inject_ypos_ser_5_1_7=eject_yneg_ser_5_2_7;
	assign inject_yneg_ser_5_1_7=eject_ypos_ser_5_0_7;
	assign inject_ypos_ser_5_2_0=eject_yneg_ser_5_3_0;
	assign inject_yneg_ser_5_2_0=eject_ypos_ser_5_1_0;
	assign inject_ypos_ser_5_2_1=eject_yneg_ser_5_3_1;
	assign inject_yneg_ser_5_2_1=eject_ypos_ser_5_1_1;
	assign inject_ypos_ser_5_2_2=eject_yneg_ser_5_3_2;
	assign inject_yneg_ser_5_2_2=eject_ypos_ser_5_1_2;
	assign inject_ypos_ser_5_2_3=eject_yneg_ser_5_3_3;
	assign inject_yneg_ser_5_2_3=eject_ypos_ser_5_1_3;
	assign inject_ypos_ser_5_2_4=eject_yneg_ser_5_3_4;
	assign inject_yneg_ser_5_2_4=eject_ypos_ser_5_1_4;
	assign inject_ypos_ser_5_2_5=eject_yneg_ser_5_3_5;
	assign inject_yneg_ser_5_2_5=eject_ypos_ser_5_1_5;
	assign inject_ypos_ser_5_2_6=eject_yneg_ser_5_3_6;
	assign inject_yneg_ser_5_2_6=eject_ypos_ser_5_1_6;
	assign inject_ypos_ser_5_2_7=eject_yneg_ser_5_3_7;
	assign inject_yneg_ser_5_2_7=eject_ypos_ser_5_1_7;
	assign inject_ypos_ser_5_3_0=eject_yneg_ser_5_4_0;
	assign inject_yneg_ser_5_3_0=eject_ypos_ser_5_2_0;
	assign inject_ypos_ser_5_3_1=eject_yneg_ser_5_4_1;
	assign inject_yneg_ser_5_3_1=eject_ypos_ser_5_2_1;
	assign inject_ypos_ser_5_3_2=eject_yneg_ser_5_4_2;
	assign inject_yneg_ser_5_3_2=eject_ypos_ser_5_2_2;
	assign inject_ypos_ser_5_3_3=eject_yneg_ser_5_4_3;
	assign inject_yneg_ser_5_3_3=eject_ypos_ser_5_2_3;
	assign inject_ypos_ser_5_3_4=eject_yneg_ser_5_4_4;
	assign inject_yneg_ser_5_3_4=eject_ypos_ser_5_2_4;
	assign inject_ypos_ser_5_3_5=eject_yneg_ser_5_4_5;
	assign inject_yneg_ser_5_3_5=eject_ypos_ser_5_2_5;
	assign inject_ypos_ser_5_3_6=eject_yneg_ser_5_4_6;
	assign inject_yneg_ser_5_3_6=eject_ypos_ser_5_2_6;
	assign inject_ypos_ser_5_3_7=eject_yneg_ser_5_4_7;
	assign inject_yneg_ser_5_3_7=eject_ypos_ser_5_2_7;
	assign inject_ypos_ser_5_4_0=eject_yneg_ser_5_5_0;
	assign inject_yneg_ser_5_4_0=eject_ypos_ser_5_3_0;
	assign inject_ypos_ser_5_4_1=eject_yneg_ser_5_5_1;
	assign inject_yneg_ser_5_4_1=eject_ypos_ser_5_3_1;
	assign inject_ypos_ser_5_4_2=eject_yneg_ser_5_5_2;
	assign inject_yneg_ser_5_4_2=eject_ypos_ser_5_3_2;
	assign inject_ypos_ser_5_4_3=eject_yneg_ser_5_5_3;
	assign inject_yneg_ser_5_4_3=eject_ypos_ser_5_3_3;
	assign inject_ypos_ser_5_4_4=eject_yneg_ser_5_5_4;
	assign inject_yneg_ser_5_4_4=eject_ypos_ser_5_3_4;
	assign inject_ypos_ser_5_4_5=eject_yneg_ser_5_5_5;
	assign inject_yneg_ser_5_4_5=eject_ypos_ser_5_3_5;
	assign inject_ypos_ser_5_4_6=eject_yneg_ser_5_5_6;
	assign inject_yneg_ser_5_4_6=eject_ypos_ser_5_3_6;
	assign inject_ypos_ser_5_4_7=eject_yneg_ser_5_5_7;
	assign inject_yneg_ser_5_4_7=eject_ypos_ser_5_3_7;
	assign inject_ypos_ser_5_5_0=eject_yneg_ser_5_6_0;
	assign inject_yneg_ser_5_5_0=eject_ypos_ser_5_4_0;
	assign inject_ypos_ser_5_5_1=eject_yneg_ser_5_6_1;
	assign inject_yneg_ser_5_5_1=eject_ypos_ser_5_4_1;
	assign inject_ypos_ser_5_5_2=eject_yneg_ser_5_6_2;
	assign inject_yneg_ser_5_5_2=eject_ypos_ser_5_4_2;
	assign inject_ypos_ser_5_5_3=eject_yneg_ser_5_6_3;
	assign inject_yneg_ser_5_5_3=eject_ypos_ser_5_4_3;
	assign inject_ypos_ser_5_5_4=eject_yneg_ser_5_6_4;
	assign inject_yneg_ser_5_5_4=eject_ypos_ser_5_4_4;
	assign inject_ypos_ser_5_5_5=eject_yneg_ser_5_6_5;
	assign inject_yneg_ser_5_5_5=eject_ypos_ser_5_4_5;
	assign inject_ypos_ser_5_5_6=eject_yneg_ser_5_6_6;
	assign inject_yneg_ser_5_5_6=eject_ypos_ser_5_4_6;
	assign inject_ypos_ser_5_5_7=eject_yneg_ser_5_6_7;
	assign inject_yneg_ser_5_5_7=eject_ypos_ser_5_4_7;
	assign inject_ypos_ser_5_6_0=eject_yneg_ser_5_7_0;
	assign inject_yneg_ser_5_6_0=eject_ypos_ser_5_5_0;
	assign inject_ypos_ser_5_6_1=eject_yneg_ser_5_7_1;
	assign inject_yneg_ser_5_6_1=eject_ypos_ser_5_5_1;
	assign inject_ypos_ser_5_6_2=eject_yneg_ser_5_7_2;
	assign inject_yneg_ser_5_6_2=eject_ypos_ser_5_5_2;
	assign inject_ypos_ser_5_6_3=eject_yneg_ser_5_7_3;
	assign inject_yneg_ser_5_6_3=eject_ypos_ser_5_5_3;
	assign inject_ypos_ser_5_6_4=eject_yneg_ser_5_7_4;
	assign inject_yneg_ser_5_6_4=eject_ypos_ser_5_5_4;
	assign inject_ypos_ser_5_6_5=eject_yneg_ser_5_7_5;
	assign inject_yneg_ser_5_6_5=eject_ypos_ser_5_5_5;
	assign inject_ypos_ser_5_6_6=eject_yneg_ser_5_7_6;
	assign inject_yneg_ser_5_6_6=eject_ypos_ser_5_5_6;
	assign inject_ypos_ser_5_6_7=eject_yneg_ser_5_7_7;
	assign inject_yneg_ser_5_6_7=eject_ypos_ser_5_5_7;
	assign inject_ypos_ser_5_7_0=eject_yneg_ser_5_0_0;
	assign inject_yneg_ser_5_7_0=eject_ypos_ser_5_6_0;
	assign inject_ypos_ser_5_7_1=eject_yneg_ser_5_0_1;
	assign inject_yneg_ser_5_7_1=eject_ypos_ser_5_6_1;
	assign inject_ypos_ser_5_7_2=eject_yneg_ser_5_0_2;
	assign inject_yneg_ser_5_7_2=eject_ypos_ser_5_6_2;
	assign inject_ypos_ser_5_7_3=eject_yneg_ser_5_0_3;
	assign inject_yneg_ser_5_7_3=eject_ypos_ser_5_6_3;
	assign inject_ypos_ser_5_7_4=eject_yneg_ser_5_0_4;
	assign inject_yneg_ser_5_7_4=eject_ypos_ser_5_6_4;
	assign inject_ypos_ser_5_7_5=eject_yneg_ser_5_0_5;
	assign inject_yneg_ser_5_7_5=eject_ypos_ser_5_6_5;
	assign inject_ypos_ser_5_7_6=eject_yneg_ser_5_0_6;
	assign inject_yneg_ser_5_7_6=eject_ypos_ser_5_6_6;
	assign inject_ypos_ser_5_7_7=eject_yneg_ser_5_0_7;
	assign inject_yneg_ser_5_7_7=eject_ypos_ser_5_6_7;
	assign inject_ypos_ser_6_0_0=eject_yneg_ser_6_1_0;
	assign inject_yneg_ser_6_0_0=eject_ypos_ser_6_7_0;
	assign inject_ypos_ser_6_0_1=eject_yneg_ser_6_1_1;
	assign inject_yneg_ser_6_0_1=eject_ypos_ser_6_7_1;
	assign inject_ypos_ser_6_0_2=eject_yneg_ser_6_1_2;
	assign inject_yneg_ser_6_0_2=eject_ypos_ser_6_7_2;
	assign inject_ypos_ser_6_0_3=eject_yneg_ser_6_1_3;
	assign inject_yneg_ser_6_0_3=eject_ypos_ser_6_7_3;
	assign inject_ypos_ser_6_0_4=eject_yneg_ser_6_1_4;
	assign inject_yneg_ser_6_0_4=eject_ypos_ser_6_7_4;
	assign inject_ypos_ser_6_0_5=eject_yneg_ser_6_1_5;
	assign inject_yneg_ser_6_0_5=eject_ypos_ser_6_7_5;
	assign inject_ypos_ser_6_0_6=eject_yneg_ser_6_1_6;
	assign inject_yneg_ser_6_0_6=eject_ypos_ser_6_7_6;
	assign inject_ypos_ser_6_0_7=eject_yneg_ser_6_1_7;
	assign inject_yneg_ser_6_0_7=eject_ypos_ser_6_7_7;
	assign inject_ypos_ser_6_1_0=eject_yneg_ser_6_2_0;
	assign inject_yneg_ser_6_1_0=eject_ypos_ser_6_0_0;
	assign inject_ypos_ser_6_1_1=eject_yneg_ser_6_2_1;
	assign inject_yneg_ser_6_1_1=eject_ypos_ser_6_0_1;
	assign inject_ypos_ser_6_1_2=eject_yneg_ser_6_2_2;
	assign inject_yneg_ser_6_1_2=eject_ypos_ser_6_0_2;
	assign inject_ypos_ser_6_1_3=eject_yneg_ser_6_2_3;
	assign inject_yneg_ser_6_1_3=eject_ypos_ser_6_0_3;
	assign inject_ypos_ser_6_1_4=eject_yneg_ser_6_2_4;
	assign inject_yneg_ser_6_1_4=eject_ypos_ser_6_0_4;
	assign inject_ypos_ser_6_1_5=eject_yneg_ser_6_2_5;
	assign inject_yneg_ser_6_1_5=eject_ypos_ser_6_0_5;
	assign inject_ypos_ser_6_1_6=eject_yneg_ser_6_2_6;
	assign inject_yneg_ser_6_1_6=eject_ypos_ser_6_0_6;
	assign inject_ypos_ser_6_1_7=eject_yneg_ser_6_2_7;
	assign inject_yneg_ser_6_1_7=eject_ypos_ser_6_0_7;
	assign inject_ypos_ser_6_2_0=eject_yneg_ser_6_3_0;
	assign inject_yneg_ser_6_2_0=eject_ypos_ser_6_1_0;
	assign inject_ypos_ser_6_2_1=eject_yneg_ser_6_3_1;
	assign inject_yneg_ser_6_2_1=eject_ypos_ser_6_1_1;
	assign inject_ypos_ser_6_2_2=eject_yneg_ser_6_3_2;
	assign inject_yneg_ser_6_2_2=eject_ypos_ser_6_1_2;
	assign inject_ypos_ser_6_2_3=eject_yneg_ser_6_3_3;
	assign inject_yneg_ser_6_2_3=eject_ypos_ser_6_1_3;
	assign inject_ypos_ser_6_2_4=eject_yneg_ser_6_3_4;
	assign inject_yneg_ser_6_2_4=eject_ypos_ser_6_1_4;
	assign inject_ypos_ser_6_2_5=eject_yneg_ser_6_3_5;
	assign inject_yneg_ser_6_2_5=eject_ypos_ser_6_1_5;
	assign inject_ypos_ser_6_2_6=eject_yneg_ser_6_3_6;
	assign inject_yneg_ser_6_2_6=eject_ypos_ser_6_1_6;
	assign inject_ypos_ser_6_2_7=eject_yneg_ser_6_3_7;
	assign inject_yneg_ser_6_2_7=eject_ypos_ser_6_1_7;
	assign inject_ypos_ser_6_3_0=eject_yneg_ser_6_4_0;
	assign inject_yneg_ser_6_3_0=eject_ypos_ser_6_2_0;
	assign inject_ypos_ser_6_3_1=eject_yneg_ser_6_4_1;
	assign inject_yneg_ser_6_3_1=eject_ypos_ser_6_2_1;
	assign inject_ypos_ser_6_3_2=eject_yneg_ser_6_4_2;
	assign inject_yneg_ser_6_3_2=eject_ypos_ser_6_2_2;
	assign inject_ypos_ser_6_3_3=eject_yneg_ser_6_4_3;
	assign inject_yneg_ser_6_3_3=eject_ypos_ser_6_2_3;
	assign inject_ypos_ser_6_3_4=eject_yneg_ser_6_4_4;
	assign inject_yneg_ser_6_3_4=eject_ypos_ser_6_2_4;
	assign inject_ypos_ser_6_3_5=eject_yneg_ser_6_4_5;
	assign inject_yneg_ser_6_3_5=eject_ypos_ser_6_2_5;
	assign inject_ypos_ser_6_3_6=eject_yneg_ser_6_4_6;
	assign inject_yneg_ser_6_3_6=eject_ypos_ser_6_2_6;
	assign inject_ypos_ser_6_3_7=eject_yneg_ser_6_4_7;
	assign inject_yneg_ser_6_3_7=eject_ypos_ser_6_2_7;
	assign inject_ypos_ser_6_4_0=eject_yneg_ser_6_5_0;
	assign inject_yneg_ser_6_4_0=eject_ypos_ser_6_3_0;
	assign inject_ypos_ser_6_4_1=eject_yneg_ser_6_5_1;
	assign inject_yneg_ser_6_4_1=eject_ypos_ser_6_3_1;
	assign inject_ypos_ser_6_4_2=eject_yneg_ser_6_5_2;
	assign inject_yneg_ser_6_4_2=eject_ypos_ser_6_3_2;
	assign inject_ypos_ser_6_4_3=eject_yneg_ser_6_5_3;
	assign inject_yneg_ser_6_4_3=eject_ypos_ser_6_3_3;
	assign inject_ypos_ser_6_4_4=eject_yneg_ser_6_5_4;
	assign inject_yneg_ser_6_4_4=eject_ypos_ser_6_3_4;
	assign inject_ypos_ser_6_4_5=eject_yneg_ser_6_5_5;
	assign inject_yneg_ser_6_4_5=eject_ypos_ser_6_3_5;
	assign inject_ypos_ser_6_4_6=eject_yneg_ser_6_5_6;
	assign inject_yneg_ser_6_4_6=eject_ypos_ser_6_3_6;
	assign inject_ypos_ser_6_4_7=eject_yneg_ser_6_5_7;
	assign inject_yneg_ser_6_4_7=eject_ypos_ser_6_3_7;
	assign inject_ypos_ser_6_5_0=eject_yneg_ser_6_6_0;
	assign inject_yneg_ser_6_5_0=eject_ypos_ser_6_4_0;
	assign inject_ypos_ser_6_5_1=eject_yneg_ser_6_6_1;
	assign inject_yneg_ser_6_5_1=eject_ypos_ser_6_4_1;
	assign inject_ypos_ser_6_5_2=eject_yneg_ser_6_6_2;
	assign inject_yneg_ser_6_5_2=eject_ypos_ser_6_4_2;
	assign inject_ypos_ser_6_5_3=eject_yneg_ser_6_6_3;
	assign inject_yneg_ser_6_5_3=eject_ypos_ser_6_4_3;
	assign inject_ypos_ser_6_5_4=eject_yneg_ser_6_6_4;
	assign inject_yneg_ser_6_5_4=eject_ypos_ser_6_4_4;
	assign inject_ypos_ser_6_5_5=eject_yneg_ser_6_6_5;
	assign inject_yneg_ser_6_5_5=eject_ypos_ser_6_4_5;
	assign inject_ypos_ser_6_5_6=eject_yneg_ser_6_6_6;
	assign inject_yneg_ser_6_5_6=eject_ypos_ser_6_4_6;
	assign inject_ypos_ser_6_5_7=eject_yneg_ser_6_6_7;
	assign inject_yneg_ser_6_5_7=eject_ypos_ser_6_4_7;
	assign inject_ypos_ser_6_6_0=eject_yneg_ser_6_7_0;
	assign inject_yneg_ser_6_6_0=eject_ypos_ser_6_5_0;
	assign inject_ypos_ser_6_6_1=eject_yneg_ser_6_7_1;
	assign inject_yneg_ser_6_6_1=eject_ypos_ser_6_5_1;
	assign inject_ypos_ser_6_6_2=eject_yneg_ser_6_7_2;
	assign inject_yneg_ser_6_6_2=eject_ypos_ser_6_5_2;
	assign inject_ypos_ser_6_6_3=eject_yneg_ser_6_7_3;
	assign inject_yneg_ser_6_6_3=eject_ypos_ser_6_5_3;
	assign inject_ypos_ser_6_6_4=eject_yneg_ser_6_7_4;
	assign inject_yneg_ser_6_6_4=eject_ypos_ser_6_5_4;
	assign inject_ypos_ser_6_6_5=eject_yneg_ser_6_7_5;
	assign inject_yneg_ser_6_6_5=eject_ypos_ser_6_5_5;
	assign inject_ypos_ser_6_6_6=eject_yneg_ser_6_7_6;
	assign inject_yneg_ser_6_6_6=eject_ypos_ser_6_5_6;
	assign inject_ypos_ser_6_6_7=eject_yneg_ser_6_7_7;
	assign inject_yneg_ser_6_6_7=eject_ypos_ser_6_5_7;
	assign inject_ypos_ser_6_7_0=eject_yneg_ser_6_0_0;
	assign inject_yneg_ser_6_7_0=eject_ypos_ser_6_6_0;
	assign inject_ypos_ser_6_7_1=eject_yneg_ser_6_0_1;
	assign inject_yneg_ser_6_7_1=eject_ypos_ser_6_6_1;
	assign inject_ypos_ser_6_7_2=eject_yneg_ser_6_0_2;
	assign inject_yneg_ser_6_7_2=eject_ypos_ser_6_6_2;
	assign inject_ypos_ser_6_7_3=eject_yneg_ser_6_0_3;
	assign inject_yneg_ser_6_7_3=eject_ypos_ser_6_6_3;
	assign inject_ypos_ser_6_7_4=eject_yneg_ser_6_0_4;
	assign inject_yneg_ser_6_7_4=eject_ypos_ser_6_6_4;
	assign inject_ypos_ser_6_7_5=eject_yneg_ser_6_0_5;
	assign inject_yneg_ser_6_7_5=eject_ypos_ser_6_6_5;
	assign inject_ypos_ser_6_7_6=eject_yneg_ser_6_0_6;
	assign inject_yneg_ser_6_7_6=eject_ypos_ser_6_6_6;
	assign inject_ypos_ser_6_7_7=eject_yneg_ser_6_0_7;
	assign inject_yneg_ser_6_7_7=eject_ypos_ser_6_6_7;
	assign inject_ypos_ser_7_0_0=eject_yneg_ser_7_1_0;
	assign inject_yneg_ser_7_0_0=eject_ypos_ser_7_7_0;
	assign inject_ypos_ser_7_0_1=eject_yneg_ser_7_1_1;
	assign inject_yneg_ser_7_0_1=eject_ypos_ser_7_7_1;
	assign inject_ypos_ser_7_0_2=eject_yneg_ser_7_1_2;
	assign inject_yneg_ser_7_0_2=eject_ypos_ser_7_7_2;
	assign inject_ypos_ser_7_0_3=eject_yneg_ser_7_1_3;
	assign inject_yneg_ser_7_0_3=eject_ypos_ser_7_7_3;
	assign inject_ypos_ser_7_0_4=eject_yneg_ser_7_1_4;
	assign inject_yneg_ser_7_0_4=eject_ypos_ser_7_7_4;
	assign inject_ypos_ser_7_0_5=eject_yneg_ser_7_1_5;
	assign inject_yneg_ser_7_0_5=eject_ypos_ser_7_7_5;
	assign inject_ypos_ser_7_0_6=eject_yneg_ser_7_1_6;
	assign inject_yneg_ser_7_0_6=eject_ypos_ser_7_7_6;
	assign inject_ypos_ser_7_0_7=eject_yneg_ser_7_1_7;
	assign inject_yneg_ser_7_0_7=eject_ypos_ser_7_7_7;
	assign inject_ypos_ser_7_1_0=eject_yneg_ser_7_2_0;
	assign inject_yneg_ser_7_1_0=eject_ypos_ser_7_0_0;
	assign inject_ypos_ser_7_1_1=eject_yneg_ser_7_2_1;
	assign inject_yneg_ser_7_1_1=eject_ypos_ser_7_0_1;
	assign inject_ypos_ser_7_1_2=eject_yneg_ser_7_2_2;
	assign inject_yneg_ser_7_1_2=eject_ypos_ser_7_0_2;
	assign inject_ypos_ser_7_1_3=eject_yneg_ser_7_2_3;
	assign inject_yneg_ser_7_1_3=eject_ypos_ser_7_0_3;
	assign inject_ypos_ser_7_1_4=eject_yneg_ser_7_2_4;
	assign inject_yneg_ser_7_1_4=eject_ypos_ser_7_0_4;
	assign inject_ypos_ser_7_1_5=eject_yneg_ser_7_2_5;
	assign inject_yneg_ser_7_1_5=eject_ypos_ser_7_0_5;
	assign inject_ypos_ser_7_1_6=eject_yneg_ser_7_2_6;
	assign inject_yneg_ser_7_1_6=eject_ypos_ser_7_0_6;
	assign inject_ypos_ser_7_1_7=eject_yneg_ser_7_2_7;
	assign inject_yneg_ser_7_1_7=eject_ypos_ser_7_0_7;
	assign inject_ypos_ser_7_2_0=eject_yneg_ser_7_3_0;
	assign inject_yneg_ser_7_2_0=eject_ypos_ser_7_1_0;
	assign inject_ypos_ser_7_2_1=eject_yneg_ser_7_3_1;
	assign inject_yneg_ser_7_2_1=eject_ypos_ser_7_1_1;
	assign inject_ypos_ser_7_2_2=eject_yneg_ser_7_3_2;
	assign inject_yneg_ser_7_2_2=eject_ypos_ser_7_1_2;
	assign inject_ypos_ser_7_2_3=eject_yneg_ser_7_3_3;
	assign inject_yneg_ser_7_2_3=eject_ypos_ser_7_1_3;
	assign inject_ypos_ser_7_2_4=eject_yneg_ser_7_3_4;
	assign inject_yneg_ser_7_2_4=eject_ypos_ser_7_1_4;
	assign inject_ypos_ser_7_2_5=eject_yneg_ser_7_3_5;
	assign inject_yneg_ser_7_2_5=eject_ypos_ser_7_1_5;
	assign inject_ypos_ser_7_2_6=eject_yneg_ser_7_3_6;
	assign inject_yneg_ser_7_2_6=eject_ypos_ser_7_1_6;
	assign inject_ypos_ser_7_2_7=eject_yneg_ser_7_3_7;
	assign inject_yneg_ser_7_2_7=eject_ypos_ser_7_1_7;
	assign inject_ypos_ser_7_3_0=eject_yneg_ser_7_4_0;
	assign inject_yneg_ser_7_3_0=eject_ypos_ser_7_2_0;
	assign inject_ypos_ser_7_3_1=eject_yneg_ser_7_4_1;
	assign inject_yneg_ser_7_3_1=eject_ypos_ser_7_2_1;
	assign inject_ypos_ser_7_3_2=eject_yneg_ser_7_4_2;
	assign inject_yneg_ser_7_3_2=eject_ypos_ser_7_2_2;
	assign inject_ypos_ser_7_3_3=eject_yneg_ser_7_4_3;
	assign inject_yneg_ser_7_3_3=eject_ypos_ser_7_2_3;
	assign inject_ypos_ser_7_3_4=eject_yneg_ser_7_4_4;
	assign inject_yneg_ser_7_3_4=eject_ypos_ser_7_2_4;
	assign inject_ypos_ser_7_3_5=eject_yneg_ser_7_4_5;
	assign inject_yneg_ser_7_3_5=eject_ypos_ser_7_2_5;
	assign inject_ypos_ser_7_3_6=eject_yneg_ser_7_4_6;
	assign inject_yneg_ser_7_3_6=eject_ypos_ser_7_2_6;
	assign inject_ypos_ser_7_3_7=eject_yneg_ser_7_4_7;
	assign inject_yneg_ser_7_3_7=eject_ypos_ser_7_2_7;
	assign inject_ypos_ser_7_4_0=eject_yneg_ser_7_5_0;
	assign inject_yneg_ser_7_4_0=eject_ypos_ser_7_3_0;
	assign inject_ypos_ser_7_4_1=eject_yneg_ser_7_5_1;
	assign inject_yneg_ser_7_4_1=eject_ypos_ser_7_3_1;
	assign inject_ypos_ser_7_4_2=eject_yneg_ser_7_5_2;
	assign inject_yneg_ser_7_4_2=eject_ypos_ser_7_3_2;
	assign inject_ypos_ser_7_4_3=eject_yneg_ser_7_5_3;
	assign inject_yneg_ser_7_4_3=eject_ypos_ser_7_3_3;
	assign inject_ypos_ser_7_4_4=eject_yneg_ser_7_5_4;
	assign inject_yneg_ser_7_4_4=eject_ypos_ser_7_3_4;
	assign inject_ypos_ser_7_4_5=eject_yneg_ser_7_5_5;
	assign inject_yneg_ser_7_4_5=eject_ypos_ser_7_3_5;
	assign inject_ypos_ser_7_4_6=eject_yneg_ser_7_5_6;
	assign inject_yneg_ser_7_4_6=eject_ypos_ser_7_3_6;
	assign inject_ypos_ser_7_4_7=eject_yneg_ser_7_5_7;
	assign inject_yneg_ser_7_4_7=eject_ypos_ser_7_3_7;
	assign inject_ypos_ser_7_5_0=eject_yneg_ser_7_6_0;
	assign inject_yneg_ser_7_5_0=eject_ypos_ser_7_4_0;
	assign inject_ypos_ser_7_5_1=eject_yneg_ser_7_6_1;
	assign inject_yneg_ser_7_5_1=eject_ypos_ser_7_4_1;
	assign inject_ypos_ser_7_5_2=eject_yneg_ser_7_6_2;
	assign inject_yneg_ser_7_5_2=eject_ypos_ser_7_4_2;
	assign inject_ypos_ser_7_5_3=eject_yneg_ser_7_6_3;
	assign inject_yneg_ser_7_5_3=eject_ypos_ser_7_4_3;
	assign inject_ypos_ser_7_5_4=eject_yneg_ser_7_6_4;
	assign inject_yneg_ser_7_5_4=eject_ypos_ser_7_4_4;
	assign inject_ypos_ser_7_5_5=eject_yneg_ser_7_6_5;
	assign inject_yneg_ser_7_5_5=eject_ypos_ser_7_4_5;
	assign inject_ypos_ser_7_5_6=eject_yneg_ser_7_6_6;
	assign inject_yneg_ser_7_5_6=eject_ypos_ser_7_4_6;
	assign inject_ypos_ser_7_5_7=eject_yneg_ser_7_6_7;
	assign inject_yneg_ser_7_5_7=eject_ypos_ser_7_4_7;
	assign inject_ypos_ser_7_6_0=eject_yneg_ser_7_7_0;
	assign inject_yneg_ser_7_6_0=eject_ypos_ser_7_5_0;
	assign inject_ypos_ser_7_6_1=eject_yneg_ser_7_7_1;
	assign inject_yneg_ser_7_6_1=eject_ypos_ser_7_5_1;
	assign inject_ypos_ser_7_6_2=eject_yneg_ser_7_7_2;
	assign inject_yneg_ser_7_6_2=eject_ypos_ser_7_5_2;
	assign inject_ypos_ser_7_6_3=eject_yneg_ser_7_7_3;
	assign inject_yneg_ser_7_6_3=eject_ypos_ser_7_5_3;
	assign inject_ypos_ser_7_6_4=eject_yneg_ser_7_7_4;
	assign inject_yneg_ser_7_6_4=eject_ypos_ser_7_5_4;
	assign inject_ypos_ser_7_6_5=eject_yneg_ser_7_7_5;
	assign inject_yneg_ser_7_6_5=eject_ypos_ser_7_5_5;
	assign inject_ypos_ser_7_6_6=eject_yneg_ser_7_7_6;
	assign inject_yneg_ser_7_6_6=eject_ypos_ser_7_5_6;
	assign inject_ypos_ser_7_6_7=eject_yneg_ser_7_7_7;
	assign inject_yneg_ser_7_6_7=eject_ypos_ser_7_5_7;
	assign inject_ypos_ser_7_7_0=eject_yneg_ser_7_0_0;
	assign inject_yneg_ser_7_7_0=eject_ypos_ser_7_6_0;
	assign inject_ypos_ser_7_7_1=eject_yneg_ser_7_0_1;
	assign inject_yneg_ser_7_7_1=eject_ypos_ser_7_6_1;
	assign inject_ypos_ser_7_7_2=eject_yneg_ser_7_0_2;
	assign inject_yneg_ser_7_7_2=eject_ypos_ser_7_6_2;
	assign inject_ypos_ser_7_7_3=eject_yneg_ser_7_0_3;
	assign inject_yneg_ser_7_7_3=eject_ypos_ser_7_6_3;
	assign inject_ypos_ser_7_7_4=eject_yneg_ser_7_0_4;
	assign inject_yneg_ser_7_7_4=eject_ypos_ser_7_6_4;
	assign inject_ypos_ser_7_7_5=eject_yneg_ser_7_0_5;
	assign inject_yneg_ser_7_7_5=eject_ypos_ser_7_6_5;
	assign inject_ypos_ser_7_7_6=eject_yneg_ser_7_0_6;
	assign inject_yneg_ser_7_7_6=eject_ypos_ser_7_6_6;
	assign inject_ypos_ser_7_7_7=eject_yneg_ser_7_0_7;
	assign inject_yneg_ser_7_7_7=eject_ypos_ser_7_6_7;
	assign inject_zpos_ser_0_0_0=eject_zneg_ser_0_0_1;
	assign inject_zneg_ser_0_0_0=eject_zpos_ser_0_0_7;
	assign inject_zpos_ser_0_0_1=eject_zneg_ser_0_0_2;
	assign inject_zneg_ser_0_0_1=eject_zpos_ser_0_0_0;
	assign inject_zpos_ser_0_0_2=eject_zneg_ser_0_0_3;
	assign inject_zneg_ser_0_0_2=eject_zpos_ser_0_0_1;
	assign inject_zpos_ser_0_0_3=eject_zneg_ser_0_0_4;
	assign inject_zneg_ser_0_0_3=eject_zpos_ser_0_0_2;
	assign inject_zpos_ser_0_0_4=eject_zneg_ser_0_0_5;
	assign inject_zneg_ser_0_0_4=eject_zpos_ser_0_0_3;
	assign inject_zpos_ser_0_0_5=eject_zneg_ser_0_0_6;
	assign inject_zneg_ser_0_0_5=eject_zpos_ser_0_0_4;
	assign inject_zpos_ser_0_0_6=eject_zneg_ser_0_0_7;
	assign inject_zneg_ser_0_0_6=eject_zpos_ser_0_0_5;
	assign inject_zpos_ser_0_0_7=eject_zneg_ser_0_0_0;
	assign inject_zneg_ser_0_0_7=eject_zpos_ser_0_0_6;
	assign inject_zpos_ser_0_1_0=eject_zneg_ser_0_1_1;
	assign inject_zneg_ser_0_1_0=eject_zpos_ser_0_1_7;
	assign inject_zpos_ser_0_1_1=eject_zneg_ser_0_1_2;
	assign inject_zneg_ser_0_1_1=eject_zpos_ser_0_1_0;
	assign inject_zpos_ser_0_1_2=eject_zneg_ser_0_1_3;
	assign inject_zneg_ser_0_1_2=eject_zpos_ser_0_1_1;
	assign inject_zpos_ser_0_1_3=eject_zneg_ser_0_1_4;
	assign inject_zneg_ser_0_1_3=eject_zpos_ser_0_1_2;
	assign inject_zpos_ser_0_1_4=eject_zneg_ser_0_1_5;
	assign inject_zneg_ser_0_1_4=eject_zpos_ser_0_1_3;
	assign inject_zpos_ser_0_1_5=eject_zneg_ser_0_1_6;
	assign inject_zneg_ser_0_1_5=eject_zpos_ser_0_1_4;
	assign inject_zpos_ser_0_1_6=eject_zneg_ser_0_1_7;
	assign inject_zneg_ser_0_1_6=eject_zpos_ser_0_1_5;
	assign inject_zpos_ser_0_1_7=eject_zneg_ser_0_1_0;
	assign inject_zneg_ser_0_1_7=eject_zpos_ser_0_1_6;
	assign inject_zpos_ser_0_2_0=eject_zneg_ser_0_2_1;
	assign inject_zneg_ser_0_2_0=eject_zpos_ser_0_2_7;
	assign inject_zpos_ser_0_2_1=eject_zneg_ser_0_2_2;
	assign inject_zneg_ser_0_2_1=eject_zpos_ser_0_2_0;
	assign inject_zpos_ser_0_2_2=eject_zneg_ser_0_2_3;
	assign inject_zneg_ser_0_2_2=eject_zpos_ser_0_2_1;
	assign inject_zpos_ser_0_2_3=eject_zneg_ser_0_2_4;
	assign inject_zneg_ser_0_2_3=eject_zpos_ser_0_2_2;
	assign inject_zpos_ser_0_2_4=eject_zneg_ser_0_2_5;
	assign inject_zneg_ser_0_2_4=eject_zpos_ser_0_2_3;
	assign inject_zpos_ser_0_2_5=eject_zneg_ser_0_2_6;
	assign inject_zneg_ser_0_2_5=eject_zpos_ser_0_2_4;
	assign inject_zpos_ser_0_2_6=eject_zneg_ser_0_2_7;
	assign inject_zneg_ser_0_2_6=eject_zpos_ser_0_2_5;
	assign inject_zpos_ser_0_2_7=eject_zneg_ser_0_2_0;
	assign inject_zneg_ser_0_2_7=eject_zpos_ser_0_2_6;
	assign inject_zpos_ser_0_3_0=eject_zneg_ser_0_3_1;
	assign inject_zneg_ser_0_3_0=eject_zpos_ser_0_3_7;
	assign inject_zpos_ser_0_3_1=eject_zneg_ser_0_3_2;
	assign inject_zneg_ser_0_3_1=eject_zpos_ser_0_3_0;
	assign inject_zpos_ser_0_3_2=eject_zneg_ser_0_3_3;
	assign inject_zneg_ser_0_3_2=eject_zpos_ser_0_3_1;
	assign inject_zpos_ser_0_3_3=eject_zneg_ser_0_3_4;
	assign inject_zneg_ser_0_3_3=eject_zpos_ser_0_3_2;
	assign inject_zpos_ser_0_3_4=eject_zneg_ser_0_3_5;
	assign inject_zneg_ser_0_3_4=eject_zpos_ser_0_3_3;
	assign inject_zpos_ser_0_3_5=eject_zneg_ser_0_3_6;
	assign inject_zneg_ser_0_3_5=eject_zpos_ser_0_3_4;
	assign inject_zpos_ser_0_3_6=eject_zneg_ser_0_3_7;
	assign inject_zneg_ser_0_3_6=eject_zpos_ser_0_3_5;
	assign inject_zpos_ser_0_3_7=eject_zneg_ser_0_3_0;
	assign inject_zneg_ser_0_3_7=eject_zpos_ser_0_3_6;
	assign inject_zpos_ser_0_4_0=eject_zneg_ser_0_4_1;
	assign inject_zneg_ser_0_4_0=eject_zpos_ser_0_4_7;
	assign inject_zpos_ser_0_4_1=eject_zneg_ser_0_4_2;
	assign inject_zneg_ser_0_4_1=eject_zpos_ser_0_4_0;
	assign inject_zpos_ser_0_4_2=eject_zneg_ser_0_4_3;
	assign inject_zneg_ser_0_4_2=eject_zpos_ser_0_4_1;
	assign inject_zpos_ser_0_4_3=eject_zneg_ser_0_4_4;
	assign inject_zneg_ser_0_4_3=eject_zpos_ser_0_4_2;
	assign inject_zpos_ser_0_4_4=eject_zneg_ser_0_4_5;
	assign inject_zneg_ser_0_4_4=eject_zpos_ser_0_4_3;
	assign inject_zpos_ser_0_4_5=eject_zneg_ser_0_4_6;
	assign inject_zneg_ser_0_4_5=eject_zpos_ser_0_4_4;
	assign inject_zpos_ser_0_4_6=eject_zneg_ser_0_4_7;
	assign inject_zneg_ser_0_4_6=eject_zpos_ser_0_4_5;
	assign inject_zpos_ser_0_4_7=eject_zneg_ser_0_4_0;
	assign inject_zneg_ser_0_4_7=eject_zpos_ser_0_4_6;
	assign inject_zpos_ser_0_5_0=eject_zneg_ser_0_5_1;
	assign inject_zneg_ser_0_5_0=eject_zpos_ser_0_5_7;
	assign inject_zpos_ser_0_5_1=eject_zneg_ser_0_5_2;
	assign inject_zneg_ser_0_5_1=eject_zpos_ser_0_5_0;
	assign inject_zpos_ser_0_5_2=eject_zneg_ser_0_5_3;
	assign inject_zneg_ser_0_5_2=eject_zpos_ser_0_5_1;
	assign inject_zpos_ser_0_5_3=eject_zneg_ser_0_5_4;
	assign inject_zneg_ser_0_5_3=eject_zpos_ser_0_5_2;
	assign inject_zpos_ser_0_5_4=eject_zneg_ser_0_5_5;
	assign inject_zneg_ser_0_5_4=eject_zpos_ser_0_5_3;
	assign inject_zpos_ser_0_5_5=eject_zneg_ser_0_5_6;
	assign inject_zneg_ser_0_5_5=eject_zpos_ser_0_5_4;
	assign inject_zpos_ser_0_5_6=eject_zneg_ser_0_5_7;
	assign inject_zneg_ser_0_5_6=eject_zpos_ser_0_5_5;
	assign inject_zpos_ser_0_5_7=eject_zneg_ser_0_5_0;
	assign inject_zneg_ser_0_5_7=eject_zpos_ser_0_5_6;
	assign inject_zpos_ser_0_6_0=eject_zneg_ser_0_6_1;
	assign inject_zneg_ser_0_6_0=eject_zpos_ser_0_6_7;
	assign inject_zpos_ser_0_6_1=eject_zneg_ser_0_6_2;
	assign inject_zneg_ser_0_6_1=eject_zpos_ser_0_6_0;
	assign inject_zpos_ser_0_6_2=eject_zneg_ser_0_6_3;
	assign inject_zneg_ser_0_6_2=eject_zpos_ser_0_6_1;
	assign inject_zpos_ser_0_6_3=eject_zneg_ser_0_6_4;
	assign inject_zneg_ser_0_6_3=eject_zpos_ser_0_6_2;
	assign inject_zpos_ser_0_6_4=eject_zneg_ser_0_6_5;
	assign inject_zneg_ser_0_6_4=eject_zpos_ser_0_6_3;
	assign inject_zpos_ser_0_6_5=eject_zneg_ser_0_6_6;
	assign inject_zneg_ser_0_6_5=eject_zpos_ser_0_6_4;
	assign inject_zpos_ser_0_6_6=eject_zneg_ser_0_6_7;
	assign inject_zneg_ser_0_6_6=eject_zpos_ser_0_6_5;
	assign inject_zpos_ser_0_6_7=eject_zneg_ser_0_6_0;
	assign inject_zneg_ser_0_6_7=eject_zpos_ser_0_6_6;
	assign inject_zpos_ser_0_7_0=eject_zneg_ser_0_7_1;
	assign inject_zneg_ser_0_7_0=eject_zpos_ser_0_7_7;
	assign inject_zpos_ser_0_7_1=eject_zneg_ser_0_7_2;
	assign inject_zneg_ser_0_7_1=eject_zpos_ser_0_7_0;
	assign inject_zpos_ser_0_7_2=eject_zneg_ser_0_7_3;
	assign inject_zneg_ser_0_7_2=eject_zpos_ser_0_7_1;
	assign inject_zpos_ser_0_7_3=eject_zneg_ser_0_7_4;
	assign inject_zneg_ser_0_7_3=eject_zpos_ser_0_7_2;
	assign inject_zpos_ser_0_7_4=eject_zneg_ser_0_7_5;
	assign inject_zneg_ser_0_7_4=eject_zpos_ser_0_7_3;
	assign inject_zpos_ser_0_7_5=eject_zneg_ser_0_7_6;
	assign inject_zneg_ser_0_7_5=eject_zpos_ser_0_7_4;
	assign inject_zpos_ser_0_7_6=eject_zneg_ser_0_7_7;
	assign inject_zneg_ser_0_7_6=eject_zpos_ser_0_7_5;
	assign inject_zpos_ser_0_7_7=eject_zneg_ser_0_7_0;
	assign inject_zneg_ser_0_7_7=eject_zpos_ser_0_7_6;
	assign inject_zpos_ser_1_0_0=eject_zneg_ser_1_0_1;
	assign inject_zneg_ser_1_0_0=eject_zpos_ser_1_0_7;
	assign inject_zpos_ser_1_0_1=eject_zneg_ser_1_0_2;
	assign inject_zneg_ser_1_0_1=eject_zpos_ser_1_0_0;
	assign inject_zpos_ser_1_0_2=eject_zneg_ser_1_0_3;
	assign inject_zneg_ser_1_0_2=eject_zpos_ser_1_0_1;
	assign inject_zpos_ser_1_0_3=eject_zneg_ser_1_0_4;
	assign inject_zneg_ser_1_0_3=eject_zpos_ser_1_0_2;
	assign inject_zpos_ser_1_0_4=eject_zneg_ser_1_0_5;
	assign inject_zneg_ser_1_0_4=eject_zpos_ser_1_0_3;
	assign inject_zpos_ser_1_0_5=eject_zneg_ser_1_0_6;
	assign inject_zneg_ser_1_0_5=eject_zpos_ser_1_0_4;
	assign inject_zpos_ser_1_0_6=eject_zneg_ser_1_0_7;
	assign inject_zneg_ser_1_0_6=eject_zpos_ser_1_0_5;
	assign inject_zpos_ser_1_0_7=eject_zneg_ser_1_0_0;
	assign inject_zneg_ser_1_0_7=eject_zpos_ser_1_0_6;
	assign inject_zpos_ser_1_1_0=eject_zneg_ser_1_1_1;
	assign inject_zneg_ser_1_1_0=eject_zpos_ser_1_1_7;
	assign inject_zpos_ser_1_1_1=eject_zneg_ser_1_1_2;
	assign inject_zneg_ser_1_1_1=eject_zpos_ser_1_1_0;
	assign inject_zpos_ser_1_1_2=eject_zneg_ser_1_1_3;
	assign inject_zneg_ser_1_1_2=eject_zpos_ser_1_1_1;
	assign inject_zpos_ser_1_1_3=eject_zneg_ser_1_1_4;
	assign inject_zneg_ser_1_1_3=eject_zpos_ser_1_1_2;
	assign inject_zpos_ser_1_1_4=eject_zneg_ser_1_1_5;
	assign inject_zneg_ser_1_1_4=eject_zpos_ser_1_1_3;
	assign inject_zpos_ser_1_1_5=eject_zneg_ser_1_1_6;
	assign inject_zneg_ser_1_1_5=eject_zpos_ser_1_1_4;
	assign inject_zpos_ser_1_1_6=eject_zneg_ser_1_1_7;
	assign inject_zneg_ser_1_1_6=eject_zpos_ser_1_1_5;
	assign inject_zpos_ser_1_1_7=eject_zneg_ser_1_1_0;
	assign inject_zneg_ser_1_1_7=eject_zpos_ser_1_1_6;
	assign inject_zpos_ser_1_2_0=eject_zneg_ser_1_2_1;
	assign inject_zneg_ser_1_2_0=eject_zpos_ser_1_2_7;
	assign inject_zpos_ser_1_2_1=eject_zneg_ser_1_2_2;
	assign inject_zneg_ser_1_2_1=eject_zpos_ser_1_2_0;
	assign inject_zpos_ser_1_2_2=eject_zneg_ser_1_2_3;
	assign inject_zneg_ser_1_2_2=eject_zpos_ser_1_2_1;
	assign inject_zpos_ser_1_2_3=eject_zneg_ser_1_2_4;
	assign inject_zneg_ser_1_2_3=eject_zpos_ser_1_2_2;
	assign inject_zpos_ser_1_2_4=eject_zneg_ser_1_2_5;
	assign inject_zneg_ser_1_2_4=eject_zpos_ser_1_2_3;
	assign inject_zpos_ser_1_2_5=eject_zneg_ser_1_2_6;
	assign inject_zneg_ser_1_2_5=eject_zpos_ser_1_2_4;
	assign inject_zpos_ser_1_2_6=eject_zneg_ser_1_2_7;
	assign inject_zneg_ser_1_2_6=eject_zpos_ser_1_2_5;
	assign inject_zpos_ser_1_2_7=eject_zneg_ser_1_2_0;
	assign inject_zneg_ser_1_2_7=eject_zpos_ser_1_2_6;
	assign inject_zpos_ser_1_3_0=eject_zneg_ser_1_3_1;
	assign inject_zneg_ser_1_3_0=eject_zpos_ser_1_3_7;
	assign inject_zpos_ser_1_3_1=eject_zneg_ser_1_3_2;
	assign inject_zneg_ser_1_3_1=eject_zpos_ser_1_3_0;
	assign inject_zpos_ser_1_3_2=eject_zneg_ser_1_3_3;
	assign inject_zneg_ser_1_3_2=eject_zpos_ser_1_3_1;
	assign inject_zpos_ser_1_3_3=eject_zneg_ser_1_3_4;
	assign inject_zneg_ser_1_3_3=eject_zpos_ser_1_3_2;
	assign inject_zpos_ser_1_3_4=eject_zneg_ser_1_3_5;
	assign inject_zneg_ser_1_3_4=eject_zpos_ser_1_3_3;
	assign inject_zpos_ser_1_3_5=eject_zneg_ser_1_3_6;
	assign inject_zneg_ser_1_3_5=eject_zpos_ser_1_3_4;
	assign inject_zpos_ser_1_3_6=eject_zneg_ser_1_3_7;
	assign inject_zneg_ser_1_3_6=eject_zpos_ser_1_3_5;
	assign inject_zpos_ser_1_3_7=eject_zneg_ser_1_3_0;
	assign inject_zneg_ser_1_3_7=eject_zpos_ser_1_3_6;
	assign inject_zpos_ser_1_4_0=eject_zneg_ser_1_4_1;
	assign inject_zneg_ser_1_4_0=eject_zpos_ser_1_4_7;
	assign inject_zpos_ser_1_4_1=eject_zneg_ser_1_4_2;
	assign inject_zneg_ser_1_4_1=eject_zpos_ser_1_4_0;
	assign inject_zpos_ser_1_4_2=eject_zneg_ser_1_4_3;
	assign inject_zneg_ser_1_4_2=eject_zpos_ser_1_4_1;
	assign inject_zpos_ser_1_4_3=eject_zneg_ser_1_4_4;
	assign inject_zneg_ser_1_4_3=eject_zpos_ser_1_4_2;
	assign inject_zpos_ser_1_4_4=eject_zneg_ser_1_4_5;
	assign inject_zneg_ser_1_4_4=eject_zpos_ser_1_4_3;
	assign inject_zpos_ser_1_4_5=eject_zneg_ser_1_4_6;
	assign inject_zneg_ser_1_4_5=eject_zpos_ser_1_4_4;
	assign inject_zpos_ser_1_4_6=eject_zneg_ser_1_4_7;
	assign inject_zneg_ser_1_4_6=eject_zpos_ser_1_4_5;
	assign inject_zpos_ser_1_4_7=eject_zneg_ser_1_4_0;
	assign inject_zneg_ser_1_4_7=eject_zpos_ser_1_4_6;
	assign inject_zpos_ser_1_5_0=eject_zneg_ser_1_5_1;
	assign inject_zneg_ser_1_5_0=eject_zpos_ser_1_5_7;
	assign inject_zpos_ser_1_5_1=eject_zneg_ser_1_5_2;
	assign inject_zneg_ser_1_5_1=eject_zpos_ser_1_5_0;
	assign inject_zpos_ser_1_5_2=eject_zneg_ser_1_5_3;
	assign inject_zneg_ser_1_5_2=eject_zpos_ser_1_5_1;
	assign inject_zpos_ser_1_5_3=eject_zneg_ser_1_5_4;
	assign inject_zneg_ser_1_5_3=eject_zpos_ser_1_5_2;
	assign inject_zpos_ser_1_5_4=eject_zneg_ser_1_5_5;
	assign inject_zneg_ser_1_5_4=eject_zpos_ser_1_5_3;
	assign inject_zpos_ser_1_5_5=eject_zneg_ser_1_5_6;
	assign inject_zneg_ser_1_5_5=eject_zpos_ser_1_5_4;
	assign inject_zpos_ser_1_5_6=eject_zneg_ser_1_5_7;
	assign inject_zneg_ser_1_5_6=eject_zpos_ser_1_5_5;
	assign inject_zpos_ser_1_5_7=eject_zneg_ser_1_5_0;
	assign inject_zneg_ser_1_5_7=eject_zpos_ser_1_5_6;
	assign inject_zpos_ser_1_6_0=eject_zneg_ser_1_6_1;
	assign inject_zneg_ser_1_6_0=eject_zpos_ser_1_6_7;
	assign inject_zpos_ser_1_6_1=eject_zneg_ser_1_6_2;
	assign inject_zneg_ser_1_6_1=eject_zpos_ser_1_6_0;
	assign inject_zpos_ser_1_6_2=eject_zneg_ser_1_6_3;
	assign inject_zneg_ser_1_6_2=eject_zpos_ser_1_6_1;
	assign inject_zpos_ser_1_6_3=eject_zneg_ser_1_6_4;
	assign inject_zneg_ser_1_6_3=eject_zpos_ser_1_6_2;
	assign inject_zpos_ser_1_6_4=eject_zneg_ser_1_6_5;
	assign inject_zneg_ser_1_6_4=eject_zpos_ser_1_6_3;
	assign inject_zpos_ser_1_6_5=eject_zneg_ser_1_6_6;
	assign inject_zneg_ser_1_6_5=eject_zpos_ser_1_6_4;
	assign inject_zpos_ser_1_6_6=eject_zneg_ser_1_6_7;
	assign inject_zneg_ser_1_6_6=eject_zpos_ser_1_6_5;
	assign inject_zpos_ser_1_6_7=eject_zneg_ser_1_6_0;
	assign inject_zneg_ser_1_6_7=eject_zpos_ser_1_6_6;
	assign inject_zpos_ser_1_7_0=eject_zneg_ser_1_7_1;
	assign inject_zneg_ser_1_7_0=eject_zpos_ser_1_7_7;
	assign inject_zpos_ser_1_7_1=eject_zneg_ser_1_7_2;
	assign inject_zneg_ser_1_7_1=eject_zpos_ser_1_7_0;
	assign inject_zpos_ser_1_7_2=eject_zneg_ser_1_7_3;
	assign inject_zneg_ser_1_7_2=eject_zpos_ser_1_7_1;
	assign inject_zpos_ser_1_7_3=eject_zneg_ser_1_7_4;
	assign inject_zneg_ser_1_7_3=eject_zpos_ser_1_7_2;
	assign inject_zpos_ser_1_7_4=eject_zneg_ser_1_7_5;
	assign inject_zneg_ser_1_7_4=eject_zpos_ser_1_7_3;
	assign inject_zpos_ser_1_7_5=eject_zneg_ser_1_7_6;
	assign inject_zneg_ser_1_7_5=eject_zpos_ser_1_7_4;
	assign inject_zpos_ser_1_7_6=eject_zneg_ser_1_7_7;
	assign inject_zneg_ser_1_7_6=eject_zpos_ser_1_7_5;
	assign inject_zpos_ser_1_7_7=eject_zneg_ser_1_7_0;
	assign inject_zneg_ser_1_7_7=eject_zpos_ser_1_7_6;
	assign inject_zpos_ser_2_0_0=eject_zneg_ser_2_0_1;
	assign inject_zneg_ser_2_0_0=eject_zpos_ser_2_0_7;
	assign inject_zpos_ser_2_0_1=eject_zneg_ser_2_0_2;
	assign inject_zneg_ser_2_0_1=eject_zpos_ser_2_0_0;
	assign inject_zpos_ser_2_0_2=eject_zneg_ser_2_0_3;
	assign inject_zneg_ser_2_0_2=eject_zpos_ser_2_0_1;
	assign inject_zpos_ser_2_0_3=eject_zneg_ser_2_0_4;
	assign inject_zneg_ser_2_0_3=eject_zpos_ser_2_0_2;
	assign inject_zpos_ser_2_0_4=eject_zneg_ser_2_0_5;
	assign inject_zneg_ser_2_0_4=eject_zpos_ser_2_0_3;
	assign inject_zpos_ser_2_0_5=eject_zneg_ser_2_0_6;
	assign inject_zneg_ser_2_0_5=eject_zpos_ser_2_0_4;
	assign inject_zpos_ser_2_0_6=eject_zneg_ser_2_0_7;
	assign inject_zneg_ser_2_0_6=eject_zpos_ser_2_0_5;
	assign inject_zpos_ser_2_0_7=eject_zneg_ser_2_0_0;
	assign inject_zneg_ser_2_0_7=eject_zpos_ser_2_0_6;
	assign inject_zpos_ser_2_1_0=eject_zneg_ser_2_1_1;
	assign inject_zneg_ser_2_1_0=eject_zpos_ser_2_1_7;
	assign inject_zpos_ser_2_1_1=eject_zneg_ser_2_1_2;
	assign inject_zneg_ser_2_1_1=eject_zpos_ser_2_1_0;
	assign inject_zpos_ser_2_1_2=eject_zneg_ser_2_1_3;
	assign inject_zneg_ser_2_1_2=eject_zpos_ser_2_1_1;
	assign inject_zpos_ser_2_1_3=eject_zneg_ser_2_1_4;
	assign inject_zneg_ser_2_1_3=eject_zpos_ser_2_1_2;
	assign inject_zpos_ser_2_1_4=eject_zneg_ser_2_1_5;
	assign inject_zneg_ser_2_1_4=eject_zpos_ser_2_1_3;
	assign inject_zpos_ser_2_1_5=eject_zneg_ser_2_1_6;
	assign inject_zneg_ser_2_1_5=eject_zpos_ser_2_1_4;
	assign inject_zpos_ser_2_1_6=eject_zneg_ser_2_1_7;
	assign inject_zneg_ser_2_1_6=eject_zpos_ser_2_1_5;
	assign inject_zpos_ser_2_1_7=eject_zneg_ser_2_1_0;
	assign inject_zneg_ser_2_1_7=eject_zpos_ser_2_1_6;
	assign inject_zpos_ser_2_2_0=eject_zneg_ser_2_2_1;
	assign inject_zneg_ser_2_2_0=eject_zpos_ser_2_2_7;
	assign inject_zpos_ser_2_2_1=eject_zneg_ser_2_2_2;
	assign inject_zneg_ser_2_2_1=eject_zpos_ser_2_2_0;
	assign inject_zpos_ser_2_2_2=eject_zneg_ser_2_2_3;
	assign inject_zneg_ser_2_2_2=eject_zpos_ser_2_2_1;
	assign inject_zpos_ser_2_2_3=eject_zneg_ser_2_2_4;
	assign inject_zneg_ser_2_2_3=eject_zpos_ser_2_2_2;
	assign inject_zpos_ser_2_2_4=eject_zneg_ser_2_2_5;
	assign inject_zneg_ser_2_2_4=eject_zpos_ser_2_2_3;
	assign inject_zpos_ser_2_2_5=eject_zneg_ser_2_2_6;
	assign inject_zneg_ser_2_2_5=eject_zpos_ser_2_2_4;
	assign inject_zpos_ser_2_2_6=eject_zneg_ser_2_2_7;
	assign inject_zneg_ser_2_2_6=eject_zpos_ser_2_2_5;
	assign inject_zpos_ser_2_2_7=eject_zneg_ser_2_2_0;
	assign inject_zneg_ser_2_2_7=eject_zpos_ser_2_2_6;
	assign inject_zpos_ser_2_3_0=eject_zneg_ser_2_3_1;
	assign inject_zneg_ser_2_3_0=eject_zpos_ser_2_3_7;
	assign inject_zpos_ser_2_3_1=eject_zneg_ser_2_3_2;
	assign inject_zneg_ser_2_3_1=eject_zpos_ser_2_3_0;
	assign inject_zpos_ser_2_3_2=eject_zneg_ser_2_3_3;
	assign inject_zneg_ser_2_3_2=eject_zpos_ser_2_3_1;
	assign inject_zpos_ser_2_3_3=eject_zneg_ser_2_3_4;
	assign inject_zneg_ser_2_3_3=eject_zpos_ser_2_3_2;
	assign inject_zpos_ser_2_3_4=eject_zneg_ser_2_3_5;
	assign inject_zneg_ser_2_3_4=eject_zpos_ser_2_3_3;
	assign inject_zpos_ser_2_3_5=eject_zneg_ser_2_3_6;
	assign inject_zneg_ser_2_3_5=eject_zpos_ser_2_3_4;
	assign inject_zpos_ser_2_3_6=eject_zneg_ser_2_3_7;
	assign inject_zneg_ser_2_3_6=eject_zpos_ser_2_3_5;
	assign inject_zpos_ser_2_3_7=eject_zneg_ser_2_3_0;
	assign inject_zneg_ser_2_3_7=eject_zpos_ser_2_3_6;
	assign inject_zpos_ser_2_4_0=eject_zneg_ser_2_4_1;
	assign inject_zneg_ser_2_4_0=eject_zpos_ser_2_4_7;
	assign inject_zpos_ser_2_4_1=eject_zneg_ser_2_4_2;
	assign inject_zneg_ser_2_4_1=eject_zpos_ser_2_4_0;
	assign inject_zpos_ser_2_4_2=eject_zneg_ser_2_4_3;
	assign inject_zneg_ser_2_4_2=eject_zpos_ser_2_4_1;
	assign inject_zpos_ser_2_4_3=eject_zneg_ser_2_4_4;
	assign inject_zneg_ser_2_4_3=eject_zpos_ser_2_4_2;
	assign inject_zpos_ser_2_4_4=eject_zneg_ser_2_4_5;
	assign inject_zneg_ser_2_4_4=eject_zpos_ser_2_4_3;
	assign inject_zpos_ser_2_4_5=eject_zneg_ser_2_4_6;
	assign inject_zneg_ser_2_4_5=eject_zpos_ser_2_4_4;
	assign inject_zpos_ser_2_4_6=eject_zneg_ser_2_4_7;
	assign inject_zneg_ser_2_4_6=eject_zpos_ser_2_4_5;
	assign inject_zpos_ser_2_4_7=eject_zneg_ser_2_4_0;
	assign inject_zneg_ser_2_4_7=eject_zpos_ser_2_4_6;
	assign inject_zpos_ser_2_5_0=eject_zneg_ser_2_5_1;
	assign inject_zneg_ser_2_5_0=eject_zpos_ser_2_5_7;
	assign inject_zpos_ser_2_5_1=eject_zneg_ser_2_5_2;
	assign inject_zneg_ser_2_5_1=eject_zpos_ser_2_5_0;
	assign inject_zpos_ser_2_5_2=eject_zneg_ser_2_5_3;
	assign inject_zneg_ser_2_5_2=eject_zpos_ser_2_5_1;
	assign inject_zpos_ser_2_5_3=eject_zneg_ser_2_5_4;
	assign inject_zneg_ser_2_5_3=eject_zpos_ser_2_5_2;
	assign inject_zpos_ser_2_5_4=eject_zneg_ser_2_5_5;
	assign inject_zneg_ser_2_5_4=eject_zpos_ser_2_5_3;
	assign inject_zpos_ser_2_5_5=eject_zneg_ser_2_5_6;
	assign inject_zneg_ser_2_5_5=eject_zpos_ser_2_5_4;
	assign inject_zpos_ser_2_5_6=eject_zneg_ser_2_5_7;
	assign inject_zneg_ser_2_5_6=eject_zpos_ser_2_5_5;
	assign inject_zpos_ser_2_5_7=eject_zneg_ser_2_5_0;
	assign inject_zneg_ser_2_5_7=eject_zpos_ser_2_5_6;
	assign inject_zpos_ser_2_6_0=eject_zneg_ser_2_6_1;
	assign inject_zneg_ser_2_6_0=eject_zpos_ser_2_6_7;
	assign inject_zpos_ser_2_6_1=eject_zneg_ser_2_6_2;
	assign inject_zneg_ser_2_6_1=eject_zpos_ser_2_6_0;
	assign inject_zpos_ser_2_6_2=eject_zneg_ser_2_6_3;
	assign inject_zneg_ser_2_6_2=eject_zpos_ser_2_6_1;
	assign inject_zpos_ser_2_6_3=eject_zneg_ser_2_6_4;
	assign inject_zneg_ser_2_6_3=eject_zpos_ser_2_6_2;
	assign inject_zpos_ser_2_6_4=eject_zneg_ser_2_6_5;
	assign inject_zneg_ser_2_6_4=eject_zpos_ser_2_6_3;
	assign inject_zpos_ser_2_6_5=eject_zneg_ser_2_6_6;
	assign inject_zneg_ser_2_6_5=eject_zpos_ser_2_6_4;
	assign inject_zpos_ser_2_6_6=eject_zneg_ser_2_6_7;
	assign inject_zneg_ser_2_6_6=eject_zpos_ser_2_6_5;
	assign inject_zpos_ser_2_6_7=eject_zneg_ser_2_6_0;
	assign inject_zneg_ser_2_6_7=eject_zpos_ser_2_6_6;
	assign inject_zpos_ser_2_7_0=eject_zneg_ser_2_7_1;
	assign inject_zneg_ser_2_7_0=eject_zpos_ser_2_7_7;
	assign inject_zpos_ser_2_7_1=eject_zneg_ser_2_7_2;
	assign inject_zneg_ser_2_7_1=eject_zpos_ser_2_7_0;
	assign inject_zpos_ser_2_7_2=eject_zneg_ser_2_7_3;
	assign inject_zneg_ser_2_7_2=eject_zpos_ser_2_7_1;
	assign inject_zpos_ser_2_7_3=eject_zneg_ser_2_7_4;
	assign inject_zneg_ser_2_7_3=eject_zpos_ser_2_7_2;
	assign inject_zpos_ser_2_7_4=eject_zneg_ser_2_7_5;
	assign inject_zneg_ser_2_7_4=eject_zpos_ser_2_7_3;
	assign inject_zpos_ser_2_7_5=eject_zneg_ser_2_7_6;
	assign inject_zneg_ser_2_7_5=eject_zpos_ser_2_7_4;
	assign inject_zpos_ser_2_7_6=eject_zneg_ser_2_7_7;
	assign inject_zneg_ser_2_7_6=eject_zpos_ser_2_7_5;
	assign inject_zpos_ser_2_7_7=eject_zneg_ser_2_7_0;
	assign inject_zneg_ser_2_7_7=eject_zpos_ser_2_7_6;
	assign inject_zpos_ser_3_0_0=eject_zneg_ser_3_0_1;
	assign inject_zneg_ser_3_0_0=eject_zpos_ser_3_0_7;
	assign inject_zpos_ser_3_0_1=eject_zneg_ser_3_0_2;
	assign inject_zneg_ser_3_0_1=eject_zpos_ser_3_0_0;
	assign inject_zpos_ser_3_0_2=eject_zneg_ser_3_0_3;
	assign inject_zneg_ser_3_0_2=eject_zpos_ser_3_0_1;
	assign inject_zpos_ser_3_0_3=eject_zneg_ser_3_0_4;
	assign inject_zneg_ser_3_0_3=eject_zpos_ser_3_0_2;
	assign inject_zpos_ser_3_0_4=eject_zneg_ser_3_0_5;
	assign inject_zneg_ser_3_0_4=eject_zpos_ser_3_0_3;
	assign inject_zpos_ser_3_0_5=eject_zneg_ser_3_0_6;
	assign inject_zneg_ser_3_0_5=eject_zpos_ser_3_0_4;
	assign inject_zpos_ser_3_0_6=eject_zneg_ser_3_0_7;
	assign inject_zneg_ser_3_0_6=eject_zpos_ser_3_0_5;
	assign inject_zpos_ser_3_0_7=eject_zneg_ser_3_0_0;
	assign inject_zneg_ser_3_0_7=eject_zpos_ser_3_0_6;
	assign inject_zpos_ser_3_1_0=eject_zneg_ser_3_1_1;
	assign inject_zneg_ser_3_1_0=eject_zpos_ser_3_1_7;
	assign inject_zpos_ser_3_1_1=eject_zneg_ser_3_1_2;
	assign inject_zneg_ser_3_1_1=eject_zpos_ser_3_1_0;
	assign inject_zpos_ser_3_1_2=eject_zneg_ser_3_1_3;
	assign inject_zneg_ser_3_1_2=eject_zpos_ser_3_1_1;
	assign inject_zpos_ser_3_1_3=eject_zneg_ser_3_1_4;
	assign inject_zneg_ser_3_1_3=eject_zpos_ser_3_1_2;
	assign inject_zpos_ser_3_1_4=eject_zneg_ser_3_1_5;
	assign inject_zneg_ser_3_1_4=eject_zpos_ser_3_1_3;
	assign inject_zpos_ser_3_1_5=eject_zneg_ser_3_1_6;
	assign inject_zneg_ser_3_1_5=eject_zpos_ser_3_1_4;
	assign inject_zpos_ser_3_1_6=eject_zneg_ser_3_1_7;
	assign inject_zneg_ser_3_1_6=eject_zpos_ser_3_1_5;
	assign inject_zpos_ser_3_1_7=eject_zneg_ser_3_1_0;
	assign inject_zneg_ser_3_1_7=eject_zpos_ser_3_1_6;
	assign inject_zpos_ser_3_2_0=eject_zneg_ser_3_2_1;
	assign inject_zneg_ser_3_2_0=eject_zpos_ser_3_2_7;
	assign inject_zpos_ser_3_2_1=eject_zneg_ser_3_2_2;
	assign inject_zneg_ser_3_2_1=eject_zpos_ser_3_2_0;
	assign inject_zpos_ser_3_2_2=eject_zneg_ser_3_2_3;
	assign inject_zneg_ser_3_2_2=eject_zpos_ser_3_2_1;
	assign inject_zpos_ser_3_2_3=eject_zneg_ser_3_2_4;
	assign inject_zneg_ser_3_2_3=eject_zpos_ser_3_2_2;
	assign inject_zpos_ser_3_2_4=eject_zneg_ser_3_2_5;
	assign inject_zneg_ser_3_2_4=eject_zpos_ser_3_2_3;
	assign inject_zpos_ser_3_2_5=eject_zneg_ser_3_2_6;
	assign inject_zneg_ser_3_2_5=eject_zpos_ser_3_2_4;
	assign inject_zpos_ser_3_2_6=eject_zneg_ser_3_2_7;
	assign inject_zneg_ser_3_2_6=eject_zpos_ser_3_2_5;
	assign inject_zpos_ser_3_2_7=eject_zneg_ser_3_2_0;
	assign inject_zneg_ser_3_2_7=eject_zpos_ser_3_2_6;
	assign inject_zpos_ser_3_3_0=eject_zneg_ser_3_3_1;
	assign inject_zneg_ser_3_3_0=eject_zpos_ser_3_3_7;
	assign inject_zpos_ser_3_3_1=eject_zneg_ser_3_3_2;
	assign inject_zneg_ser_3_3_1=eject_zpos_ser_3_3_0;
	assign inject_zpos_ser_3_3_2=eject_zneg_ser_3_3_3;
	assign inject_zneg_ser_3_3_2=eject_zpos_ser_3_3_1;
	assign inject_zpos_ser_3_3_3=eject_zneg_ser_3_3_4;
	assign inject_zneg_ser_3_3_3=eject_zpos_ser_3_3_2;
	assign inject_zpos_ser_3_3_4=eject_zneg_ser_3_3_5;
	assign inject_zneg_ser_3_3_4=eject_zpos_ser_3_3_3;
	assign inject_zpos_ser_3_3_5=eject_zneg_ser_3_3_6;
	assign inject_zneg_ser_3_3_5=eject_zpos_ser_3_3_4;
	assign inject_zpos_ser_3_3_6=eject_zneg_ser_3_3_7;
	assign inject_zneg_ser_3_3_6=eject_zpos_ser_3_3_5;
	assign inject_zpos_ser_3_3_7=eject_zneg_ser_3_3_0;
	assign inject_zneg_ser_3_3_7=eject_zpos_ser_3_3_6;
	assign inject_zpos_ser_3_4_0=eject_zneg_ser_3_4_1;
	assign inject_zneg_ser_3_4_0=eject_zpos_ser_3_4_7;
	assign inject_zpos_ser_3_4_1=eject_zneg_ser_3_4_2;
	assign inject_zneg_ser_3_4_1=eject_zpos_ser_3_4_0;
	assign inject_zpos_ser_3_4_2=eject_zneg_ser_3_4_3;
	assign inject_zneg_ser_3_4_2=eject_zpos_ser_3_4_1;
	assign inject_zpos_ser_3_4_3=eject_zneg_ser_3_4_4;
	assign inject_zneg_ser_3_4_3=eject_zpos_ser_3_4_2;
	assign inject_zpos_ser_3_4_4=eject_zneg_ser_3_4_5;
	assign inject_zneg_ser_3_4_4=eject_zpos_ser_3_4_3;
	assign inject_zpos_ser_3_4_5=eject_zneg_ser_3_4_6;
	assign inject_zneg_ser_3_4_5=eject_zpos_ser_3_4_4;
	assign inject_zpos_ser_3_4_6=eject_zneg_ser_3_4_7;
	assign inject_zneg_ser_3_4_6=eject_zpos_ser_3_4_5;
	assign inject_zpos_ser_3_4_7=eject_zneg_ser_3_4_0;
	assign inject_zneg_ser_3_4_7=eject_zpos_ser_3_4_6;
	assign inject_zpos_ser_3_5_0=eject_zneg_ser_3_5_1;
	assign inject_zneg_ser_3_5_0=eject_zpos_ser_3_5_7;
	assign inject_zpos_ser_3_5_1=eject_zneg_ser_3_5_2;
	assign inject_zneg_ser_3_5_1=eject_zpos_ser_3_5_0;
	assign inject_zpos_ser_3_5_2=eject_zneg_ser_3_5_3;
	assign inject_zneg_ser_3_5_2=eject_zpos_ser_3_5_1;
	assign inject_zpos_ser_3_5_3=eject_zneg_ser_3_5_4;
	assign inject_zneg_ser_3_5_3=eject_zpos_ser_3_5_2;
	assign inject_zpos_ser_3_5_4=eject_zneg_ser_3_5_5;
	assign inject_zneg_ser_3_5_4=eject_zpos_ser_3_5_3;
	assign inject_zpos_ser_3_5_5=eject_zneg_ser_3_5_6;
	assign inject_zneg_ser_3_5_5=eject_zpos_ser_3_5_4;
	assign inject_zpos_ser_3_5_6=eject_zneg_ser_3_5_7;
	assign inject_zneg_ser_3_5_6=eject_zpos_ser_3_5_5;
	assign inject_zpos_ser_3_5_7=eject_zneg_ser_3_5_0;
	assign inject_zneg_ser_3_5_7=eject_zpos_ser_3_5_6;
	assign inject_zpos_ser_3_6_0=eject_zneg_ser_3_6_1;
	assign inject_zneg_ser_3_6_0=eject_zpos_ser_3_6_7;
	assign inject_zpos_ser_3_6_1=eject_zneg_ser_3_6_2;
	assign inject_zneg_ser_3_6_1=eject_zpos_ser_3_6_0;
	assign inject_zpos_ser_3_6_2=eject_zneg_ser_3_6_3;
	assign inject_zneg_ser_3_6_2=eject_zpos_ser_3_6_1;
	assign inject_zpos_ser_3_6_3=eject_zneg_ser_3_6_4;
	assign inject_zneg_ser_3_6_3=eject_zpos_ser_3_6_2;
	assign inject_zpos_ser_3_6_4=eject_zneg_ser_3_6_5;
	assign inject_zneg_ser_3_6_4=eject_zpos_ser_3_6_3;
	assign inject_zpos_ser_3_6_5=eject_zneg_ser_3_6_6;
	assign inject_zneg_ser_3_6_5=eject_zpos_ser_3_6_4;
	assign inject_zpos_ser_3_6_6=eject_zneg_ser_3_6_7;
	assign inject_zneg_ser_3_6_6=eject_zpos_ser_3_6_5;
	assign inject_zpos_ser_3_6_7=eject_zneg_ser_3_6_0;
	assign inject_zneg_ser_3_6_7=eject_zpos_ser_3_6_6;
	assign inject_zpos_ser_3_7_0=eject_zneg_ser_3_7_1;
	assign inject_zneg_ser_3_7_0=eject_zpos_ser_3_7_7;
	assign inject_zpos_ser_3_7_1=eject_zneg_ser_3_7_2;
	assign inject_zneg_ser_3_7_1=eject_zpos_ser_3_7_0;
	assign inject_zpos_ser_3_7_2=eject_zneg_ser_3_7_3;
	assign inject_zneg_ser_3_7_2=eject_zpos_ser_3_7_1;
	assign inject_zpos_ser_3_7_3=eject_zneg_ser_3_7_4;
	assign inject_zneg_ser_3_7_3=eject_zpos_ser_3_7_2;
	assign inject_zpos_ser_3_7_4=eject_zneg_ser_3_7_5;
	assign inject_zneg_ser_3_7_4=eject_zpos_ser_3_7_3;
	assign inject_zpos_ser_3_7_5=eject_zneg_ser_3_7_6;
	assign inject_zneg_ser_3_7_5=eject_zpos_ser_3_7_4;
	assign inject_zpos_ser_3_7_6=eject_zneg_ser_3_7_7;
	assign inject_zneg_ser_3_7_6=eject_zpos_ser_3_7_5;
	assign inject_zpos_ser_3_7_7=eject_zneg_ser_3_7_0;
	assign inject_zneg_ser_3_7_7=eject_zpos_ser_3_7_6;
	assign inject_zpos_ser_4_0_0=eject_zneg_ser_4_0_1;
	assign inject_zneg_ser_4_0_0=eject_zpos_ser_4_0_7;
	assign inject_zpos_ser_4_0_1=eject_zneg_ser_4_0_2;
	assign inject_zneg_ser_4_0_1=eject_zpos_ser_4_0_0;
	assign inject_zpos_ser_4_0_2=eject_zneg_ser_4_0_3;
	assign inject_zneg_ser_4_0_2=eject_zpos_ser_4_0_1;
	assign inject_zpos_ser_4_0_3=eject_zneg_ser_4_0_4;
	assign inject_zneg_ser_4_0_3=eject_zpos_ser_4_0_2;
	assign inject_zpos_ser_4_0_4=eject_zneg_ser_4_0_5;
	assign inject_zneg_ser_4_0_4=eject_zpos_ser_4_0_3;
	assign inject_zpos_ser_4_0_5=eject_zneg_ser_4_0_6;
	assign inject_zneg_ser_4_0_5=eject_zpos_ser_4_0_4;
	assign inject_zpos_ser_4_0_6=eject_zneg_ser_4_0_7;
	assign inject_zneg_ser_4_0_6=eject_zpos_ser_4_0_5;
	assign inject_zpos_ser_4_0_7=eject_zneg_ser_4_0_0;
	assign inject_zneg_ser_4_0_7=eject_zpos_ser_4_0_6;
	assign inject_zpos_ser_4_1_0=eject_zneg_ser_4_1_1;
	assign inject_zneg_ser_4_1_0=eject_zpos_ser_4_1_7;
	assign inject_zpos_ser_4_1_1=eject_zneg_ser_4_1_2;
	assign inject_zneg_ser_4_1_1=eject_zpos_ser_4_1_0;
	assign inject_zpos_ser_4_1_2=eject_zneg_ser_4_1_3;
	assign inject_zneg_ser_4_1_2=eject_zpos_ser_4_1_1;
	assign inject_zpos_ser_4_1_3=eject_zneg_ser_4_1_4;
	assign inject_zneg_ser_4_1_3=eject_zpos_ser_4_1_2;
	assign inject_zpos_ser_4_1_4=eject_zneg_ser_4_1_5;
	assign inject_zneg_ser_4_1_4=eject_zpos_ser_4_1_3;
	assign inject_zpos_ser_4_1_5=eject_zneg_ser_4_1_6;
	assign inject_zneg_ser_4_1_5=eject_zpos_ser_4_1_4;
	assign inject_zpos_ser_4_1_6=eject_zneg_ser_4_1_7;
	assign inject_zneg_ser_4_1_6=eject_zpos_ser_4_1_5;
	assign inject_zpos_ser_4_1_7=eject_zneg_ser_4_1_0;
	assign inject_zneg_ser_4_1_7=eject_zpos_ser_4_1_6;
	assign inject_zpos_ser_4_2_0=eject_zneg_ser_4_2_1;
	assign inject_zneg_ser_4_2_0=eject_zpos_ser_4_2_7;
	assign inject_zpos_ser_4_2_1=eject_zneg_ser_4_2_2;
	assign inject_zneg_ser_4_2_1=eject_zpos_ser_4_2_0;
	assign inject_zpos_ser_4_2_2=eject_zneg_ser_4_2_3;
	assign inject_zneg_ser_4_2_2=eject_zpos_ser_4_2_1;
	assign inject_zpos_ser_4_2_3=eject_zneg_ser_4_2_4;
	assign inject_zneg_ser_4_2_3=eject_zpos_ser_4_2_2;
	assign inject_zpos_ser_4_2_4=eject_zneg_ser_4_2_5;
	assign inject_zneg_ser_4_2_4=eject_zpos_ser_4_2_3;
	assign inject_zpos_ser_4_2_5=eject_zneg_ser_4_2_6;
	assign inject_zneg_ser_4_2_5=eject_zpos_ser_4_2_4;
	assign inject_zpos_ser_4_2_6=eject_zneg_ser_4_2_7;
	assign inject_zneg_ser_4_2_6=eject_zpos_ser_4_2_5;
	assign inject_zpos_ser_4_2_7=eject_zneg_ser_4_2_0;
	assign inject_zneg_ser_4_2_7=eject_zpos_ser_4_2_6;
	assign inject_zpos_ser_4_3_0=eject_zneg_ser_4_3_1;
	assign inject_zneg_ser_4_3_0=eject_zpos_ser_4_3_7;
	assign inject_zpos_ser_4_3_1=eject_zneg_ser_4_3_2;
	assign inject_zneg_ser_4_3_1=eject_zpos_ser_4_3_0;
	assign inject_zpos_ser_4_3_2=eject_zneg_ser_4_3_3;
	assign inject_zneg_ser_4_3_2=eject_zpos_ser_4_3_1;
	assign inject_zpos_ser_4_3_3=eject_zneg_ser_4_3_4;
	assign inject_zneg_ser_4_3_3=eject_zpos_ser_4_3_2;
	assign inject_zpos_ser_4_3_4=eject_zneg_ser_4_3_5;
	assign inject_zneg_ser_4_3_4=eject_zpos_ser_4_3_3;
	assign inject_zpos_ser_4_3_5=eject_zneg_ser_4_3_6;
	assign inject_zneg_ser_4_3_5=eject_zpos_ser_4_3_4;
	assign inject_zpos_ser_4_3_6=eject_zneg_ser_4_3_7;
	assign inject_zneg_ser_4_3_6=eject_zpos_ser_4_3_5;
	assign inject_zpos_ser_4_3_7=eject_zneg_ser_4_3_0;
	assign inject_zneg_ser_4_3_7=eject_zpos_ser_4_3_6;
	assign inject_zpos_ser_4_4_0=eject_zneg_ser_4_4_1;
	assign inject_zneg_ser_4_4_0=eject_zpos_ser_4_4_7;
	assign inject_zpos_ser_4_4_1=eject_zneg_ser_4_4_2;
	assign inject_zneg_ser_4_4_1=eject_zpos_ser_4_4_0;
	assign inject_zpos_ser_4_4_2=eject_zneg_ser_4_4_3;
	assign inject_zneg_ser_4_4_2=eject_zpos_ser_4_4_1;
	assign inject_zpos_ser_4_4_3=eject_zneg_ser_4_4_4;
	assign inject_zneg_ser_4_4_3=eject_zpos_ser_4_4_2;
	assign inject_zpos_ser_4_4_4=eject_zneg_ser_4_4_5;
	assign inject_zneg_ser_4_4_4=eject_zpos_ser_4_4_3;
	assign inject_zpos_ser_4_4_5=eject_zneg_ser_4_4_6;
	assign inject_zneg_ser_4_4_5=eject_zpos_ser_4_4_4;
	assign inject_zpos_ser_4_4_6=eject_zneg_ser_4_4_7;
	assign inject_zneg_ser_4_4_6=eject_zpos_ser_4_4_5;
	assign inject_zpos_ser_4_4_7=eject_zneg_ser_4_4_0;
	assign inject_zneg_ser_4_4_7=eject_zpos_ser_4_4_6;
	assign inject_zpos_ser_4_5_0=eject_zneg_ser_4_5_1;
	assign inject_zneg_ser_4_5_0=eject_zpos_ser_4_5_7;
	assign inject_zpos_ser_4_5_1=eject_zneg_ser_4_5_2;
	assign inject_zneg_ser_4_5_1=eject_zpos_ser_4_5_0;
	assign inject_zpos_ser_4_5_2=eject_zneg_ser_4_5_3;
	assign inject_zneg_ser_4_5_2=eject_zpos_ser_4_5_1;
	assign inject_zpos_ser_4_5_3=eject_zneg_ser_4_5_4;
	assign inject_zneg_ser_4_5_3=eject_zpos_ser_4_5_2;
	assign inject_zpos_ser_4_5_4=eject_zneg_ser_4_5_5;
	assign inject_zneg_ser_4_5_4=eject_zpos_ser_4_5_3;
	assign inject_zpos_ser_4_5_5=eject_zneg_ser_4_5_6;
	assign inject_zneg_ser_4_5_5=eject_zpos_ser_4_5_4;
	assign inject_zpos_ser_4_5_6=eject_zneg_ser_4_5_7;
	assign inject_zneg_ser_4_5_6=eject_zpos_ser_4_5_5;
	assign inject_zpos_ser_4_5_7=eject_zneg_ser_4_5_0;
	assign inject_zneg_ser_4_5_7=eject_zpos_ser_4_5_6;
	assign inject_zpos_ser_4_6_0=eject_zneg_ser_4_6_1;
	assign inject_zneg_ser_4_6_0=eject_zpos_ser_4_6_7;
	assign inject_zpos_ser_4_6_1=eject_zneg_ser_4_6_2;
	assign inject_zneg_ser_4_6_1=eject_zpos_ser_4_6_0;
	assign inject_zpos_ser_4_6_2=eject_zneg_ser_4_6_3;
	assign inject_zneg_ser_4_6_2=eject_zpos_ser_4_6_1;
	assign inject_zpos_ser_4_6_3=eject_zneg_ser_4_6_4;
	assign inject_zneg_ser_4_6_3=eject_zpos_ser_4_6_2;
	assign inject_zpos_ser_4_6_4=eject_zneg_ser_4_6_5;
	assign inject_zneg_ser_4_6_4=eject_zpos_ser_4_6_3;
	assign inject_zpos_ser_4_6_5=eject_zneg_ser_4_6_6;
	assign inject_zneg_ser_4_6_5=eject_zpos_ser_4_6_4;
	assign inject_zpos_ser_4_6_6=eject_zneg_ser_4_6_7;
	assign inject_zneg_ser_4_6_6=eject_zpos_ser_4_6_5;
	assign inject_zpos_ser_4_6_7=eject_zneg_ser_4_6_0;
	assign inject_zneg_ser_4_6_7=eject_zpos_ser_4_6_6;
	assign inject_zpos_ser_4_7_0=eject_zneg_ser_4_7_1;
	assign inject_zneg_ser_4_7_0=eject_zpos_ser_4_7_7;
	assign inject_zpos_ser_4_7_1=eject_zneg_ser_4_7_2;
	assign inject_zneg_ser_4_7_1=eject_zpos_ser_4_7_0;
	assign inject_zpos_ser_4_7_2=eject_zneg_ser_4_7_3;
	assign inject_zneg_ser_4_7_2=eject_zpos_ser_4_7_1;
	assign inject_zpos_ser_4_7_3=eject_zneg_ser_4_7_4;
	assign inject_zneg_ser_4_7_3=eject_zpos_ser_4_7_2;
	assign inject_zpos_ser_4_7_4=eject_zneg_ser_4_7_5;
	assign inject_zneg_ser_4_7_4=eject_zpos_ser_4_7_3;
	assign inject_zpos_ser_4_7_5=eject_zneg_ser_4_7_6;
	assign inject_zneg_ser_4_7_5=eject_zpos_ser_4_7_4;
	assign inject_zpos_ser_4_7_6=eject_zneg_ser_4_7_7;
	assign inject_zneg_ser_4_7_6=eject_zpos_ser_4_7_5;
	assign inject_zpos_ser_4_7_7=eject_zneg_ser_4_7_0;
	assign inject_zneg_ser_4_7_7=eject_zpos_ser_4_7_6;
	assign inject_zpos_ser_5_0_0=eject_zneg_ser_5_0_1;
	assign inject_zneg_ser_5_0_0=eject_zpos_ser_5_0_7;
	assign inject_zpos_ser_5_0_1=eject_zneg_ser_5_0_2;
	assign inject_zneg_ser_5_0_1=eject_zpos_ser_5_0_0;
	assign inject_zpos_ser_5_0_2=eject_zneg_ser_5_0_3;
	assign inject_zneg_ser_5_0_2=eject_zpos_ser_5_0_1;
	assign inject_zpos_ser_5_0_3=eject_zneg_ser_5_0_4;
	assign inject_zneg_ser_5_0_3=eject_zpos_ser_5_0_2;
	assign inject_zpos_ser_5_0_4=eject_zneg_ser_5_0_5;
	assign inject_zneg_ser_5_0_4=eject_zpos_ser_5_0_3;
	assign inject_zpos_ser_5_0_5=eject_zneg_ser_5_0_6;
	assign inject_zneg_ser_5_0_5=eject_zpos_ser_5_0_4;
	assign inject_zpos_ser_5_0_6=eject_zneg_ser_5_0_7;
	assign inject_zneg_ser_5_0_6=eject_zpos_ser_5_0_5;
	assign inject_zpos_ser_5_0_7=eject_zneg_ser_5_0_0;
	assign inject_zneg_ser_5_0_7=eject_zpos_ser_5_0_6;
	assign inject_zpos_ser_5_1_0=eject_zneg_ser_5_1_1;
	assign inject_zneg_ser_5_1_0=eject_zpos_ser_5_1_7;
	assign inject_zpos_ser_5_1_1=eject_zneg_ser_5_1_2;
	assign inject_zneg_ser_5_1_1=eject_zpos_ser_5_1_0;
	assign inject_zpos_ser_5_1_2=eject_zneg_ser_5_1_3;
	assign inject_zneg_ser_5_1_2=eject_zpos_ser_5_1_1;
	assign inject_zpos_ser_5_1_3=eject_zneg_ser_5_1_4;
	assign inject_zneg_ser_5_1_3=eject_zpos_ser_5_1_2;
	assign inject_zpos_ser_5_1_4=eject_zneg_ser_5_1_5;
	assign inject_zneg_ser_5_1_4=eject_zpos_ser_5_1_3;
	assign inject_zpos_ser_5_1_5=eject_zneg_ser_5_1_6;
	assign inject_zneg_ser_5_1_5=eject_zpos_ser_5_1_4;
	assign inject_zpos_ser_5_1_6=eject_zneg_ser_5_1_7;
	assign inject_zneg_ser_5_1_6=eject_zpos_ser_5_1_5;
	assign inject_zpos_ser_5_1_7=eject_zneg_ser_5_1_0;
	assign inject_zneg_ser_5_1_7=eject_zpos_ser_5_1_6;
	assign inject_zpos_ser_5_2_0=eject_zneg_ser_5_2_1;
	assign inject_zneg_ser_5_2_0=eject_zpos_ser_5_2_7;
	assign inject_zpos_ser_5_2_1=eject_zneg_ser_5_2_2;
	assign inject_zneg_ser_5_2_1=eject_zpos_ser_5_2_0;
	assign inject_zpos_ser_5_2_2=eject_zneg_ser_5_2_3;
	assign inject_zneg_ser_5_2_2=eject_zpos_ser_5_2_1;
	assign inject_zpos_ser_5_2_3=eject_zneg_ser_5_2_4;
	assign inject_zneg_ser_5_2_3=eject_zpos_ser_5_2_2;
	assign inject_zpos_ser_5_2_4=eject_zneg_ser_5_2_5;
	assign inject_zneg_ser_5_2_4=eject_zpos_ser_5_2_3;
	assign inject_zpos_ser_5_2_5=eject_zneg_ser_5_2_6;
	assign inject_zneg_ser_5_2_5=eject_zpos_ser_5_2_4;
	assign inject_zpos_ser_5_2_6=eject_zneg_ser_5_2_7;
	assign inject_zneg_ser_5_2_6=eject_zpos_ser_5_2_5;
	assign inject_zpos_ser_5_2_7=eject_zneg_ser_5_2_0;
	assign inject_zneg_ser_5_2_7=eject_zpos_ser_5_2_6;
	assign inject_zpos_ser_5_3_0=eject_zneg_ser_5_3_1;
	assign inject_zneg_ser_5_3_0=eject_zpos_ser_5_3_7;
	assign inject_zpos_ser_5_3_1=eject_zneg_ser_5_3_2;
	assign inject_zneg_ser_5_3_1=eject_zpos_ser_5_3_0;
	assign inject_zpos_ser_5_3_2=eject_zneg_ser_5_3_3;
	assign inject_zneg_ser_5_3_2=eject_zpos_ser_5_3_1;
	assign inject_zpos_ser_5_3_3=eject_zneg_ser_5_3_4;
	assign inject_zneg_ser_5_3_3=eject_zpos_ser_5_3_2;
	assign inject_zpos_ser_5_3_4=eject_zneg_ser_5_3_5;
	assign inject_zneg_ser_5_3_4=eject_zpos_ser_5_3_3;
	assign inject_zpos_ser_5_3_5=eject_zneg_ser_5_3_6;
	assign inject_zneg_ser_5_3_5=eject_zpos_ser_5_3_4;
	assign inject_zpos_ser_5_3_6=eject_zneg_ser_5_3_7;
	assign inject_zneg_ser_5_3_6=eject_zpos_ser_5_3_5;
	assign inject_zpos_ser_5_3_7=eject_zneg_ser_5_3_0;
	assign inject_zneg_ser_5_3_7=eject_zpos_ser_5_3_6;
	assign inject_zpos_ser_5_4_0=eject_zneg_ser_5_4_1;
	assign inject_zneg_ser_5_4_0=eject_zpos_ser_5_4_7;
	assign inject_zpos_ser_5_4_1=eject_zneg_ser_5_4_2;
	assign inject_zneg_ser_5_4_1=eject_zpos_ser_5_4_0;
	assign inject_zpos_ser_5_4_2=eject_zneg_ser_5_4_3;
	assign inject_zneg_ser_5_4_2=eject_zpos_ser_5_4_1;
	assign inject_zpos_ser_5_4_3=eject_zneg_ser_5_4_4;
	assign inject_zneg_ser_5_4_3=eject_zpos_ser_5_4_2;
	assign inject_zpos_ser_5_4_4=eject_zneg_ser_5_4_5;
	assign inject_zneg_ser_5_4_4=eject_zpos_ser_5_4_3;
	assign inject_zpos_ser_5_4_5=eject_zneg_ser_5_4_6;
	assign inject_zneg_ser_5_4_5=eject_zpos_ser_5_4_4;
	assign inject_zpos_ser_5_4_6=eject_zneg_ser_5_4_7;
	assign inject_zneg_ser_5_4_6=eject_zpos_ser_5_4_5;
	assign inject_zpos_ser_5_4_7=eject_zneg_ser_5_4_0;
	assign inject_zneg_ser_5_4_7=eject_zpos_ser_5_4_6;
	assign inject_zpos_ser_5_5_0=eject_zneg_ser_5_5_1;
	assign inject_zneg_ser_5_5_0=eject_zpos_ser_5_5_7;
	assign inject_zpos_ser_5_5_1=eject_zneg_ser_5_5_2;
	assign inject_zneg_ser_5_5_1=eject_zpos_ser_5_5_0;
	assign inject_zpos_ser_5_5_2=eject_zneg_ser_5_5_3;
	assign inject_zneg_ser_5_5_2=eject_zpos_ser_5_5_1;
	assign inject_zpos_ser_5_5_3=eject_zneg_ser_5_5_4;
	assign inject_zneg_ser_5_5_3=eject_zpos_ser_5_5_2;
	assign inject_zpos_ser_5_5_4=eject_zneg_ser_5_5_5;
	assign inject_zneg_ser_5_5_4=eject_zpos_ser_5_5_3;
	assign inject_zpos_ser_5_5_5=eject_zneg_ser_5_5_6;
	assign inject_zneg_ser_5_5_5=eject_zpos_ser_5_5_4;
	assign inject_zpos_ser_5_5_6=eject_zneg_ser_5_5_7;
	assign inject_zneg_ser_5_5_6=eject_zpos_ser_5_5_5;
	assign inject_zpos_ser_5_5_7=eject_zneg_ser_5_5_0;
	assign inject_zneg_ser_5_5_7=eject_zpos_ser_5_5_6;
	assign inject_zpos_ser_5_6_0=eject_zneg_ser_5_6_1;
	assign inject_zneg_ser_5_6_0=eject_zpos_ser_5_6_7;
	assign inject_zpos_ser_5_6_1=eject_zneg_ser_5_6_2;
	assign inject_zneg_ser_5_6_1=eject_zpos_ser_5_6_0;
	assign inject_zpos_ser_5_6_2=eject_zneg_ser_5_6_3;
	assign inject_zneg_ser_5_6_2=eject_zpos_ser_5_6_1;
	assign inject_zpos_ser_5_6_3=eject_zneg_ser_5_6_4;
	assign inject_zneg_ser_5_6_3=eject_zpos_ser_5_6_2;
	assign inject_zpos_ser_5_6_4=eject_zneg_ser_5_6_5;
	assign inject_zneg_ser_5_6_4=eject_zpos_ser_5_6_3;
	assign inject_zpos_ser_5_6_5=eject_zneg_ser_5_6_6;
	assign inject_zneg_ser_5_6_5=eject_zpos_ser_5_6_4;
	assign inject_zpos_ser_5_6_6=eject_zneg_ser_5_6_7;
	assign inject_zneg_ser_5_6_6=eject_zpos_ser_5_6_5;
	assign inject_zpos_ser_5_6_7=eject_zneg_ser_5_6_0;
	assign inject_zneg_ser_5_6_7=eject_zpos_ser_5_6_6;
	assign inject_zpos_ser_5_7_0=eject_zneg_ser_5_7_1;
	assign inject_zneg_ser_5_7_0=eject_zpos_ser_5_7_7;
	assign inject_zpos_ser_5_7_1=eject_zneg_ser_5_7_2;
	assign inject_zneg_ser_5_7_1=eject_zpos_ser_5_7_0;
	assign inject_zpos_ser_5_7_2=eject_zneg_ser_5_7_3;
	assign inject_zneg_ser_5_7_2=eject_zpos_ser_5_7_1;
	assign inject_zpos_ser_5_7_3=eject_zneg_ser_5_7_4;
	assign inject_zneg_ser_5_7_3=eject_zpos_ser_5_7_2;
	assign inject_zpos_ser_5_7_4=eject_zneg_ser_5_7_5;
	assign inject_zneg_ser_5_7_4=eject_zpos_ser_5_7_3;
	assign inject_zpos_ser_5_7_5=eject_zneg_ser_5_7_6;
	assign inject_zneg_ser_5_7_5=eject_zpos_ser_5_7_4;
	assign inject_zpos_ser_5_7_6=eject_zneg_ser_5_7_7;
	assign inject_zneg_ser_5_7_6=eject_zpos_ser_5_7_5;
	assign inject_zpos_ser_5_7_7=eject_zneg_ser_5_7_0;
	assign inject_zneg_ser_5_7_7=eject_zpos_ser_5_7_6;
	assign inject_zpos_ser_6_0_0=eject_zneg_ser_6_0_1;
	assign inject_zneg_ser_6_0_0=eject_zpos_ser_6_0_7;
	assign inject_zpos_ser_6_0_1=eject_zneg_ser_6_0_2;
	assign inject_zneg_ser_6_0_1=eject_zpos_ser_6_0_0;
	assign inject_zpos_ser_6_0_2=eject_zneg_ser_6_0_3;
	assign inject_zneg_ser_6_0_2=eject_zpos_ser_6_0_1;
	assign inject_zpos_ser_6_0_3=eject_zneg_ser_6_0_4;
	assign inject_zneg_ser_6_0_3=eject_zpos_ser_6_0_2;
	assign inject_zpos_ser_6_0_4=eject_zneg_ser_6_0_5;
	assign inject_zneg_ser_6_0_4=eject_zpos_ser_6_0_3;
	assign inject_zpos_ser_6_0_5=eject_zneg_ser_6_0_6;
	assign inject_zneg_ser_6_0_5=eject_zpos_ser_6_0_4;
	assign inject_zpos_ser_6_0_6=eject_zneg_ser_6_0_7;
	assign inject_zneg_ser_6_0_6=eject_zpos_ser_6_0_5;
	assign inject_zpos_ser_6_0_7=eject_zneg_ser_6_0_0;
	assign inject_zneg_ser_6_0_7=eject_zpos_ser_6_0_6;
	assign inject_zpos_ser_6_1_0=eject_zneg_ser_6_1_1;
	assign inject_zneg_ser_6_1_0=eject_zpos_ser_6_1_7;
	assign inject_zpos_ser_6_1_1=eject_zneg_ser_6_1_2;
	assign inject_zneg_ser_6_1_1=eject_zpos_ser_6_1_0;
	assign inject_zpos_ser_6_1_2=eject_zneg_ser_6_1_3;
	assign inject_zneg_ser_6_1_2=eject_zpos_ser_6_1_1;
	assign inject_zpos_ser_6_1_3=eject_zneg_ser_6_1_4;
	assign inject_zneg_ser_6_1_3=eject_zpos_ser_6_1_2;
	assign inject_zpos_ser_6_1_4=eject_zneg_ser_6_1_5;
	assign inject_zneg_ser_6_1_4=eject_zpos_ser_6_1_3;
	assign inject_zpos_ser_6_1_5=eject_zneg_ser_6_1_6;
	assign inject_zneg_ser_6_1_5=eject_zpos_ser_6_1_4;
	assign inject_zpos_ser_6_1_6=eject_zneg_ser_6_1_7;
	assign inject_zneg_ser_6_1_6=eject_zpos_ser_6_1_5;
	assign inject_zpos_ser_6_1_7=eject_zneg_ser_6_1_0;
	assign inject_zneg_ser_6_1_7=eject_zpos_ser_6_1_6;
	assign inject_zpos_ser_6_2_0=eject_zneg_ser_6_2_1;
	assign inject_zneg_ser_6_2_0=eject_zpos_ser_6_2_7;
	assign inject_zpos_ser_6_2_1=eject_zneg_ser_6_2_2;
	assign inject_zneg_ser_6_2_1=eject_zpos_ser_6_2_0;
	assign inject_zpos_ser_6_2_2=eject_zneg_ser_6_2_3;
	assign inject_zneg_ser_6_2_2=eject_zpos_ser_6_2_1;
	assign inject_zpos_ser_6_2_3=eject_zneg_ser_6_2_4;
	assign inject_zneg_ser_6_2_3=eject_zpos_ser_6_2_2;
	assign inject_zpos_ser_6_2_4=eject_zneg_ser_6_2_5;
	assign inject_zneg_ser_6_2_4=eject_zpos_ser_6_2_3;
	assign inject_zpos_ser_6_2_5=eject_zneg_ser_6_2_6;
	assign inject_zneg_ser_6_2_5=eject_zpos_ser_6_2_4;
	assign inject_zpos_ser_6_2_6=eject_zneg_ser_6_2_7;
	assign inject_zneg_ser_6_2_6=eject_zpos_ser_6_2_5;
	assign inject_zpos_ser_6_2_7=eject_zneg_ser_6_2_0;
	assign inject_zneg_ser_6_2_7=eject_zpos_ser_6_2_6;
	assign inject_zpos_ser_6_3_0=eject_zneg_ser_6_3_1;
	assign inject_zneg_ser_6_3_0=eject_zpos_ser_6_3_7;
	assign inject_zpos_ser_6_3_1=eject_zneg_ser_6_3_2;
	assign inject_zneg_ser_6_3_1=eject_zpos_ser_6_3_0;
	assign inject_zpos_ser_6_3_2=eject_zneg_ser_6_3_3;
	assign inject_zneg_ser_6_3_2=eject_zpos_ser_6_3_1;
	assign inject_zpos_ser_6_3_3=eject_zneg_ser_6_3_4;
	assign inject_zneg_ser_6_3_3=eject_zpos_ser_6_3_2;
	assign inject_zpos_ser_6_3_4=eject_zneg_ser_6_3_5;
	assign inject_zneg_ser_6_3_4=eject_zpos_ser_6_3_3;
	assign inject_zpos_ser_6_3_5=eject_zneg_ser_6_3_6;
	assign inject_zneg_ser_6_3_5=eject_zpos_ser_6_3_4;
	assign inject_zpos_ser_6_3_6=eject_zneg_ser_6_3_7;
	assign inject_zneg_ser_6_3_6=eject_zpos_ser_6_3_5;
	assign inject_zpos_ser_6_3_7=eject_zneg_ser_6_3_0;
	assign inject_zneg_ser_6_3_7=eject_zpos_ser_6_3_6;
	assign inject_zpos_ser_6_4_0=eject_zneg_ser_6_4_1;
	assign inject_zneg_ser_6_4_0=eject_zpos_ser_6_4_7;
	assign inject_zpos_ser_6_4_1=eject_zneg_ser_6_4_2;
	assign inject_zneg_ser_6_4_1=eject_zpos_ser_6_4_0;
	assign inject_zpos_ser_6_4_2=eject_zneg_ser_6_4_3;
	assign inject_zneg_ser_6_4_2=eject_zpos_ser_6_4_1;
	assign inject_zpos_ser_6_4_3=eject_zneg_ser_6_4_4;
	assign inject_zneg_ser_6_4_3=eject_zpos_ser_6_4_2;
	assign inject_zpos_ser_6_4_4=eject_zneg_ser_6_4_5;
	assign inject_zneg_ser_6_4_4=eject_zpos_ser_6_4_3;
	assign inject_zpos_ser_6_4_5=eject_zneg_ser_6_4_6;
	assign inject_zneg_ser_6_4_5=eject_zpos_ser_6_4_4;
	assign inject_zpos_ser_6_4_6=eject_zneg_ser_6_4_7;
	assign inject_zneg_ser_6_4_6=eject_zpos_ser_6_4_5;
	assign inject_zpos_ser_6_4_7=eject_zneg_ser_6_4_0;
	assign inject_zneg_ser_6_4_7=eject_zpos_ser_6_4_6;
	assign inject_zpos_ser_6_5_0=eject_zneg_ser_6_5_1;
	assign inject_zneg_ser_6_5_0=eject_zpos_ser_6_5_7;
	assign inject_zpos_ser_6_5_1=eject_zneg_ser_6_5_2;
	assign inject_zneg_ser_6_5_1=eject_zpos_ser_6_5_0;
	assign inject_zpos_ser_6_5_2=eject_zneg_ser_6_5_3;
	assign inject_zneg_ser_6_5_2=eject_zpos_ser_6_5_1;
	assign inject_zpos_ser_6_5_3=eject_zneg_ser_6_5_4;
	assign inject_zneg_ser_6_5_3=eject_zpos_ser_6_5_2;
	assign inject_zpos_ser_6_5_4=eject_zneg_ser_6_5_5;
	assign inject_zneg_ser_6_5_4=eject_zpos_ser_6_5_3;
	assign inject_zpos_ser_6_5_5=eject_zneg_ser_6_5_6;
	assign inject_zneg_ser_6_5_5=eject_zpos_ser_6_5_4;
	assign inject_zpos_ser_6_5_6=eject_zneg_ser_6_5_7;
	assign inject_zneg_ser_6_5_6=eject_zpos_ser_6_5_5;
	assign inject_zpos_ser_6_5_7=eject_zneg_ser_6_5_0;
	assign inject_zneg_ser_6_5_7=eject_zpos_ser_6_5_6;
	assign inject_zpos_ser_6_6_0=eject_zneg_ser_6_6_1;
	assign inject_zneg_ser_6_6_0=eject_zpos_ser_6_6_7;
	assign inject_zpos_ser_6_6_1=eject_zneg_ser_6_6_2;
	assign inject_zneg_ser_6_6_1=eject_zpos_ser_6_6_0;
	assign inject_zpos_ser_6_6_2=eject_zneg_ser_6_6_3;
	assign inject_zneg_ser_6_6_2=eject_zpos_ser_6_6_1;
	assign inject_zpos_ser_6_6_3=eject_zneg_ser_6_6_4;
	assign inject_zneg_ser_6_6_3=eject_zpos_ser_6_6_2;
	assign inject_zpos_ser_6_6_4=eject_zneg_ser_6_6_5;
	assign inject_zneg_ser_6_6_4=eject_zpos_ser_6_6_3;
	assign inject_zpos_ser_6_6_5=eject_zneg_ser_6_6_6;
	assign inject_zneg_ser_6_6_5=eject_zpos_ser_6_6_4;
	assign inject_zpos_ser_6_6_6=eject_zneg_ser_6_6_7;
	assign inject_zneg_ser_6_6_6=eject_zpos_ser_6_6_5;
	assign inject_zpos_ser_6_6_7=eject_zneg_ser_6_6_0;
	assign inject_zneg_ser_6_6_7=eject_zpos_ser_6_6_6;
	assign inject_zpos_ser_6_7_0=eject_zneg_ser_6_7_1;
	assign inject_zneg_ser_6_7_0=eject_zpos_ser_6_7_7;
	assign inject_zpos_ser_6_7_1=eject_zneg_ser_6_7_2;
	assign inject_zneg_ser_6_7_1=eject_zpos_ser_6_7_0;
	assign inject_zpos_ser_6_7_2=eject_zneg_ser_6_7_3;
	assign inject_zneg_ser_6_7_2=eject_zpos_ser_6_7_1;
	assign inject_zpos_ser_6_7_3=eject_zneg_ser_6_7_4;
	assign inject_zneg_ser_6_7_3=eject_zpos_ser_6_7_2;
	assign inject_zpos_ser_6_7_4=eject_zneg_ser_6_7_5;
	assign inject_zneg_ser_6_7_4=eject_zpos_ser_6_7_3;
	assign inject_zpos_ser_6_7_5=eject_zneg_ser_6_7_6;
	assign inject_zneg_ser_6_7_5=eject_zpos_ser_6_7_4;
	assign inject_zpos_ser_6_7_6=eject_zneg_ser_6_7_7;
	assign inject_zneg_ser_6_7_6=eject_zpos_ser_6_7_5;
	assign inject_zpos_ser_6_7_7=eject_zneg_ser_6_7_0;
	assign inject_zneg_ser_6_7_7=eject_zpos_ser_6_7_6;
	assign inject_zpos_ser_7_0_0=eject_zneg_ser_7_0_1;
	assign inject_zneg_ser_7_0_0=eject_zpos_ser_7_0_7;
	assign inject_zpos_ser_7_0_1=eject_zneg_ser_7_0_2;
	assign inject_zneg_ser_7_0_1=eject_zpos_ser_7_0_0;
	assign inject_zpos_ser_7_0_2=eject_zneg_ser_7_0_3;
	assign inject_zneg_ser_7_0_2=eject_zpos_ser_7_0_1;
	assign inject_zpos_ser_7_0_3=eject_zneg_ser_7_0_4;
	assign inject_zneg_ser_7_0_3=eject_zpos_ser_7_0_2;
	assign inject_zpos_ser_7_0_4=eject_zneg_ser_7_0_5;
	assign inject_zneg_ser_7_0_4=eject_zpos_ser_7_0_3;
	assign inject_zpos_ser_7_0_5=eject_zneg_ser_7_0_6;
	assign inject_zneg_ser_7_0_5=eject_zpos_ser_7_0_4;
	assign inject_zpos_ser_7_0_6=eject_zneg_ser_7_0_7;
	assign inject_zneg_ser_7_0_6=eject_zpos_ser_7_0_5;
	assign inject_zpos_ser_7_0_7=eject_zneg_ser_7_0_0;
	assign inject_zneg_ser_7_0_7=eject_zpos_ser_7_0_6;
	assign inject_zpos_ser_7_1_0=eject_zneg_ser_7_1_1;
	assign inject_zneg_ser_7_1_0=eject_zpos_ser_7_1_7;
	assign inject_zpos_ser_7_1_1=eject_zneg_ser_7_1_2;
	assign inject_zneg_ser_7_1_1=eject_zpos_ser_7_1_0;
	assign inject_zpos_ser_7_1_2=eject_zneg_ser_7_1_3;
	assign inject_zneg_ser_7_1_2=eject_zpos_ser_7_1_1;
	assign inject_zpos_ser_7_1_3=eject_zneg_ser_7_1_4;
	assign inject_zneg_ser_7_1_3=eject_zpos_ser_7_1_2;
	assign inject_zpos_ser_7_1_4=eject_zneg_ser_7_1_5;
	assign inject_zneg_ser_7_1_4=eject_zpos_ser_7_1_3;
	assign inject_zpos_ser_7_1_5=eject_zneg_ser_7_1_6;
	assign inject_zneg_ser_7_1_5=eject_zpos_ser_7_1_4;
	assign inject_zpos_ser_7_1_6=eject_zneg_ser_7_1_7;
	assign inject_zneg_ser_7_1_6=eject_zpos_ser_7_1_5;
	assign inject_zpos_ser_7_1_7=eject_zneg_ser_7_1_0;
	assign inject_zneg_ser_7_1_7=eject_zpos_ser_7_1_6;
	assign inject_zpos_ser_7_2_0=eject_zneg_ser_7_2_1;
	assign inject_zneg_ser_7_2_0=eject_zpos_ser_7_2_7;
	assign inject_zpos_ser_7_2_1=eject_zneg_ser_7_2_2;
	assign inject_zneg_ser_7_2_1=eject_zpos_ser_7_2_0;
	assign inject_zpos_ser_7_2_2=eject_zneg_ser_7_2_3;
	assign inject_zneg_ser_7_2_2=eject_zpos_ser_7_2_1;
	assign inject_zpos_ser_7_2_3=eject_zneg_ser_7_2_4;
	assign inject_zneg_ser_7_2_3=eject_zpos_ser_7_2_2;
	assign inject_zpos_ser_7_2_4=eject_zneg_ser_7_2_5;
	assign inject_zneg_ser_7_2_4=eject_zpos_ser_7_2_3;
	assign inject_zpos_ser_7_2_5=eject_zneg_ser_7_2_6;
	assign inject_zneg_ser_7_2_5=eject_zpos_ser_7_2_4;
	assign inject_zpos_ser_7_2_6=eject_zneg_ser_7_2_7;
	assign inject_zneg_ser_7_2_6=eject_zpos_ser_7_2_5;
	assign inject_zpos_ser_7_2_7=eject_zneg_ser_7_2_0;
	assign inject_zneg_ser_7_2_7=eject_zpos_ser_7_2_6;
	assign inject_zpos_ser_7_3_0=eject_zneg_ser_7_3_1;
	assign inject_zneg_ser_7_3_0=eject_zpos_ser_7_3_7;
	assign inject_zpos_ser_7_3_1=eject_zneg_ser_7_3_2;
	assign inject_zneg_ser_7_3_1=eject_zpos_ser_7_3_0;
	assign inject_zpos_ser_7_3_2=eject_zneg_ser_7_3_3;
	assign inject_zneg_ser_7_3_2=eject_zpos_ser_7_3_1;
	assign inject_zpos_ser_7_3_3=eject_zneg_ser_7_3_4;
	assign inject_zneg_ser_7_3_3=eject_zpos_ser_7_3_2;
	assign inject_zpos_ser_7_3_4=eject_zneg_ser_7_3_5;
	assign inject_zneg_ser_7_3_4=eject_zpos_ser_7_3_3;
	assign inject_zpos_ser_7_3_5=eject_zneg_ser_7_3_6;
	assign inject_zneg_ser_7_3_5=eject_zpos_ser_7_3_4;
	assign inject_zpos_ser_7_3_6=eject_zneg_ser_7_3_7;
	assign inject_zneg_ser_7_3_6=eject_zpos_ser_7_3_5;
	assign inject_zpos_ser_7_3_7=eject_zneg_ser_7_3_0;
	assign inject_zneg_ser_7_3_7=eject_zpos_ser_7_3_6;
	assign inject_zpos_ser_7_4_0=eject_zneg_ser_7_4_1;
	assign inject_zneg_ser_7_4_0=eject_zpos_ser_7_4_7;
	assign inject_zpos_ser_7_4_1=eject_zneg_ser_7_4_2;
	assign inject_zneg_ser_7_4_1=eject_zpos_ser_7_4_0;
	assign inject_zpos_ser_7_4_2=eject_zneg_ser_7_4_3;
	assign inject_zneg_ser_7_4_2=eject_zpos_ser_7_4_1;
	assign inject_zpos_ser_7_4_3=eject_zneg_ser_7_4_4;
	assign inject_zneg_ser_7_4_3=eject_zpos_ser_7_4_2;
	assign inject_zpos_ser_7_4_4=eject_zneg_ser_7_4_5;
	assign inject_zneg_ser_7_4_4=eject_zpos_ser_7_4_3;
	assign inject_zpos_ser_7_4_5=eject_zneg_ser_7_4_6;
	assign inject_zneg_ser_7_4_5=eject_zpos_ser_7_4_4;
	assign inject_zpos_ser_7_4_6=eject_zneg_ser_7_4_7;
	assign inject_zneg_ser_7_4_6=eject_zpos_ser_7_4_5;
	assign inject_zpos_ser_7_4_7=eject_zneg_ser_7_4_0;
	assign inject_zneg_ser_7_4_7=eject_zpos_ser_7_4_6;
	assign inject_zpos_ser_7_5_0=eject_zneg_ser_7_5_1;
	assign inject_zneg_ser_7_5_0=eject_zpos_ser_7_5_7;
	assign inject_zpos_ser_7_5_1=eject_zneg_ser_7_5_2;
	assign inject_zneg_ser_7_5_1=eject_zpos_ser_7_5_0;
	assign inject_zpos_ser_7_5_2=eject_zneg_ser_7_5_3;
	assign inject_zneg_ser_7_5_2=eject_zpos_ser_7_5_1;
	assign inject_zpos_ser_7_5_3=eject_zneg_ser_7_5_4;
	assign inject_zneg_ser_7_5_3=eject_zpos_ser_7_5_2;
	assign inject_zpos_ser_7_5_4=eject_zneg_ser_7_5_5;
	assign inject_zneg_ser_7_5_4=eject_zpos_ser_7_5_3;
	assign inject_zpos_ser_7_5_5=eject_zneg_ser_7_5_6;
	assign inject_zneg_ser_7_5_5=eject_zpos_ser_7_5_4;
	assign inject_zpos_ser_7_5_6=eject_zneg_ser_7_5_7;
	assign inject_zneg_ser_7_5_6=eject_zpos_ser_7_5_5;
	assign inject_zpos_ser_7_5_7=eject_zneg_ser_7_5_0;
	assign inject_zneg_ser_7_5_7=eject_zpos_ser_7_5_6;
	assign inject_zpos_ser_7_6_0=eject_zneg_ser_7_6_1;
	assign inject_zneg_ser_7_6_0=eject_zpos_ser_7_6_7;
	assign inject_zpos_ser_7_6_1=eject_zneg_ser_7_6_2;
	assign inject_zneg_ser_7_6_1=eject_zpos_ser_7_6_0;
	assign inject_zpos_ser_7_6_2=eject_zneg_ser_7_6_3;
	assign inject_zneg_ser_7_6_2=eject_zpos_ser_7_6_1;
	assign inject_zpos_ser_7_6_3=eject_zneg_ser_7_6_4;
	assign inject_zneg_ser_7_6_3=eject_zpos_ser_7_6_2;
	assign inject_zpos_ser_7_6_4=eject_zneg_ser_7_6_5;
	assign inject_zneg_ser_7_6_4=eject_zpos_ser_7_6_3;
	assign inject_zpos_ser_7_6_5=eject_zneg_ser_7_6_6;
	assign inject_zneg_ser_7_6_5=eject_zpos_ser_7_6_4;
	assign inject_zpos_ser_7_6_6=eject_zneg_ser_7_6_7;
	assign inject_zneg_ser_7_6_6=eject_zpos_ser_7_6_5;
	assign inject_zpos_ser_7_6_7=eject_zneg_ser_7_6_0;
	assign inject_zneg_ser_7_6_7=eject_zpos_ser_7_6_6;
	assign inject_zpos_ser_7_7_0=eject_zneg_ser_7_7_1;
	assign inject_zneg_ser_7_7_0=eject_zpos_ser_7_7_7;
	assign inject_zpos_ser_7_7_1=eject_zneg_ser_7_7_2;
	assign inject_zneg_ser_7_7_1=eject_zpos_ser_7_7_0;
	assign inject_zpos_ser_7_7_2=eject_zneg_ser_7_7_3;
	assign inject_zneg_ser_7_7_2=eject_zpos_ser_7_7_1;
	assign inject_zpos_ser_7_7_3=eject_zneg_ser_7_7_4;
	assign inject_zneg_ser_7_7_3=eject_zpos_ser_7_7_2;
	assign inject_zpos_ser_7_7_4=eject_zneg_ser_7_7_5;
	assign inject_zneg_ser_7_7_4=eject_zpos_ser_7_7_3;
	assign inject_zpos_ser_7_7_5=eject_zneg_ser_7_7_6;
	assign inject_zneg_ser_7_7_5=eject_zpos_ser_7_7_4;
	assign inject_zpos_ser_7_7_6=eject_zneg_ser_7_7_7;
	assign inject_zneg_ser_7_7_6=eject_zpos_ser_7_7_5;
	assign inject_zpos_ser_7_7_7=eject_zneg_ser_7_7_0;
	assign inject_zneg_ser_7_7_7=eject_zpos_ser_7_7_6;
    node#(
        .X(0),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_0_7),
        .eject_xpos_ser(eject_xpos_ser_0_0_7),
        .inject_xneg_ser(inject_xneg_ser_0_0_7),
        .eject_xneg_ser(eject_xneg_ser_0_0_7),
        .inject_ypos_ser(inject_ypos_ser_0_0_7),
        .eject_ypos_ser(eject_ypos_ser_0_0_7),
        .inject_yneg_ser(inject_yneg_ser_0_0_7),
        .eject_yneg_ser(eject_yneg_ser_0_0_7),
        .inject_zpos_ser(inject_zpos_ser_0_0_7),
        .eject_zpos_ser(eject_zpos_ser_0_0_7),
        .inject_zneg_ser(inject_zneg_ser_0_0_7),
        .eject_zneg_ser(eject_zneg_ser_0_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_0_7)
);
    node#(
        .X(0),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_1_7),
        .eject_xpos_ser(eject_xpos_ser_0_1_7),
        .inject_xneg_ser(inject_xneg_ser_0_1_7),
        .eject_xneg_ser(eject_xneg_ser_0_1_7),
        .inject_ypos_ser(inject_ypos_ser_0_1_7),
        .eject_ypos_ser(eject_ypos_ser_0_1_7),
        .inject_yneg_ser(inject_yneg_ser_0_1_7),
        .eject_yneg_ser(eject_yneg_ser_0_1_7),
        .inject_zpos_ser(inject_zpos_ser_0_1_7),
        .eject_zpos_ser(eject_zpos_ser_0_1_7),
        .inject_zneg_ser(inject_zneg_ser_0_1_7),
        .eject_zneg_ser(eject_zneg_ser_0_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_1_7)
);
    node#(
        .X(0),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_2_7),
        .eject_xpos_ser(eject_xpos_ser_0_2_7),
        .inject_xneg_ser(inject_xneg_ser_0_2_7),
        .eject_xneg_ser(eject_xneg_ser_0_2_7),
        .inject_ypos_ser(inject_ypos_ser_0_2_7),
        .eject_ypos_ser(eject_ypos_ser_0_2_7),
        .inject_yneg_ser(inject_yneg_ser_0_2_7),
        .eject_yneg_ser(eject_yneg_ser_0_2_7),
        .inject_zpos_ser(inject_zpos_ser_0_2_7),
        .eject_zpos_ser(eject_zpos_ser_0_2_7),
        .inject_zneg_ser(inject_zneg_ser_0_2_7),
        .eject_zneg_ser(eject_zneg_ser_0_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_2_7)
);
    node#(
        .X(0),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_3_7),
        .eject_xpos_ser(eject_xpos_ser_0_3_7),
        .inject_xneg_ser(inject_xneg_ser_0_3_7),
        .eject_xneg_ser(eject_xneg_ser_0_3_7),
        .inject_ypos_ser(inject_ypos_ser_0_3_7),
        .eject_ypos_ser(eject_ypos_ser_0_3_7),
        .inject_yneg_ser(inject_yneg_ser_0_3_7),
        .eject_yneg_ser(eject_yneg_ser_0_3_7),
        .inject_zpos_ser(inject_zpos_ser_0_3_7),
        .eject_zpos_ser(eject_zpos_ser_0_3_7),
        .inject_zneg_ser(inject_zneg_ser_0_3_7),
        .eject_zneg_ser(eject_zneg_ser_0_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_3_7)
);
    node#(
        .X(0),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_4_7),
        .eject_xpos_ser(eject_xpos_ser_0_4_7),
        .inject_xneg_ser(inject_xneg_ser_0_4_7),
        .eject_xneg_ser(eject_xneg_ser_0_4_7),
        .inject_ypos_ser(inject_ypos_ser_0_4_7),
        .eject_ypos_ser(eject_ypos_ser_0_4_7),
        .inject_yneg_ser(inject_yneg_ser_0_4_7),
        .eject_yneg_ser(eject_yneg_ser_0_4_7),
        .inject_zpos_ser(inject_zpos_ser_0_4_7),
        .eject_zpos_ser(eject_zpos_ser_0_4_7),
        .inject_zneg_ser(inject_zneg_ser_0_4_7),
        .eject_zneg_ser(eject_zneg_ser_0_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_4_7)
);
    node#(
        .X(0),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_5_7),
        .eject_xpos_ser(eject_xpos_ser_0_5_7),
        .inject_xneg_ser(inject_xneg_ser_0_5_7),
        .eject_xneg_ser(eject_xneg_ser_0_5_7),
        .inject_ypos_ser(inject_ypos_ser_0_5_7),
        .eject_ypos_ser(eject_ypos_ser_0_5_7),
        .inject_yneg_ser(inject_yneg_ser_0_5_7),
        .eject_yneg_ser(eject_yneg_ser_0_5_7),
        .inject_zpos_ser(inject_zpos_ser_0_5_7),
        .eject_zpos_ser(eject_zpos_ser_0_5_7),
        .inject_zneg_ser(inject_zneg_ser_0_5_7),
        .eject_zneg_ser(eject_zneg_ser_0_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_5_7)
);
    node#(
        .X(0),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_6_7),
        .eject_xpos_ser(eject_xpos_ser_0_6_7),
        .inject_xneg_ser(inject_xneg_ser_0_6_7),
        .eject_xneg_ser(eject_xneg_ser_0_6_7),
        .inject_ypos_ser(inject_ypos_ser_0_6_7),
        .eject_ypos_ser(eject_ypos_ser_0_6_7),
        .inject_yneg_ser(inject_yneg_ser_0_6_7),
        .eject_yneg_ser(eject_yneg_ser_0_6_7),
        .inject_zpos_ser(inject_zpos_ser_0_6_7),
        .eject_zpos_ser(eject_zpos_ser_0_6_7),
        .inject_zneg_ser(inject_zneg_ser_0_6_7),
        .eject_zneg_ser(eject_zneg_ser_0_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_6_7)
);
    node#(
        .X(0),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_0_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_7_7),
        .eject_xpos_ser(eject_xpos_ser_0_7_7),
        .inject_xneg_ser(inject_xneg_ser_0_7_7),
        .eject_xneg_ser(eject_xneg_ser_0_7_7),
        .inject_ypos_ser(inject_ypos_ser_0_7_7),
        .eject_ypos_ser(eject_ypos_ser_0_7_7),
        .inject_yneg_ser(inject_yneg_ser_0_7_7),
        .eject_yneg_ser(eject_yneg_ser_0_7_7),
        .inject_zpos_ser(inject_zpos_ser_0_7_7),
        .eject_zpos_ser(eject_zpos_ser_0_7_7),
        .inject_zneg_ser(inject_zneg_ser_0_7_7),
        .eject_zneg_ser(eject_zneg_ser_0_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_0_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_0_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_0_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_0_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_0_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_0_7_7)
);
    node#(
        .X(1),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_0_7),
        .eject_xpos_ser(eject_xpos_ser_1_0_7),
        .inject_xneg_ser(inject_xneg_ser_1_0_7),
        .eject_xneg_ser(eject_xneg_ser_1_0_7),
        .inject_ypos_ser(inject_ypos_ser_1_0_7),
        .eject_ypos_ser(eject_ypos_ser_1_0_7),
        .inject_yneg_ser(inject_yneg_ser_1_0_7),
        .eject_yneg_ser(eject_yneg_ser_1_0_7),
        .inject_zpos_ser(inject_zpos_ser_1_0_7),
        .eject_zpos_ser(eject_zpos_ser_1_0_7),
        .inject_zneg_ser(inject_zneg_ser_1_0_7),
        .eject_zneg_ser(eject_zneg_ser_1_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_0_7)
);
    node#(
        .X(1),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_1_7),
        .eject_xpos_ser(eject_xpos_ser_1_1_7),
        .inject_xneg_ser(inject_xneg_ser_1_1_7),
        .eject_xneg_ser(eject_xneg_ser_1_1_7),
        .inject_ypos_ser(inject_ypos_ser_1_1_7),
        .eject_ypos_ser(eject_ypos_ser_1_1_7),
        .inject_yneg_ser(inject_yneg_ser_1_1_7),
        .eject_yneg_ser(eject_yneg_ser_1_1_7),
        .inject_zpos_ser(inject_zpos_ser_1_1_7),
        .eject_zpos_ser(eject_zpos_ser_1_1_7),
        .inject_zneg_ser(inject_zneg_ser_1_1_7),
        .eject_zneg_ser(eject_zneg_ser_1_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_1_7)
);
    node#(
        .X(1),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_2_7),
        .eject_xpos_ser(eject_xpos_ser_1_2_7),
        .inject_xneg_ser(inject_xneg_ser_1_2_7),
        .eject_xneg_ser(eject_xneg_ser_1_2_7),
        .inject_ypos_ser(inject_ypos_ser_1_2_7),
        .eject_ypos_ser(eject_ypos_ser_1_2_7),
        .inject_yneg_ser(inject_yneg_ser_1_2_7),
        .eject_yneg_ser(eject_yneg_ser_1_2_7),
        .inject_zpos_ser(inject_zpos_ser_1_2_7),
        .eject_zpos_ser(eject_zpos_ser_1_2_7),
        .inject_zneg_ser(inject_zneg_ser_1_2_7),
        .eject_zneg_ser(eject_zneg_ser_1_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_2_7)
);
    node#(
        .X(1),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_3_7),
        .eject_xpos_ser(eject_xpos_ser_1_3_7),
        .inject_xneg_ser(inject_xneg_ser_1_3_7),
        .eject_xneg_ser(eject_xneg_ser_1_3_7),
        .inject_ypos_ser(inject_ypos_ser_1_3_7),
        .eject_ypos_ser(eject_ypos_ser_1_3_7),
        .inject_yneg_ser(inject_yneg_ser_1_3_7),
        .eject_yneg_ser(eject_yneg_ser_1_3_7),
        .inject_zpos_ser(inject_zpos_ser_1_3_7),
        .eject_zpos_ser(eject_zpos_ser_1_3_7),
        .inject_zneg_ser(inject_zneg_ser_1_3_7),
        .eject_zneg_ser(eject_zneg_ser_1_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_3_7)
);
    node#(
        .X(1),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_4_7),
        .eject_xpos_ser(eject_xpos_ser_1_4_7),
        .inject_xneg_ser(inject_xneg_ser_1_4_7),
        .eject_xneg_ser(eject_xneg_ser_1_4_7),
        .inject_ypos_ser(inject_ypos_ser_1_4_7),
        .eject_ypos_ser(eject_ypos_ser_1_4_7),
        .inject_yneg_ser(inject_yneg_ser_1_4_7),
        .eject_yneg_ser(eject_yneg_ser_1_4_7),
        .inject_zpos_ser(inject_zpos_ser_1_4_7),
        .eject_zpos_ser(eject_zpos_ser_1_4_7),
        .inject_zneg_ser(inject_zneg_ser_1_4_7),
        .eject_zneg_ser(eject_zneg_ser_1_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_4_7)
);
    node#(
        .X(1),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_5_7),
        .eject_xpos_ser(eject_xpos_ser_1_5_7),
        .inject_xneg_ser(inject_xneg_ser_1_5_7),
        .eject_xneg_ser(eject_xneg_ser_1_5_7),
        .inject_ypos_ser(inject_ypos_ser_1_5_7),
        .eject_ypos_ser(eject_ypos_ser_1_5_7),
        .inject_yneg_ser(inject_yneg_ser_1_5_7),
        .eject_yneg_ser(eject_yneg_ser_1_5_7),
        .inject_zpos_ser(inject_zpos_ser_1_5_7),
        .eject_zpos_ser(eject_zpos_ser_1_5_7),
        .inject_zneg_ser(inject_zneg_ser_1_5_7),
        .eject_zneg_ser(eject_zneg_ser_1_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_5_7)
);
    node#(
        .X(1),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_6_7),
        .eject_xpos_ser(eject_xpos_ser_1_6_7),
        .inject_xneg_ser(inject_xneg_ser_1_6_7),
        .eject_xneg_ser(eject_xneg_ser_1_6_7),
        .inject_ypos_ser(inject_ypos_ser_1_6_7),
        .eject_ypos_ser(eject_ypos_ser_1_6_7),
        .inject_yneg_ser(inject_yneg_ser_1_6_7),
        .eject_yneg_ser(eject_yneg_ser_1_6_7),
        .inject_zpos_ser(inject_zpos_ser_1_6_7),
        .eject_zpos_ser(eject_zpos_ser_1_6_7),
        .inject_zneg_ser(inject_zneg_ser_1_6_7),
        .eject_zneg_ser(eject_zneg_ser_1_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_6_7)
);
    node#(
        .X(1),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_1_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_7_7),
        .eject_xpos_ser(eject_xpos_ser_1_7_7),
        .inject_xneg_ser(inject_xneg_ser_1_7_7),
        .eject_xneg_ser(eject_xneg_ser_1_7_7),
        .inject_ypos_ser(inject_ypos_ser_1_7_7),
        .eject_ypos_ser(eject_ypos_ser_1_7_7),
        .inject_yneg_ser(inject_yneg_ser_1_7_7),
        .eject_yneg_ser(eject_yneg_ser_1_7_7),
        .inject_zpos_ser(inject_zpos_ser_1_7_7),
        .eject_zpos_ser(eject_zpos_ser_1_7_7),
        .inject_zneg_ser(inject_zneg_ser_1_7_7),
        .eject_zneg_ser(eject_zneg_ser_1_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_1_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_1_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_1_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_1_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_1_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_1_7_7)
);
    node#(
        .X(2),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_0_7),
        .eject_xpos_ser(eject_xpos_ser_2_0_7),
        .inject_xneg_ser(inject_xneg_ser_2_0_7),
        .eject_xneg_ser(eject_xneg_ser_2_0_7),
        .inject_ypos_ser(inject_ypos_ser_2_0_7),
        .eject_ypos_ser(eject_ypos_ser_2_0_7),
        .inject_yneg_ser(inject_yneg_ser_2_0_7),
        .eject_yneg_ser(eject_yneg_ser_2_0_7),
        .inject_zpos_ser(inject_zpos_ser_2_0_7),
        .eject_zpos_ser(eject_zpos_ser_2_0_7),
        .inject_zneg_ser(inject_zneg_ser_2_0_7),
        .eject_zneg_ser(eject_zneg_ser_2_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_0_7)
);
    node#(
        .X(2),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_1_7),
        .eject_xpos_ser(eject_xpos_ser_2_1_7),
        .inject_xneg_ser(inject_xneg_ser_2_1_7),
        .eject_xneg_ser(eject_xneg_ser_2_1_7),
        .inject_ypos_ser(inject_ypos_ser_2_1_7),
        .eject_ypos_ser(eject_ypos_ser_2_1_7),
        .inject_yneg_ser(inject_yneg_ser_2_1_7),
        .eject_yneg_ser(eject_yneg_ser_2_1_7),
        .inject_zpos_ser(inject_zpos_ser_2_1_7),
        .eject_zpos_ser(eject_zpos_ser_2_1_7),
        .inject_zneg_ser(inject_zneg_ser_2_1_7),
        .eject_zneg_ser(eject_zneg_ser_2_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_1_7)
);
    node#(
        .X(2),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_2_7),
        .eject_xpos_ser(eject_xpos_ser_2_2_7),
        .inject_xneg_ser(inject_xneg_ser_2_2_7),
        .eject_xneg_ser(eject_xneg_ser_2_2_7),
        .inject_ypos_ser(inject_ypos_ser_2_2_7),
        .eject_ypos_ser(eject_ypos_ser_2_2_7),
        .inject_yneg_ser(inject_yneg_ser_2_2_7),
        .eject_yneg_ser(eject_yneg_ser_2_2_7),
        .inject_zpos_ser(inject_zpos_ser_2_2_7),
        .eject_zpos_ser(eject_zpos_ser_2_2_7),
        .inject_zneg_ser(inject_zneg_ser_2_2_7),
        .eject_zneg_ser(eject_zneg_ser_2_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_2_7)
);
    node#(
        .X(2),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_3_7),
        .eject_xpos_ser(eject_xpos_ser_2_3_7),
        .inject_xneg_ser(inject_xneg_ser_2_3_7),
        .eject_xneg_ser(eject_xneg_ser_2_3_7),
        .inject_ypos_ser(inject_ypos_ser_2_3_7),
        .eject_ypos_ser(eject_ypos_ser_2_3_7),
        .inject_yneg_ser(inject_yneg_ser_2_3_7),
        .eject_yneg_ser(eject_yneg_ser_2_3_7),
        .inject_zpos_ser(inject_zpos_ser_2_3_7),
        .eject_zpos_ser(eject_zpos_ser_2_3_7),
        .inject_zneg_ser(inject_zneg_ser_2_3_7),
        .eject_zneg_ser(eject_zneg_ser_2_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_3_7)
);
    node#(
        .X(2),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_4_7),
        .eject_xpos_ser(eject_xpos_ser_2_4_7),
        .inject_xneg_ser(inject_xneg_ser_2_4_7),
        .eject_xneg_ser(eject_xneg_ser_2_4_7),
        .inject_ypos_ser(inject_ypos_ser_2_4_7),
        .eject_ypos_ser(eject_ypos_ser_2_4_7),
        .inject_yneg_ser(inject_yneg_ser_2_4_7),
        .eject_yneg_ser(eject_yneg_ser_2_4_7),
        .inject_zpos_ser(inject_zpos_ser_2_4_7),
        .eject_zpos_ser(eject_zpos_ser_2_4_7),
        .inject_zneg_ser(inject_zneg_ser_2_4_7),
        .eject_zneg_ser(eject_zneg_ser_2_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_4_7)
);
    node#(
        .X(2),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_5_7),
        .eject_xpos_ser(eject_xpos_ser_2_5_7),
        .inject_xneg_ser(inject_xneg_ser_2_5_7),
        .eject_xneg_ser(eject_xneg_ser_2_5_7),
        .inject_ypos_ser(inject_ypos_ser_2_5_7),
        .eject_ypos_ser(eject_ypos_ser_2_5_7),
        .inject_yneg_ser(inject_yneg_ser_2_5_7),
        .eject_yneg_ser(eject_yneg_ser_2_5_7),
        .inject_zpos_ser(inject_zpos_ser_2_5_7),
        .eject_zpos_ser(eject_zpos_ser_2_5_7),
        .inject_zneg_ser(inject_zneg_ser_2_5_7),
        .eject_zneg_ser(eject_zneg_ser_2_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_5_7)
);
    node#(
        .X(2),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_6_7),
        .eject_xpos_ser(eject_xpos_ser_2_6_7),
        .inject_xneg_ser(inject_xneg_ser_2_6_7),
        .eject_xneg_ser(eject_xneg_ser_2_6_7),
        .inject_ypos_ser(inject_ypos_ser_2_6_7),
        .eject_ypos_ser(eject_ypos_ser_2_6_7),
        .inject_yneg_ser(inject_yneg_ser_2_6_7),
        .eject_yneg_ser(eject_yneg_ser_2_6_7),
        .inject_zpos_ser(inject_zpos_ser_2_6_7),
        .eject_zpos_ser(eject_zpos_ser_2_6_7),
        .inject_zneg_ser(inject_zneg_ser_2_6_7),
        .eject_zneg_ser(eject_zneg_ser_2_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_6_7)
);
    node#(
        .X(2),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_2_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_7_7),
        .eject_xpos_ser(eject_xpos_ser_2_7_7),
        .inject_xneg_ser(inject_xneg_ser_2_7_7),
        .eject_xneg_ser(eject_xneg_ser_2_7_7),
        .inject_ypos_ser(inject_ypos_ser_2_7_7),
        .eject_ypos_ser(eject_ypos_ser_2_7_7),
        .inject_yneg_ser(inject_yneg_ser_2_7_7),
        .eject_yneg_ser(eject_yneg_ser_2_7_7),
        .inject_zpos_ser(inject_zpos_ser_2_7_7),
        .eject_zpos_ser(eject_zpos_ser_2_7_7),
        .inject_zneg_ser(inject_zneg_ser_2_7_7),
        .eject_zneg_ser(eject_zneg_ser_2_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_2_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_2_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_2_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_2_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_2_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_2_7_7)
);
    node#(
        .X(3),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_0_7),
        .eject_xpos_ser(eject_xpos_ser_3_0_7),
        .inject_xneg_ser(inject_xneg_ser_3_0_7),
        .eject_xneg_ser(eject_xneg_ser_3_0_7),
        .inject_ypos_ser(inject_ypos_ser_3_0_7),
        .eject_ypos_ser(eject_ypos_ser_3_0_7),
        .inject_yneg_ser(inject_yneg_ser_3_0_7),
        .eject_yneg_ser(eject_yneg_ser_3_0_7),
        .inject_zpos_ser(inject_zpos_ser_3_0_7),
        .eject_zpos_ser(eject_zpos_ser_3_0_7),
        .inject_zneg_ser(inject_zneg_ser_3_0_7),
        .eject_zneg_ser(eject_zneg_ser_3_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_0_7)
);
    node#(
        .X(3),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_1_7),
        .eject_xpos_ser(eject_xpos_ser_3_1_7),
        .inject_xneg_ser(inject_xneg_ser_3_1_7),
        .eject_xneg_ser(eject_xneg_ser_3_1_7),
        .inject_ypos_ser(inject_ypos_ser_3_1_7),
        .eject_ypos_ser(eject_ypos_ser_3_1_7),
        .inject_yneg_ser(inject_yneg_ser_3_1_7),
        .eject_yneg_ser(eject_yneg_ser_3_1_7),
        .inject_zpos_ser(inject_zpos_ser_3_1_7),
        .eject_zpos_ser(eject_zpos_ser_3_1_7),
        .inject_zneg_ser(inject_zneg_ser_3_1_7),
        .eject_zneg_ser(eject_zneg_ser_3_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_1_7)
);
    node#(
        .X(3),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_2_7),
        .eject_xpos_ser(eject_xpos_ser_3_2_7),
        .inject_xneg_ser(inject_xneg_ser_3_2_7),
        .eject_xneg_ser(eject_xneg_ser_3_2_7),
        .inject_ypos_ser(inject_ypos_ser_3_2_7),
        .eject_ypos_ser(eject_ypos_ser_3_2_7),
        .inject_yneg_ser(inject_yneg_ser_3_2_7),
        .eject_yneg_ser(eject_yneg_ser_3_2_7),
        .inject_zpos_ser(inject_zpos_ser_3_2_7),
        .eject_zpos_ser(eject_zpos_ser_3_2_7),
        .inject_zneg_ser(inject_zneg_ser_3_2_7),
        .eject_zneg_ser(eject_zneg_ser_3_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_2_7)
);
    node#(
        .X(3),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_3_7),
        .eject_xpos_ser(eject_xpos_ser_3_3_7),
        .inject_xneg_ser(inject_xneg_ser_3_3_7),
        .eject_xneg_ser(eject_xneg_ser_3_3_7),
        .inject_ypos_ser(inject_ypos_ser_3_3_7),
        .eject_ypos_ser(eject_ypos_ser_3_3_7),
        .inject_yneg_ser(inject_yneg_ser_3_3_7),
        .eject_yneg_ser(eject_yneg_ser_3_3_7),
        .inject_zpos_ser(inject_zpos_ser_3_3_7),
        .eject_zpos_ser(eject_zpos_ser_3_3_7),
        .inject_zneg_ser(inject_zneg_ser_3_3_7),
        .eject_zneg_ser(eject_zneg_ser_3_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_3_7)
);
    node#(
        .X(3),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_4_7),
        .eject_xpos_ser(eject_xpos_ser_3_4_7),
        .inject_xneg_ser(inject_xneg_ser_3_4_7),
        .eject_xneg_ser(eject_xneg_ser_3_4_7),
        .inject_ypos_ser(inject_ypos_ser_3_4_7),
        .eject_ypos_ser(eject_ypos_ser_3_4_7),
        .inject_yneg_ser(inject_yneg_ser_3_4_7),
        .eject_yneg_ser(eject_yneg_ser_3_4_7),
        .inject_zpos_ser(inject_zpos_ser_3_4_7),
        .eject_zpos_ser(eject_zpos_ser_3_4_7),
        .inject_zneg_ser(inject_zneg_ser_3_4_7),
        .eject_zneg_ser(eject_zneg_ser_3_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_4_7)
);
    node#(
        .X(3),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_5_7),
        .eject_xpos_ser(eject_xpos_ser_3_5_7),
        .inject_xneg_ser(inject_xneg_ser_3_5_7),
        .eject_xneg_ser(eject_xneg_ser_3_5_7),
        .inject_ypos_ser(inject_ypos_ser_3_5_7),
        .eject_ypos_ser(eject_ypos_ser_3_5_7),
        .inject_yneg_ser(inject_yneg_ser_3_5_7),
        .eject_yneg_ser(eject_yneg_ser_3_5_7),
        .inject_zpos_ser(inject_zpos_ser_3_5_7),
        .eject_zpos_ser(eject_zpos_ser_3_5_7),
        .inject_zneg_ser(inject_zneg_ser_3_5_7),
        .eject_zneg_ser(eject_zneg_ser_3_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_5_7)
);
    node#(
        .X(3),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_6_7),
        .eject_xpos_ser(eject_xpos_ser_3_6_7),
        .inject_xneg_ser(inject_xneg_ser_3_6_7),
        .eject_xneg_ser(eject_xneg_ser_3_6_7),
        .inject_ypos_ser(inject_ypos_ser_3_6_7),
        .eject_ypos_ser(eject_ypos_ser_3_6_7),
        .inject_yneg_ser(inject_yneg_ser_3_6_7),
        .eject_yneg_ser(eject_yneg_ser_3_6_7),
        .inject_zpos_ser(inject_zpos_ser_3_6_7),
        .eject_zpos_ser(eject_zpos_ser_3_6_7),
        .inject_zneg_ser(inject_zneg_ser_3_6_7),
        .eject_zneg_ser(eject_zneg_ser_3_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_6_7)
);
    node#(
        .X(3),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_3_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_7_7),
        .eject_xpos_ser(eject_xpos_ser_3_7_7),
        .inject_xneg_ser(inject_xneg_ser_3_7_7),
        .eject_xneg_ser(eject_xneg_ser_3_7_7),
        .inject_ypos_ser(inject_ypos_ser_3_7_7),
        .eject_ypos_ser(eject_ypos_ser_3_7_7),
        .inject_yneg_ser(inject_yneg_ser_3_7_7),
        .eject_yneg_ser(eject_yneg_ser_3_7_7),
        .inject_zpos_ser(inject_zpos_ser_3_7_7),
        .eject_zpos_ser(eject_zpos_ser_3_7_7),
        .inject_zneg_ser(inject_zneg_ser_3_7_7),
        .eject_zneg_ser(eject_zneg_ser_3_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_3_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_3_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_3_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_3_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_3_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_3_7_7)
);
    node#(
        .X(4),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_0_7),
        .eject_xpos_ser(eject_xpos_ser_4_0_7),
        .inject_xneg_ser(inject_xneg_ser_4_0_7),
        .eject_xneg_ser(eject_xneg_ser_4_0_7),
        .inject_ypos_ser(inject_ypos_ser_4_0_7),
        .eject_ypos_ser(eject_ypos_ser_4_0_7),
        .inject_yneg_ser(inject_yneg_ser_4_0_7),
        .eject_yneg_ser(eject_yneg_ser_4_0_7),
        .inject_zpos_ser(inject_zpos_ser_4_0_7),
        .eject_zpos_ser(eject_zpos_ser_4_0_7),
        .inject_zneg_ser(inject_zneg_ser_4_0_7),
        .eject_zneg_ser(eject_zneg_ser_4_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_0_7)
);
    node#(
        .X(4),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_1_7),
        .eject_xpos_ser(eject_xpos_ser_4_1_7),
        .inject_xneg_ser(inject_xneg_ser_4_1_7),
        .eject_xneg_ser(eject_xneg_ser_4_1_7),
        .inject_ypos_ser(inject_ypos_ser_4_1_7),
        .eject_ypos_ser(eject_ypos_ser_4_1_7),
        .inject_yneg_ser(inject_yneg_ser_4_1_7),
        .eject_yneg_ser(eject_yneg_ser_4_1_7),
        .inject_zpos_ser(inject_zpos_ser_4_1_7),
        .eject_zpos_ser(eject_zpos_ser_4_1_7),
        .inject_zneg_ser(inject_zneg_ser_4_1_7),
        .eject_zneg_ser(eject_zneg_ser_4_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_1_7)
);
    node#(
        .X(4),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_2_7),
        .eject_xpos_ser(eject_xpos_ser_4_2_7),
        .inject_xneg_ser(inject_xneg_ser_4_2_7),
        .eject_xneg_ser(eject_xneg_ser_4_2_7),
        .inject_ypos_ser(inject_ypos_ser_4_2_7),
        .eject_ypos_ser(eject_ypos_ser_4_2_7),
        .inject_yneg_ser(inject_yneg_ser_4_2_7),
        .eject_yneg_ser(eject_yneg_ser_4_2_7),
        .inject_zpos_ser(inject_zpos_ser_4_2_7),
        .eject_zpos_ser(eject_zpos_ser_4_2_7),
        .inject_zneg_ser(inject_zneg_ser_4_2_7),
        .eject_zneg_ser(eject_zneg_ser_4_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_2_7)
);
    node#(
        .X(4),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_3_7),
        .eject_xpos_ser(eject_xpos_ser_4_3_7),
        .inject_xneg_ser(inject_xneg_ser_4_3_7),
        .eject_xneg_ser(eject_xneg_ser_4_3_7),
        .inject_ypos_ser(inject_ypos_ser_4_3_7),
        .eject_ypos_ser(eject_ypos_ser_4_3_7),
        .inject_yneg_ser(inject_yneg_ser_4_3_7),
        .eject_yneg_ser(eject_yneg_ser_4_3_7),
        .inject_zpos_ser(inject_zpos_ser_4_3_7),
        .eject_zpos_ser(eject_zpos_ser_4_3_7),
        .inject_zneg_ser(inject_zneg_ser_4_3_7),
        .eject_zneg_ser(eject_zneg_ser_4_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_3_7)
);
    node#(
        .X(4),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_4_7),
        .eject_xpos_ser(eject_xpos_ser_4_4_7),
        .inject_xneg_ser(inject_xneg_ser_4_4_7),
        .eject_xneg_ser(eject_xneg_ser_4_4_7),
        .inject_ypos_ser(inject_ypos_ser_4_4_7),
        .eject_ypos_ser(eject_ypos_ser_4_4_7),
        .inject_yneg_ser(inject_yneg_ser_4_4_7),
        .eject_yneg_ser(eject_yneg_ser_4_4_7),
        .inject_zpos_ser(inject_zpos_ser_4_4_7),
        .eject_zpos_ser(eject_zpos_ser_4_4_7),
        .inject_zneg_ser(inject_zneg_ser_4_4_7),
        .eject_zneg_ser(eject_zneg_ser_4_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_4_7)
);
    node#(
        .X(4),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_5_7),
        .eject_xpos_ser(eject_xpos_ser_4_5_7),
        .inject_xneg_ser(inject_xneg_ser_4_5_7),
        .eject_xneg_ser(eject_xneg_ser_4_5_7),
        .inject_ypos_ser(inject_ypos_ser_4_5_7),
        .eject_ypos_ser(eject_ypos_ser_4_5_7),
        .inject_yneg_ser(inject_yneg_ser_4_5_7),
        .eject_yneg_ser(eject_yneg_ser_4_5_7),
        .inject_zpos_ser(inject_zpos_ser_4_5_7),
        .eject_zpos_ser(eject_zpos_ser_4_5_7),
        .inject_zneg_ser(inject_zneg_ser_4_5_7),
        .eject_zneg_ser(eject_zneg_ser_4_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_5_7)
);
    node#(
        .X(4),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_6_7),
        .eject_xpos_ser(eject_xpos_ser_4_6_7),
        .inject_xneg_ser(inject_xneg_ser_4_6_7),
        .eject_xneg_ser(eject_xneg_ser_4_6_7),
        .inject_ypos_ser(inject_ypos_ser_4_6_7),
        .eject_ypos_ser(eject_ypos_ser_4_6_7),
        .inject_yneg_ser(inject_yneg_ser_4_6_7),
        .eject_yneg_ser(eject_yneg_ser_4_6_7),
        .inject_zpos_ser(inject_zpos_ser_4_6_7),
        .eject_zpos_ser(eject_zpos_ser_4_6_7),
        .inject_zneg_ser(inject_zneg_ser_4_6_7),
        .eject_zneg_ser(eject_zneg_ser_4_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_6_7)
);
    node#(
        .X(4),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_4_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_4_7_7),
        .eject_xpos_ser(eject_xpos_ser_4_7_7),
        .inject_xneg_ser(inject_xneg_ser_4_7_7),
        .eject_xneg_ser(eject_xneg_ser_4_7_7),
        .inject_ypos_ser(inject_ypos_ser_4_7_7),
        .eject_ypos_ser(eject_ypos_ser_4_7_7),
        .inject_yneg_ser(inject_yneg_ser_4_7_7),
        .eject_yneg_ser(eject_yneg_ser_4_7_7),
        .inject_zpos_ser(inject_zpos_ser_4_7_7),
        .eject_zpos_ser(eject_zpos_ser_4_7_7),
        .inject_zneg_ser(inject_zneg_ser_4_7_7),
        .eject_zneg_ser(eject_zneg_ser_4_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_4_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_4_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_4_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_4_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_4_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_4_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_4_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_4_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_4_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_4_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_4_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_4_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_4_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_4_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_4_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_4_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_4_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_4_7_7)
);
    node#(
        .X(5),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_0_7),
        .eject_xpos_ser(eject_xpos_ser_5_0_7),
        .inject_xneg_ser(inject_xneg_ser_5_0_7),
        .eject_xneg_ser(eject_xneg_ser_5_0_7),
        .inject_ypos_ser(inject_ypos_ser_5_0_7),
        .eject_ypos_ser(eject_ypos_ser_5_0_7),
        .inject_yneg_ser(inject_yneg_ser_5_0_7),
        .eject_yneg_ser(eject_yneg_ser_5_0_7),
        .inject_zpos_ser(inject_zpos_ser_5_0_7),
        .eject_zpos_ser(eject_zpos_ser_5_0_7),
        .inject_zneg_ser(inject_zneg_ser_5_0_7),
        .eject_zneg_ser(eject_zneg_ser_5_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_0_7)
);
    node#(
        .X(5),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_1_7),
        .eject_xpos_ser(eject_xpos_ser_5_1_7),
        .inject_xneg_ser(inject_xneg_ser_5_1_7),
        .eject_xneg_ser(eject_xneg_ser_5_1_7),
        .inject_ypos_ser(inject_ypos_ser_5_1_7),
        .eject_ypos_ser(eject_ypos_ser_5_1_7),
        .inject_yneg_ser(inject_yneg_ser_5_1_7),
        .eject_yneg_ser(eject_yneg_ser_5_1_7),
        .inject_zpos_ser(inject_zpos_ser_5_1_7),
        .eject_zpos_ser(eject_zpos_ser_5_1_7),
        .inject_zneg_ser(inject_zneg_ser_5_1_7),
        .eject_zneg_ser(eject_zneg_ser_5_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_1_7)
);
    node#(
        .X(5),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_2_7),
        .eject_xpos_ser(eject_xpos_ser_5_2_7),
        .inject_xneg_ser(inject_xneg_ser_5_2_7),
        .eject_xneg_ser(eject_xneg_ser_5_2_7),
        .inject_ypos_ser(inject_ypos_ser_5_2_7),
        .eject_ypos_ser(eject_ypos_ser_5_2_7),
        .inject_yneg_ser(inject_yneg_ser_5_2_7),
        .eject_yneg_ser(eject_yneg_ser_5_2_7),
        .inject_zpos_ser(inject_zpos_ser_5_2_7),
        .eject_zpos_ser(eject_zpos_ser_5_2_7),
        .inject_zneg_ser(inject_zneg_ser_5_2_7),
        .eject_zneg_ser(eject_zneg_ser_5_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_2_7)
);
    node#(
        .X(5),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_3_7),
        .eject_xpos_ser(eject_xpos_ser_5_3_7),
        .inject_xneg_ser(inject_xneg_ser_5_3_7),
        .eject_xneg_ser(eject_xneg_ser_5_3_7),
        .inject_ypos_ser(inject_ypos_ser_5_3_7),
        .eject_ypos_ser(eject_ypos_ser_5_3_7),
        .inject_yneg_ser(inject_yneg_ser_5_3_7),
        .eject_yneg_ser(eject_yneg_ser_5_3_7),
        .inject_zpos_ser(inject_zpos_ser_5_3_7),
        .eject_zpos_ser(eject_zpos_ser_5_3_7),
        .inject_zneg_ser(inject_zneg_ser_5_3_7),
        .eject_zneg_ser(eject_zneg_ser_5_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_3_7)
);
    node#(
        .X(5),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_4_7),
        .eject_xpos_ser(eject_xpos_ser_5_4_7),
        .inject_xneg_ser(inject_xneg_ser_5_4_7),
        .eject_xneg_ser(eject_xneg_ser_5_4_7),
        .inject_ypos_ser(inject_ypos_ser_5_4_7),
        .eject_ypos_ser(eject_ypos_ser_5_4_7),
        .inject_yneg_ser(inject_yneg_ser_5_4_7),
        .eject_yneg_ser(eject_yneg_ser_5_4_7),
        .inject_zpos_ser(inject_zpos_ser_5_4_7),
        .eject_zpos_ser(eject_zpos_ser_5_4_7),
        .inject_zneg_ser(inject_zneg_ser_5_4_7),
        .eject_zneg_ser(eject_zneg_ser_5_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_4_7)
);
    node#(
        .X(5),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_5_7),
        .eject_xpos_ser(eject_xpos_ser_5_5_7),
        .inject_xneg_ser(inject_xneg_ser_5_5_7),
        .eject_xneg_ser(eject_xneg_ser_5_5_7),
        .inject_ypos_ser(inject_ypos_ser_5_5_7),
        .eject_ypos_ser(eject_ypos_ser_5_5_7),
        .inject_yneg_ser(inject_yneg_ser_5_5_7),
        .eject_yneg_ser(eject_yneg_ser_5_5_7),
        .inject_zpos_ser(inject_zpos_ser_5_5_7),
        .eject_zpos_ser(eject_zpos_ser_5_5_7),
        .inject_zneg_ser(inject_zneg_ser_5_5_7),
        .eject_zneg_ser(eject_zneg_ser_5_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_5_7)
);
    node#(
        .X(5),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_6_7),
        .eject_xpos_ser(eject_xpos_ser_5_6_7),
        .inject_xneg_ser(inject_xneg_ser_5_6_7),
        .eject_xneg_ser(eject_xneg_ser_5_6_7),
        .inject_ypos_ser(inject_ypos_ser_5_6_7),
        .eject_ypos_ser(eject_ypos_ser_5_6_7),
        .inject_yneg_ser(inject_yneg_ser_5_6_7),
        .eject_yneg_ser(eject_yneg_ser_5_6_7),
        .inject_zpos_ser(inject_zpos_ser_5_6_7),
        .eject_zpos_ser(eject_zpos_ser_5_6_7),
        .inject_zneg_ser(inject_zneg_ser_5_6_7),
        .eject_zneg_ser(eject_zneg_ser_5_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_6_7)
);
    node#(
        .X(5),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_5_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_5_7_7),
        .eject_xpos_ser(eject_xpos_ser_5_7_7),
        .inject_xneg_ser(inject_xneg_ser_5_7_7),
        .eject_xneg_ser(eject_xneg_ser_5_7_7),
        .inject_ypos_ser(inject_ypos_ser_5_7_7),
        .eject_ypos_ser(eject_ypos_ser_5_7_7),
        .inject_yneg_ser(inject_yneg_ser_5_7_7),
        .eject_yneg_ser(eject_yneg_ser_5_7_7),
        .inject_zpos_ser(inject_zpos_ser_5_7_7),
        .eject_zpos_ser(eject_zpos_ser_5_7_7),
        .inject_zneg_ser(inject_zneg_ser_5_7_7),
        .eject_zneg_ser(eject_zneg_ser_5_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_5_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_5_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_5_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_5_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_5_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_5_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_5_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_5_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_5_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_5_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_5_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_5_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_5_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_5_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_5_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_5_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_5_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_5_7_7)
);
    node#(
        .X(6),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_0_7),
        .eject_xpos_ser(eject_xpos_ser_6_0_7),
        .inject_xneg_ser(inject_xneg_ser_6_0_7),
        .eject_xneg_ser(eject_xneg_ser_6_0_7),
        .inject_ypos_ser(inject_ypos_ser_6_0_7),
        .eject_ypos_ser(eject_ypos_ser_6_0_7),
        .inject_yneg_ser(inject_yneg_ser_6_0_7),
        .eject_yneg_ser(eject_yneg_ser_6_0_7),
        .inject_zpos_ser(inject_zpos_ser_6_0_7),
        .eject_zpos_ser(eject_zpos_ser_6_0_7),
        .inject_zneg_ser(inject_zneg_ser_6_0_7),
        .eject_zneg_ser(eject_zneg_ser_6_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_0_7)
);
    node#(
        .X(6),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_1_7),
        .eject_xpos_ser(eject_xpos_ser_6_1_7),
        .inject_xneg_ser(inject_xneg_ser_6_1_7),
        .eject_xneg_ser(eject_xneg_ser_6_1_7),
        .inject_ypos_ser(inject_ypos_ser_6_1_7),
        .eject_ypos_ser(eject_ypos_ser_6_1_7),
        .inject_yneg_ser(inject_yneg_ser_6_1_7),
        .eject_yneg_ser(eject_yneg_ser_6_1_7),
        .inject_zpos_ser(inject_zpos_ser_6_1_7),
        .eject_zpos_ser(eject_zpos_ser_6_1_7),
        .inject_zneg_ser(inject_zneg_ser_6_1_7),
        .eject_zneg_ser(eject_zneg_ser_6_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_1_7)
);
    node#(
        .X(6),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_2_7),
        .eject_xpos_ser(eject_xpos_ser_6_2_7),
        .inject_xneg_ser(inject_xneg_ser_6_2_7),
        .eject_xneg_ser(eject_xneg_ser_6_2_7),
        .inject_ypos_ser(inject_ypos_ser_6_2_7),
        .eject_ypos_ser(eject_ypos_ser_6_2_7),
        .inject_yneg_ser(inject_yneg_ser_6_2_7),
        .eject_yneg_ser(eject_yneg_ser_6_2_7),
        .inject_zpos_ser(inject_zpos_ser_6_2_7),
        .eject_zpos_ser(eject_zpos_ser_6_2_7),
        .inject_zneg_ser(inject_zneg_ser_6_2_7),
        .eject_zneg_ser(eject_zneg_ser_6_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_2_7)
);
    node#(
        .X(6),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_3_7),
        .eject_xpos_ser(eject_xpos_ser_6_3_7),
        .inject_xneg_ser(inject_xneg_ser_6_3_7),
        .eject_xneg_ser(eject_xneg_ser_6_3_7),
        .inject_ypos_ser(inject_ypos_ser_6_3_7),
        .eject_ypos_ser(eject_ypos_ser_6_3_7),
        .inject_yneg_ser(inject_yneg_ser_6_3_7),
        .eject_yneg_ser(eject_yneg_ser_6_3_7),
        .inject_zpos_ser(inject_zpos_ser_6_3_7),
        .eject_zpos_ser(eject_zpos_ser_6_3_7),
        .inject_zneg_ser(inject_zneg_ser_6_3_7),
        .eject_zneg_ser(eject_zneg_ser_6_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_3_7)
);
    node#(
        .X(6),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_4_7),
        .eject_xpos_ser(eject_xpos_ser_6_4_7),
        .inject_xneg_ser(inject_xneg_ser_6_4_7),
        .eject_xneg_ser(eject_xneg_ser_6_4_7),
        .inject_ypos_ser(inject_ypos_ser_6_4_7),
        .eject_ypos_ser(eject_ypos_ser_6_4_7),
        .inject_yneg_ser(inject_yneg_ser_6_4_7),
        .eject_yneg_ser(eject_yneg_ser_6_4_7),
        .inject_zpos_ser(inject_zpos_ser_6_4_7),
        .eject_zpos_ser(eject_zpos_ser_6_4_7),
        .inject_zneg_ser(inject_zneg_ser_6_4_7),
        .eject_zneg_ser(eject_zneg_ser_6_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_4_7)
);
    node#(
        .X(6),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_5_7),
        .eject_xpos_ser(eject_xpos_ser_6_5_7),
        .inject_xneg_ser(inject_xneg_ser_6_5_7),
        .eject_xneg_ser(eject_xneg_ser_6_5_7),
        .inject_ypos_ser(inject_ypos_ser_6_5_7),
        .eject_ypos_ser(eject_ypos_ser_6_5_7),
        .inject_yneg_ser(inject_yneg_ser_6_5_7),
        .eject_yneg_ser(eject_yneg_ser_6_5_7),
        .inject_zpos_ser(inject_zpos_ser_6_5_7),
        .eject_zpos_ser(eject_zpos_ser_6_5_7),
        .inject_zneg_ser(inject_zneg_ser_6_5_7),
        .eject_zneg_ser(eject_zneg_ser_6_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_5_7)
);
    node#(
        .X(6),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_6_7),
        .eject_xpos_ser(eject_xpos_ser_6_6_7),
        .inject_xneg_ser(inject_xneg_ser_6_6_7),
        .eject_xneg_ser(eject_xneg_ser_6_6_7),
        .inject_ypos_ser(inject_ypos_ser_6_6_7),
        .eject_ypos_ser(eject_ypos_ser_6_6_7),
        .inject_yneg_ser(inject_yneg_ser_6_6_7),
        .eject_yneg_ser(eject_yneg_ser_6_6_7),
        .inject_zpos_ser(inject_zpos_ser_6_6_7),
        .eject_zpos_ser(eject_zpos_ser_6_6_7),
        .inject_zneg_ser(inject_zneg_ser_6_6_7),
        .eject_zneg_ser(eject_zneg_ser_6_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_6_7)
);
    node#(
        .X(6),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_6_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_6_7_7),
        .eject_xpos_ser(eject_xpos_ser_6_7_7),
        .inject_xneg_ser(inject_xneg_ser_6_7_7),
        .eject_xneg_ser(eject_xneg_ser_6_7_7),
        .inject_ypos_ser(inject_ypos_ser_6_7_7),
        .eject_ypos_ser(eject_ypos_ser_6_7_7),
        .inject_yneg_ser(inject_yneg_ser_6_7_7),
        .eject_yneg_ser(eject_yneg_ser_6_7_7),
        .inject_zpos_ser(inject_zpos_ser_6_7_7),
        .eject_zpos_ser(eject_zpos_ser_6_7_7),
        .inject_zneg_ser(inject_zneg_ser_6_7_7),
        .eject_zneg_ser(eject_zneg_ser_6_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_6_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_6_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_6_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_6_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_6_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_6_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_6_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_6_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_6_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_6_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_6_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_6_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_6_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_6_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_6_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_6_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_6_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_6_7_7)
);
    node#(
        .X(7),
        .Y(0),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_0_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_0_7),
        .eject_xpos_ser(eject_xpos_ser_7_0_7),
        .inject_xneg_ser(inject_xneg_ser_7_0_7),
        .eject_xneg_ser(eject_xneg_ser_7_0_7),
        .inject_ypos_ser(inject_ypos_ser_7_0_7),
        .eject_ypos_ser(eject_ypos_ser_7_0_7),
        .inject_yneg_ser(inject_yneg_ser_7_0_7),
        .eject_yneg_ser(eject_yneg_ser_7_0_7),
        .inject_zpos_ser(inject_zpos_ser_7_0_7),
        .eject_zpos_ser(eject_zpos_ser_7_0_7),
        .inject_zneg_ser(inject_zneg_ser_7_0_7),
        .eject_zneg_ser(eject_zneg_ser_7_0_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_0_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_0_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_0_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_0_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_0_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_0_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_0_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_0_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_0_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_0_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_0_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_0_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_0_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_0_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_0_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_0_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_0_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_0_7)
);
    node#(
        .X(7),
        .Y(1),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_1_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_1_7),
        .eject_xpos_ser(eject_xpos_ser_7_1_7),
        .inject_xneg_ser(inject_xneg_ser_7_1_7),
        .eject_xneg_ser(eject_xneg_ser_7_1_7),
        .inject_ypos_ser(inject_ypos_ser_7_1_7),
        .eject_ypos_ser(eject_ypos_ser_7_1_7),
        .inject_yneg_ser(inject_yneg_ser_7_1_7),
        .eject_yneg_ser(eject_yneg_ser_7_1_7),
        .inject_zpos_ser(inject_zpos_ser_7_1_7),
        .eject_zpos_ser(eject_zpos_ser_7_1_7),
        .inject_zneg_ser(inject_zneg_ser_7_1_7),
        .eject_zneg_ser(eject_zneg_ser_7_1_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_1_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_1_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_1_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_1_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_1_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_1_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_1_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_1_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_1_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_1_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_1_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_1_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_1_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_1_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_1_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_1_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_1_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_1_7)
);
    node#(
        .X(7),
        .Y(2),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_2_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_2_7),
        .eject_xpos_ser(eject_xpos_ser_7_2_7),
        .inject_xneg_ser(inject_xneg_ser_7_2_7),
        .eject_xneg_ser(eject_xneg_ser_7_2_7),
        .inject_ypos_ser(inject_ypos_ser_7_2_7),
        .eject_ypos_ser(eject_ypos_ser_7_2_7),
        .inject_yneg_ser(inject_yneg_ser_7_2_7),
        .eject_yneg_ser(eject_yneg_ser_7_2_7),
        .inject_zpos_ser(inject_zpos_ser_7_2_7),
        .eject_zpos_ser(eject_zpos_ser_7_2_7),
        .inject_zneg_ser(inject_zneg_ser_7_2_7),
        .eject_zneg_ser(eject_zneg_ser_7_2_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_2_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_2_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_2_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_2_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_2_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_2_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_2_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_2_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_2_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_2_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_2_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_2_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_2_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_2_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_2_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_2_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_2_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_2_7)
);
    node#(
        .X(7),
        .Y(3),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_3_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_3_7),
        .eject_xpos_ser(eject_xpos_ser_7_3_7),
        .inject_xneg_ser(inject_xneg_ser_7_3_7),
        .eject_xneg_ser(eject_xneg_ser_7_3_7),
        .inject_ypos_ser(inject_ypos_ser_7_3_7),
        .eject_ypos_ser(eject_ypos_ser_7_3_7),
        .inject_yneg_ser(inject_yneg_ser_7_3_7),
        .eject_yneg_ser(eject_yneg_ser_7_3_7),
        .inject_zpos_ser(inject_zpos_ser_7_3_7),
        .eject_zpos_ser(eject_zpos_ser_7_3_7),
        .inject_zneg_ser(inject_zneg_ser_7_3_7),
        .eject_zneg_ser(eject_zneg_ser_7_3_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_3_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_3_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_3_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_3_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_3_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_3_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_3_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_3_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_3_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_3_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_3_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_3_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_3_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_3_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_3_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_3_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_3_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_3_7)
);
    node#(
        .X(7),
        .Y(4),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_4_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_4_7),
        .eject_xpos_ser(eject_xpos_ser_7_4_7),
        .inject_xneg_ser(inject_xneg_ser_7_4_7),
        .eject_xneg_ser(eject_xneg_ser_7_4_7),
        .inject_ypos_ser(inject_ypos_ser_7_4_7),
        .eject_ypos_ser(eject_ypos_ser_7_4_7),
        .inject_yneg_ser(inject_yneg_ser_7_4_7),
        .eject_yneg_ser(eject_yneg_ser_7_4_7),
        .inject_zpos_ser(inject_zpos_ser_7_4_7),
        .eject_zpos_ser(eject_zpos_ser_7_4_7),
        .inject_zneg_ser(inject_zneg_ser_7_4_7),
        .eject_zneg_ser(eject_zneg_ser_7_4_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_4_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_4_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_4_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_4_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_4_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_4_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_4_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_4_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_4_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_4_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_4_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_4_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_4_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_4_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_4_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_4_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_4_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_4_7)
);
    node#(
        .X(7),
        .Y(5),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_5_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_5_7),
        .eject_xpos_ser(eject_xpos_ser_7_5_7),
        .inject_xneg_ser(inject_xneg_ser_7_5_7),
        .eject_xneg_ser(eject_xneg_ser_7_5_7),
        .inject_ypos_ser(inject_ypos_ser_7_5_7),
        .eject_ypos_ser(eject_ypos_ser_7_5_7),
        .inject_yneg_ser(inject_yneg_ser_7_5_7),
        .eject_yneg_ser(eject_yneg_ser_7_5_7),
        .inject_zpos_ser(inject_zpos_ser_7_5_7),
        .eject_zpos_ser(eject_zpos_ser_7_5_7),
        .inject_zneg_ser(inject_zneg_ser_7_5_7),
        .eject_zneg_ser(eject_zneg_ser_7_5_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_5_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_5_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_5_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_5_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_5_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_5_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_5_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_5_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_5_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_5_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_5_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_5_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_5_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_5_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_5_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_5_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_5_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_5_7)
);
    node#(
        .X(7),
        .Y(6),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_6_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_6_7),
        .eject_xpos_ser(eject_xpos_ser_7_6_7),
        .inject_xneg_ser(inject_xneg_ser_7_6_7),
        .eject_xneg_ser(eject_xneg_ser_7_6_7),
        .inject_ypos_ser(inject_ypos_ser_7_6_7),
        .eject_ypos_ser(eject_ypos_ser_7_6_7),
        .inject_yneg_ser(inject_yneg_ser_7_6_7),
        .eject_yneg_ser(eject_yneg_ser_7_6_7),
        .inject_zpos_ser(inject_zpos_ser_7_6_7),
        .eject_zpos_ser(eject_zpos_ser_7_6_7),
        .inject_zneg_ser(inject_zneg_ser_7_6_7),
        .eject_zneg_ser(eject_zneg_ser_7_6_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_6_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_6_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_6_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_6_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_6_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_6_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_6_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_6_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_6_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_6_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_6_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_6_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_6_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_6_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_6_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_6_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_6_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_6_7)
);
    node#(
        .X(7),
        .Y(7),
        .Z(7),
        .CoordWidth(CoordWidth),
        .XCoordPos(XCoordPos),
        .YCoordPos(YCoordPos),
        .ZCoordPos(ZCoordPos),
        .PacketIDPos(PacketIDPos),
        .PacketTypePos(PacketTypePos),
        .packet_count(packet_count),
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
        )n_7_7_7(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_7_7_7),
        .eject_xpos_ser(eject_xpos_ser_7_7_7),
        .inject_xneg_ser(inject_xneg_ser_7_7_7),
        .eject_xneg_ser(eject_xneg_ser_7_7_7),
        .inject_ypos_ser(inject_ypos_ser_7_7_7),
        .eject_ypos_ser(eject_ypos_ser_7_7_7),
        .inject_yneg_ser(inject_yneg_ser_7_7_7),
        .eject_yneg_ser(eject_yneg_ser_7_7_7),
        .inject_zpos_ser(inject_zpos_ser_7_7_7),
        .eject_zpos_ser(eject_zpos_ser_7_7_7),
        .inject_zneg_ser(inject_zneg_ser_7_7_7),
        .eject_zneg_ser(eject_zneg_ser_7_7_7),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_7_7_7),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_7_7_7),
        .xpos_InjectUtil(xpos_InjectUtil_7_7_7),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_7_7_7),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_7_7_7),
        .xneg_InjectUtil(xneg_InjectUtil_7_7_7),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_7_7_7),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_7_7_7),
        .ypos_InjectUtil(ypos_InjectUtil_7_7_7),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_7_7_7),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_7_7_7),
        .yneg_InjectUtil(yneg_InjectUtil_7_7_7),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_7_7_7),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_7_7_7),
        .zpos_InjectUtil(zpos_InjectUtil_7_7_7),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_7_7_7),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_7_7_7),
        .zneg_InjectUtil(zneg_InjectUtil_7_7_7)
);
endmodule
