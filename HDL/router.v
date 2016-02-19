//Purpose: one router among the six router on the ring-based switch
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 9th 2015
//
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


module router
#(
    parameter DataSize=8'd172,
    parameter X=8'd0,
    parameter Y=8'd0,
    parameter Z=8'd0,
    parameter srcID=4'd0,
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
)
(
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
    output ClockwiseSlotAvail,
    output CounterClockwiseSlotAvail,
    output InjectSlotAvail,
    output [7:0] CounterClockwiseUtil,
    output [7:0] ClockwiseUtil,
    output [7:0] InjectUtil
);

    parameter SINGLECAST=4'b1000;
    parameter MULTICAST=4'b1001;
    parameter REDUCTION=4'b1010;

	
	
	wire[DataWidth-1:0] ejector0_in;
	wire[DataWidth-1:0] ejector0_out0;//out0 is the ejecting port
	wire[DataWidth-1:0] ejector0_out1;//out1 is the port that directs to the next router
	//wire ejection0_match;
	wire[DataWidth-1:0] ejector1_in;
	wire[DataWidth-1:0] ejector1_out0;
	wire[DataWidth-1:0] ejector1_out1;
	//wire ejection1_match;
	
	wire[DataWidth-1:0] input_fifo_out;
	
	reg[DataWidth-1:0] injector_in;
	wire[2:0] dstID;
	reg[DataWidth-1:0] injector_out0;//counterclockwise
	reg[DataWidth-1:0] injector_out1;//clockwise
	
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

    wire [RoutingTableWidth-1:0] routing_table_entry;
    wire [ReductionTableWidth-1:0] reduction_table_entry;


    reg inject_consume;
    reg inject_consume_singlecast;

    reg inject_consume_multicast;//the read signal to read from multicast unit or reduction unit or direct input fifo
    reg [WeightWidth-1:0] weigth_split[4:0]; //weight split
    wire multicast_active; //indicate the multicast unit is active
    wire multicast_not_ready;
    wire fifo2_consume_multicast;
    wire [DataWidth-1:0] multicast_unit_out;


    wire [DataWidth-1:0] eject_before_reduction;
    wire reduction_consume;
    wire [DataWidth-1:0] reduction_unit_in;
    wire reduction_ready;
    wire reduction_hold;
    wire [DataWidth-1:0] reduction_unit_out;
    
    wire who_win_eject;// 0 is ejector0 win, 1 is ejector1 win
    

    

    
	
/*Only for simulation*/
  integer fd;
  reg [31:0] cycle_counter=0;
  always@(posedge clk)
    begin
    cycle_counter<=cycle_counter+1;
  end

  //register on counterclockwise ring
    FIFO #(
        .FIFO_depth(IntraNodeFIFODepth+1),
        .FIFO_width(DataWidth)
    )
    fifo0(
        .clk(clk),
        .rst(rst),
        .in(CounterClockwiseIn),
        .consume(fifo0_consume),//read enabling to out port from FIFO
        .produce(CounterClockwiseReceive),//write enabling to in port to FIFO 
        .out(ejector0_in),
        .full(fifo0_full),
        .empty(fifo0_empty),
        .util(CounterClockwiseUtil)
    );
	
	//register on clockwise ring
    //
    FIFO #(
        .FIFO_depth(IntraNodeFIFODepth+1),
        .FIFO_width(DataWidth)
    )
    fifo1(
        .clk(clk),
        .rst(rst),
        .in(ClockwiseIn),
        .consume(fifo1_consume),//read enabling to out port from FIFO
        .produce(ClockwiseReceive),//write enabling to in port to FIFO 
        .out(ejector1_in),
        .full(fifo1_full),
        .empty(fifo1_empty),
        .util(ClockwiseUtil)
    );
	
	//input fifo
    //
    FIFO #(
        .FIFO_depth(InterNodeFIFODepth),
        .FIFO_width(DataWidth)
    )
    fifo2(
        .clk(clk),
        .rst(rst),
        .in(inject),
        .consume(fifo2_consume),//read enabling to out port from FIFO
        .produce(inject_receive),//write enabling to in port to FIFO 
        .out(input_fifo_out),
        .full(fifo2_full),
        .empty(fifo2_empty),
        .util(InjectUtil)
    );

	
	//routing table
	reg[RoutingTableWidth-1:0] routing_table[RoutingTablesize-1:0];
	//packet assembler	
    //injector_in should depend on the packet type
    //
   // assign fifo2_consume=inject_consume_singlecast;
    assign routing_table_entry=routing_table[input_fifo_out[IndexPos+IndexWidth-1:IndexPos]];
    always@(*)begin
        if(input_fifo_out[DataWidth-1]==0) begin
            injector_in=0;
            fifo2_consume=0;
            inject_consume_multicast=0;
        end
        else if(multicast_active) begin //multicast has higher priority than singlecsast
            if(multicast_not_ready) begin
                injector_in=0;
                inject_consume_multicast=inject_consume;
                fifo2_consume=0;
            end
            else begin
                injector_in=multicast_unit_out;
           // inject_consume_singlecast=0;
                inject_consume_multicast=inject_consume;
                fifo2_consume=fifo2_consume_multicast;
            end
        end
        else if(routing_table_entry[RoutingTableWidth-1:RoutingTableWidth-PcktTypeLen]==SINGLECAST) begin
            injector_in={input_fifo_out[DataWidth-1],1'b0,input_fifo_out[ReductionBitPos-1:ExitPos+ExitWidth],routing_table_entry[27:24],routing_table_entry[7:0],input_fifo_out[WeightPos+WeightWidth-1:WeightPos],routing_table_entry[23:8],input_fifo_out[PayloadLen-1:0]};
            //inject_consume_singlecast=inject_consume;
            fifo2_consume=inject_consume;
            inject_consume_multicast=0;
        end
        else if(routing_table_entry[RoutingTableWidth-1:RoutingTableWidth-PcktTypeLen]==REDUCTION) begin
            injector_in={input_fifo_out[DataWidth-1],1'b1,input_fifo_out[ReductionBitPos-1:ExitPos+ExitWidth],routing_table_entry[27:24],routing_table_entry[7:0],input_fifo_out[WeightPos+WeightWidth-1:WeightPos],routing_table_entry[23:8],input_fifo_out[PayloadLen-1:0]};
            //inject_consume_singlecast=inject_consume;
            fifo2_consume=inject_consume;
            inject_consume_multicast=0;      
        end
        else begin
            injector_in=0;//invalid packet
            //inject_consume_singlecast=0;
            fifo2_consume=inject_consume;
            inject_consume_multicast=0;
        end
    end
    

   //multicast_unit
    //this unit will distribute the packets marked in the multicast entry to their destinations
    multicast_unit#(
        .SrcID(srcID),
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
    multicast_unit_inst(
        .clk(clk),
        .rst(rst),
        .input_fifo_out(input_fifo_out),
        .consume_inject(inject_consume_multicast),
        .routing_table_entry(routing_table_entry),
        .injector_in_multicast(multicast_unit_out),
        .start(multicast_active),
        .fifo2_consume_multicast(fifo2_consume_multicast),
        .start_but_not_ready(multicast_not_ready)
    );
//reduction unit
//this unit will collect the expect packet in each reduction entry, which will send a new packet when all the expectations are collected, this is related with eject port
    reduction_unit#(
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
    reduction_unit_inst(
        .clk(clk),
        .rst(rst),
        .EjectSlotAvail(EjectSlotAvail),
        .reduction_eject(eject_before_reduction),
        .routing_table_entry(routing_table_entry),
        .reduction_consume(reduction_consume),
        .ready(reduction_ready),
        .hold(reduction_hold),
        .eject_out_reduction(reduction_unit_out)  
    
    );
	
	//ejector0 on counterclockwise direction
	assign ejector0_match=(ejector0_in[ExitPos+ExitWidth-1:ExitPos]==srcID) && ejector0_in[DataWidth-1];
	assign ejector0_out0=ejector0_match?ejector0_in:0;
	assign ejector0_out1=(~ejector0_match)?ejector0_in:0;
	//ejector1 on clockwise direction
	assign ejector1_match=(ejector1_in[ExitPos+ExitWidth-1:ExitPos]==srcID) && ejector1_in[DataWidth-1];
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
	
	assign dstID=injector_in[ExitPos+ExitWidth-1:ExitPos];
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
	assign CounterClockwiseOut=(injector_out0[PriorityPos+PriorityWidth-1:PriorityPos]>ejector0_out1[PriorityPos+PriorityWidth-1:PriorityPos])?
						(injector_out0):(ejector0_out1);

	//mux for clockwise out
	assign ClockwiseOut=(injector_out1[PriorityPos+PriorityWidth-1:PriorityPos]>ejector1_out1[PriorityPos+PriorityWidth-1:PriorityPos])?
						(injector_out1):(ejector1_out1);
						
	//who win the ejector
    assign who_win_eject=(ejector1_out0[PriorityPos+PriorityWidth-1:PriorityPos]>ejector0_out0[PriorityPos+PriorityWidth-1:PriorityPos]);


	//mux for ejector
	assign eject_before_reduction=who_win_eject?(ejector1_out0):(ejector0_out0);
	
    assign eject=(reduction_hold)?((reduction_ready)?reduction_unit_out:0):eject_before_reduction;
	

	
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
					if(injector_out1[PriorityPos+PriorityWidth-1:PriorityPos]>ejector1_out1[PriorityPos+PriorityWidth-1:PriorityPos]&&(~fifo2_empty))
						begin
						inject_consume<=1;
						inject_turn<=3;
					end
					else
						begin
						inject_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					inject_consume<=0;
					inject_turn<=0;
				end
			end
			else//go to the counterclockwise direction
				begin
				if(CounterClockwiseNextSlotAvail)
				begin
					if(injector_out0[PriorityPos+PriorityWidth-1:PriorityPos]>ejector0_out1[PriorityPos+PriorityWidth-1:PriorityPos]&&(~fifo2_empty))
						begin
						inject_consume<=1;
						inject_turn<=2;
						//CounterClockwiseSend<=1;
					end
					else
						begin
						inject_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					inject_consume<=0;
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
					if(injector_out0[PriorityPos+PriorityWidth-1:PriorityPos]>ejector0_out1[PriorityPos+PriorityWidth-1:PriorityPos]&&(~fifo2_empty))
						begin
						inject_consume<=1;
						inject_turn<=2;
						//CounterClockwiseSend<=1;
					end
					else
						begin
						inject_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					inject_consume<=0;
					inject_turn<=0;
				end
				
				//injector_out0<=injector_in;
				//injector_out1<=0;
			end
			else
				begin
				if(ClockwiseNextSlotAvail)
					begin
					if(injector_out1[PriorityPos+PriorityWidth-1:PriorityPos]>ejector1_out1[PriorityPos+PriorityWidth-1:PriorityPos]&&(~fifo2_empty))
						begin
						inject_consume<=1;
						inject_turn<=3;
					end
					else
						begin
						inject_consume<=0;
						inject_turn<=0;
					end
				end
				else
					begin
					inject_consume<=0;
					inject_turn<=0;
				end
			end
		end
		else//srcD==dstID
		  begin 
		  if(injector_in[PriorityPos+PriorityWidth-1:PriorityPos]!=0)
		    begin
		    inject_consume<=1;//discard the local communication
		    inject_turn<=0;  
		  end
		  else
		    begin
		    inject_consume<=0;//do nothing
		    inject_turn<=0;
		  end
		end
	end
	
	
	always@(*) begin
        if(reduction_ready) begin //now the eject port is controlled by reduction unit
            eject_enable0<=0;
            fifo0_consume<=0;
        end
        else begin
	        if(ejector0_match) begin//being ejected
                if(who_win_eject==0) begin//ejector0_out0 wins if contention exists
                    if(reduction_hold) begin//the ejecting packet is a reduction packet
                        eject_enable0<=1;
                        fifo0_consume<=1;
                    end
                    else begin //not reduction packet           
                        if(EjectSlotAvail) begin //can be ejected
                            eject_enable0<=1;
					        fifo0_consume<=1;
				        end
				        else begin
					        eject_enable0<=0; 
					        fifo0_consume<=0;
				        end
		            end
		        end
			    else begin
				    eject_enable0<=0;
				    fifo0_consume<=0;
			    end
		    end
		    else begin //not being ejected
			    eject_enable0<=0;
		    	 if(CounterClockwiseNextSlotAvail) begin
				    if(injector_out0[PriorityPos+PriorityWidth-1:PriorityPos]<=ejector0_out1[PriorityPos+PriorityWidth-1:PriorityPos]&&(~fifo0_empty)) begin
					    fifo0_consume<=1;
				    end
				    else begin
					    fifo0_consume<=0;
				    end
			    end
			    else begin
				    fifo0_consume<=0;
			    end
		    end
        end		
	end
	
    always@(*)
		begin
        if(reduction_ready) begin //now the eject port is controlled by reduction unit
            eject_enable1<=0;
            fifo1_consume<=0;
        end
        else begin
	    	if(ejector1_match) begin//being ejected
                if(who_win_eject==1) begin//ejector1_out1 wins if contention exists
                    if(reduction_hold) begin//the ejecting packet is a reduction packet
                        eject_enable1<=1;
                        fifo1_consume<=1;
                    end
                    else begin //not reduction packet           
			            if(EjectSlotAvail) begin //can be ejected
					    eject_enable1<=1;
					    fifo1_consume<=1;
				        end
				        else begin
					        eject_enable1<=0; 
					        fifo1_consume<=0;
				        end
		        	end
		      end
			    else begin
				    eject_enable1<=0;
				    fifo1_consume<=0;
			    end
		    end
		    else begin //not being ejected
			    eject_enable1<=0;
		    	if(ClockwiseNextSlotAvail) begin
				    if(injector_out1[PriorityPos+PriorityWidth-1:PriorityPos]<=ejector1_out1[PriorityPos+PriorityWidth-1:PriorityPos]&&(~fifo1_empty)) begin
					    fifo1_consume<=1;
				    end
				    else begin
					    fifo1_consume<=0;
				    end
			    end
			    else begin
				    fifo1_consume<=0;
			    end
		    end
        end		
	end

	
	
	
	assign CounterClockwiseSend=(fifo0_consume&&(~eject_enable0)) || (inject_consume&&(inject_turn==2));
	assign ClockwiseSend=(fifo1_consume&&(~eject_enable1)) || (inject_consume&&(inject_turn==3));
	assign eject_send=reduction_hold ? reduction_ready:( eject_enable0 || eject_enable1 );
	
endmodule
						
	
	
	
	
	
	
			
	
	
	
	
	
