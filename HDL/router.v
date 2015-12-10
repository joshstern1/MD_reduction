//Purpose: 
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 9th 2015
//
//
//the 256-bit data format will be like this
//Outside the router 
/*
    *|255      |254---152|151-----144|143-----128|127--96|95--64|63--32|31--0|
    *|valid bit|unused   |log  weight|table Index|type   |z     |y     |z    |

    *

    */
//inside the router
/*
    *|255      |254---152|151-----144|143--136|135---128|127--96|95--64|63--32|31--0|
    *|valid bit|unused   |log  weight|priority|exit port|type   |z     |y     |z    |

    *

    */


module 
#(
    parameter srcID=3'd0,
    parameter PayloadLen=128,
    parameter DataWidth=256,
    parameter WeightPos=144,
    parameter WeightWidth=8,
    parameter IndexPos=128,
    parameter IndexWidth=16,
    parameter PriorityPos=136,
    parameter PriorityWidth=8,
    parameter ExitPos=128,
    parameter ExitWidth=8
)
router(
//input
    input clk,
    input rst,
    input [DataWidth-1:0] ClockwiseIn,
    input [DataWidth-1:0] CounterClockwiseIn,
    input [DataWidth-1:0] inject, //data injected from other node or local
    input inject_receive,//write signal at the inject port
    input ClockwiseReceive,//write signal at the clockwise port
    input CounterClockwiseReceive,//write signal at the CounterClockwise port
    input ClockwiseNextSlotAvail,
    input CounterClockwiseNextSlotAvail,
    input EjectSlotAvail,


//output
    output [DataWidth-1:0] ClockwiseOut,
    output [DataWidth-1:0] CounterClockwiseOut,
    output [DataWidth-1:0] eject,
    output eject_send,
    output ClockwiseSend,
    output CounterClockwiseSend,
    output ClockwiseAvail,
    output CounterClockwiseAvail,
    output InjectSlotAvail,
    output [7:0] CounterClockwiseUtil,
    output [7:0] ClockwiseUtil,
    output [7:0] InjectUtil
);
	
	parameter srcID=3'd0;
//	parameter DataLenInside=24;
//	parameter DataLenOutside=16;
	parameter DataLenInside=48;
	parameter DataLenOutside=40;
	//parameter IntraRingFIFODepth=2;
	parameter IntraRingFIFODepth=3;
	parameter IDLen=3;
	parameter PriorityLen=5; //priority field has 5 bits, 0 is the lowest priority
	parameter TableIndexFieldLen=16;
	
	parameter InterRingFIFODepth=1000;
	parameter table_size=1024;
	
	input clk,rst;
	input [DataLenInside-1:0] ClockwiseIn,CounterClockwiseIn;
	input [DataLenOutside-1:0] inject;
	input inject_receive;
	input ClockwiseReceive;
	input CounterClockwiseReceive;
	input ClockwiseNextSlotAvail;
	input CounterClockwiseNextSlotAvail;
	input EjectSlotAvail;
	
	output [DataLenInside-1:0] ClockwiseOut,CounterClockwiseOut;
	output [DataLenOutside-1:0] eject;
	output eject_send;
	output ClockwiseSend;
	output CounterClockwiseSend;
	output ClockwiseSlotAvail;
	output CounterClockwiseSlotAvail;
	output InjectSlotAvail;
    output [31:0] ClockwiseUtil;
    output [31:0] CounterClockwiseUtil;
    output [31:0] InjectUtil;
	//output fifo0_full;
	//output fifo1_full;
	
	
	
	wire[DataLenInside-1:0] ejector0_in;
	wire[DataLenInside-1:0] ejector0_out0;//out0 is the ejecting port
	wire[DataLenInside-1:0] ejector0_out1;//out1 is the port that directs to the next router
	//wire ejection0_match;
	wire[DataLenInside-1:0] ejector1_in;
	wire[DataLenInside-1:0] ejector1_out0;
	wire[DataLenInside-1:0] ejector1_out1;
	//wire ejection1_match;
	
	wire[DataLenOutside-1:0] input_fifo_out;
	
	wire[DataLenInside-1:0] injector_in;
	wire[IDLen-1:0] dstID;
	reg[DataLenInside-1:0] injector_out0;//counterclockwise
	reg[DataLenInside-1:0] injector_out1;//clockwise
	
	wire fifo0_full;
	wire fifo0_empty;
	wire fifo1_full;
	wire fifo1_empty;
	wire fifo2_full;
	wire fifo2_empty;
	reg fifo0_consume;
	reg fifo1_consume;
	reg fifo2_consume;
	
	reg [1:0] inject_turn; //2 is for Counterclockwise, 3 is for Clockwise, 0 is no turn
	reg eject_enable0;//the counterclockwise input is ejected
	reg eject_enable1;//the clockwise input is ejected

	
	
	
	
/*Only for simulation*/
  integer fd;
  reg [31:0] cycle_counter=0;
  always@(posedge clk)
    begin
    cycle_counter<=cycle_counter+1;
  end

/*  always@(posedge clk)
    begin
    if(srcID==0 && inject_receive && injector_in[7:0]<=8'd64 &&dstID!=0)
      begin
      fd=$fopen("dump.txt","a");
      if(fd)
        $display("file open successfully\n");
      else
        $display("file open failed\n");
      $strobe("Displaying in %m\t");
      $strobe("data from (%d,%d) whose id # %d is injected into the network at cycle %d",injector_in[15:12],injector_in[11:8],injector_in[7:0],cycle_counter);
// format [src.x] [src.y] [id] [time]
      $fdisplay(fd,"Departure from %m\t");
      $fdisplay(fd,"%d %d %d %d",injector_in[15:12],injector_in[11:8],injector_in[7:0],cycle_counter);
      $fclose(fd);
    end
  end*/
    


	
	
	
	//register on counterclockwise ring
	defparam fifo0.FIFO_depth=IntraRingFIFODepth;
	defparam fifo0.FIFO_width=DataLenInside;
	FIFO fifo0(clk,rst,CounterClockwiseIn,ejector0_in,fifo0_consume,CounterClockwiseReceive,fifo0_full,fifo0_empty,CounterClockwiseUtil);
	
	//register on clockwise ring
	defparam fifo1.FIFO_depth=IntraRingFIFODepth;
	defparam fifo1.FIFO_width=DataLenInside;
	FIFO fifo1(clk,rst,ClockwiseIn,ejector1_in,fifo1_consume,ClockwiseReceive,fifo1_full,fifo1_empty,ClockwiseUtil);
	
	//input fifo
	defparam fifo2.FIFO_depth=InterRingFIFODepth;
	defparam fifo2.FIFO_width=DataLenOutside;
	FIFO fifo2(clk,rst,inject,input_fifo_out,fifo2_consume,inject_receive,fifo2_full,fifo2_empty,InjectUtil);
	
	//routing table
	reg[DataLenInside-DataLenOutside-1+TableIndexFieldLen:0] routing_table[table_size-1:0];
	//initial $readmemh("table",routing_table);
	//packet assembler
	
	assign injector_in={routing_table[input_fifo_out[DataLenOutside-1:DataLenOutside-TableIndexFieldLen]],input_fifo_out[DataLenOutside-TableIndexFieldLen-1:0]};
	
	
	
	//ejector0 on counterclockwise direction
	assign ejector0_match=(ejector0_in[DataLenInside-1:DataLenInside-IDLen]==srcID);
	assign ejector0_out0=ejector0_match?ejector0_in:0;
	assign ejector0_out1=(~ejector0_match)?ejector0_in:0;
	//ejector1 on clockwise direction
	assign ejector1_match=(ejector1_in[DataLenInside-1:DataLenInside-IDLen]==srcID);
	assign ejector1_out0=ejector1_match?ejector1_in:0;
	assign ejector1_out1=(~ejector1_match)?ejector1_in:0;
	
	//injector
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
	
	assign dstID=injector_in[DataLenInside-1:DataLenInside-IDLen];
	//injector block
	always@(*)
		begin
		if(dstID>srcID)
			begin
			if(dstID>srcID+3)
				begin
				injector_out1<=injector_in;//go to the clockwise direction
				injector_out0<=0;
			end
			else
			  begin
				injector_out0<=injector_in;//go to the counterclockwise direction
				injector_out1<=0;
			end
		end
		else if(dstID<srcID)
			begin
			if(7-srcID+dstID<4)
				begin
				injector_out0<=injector_in;//go to the counterclockwise direction
				injector_out1<=0;
			end
			else
				begin
				injector_out1<=injector_in;//go to the clockwise direction
				injector_out0<=0;
			end
		end
		else
		  begin
		  injector_out0<=0;//if srcID equals to dstID the packet is invalid
		  injector_out1<=0;
		end
	end
	
	//mux for counter clockwise out	
	assign CounterClockwiseOut=(injector_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector0_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen])?
						(injector_out0):(ejector0_out1);

	//mux for clockwise out
	assign ClockwiseOut=(injector_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector1_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen])?
						(injector_out1):(ejector1_out1);
						
	
	//mux for ejector
	assign eject=(ejector0_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector1_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen])?
					(ejector0_out0[DataLenOutside-1:0]):(ejector1_out0[DataLenOutside-1:0]);
	
	

	
	assign CounterClockwiseSlotAvail=(~fifo0_full);
	assign ClockwiseSlotAvail=(~fifo1_full);
	assign InjectSlotAvail=(~fifo2_full);
	
	
	always@(*)
		begin
		if(dstID>srcID)
			begin
			if(dstID>srcID+3)//go to clockwise direction
				begin
				if(ClockwiseNextSlotAvail)
					begin
					if(injector_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector1_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo2_empty))
						begin
						fifo2_consume<=1;
						inject_turn<=3;
					end
					else
						begin
						fifo2_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					fifo2_consume<=0;
					inject_turn<=0;
				end
			end
			else//go to the counterclockwise direction
				begin
				if(CounterClockwiseNextSlotAvail)
				begin
					if(injector_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector0_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo2_empty))
						begin
						fifo2_consume<=1;
						inject_turn<=2;
						//CounterClockwiseSend<=1;
					end
					else
						begin
						fifo2_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					fifo2_consume<=0;
					inject_turn<=0;
				end
			end
		end
		else if(dstID<srcID)
			begin
			if(7-srcID+dstID<4)//go to the counterclockwise direction
				begin
				if(CounterClockwiseNextSlotAvail)
				begin
					if(injector_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector0_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo2_empty))
						begin
						fifo2_consume<=1;
						inject_turn<=2;
						//CounterClockwiseSend<=1;
					end
					else
						begin
						fifo2_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					fifo2_consume<=0;
					inject_turn<=0;
				end
				
				//injector_out0<=injector_in;
				//injector_out1<=0;
			end
			else
				begin
				if(ClockwiseNextSlotAvail)
					begin
					if(injector_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector1_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo2_empty))
						begin
						fifo2_consume<=1;
						inject_turn<=3;
					end
					else
						begin
						fifo2_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					fifo2_consume<=0;
					inject_turn<=0;
				end
			end
		end
		else//srcD==dstID
		  begin 
		  if(injector_in[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]!=0)
		    begin
		    fifo2_consume<=1;//discard the local communication
		    inject_turn<=0;  
		  end
		  else
		    begin
		    fifo2_consume<=0;//do nothing
		    inject_turn<=0;
		  end
		end
	end
	
	
	always@(*)
		begin
		if(ejector0_in[DataLenInside-1:DataLenInside-IDLen]==srcID)//being ejected
			begin
			if(EjectSlotAvail)
				begin
				if(ejector0_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]>ejector1_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo0_empty))
					begin
					eject_enable0<=1;
					fifo0_consume<=1;
				end
				else
					begin
					eject_enable0<=0; 
					fifo0_consume<=0;
				end
			end
			else
				begin
				eject_enable0<=0;
				fifo0_consume<=0;
			end
		end
		else
			begin
			eject_enable0<=0;
			if(CounterClockwiseNextSlotAvail)
				begin
				if(injector_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]<=ejector0_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo0_empty))
					begin
					fifo0_consume<=1;
				end
				else
					begin
					fifo0_consume<=0;
				end
			end
			else
				begin
				fifo0_consume<=0;
			end
		end
		
	end
	
	
	always@(*)
		begin
		if(ejector1_in[DataLenInside-1:DataLenInside-IDLen]==srcID)//being ejected
			begin
			if(EjectSlotAvail)
				begin
				if(ejector0_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]<=ejector1_out0[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo1_empty))
					begin
					eject_enable1<=1;
					fifo1_consume<=1;
				end
				else
					begin
					eject_enable1<=0;
					fifo1_consume<=0;
				end
			end
			else
				begin
				eject_enable1<=0;
				fifo1_consume<=0;
			end
		end
		else
			begin
			eject_enable1<=0;
			if(ClockwiseNextSlotAvail)
				begin
				if(injector_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]<=ejector1_out1[DataLenInside-IDLen-1:DataLenInside-IDLen-PriorityLen]&&(~fifo1_empty))
					begin
					fifo1_consume<=1;
				end
				else
					begin
					fifo1_consume<=0;
				end
			end
			else
				begin
				fifo1_consume<=0;
			end
		end		
	end
	
	assign CounterClockwiseSend=(fifo0_consume&&(~eject_enable0)) || (fifo2_consume&&(inject_turn==2));
	assign ClockwiseSend=(fifo1_consume&&(~eject_enable1)) || (fifo2_consume&&(inject_turn==3));
	assign eject_send=eject_enable0 || eject_enable1;
	
endmodule
						
	
	
	
	
	
	
			
	
	
	
	
	
