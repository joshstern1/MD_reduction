module network#(
    parameter DataSize=8'd172,
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
    parameter LinkDelay=20
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

	assign inject_xpos_ser_0_0_0=eject_xneg_ser_1_0_0;
	assign inject_xneg_ser_0_0_0=eject_xpos_ser_3_0_0;
	assign inject_xpos_ser_0_0_1=eject_xneg_ser_1_0_1;
	assign inject_xneg_ser_0_0_1=eject_xpos_ser_3_0_1;
	assign inject_xpos_ser_0_0_2=eject_xneg_ser_1_0_2;
	assign inject_xneg_ser_0_0_2=eject_xpos_ser_3_0_2;
	assign inject_xpos_ser_0_0_3=eject_xneg_ser_1_0_3;
	assign inject_xneg_ser_0_0_3=eject_xpos_ser_3_0_3;
	assign inject_xpos_ser_0_1_0=eject_xneg_ser_1_1_0;
	assign inject_xneg_ser_0_1_0=eject_xpos_ser_3_1_0;
	assign inject_xpos_ser_0_1_1=eject_xneg_ser_1_1_1;
	assign inject_xneg_ser_0_1_1=eject_xpos_ser_3_1_1;
	assign inject_xpos_ser_0_1_2=eject_xneg_ser_1_1_2;
	assign inject_xneg_ser_0_1_2=eject_xpos_ser_3_1_2;
	assign inject_xpos_ser_0_1_3=eject_xneg_ser_1_1_3;
	assign inject_xneg_ser_0_1_3=eject_xpos_ser_3_1_3;
	assign inject_xpos_ser_0_2_0=eject_xneg_ser_1_2_0;
	assign inject_xneg_ser_0_2_0=eject_xpos_ser_3_2_0;
	assign inject_xpos_ser_0_2_1=eject_xneg_ser_1_2_1;
	assign inject_xneg_ser_0_2_1=eject_xpos_ser_3_2_1;
	assign inject_xpos_ser_0_2_2=eject_xneg_ser_1_2_2;
	assign inject_xneg_ser_0_2_2=eject_xpos_ser_3_2_2;
	assign inject_xpos_ser_0_2_3=eject_xneg_ser_1_2_3;
	assign inject_xneg_ser_0_2_3=eject_xpos_ser_3_2_3;
	assign inject_xpos_ser_0_3_0=eject_xneg_ser_1_3_0;
	assign inject_xneg_ser_0_3_0=eject_xpos_ser_3_3_0;
	assign inject_xpos_ser_0_3_1=eject_xneg_ser_1_3_1;
	assign inject_xneg_ser_0_3_1=eject_xpos_ser_3_3_1;
	assign inject_xpos_ser_0_3_2=eject_xneg_ser_1_3_2;
	assign inject_xneg_ser_0_3_2=eject_xpos_ser_3_3_2;
	assign inject_xpos_ser_0_3_3=eject_xneg_ser_1_3_3;
	assign inject_xneg_ser_0_3_3=eject_xpos_ser_3_3_3;
	assign inject_xpos_ser_1_0_0=eject_xneg_ser_2_0_0;
	assign inject_xneg_ser_1_0_0=eject_xpos_ser_0_0_0;
	assign inject_xpos_ser_1_0_1=eject_xneg_ser_2_0_1;
	assign inject_xneg_ser_1_0_1=eject_xpos_ser_0_0_1;
	assign inject_xpos_ser_1_0_2=eject_xneg_ser_2_0_2;
	assign inject_xneg_ser_1_0_2=eject_xpos_ser_0_0_2;
	assign inject_xpos_ser_1_0_3=eject_xneg_ser_2_0_3;
	assign inject_xneg_ser_1_0_3=eject_xpos_ser_0_0_3;
	assign inject_xpos_ser_1_1_0=eject_xneg_ser_2_1_0;
	assign inject_xneg_ser_1_1_0=eject_xpos_ser_0_1_0;
	assign inject_xpos_ser_1_1_1=eject_xneg_ser_2_1_1;
	assign inject_xneg_ser_1_1_1=eject_xpos_ser_0_1_1;
	assign inject_xpos_ser_1_1_2=eject_xneg_ser_2_1_2;
	assign inject_xneg_ser_1_1_2=eject_xpos_ser_0_1_2;
	assign inject_xpos_ser_1_1_3=eject_xneg_ser_2_1_3;
	assign inject_xneg_ser_1_1_3=eject_xpos_ser_0_1_3;
	assign inject_xpos_ser_1_2_0=eject_xneg_ser_2_2_0;
	assign inject_xneg_ser_1_2_0=eject_xpos_ser_0_2_0;
	assign inject_xpos_ser_1_2_1=eject_xneg_ser_2_2_1;
	assign inject_xneg_ser_1_2_1=eject_xpos_ser_0_2_1;
	assign inject_xpos_ser_1_2_2=eject_xneg_ser_2_2_2;
	assign inject_xneg_ser_1_2_2=eject_xpos_ser_0_2_2;
	assign inject_xpos_ser_1_2_3=eject_xneg_ser_2_2_3;
	assign inject_xneg_ser_1_2_3=eject_xpos_ser_0_2_3;
	assign inject_xpos_ser_1_3_0=eject_xneg_ser_2_3_0;
	assign inject_xneg_ser_1_3_0=eject_xpos_ser_0_3_0;
	assign inject_xpos_ser_1_3_1=eject_xneg_ser_2_3_1;
	assign inject_xneg_ser_1_3_1=eject_xpos_ser_0_3_1;
	assign inject_xpos_ser_1_3_2=eject_xneg_ser_2_3_2;
	assign inject_xneg_ser_1_3_2=eject_xpos_ser_0_3_2;
	assign inject_xpos_ser_1_3_3=eject_xneg_ser_2_3_3;
	assign inject_xneg_ser_1_3_3=eject_xpos_ser_0_3_3;
	assign inject_xpos_ser_2_0_0=eject_xneg_ser_3_0_0;
	assign inject_xneg_ser_2_0_0=eject_xpos_ser_1_0_0;
	assign inject_xpos_ser_2_0_1=eject_xneg_ser_3_0_1;
	assign inject_xneg_ser_2_0_1=eject_xpos_ser_1_0_1;
	assign inject_xpos_ser_2_0_2=eject_xneg_ser_3_0_2;
	assign inject_xneg_ser_2_0_2=eject_xpos_ser_1_0_2;
	assign inject_xpos_ser_2_0_3=eject_xneg_ser_3_0_3;
	assign inject_xneg_ser_2_0_3=eject_xpos_ser_1_0_3;
	assign inject_xpos_ser_2_1_0=eject_xneg_ser_3_1_0;
	assign inject_xneg_ser_2_1_0=eject_xpos_ser_1_1_0;
	assign inject_xpos_ser_2_1_1=eject_xneg_ser_3_1_1;
	assign inject_xneg_ser_2_1_1=eject_xpos_ser_1_1_1;
	assign inject_xpos_ser_2_1_2=eject_xneg_ser_3_1_2;
	assign inject_xneg_ser_2_1_2=eject_xpos_ser_1_1_2;
	assign inject_xpos_ser_2_1_3=eject_xneg_ser_3_1_3;
	assign inject_xneg_ser_2_1_3=eject_xpos_ser_1_1_3;
	assign inject_xpos_ser_2_2_0=eject_xneg_ser_3_2_0;
	assign inject_xneg_ser_2_2_0=eject_xpos_ser_1_2_0;
	assign inject_xpos_ser_2_2_1=eject_xneg_ser_3_2_1;
	assign inject_xneg_ser_2_2_1=eject_xpos_ser_1_2_1;
	assign inject_xpos_ser_2_2_2=eject_xneg_ser_3_2_2;
	assign inject_xneg_ser_2_2_2=eject_xpos_ser_1_2_2;
	assign inject_xpos_ser_2_2_3=eject_xneg_ser_3_2_3;
	assign inject_xneg_ser_2_2_3=eject_xpos_ser_1_2_3;
	assign inject_xpos_ser_2_3_0=eject_xneg_ser_3_3_0;
	assign inject_xneg_ser_2_3_0=eject_xpos_ser_1_3_0;
	assign inject_xpos_ser_2_3_1=eject_xneg_ser_3_3_1;
	assign inject_xneg_ser_2_3_1=eject_xpos_ser_1_3_1;
	assign inject_xpos_ser_2_3_2=eject_xneg_ser_3_3_2;
	assign inject_xneg_ser_2_3_2=eject_xpos_ser_1_3_2;
	assign inject_xpos_ser_2_3_3=eject_xneg_ser_3_3_3;
	assign inject_xneg_ser_2_3_3=eject_xpos_ser_1_3_3;
	assign inject_xpos_ser_3_0_0=eject_xneg_ser_0_0_0;
	assign inject_xneg_ser_3_0_0=eject_xpos_ser_2_0_0;
	assign inject_xpos_ser_3_0_1=eject_xneg_ser_0_0_1;
	assign inject_xneg_ser_3_0_1=eject_xpos_ser_2_0_1;
	assign inject_xpos_ser_3_0_2=eject_xneg_ser_0_0_2;
	assign inject_xneg_ser_3_0_2=eject_xpos_ser_2_0_2;
	assign inject_xpos_ser_3_0_3=eject_xneg_ser_0_0_3;
	assign inject_xneg_ser_3_0_3=eject_xpos_ser_2_0_3;
	assign inject_xpos_ser_3_1_0=eject_xneg_ser_0_1_0;
	assign inject_xneg_ser_3_1_0=eject_xpos_ser_2_1_0;
	assign inject_xpos_ser_3_1_1=eject_xneg_ser_0_1_1;
	assign inject_xneg_ser_3_1_1=eject_xpos_ser_2_1_1;
	assign inject_xpos_ser_3_1_2=eject_xneg_ser_0_1_2;
	assign inject_xneg_ser_3_1_2=eject_xpos_ser_2_1_2;
	assign inject_xpos_ser_3_1_3=eject_xneg_ser_0_1_3;
	assign inject_xneg_ser_3_1_3=eject_xpos_ser_2_1_3;
	assign inject_xpos_ser_3_2_0=eject_xneg_ser_0_2_0;
	assign inject_xneg_ser_3_2_0=eject_xpos_ser_2_2_0;
	assign inject_xpos_ser_3_2_1=eject_xneg_ser_0_2_1;
	assign inject_xneg_ser_3_2_1=eject_xpos_ser_2_2_1;
	assign inject_xpos_ser_3_2_2=eject_xneg_ser_0_2_2;
	assign inject_xneg_ser_3_2_2=eject_xpos_ser_2_2_2;
	assign inject_xpos_ser_3_2_3=eject_xneg_ser_0_2_3;
	assign inject_xneg_ser_3_2_3=eject_xpos_ser_2_2_3;
	assign inject_xpos_ser_3_3_0=eject_xneg_ser_0_3_0;
	assign inject_xneg_ser_3_3_0=eject_xpos_ser_2_3_0;
	assign inject_xpos_ser_3_3_1=eject_xneg_ser_0_3_1;
	assign inject_xneg_ser_3_3_1=eject_xpos_ser_2_3_1;
	assign inject_xpos_ser_3_3_2=eject_xneg_ser_0_3_2;
	assign inject_xneg_ser_3_3_2=eject_xpos_ser_2_3_2;
	assign inject_xpos_ser_3_3_3=eject_xneg_ser_0_3_3;
	assign inject_xneg_ser_3_3_3=eject_xpos_ser_2_3_3;
	assign inject_ypos_ser_0_0_0=eject_yneg_ser_0_1_0;
	assign inject_yneg_ser_0_0_0=eject_ypos_ser_0_3_0;
	assign inject_ypos_ser_0_0_1=eject_yneg_ser_0_1_1;
	assign inject_yneg_ser_0_0_1=eject_ypos_ser_0_3_1;
	assign inject_ypos_ser_0_0_2=eject_yneg_ser_0_1_2;
	assign inject_yneg_ser_0_0_2=eject_ypos_ser_0_3_2;
	assign inject_ypos_ser_0_0_3=eject_yneg_ser_0_1_3;
	assign inject_yneg_ser_0_0_3=eject_ypos_ser_0_3_3;
	assign inject_ypos_ser_0_1_0=eject_yneg_ser_0_2_0;
	assign inject_yneg_ser_0_1_0=eject_ypos_ser_0_0_0;
	assign inject_ypos_ser_0_1_1=eject_yneg_ser_0_2_1;
	assign inject_yneg_ser_0_1_1=eject_ypos_ser_0_0_1;
	assign inject_ypos_ser_0_1_2=eject_yneg_ser_0_2_2;
	assign inject_yneg_ser_0_1_2=eject_ypos_ser_0_0_2;
	assign inject_ypos_ser_0_1_3=eject_yneg_ser_0_2_3;
	assign inject_yneg_ser_0_1_3=eject_ypos_ser_0_0_3;
	assign inject_ypos_ser_0_2_0=eject_yneg_ser_0_3_0;
	assign inject_yneg_ser_0_2_0=eject_ypos_ser_0_1_0;
	assign inject_ypos_ser_0_2_1=eject_yneg_ser_0_3_1;
	assign inject_yneg_ser_0_2_1=eject_ypos_ser_0_1_1;
	assign inject_ypos_ser_0_2_2=eject_yneg_ser_0_3_2;
	assign inject_yneg_ser_0_2_2=eject_ypos_ser_0_1_2;
	assign inject_ypos_ser_0_2_3=eject_yneg_ser_0_3_3;
	assign inject_yneg_ser_0_2_3=eject_ypos_ser_0_1_3;
	assign inject_ypos_ser_0_3_0=eject_yneg_ser_0_0_0;
	assign inject_yneg_ser_0_3_0=eject_ypos_ser_0_2_0;
	assign inject_ypos_ser_0_3_1=eject_yneg_ser_0_0_1;
	assign inject_yneg_ser_0_3_1=eject_ypos_ser_0_2_1;
	assign inject_ypos_ser_0_3_2=eject_yneg_ser_0_0_2;
	assign inject_yneg_ser_0_3_2=eject_ypos_ser_0_2_2;
	assign inject_ypos_ser_0_3_3=eject_yneg_ser_0_0_3;
	assign inject_yneg_ser_0_3_3=eject_ypos_ser_0_2_3;
	assign inject_ypos_ser_1_0_0=eject_yneg_ser_1_1_0;
	assign inject_yneg_ser_1_0_0=eject_ypos_ser_1_3_0;
	assign inject_ypos_ser_1_0_1=eject_yneg_ser_1_1_1;
	assign inject_yneg_ser_1_0_1=eject_ypos_ser_1_3_1;
	assign inject_ypos_ser_1_0_2=eject_yneg_ser_1_1_2;
	assign inject_yneg_ser_1_0_2=eject_ypos_ser_1_3_2;
	assign inject_ypos_ser_1_0_3=eject_yneg_ser_1_1_3;
	assign inject_yneg_ser_1_0_3=eject_ypos_ser_1_3_3;
	assign inject_ypos_ser_1_1_0=eject_yneg_ser_1_2_0;
	assign inject_yneg_ser_1_1_0=eject_ypos_ser_1_0_0;
	assign inject_ypos_ser_1_1_1=eject_yneg_ser_1_2_1;
	assign inject_yneg_ser_1_1_1=eject_ypos_ser_1_0_1;
	assign inject_ypos_ser_1_1_2=eject_yneg_ser_1_2_2;
	assign inject_yneg_ser_1_1_2=eject_ypos_ser_1_0_2;
	assign inject_ypos_ser_1_1_3=eject_yneg_ser_1_2_3;
	assign inject_yneg_ser_1_1_3=eject_ypos_ser_1_0_3;
	assign inject_ypos_ser_1_2_0=eject_yneg_ser_1_3_0;
	assign inject_yneg_ser_1_2_0=eject_ypos_ser_1_1_0;
	assign inject_ypos_ser_1_2_1=eject_yneg_ser_1_3_1;
	assign inject_yneg_ser_1_2_1=eject_ypos_ser_1_1_1;
	assign inject_ypos_ser_1_2_2=eject_yneg_ser_1_3_2;
	assign inject_yneg_ser_1_2_2=eject_ypos_ser_1_1_2;
	assign inject_ypos_ser_1_2_3=eject_yneg_ser_1_3_3;
	assign inject_yneg_ser_1_2_3=eject_ypos_ser_1_1_3;
	assign inject_ypos_ser_1_3_0=eject_yneg_ser_1_0_0;
	assign inject_yneg_ser_1_3_0=eject_ypos_ser_1_2_0;
	assign inject_ypos_ser_1_3_1=eject_yneg_ser_1_0_1;
	assign inject_yneg_ser_1_3_1=eject_ypos_ser_1_2_1;
	assign inject_ypos_ser_1_3_2=eject_yneg_ser_1_0_2;
	assign inject_yneg_ser_1_3_2=eject_ypos_ser_1_2_2;
	assign inject_ypos_ser_1_3_3=eject_yneg_ser_1_0_3;
	assign inject_yneg_ser_1_3_3=eject_ypos_ser_1_2_3;
	assign inject_ypos_ser_2_0_0=eject_yneg_ser_2_1_0;
	assign inject_yneg_ser_2_0_0=eject_ypos_ser_2_3_0;
	assign inject_ypos_ser_2_0_1=eject_yneg_ser_2_1_1;
	assign inject_yneg_ser_2_0_1=eject_ypos_ser_2_3_1;
	assign inject_ypos_ser_2_0_2=eject_yneg_ser_2_1_2;
	assign inject_yneg_ser_2_0_2=eject_ypos_ser_2_3_2;
	assign inject_ypos_ser_2_0_3=eject_yneg_ser_2_1_3;
	assign inject_yneg_ser_2_0_3=eject_ypos_ser_2_3_3;
	assign inject_ypos_ser_2_1_0=eject_yneg_ser_2_2_0;
	assign inject_yneg_ser_2_1_0=eject_ypos_ser_2_0_0;
	assign inject_ypos_ser_2_1_1=eject_yneg_ser_2_2_1;
	assign inject_yneg_ser_2_1_1=eject_ypos_ser_2_0_1;
	assign inject_ypos_ser_2_1_2=eject_yneg_ser_2_2_2;
	assign inject_yneg_ser_2_1_2=eject_ypos_ser_2_0_2;
	assign inject_ypos_ser_2_1_3=eject_yneg_ser_2_2_3;
	assign inject_yneg_ser_2_1_3=eject_ypos_ser_2_0_3;
	assign inject_ypos_ser_2_2_0=eject_yneg_ser_2_3_0;
	assign inject_yneg_ser_2_2_0=eject_ypos_ser_2_1_0;
	assign inject_ypos_ser_2_2_1=eject_yneg_ser_2_3_1;
	assign inject_yneg_ser_2_2_1=eject_ypos_ser_2_1_1;
	assign inject_ypos_ser_2_2_2=eject_yneg_ser_2_3_2;
	assign inject_yneg_ser_2_2_2=eject_ypos_ser_2_1_2;
	assign inject_ypos_ser_2_2_3=eject_yneg_ser_2_3_3;
	assign inject_yneg_ser_2_2_3=eject_ypos_ser_2_1_3;
	assign inject_ypos_ser_2_3_0=eject_yneg_ser_2_0_0;
	assign inject_yneg_ser_2_3_0=eject_ypos_ser_2_2_0;
	assign inject_ypos_ser_2_3_1=eject_yneg_ser_2_0_1;
	assign inject_yneg_ser_2_3_1=eject_ypos_ser_2_2_1;
	assign inject_ypos_ser_2_3_2=eject_yneg_ser_2_0_2;
	assign inject_yneg_ser_2_3_2=eject_ypos_ser_2_2_2;
	assign inject_ypos_ser_2_3_3=eject_yneg_ser_2_0_3;
	assign inject_yneg_ser_2_3_3=eject_ypos_ser_2_2_3;
	assign inject_ypos_ser_3_0_0=eject_yneg_ser_3_1_0;
	assign inject_yneg_ser_3_0_0=eject_ypos_ser_3_3_0;
	assign inject_ypos_ser_3_0_1=eject_yneg_ser_3_1_1;
	assign inject_yneg_ser_3_0_1=eject_ypos_ser_3_3_1;
	assign inject_ypos_ser_3_0_2=eject_yneg_ser_3_1_2;
	assign inject_yneg_ser_3_0_2=eject_ypos_ser_3_3_2;
	assign inject_ypos_ser_3_0_3=eject_yneg_ser_3_1_3;
	assign inject_yneg_ser_3_0_3=eject_ypos_ser_3_3_3;
	assign inject_ypos_ser_3_1_0=eject_yneg_ser_3_2_0;
	assign inject_yneg_ser_3_1_0=eject_ypos_ser_3_0_0;
	assign inject_ypos_ser_3_1_1=eject_yneg_ser_3_2_1;
	assign inject_yneg_ser_3_1_1=eject_ypos_ser_3_0_1;
	assign inject_ypos_ser_3_1_2=eject_yneg_ser_3_2_2;
	assign inject_yneg_ser_3_1_2=eject_ypos_ser_3_0_2;
	assign inject_ypos_ser_3_1_3=eject_yneg_ser_3_2_3;
	assign inject_yneg_ser_3_1_3=eject_ypos_ser_3_0_3;
	assign inject_ypos_ser_3_2_0=eject_yneg_ser_3_3_0;
	assign inject_yneg_ser_3_2_0=eject_ypos_ser_3_1_0;
	assign inject_ypos_ser_3_2_1=eject_yneg_ser_3_3_1;
	assign inject_yneg_ser_3_2_1=eject_ypos_ser_3_1_1;
	assign inject_ypos_ser_3_2_2=eject_yneg_ser_3_3_2;
	assign inject_yneg_ser_3_2_2=eject_ypos_ser_3_1_2;
	assign inject_ypos_ser_3_2_3=eject_yneg_ser_3_3_3;
	assign inject_yneg_ser_3_2_3=eject_ypos_ser_3_1_3;
	assign inject_ypos_ser_3_3_0=eject_yneg_ser_3_0_0;
	assign inject_yneg_ser_3_3_0=eject_ypos_ser_3_2_0;
	assign inject_ypos_ser_3_3_1=eject_yneg_ser_3_0_1;
	assign inject_yneg_ser_3_3_1=eject_ypos_ser_3_2_1;
	assign inject_ypos_ser_3_3_2=eject_yneg_ser_3_0_2;
	assign inject_yneg_ser_3_3_2=eject_ypos_ser_3_2_2;
	assign inject_ypos_ser_3_3_3=eject_yneg_ser_3_0_3;
	assign inject_yneg_ser_3_3_3=eject_ypos_ser_3_2_3;
	assign inject_zpos_ser_0_0_0=eject_zneg_ser_0_0_1;
	assign inject_zneg_ser_0_0_0=eject_zpos_ser_0_0_3;
	assign inject_zpos_ser_0_0_1=eject_zneg_ser_0_0_2;
	assign inject_zneg_ser_0_0_1=eject_zpos_ser_0_0_0;
	assign inject_zpos_ser_0_0_2=eject_zneg_ser_0_0_3;
	assign inject_zneg_ser_0_0_2=eject_zpos_ser_0_0_1;
	assign inject_zpos_ser_0_0_3=eject_zneg_ser_0_0_0;
	assign inject_zneg_ser_0_0_3=eject_zpos_ser_0_0_2;
	assign inject_zpos_ser_0_1_0=eject_zneg_ser_0_1_1;
	assign inject_zneg_ser_0_1_0=eject_zpos_ser_0_1_3;
	assign inject_zpos_ser_0_1_1=eject_zneg_ser_0_1_2;
	assign inject_zneg_ser_0_1_1=eject_zpos_ser_0_1_0;
	assign inject_zpos_ser_0_1_2=eject_zneg_ser_0_1_3;
	assign inject_zneg_ser_0_1_2=eject_zpos_ser_0_1_1;
	assign inject_zpos_ser_0_1_3=eject_zneg_ser_0_1_0;
	assign inject_zneg_ser_0_1_3=eject_zpos_ser_0_1_2;
	assign inject_zpos_ser_0_2_0=eject_zneg_ser_0_2_1;
	assign inject_zneg_ser_0_2_0=eject_zpos_ser_0_2_3;
	assign inject_zpos_ser_0_2_1=eject_zneg_ser_0_2_2;
	assign inject_zneg_ser_0_2_1=eject_zpos_ser_0_2_0;
	assign inject_zpos_ser_0_2_2=eject_zneg_ser_0_2_3;
	assign inject_zneg_ser_0_2_2=eject_zpos_ser_0_2_1;
	assign inject_zpos_ser_0_2_3=eject_zneg_ser_0_2_0;
	assign inject_zneg_ser_0_2_3=eject_zpos_ser_0_2_2;
	assign inject_zpos_ser_0_3_0=eject_zneg_ser_0_3_1;
	assign inject_zneg_ser_0_3_0=eject_zpos_ser_0_3_3;
	assign inject_zpos_ser_0_3_1=eject_zneg_ser_0_3_2;
	assign inject_zneg_ser_0_3_1=eject_zpos_ser_0_3_0;
	assign inject_zpos_ser_0_3_2=eject_zneg_ser_0_3_3;
	assign inject_zneg_ser_0_3_2=eject_zpos_ser_0_3_1;
	assign inject_zpos_ser_0_3_3=eject_zneg_ser_0_3_0;
	assign inject_zneg_ser_0_3_3=eject_zpos_ser_0_3_2;
	assign inject_zpos_ser_1_0_0=eject_zneg_ser_1_0_1;
	assign inject_zneg_ser_1_0_0=eject_zpos_ser_1_0_3;
	assign inject_zpos_ser_1_0_1=eject_zneg_ser_1_0_2;
	assign inject_zneg_ser_1_0_1=eject_zpos_ser_1_0_0;
	assign inject_zpos_ser_1_0_2=eject_zneg_ser_1_0_3;
	assign inject_zneg_ser_1_0_2=eject_zpos_ser_1_0_1;
	assign inject_zpos_ser_1_0_3=eject_zneg_ser_1_0_0;
	assign inject_zneg_ser_1_0_3=eject_zpos_ser_1_0_2;
	assign inject_zpos_ser_1_1_0=eject_zneg_ser_1_1_1;
	assign inject_zneg_ser_1_1_0=eject_zpos_ser_1_1_3;
	assign inject_zpos_ser_1_1_1=eject_zneg_ser_1_1_2;
	assign inject_zneg_ser_1_1_1=eject_zpos_ser_1_1_0;
	assign inject_zpos_ser_1_1_2=eject_zneg_ser_1_1_3;
	assign inject_zneg_ser_1_1_2=eject_zpos_ser_1_1_1;
	assign inject_zpos_ser_1_1_3=eject_zneg_ser_1_1_0;
	assign inject_zneg_ser_1_1_3=eject_zpos_ser_1_1_2;
	assign inject_zpos_ser_1_2_0=eject_zneg_ser_1_2_1;
	assign inject_zneg_ser_1_2_0=eject_zpos_ser_1_2_3;
	assign inject_zpos_ser_1_2_1=eject_zneg_ser_1_2_2;
	assign inject_zneg_ser_1_2_1=eject_zpos_ser_1_2_0;
	assign inject_zpos_ser_1_2_2=eject_zneg_ser_1_2_3;
	assign inject_zneg_ser_1_2_2=eject_zpos_ser_1_2_1;
	assign inject_zpos_ser_1_2_3=eject_zneg_ser_1_2_0;
	assign inject_zneg_ser_1_2_3=eject_zpos_ser_1_2_2;
	assign inject_zpos_ser_1_3_0=eject_zneg_ser_1_3_1;
	assign inject_zneg_ser_1_3_0=eject_zpos_ser_1_3_3;
	assign inject_zpos_ser_1_3_1=eject_zneg_ser_1_3_2;
	assign inject_zneg_ser_1_3_1=eject_zpos_ser_1_3_0;
	assign inject_zpos_ser_1_3_2=eject_zneg_ser_1_3_3;
	assign inject_zneg_ser_1_3_2=eject_zpos_ser_1_3_1;
	assign inject_zpos_ser_1_3_3=eject_zneg_ser_1_3_0;
	assign inject_zneg_ser_1_3_3=eject_zpos_ser_1_3_2;
	assign inject_zpos_ser_2_0_0=eject_zneg_ser_2_0_1;
	assign inject_zneg_ser_2_0_0=eject_zpos_ser_2_0_3;
	assign inject_zpos_ser_2_0_1=eject_zneg_ser_2_0_2;
	assign inject_zneg_ser_2_0_1=eject_zpos_ser_2_0_0;
	assign inject_zpos_ser_2_0_2=eject_zneg_ser_2_0_3;
	assign inject_zneg_ser_2_0_2=eject_zpos_ser_2_0_1;
	assign inject_zpos_ser_2_0_3=eject_zneg_ser_2_0_0;
	assign inject_zneg_ser_2_0_3=eject_zpos_ser_2_0_2;
	assign inject_zpos_ser_2_1_0=eject_zneg_ser_2_1_1;
	assign inject_zneg_ser_2_1_0=eject_zpos_ser_2_1_3;
	assign inject_zpos_ser_2_1_1=eject_zneg_ser_2_1_2;
	assign inject_zneg_ser_2_1_1=eject_zpos_ser_2_1_0;
	assign inject_zpos_ser_2_1_2=eject_zneg_ser_2_1_3;
	assign inject_zneg_ser_2_1_2=eject_zpos_ser_2_1_1;
	assign inject_zpos_ser_2_1_3=eject_zneg_ser_2_1_0;
	assign inject_zneg_ser_2_1_3=eject_zpos_ser_2_1_2;
	assign inject_zpos_ser_2_2_0=eject_zneg_ser_2_2_1;
	assign inject_zneg_ser_2_2_0=eject_zpos_ser_2_2_3;
	assign inject_zpos_ser_2_2_1=eject_zneg_ser_2_2_2;
	assign inject_zneg_ser_2_2_1=eject_zpos_ser_2_2_0;
	assign inject_zpos_ser_2_2_2=eject_zneg_ser_2_2_3;
	assign inject_zneg_ser_2_2_2=eject_zpos_ser_2_2_1;
	assign inject_zpos_ser_2_2_3=eject_zneg_ser_2_2_0;
	assign inject_zneg_ser_2_2_3=eject_zpos_ser_2_2_2;
	assign inject_zpos_ser_2_3_0=eject_zneg_ser_2_3_1;
	assign inject_zneg_ser_2_3_0=eject_zpos_ser_2_3_3;
	assign inject_zpos_ser_2_3_1=eject_zneg_ser_2_3_2;
	assign inject_zneg_ser_2_3_1=eject_zpos_ser_2_3_0;
	assign inject_zpos_ser_2_3_2=eject_zneg_ser_2_3_3;
	assign inject_zneg_ser_2_3_2=eject_zpos_ser_2_3_1;
	assign inject_zpos_ser_2_3_3=eject_zneg_ser_2_3_0;
	assign inject_zneg_ser_2_3_3=eject_zpos_ser_2_3_2;
	assign inject_zpos_ser_3_0_0=eject_zneg_ser_3_0_1;
	assign inject_zneg_ser_3_0_0=eject_zpos_ser_3_0_3;
	assign inject_zpos_ser_3_0_1=eject_zneg_ser_3_0_2;
	assign inject_zneg_ser_3_0_1=eject_zpos_ser_3_0_0;
	assign inject_zpos_ser_3_0_2=eject_zneg_ser_3_0_3;
	assign inject_zneg_ser_3_0_2=eject_zpos_ser_3_0_1;
	assign inject_zpos_ser_3_0_3=eject_zneg_ser_3_0_0;
	assign inject_zneg_ser_3_0_3=eject_zpos_ser_3_0_2;
	assign inject_zpos_ser_3_1_0=eject_zneg_ser_3_1_1;
	assign inject_zneg_ser_3_1_0=eject_zpos_ser_3_1_3;
	assign inject_zpos_ser_3_1_1=eject_zneg_ser_3_1_2;
	assign inject_zneg_ser_3_1_1=eject_zpos_ser_3_1_0;
	assign inject_zpos_ser_3_1_2=eject_zneg_ser_3_1_3;
	assign inject_zneg_ser_3_1_2=eject_zpos_ser_3_1_1;
	assign inject_zpos_ser_3_1_3=eject_zneg_ser_3_1_0;
	assign inject_zneg_ser_3_1_3=eject_zpos_ser_3_1_2;
	assign inject_zpos_ser_3_2_0=eject_zneg_ser_3_2_1;
	assign inject_zneg_ser_3_2_0=eject_zpos_ser_3_2_3;
	assign inject_zpos_ser_3_2_1=eject_zneg_ser_3_2_2;
	assign inject_zneg_ser_3_2_1=eject_zpos_ser_3_2_0;
	assign inject_zpos_ser_3_2_2=eject_zneg_ser_3_2_3;
	assign inject_zneg_ser_3_2_2=eject_zpos_ser_3_2_1;
	assign inject_zpos_ser_3_2_3=eject_zneg_ser_3_2_0;
	assign inject_zneg_ser_3_2_3=eject_zpos_ser_3_2_2;
	assign inject_zpos_ser_3_3_0=eject_zneg_ser_3_3_1;
	assign inject_zneg_ser_3_3_0=eject_zpos_ser_3_3_3;
	assign inject_zpos_ser_3_3_1=eject_zneg_ser_3_3_2;
	assign inject_zneg_ser_3_3_1=eject_zpos_ser_3_3_0;
	assign inject_zpos_ser_3_3_2=eject_zneg_ser_3_3_3;
	assign inject_zneg_ser_3_3_2=eject_zpos_ser_3_3_1;
	assign inject_zpos_ser_3_3_3=eject_zneg_ser_3_3_0;
	assign inject_zneg_ser_3_3_3=eject_zpos_ser_3_3_2;
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(0),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_0_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_0_0),
        .eject_xpos_ser(eject_xpos_ser_0_0_0),
        .inject_xneg_ser(inject_xneg_ser_0_0_0),
        .eject_xneg_ser(eject_xneg_ser_0_0_0),
        .inject_ypos_ser(inject_ypos_ser_0_0_0),
        .eject_ypos_ser(eject_ypos_ser_0_0_0),
        .inject_yneg_ser(inject_yneg_ser_0_0_0),
        .eject_yneg_ser(eject_yneg_ser_0_0_0),
        .inject_zpos_ser(inject_zpos_ser_0_0_0),
        .eject_zpos_ser(eject_zpos_ser_0_0_0),
        .inject_zneg_ser(inject_zneg_ser_0_0_0),
        .eject_zneg_ser(eject_zneg_ser_0_0_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_0_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_0_0),
        .xpos_InjectUtil(xpos_InjectUtil_0_0_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_0_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_0_0),
        .xneg_InjectUtil(xneg_InjectUtil_0_0_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_0_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_0_0),
        .ypos_InjectUtil(ypos_InjectUtil_0_0_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_0_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_0_0),
        .yneg_InjectUtil(yneg_InjectUtil_0_0_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_0_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_0_0),
        .zpos_InjectUtil(zpos_InjectUtil_0_0_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_0_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_0_0),
        .zneg_InjectUtil(zneg_InjectUtil_0_0_0)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(0),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_0_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_0_1),
        .eject_xpos_ser(eject_xpos_ser_0_0_1),
        .inject_xneg_ser(inject_xneg_ser_0_0_1),
        .eject_xneg_ser(eject_xneg_ser_0_0_1),
        .inject_ypos_ser(inject_ypos_ser_0_0_1),
        .eject_ypos_ser(eject_ypos_ser_0_0_1),
        .inject_yneg_ser(inject_yneg_ser_0_0_1),
        .eject_yneg_ser(eject_yneg_ser_0_0_1),
        .inject_zpos_ser(inject_zpos_ser_0_0_1),
        .eject_zpos_ser(eject_zpos_ser_0_0_1),
        .inject_zneg_ser(inject_zneg_ser_0_0_1),
        .eject_zneg_ser(eject_zneg_ser_0_0_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_0_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_0_1),
        .xpos_InjectUtil(xpos_InjectUtil_0_0_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_0_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_0_1),
        .xneg_InjectUtil(xneg_InjectUtil_0_0_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_0_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_0_1),
        .ypos_InjectUtil(ypos_InjectUtil_0_0_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_0_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_0_1),
        .yneg_InjectUtil(yneg_InjectUtil_0_0_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_0_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_0_1),
        .zpos_InjectUtil(zpos_InjectUtil_0_0_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_0_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_0_1),
        .zneg_InjectUtil(zneg_InjectUtil_0_0_1)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(0),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_0_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_0_2),
        .eject_xpos_ser(eject_xpos_ser_0_0_2),
        .inject_xneg_ser(inject_xneg_ser_0_0_2),
        .eject_xneg_ser(eject_xneg_ser_0_0_2),
        .inject_ypos_ser(inject_ypos_ser_0_0_2),
        .eject_ypos_ser(eject_ypos_ser_0_0_2),
        .inject_yneg_ser(inject_yneg_ser_0_0_2),
        .eject_yneg_ser(eject_yneg_ser_0_0_2),
        .inject_zpos_ser(inject_zpos_ser_0_0_2),
        .eject_zpos_ser(eject_zpos_ser_0_0_2),
        .inject_zneg_ser(inject_zneg_ser_0_0_2),
        .eject_zneg_ser(eject_zneg_ser_0_0_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_0_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_0_2),
        .xpos_InjectUtil(xpos_InjectUtil_0_0_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_0_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_0_2),
        .xneg_InjectUtil(xneg_InjectUtil_0_0_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_0_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_0_2),
        .ypos_InjectUtil(ypos_InjectUtil_0_0_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_0_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_0_2),
        .yneg_InjectUtil(yneg_InjectUtil_0_0_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_0_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_0_2),
        .zpos_InjectUtil(zpos_InjectUtil_0_0_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_0_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_0_2),
        .zneg_InjectUtil(zneg_InjectUtil_0_0_2)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(0),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_0_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_0_3),
        .eject_xpos_ser(eject_xpos_ser_0_0_3),
        .inject_xneg_ser(inject_xneg_ser_0_0_3),
        .eject_xneg_ser(eject_xneg_ser_0_0_3),
        .inject_ypos_ser(inject_ypos_ser_0_0_3),
        .eject_ypos_ser(eject_ypos_ser_0_0_3),
        .inject_yneg_ser(inject_yneg_ser_0_0_3),
        .eject_yneg_ser(eject_yneg_ser_0_0_3),
        .inject_zpos_ser(inject_zpos_ser_0_0_3),
        .eject_zpos_ser(eject_zpos_ser_0_0_3),
        .inject_zneg_ser(inject_zneg_ser_0_0_3),
        .eject_zneg_ser(eject_zneg_ser_0_0_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_0_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_0_3),
        .xpos_InjectUtil(xpos_InjectUtil_0_0_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_0_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_0_3),
        .xneg_InjectUtil(xneg_InjectUtil_0_0_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_0_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_0_3),
        .ypos_InjectUtil(ypos_InjectUtil_0_0_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_0_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_0_3),
        .yneg_InjectUtil(yneg_InjectUtil_0_0_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_0_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_0_3),
        .zpos_InjectUtil(zpos_InjectUtil_0_0_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_0_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_0_3),
        .zneg_InjectUtil(zneg_InjectUtil_0_0_3)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(1),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_1_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_1_0),
        .eject_xpos_ser(eject_xpos_ser_0_1_0),
        .inject_xneg_ser(inject_xneg_ser_0_1_0),
        .eject_xneg_ser(eject_xneg_ser_0_1_0),
        .inject_ypos_ser(inject_ypos_ser_0_1_0),
        .eject_ypos_ser(eject_ypos_ser_0_1_0),
        .inject_yneg_ser(inject_yneg_ser_0_1_0),
        .eject_yneg_ser(eject_yneg_ser_0_1_0),
        .inject_zpos_ser(inject_zpos_ser_0_1_0),
        .eject_zpos_ser(eject_zpos_ser_0_1_0),
        .inject_zneg_ser(inject_zneg_ser_0_1_0),
        .eject_zneg_ser(eject_zneg_ser_0_1_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_1_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_1_0),
        .xpos_InjectUtil(xpos_InjectUtil_0_1_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_1_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_1_0),
        .xneg_InjectUtil(xneg_InjectUtil_0_1_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_1_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_1_0),
        .ypos_InjectUtil(ypos_InjectUtil_0_1_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_1_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_1_0),
        .yneg_InjectUtil(yneg_InjectUtil_0_1_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_1_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_1_0),
        .zpos_InjectUtil(zpos_InjectUtil_0_1_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_1_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_1_0),
        .zneg_InjectUtil(zneg_InjectUtil_0_1_0)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(1),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_1_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_1_1),
        .eject_xpos_ser(eject_xpos_ser_0_1_1),
        .inject_xneg_ser(inject_xneg_ser_0_1_1),
        .eject_xneg_ser(eject_xneg_ser_0_1_1),
        .inject_ypos_ser(inject_ypos_ser_0_1_1),
        .eject_ypos_ser(eject_ypos_ser_0_1_1),
        .inject_yneg_ser(inject_yneg_ser_0_1_1),
        .eject_yneg_ser(eject_yneg_ser_0_1_1),
        .inject_zpos_ser(inject_zpos_ser_0_1_1),
        .eject_zpos_ser(eject_zpos_ser_0_1_1),
        .inject_zneg_ser(inject_zneg_ser_0_1_1),
        .eject_zneg_ser(eject_zneg_ser_0_1_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_1_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_1_1),
        .xpos_InjectUtil(xpos_InjectUtil_0_1_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_1_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_1_1),
        .xneg_InjectUtil(xneg_InjectUtil_0_1_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_1_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_1_1),
        .ypos_InjectUtil(ypos_InjectUtil_0_1_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_1_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_1_1),
        .yneg_InjectUtil(yneg_InjectUtil_0_1_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_1_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_1_1),
        .zpos_InjectUtil(zpos_InjectUtil_0_1_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_1_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_1_1),
        .zneg_InjectUtil(zneg_InjectUtil_0_1_1)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(1),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_1_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_1_2),
        .eject_xpos_ser(eject_xpos_ser_0_1_2),
        .inject_xneg_ser(inject_xneg_ser_0_1_2),
        .eject_xneg_ser(eject_xneg_ser_0_1_2),
        .inject_ypos_ser(inject_ypos_ser_0_1_2),
        .eject_ypos_ser(eject_ypos_ser_0_1_2),
        .inject_yneg_ser(inject_yneg_ser_0_1_2),
        .eject_yneg_ser(eject_yneg_ser_0_1_2),
        .inject_zpos_ser(inject_zpos_ser_0_1_2),
        .eject_zpos_ser(eject_zpos_ser_0_1_2),
        .inject_zneg_ser(inject_zneg_ser_0_1_2),
        .eject_zneg_ser(eject_zneg_ser_0_1_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_1_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_1_2),
        .xpos_InjectUtil(xpos_InjectUtil_0_1_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_1_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_1_2),
        .xneg_InjectUtil(xneg_InjectUtil_0_1_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_1_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_1_2),
        .ypos_InjectUtil(ypos_InjectUtil_0_1_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_1_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_1_2),
        .yneg_InjectUtil(yneg_InjectUtil_0_1_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_1_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_1_2),
        .zpos_InjectUtil(zpos_InjectUtil_0_1_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_1_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_1_2),
        .zneg_InjectUtil(zneg_InjectUtil_0_1_2)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(1),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_1_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_1_3),
        .eject_xpos_ser(eject_xpos_ser_0_1_3),
        .inject_xneg_ser(inject_xneg_ser_0_1_3),
        .eject_xneg_ser(eject_xneg_ser_0_1_3),
        .inject_ypos_ser(inject_ypos_ser_0_1_3),
        .eject_ypos_ser(eject_ypos_ser_0_1_3),
        .inject_yneg_ser(inject_yneg_ser_0_1_3),
        .eject_yneg_ser(eject_yneg_ser_0_1_3),
        .inject_zpos_ser(inject_zpos_ser_0_1_3),
        .eject_zpos_ser(eject_zpos_ser_0_1_3),
        .inject_zneg_ser(inject_zneg_ser_0_1_3),
        .eject_zneg_ser(eject_zneg_ser_0_1_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_1_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_1_3),
        .xpos_InjectUtil(xpos_InjectUtil_0_1_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_1_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_1_3),
        .xneg_InjectUtil(xneg_InjectUtil_0_1_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_1_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_1_3),
        .ypos_InjectUtil(ypos_InjectUtil_0_1_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_1_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_1_3),
        .yneg_InjectUtil(yneg_InjectUtil_0_1_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_1_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_1_3),
        .zpos_InjectUtil(zpos_InjectUtil_0_1_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_1_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_1_3),
        .zneg_InjectUtil(zneg_InjectUtil_0_1_3)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(2),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_2_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_2_0),
        .eject_xpos_ser(eject_xpos_ser_0_2_0),
        .inject_xneg_ser(inject_xneg_ser_0_2_0),
        .eject_xneg_ser(eject_xneg_ser_0_2_0),
        .inject_ypos_ser(inject_ypos_ser_0_2_0),
        .eject_ypos_ser(eject_ypos_ser_0_2_0),
        .inject_yneg_ser(inject_yneg_ser_0_2_0),
        .eject_yneg_ser(eject_yneg_ser_0_2_0),
        .inject_zpos_ser(inject_zpos_ser_0_2_0),
        .eject_zpos_ser(eject_zpos_ser_0_2_0),
        .inject_zneg_ser(inject_zneg_ser_0_2_0),
        .eject_zneg_ser(eject_zneg_ser_0_2_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_2_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_2_0),
        .xpos_InjectUtil(xpos_InjectUtil_0_2_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_2_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_2_0),
        .xneg_InjectUtil(xneg_InjectUtil_0_2_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_2_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_2_0),
        .ypos_InjectUtil(ypos_InjectUtil_0_2_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_2_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_2_0),
        .yneg_InjectUtil(yneg_InjectUtil_0_2_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_2_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_2_0),
        .zpos_InjectUtil(zpos_InjectUtil_0_2_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_2_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_2_0),
        .zneg_InjectUtil(zneg_InjectUtil_0_2_0)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(2),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_2_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_2_1),
        .eject_xpos_ser(eject_xpos_ser_0_2_1),
        .inject_xneg_ser(inject_xneg_ser_0_2_1),
        .eject_xneg_ser(eject_xneg_ser_0_2_1),
        .inject_ypos_ser(inject_ypos_ser_0_2_1),
        .eject_ypos_ser(eject_ypos_ser_0_2_1),
        .inject_yneg_ser(inject_yneg_ser_0_2_1),
        .eject_yneg_ser(eject_yneg_ser_0_2_1),
        .inject_zpos_ser(inject_zpos_ser_0_2_1),
        .eject_zpos_ser(eject_zpos_ser_0_2_1),
        .inject_zneg_ser(inject_zneg_ser_0_2_1),
        .eject_zneg_ser(eject_zneg_ser_0_2_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_2_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_2_1),
        .xpos_InjectUtil(xpos_InjectUtil_0_2_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_2_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_2_1),
        .xneg_InjectUtil(xneg_InjectUtil_0_2_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_2_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_2_1),
        .ypos_InjectUtil(ypos_InjectUtil_0_2_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_2_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_2_1),
        .yneg_InjectUtil(yneg_InjectUtil_0_2_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_2_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_2_1),
        .zpos_InjectUtil(zpos_InjectUtil_0_2_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_2_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_2_1),
        .zneg_InjectUtil(zneg_InjectUtil_0_2_1)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(2),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_2_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_2_2),
        .eject_xpos_ser(eject_xpos_ser_0_2_2),
        .inject_xneg_ser(inject_xneg_ser_0_2_2),
        .eject_xneg_ser(eject_xneg_ser_0_2_2),
        .inject_ypos_ser(inject_ypos_ser_0_2_2),
        .eject_ypos_ser(eject_ypos_ser_0_2_2),
        .inject_yneg_ser(inject_yneg_ser_0_2_2),
        .eject_yneg_ser(eject_yneg_ser_0_2_2),
        .inject_zpos_ser(inject_zpos_ser_0_2_2),
        .eject_zpos_ser(eject_zpos_ser_0_2_2),
        .inject_zneg_ser(inject_zneg_ser_0_2_2),
        .eject_zneg_ser(eject_zneg_ser_0_2_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_2_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_2_2),
        .xpos_InjectUtil(xpos_InjectUtil_0_2_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_2_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_2_2),
        .xneg_InjectUtil(xneg_InjectUtil_0_2_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_2_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_2_2),
        .ypos_InjectUtil(ypos_InjectUtil_0_2_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_2_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_2_2),
        .yneg_InjectUtil(yneg_InjectUtil_0_2_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_2_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_2_2),
        .zpos_InjectUtil(zpos_InjectUtil_0_2_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_2_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_2_2),
        .zneg_InjectUtil(zneg_InjectUtil_0_2_2)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(2),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_2_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_2_3),
        .eject_xpos_ser(eject_xpos_ser_0_2_3),
        .inject_xneg_ser(inject_xneg_ser_0_2_3),
        .eject_xneg_ser(eject_xneg_ser_0_2_3),
        .inject_ypos_ser(inject_ypos_ser_0_2_3),
        .eject_ypos_ser(eject_ypos_ser_0_2_3),
        .inject_yneg_ser(inject_yneg_ser_0_2_3),
        .eject_yneg_ser(eject_yneg_ser_0_2_3),
        .inject_zpos_ser(inject_zpos_ser_0_2_3),
        .eject_zpos_ser(eject_zpos_ser_0_2_3),
        .inject_zneg_ser(inject_zneg_ser_0_2_3),
        .eject_zneg_ser(eject_zneg_ser_0_2_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_2_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_2_3),
        .xpos_InjectUtil(xpos_InjectUtil_0_2_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_2_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_2_3),
        .xneg_InjectUtil(xneg_InjectUtil_0_2_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_2_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_2_3),
        .ypos_InjectUtil(ypos_InjectUtil_0_2_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_2_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_2_3),
        .yneg_InjectUtil(yneg_InjectUtil_0_2_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_2_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_2_3),
        .zpos_InjectUtil(zpos_InjectUtil_0_2_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_2_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_2_3),
        .zneg_InjectUtil(zneg_InjectUtil_0_2_3)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(3),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_3_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_3_0),
        .eject_xpos_ser(eject_xpos_ser_0_3_0),
        .inject_xneg_ser(inject_xneg_ser_0_3_0),
        .eject_xneg_ser(eject_xneg_ser_0_3_0),
        .inject_ypos_ser(inject_ypos_ser_0_3_0),
        .eject_ypos_ser(eject_ypos_ser_0_3_0),
        .inject_yneg_ser(inject_yneg_ser_0_3_0),
        .eject_yneg_ser(eject_yneg_ser_0_3_0),
        .inject_zpos_ser(inject_zpos_ser_0_3_0),
        .eject_zpos_ser(eject_zpos_ser_0_3_0),
        .inject_zneg_ser(inject_zneg_ser_0_3_0),
        .eject_zneg_ser(eject_zneg_ser_0_3_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_3_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_3_0),
        .xpos_InjectUtil(xpos_InjectUtil_0_3_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_3_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_3_0),
        .xneg_InjectUtil(xneg_InjectUtil_0_3_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_3_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_3_0),
        .ypos_InjectUtil(ypos_InjectUtil_0_3_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_3_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_3_0),
        .yneg_InjectUtil(yneg_InjectUtil_0_3_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_3_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_3_0),
        .zpos_InjectUtil(zpos_InjectUtil_0_3_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_3_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_3_0),
        .zneg_InjectUtil(zneg_InjectUtil_0_3_0)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(3),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_3_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_3_1),
        .eject_xpos_ser(eject_xpos_ser_0_3_1),
        .inject_xneg_ser(inject_xneg_ser_0_3_1),
        .eject_xneg_ser(eject_xneg_ser_0_3_1),
        .inject_ypos_ser(inject_ypos_ser_0_3_1),
        .eject_ypos_ser(eject_ypos_ser_0_3_1),
        .inject_yneg_ser(inject_yneg_ser_0_3_1),
        .eject_yneg_ser(eject_yneg_ser_0_3_1),
        .inject_zpos_ser(inject_zpos_ser_0_3_1),
        .eject_zpos_ser(eject_zpos_ser_0_3_1),
        .inject_zneg_ser(inject_zneg_ser_0_3_1),
        .eject_zneg_ser(eject_zneg_ser_0_3_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_3_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_3_1),
        .xpos_InjectUtil(xpos_InjectUtil_0_3_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_3_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_3_1),
        .xneg_InjectUtil(xneg_InjectUtil_0_3_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_3_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_3_1),
        .ypos_InjectUtil(ypos_InjectUtil_0_3_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_3_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_3_1),
        .yneg_InjectUtil(yneg_InjectUtil_0_3_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_3_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_3_1),
        .zpos_InjectUtil(zpos_InjectUtil_0_3_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_3_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_3_1),
        .zneg_InjectUtil(zneg_InjectUtil_0_3_1)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(3),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_3_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_3_2),
        .eject_xpos_ser(eject_xpos_ser_0_3_2),
        .inject_xneg_ser(inject_xneg_ser_0_3_2),
        .eject_xneg_ser(eject_xneg_ser_0_3_2),
        .inject_ypos_ser(inject_ypos_ser_0_3_2),
        .eject_ypos_ser(eject_ypos_ser_0_3_2),
        .inject_yneg_ser(inject_yneg_ser_0_3_2),
        .eject_yneg_ser(eject_yneg_ser_0_3_2),
        .inject_zpos_ser(inject_zpos_ser_0_3_2),
        .eject_zpos_ser(eject_zpos_ser_0_3_2),
        .inject_zneg_ser(inject_zneg_ser_0_3_2),
        .eject_zneg_ser(eject_zneg_ser_0_3_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_3_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_3_2),
        .xpos_InjectUtil(xpos_InjectUtil_0_3_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_3_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_3_2),
        .xneg_InjectUtil(xneg_InjectUtil_0_3_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_3_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_3_2),
        .ypos_InjectUtil(ypos_InjectUtil_0_3_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_3_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_3_2),
        .yneg_InjectUtil(yneg_InjectUtil_0_3_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_3_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_3_2),
        .zpos_InjectUtil(zpos_InjectUtil_0_3_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_3_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_3_2),
        .zneg_InjectUtil(zneg_InjectUtil_0_3_2)
);
    node#(
        .DataSize(DataSize),
        .X(0),
        .Y(3),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_0_3_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_0_3_3),
        .eject_xpos_ser(eject_xpos_ser_0_3_3),
        .inject_xneg_ser(inject_xneg_ser_0_3_3),
        .eject_xneg_ser(eject_xneg_ser_0_3_3),
        .inject_ypos_ser(inject_ypos_ser_0_3_3),
        .eject_ypos_ser(eject_ypos_ser_0_3_3),
        .inject_yneg_ser(inject_yneg_ser_0_3_3),
        .eject_yneg_ser(eject_yneg_ser_0_3_3),
        .inject_zpos_ser(inject_zpos_ser_0_3_3),
        .eject_zpos_ser(eject_zpos_ser_0_3_3),
        .inject_zneg_ser(inject_zneg_ser_0_3_3),
        .eject_zneg_ser(eject_zneg_ser_0_3_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_0_3_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_0_3_3),
        .xpos_InjectUtil(xpos_InjectUtil_0_3_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_0_3_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_0_3_3),
        .xneg_InjectUtil(xneg_InjectUtil_0_3_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_0_3_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_0_3_3),
        .ypos_InjectUtil(ypos_InjectUtil_0_3_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_0_3_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_0_3_3),
        .yneg_InjectUtil(yneg_InjectUtil_0_3_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_0_3_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_0_3_3),
        .zpos_InjectUtil(zpos_InjectUtil_0_3_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_0_3_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_0_3_3),
        .zneg_InjectUtil(zneg_InjectUtil_0_3_3)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(0),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_0_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_0_0),
        .eject_xpos_ser(eject_xpos_ser_1_0_0),
        .inject_xneg_ser(inject_xneg_ser_1_0_0),
        .eject_xneg_ser(eject_xneg_ser_1_0_0),
        .inject_ypos_ser(inject_ypos_ser_1_0_0),
        .eject_ypos_ser(eject_ypos_ser_1_0_0),
        .inject_yneg_ser(inject_yneg_ser_1_0_0),
        .eject_yneg_ser(eject_yneg_ser_1_0_0),
        .inject_zpos_ser(inject_zpos_ser_1_0_0),
        .eject_zpos_ser(eject_zpos_ser_1_0_0),
        .inject_zneg_ser(inject_zneg_ser_1_0_0),
        .eject_zneg_ser(eject_zneg_ser_1_0_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_0_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_0_0),
        .xpos_InjectUtil(xpos_InjectUtil_1_0_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_0_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_0_0),
        .xneg_InjectUtil(xneg_InjectUtil_1_0_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_0_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_0_0),
        .ypos_InjectUtil(ypos_InjectUtil_1_0_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_0_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_0_0),
        .yneg_InjectUtil(yneg_InjectUtil_1_0_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_0_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_0_0),
        .zpos_InjectUtil(zpos_InjectUtil_1_0_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_0_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_0_0),
        .zneg_InjectUtil(zneg_InjectUtil_1_0_0)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(0),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_0_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_0_1),
        .eject_xpos_ser(eject_xpos_ser_1_0_1),
        .inject_xneg_ser(inject_xneg_ser_1_0_1),
        .eject_xneg_ser(eject_xneg_ser_1_0_1),
        .inject_ypos_ser(inject_ypos_ser_1_0_1),
        .eject_ypos_ser(eject_ypos_ser_1_0_1),
        .inject_yneg_ser(inject_yneg_ser_1_0_1),
        .eject_yneg_ser(eject_yneg_ser_1_0_1),
        .inject_zpos_ser(inject_zpos_ser_1_0_1),
        .eject_zpos_ser(eject_zpos_ser_1_0_1),
        .inject_zneg_ser(inject_zneg_ser_1_0_1),
        .eject_zneg_ser(eject_zneg_ser_1_0_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_0_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_0_1),
        .xpos_InjectUtil(xpos_InjectUtil_1_0_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_0_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_0_1),
        .xneg_InjectUtil(xneg_InjectUtil_1_0_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_0_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_0_1),
        .ypos_InjectUtil(ypos_InjectUtil_1_0_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_0_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_0_1),
        .yneg_InjectUtil(yneg_InjectUtil_1_0_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_0_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_0_1),
        .zpos_InjectUtil(zpos_InjectUtil_1_0_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_0_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_0_1),
        .zneg_InjectUtil(zneg_InjectUtil_1_0_1)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(0),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_0_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_0_2),
        .eject_xpos_ser(eject_xpos_ser_1_0_2),
        .inject_xneg_ser(inject_xneg_ser_1_0_2),
        .eject_xneg_ser(eject_xneg_ser_1_0_2),
        .inject_ypos_ser(inject_ypos_ser_1_0_2),
        .eject_ypos_ser(eject_ypos_ser_1_0_2),
        .inject_yneg_ser(inject_yneg_ser_1_0_2),
        .eject_yneg_ser(eject_yneg_ser_1_0_2),
        .inject_zpos_ser(inject_zpos_ser_1_0_2),
        .eject_zpos_ser(eject_zpos_ser_1_0_2),
        .inject_zneg_ser(inject_zneg_ser_1_0_2),
        .eject_zneg_ser(eject_zneg_ser_1_0_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_0_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_0_2),
        .xpos_InjectUtil(xpos_InjectUtil_1_0_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_0_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_0_2),
        .xneg_InjectUtil(xneg_InjectUtil_1_0_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_0_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_0_2),
        .ypos_InjectUtil(ypos_InjectUtil_1_0_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_0_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_0_2),
        .yneg_InjectUtil(yneg_InjectUtil_1_0_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_0_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_0_2),
        .zpos_InjectUtil(zpos_InjectUtil_1_0_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_0_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_0_2),
        .zneg_InjectUtil(zneg_InjectUtil_1_0_2)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(0),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_0_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_0_3),
        .eject_xpos_ser(eject_xpos_ser_1_0_3),
        .inject_xneg_ser(inject_xneg_ser_1_0_3),
        .eject_xneg_ser(eject_xneg_ser_1_0_3),
        .inject_ypos_ser(inject_ypos_ser_1_0_3),
        .eject_ypos_ser(eject_ypos_ser_1_0_3),
        .inject_yneg_ser(inject_yneg_ser_1_0_3),
        .eject_yneg_ser(eject_yneg_ser_1_0_3),
        .inject_zpos_ser(inject_zpos_ser_1_0_3),
        .eject_zpos_ser(eject_zpos_ser_1_0_3),
        .inject_zneg_ser(inject_zneg_ser_1_0_3),
        .eject_zneg_ser(eject_zneg_ser_1_0_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_0_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_0_3),
        .xpos_InjectUtil(xpos_InjectUtil_1_0_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_0_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_0_3),
        .xneg_InjectUtil(xneg_InjectUtil_1_0_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_0_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_0_3),
        .ypos_InjectUtil(ypos_InjectUtil_1_0_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_0_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_0_3),
        .yneg_InjectUtil(yneg_InjectUtil_1_0_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_0_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_0_3),
        .zpos_InjectUtil(zpos_InjectUtil_1_0_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_0_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_0_3),
        .zneg_InjectUtil(zneg_InjectUtil_1_0_3)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(1),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_1_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_1_0),
        .eject_xpos_ser(eject_xpos_ser_1_1_0),
        .inject_xneg_ser(inject_xneg_ser_1_1_0),
        .eject_xneg_ser(eject_xneg_ser_1_1_0),
        .inject_ypos_ser(inject_ypos_ser_1_1_0),
        .eject_ypos_ser(eject_ypos_ser_1_1_0),
        .inject_yneg_ser(inject_yneg_ser_1_1_0),
        .eject_yneg_ser(eject_yneg_ser_1_1_0),
        .inject_zpos_ser(inject_zpos_ser_1_1_0),
        .eject_zpos_ser(eject_zpos_ser_1_1_0),
        .inject_zneg_ser(inject_zneg_ser_1_1_0),
        .eject_zneg_ser(eject_zneg_ser_1_1_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_1_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_1_0),
        .xpos_InjectUtil(xpos_InjectUtil_1_1_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_1_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_1_0),
        .xneg_InjectUtil(xneg_InjectUtil_1_1_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_1_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_1_0),
        .ypos_InjectUtil(ypos_InjectUtil_1_1_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_1_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_1_0),
        .yneg_InjectUtil(yneg_InjectUtil_1_1_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_1_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_1_0),
        .zpos_InjectUtil(zpos_InjectUtil_1_1_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_1_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_1_0),
        .zneg_InjectUtil(zneg_InjectUtil_1_1_0)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(1),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_1_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_1_1),
        .eject_xpos_ser(eject_xpos_ser_1_1_1),
        .inject_xneg_ser(inject_xneg_ser_1_1_1),
        .eject_xneg_ser(eject_xneg_ser_1_1_1),
        .inject_ypos_ser(inject_ypos_ser_1_1_1),
        .eject_ypos_ser(eject_ypos_ser_1_1_1),
        .inject_yneg_ser(inject_yneg_ser_1_1_1),
        .eject_yneg_ser(eject_yneg_ser_1_1_1),
        .inject_zpos_ser(inject_zpos_ser_1_1_1),
        .eject_zpos_ser(eject_zpos_ser_1_1_1),
        .inject_zneg_ser(inject_zneg_ser_1_1_1),
        .eject_zneg_ser(eject_zneg_ser_1_1_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_1_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_1_1),
        .xpos_InjectUtil(xpos_InjectUtil_1_1_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_1_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_1_1),
        .xneg_InjectUtil(xneg_InjectUtil_1_1_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_1_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_1_1),
        .ypos_InjectUtil(ypos_InjectUtil_1_1_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_1_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_1_1),
        .yneg_InjectUtil(yneg_InjectUtil_1_1_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_1_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_1_1),
        .zpos_InjectUtil(zpos_InjectUtil_1_1_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_1_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_1_1),
        .zneg_InjectUtil(zneg_InjectUtil_1_1_1)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(1),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_1_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_1_2),
        .eject_xpos_ser(eject_xpos_ser_1_1_2),
        .inject_xneg_ser(inject_xneg_ser_1_1_2),
        .eject_xneg_ser(eject_xneg_ser_1_1_2),
        .inject_ypos_ser(inject_ypos_ser_1_1_2),
        .eject_ypos_ser(eject_ypos_ser_1_1_2),
        .inject_yneg_ser(inject_yneg_ser_1_1_2),
        .eject_yneg_ser(eject_yneg_ser_1_1_2),
        .inject_zpos_ser(inject_zpos_ser_1_1_2),
        .eject_zpos_ser(eject_zpos_ser_1_1_2),
        .inject_zneg_ser(inject_zneg_ser_1_1_2),
        .eject_zneg_ser(eject_zneg_ser_1_1_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_1_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_1_2),
        .xpos_InjectUtil(xpos_InjectUtil_1_1_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_1_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_1_2),
        .xneg_InjectUtil(xneg_InjectUtil_1_1_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_1_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_1_2),
        .ypos_InjectUtil(ypos_InjectUtil_1_1_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_1_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_1_2),
        .yneg_InjectUtil(yneg_InjectUtil_1_1_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_1_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_1_2),
        .zpos_InjectUtil(zpos_InjectUtil_1_1_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_1_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_1_2),
        .zneg_InjectUtil(zneg_InjectUtil_1_1_2)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(1),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_1_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_1_3),
        .eject_xpos_ser(eject_xpos_ser_1_1_3),
        .inject_xneg_ser(inject_xneg_ser_1_1_3),
        .eject_xneg_ser(eject_xneg_ser_1_1_3),
        .inject_ypos_ser(inject_ypos_ser_1_1_3),
        .eject_ypos_ser(eject_ypos_ser_1_1_3),
        .inject_yneg_ser(inject_yneg_ser_1_1_3),
        .eject_yneg_ser(eject_yneg_ser_1_1_3),
        .inject_zpos_ser(inject_zpos_ser_1_1_3),
        .eject_zpos_ser(eject_zpos_ser_1_1_3),
        .inject_zneg_ser(inject_zneg_ser_1_1_3),
        .eject_zneg_ser(eject_zneg_ser_1_1_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_1_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_1_3),
        .xpos_InjectUtil(xpos_InjectUtil_1_1_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_1_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_1_3),
        .xneg_InjectUtil(xneg_InjectUtil_1_1_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_1_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_1_3),
        .ypos_InjectUtil(ypos_InjectUtil_1_1_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_1_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_1_3),
        .yneg_InjectUtil(yneg_InjectUtil_1_1_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_1_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_1_3),
        .zpos_InjectUtil(zpos_InjectUtil_1_1_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_1_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_1_3),
        .zneg_InjectUtil(zneg_InjectUtil_1_1_3)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(2),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_2_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_2_0),
        .eject_xpos_ser(eject_xpos_ser_1_2_0),
        .inject_xneg_ser(inject_xneg_ser_1_2_0),
        .eject_xneg_ser(eject_xneg_ser_1_2_0),
        .inject_ypos_ser(inject_ypos_ser_1_2_0),
        .eject_ypos_ser(eject_ypos_ser_1_2_0),
        .inject_yneg_ser(inject_yneg_ser_1_2_0),
        .eject_yneg_ser(eject_yneg_ser_1_2_0),
        .inject_zpos_ser(inject_zpos_ser_1_2_0),
        .eject_zpos_ser(eject_zpos_ser_1_2_0),
        .inject_zneg_ser(inject_zneg_ser_1_2_0),
        .eject_zneg_ser(eject_zneg_ser_1_2_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_2_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_2_0),
        .xpos_InjectUtil(xpos_InjectUtil_1_2_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_2_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_2_0),
        .xneg_InjectUtil(xneg_InjectUtil_1_2_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_2_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_2_0),
        .ypos_InjectUtil(ypos_InjectUtil_1_2_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_2_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_2_0),
        .yneg_InjectUtil(yneg_InjectUtil_1_2_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_2_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_2_0),
        .zpos_InjectUtil(zpos_InjectUtil_1_2_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_2_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_2_0),
        .zneg_InjectUtil(zneg_InjectUtil_1_2_0)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(2),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_2_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_2_1),
        .eject_xpos_ser(eject_xpos_ser_1_2_1),
        .inject_xneg_ser(inject_xneg_ser_1_2_1),
        .eject_xneg_ser(eject_xneg_ser_1_2_1),
        .inject_ypos_ser(inject_ypos_ser_1_2_1),
        .eject_ypos_ser(eject_ypos_ser_1_2_1),
        .inject_yneg_ser(inject_yneg_ser_1_2_1),
        .eject_yneg_ser(eject_yneg_ser_1_2_1),
        .inject_zpos_ser(inject_zpos_ser_1_2_1),
        .eject_zpos_ser(eject_zpos_ser_1_2_1),
        .inject_zneg_ser(inject_zneg_ser_1_2_1),
        .eject_zneg_ser(eject_zneg_ser_1_2_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_2_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_2_1),
        .xpos_InjectUtil(xpos_InjectUtil_1_2_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_2_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_2_1),
        .xneg_InjectUtil(xneg_InjectUtil_1_2_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_2_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_2_1),
        .ypos_InjectUtil(ypos_InjectUtil_1_2_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_2_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_2_1),
        .yneg_InjectUtil(yneg_InjectUtil_1_2_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_2_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_2_1),
        .zpos_InjectUtil(zpos_InjectUtil_1_2_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_2_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_2_1),
        .zneg_InjectUtil(zneg_InjectUtil_1_2_1)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(2),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_2_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_2_2),
        .eject_xpos_ser(eject_xpos_ser_1_2_2),
        .inject_xneg_ser(inject_xneg_ser_1_2_2),
        .eject_xneg_ser(eject_xneg_ser_1_2_2),
        .inject_ypos_ser(inject_ypos_ser_1_2_2),
        .eject_ypos_ser(eject_ypos_ser_1_2_2),
        .inject_yneg_ser(inject_yneg_ser_1_2_2),
        .eject_yneg_ser(eject_yneg_ser_1_2_2),
        .inject_zpos_ser(inject_zpos_ser_1_2_2),
        .eject_zpos_ser(eject_zpos_ser_1_2_2),
        .inject_zneg_ser(inject_zneg_ser_1_2_2),
        .eject_zneg_ser(eject_zneg_ser_1_2_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_2_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_2_2),
        .xpos_InjectUtil(xpos_InjectUtil_1_2_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_2_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_2_2),
        .xneg_InjectUtil(xneg_InjectUtil_1_2_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_2_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_2_2),
        .ypos_InjectUtil(ypos_InjectUtil_1_2_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_2_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_2_2),
        .yneg_InjectUtil(yneg_InjectUtil_1_2_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_2_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_2_2),
        .zpos_InjectUtil(zpos_InjectUtil_1_2_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_2_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_2_2),
        .zneg_InjectUtil(zneg_InjectUtil_1_2_2)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(2),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_2_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_2_3),
        .eject_xpos_ser(eject_xpos_ser_1_2_3),
        .inject_xneg_ser(inject_xneg_ser_1_2_3),
        .eject_xneg_ser(eject_xneg_ser_1_2_3),
        .inject_ypos_ser(inject_ypos_ser_1_2_3),
        .eject_ypos_ser(eject_ypos_ser_1_2_3),
        .inject_yneg_ser(inject_yneg_ser_1_2_3),
        .eject_yneg_ser(eject_yneg_ser_1_2_3),
        .inject_zpos_ser(inject_zpos_ser_1_2_3),
        .eject_zpos_ser(eject_zpos_ser_1_2_3),
        .inject_zneg_ser(inject_zneg_ser_1_2_3),
        .eject_zneg_ser(eject_zneg_ser_1_2_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_2_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_2_3),
        .xpos_InjectUtil(xpos_InjectUtil_1_2_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_2_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_2_3),
        .xneg_InjectUtil(xneg_InjectUtil_1_2_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_2_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_2_3),
        .ypos_InjectUtil(ypos_InjectUtil_1_2_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_2_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_2_3),
        .yneg_InjectUtil(yneg_InjectUtil_1_2_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_2_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_2_3),
        .zpos_InjectUtil(zpos_InjectUtil_1_2_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_2_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_2_3),
        .zneg_InjectUtil(zneg_InjectUtil_1_2_3)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(3),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_3_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_3_0),
        .eject_xpos_ser(eject_xpos_ser_1_3_0),
        .inject_xneg_ser(inject_xneg_ser_1_3_0),
        .eject_xneg_ser(eject_xneg_ser_1_3_0),
        .inject_ypos_ser(inject_ypos_ser_1_3_0),
        .eject_ypos_ser(eject_ypos_ser_1_3_0),
        .inject_yneg_ser(inject_yneg_ser_1_3_0),
        .eject_yneg_ser(eject_yneg_ser_1_3_0),
        .inject_zpos_ser(inject_zpos_ser_1_3_0),
        .eject_zpos_ser(eject_zpos_ser_1_3_0),
        .inject_zneg_ser(inject_zneg_ser_1_3_0),
        .eject_zneg_ser(eject_zneg_ser_1_3_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_3_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_3_0),
        .xpos_InjectUtil(xpos_InjectUtil_1_3_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_3_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_3_0),
        .xneg_InjectUtil(xneg_InjectUtil_1_3_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_3_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_3_0),
        .ypos_InjectUtil(ypos_InjectUtil_1_3_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_3_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_3_0),
        .yneg_InjectUtil(yneg_InjectUtil_1_3_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_3_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_3_0),
        .zpos_InjectUtil(zpos_InjectUtil_1_3_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_3_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_3_0),
        .zneg_InjectUtil(zneg_InjectUtil_1_3_0)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(3),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_3_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_3_1),
        .eject_xpos_ser(eject_xpos_ser_1_3_1),
        .inject_xneg_ser(inject_xneg_ser_1_3_1),
        .eject_xneg_ser(eject_xneg_ser_1_3_1),
        .inject_ypos_ser(inject_ypos_ser_1_3_1),
        .eject_ypos_ser(eject_ypos_ser_1_3_1),
        .inject_yneg_ser(inject_yneg_ser_1_3_1),
        .eject_yneg_ser(eject_yneg_ser_1_3_1),
        .inject_zpos_ser(inject_zpos_ser_1_3_1),
        .eject_zpos_ser(eject_zpos_ser_1_3_1),
        .inject_zneg_ser(inject_zneg_ser_1_3_1),
        .eject_zneg_ser(eject_zneg_ser_1_3_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_3_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_3_1),
        .xpos_InjectUtil(xpos_InjectUtil_1_3_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_3_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_3_1),
        .xneg_InjectUtil(xneg_InjectUtil_1_3_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_3_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_3_1),
        .ypos_InjectUtil(ypos_InjectUtil_1_3_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_3_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_3_1),
        .yneg_InjectUtil(yneg_InjectUtil_1_3_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_3_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_3_1),
        .zpos_InjectUtil(zpos_InjectUtil_1_3_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_3_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_3_1),
        .zneg_InjectUtil(zneg_InjectUtil_1_3_1)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(3),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_3_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_3_2),
        .eject_xpos_ser(eject_xpos_ser_1_3_2),
        .inject_xneg_ser(inject_xneg_ser_1_3_2),
        .eject_xneg_ser(eject_xneg_ser_1_3_2),
        .inject_ypos_ser(inject_ypos_ser_1_3_2),
        .eject_ypos_ser(eject_ypos_ser_1_3_2),
        .inject_yneg_ser(inject_yneg_ser_1_3_2),
        .eject_yneg_ser(eject_yneg_ser_1_3_2),
        .inject_zpos_ser(inject_zpos_ser_1_3_2),
        .eject_zpos_ser(eject_zpos_ser_1_3_2),
        .inject_zneg_ser(inject_zneg_ser_1_3_2),
        .eject_zneg_ser(eject_zneg_ser_1_3_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_3_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_3_2),
        .xpos_InjectUtil(xpos_InjectUtil_1_3_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_3_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_3_2),
        .xneg_InjectUtil(xneg_InjectUtil_1_3_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_3_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_3_2),
        .ypos_InjectUtil(ypos_InjectUtil_1_3_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_3_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_3_2),
        .yneg_InjectUtil(yneg_InjectUtil_1_3_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_3_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_3_2),
        .zpos_InjectUtil(zpos_InjectUtil_1_3_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_3_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_3_2),
        .zneg_InjectUtil(zneg_InjectUtil_1_3_2)
);
    node#(
        .DataSize(DataSize),
        .X(1),
        .Y(3),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_1_3_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_1_3_3),
        .eject_xpos_ser(eject_xpos_ser_1_3_3),
        .inject_xneg_ser(inject_xneg_ser_1_3_3),
        .eject_xneg_ser(eject_xneg_ser_1_3_3),
        .inject_ypos_ser(inject_ypos_ser_1_3_3),
        .eject_ypos_ser(eject_ypos_ser_1_3_3),
        .inject_yneg_ser(inject_yneg_ser_1_3_3),
        .eject_yneg_ser(eject_yneg_ser_1_3_3),
        .inject_zpos_ser(inject_zpos_ser_1_3_3),
        .eject_zpos_ser(eject_zpos_ser_1_3_3),
        .inject_zneg_ser(inject_zneg_ser_1_3_3),
        .eject_zneg_ser(eject_zneg_ser_1_3_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_1_3_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_1_3_3),
        .xpos_InjectUtil(xpos_InjectUtil_1_3_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_1_3_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_1_3_3),
        .xneg_InjectUtil(xneg_InjectUtil_1_3_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_1_3_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_1_3_3),
        .ypos_InjectUtil(ypos_InjectUtil_1_3_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_1_3_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_1_3_3),
        .yneg_InjectUtil(yneg_InjectUtil_1_3_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_1_3_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_1_3_3),
        .zpos_InjectUtil(zpos_InjectUtil_1_3_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_1_3_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_1_3_3),
        .zneg_InjectUtil(zneg_InjectUtil_1_3_3)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(0),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_0_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_0_0),
        .eject_xpos_ser(eject_xpos_ser_2_0_0),
        .inject_xneg_ser(inject_xneg_ser_2_0_0),
        .eject_xneg_ser(eject_xneg_ser_2_0_0),
        .inject_ypos_ser(inject_ypos_ser_2_0_0),
        .eject_ypos_ser(eject_ypos_ser_2_0_0),
        .inject_yneg_ser(inject_yneg_ser_2_0_0),
        .eject_yneg_ser(eject_yneg_ser_2_0_0),
        .inject_zpos_ser(inject_zpos_ser_2_0_0),
        .eject_zpos_ser(eject_zpos_ser_2_0_0),
        .inject_zneg_ser(inject_zneg_ser_2_0_0),
        .eject_zneg_ser(eject_zneg_ser_2_0_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_0_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_0_0),
        .xpos_InjectUtil(xpos_InjectUtil_2_0_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_0_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_0_0),
        .xneg_InjectUtil(xneg_InjectUtil_2_0_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_0_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_0_0),
        .ypos_InjectUtil(ypos_InjectUtil_2_0_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_0_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_0_0),
        .yneg_InjectUtil(yneg_InjectUtil_2_0_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_0_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_0_0),
        .zpos_InjectUtil(zpos_InjectUtil_2_0_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_0_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_0_0),
        .zneg_InjectUtil(zneg_InjectUtil_2_0_0)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(0),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_0_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_0_1),
        .eject_xpos_ser(eject_xpos_ser_2_0_1),
        .inject_xneg_ser(inject_xneg_ser_2_0_1),
        .eject_xneg_ser(eject_xneg_ser_2_0_1),
        .inject_ypos_ser(inject_ypos_ser_2_0_1),
        .eject_ypos_ser(eject_ypos_ser_2_0_1),
        .inject_yneg_ser(inject_yneg_ser_2_0_1),
        .eject_yneg_ser(eject_yneg_ser_2_0_1),
        .inject_zpos_ser(inject_zpos_ser_2_0_1),
        .eject_zpos_ser(eject_zpos_ser_2_0_1),
        .inject_zneg_ser(inject_zneg_ser_2_0_1),
        .eject_zneg_ser(eject_zneg_ser_2_0_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_0_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_0_1),
        .xpos_InjectUtil(xpos_InjectUtil_2_0_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_0_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_0_1),
        .xneg_InjectUtil(xneg_InjectUtil_2_0_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_0_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_0_1),
        .ypos_InjectUtil(ypos_InjectUtil_2_0_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_0_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_0_1),
        .yneg_InjectUtil(yneg_InjectUtil_2_0_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_0_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_0_1),
        .zpos_InjectUtil(zpos_InjectUtil_2_0_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_0_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_0_1),
        .zneg_InjectUtil(zneg_InjectUtil_2_0_1)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(0),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_0_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_0_2),
        .eject_xpos_ser(eject_xpos_ser_2_0_2),
        .inject_xneg_ser(inject_xneg_ser_2_0_2),
        .eject_xneg_ser(eject_xneg_ser_2_0_2),
        .inject_ypos_ser(inject_ypos_ser_2_0_2),
        .eject_ypos_ser(eject_ypos_ser_2_0_2),
        .inject_yneg_ser(inject_yneg_ser_2_0_2),
        .eject_yneg_ser(eject_yneg_ser_2_0_2),
        .inject_zpos_ser(inject_zpos_ser_2_0_2),
        .eject_zpos_ser(eject_zpos_ser_2_0_2),
        .inject_zneg_ser(inject_zneg_ser_2_0_2),
        .eject_zneg_ser(eject_zneg_ser_2_0_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_0_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_0_2),
        .xpos_InjectUtil(xpos_InjectUtil_2_0_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_0_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_0_2),
        .xneg_InjectUtil(xneg_InjectUtil_2_0_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_0_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_0_2),
        .ypos_InjectUtil(ypos_InjectUtil_2_0_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_0_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_0_2),
        .yneg_InjectUtil(yneg_InjectUtil_2_0_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_0_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_0_2),
        .zpos_InjectUtil(zpos_InjectUtil_2_0_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_0_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_0_2),
        .zneg_InjectUtil(zneg_InjectUtil_2_0_2)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(0),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_0_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_0_3),
        .eject_xpos_ser(eject_xpos_ser_2_0_3),
        .inject_xneg_ser(inject_xneg_ser_2_0_3),
        .eject_xneg_ser(eject_xneg_ser_2_0_3),
        .inject_ypos_ser(inject_ypos_ser_2_0_3),
        .eject_ypos_ser(eject_ypos_ser_2_0_3),
        .inject_yneg_ser(inject_yneg_ser_2_0_3),
        .eject_yneg_ser(eject_yneg_ser_2_0_3),
        .inject_zpos_ser(inject_zpos_ser_2_0_3),
        .eject_zpos_ser(eject_zpos_ser_2_0_3),
        .inject_zneg_ser(inject_zneg_ser_2_0_3),
        .eject_zneg_ser(eject_zneg_ser_2_0_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_0_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_0_3),
        .xpos_InjectUtil(xpos_InjectUtil_2_0_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_0_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_0_3),
        .xneg_InjectUtil(xneg_InjectUtil_2_0_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_0_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_0_3),
        .ypos_InjectUtil(ypos_InjectUtil_2_0_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_0_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_0_3),
        .yneg_InjectUtil(yneg_InjectUtil_2_0_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_0_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_0_3),
        .zpos_InjectUtil(zpos_InjectUtil_2_0_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_0_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_0_3),
        .zneg_InjectUtil(zneg_InjectUtil_2_0_3)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(1),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_1_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_1_0),
        .eject_xpos_ser(eject_xpos_ser_2_1_0),
        .inject_xneg_ser(inject_xneg_ser_2_1_0),
        .eject_xneg_ser(eject_xneg_ser_2_1_0),
        .inject_ypos_ser(inject_ypos_ser_2_1_0),
        .eject_ypos_ser(eject_ypos_ser_2_1_0),
        .inject_yneg_ser(inject_yneg_ser_2_1_0),
        .eject_yneg_ser(eject_yneg_ser_2_1_0),
        .inject_zpos_ser(inject_zpos_ser_2_1_0),
        .eject_zpos_ser(eject_zpos_ser_2_1_0),
        .inject_zneg_ser(inject_zneg_ser_2_1_0),
        .eject_zneg_ser(eject_zneg_ser_2_1_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_1_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_1_0),
        .xpos_InjectUtil(xpos_InjectUtil_2_1_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_1_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_1_0),
        .xneg_InjectUtil(xneg_InjectUtil_2_1_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_1_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_1_0),
        .ypos_InjectUtil(ypos_InjectUtil_2_1_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_1_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_1_0),
        .yneg_InjectUtil(yneg_InjectUtil_2_1_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_1_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_1_0),
        .zpos_InjectUtil(zpos_InjectUtil_2_1_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_1_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_1_0),
        .zneg_InjectUtil(zneg_InjectUtil_2_1_0)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(1),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_1_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_1_1),
        .eject_xpos_ser(eject_xpos_ser_2_1_1),
        .inject_xneg_ser(inject_xneg_ser_2_1_1),
        .eject_xneg_ser(eject_xneg_ser_2_1_1),
        .inject_ypos_ser(inject_ypos_ser_2_1_1),
        .eject_ypos_ser(eject_ypos_ser_2_1_1),
        .inject_yneg_ser(inject_yneg_ser_2_1_1),
        .eject_yneg_ser(eject_yneg_ser_2_1_1),
        .inject_zpos_ser(inject_zpos_ser_2_1_1),
        .eject_zpos_ser(eject_zpos_ser_2_1_1),
        .inject_zneg_ser(inject_zneg_ser_2_1_1),
        .eject_zneg_ser(eject_zneg_ser_2_1_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_1_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_1_1),
        .xpos_InjectUtil(xpos_InjectUtil_2_1_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_1_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_1_1),
        .xneg_InjectUtil(xneg_InjectUtil_2_1_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_1_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_1_1),
        .ypos_InjectUtil(ypos_InjectUtil_2_1_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_1_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_1_1),
        .yneg_InjectUtil(yneg_InjectUtil_2_1_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_1_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_1_1),
        .zpos_InjectUtil(zpos_InjectUtil_2_1_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_1_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_1_1),
        .zneg_InjectUtil(zneg_InjectUtil_2_1_1)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(1),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_1_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_1_2),
        .eject_xpos_ser(eject_xpos_ser_2_1_2),
        .inject_xneg_ser(inject_xneg_ser_2_1_2),
        .eject_xneg_ser(eject_xneg_ser_2_1_2),
        .inject_ypos_ser(inject_ypos_ser_2_1_2),
        .eject_ypos_ser(eject_ypos_ser_2_1_2),
        .inject_yneg_ser(inject_yneg_ser_2_1_2),
        .eject_yneg_ser(eject_yneg_ser_2_1_2),
        .inject_zpos_ser(inject_zpos_ser_2_1_2),
        .eject_zpos_ser(eject_zpos_ser_2_1_2),
        .inject_zneg_ser(inject_zneg_ser_2_1_2),
        .eject_zneg_ser(eject_zneg_ser_2_1_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_1_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_1_2),
        .xpos_InjectUtil(xpos_InjectUtil_2_1_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_1_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_1_2),
        .xneg_InjectUtil(xneg_InjectUtil_2_1_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_1_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_1_2),
        .ypos_InjectUtil(ypos_InjectUtil_2_1_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_1_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_1_2),
        .yneg_InjectUtil(yneg_InjectUtil_2_1_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_1_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_1_2),
        .zpos_InjectUtil(zpos_InjectUtil_2_1_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_1_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_1_2),
        .zneg_InjectUtil(zneg_InjectUtil_2_1_2)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(1),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_1_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_1_3),
        .eject_xpos_ser(eject_xpos_ser_2_1_3),
        .inject_xneg_ser(inject_xneg_ser_2_1_3),
        .eject_xneg_ser(eject_xneg_ser_2_1_3),
        .inject_ypos_ser(inject_ypos_ser_2_1_3),
        .eject_ypos_ser(eject_ypos_ser_2_1_3),
        .inject_yneg_ser(inject_yneg_ser_2_1_3),
        .eject_yneg_ser(eject_yneg_ser_2_1_3),
        .inject_zpos_ser(inject_zpos_ser_2_1_3),
        .eject_zpos_ser(eject_zpos_ser_2_1_3),
        .inject_zneg_ser(inject_zneg_ser_2_1_3),
        .eject_zneg_ser(eject_zneg_ser_2_1_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_1_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_1_3),
        .xpos_InjectUtil(xpos_InjectUtil_2_1_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_1_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_1_3),
        .xneg_InjectUtil(xneg_InjectUtil_2_1_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_1_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_1_3),
        .ypos_InjectUtil(ypos_InjectUtil_2_1_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_1_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_1_3),
        .yneg_InjectUtil(yneg_InjectUtil_2_1_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_1_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_1_3),
        .zpos_InjectUtil(zpos_InjectUtil_2_1_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_1_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_1_3),
        .zneg_InjectUtil(zneg_InjectUtil_2_1_3)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(2),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_2_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_2_0),
        .eject_xpos_ser(eject_xpos_ser_2_2_0),
        .inject_xneg_ser(inject_xneg_ser_2_2_0),
        .eject_xneg_ser(eject_xneg_ser_2_2_0),
        .inject_ypos_ser(inject_ypos_ser_2_2_0),
        .eject_ypos_ser(eject_ypos_ser_2_2_0),
        .inject_yneg_ser(inject_yneg_ser_2_2_0),
        .eject_yneg_ser(eject_yneg_ser_2_2_0),
        .inject_zpos_ser(inject_zpos_ser_2_2_0),
        .eject_zpos_ser(eject_zpos_ser_2_2_0),
        .inject_zneg_ser(inject_zneg_ser_2_2_0),
        .eject_zneg_ser(eject_zneg_ser_2_2_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_2_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_2_0),
        .xpos_InjectUtil(xpos_InjectUtil_2_2_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_2_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_2_0),
        .xneg_InjectUtil(xneg_InjectUtil_2_2_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_2_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_2_0),
        .ypos_InjectUtil(ypos_InjectUtil_2_2_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_2_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_2_0),
        .yneg_InjectUtil(yneg_InjectUtil_2_2_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_2_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_2_0),
        .zpos_InjectUtil(zpos_InjectUtil_2_2_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_2_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_2_0),
        .zneg_InjectUtil(zneg_InjectUtil_2_2_0)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(2),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_2_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_2_1),
        .eject_xpos_ser(eject_xpos_ser_2_2_1),
        .inject_xneg_ser(inject_xneg_ser_2_2_1),
        .eject_xneg_ser(eject_xneg_ser_2_2_1),
        .inject_ypos_ser(inject_ypos_ser_2_2_1),
        .eject_ypos_ser(eject_ypos_ser_2_2_1),
        .inject_yneg_ser(inject_yneg_ser_2_2_1),
        .eject_yneg_ser(eject_yneg_ser_2_2_1),
        .inject_zpos_ser(inject_zpos_ser_2_2_1),
        .eject_zpos_ser(eject_zpos_ser_2_2_1),
        .inject_zneg_ser(inject_zneg_ser_2_2_1),
        .eject_zneg_ser(eject_zneg_ser_2_2_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_2_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_2_1),
        .xpos_InjectUtil(xpos_InjectUtil_2_2_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_2_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_2_1),
        .xneg_InjectUtil(xneg_InjectUtil_2_2_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_2_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_2_1),
        .ypos_InjectUtil(ypos_InjectUtil_2_2_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_2_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_2_1),
        .yneg_InjectUtil(yneg_InjectUtil_2_2_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_2_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_2_1),
        .zpos_InjectUtil(zpos_InjectUtil_2_2_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_2_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_2_1),
        .zneg_InjectUtil(zneg_InjectUtil_2_2_1)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(2),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_2_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_2_2),
        .eject_xpos_ser(eject_xpos_ser_2_2_2),
        .inject_xneg_ser(inject_xneg_ser_2_2_2),
        .eject_xneg_ser(eject_xneg_ser_2_2_2),
        .inject_ypos_ser(inject_ypos_ser_2_2_2),
        .eject_ypos_ser(eject_ypos_ser_2_2_2),
        .inject_yneg_ser(inject_yneg_ser_2_2_2),
        .eject_yneg_ser(eject_yneg_ser_2_2_2),
        .inject_zpos_ser(inject_zpos_ser_2_2_2),
        .eject_zpos_ser(eject_zpos_ser_2_2_2),
        .inject_zneg_ser(inject_zneg_ser_2_2_2),
        .eject_zneg_ser(eject_zneg_ser_2_2_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_2_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_2_2),
        .xpos_InjectUtil(xpos_InjectUtil_2_2_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_2_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_2_2),
        .xneg_InjectUtil(xneg_InjectUtil_2_2_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_2_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_2_2),
        .ypos_InjectUtil(ypos_InjectUtil_2_2_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_2_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_2_2),
        .yneg_InjectUtil(yneg_InjectUtil_2_2_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_2_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_2_2),
        .zpos_InjectUtil(zpos_InjectUtil_2_2_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_2_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_2_2),
        .zneg_InjectUtil(zneg_InjectUtil_2_2_2)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(2),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_2_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_2_3),
        .eject_xpos_ser(eject_xpos_ser_2_2_3),
        .inject_xneg_ser(inject_xneg_ser_2_2_3),
        .eject_xneg_ser(eject_xneg_ser_2_2_3),
        .inject_ypos_ser(inject_ypos_ser_2_2_3),
        .eject_ypos_ser(eject_ypos_ser_2_2_3),
        .inject_yneg_ser(inject_yneg_ser_2_2_3),
        .eject_yneg_ser(eject_yneg_ser_2_2_3),
        .inject_zpos_ser(inject_zpos_ser_2_2_3),
        .eject_zpos_ser(eject_zpos_ser_2_2_3),
        .inject_zneg_ser(inject_zneg_ser_2_2_3),
        .eject_zneg_ser(eject_zneg_ser_2_2_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_2_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_2_3),
        .xpos_InjectUtil(xpos_InjectUtil_2_2_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_2_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_2_3),
        .xneg_InjectUtil(xneg_InjectUtil_2_2_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_2_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_2_3),
        .ypos_InjectUtil(ypos_InjectUtil_2_2_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_2_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_2_3),
        .yneg_InjectUtil(yneg_InjectUtil_2_2_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_2_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_2_3),
        .zpos_InjectUtil(zpos_InjectUtil_2_2_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_2_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_2_3),
        .zneg_InjectUtil(zneg_InjectUtil_2_2_3)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(3),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_3_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_3_0),
        .eject_xpos_ser(eject_xpos_ser_2_3_0),
        .inject_xneg_ser(inject_xneg_ser_2_3_0),
        .eject_xneg_ser(eject_xneg_ser_2_3_0),
        .inject_ypos_ser(inject_ypos_ser_2_3_0),
        .eject_ypos_ser(eject_ypos_ser_2_3_0),
        .inject_yneg_ser(inject_yneg_ser_2_3_0),
        .eject_yneg_ser(eject_yneg_ser_2_3_0),
        .inject_zpos_ser(inject_zpos_ser_2_3_0),
        .eject_zpos_ser(eject_zpos_ser_2_3_0),
        .inject_zneg_ser(inject_zneg_ser_2_3_0),
        .eject_zneg_ser(eject_zneg_ser_2_3_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_3_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_3_0),
        .xpos_InjectUtil(xpos_InjectUtil_2_3_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_3_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_3_0),
        .xneg_InjectUtil(xneg_InjectUtil_2_3_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_3_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_3_0),
        .ypos_InjectUtil(ypos_InjectUtil_2_3_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_3_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_3_0),
        .yneg_InjectUtil(yneg_InjectUtil_2_3_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_3_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_3_0),
        .zpos_InjectUtil(zpos_InjectUtil_2_3_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_3_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_3_0),
        .zneg_InjectUtil(zneg_InjectUtil_2_3_0)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(3),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_3_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_3_1),
        .eject_xpos_ser(eject_xpos_ser_2_3_1),
        .inject_xneg_ser(inject_xneg_ser_2_3_1),
        .eject_xneg_ser(eject_xneg_ser_2_3_1),
        .inject_ypos_ser(inject_ypos_ser_2_3_1),
        .eject_ypos_ser(eject_ypos_ser_2_3_1),
        .inject_yneg_ser(inject_yneg_ser_2_3_1),
        .eject_yneg_ser(eject_yneg_ser_2_3_1),
        .inject_zpos_ser(inject_zpos_ser_2_3_1),
        .eject_zpos_ser(eject_zpos_ser_2_3_1),
        .inject_zneg_ser(inject_zneg_ser_2_3_1),
        .eject_zneg_ser(eject_zneg_ser_2_3_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_3_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_3_1),
        .xpos_InjectUtil(xpos_InjectUtil_2_3_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_3_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_3_1),
        .xneg_InjectUtil(xneg_InjectUtil_2_3_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_3_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_3_1),
        .ypos_InjectUtil(ypos_InjectUtil_2_3_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_3_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_3_1),
        .yneg_InjectUtil(yneg_InjectUtil_2_3_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_3_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_3_1),
        .zpos_InjectUtil(zpos_InjectUtil_2_3_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_3_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_3_1),
        .zneg_InjectUtil(zneg_InjectUtil_2_3_1)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(3),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_3_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_3_2),
        .eject_xpos_ser(eject_xpos_ser_2_3_2),
        .inject_xneg_ser(inject_xneg_ser_2_3_2),
        .eject_xneg_ser(eject_xneg_ser_2_3_2),
        .inject_ypos_ser(inject_ypos_ser_2_3_2),
        .eject_ypos_ser(eject_ypos_ser_2_3_2),
        .inject_yneg_ser(inject_yneg_ser_2_3_2),
        .eject_yneg_ser(eject_yneg_ser_2_3_2),
        .inject_zpos_ser(inject_zpos_ser_2_3_2),
        .eject_zpos_ser(eject_zpos_ser_2_3_2),
        .inject_zneg_ser(inject_zneg_ser_2_3_2),
        .eject_zneg_ser(eject_zneg_ser_2_3_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_3_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_3_2),
        .xpos_InjectUtil(xpos_InjectUtil_2_3_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_3_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_3_2),
        .xneg_InjectUtil(xneg_InjectUtil_2_3_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_3_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_3_2),
        .ypos_InjectUtil(ypos_InjectUtil_2_3_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_3_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_3_2),
        .yneg_InjectUtil(yneg_InjectUtil_2_3_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_3_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_3_2),
        .zpos_InjectUtil(zpos_InjectUtil_2_3_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_3_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_3_2),
        .zneg_InjectUtil(zneg_InjectUtil_2_3_2)
);
    node#(
        .DataSize(DataSize),
        .X(2),
        .Y(3),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_2_3_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_2_3_3),
        .eject_xpos_ser(eject_xpos_ser_2_3_3),
        .inject_xneg_ser(inject_xneg_ser_2_3_3),
        .eject_xneg_ser(eject_xneg_ser_2_3_3),
        .inject_ypos_ser(inject_ypos_ser_2_3_3),
        .eject_ypos_ser(eject_ypos_ser_2_3_3),
        .inject_yneg_ser(inject_yneg_ser_2_3_3),
        .eject_yneg_ser(eject_yneg_ser_2_3_3),
        .inject_zpos_ser(inject_zpos_ser_2_3_3),
        .eject_zpos_ser(eject_zpos_ser_2_3_3),
        .inject_zneg_ser(inject_zneg_ser_2_3_3),
        .eject_zneg_ser(eject_zneg_ser_2_3_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_2_3_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_2_3_3),
        .xpos_InjectUtil(xpos_InjectUtil_2_3_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_2_3_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_2_3_3),
        .xneg_InjectUtil(xneg_InjectUtil_2_3_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_2_3_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_2_3_3),
        .ypos_InjectUtil(ypos_InjectUtil_2_3_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_2_3_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_2_3_3),
        .yneg_InjectUtil(yneg_InjectUtil_2_3_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_2_3_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_2_3_3),
        .zpos_InjectUtil(zpos_InjectUtil_2_3_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_2_3_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_2_3_3),
        .zneg_InjectUtil(zneg_InjectUtil_2_3_3)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(0),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_0_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_0_0),
        .eject_xpos_ser(eject_xpos_ser_3_0_0),
        .inject_xneg_ser(inject_xneg_ser_3_0_0),
        .eject_xneg_ser(eject_xneg_ser_3_0_0),
        .inject_ypos_ser(inject_ypos_ser_3_0_0),
        .eject_ypos_ser(eject_ypos_ser_3_0_0),
        .inject_yneg_ser(inject_yneg_ser_3_0_0),
        .eject_yneg_ser(eject_yneg_ser_3_0_0),
        .inject_zpos_ser(inject_zpos_ser_3_0_0),
        .eject_zpos_ser(eject_zpos_ser_3_0_0),
        .inject_zneg_ser(inject_zneg_ser_3_0_0),
        .eject_zneg_ser(eject_zneg_ser_3_0_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_0_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_0_0),
        .xpos_InjectUtil(xpos_InjectUtil_3_0_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_0_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_0_0),
        .xneg_InjectUtil(xneg_InjectUtil_3_0_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_0_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_0_0),
        .ypos_InjectUtil(ypos_InjectUtil_3_0_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_0_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_0_0),
        .yneg_InjectUtil(yneg_InjectUtil_3_0_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_0_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_0_0),
        .zpos_InjectUtil(zpos_InjectUtil_3_0_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_0_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_0_0),
        .zneg_InjectUtil(zneg_InjectUtil_3_0_0)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(0),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_0_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_0_1),
        .eject_xpos_ser(eject_xpos_ser_3_0_1),
        .inject_xneg_ser(inject_xneg_ser_3_0_1),
        .eject_xneg_ser(eject_xneg_ser_3_0_1),
        .inject_ypos_ser(inject_ypos_ser_3_0_1),
        .eject_ypos_ser(eject_ypos_ser_3_0_1),
        .inject_yneg_ser(inject_yneg_ser_3_0_1),
        .eject_yneg_ser(eject_yneg_ser_3_0_1),
        .inject_zpos_ser(inject_zpos_ser_3_0_1),
        .eject_zpos_ser(eject_zpos_ser_3_0_1),
        .inject_zneg_ser(inject_zneg_ser_3_0_1),
        .eject_zneg_ser(eject_zneg_ser_3_0_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_0_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_0_1),
        .xpos_InjectUtil(xpos_InjectUtil_3_0_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_0_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_0_1),
        .xneg_InjectUtil(xneg_InjectUtil_3_0_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_0_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_0_1),
        .ypos_InjectUtil(ypos_InjectUtil_3_0_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_0_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_0_1),
        .yneg_InjectUtil(yneg_InjectUtil_3_0_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_0_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_0_1),
        .zpos_InjectUtil(zpos_InjectUtil_3_0_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_0_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_0_1),
        .zneg_InjectUtil(zneg_InjectUtil_3_0_1)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(0),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_0_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_0_2),
        .eject_xpos_ser(eject_xpos_ser_3_0_2),
        .inject_xneg_ser(inject_xneg_ser_3_0_2),
        .eject_xneg_ser(eject_xneg_ser_3_0_2),
        .inject_ypos_ser(inject_ypos_ser_3_0_2),
        .eject_ypos_ser(eject_ypos_ser_3_0_2),
        .inject_yneg_ser(inject_yneg_ser_3_0_2),
        .eject_yneg_ser(eject_yneg_ser_3_0_2),
        .inject_zpos_ser(inject_zpos_ser_3_0_2),
        .eject_zpos_ser(eject_zpos_ser_3_0_2),
        .inject_zneg_ser(inject_zneg_ser_3_0_2),
        .eject_zneg_ser(eject_zneg_ser_3_0_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_0_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_0_2),
        .xpos_InjectUtil(xpos_InjectUtil_3_0_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_0_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_0_2),
        .xneg_InjectUtil(xneg_InjectUtil_3_0_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_0_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_0_2),
        .ypos_InjectUtil(ypos_InjectUtil_3_0_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_0_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_0_2),
        .yneg_InjectUtil(yneg_InjectUtil_3_0_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_0_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_0_2),
        .zpos_InjectUtil(zpos_InjectUtil_3_0_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_0_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_0_2),
        .zneg_InjectUtil(zneg_InjectUtil_3_0_2)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(0),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_0_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_0_3),
        .eject_xpos_ser(eject_xpos_ser_3_0_3),
        .inject_xneg_ser(inject_xneg_ser_3_0_3),
        .eject_xneg_ser(eject_xneg_ser_3_0_3),
        .inject_ypos_ser(inject_ypos_ser_3_0_3),
        .eject_ypos_ser(eject_ypos_ser_3_0_3),
        .inject_yneg_ser(inject_yneg_ser_3_0_3),
        .eject_yneg_ser(eject_yneg_ser_3_0_3),
        .inject_zpos_ser(inject_zpos_ser_3_0_3),
        .eject_zpos_ser(eject_zpos_ser_3_0_3),
        .inject_zneg_ser(inject_zneg_ser_3_0_3),
        .eject_zneg_ser(eject_zneg_ser_3_0_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_0_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_0_3),
        .xpos_InjectUtil(xpos_InjectUtil_3_0_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_0_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_0_3),
        .xneg_InjectUtil(xneg_InjectUtil_3_0_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_0_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_0_3),
        .ypos_InjectUtil(ypos_InjectUtil_3_0_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_0_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_0_3),
        .yneg_InjectUtil(yneg_InjectUtil_3_0_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_0_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_0_3),
        .zpos_InjectUtil(zpos_InjectUtil_3_0_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_0_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_0_3),
        .zneg_InjectUtil(zneg_InjectUtil_3_0_3)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(1),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_1_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_1_0),
        .eject_xpos_ser(eject_xpos_ser_3_1_0),
        .inject_xneg_ser(inject_xneg_ser_3_1_0),
        .eject_xneg_ser(eject_xneg_ser_3_1_0),
        .inject_ypos_ser(inject_ypos_ser_3_1_0),
        .eject_ypos_ser(eject_ypos_ser_3_1_0),
        .inject_yneg_ser(inject_yneg_ser_3_1_0),
        .eject_yneg_ser(eject_yneg_ser_3_1_0),
        .inject_zpos_ser(inject_zpos_ser_3_1_0),
        .eject_zpos_ser(eject_zpos_ser_3_1_0),
        .inject_zneg_ser(inject_zneg_ser_3_1_0),
        .eject_zneg_ser(eject_zneg_ser_3_1_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_1_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_1_0),
        .xpos_InjectUtil(xpos_InjectUtil_3_1_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_1_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_1_0),
        .xneg_InjectUtil(xneg_InjectUtil_3_1_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_1_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_1_0),
        .ypos_InjectUtil(ypos_InjectUtil_3_1_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_1_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_1_0),
        .yneg_InjectUtil(yneg_InjectUtil_3_1_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_1_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_1_0),
        .zpos_InjectUtil(zpos_InjectUtil_3_1_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_1_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_1_0),
        .zneg_InjectUtil(zneg_InjectUtil_3_1_0)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(1),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_1_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_1_1),
        .eject_xpos_ser(eject_xpos_ser_3_1_1),
        .inject_xneg_ser(inject_xneg_ser_3_1_1),
        .eject_xneg_ser(eject_xneg_ser_3_1_1),
        .inject_ypos_ser(inject_ypos_ser_3_1_1),
        .eject_ypos_ser(eject_ypos_ser_3_1_1),
        .inject_yneg_ser(inject_yneg_ser_3_1_1),
        .eject_yneg_ser(eject_yneg_ser_3_1_1),
        .inject_zpos_ser(inject_zpos_ser_3_1_1),
        .eject_zpos_ser(eject_zpos_ser_3_1_1),
        .inject_zneg_ser(inject_zneg_ser_3_1_1),
        .eject_zneg_ser(eject_zneg_ser_3_1_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_1_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_1_1),
        .xpos_InjectUtil(xpos_InjectUtil_3_1_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_1_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_1_1),
        .xneg_InjectUtil(xneg_InjectUtil_3_1_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_1_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_1_1),
        .ypos_InjectUtil(ypos_InjectUtil_3_1_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_1_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_1_1),
        .yneg_InjectUtil(yneg_InjectUtil_3_1_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_1_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_1_1),
        .zpos_InjectUtil(zpos_InjectUtil_3_1_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_1_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_1_1),
        .zneg_InjectUtil(zneg_InjectUtil_3_1_1)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(1),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_1_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_1_2),
        .eject_xpos_ser(eject_xpos_ser_3_1_2),
        .inject_xneg_ser(inject_xneg_ser_3_1_2),
        .eject_xneg_ser(eject_xneg_ser_3_1_2),
        .inject_ypos_ser(inject_ypos_ser_3_1_2),
        .eject_ypos_ser(eject_ypos_ser_3_1_2),
        .inject_yneg_ser(inject_yneg_ser_3_1_2),
        .eject_yneg_ser(eject_yneg_ser_3_1_2),
        .inject_zpos_ser(inject_zpos_ser_3_1_2),
        .eject_zpos_ser(eject_zpos_ser_3_1_2),
        .inject_zneg_ser(inject_zneg_ser_3_1_2),
        .eject_zneg_ser(eject_zneg_ser_3_1_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_1_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_1_2),
        .xpos_InjectUtil(xpos_InjectUtil_3_1_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_1_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_1_2),
        .xneg_InjectUtil(xneg_InjectUtil_3_1_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_1_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_1_2),
        .ypos_InjectUtil(ypos_InjectUtil_3_1_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_1_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_1_2),
        .yneg_InjectUtil(yneg_InjectUtil_3_1_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_1_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_1_2),
        .zpos_InjectUtil(zpos_InjectUtil_3_1_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_1_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_1_2),
        .zneg_InjectUtil(zneg_InjectUtil_3_1_2)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(1),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_1_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_1_3),
        .eject_xpos_ser(eject_xpos_ser_3_1_3),
        .inject_xneg_ser(inject_xneg_ser_3_1_3),
        .eject_xneg_ser(eject_xneg_ser_3_1_3),
        .inject_ypos_ser(inject_ypos_ser_3_1_3),
        .eject_ypos_ser(eject_ypos_ser_3_1_3),
        .inject_yneg_ser(inject_yneg_ser_3_1_3),
        .eject_yneg_ser(eject_yneg_ser_3_1_3),
        .inject_zpos_ser(inject_zpos_ser_3_1_3),
        .eject_zpos_ser(eject_zpos_ser_3_1_3),
        .inject_zneg_ser(inject_zneg_ser_3_1_3),
        .eject_zneg_ser(eject_zneg_ser_3_1_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_1_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_1_3),
        .xpos_InjectUtil(xpos_InjectUtil_3_1_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_1_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_1_3),
        .xneg_InjectUtil(xneg_InjectUtil_3_1_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_1_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_1_3),
        .ypos_InjectUtil(ypos_InjectUtil_3_1_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_1_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_1_3),
        .yneg_InjectUtil(yneg_InjectUtil_3_1_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_1_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_1_3),
        .zpos_InjectUtil(zpos_InjectUtil_3_1_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_1_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_1_3),
        .zneg_InjectUtil(zneg_InjectUtil_3_1_3)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(2),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_2_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_2_0),
        .eject_xpos_ser(eject_xpos_ser_3_2_0),
        .inject_xneg_ser(inject_xneg_ser_3_2_0),
        .eject_xneg_ser(eject_xneg_ser_3_2_0),
        .inject_ypos_ser(inject_ypos_ser_3_2_0),
        .eject_ypos_ser(eject_ypos_ser_3_2_0),
        .inject_yneg_ser(inject_yneg_ser_3_2_0),
        .eject_yneg_ser(eject_yneg_ser_3_2_0),
        .inject_zpos_ser(inject_zpos_ser_3_2_0),
        .eject_zpos_ser(eject_zpos_ser_3_2_0),
        .inject_zneg_ser(inject_zneg_ser_3_2_0),
        .eject_zneg_ser(eject_zneg_ser_3_2_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_2_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_2_0),
        .xpos_InjectUtil(xpos_InjectUtil_3_2_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_2_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_2_0),
        .xneg_InjectUtil(xneg_InjectUtil_3_2_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_2_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_2_0),
        .ypos_InjectUtil(ypos_InjectUtil_3_2_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_2_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_2_0),
        .yneg_InjectUtil(yneg_InjectUtil_3_2_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_2_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_2_0),
        .zpos_InjectUtil(zpos_InjectUtil_3_2_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_2_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_2_0),
        .zneg_InjectUtil(zneg_InjectUtil_3_2_0)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(2),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_2_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_2_1),
        .eject_xpos_ser(eject_xpos_ser_3_2_1),
        .inject_xneg_ser(inject_xneg_ser_3_2_1),
        .eject_xneg_ser(eject_xneg_ser_3_2_1),
        .inject_ypos_ser(inject_ypos_ser_3_2_1),
        .eject_ypos_ser(eject_ypos_ser_3_2_1),
        .inject_yneg_ser(inject_yneg_ser_3_2_1),
        .eject_yneg_ser(eject_yneg_ser_3_2_1),
        .inject_zpos_ser(inject_zpos_ser_3_2_1),
        .eject_zpos_ser(eject_zpos_ser_3_2_1),
        .inject_zneg_ser(inject_zneg_ser_3_2_1),
        .eject_zneg_ser(eject_zneg_ser_3_2_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_2_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_2_1),
        .xpos_InjectUtil(xpos_InjectUtil_3_2_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_2_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_2_1),
        .xneg_InjectUtil(xneg_InjectUtil_3_2_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_2_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_2_1),
        .ypos_InjectUtil(ypos_InjectUtil_3_2_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_2_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_2_1),
        .yneg_InjectUtil(yneg_InjectUtil_3_2_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_2_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_2_1),
        .zpos_InjectUtil(zpos_InjectUtil_3_2_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_2_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_2_1),
        .zneg_InjectUtil(zneg_InjectUtil_3_2_1)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(2),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_2_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_2_2),
        .eject_xpos_ser(eject_xpos_ser_3_2_2),
        .inject_xneg_ser(inject_xneg_ser_3_2_2),
        .eject_xneg_ser(eject_xneg_ser_3_2_2),
        .inject_ypos_ser(inject_ypos_ser_3_2_2),
        .eject_ypos_ser(eject_ypos_ser_3_2_2),
        .inject_yneg_ser(inject_yneg_ser_3_2_2),
        .eject_yneg_ser(eject_yneg_ser_3_2_2),
        .inject_zpos_ser(inject_zpos_ser_3_2_2),
        .eject_zpos_ser(eject_zpos_ser_3_2_2),
        .inject_zneg_ser(inject_zneg_ser_3_2_2),
        .eject_zneg_ser(eject_zneg_ser_3_2_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_2_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_2_2),
        .xpos_InjectUtil(xpos_InjectUtil_3_2_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_2_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_2_2),
        .xneg_InjectUtil(xneg_InjectUtil_3_2_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_2_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_2_2),
        .ypos_InjectUtil(ypos_InjectUtil_3_2_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_2_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_2_2),
        .yneg_InjectUtil(yneg_InjectUtil_3_2_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_2_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_2_2),
        .zpos_InjectUtil(zpos_InjectUtil_3_2_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_2_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_2_2),
        .zneg_InjectUtil(zneg_InjectUtil_3_2_2)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(2),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_2_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_2_3),
        .eject_xpos_ser(eject_xpos_ser_3_2_3),
        .inject_xneg_ser(inject_xneg_ser_3_2_3),
        .eject_xneg_ser(eject_xneg_ser_3_2_3),
        .inject_ypos_ser(inject_ypos_ser_3_2_3),
        .eject_ypos_ser(eject_ypos_ser_3_2_3),
        .inject_yneg_ser(inject_yneg_ser_3_2_3),
        .eject_yneg_ser(eject_yneg_ser_3_2_3),
        .inject_zpos_ser(inject_zpos_ser_3_2_3),
        .eject_zpos_ser(eject_zpos_ser_3_2_3),
        .inject_zneg_ser(inject_zneg_ser_3_2_3),
        .eject_zneg_ser(eject_zneg_ser_3_2_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_2_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_2_3),
        .xpos_InjectUtil(xpos_InjectUtil_3_2_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_2_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_2_3),
        .xneg_InjectUtil(xneg_InjectUtil_3_2_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_2_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_2_3),
        .ypos_InjectUtil(ypos_InjectUtil_3_2_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_2_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_2_3),
        .yneg_InjectUtil(yneg_InjectUtil_3_2_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_2_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_2_3),
        .zpos_InjectUtil(zpos_InjectUtil_3_2_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_2_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_2_3),
        .zneg_InjectUtil(zneg_InjectUtil_3_2_3)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(3),
        .Z(0),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_3_0(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_3_0),
        .eject_xpos_ser(eject_xpos_ser_3_3_0),
        .inject_xneg_ser(inject_xneg_ser_3_3_0),
        .eject_xneg_ser(eject_xneg_ser_3_3_0),
        .inject_ypos_ser(inject_ypos_ser_3_3_0),
        .eject_ypos_ser(eject_ypos_ser_3_3_0),
        .inject_yneg_ser(inject_yneg_ser_3_3_0),
        .eject_yneg_ser(eject_yneg_ser_3_3_0),
        .inject_zpos_ser(inject_zpos_ser_3_3_0),
        .eject_zpos_ser(eject_zpos_ser_3_3_0),
        .inject_zneg_ser(inject_zneg_ser_3_3_0),
        .eject_zneg_ser(eject_zneg_ser_3_3_0),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_3_0),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_3_0),
        .xpos_InjectUtil(xpos_InjectUtil_3_3_0),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_3_0),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_3_0),
        .xneg_InjectUtil(xneg_InjectUtil_3_3_0),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_3_0),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_3_0),
        .ypos_InjectUtil(ypos_InjectUtil_3_3_0),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_3_0),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_3_0),
        .yneg_InjectUtil(yneg_InjectUtil_3_3_0),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_3_0),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_3_0),
        .zpos_InjectUtil(zpos_InjectUtil_3_3_0),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_3_0),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_3_0),
        .zneg_InjectUtil(zneg_InjectUtil_3_3_0)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(3),
        .Z(1),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_3_1(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_3_1),
        .eject_xpos_ser(eject_xpos_ser_3_3_1),
        .inject_xneg_ser(inject_xneg_ser_3_3_1),
        .eject_xneg_ser(eject_xneg_ser_3_3_1),
        .inject_ypos_ser(inject_ypos_ser_3_3_1),
        .eject_ypos_ser(eject_ypos_ser_3_3_1),
        .inject_yneg_ser(inject_yneg_ser_3_3_1),
        .eject_yneg_ser(eject_yneg_ser_3_3_1),
        .inject_zpos_ser(inject_zpos_ser_3_3_1),
        .eject_zpos_ser(eject_zpos_ser_3_3_1),
        .inject_zneg_ser(inject_zneg_ser_3_3_1),
        .eject_zneg_ser(eject_zneg_ser_3_3_1),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_3_1),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_3_1),
        .xpos_InjectUtil(xpos_InjectUtil_3_3_1),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_3_1),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_3_1),
        .xneg_InjectUtil(xneg_InjectUtil_3_3_1),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_3_1),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_3_1),
        .ypos_InjectUtil(ypos_InjectUtil_3_3_1),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_3_1),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_3_1),
        .yneg_InjectUtil(yneg_InjectUtil_3_3_1),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_3_1),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_3_1),
        .zpos_InjectUtil(zpos_InjectUtil_3_3_1),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_3_1),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_3_1),
        .zneg_InjectUtil(zneg_InjectUtil_3_3_1)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(3),
        .Z(2),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_3_2(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_3_2),
        .eject_xpos_ser(eject_xpos_ser_3_3_2),
        .inject_xneg_ser(inject_xneg_ser_3_3_2),
        .eject_xneg_ser(eject_xneg_ser_3_3_2),
        .inject_ypos_ser(inject_ypos_ser_3_3_2),
        .eject_ypos_ser(eject_ypos_ser_3_3_2),
        .inject_yneg_ser(inject_yneg_ser_3_3_2),
        .eject_yneg_ser(eject_yneg_ser_3_3_2),
        .inject_zpos_ser(inject_zpos_ser_3_3_2),
        .eject_zpos_ser(eject_zpos_ser_3_3_2),
        .inject_zneg_ser(inject_zneg_ser_3_3_2),
        .eject_zneg_ser(eject_zneg_ser_3_3_2),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_3_2),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_3_2),
        .xpos_InjectUtil(xpos_InjectUtil_3_3_2),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_3_2),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_3_2),
        .xneg_InjectUtil(xneg_InjectUtil_3_3_2),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_3_2),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_3_2),
        .ypos_InjectUtil(ypos_InjectUtil_3_3_2),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_3_2),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_3_2),
        .yneg_InjectUtil(yneg_InjectUtil_3_3_2),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_3_2),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_3_2),
        .zpos_InjectUtil(zpos_InjectUtil_3_3_2),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_3_2),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_3_2),
        .zneg_InjectUtil(zneg_InjectUtil_3_3_2)
);
    node#(
        .DataSize(DataSize),
        .X(3),
        .Y(3),
        .Z(3),
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
        .PcktTypeLen(PcktTypeLen),
        .LinkDelay(LinkDelay)
        )n_3_3_3(
        .clk(clk),
        .rst(rst),
        .inject_xpos_ser(inject_xpos_ser_3_3_3),
        .eject_xpos_ser(eject_xpos_ser_3_3_3),
        .inject_xneg_ser(inject_xneg_ser_3_3_3),
        .eject_xneg_ser(eject_xneg_ser_3_3_3),
        .inject_ypos_ser(inject_ypos_ser_3_3_3),
        .eject_ypos_ser(eject_ypos_ser_3_3_3),
        .inject_yneg_ser(inject_yneg_ser_3_3_3),
        .eject_yneg_ser(eject_yneg_ser_3_3_3),
        .inject_zpos_ser(inject_zpos_ser_3_3_3),
        .eject_zpos_ser(eject_zpos_ser_3_3_3),
        .inject_zneg_ser(inject_zneg_ser_3_3_3),
        .eject_zneg_ser(eject_zneg_ser_3_3_3),
        .xpos_ClockwiseUtil(xpos_ClockwiseUtil_3_3_3),
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil_3_3_3),
        .xpos_InjectUtil(xpos_InjectUtil_3_3_3),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil_3_3_3),
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil_3_3_3),
        .xneg_InjectUtil(xneg_InjectUtil_3_3_3),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil_3_3_3),
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil_3_3_3),
        .ypos_InjectUtil(ypos_InjectUtil_3_3_3),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil_3_3_3),
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil_3_3_3),
        .yneg_InjectUtil(yneg_InjectUtil_3_3_3),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil_3_3_3),
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil_3_3_3),
        .zpos_InjectUtil(zpos_InjectUtil_3_3_3),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil_3_3_3),
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil_3_3_3),
        .zneg_InjectUtil(zneg_InjectUtil_3_3_3)
);
endmodule
