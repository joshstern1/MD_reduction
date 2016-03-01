//Purpose: crossbar-based switch that is composed of 7 routers
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Feb 10th 2015
//Dependency: in-port.v mux.v 
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
      1010 is the reduction packe
        
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
//reduction table entry format
/*
* at most five fan-in for 3D-torus network.
  for each fanin, format is as below:
  |3-bit expect counter|3-bit arrival bookkeeping counter|dst   |table index| weight accumulator| payload accumulator|
  |3 bits              | 3 bits                          |4 bits|16 bits    | 8 bits            | 128 bits           | 162 bits in total 
* */

module crossbar
#(
    parameter DataSize=8'd172,
    parameter X=8'd0,
    parameter Y=8'd0,
    parameter Z=8'd0,
 //   parameter srcID=4'd0,
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
    input [DataWidth-1:0] inject_local,
    input inject_receive_local,
    input EjectSlotAvail_local,
	
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
    output [DataWidth-1:0] eject_local,
    output eject_send_local,
    output InjectSlotAvail_local
);


    wire local_input_fifo_full;
    wire yneg_input_fifo_full;
    wire ypos_input_fifo_full;
    wire xpos_input_fifo_full;
    wire xneg_input_fifo_full;
    wire zpos_input_fifo_full;
    wire zneg_input_fifo_full;


    wire [DataWidth-1:0] local_out_port_in_local; //from local in port to local mux
    wire [DataWidth-1:0] local_out_port_in_xpos; //from local in port to xpos mux
    wire [DataWidth-1:0] local_out_port_in_xneg; //from local in port to xneg mux
    wire [DataWidth-1:0] local_out_port_in_ypos; //from local in port to ypos mux
    wire [DataWidth-1:0] local_out_port_in_yneg; //from local in port to yneg mux
    wire [DataWidth-1:0] local_out_port_in_zpos; //from local in port to zpos mux
    wire [DataWidth-1:0] local_out_port_in_zneg; //from local in port to zneg mux

    wire [DataWidth-1:0] xpos_out_port_in_local; //from xpos in port to local mux
    wire [DataWidth-1:0] xpos_out_port_in_xpos; //from xpos in port to xpos mux
    wire [DataWidth-1:0] xpos_out_port_in_xneg; //from xpos in port to xneg mux
    wire [DataWidth-1:0] xpos_out_port_in_ypos; //from xpos in port to ypos mux
    wire [DataWidth-1:0] xpos_out_port_in_yneg; //from xpos in port to yneg mux
    wire [DataWidth-1:0] xpos_out_port_in_zpos; //from xpos in port to zpos mux
    wire [DataWidth-1:0] xpos_out_port_in_zneg; //from xpos in port to zneg mux

    wire [DataWidth-1:0] xneg_out_port_in_local;//from xneg in port to local mux
    wire [DataWidth-1:0] xneg_out_port_in_xpos; //from xneg in port to xpos mux
    wire [DataWidth-1:0] xneg_out_port_in_xneg; //from xneg in port to xneg mux
    wire [DataWidth-1:0] xneg_out_port_in_ypos; //from xneg in port to ypos mux
    wire [DataWidth-1:0] xneg_out_port_in_yneg; //from xneg in port to yneg mux
    wire [DataWidth-1:0] xneg_out_port_in_zpos; //from xneg in port to zpos mux
    wire [DataWidth-1:0] xneg_out_port_in_zneg; //from xneg in port to zneg mux

    wire [DataWidth-1:0] ypos_out_port_in_local; //from ypos in port to local mux
    wire [DataWidth-1:0] ypos_out_port_in_xpos; //from ypos in port to xpos mux
    wire [DataWidth-1:0] ypos_out_port_in_xneg; //from ypos in port to xneg mux
    wire [DataWidth-1:0] ypos_out_port_in_ypos; //from ypos in port to ypos mux
    wire [DataWidth-1:0] ypos_out_port_in_yneg; //from ypos in port to yneg mux
    wire [DataWidth-1:0] ypos_out_port_in_zpos; //from ypos in port to zpos mux
    wire [DataWidth-1:0] ypos_out_port_in_zneg; //from ypos in port to zneg mux

    wire [DataWidth-1:0] yneg_out_port_in_local;//from yneg in port to local mux
    wire [DataWidth-1:0] yneg_out_port_in_xpos; //from yneg in port to xpos mux
    wire [DataWidth-1:0] yneg_out_port_in_xneg; //from yneg in port to xneg mux
    wire [DataWidth-1:0] yneg_out_port_in_ypos; //from yneg in port to ypos mux
    wire [DataWidth-1:0] yneg_out_port_in_yneg; //from yneg in port to yneg mux
    wire [DataWidth-1:0] yneg_out_port_in_zpos; //from yneg in port to zpos mux
    wire [DataWidth-1:0] yneg_out_port_in_zneg; //from yneg in port to zneg mux

    wire [DataWidth-1:0] zpos_out_port_in_local; //from zpos in port to local mux
    wire [DataWidth-1:0] zpos_out_port_in_xpos; //from zpos in port to xpos mux
    wire [DataWidth-1:0] zpos_out_port_in_xneg; //from zpos in port to xneg mux
    wire [DataWidth-1:0] zpos_out_port_in_ypos; //from zpos in port to ypos mux
    wire [DataWidth-1:0] zpos_out_port_in_yneg; //from zpos in port to yneg mux
    wire [DataWidth-1:0] zpos_out_port_in_zpos; //from zpos in port to zpos mux
    wire [DataWidth-1:0] zpos_out_port_in_zneg; //from zpos in port to zneg mux

    wire [DataWidth-1:0] zneg_out_port_in_local;//from zneg in port to local mux
    wire [DataWidth-1:0] zneg_out_port_in_xpos; //from zneg in port to xpos mux
    wire [DataWidth-1:0] zneg_out_port_in_xneg; //from zneg in port to xneg mux
    wire [DataWidth-1:0] zneg_out_port_in_ypos; //from zneg in port to ypos mux
    wire [DataWidth-1:0] zneg_out_port_in_yneg; //from zneg in port to yneg mux
    wire [DataWidth-1:0] zneg_out_port_in_zpos; //from zneg in port to zpos mux
    wire [DataWidth-1:0] zneg_out_port_in_zneg; //from zneg in port to zneg mux

    
    wire local_out_avail_local;
    wire local_out_avail_xpos;
    wire local_out_avail_xneg;
    wire local_out_avail_ypos;
    wire local_out_avail_yneg;
    wire local_out_avail_zpos;
    wire local_out_avail_zneg;
    
    wire xpos_out_avail_local;
    wire xpos_out_avail_xpos;
    wire xpos_out_avail_xneg;
    wire xpos_out_avail_ypos;
    wire xpos_out_avail_yneg;
    wire xpos_out_avail_zpos;
    wire xpos_out_avail_zneg;

    wire xneg_out_avail_local;
    wire xneg_out_avail_xpos;
    wire xneg_out_avail_xneg;
    wire xneg_out_avail_ypos;
    wire xneg_out_avail_yneg;
    wire xneg_out_avail_zpos;
    wire xneg_out_avail_zneg;
  
    wire ypos_out_avail_local;
    wire ypos_out_avail_xpos;
    wire ypos_out_avail_xneg;
    wire ypos_out_avail_ypos;
    wire ypos_out_avail_yneg;
    wire ypos_out_avail_zpos;
    wire ypos_out_avail_zneg;

    wire yneg_out_avail_local;
    wire yneg_out_avail_xpos;
    wire yneg_out_avail_xneg;
    wire yneg_out_avail_ypos;
    wire yneg_out_avail_yneg;
    wire yneg_out_avail_zpos;
    wire yneg_out_avail_zneg;

    wire zpos_out_avail_local;
    wire zpos_out_avail_xpos;
    wire zpos_out_avail_xneg;
    wire zpos_out_avail_ypos;
    wire zpos_out_avail_yneg;
    wire zpos_out_avail_zpos;
    wire zpos_out_avail_zneg;

    wire zneg_out_avail_local;
    wire zneg_out_avail_xpos;
    wire zneg_out_avail_xneg;
    wire zneg_out_avail_ypos;
    wire zneg_out_avail_yneg;
    wire zneg_out_avail_zpos;
    wire zneg_out_avail_zneg;

    wire local_in_port_stall;
    wire xpos_in_port_stall;
    wire xneg_in_port_stall;
    wire ypos_in_port_stall;
    wire yneg_in_port_stall;
    wire zpos_in_port_stall;
    wire zneg_in_port_stall;





    assign InjectSlotAvail_xpos=~xpos_input_fifo_full;
    assign InjectSlotAvail_xneg=~xneg_input_fifo_full;
    assign InjectSlotAvail_ypos=~ypos_input_fifo_full;
    assign InjectSlotAvail_yneg=~yneg_input_fifo_full;
    assign InjectSlotAvail_zpos=~zpos_input_fifo_full;
    assign InjectSlotAvail_zneg=~zneg_input_fifo_full;
    assign InjectSlotAvail_local=~local_input_fifo_full;

    in_port#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(0),
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
    LOCAL(
        .clk(clk),
        .rst(rst),
        .in(inject_local),
        .data_in_avail(inject_receive_local),
        .input_fifo_full(local_input_fifo_full),
        .out_port_in_local(local_out_port_in_local),
        .out_port_in_xpos(local_out_port_in_xpos),
        .out_port_in_xneg(local_out_port_in_xneg),
        .out_port_in_ypos(local_out_port_in_ypos),
        .out_port_in_yneg(local_out_port_in_yneg),
        .out_port_in_zpos(local_out_port_in_zpos),
        .out_port_in_zneg(local_out_port_in_zneg),
        .out_avail_local(local_out_avail_local),
        .out_avail_xpos(local_out_avail_xpos),
        .out_avail_xneg(local_out_avail_xneg),
        .out_avail_ypos(local_out_avail_ypos),
        .out_avail_yneg(local_out_avail_yneg),
        .out_avail_zpos(local_out_avail_zpos),
        .out_avail_zneg(local_out_avail_zneg),
        .stall(local_in_port_stall)

        
    );



    in_port#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(1),
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
    YNEG(
        .clk(clk),
        .rst(rst),
        .in(inject_yneg),
        .data_in_avail(inject_receive_yneg),
        .input_fifo_full(yneg_input_fifo_full),
        .out_port_in_local(yneg_out_port_in_local),
        .out_port_in_xpos(yneg_out_port_in_xpos),
        .out_port_in_xneg(yneg_out_port_in_xneg),
        .out_port_in_ypos(yneg_out_port_in_ypos),
        .out_port_in_yneg(yneg_out_port_in_yneg),
        .out_port_in_zpos(yneg_out_port_in_zpos),
        .out_port_in_zneg(yneg_out_port_in_zneg),
        .out_avail_local(yneg_out_avail_local),
        .out_avail_xpos(yneg_out_avail_xpos),
        .out_avail_xneg(yneg_out_avail_xneg),
        .out_avail_ypos(yneg_out_avail_ypos),
        .out_avail_yneg(yneg_out_avail_yneg),
        .out_avail_zpos(yneg_out_avail_zpos),
        .out_avail_zneg(yneg_out_avail_zneg),
        .stall(yneg_in_port_stall)

        
    );

    in_port#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(2),
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
    YPOS(
        .clk(clk),
        .rst(rst),
        .in(inject_ypos),
        .data_in_avail(inject_receive_ypos),
        .input_fifo_full(ypos_input_fifo_full),
        .out_port_in_local(ypos_out_port_in_local),
        .out_port_in_xpos(ypos_out_port_in_xpos),
        .out_port_in_xneg(ypos_out_port_in_xneg),
        .out_port_in_ypos(ypos_out_port_in_ypos),
        .out_port_in_yneg(ypos_out_port_in_yneg),
        .out_port_in_zpos(ypos_out_port_in_zpos),
        .out_port_in_zneg(ypos_out_port_in_zneg),
        .out_avail_local(ypos_out_avail_local),
        .out_avail_xpos(ypos_out_avail_xpos),
        .out_avail_xneg(ypos_out_avail_xneg),
        .out_avail_ypos(ypos_out_avail_ypos),
        .out_avail_yneg(ypos_out_avail_yneg),
        .out_avail_zpos(ypos_out_avail_zpos),
        .out_avail_zneg(ypos_out_avail_zneg),
        .stall(ypos_in_port_stall)        
    );

    in_port#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(3),
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
    XPOS(
        .clk(clk),
        .rst(rst),
        .in(inject_xpos),
        .data_in_avail(inject_receive_xpos),
        .input_fifo_full(xpos_input_fifo_full),
        .out_port_in_local(xpos_out_port_in_local),
        .out_port_in_xpos(xpos_out_port_in_xpos),
        .out_port_in_xneg(xpos_out_port_in_xneg),
        .out_port_in_ypos(xpos_out_port_in_ypos),
        .out_port_in_yneg(xpos_out_port_in_yneg),
        .out_port_in_zpos(xpos_out_port_in_zpos),
        .out_port_in_zneg(xpos_out_port_in_zneg),
        .out_avail_local(xpos_out_avail_local),
        .out_avail_xpos(xpos_out_avail_xpos),
        .out_avail_xneg(xpos_out_avail_xneg),
        .out_avail_ypos(xpos_out_avail_ypos),
        .out_avail_yneg(xpos_out_avail_yneg),
        .out_avail_zpos(xpos_out_avail_zpos),
        .out_avail_zneg(xpos_out_avail_zneg),
        .stall(xpos_in_port_stall)        
    );

    in_port#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(4),
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
    XNEG(
        .clk(clk),
        .rst(rst),
        .in(inject_xneg),
        .data_in_avail(inject_receive_xneg),
        .input_fifo_full(xneg_input_fifo_full),
        .out_port_in_local(xneg_out_port_in_local),
        .out_port_in_xpos(xneg_out_port_in_xpos),
        .out_port_in_xneg(xneg_out_port_in_xneg),
        .out_port_in_ypos(xneg_out_port_in_ypos),
        .out_port_in_yneg(xneg_out_port_in_yneg),
        .out_port_in_zpos(xneg_out_port_in_zpos),
        .out_port_in_zneg(xneg_out_port_in_zneg),
        .out_avail_local(xneg_out_avail_local),
        .out_avail_xpos(xneg_out_avail_xpos),
        .out_avail_xneg(xneg_out_avail_xneg),
        .out_avail_ypos(xneg_out_avail_ypos),
        .out_avail_yneg(xneg_out_avail_yneg),
        .out_avail_zpos(xneg_out_avail_zpos),
        .out_avail_zneg(xneg_out_avail_zneg),
        .stall(xneg_in_port_stall)

        
    );

    in_port#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(5),
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
    ZPOS(
        .clk(clk),
        .rst(rst),
        .in(inject_zpos),
        .data_in_avail(inject_receive_zpos),
        .input_fifo_full(zpos_input_fifo_full),
        .out_port_in_local(zpos_out_port_in_local),
        .out_port_in_xpos(zpos_out_port_in_xpos),
        .out_port_in_xneg(zpos_out_port_in_xneg),
        .out_port_in_ypos(zpos_out_port_in_ypos),
        .out_port_in_yneg(zpos_out_port_in_yneg),
        .out_port_in_zpos(zpos_out_port_in_zpos),
        .out_port_in_zneg(zpos_out_port_in_zneg),
        .out_avail_local(zpos_out_avail_local),
        .out_avail_xpos(zpos_out_avail_xpos),
        .out_avail_xneg(zpos_out_avail_xneg),
        .out_avail_ypos(zpos_out_avail_ypos),
        .out_avail_yneg(zpos_out_avail_yneg),
        .out_avail_zpos(zpos_out_avail_zpos),
        .out_avail_zneg(zpos_out_avail_zneg),
        .stall(zpos_in_port_stall)        
    );

    in_port#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(4),
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
    ZNEG(
        .clk(clk),
        .rst(rst),
        .in(inject_zneg),
        .data_in_avail(inject_receive_zneg),
        .input_fifo_full(zneg_input_fifo_full),
        .out_port_in_local(zneg_out_port_in_local),
        .out_port_in_xpos(zneg_out_port_in_xpos),
        .out_port_in_xneg(zneg_out_port_in_xneg),
        .out_port_in_ypos(zneg_out_port_in_ypos),
        .out_port_in_yneg(zneg_out_port_in_yneg),
        .out_port_in_zpos(zneg_out_port_in_zpos),
        .out_port_in_zneg(zneg_out_port_in_zneg),
        .out_avail_local(zneg_out_avail_local),
        .out_avail_xpos(zneg_out_avail_xpos),
        .out_avail_xneg(zneg_out_avail_xneg),
        .out_avail_ypos(zneg_out_avail_ypos),
        .out_avail_yneg(zneg_out_avail_yneg),
        .out_avail_zpos(zneg_out_avail_zpos),
        .out_avail_zneg(zneg_out_avail_zneg),
        .stall(zneg_in_port_stall)
    );


    mux#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(0),
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
    mux_local(
        .clk(clk),
        .rst(rst),
        .in_local(local_out_port_in_local),
        .in_yneg(yneg_out_port_in_local),
        .in_ypos(ypos_out_port_in_local),
        .in_xpos(xpos_out_port_in_local),
        .in_xneg(xneg_out_port_in_local),
        .in_zpos(zpos_out_port_in_local),
        .in_zneg(zneg_out_port_in_local),
        .in_pipeline_stall_local(local_in_port_stall),
        .in_pipeline_stall_yneg(yneg_in_port_stall),
        .in_pipeline_stall_ypos(ypos_in_port_stall),
        .in_pipeline_stall_xpos(xpos_in_port_stall),
        .in_pipeline_stall_xneg(xneg_in_port_stall),
        .in_pipeline_stall_zpos(zpos_in_port_stall),
        .in_pipeline_stall_zneg(zneg_in_port_stall),
        .in_avail_local(local_out_avail_local),
        .in_avail_yneg(yneg_out_avail_local),
        .in_avail_ypos(ypos_out_avail_local),
        .in_avail_xpos(xpos_out_avail_local),
        .in_avail_xneg(xneg_out_avail_local),
        .in_avail_zpos(zpos_out_avail_local),
        .in_avail_zneg(zneg_out_avail_local),
        .send(eject_send_local),
        .out(eject_local)
        
    );

    mux#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(1),
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
    mux_yneg(
        .clk(clk),
        .rst(rst),
        .in_local(local_out_port_in_yneg),
        .in_yneg(yneg_out_port_in_yneg),
        .in_ypos(ypos_out_port_in_yneg),
        .in_xpos(xpos_out_port_in_yneg),
        .in_xneg(xneg_out_port_in_yneg),
        .in_zpos(zpos_out_port_in_yneg),
        .in_zneg(zneg_out_port_in_yneg),
        .in_pipeline_stall_local(local_in_port_stall),
        .in_pipeline_stall_yneg(yneg_in_port_stall),
        .in_pipeline_stall_ypos(ypos_in_port_stall),
        .in_pipeline_stall_xpos(xpos_in_port_stall),
        .in_pipeline_stall_xneg(xneg_in_port_stall),
        .in_pipeline_stall_zpos(zpos_in_port_stall),
        .in_pipeline_stall_zneg(zneg_in_port_stall),
        .in_avail_local(local_out_avail_yneg),
        .in_avail_yneg(yneg_out_avail_yneg),
        .in_avail_ypos(ypos_out_avail_yneg),
        .in_avail_xpos(xpos_out_avail_yneg),
        .in_avail_xneg(xneg_out_avail_yneg),
        .in_avail_zpos(zpos_out_avail_yneg),
        .in_avail_zneg(zneg_out_avail_yneg),
        .send(eject_send_yneg),
        .out(eject_yneg)
        
    );

    mux#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(2),
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
    mux_ypos(
        .clk(clk),
        .rst(rst),
        .in_local(local_out_port_in_ypos),
        .in_yneg(yneg_out_port_in_ypos),
        .in_ypos(ypos_out_port_in_ypos),
        .in_xpos(xpos_out_port_in_ypos),
        .in_xneg(xneg_out_port_in_ypos),
        .in_zpos(zpos_out_port_in_ypos),
        .in_zneg(zneg_out_port_in_ypos),
        .in_pipeline_stall_local(local_in_port_stall),
        .in_pipeline_stall_yneg(yneg_in_port_stall),
        .in_pipeline_stall_ypos(ypos_in_port_stall),
        .in_pipeline_stall_xpos(xpos_in_port_stall),
        .in_pipeline_stall_xneg(xneg_in_port_stall),
        .in_pipeline_stall_zpos(zpos_in_port_stall),
        .in_pipeline_stall_zneg(zneg_in_port_stall),
        .in_avail_local(local_out_avail_ypos),
        .in_avail_yneg(yneg_out_avail_ypos),
        .in_avail_ypos(ypos_out_avail_ypos),
        .in_avail_xpos(xpos_out_avail_ypos),
        .in_avail_xneg(xneg_out_avail_ypos),
        .in_avail_zpos(zpos_out_avail_ypos),
        .in_avail_zneg(zneg_out_avail_ypos),
        .send(eject_send_ypos),
        .out(eject_ypos)
        
    );
 
    mux#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(3),
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
    mux_xpos(
        .clk(clk),
        .rst(rst),
        .in_local(local_out_port_in_xpos),
        .in_yneg(yneg_out_port_in_xpos),
        .in_ypos(ypos_out_port_in_xpos),
        .in_xpos(xpos_out_port_in_xpos),
        .in_xneg(xneg_out_port_in_xpos),
        .in_zpos(zpos_out_port_in_xpos),
        .in_zneg(zneg_out_port_in_xpos),
        .in_pipeline_stall_local(local_in_port_stall),
        .in_pipeline_stall_yneg(yneg_in_port_stall),
        .in_pipeline_stall_ypos(ypos_in_port_stall),
        .in_pipeline_stall_xpos(xpos_in_port_stall),
        .in_pipeline_stall_xneg(xneg_in_port_stall),
        .in_pipeline_stall_zpos(zpos_in_port_stall),
        .in_pipeline_stall_zneg(zneg_in_port_stall),
        .in_avail_local(local_out_avail_xpos),
        .in_avail_yneg(yneg_out_avail_xpos),
        .in_avail_ypos(ypos_out_avail_xpos),
        .in_avail_xpos(xpos_out_avail_xpos),
        .in_avail_xneg(xneg_out_avail_xpos),
        .in_avail_zpos(zpos_out_avail_xpos),
        .in_avail_zneg(zneg_out_avail_xpos),
        .send(eject_send_xpos),
        .out(eject_xpos)
        
    );

    mux#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(4),
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
    mux_xneg(
        .clk(clk),
        .rst(rst),
        .in_local(local_out_port_in_xneg),
        .in_yneg(yneg_out_port_in_xneg),
        .in_ypos(ypos_out_port_in_xneg),
        .in_xpos(xpos_out_port_in_xneg),
        .in_xneg(xneg_out_port_in_xneg),
        .in_zpos(zpos_out_port_in_xneg),
        .in_zneg(zneg_out_port_in_xneg),
        .in_pipeline_stall_local(local_in_port_stall),
        .in_pipeline_stall_yneg(yneg_in_port_stall),
        .in_pipeline_stall_ypos(ypos_in_port_stall),
        .in_pipeline_stall_xpos(xpos_in_port_stall),
        .in_pipeline_stall_xneg(xneg_in_port_stall),
        .in_pipeline_stall_zpos(zpos_in_port_stall),
        .in_pipeline_stall_zneg(zneg_in_port_stall),
        .in_avail_local(local_out_avail_xneg),
        .in_avail_yneg(yneg_out_avail_xneg),
        .in_avail_ypos(ypos_out_avail_xneg),
        .in_avail_xpos(xpos_out_avail_xneg),
        .in_avail_xneg(xneg_out_avail_xneg),
        .in_avail_zpos(zpos_out_avail_xneg),
        .in_avail_zneg(zneg_out_avail_xneg),
        .send(eject_send_xneg),
        .out(eject_xneg)
        
    );
    mux#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(5),
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
    mux_zpos(
        .clk(clk),
        .rst(rst),
        .in_local(local_out_port_in_zpos),
        .in_yneg(yneg_out_port_in_zpos),
        .in_ypos(ypos_out_port_in_zpos),
        .in_xpos(xpos_out_port_in_zpos),
        .in_xneg(xneg_out_port_in_zpos),
        .in_zpos(zpos_out_port_in_zpos),
        .in_zneg(zneg_out_port_in_zpos),
        .in_pipeline_stall_local(local_in_port_stall),
        .in_pipeline_stall_yneg(yneg_in_port_stall),
        .in_pipeline_stall_ypos(ypos_in_port_stall),
        .in_pipeline_stall_xpos(xpos_in_port_stall),
        .in_pipeline_stall_xneg(xneg_in_port_stall),
        .in_pipeline_stall_zpos(zpos_in_port_stall),
        .in_pipeline_stall_zneg(zneg_in_port_stall),
        .in_avail_local(local_out_avail_zpos),
        .in_avail_yneg(yneg_out_avail_zpos),
        .in_avail_ypos(ypos_out_avail_zpos),
        .in_avail_xpos(xpos_out_avail_zpos),
        .in_avail_xneg(xneg_out_avail_zpos),
        .in_avail_zpos(zpos_out_avail_zpos),
        .in_avail_zneg(zneg_out_avail_zpos),
        .send(eject_send_zpos),
        .out(eject_zpos)
        
    );

    mux#(
        .DataSize(DataSize),
        .X(X),
        .Y(Y),
        .Z(Z),
        .srcID(4),
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
    mux_zneg(
        .clk(clk),
        .rst(rst),
        .in_local(local_out_port_in_zneg),
        .in_yneg(yneg_out_port_in_zneg),
        .in_ypos(ypos_out_port_in_zneg),
        .in_xpos(xpos_out_port_in_zneg),
        .in_xneg(xneg_out_port_in_zneg),
        .in_zpos(zpos_out_port_in_zneg),
        .in_zneg(zneg_out_port_in_zneg),
        .in_pipeline_stall_local(local_in_port_stall),
        .in_pipeline_stall_yneg(yneg_in_port_stall),
        .in_pipeline_stall_ypos(ypos_in_port_stall),
        .in_pipeline_stall_xpos(xpos_in_port_stall),
        .in_pipeline_stall_xneg(xneg_in_port_stall),
        .in_pipeline_stall_zpos(zpos_in_port_stall),
        .in_pipeline_stall_zneg(zneg_in_port_stall),
        .in_avail_local(local_out_avail_zneg),
        .in_avail_yneg(yneg_out_avail_zneg),
        .in_avail_ypos(ypos_out_avail_zneg),
        .in_avail_xpos(xpos_out_avail_zneg),
        .in_avail_xneg(xneg_out_avail_zneg),
        .in_avail_zpos(zpos_out_avail_zneg),
        .in_avail_zneg(zneg_out_avail_zneg),
        .send(eject_send_zneg),
        .out(eject_zneg)
        
    );







endmodule
    

