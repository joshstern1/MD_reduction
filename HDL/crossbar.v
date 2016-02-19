//Purpose: crossbar-based switch that is composed of 7 routers
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Feb 10th 2015
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

crossbar
#(
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
    output InjectSlotAvail_local,

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

    

