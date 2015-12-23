//Purpose: architecture of a node including the switch and MGT and link and the local_unit
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 22th 2015

module node
#(
    parameter X=4'd0,
    parameter Y=4'd0,
    parameter Z=4'd0,
    parameter CoordWidth=4,
    parameter XCoordPos=243,
    parameter YCoordPos=247,
    parameter ZCoordPos=251,
    parameter PacketIDPos=227,
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
    parameter LinkDelay=20
)(
	input clk,
    input rst,
	input [DataWidth-1:0] inject_xpos_ser,	
    output [DataWidth-1:0] eject_xpos_ser,
    
    input [DataWidth-1:0] inject_xneg_ser,	
    output [DataWidth-1:0] eject_xneg_ser,
	
    input [DataWidth-1:0] inject_ypos_ser,	
    output [DataWidth-1:0] eject_ypos_ser,
    
    input [DataWidth-1:0] inject_yneg_ser,	
    output [DataWidth-1:0] eject_yneg_ser,
 
    input [DataWidth-1:0] inject_zpos_ser,	
    output [DataWidth-1:0] eject_zpos_ser,
    
    input [DataWidth-1:0] inject_zneg_ser,	
    output [DataWidth-1:0] eject_zneg_ser,

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

    wire rx_ready_xpos;
    wire rx_ready_xneg;
    wire rx_ready_ypos;
    wire rx_ready_yneg;
    wire rx_ready_zpos;
    wire rx_ready_zneg;
    
//local unit
    local_unit#(
        .X(X),
        .Y(Y),
        .Z(Z),
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
        .ReductionTableWidth(ReductionTableWIdth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
    )
    local_unit_inst(
        .clk(clk),
        .rst(rst),
        .eject_local(eject_local),
        .eject_send_local(eject_send_local),
        .InjectSlotAvail_local(InjectSlotAvail_local),
        .inject_local(inject_local),
        .inject_receive_local(inject_receive_local),
        .EjectSlotAvail_local(EjectSlotAvail_local)
    );
    
    switch#(
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
        .ReductionTableWidth(ReductionTableWIdth),
        .ReductionTablesize(ReductionTablesize),
        .PcktTypeLen(PcktTypeLen)
        
    )
    switch_inst(
//input
        .clk(clk),
        .rst(rst),
	    .inject_xpos(inject_xpos),	
        .inject_receive_xpos(inject_receive_xpos), 
        .EjectSlotAvail_xpos(EjectSlotAvail_xpos),
	    .inject_xneg(inject_xneg),	
        .inject_receive_xneg(inject_receive_xneg), 
        .EjectSlotAvail_xneg(EjectSlotAvail_xneg),
	    .inject_ypos(inject_ypos),	
        .inject_receive_ypos(inject_receive_ypos), 
        .EjectSlotAvail_ypos(EjectSlotAvail_ypos),
	    .inject_yneg(inject_yneg),	
        .inject_receive_yneg(inject_receive_yneg), 
        .EjectSlotAvail_yneg(EjectSlotAvail_yneg),
	    .inject_zpos(inject_zpos),	
        .inject_receive_zpos(inject_receive_zpos), 
        .EjectSlotAvail_zpos(EjectSlotAvail_zpos),
	    .inject_zneg(inject_zneg),	
        .inject_receive_zneg(inject_receive_zneg), 
        .EjectSlotAvail_zneg(EjectSlotAvail_zneg),
        .inject_local(inject_local),
        .inject_receive_local(inject_receive_local),
        .EjectSlotAvail_local(EjectSlotAvail_local),
//output
	    .eject_xpos(eject_xpos), 
        .eject_send_xpos(eject_send_xpos), 
        .InjectSlotAvail_xpos(InjectSlotAvail_xpos),
	    .eject_xneg(eject_xneg), 
        .eject_send_xneg(eject_send_xneg), 
        .InjectSlotAvail_xneg(InjectSlotAvail_xneg),
	    .eject_ypos(eject_ypos), 
        .eject_send_ypos(eject_send_ypos), 
        .InjectSlotAvail_ypos(InjectSlotAvail_ypos),
	    .eject_yneg(eject_yneg), 
        .eject_send_yneg(eject_send_yneg), 
        .InjectSlotAvail_yneg(InjectSlotAvail_yneg),
	    .eject_zpos(eject_zpos), 
        .eject_send_zpos(eject_send_zpos), 
        .InjectSlotAvail_zpos(InjectSlotAvail_zpos),
	    .eject_zneg(eject_zneg), 
        .eject_send_zneg(eject_send_zneg), 
        .InjectSlotAvail_zneg(InjectSlotAvail_zneg),
        .eject_local(eject_local),
        .eject_send_local(eject_send_local),
        .InjectSlotAvail_local(InjectSlotAvail_local),

        .xpos_ClockwiseUtil(xpos_ClockwiseUtil), 
        .xpos_CounterClockwiseUtil(xpos_CounterClockwiseUtil), 
        .xpos_InjectUtil(xpos_InjectUtil),
        .xneg_ClockwiseUtil(xneg_ClockwiseUtil), 
        .xneg_CounterClockwiseUtil(xneg_CounterClockwiseUtil), 
        .xneg_InjectUtil(xneg_InjectUtil),
        .ypos_ClockwiseUtil(ypos_ClockwiseUtil), 
        .ypos_CounterClockwiseUtil(ypos_CounterClockwiseUtil), 
        .ypos_InjectUtil(ypos_InjectUtil),
        .yneg_ClockwiseUtil(yneg_ClockwiseUtil), 
        .yneg_CounterClockwiseUtil(yneg_CounterClockwiseUtil), 
        .yneg_InjectUtil(yneg_InjectUtil),
        .zpos_ClockwiseUtil(zpos_ClockwiseUtil), 
        .zpos_CounterClockwiseUtil(zpos_CounterClockwiseUtil), 
        .zpos_InjectUtil(zpos_InjectUtil),
        .zneg_ClockwiseUtil(zneg_ClockwiseUtil), 
        .zneg_CounterClockwiseUtil(zneg_CounterClockwiseUtil), 
        .zneg_InjectUtil(zneg_InjectUtil)
    );
        
//xpos link
    internode_link#(
        .WIDTH(DataWIDTH),
        .DELAY(LinkDelay),
        .x(x),
        .y(y),
        .z(z),
        .dir(3'b000)
    )
    xpos_link_inst(
        .rst(rst),
        .tx_clk(clk),
        .tx_par_data({eject_send_xpos,eject_xpos[DataWidth-2:0]}),
        .tx_ser_data(eject_xpos_ser),
        .tx_ready(EjectSlotAvail_xpos),
        .rx_clk(clk),
        .rx_par_data(inject_xpos),
        .rx_ser_data(inject_xpos_ser),
        .rx_ready(rx_ready_xpos)
    );
    assign inject_receive_xpos=eject_xpos[DataWidth-1] && rx_ready_xpos;

//xneg link
    internode_link#(
        .WIDTH(DataWIDTH),
        .DELAY(LinkDelay),
        .x(x),
        .y(y),
        .z(z),
        .dir(3'b001)
    )
    xpos_link_inst(
        .rst(rst),
        .tx_clk(clk),
        .tx_par_data({eject_send_xneg,eject_xneg[DataWidth-2:0]}),
        .tx_ser_data(eject_xneg_ser),
        .tx_ready(EjectSlotAvail_xneg),
        .rx_clk(clk),
        .rx_par_data(inject_xneg),
        .rx_ser_data(inject_xneg_ser),
        .rx_ready(rx_ready_xneg)
    );
    assign inject_receive_xneg=eject_xpos[DataWidth-1] && rx_ready_xpos;



    

endmodule