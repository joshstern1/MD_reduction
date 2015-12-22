//Purpose: Injection unit to inject packet into network
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 9th 2015
//
//the 256-bit data format will be like this
//Outside the router 
/*
    *|255      |254--251     |250--247     |246--243     |242--227        |226--223   |222--152|151-----144|143-----128|127--96|95--64|63--32|31--0|
    *|valid bit|Z of src node|Y of src node|X of src onde|id of the packet|packet type|unused  |log  weight|table Index|type   |z     |y     |x    |

    *

    */
//inside the router
/*
    *|255      |254--251     |250--247     |246--243     |242--227        |226---223  |222--164|163---160|159---152|151-----144|143-----128|127--96|95--64|63--32|31--0|
    *|valid bit|Z of src node|Y of src node|X of src onde|id of the packet|packet type|unused  |dst      |priority |log  weight|table index|type   |z     |y     |x    |

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
        
    */
module local_unit
#(
    parameter X=4'd0,
    parameter Y=4'd0,
    parameter Z=4'd0,
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
    parameter PcktTypeLen=4
)
(
    input clk,
    input rst,
    input [DataWidth-1:0] eject_local,
    input eject_send_local,
    input InjectSlotAvail_Avail,

    output [DataWidth-1:0] inject_local,
    output inject_receive_local,
    output EjectSlotAvail_local
);
    wire local_fifo_full;
    wire local_fifo_empty;
    wire [DataWidth-1:0] local_fifo_out;
    wire [15:0] local_fifo_util;
    integer fd;
    wire [CoordWidth-1:0] XCoord;
    wire [CoordWidth-1:0] YCoord;
    wire [CoordWidth-1:0] ZCoord;
    reg [31:0] cycle_counter;

    reg [IndexWidth-1:0] packet_counter=0;
//routing table copy
    reg [RoutingTableWidth-1:0] routing_table[RoutingTable_size-1:0];
//data is register based 
    
    
    assign XCoord=X;
    assign YCoord=Y;
    assign ZCoord=Z;
//local FIFO instantiated
    FIFO #(
        .FIFO_depth(packet_count),
        .FIFO_width(DataWidth)
    )
    local_fifo(
        .clk(clk),
        .rst(rst),
        .in(eject_local),
        .consume(1'b0),//read enabling to out port from FIFO
        .produce(eject_send_local),//write enabling to in port to FIFO 
        .out(local_fifo_out),
        .full(local_fifo_full),
        .empty(local_fifo_empty),
        .util(local_fifo_util)
    );
	always@(posedge clk) begin
        if(rst)
            cycle_counter<=0;
        else 
	        cycle_counter<=cycle_counter+1;
	end
    
    assign EjectSlotAvail_local=~local_fifo_full;
    always@(posedge clk) begin
        if(eject_send_local && EjectSlotAvail_local) begin
            fd=$fopen("dump.txt","a");
            $strobe("Displaying in %m\t");
            if(eject_local[PacketTypePos+PcktTypeLen-1:PacketTypePos]==4'b1010)
                $strobe("reduction packet\t");
            else
                $strobe("multicast packet\t");
            $strobe("packet arrives from (%d,%d,%d) whose id is %d at cycle #%d\n",eject_local[XCoordPos+CoordWidth-1:XCoordPos],eject_local[YCoordPos+CoordWidth-1:YCoordPos],eject_local[ZCoordPos+CoordWidth-1:ZCoordPos],eject_local[PacketIDPos+PcktTypeLen-1:PacketIDPos],cycle_counter);
            $fdisplay(fd,"Arriving at %m\t");
//format [src.x] [src.y] [src.z] [dst.x] [dst.y] [dst.z] [id] [time] [packet type]

            $fdisplay(fd,"%d %d %d %d %d %d %d %d %d",eject_local[XCoordPos+CoordWidth-1:XCoordPos],eject_local[YCoordPos+CoordWidth-1:YCoordPos],eject_local[ZCoordPos+CoordWidth-1:ZCoordPos],X,Y,Z,eject_local[PacketIDPos+PcktTypeLen-1:PacketIDPos],cycle_counter,eject_local[PacketTypePos+PcktTypeLen-1:PacketTypePos]);
            $fclose(fd);
        end
    end

    assign inject_local={1'b1,ZCoord,YCoord,XCoord,packet_counter,routing_table[packet_counter][31:28],71'd0,8'd128,packet_counter,32'd0,32'd1,32'd1,32'd1};
    


    always@(posedge clk) begin
        if(rst) begin
            packet_counter<=0;
        end
        else if(InjectSlotAvail_local&&packet_counter<=packet_count) begin
            if(routing_table[packet_counter][routing_table_width-1]) begin//valid bit is high means the table entry is valid
                packet_counter<=packet_counter+1;
            
                fd=$fopen("dump.txt","a");
                if(fd)
                    $display("file open successfully\n");
                else
                    $display("file open failed\n");
                $strobe("Displaying in %m\t");
                if(inject_local[PacketIDPos+PcktLen-1:PacketIDPos]==4'b1010)
                    $strobe("reduction packet\t");
                else
                    $strobe("multicast packet\t");
                $strobe("data from (%d, %d, %d) whose id #%d is injected into the network at cycle %d",XCoord,YCoord,ZCoord,packet_counter,cycle_counter);
//format [src.x] [src.y] [src.z] [id] [time] [packet type]
                $fdisplay(fd,"%d %d %d %d %d %d",XCoord,YCoord,ZCoord,packet_counter,cycle_counter,inject_local[PacketIDPos+PcktLen-1:PacketIDPos]);
                $fclose(fd);
        
            end
        end
    end
            
                
endmodule

    

	 

    
    
