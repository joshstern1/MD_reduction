//Purpose: architecture of a node including the switch and MGT and link and the local_unit
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 22th 2015

module node
#(
    parameter DataSize=8'd172,
    parameter X=8'd0,
    parameter Y=8'd0,
    parameter Z=8'd0,
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
    wire [DataWidth-1:0] inject_xpos,eject_xpos;
    wire inject_receive_xpos,eject_send_xpos;
    wire InjectSlotAvail_xpos,EjectSlotAvail_xpos;
    wire [DataWidth-1:0] inject_xneg,eject_xneg;
    wire inject_receive_xneg,eject_send_xneg;
    wire InjectSlotAvail_xneg,EjectSlotAvail_xneg;    
    wire [DataWidth-1:0] inject_ypos,eject_ypos;
    wire inject_receive_ypos,eject_send_ypos;
    wire InjectSlotAvail_ypos,EjectSlotAvail_ypos;
    wire [DataWidth-1:0] inject_yneg,eject_yneg;
    wire inject_receive_yneg,eject_send_yneg;
    wire InjectSlotAvail_yneg,EjectSlotAvail_yneg; 
    wire [DataWidth-1:0] inject_zpos,eject_zpos;
    wire inject_receive_zpos,eject_send_zpos;
    wire InjectSlotAvail_zpos,EjectSlotAvail_zpos;
    wire [DataWidth-1:0] inject_zneg,eject_zneg;
    wire inject_receive_zneg,eject_send_zneg;
    wire InjectSlotAvail_zneg,EjectSlotAvail_zneg; 
    wire [DataWidth-1:0] inject_local,eject_local;
    wire inject_receive_local,eject_send_local;
    wire InjectSlotAvail_local,EjectSlotAvail_local; 
//local unit
    local_unit#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
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
    
    crossbar#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .ReductionBitPos(ReductionBitPos),
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
        .InjectSlotAvail_local(InjectSlotAvail_local)
    );
        
//xpos link
    internode_link#(
        .WIDTH(DataWidth),
        .DELAY(LinkDelay),
        .x(X),
        .y(Y),
        .z(Z),
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
    assign inject_receive_xpos=inject_xpos[DataWidth-1] && rx_ready_xpos;

//xneg link
    internode_link#(
        .WIDTH(DataWidth),
        .DELAY(LinkDelay),
        .x(X),
        .y(Y),
        .z(Z),
        .dir(3'b001)
    )
    xneg_link_inst(
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
    assign inject_receive_xneg=inject_xneg[DataWidth-1] && rx_ready_xneg;

//ypos link
    internode_link#(
        .WIDTH(DataWidth),
        .DELAY(LinkDelay),
        .x(X),
        .y(Y),
        .z(Z),
        .dir(3'b010)
    )
    ypos_link_inst(
        .rst(rst),
        .tx_clk(clk),
        .tx_par_data({eject_send_ypos,eject_ypos[DataWidth-2:0]}),
        .tx_ser_data(eject_ypos_ser),
        .tx_ready(EjectSlotAvail_ypos),
        .rx_clk(clk),
        .rx_par_data(inject_ypos),
        .rx_ser_data(inject_ypos_ser),
        .rx_ready(rx_ready_ypos)
    );
    assign inject_receive_ypos=inject_ypos[DataWidth-1] && rx_ready_ypos;

//yneg link
    internode_link#(
        .WIDTH(DataWidth),
        .DELAY(LinkDelay),
        .x(X),
        .y(Y),
        .z(Z),
        .dir(3'b011)
    )
    yneg_link_inst(
        .rst(rst),
        .tx_clk(clk),
        .tx_par_data({eject_send_yneg,eject_yneg[DataWidth-2:0]}),
        .tx_ser_data(eject_yneg_ser),
        .tx_ready(EjectSlotAvail_yneg),
        .rx_clk(clk),
        .rx_par_data(inject_yneg),
        .rx_ser_data(inject_yneg_ser),
        .rx_ready(rx_ready_yneg)
    );
    assign inject_receive_yneg=inject_yneg[DataWidth-1] && rx_ready_yneg;

//zpos link
    internode_link#(
        .WIDTH(DataWidth),
        .DELAY(LinkDelay),
        .x(X),
        .y(Y),
        .z(Z),
        .dir(3'b100)
    )
    zpos_link_inst(
        .rst(rst),
        .tx_clk(clk),
        .tx_par_data({eject_send_zpos,eject_zpos[DataWidth-2:0]}),
        .tx_ser_data(eject_zpos_ser),
        .tx_ready(EjectSlotAvail_zpos),
        .rx_clk(clk),
        .rx_par_data(inject_zpos),
        .rx_ser_data(inject_zpos_ser),
        .rx_ready(rx_ready_zpos)
    );
    assign inject_receive_zpos=inject_zpos[DataWidth-1] && rx_ready_zpos;

//zneg link
    internode_link#(
        .WIDTH(DataWidth),
        .DELAY(LinkDelay),
        .x(X),
        .y(Y),
        .z(Z),
        .dir(3'b101)
    )
    zneg_link_inst(
        .rst(rst),
        .tx_clk(clk),
        .tx_par_data({eject_send_zneg,eject_zneg[DataWidth-2:0]}),
        .tx_ser_data(eject_zneg_ser),
        .tx_ready(EjectSlotAvail_zneg),
        .rx_clk(clk),
        .rx_par_data(inject_zneg),
        .rx_ser_data(inject_zneg_ser),
        .rx_ready(rx_ready_zneg)
    );
    assign inject_receive_zneg=inject_zneg[DataWidth-1] && rx_ready_zneg;





    

endmodule
