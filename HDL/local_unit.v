//Purpose: Injection unit to inject packet into network
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 9th 2015
//
//the 256-bit data format will be like this
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
        
    */

`define MULTICAST

module local_unit
#(
    parameter DataSize=8'd172,
    parameter X=8'd0,
    parameter Y=8'd0,
    parameter Z=8'd0,
    parameter CoordWidth=8,
    parameter SrcXCoordPos=230,
    parameter SrcYCoordPos=238,
    parameter SrcZCoordPos=246,
    parameter DstXCoordPos=194,
    parameter DstYCoordPos=202,
    parameter DstZCoordPos=210,
    parameter SrcPacketIDPos=222,
    parameter DstPacketIDPos=186,
    parameter PacketTypePos=218,
    parameter packet_count=256,
    parameter ReductionBitPos=254,
    parameter PayloadLen=128,
    parameter DataWidth=256,
    parameter ReductionBitWidth=254,
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
    parameter ReductionTableWidth=19,
    parameter ReductionTablesize=256,
    parameter PcktTypeLen=4
)
(
    input clk,
    input rst,
    input [DataWidth-1:0] eject_local,
    input eject_send_local,
    input InjectSlotAvail_local,

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
    reg [31:0] cycle_counter=0;

    reg [IndexWidth-1:0] packet_counter=0;
//routing table copy
    reg [RoutingTableWidth-1:0] routing_table[RoutingTablesize-1:0];
//data is register based 
//
    reg [DataWidth-1:0] eject_local_reg;
    

    always@(posedge clk) begin
        if(rst)
            cycle_counter<=0;
        else
            cycle_counter<=cycle_counter+1;
    end


`ifdef MULTICAST
    reg [DataWidth-1:0] data[DataSize-1:0];
    //all the data share the same path, so each data will use the same table entry
    reg [7:0] data_ptr;
    wire [15:0] table_ptr;

    assign inject_local=(data_ptr>=DataSize)?0:data[data_ptr];
    assign inject_receive_local=inject_local[DataWidth-1];

    always@(posedge clk) begin
        if(rst) begin
            data_ptr<=0;
        end
        else if(InjectSlotAvail_local&&inject_receive_local) begin
            data_ptr<=data_ptr+1;
            fd=$fopen("dump.txt","a");
            if(fd)
                $display("file: dump.txt open successfully\n");
            else
                $display("file open failed\n");
            $strobe("Displaying in %m\t");
            $strobe("multicast packet\t");
            $strobe("data from (%d, %d, %d) whose id #%d is injected into the network at cycle %d",XCoord,YCoord,ZCoord,data_ptr,cycle_counter);
            //format [src.x] [src.y] [src.z] [id] [time] [packet type]
            $fdisplay(fd,"Departuring: \n %d %d %d %d %d 9",XCoord,YCoord,ZCoord,data_ptr,cycle_counter);
            $fclose(fd);
        end
    end

    always@(posedge clk) begin
        eject_local_reg<=eject_local;
    end
            
    assign EjectSlotAvail_local=1;
    always@(posedge clk) begin
        if(eject_send_local && EjectSlotAvail_local) begin
            fd=$fopen("dump.txt","a");
            $strobe("Displaying in %m\t");
            $strobe("multicast packet\t");
            $strobe("packet arrives from (%d,%d,%d) whose id is %d at cycle #%d\n",eject_local_reg[SrcXCoordPos+CoordWidth-1:SrcXCoordPos],eject_local_reg[SrcYCoordPos+CoordWidth-1:SrcYCoordPos],eject_local_reg[SrcZCoordPos+CoordWidth-1:SrcZCoordPos],eject_local_reg[SrcPacketIDPos+7:SrcPacketIDPos],cycle_counter);
            $fdisplay(fd,"Arriving\t");
            //format [src.x] [src.y] [src.z] [dst.x] [dst.y] [dst.z] [id] [time] [packet type]
            $fdisplay(fd,"%d %d %d %d %d %d %d %d 9",eject_local[SrcXCoordPos+CoordWidth-1:SrcXCoordPos],eject_local[SrcYCoordPos+CoordWidth-1:SrcYCoordPos],eject_local[SrcZCoordPos+CoordWidth-1:SrcZCoordPos],X,Y,Z,eject_local[SrcPacketIDPos+7:SrcPacketIDPos],cycle_counter);
            $fclose(fd);
        end
    end

`endif

`ifdef REDUCTION
    //each packet has its own routing table entry
    reg [DataWidth-1:0] data[DataSize-1:0];
    //all the data share the same path, so each data will use the same table entry
    reg [7:0] data_ptr;
    wire [15:0] table_ptr;
    assign inject_local=(data_ptr>=DataSize)?0:data[data_ptr];
    assign inject_receive_local=inject_local[DataWidth-1];
    always@(posedge clk) begin
        if(rst) begin
            data_ptr<=0;
        end
        else if(InjectSlotAvail_local&&inject_receive_local) begin
            data_ptr<=data_ptr+1;
            fd=$fopen("dump.txt","a");
            if(fd)
                $display("file: dump.txt open successfully\n");
            else
                $display("file open failed\n");
            $strobe("Displaying in %m\t");
            $strobe("reduction packet\t");
            $strobe("data from (%d, %d, %d) whose id #%d is injected into the network at cycle %d",XCoord,YCoord,ZCoord,data_ptr,cycle_counter);
            //format [src.x] [src.y] [src.z] [id] [time] [packet type]
            $fdisplay(fd,"Departuring: \n %d %d %d %d %d 10",XCoord,YCoord,ZCoord,packet_counter,cycle_counter);
            $fclose(fd);
        end
    end
    always@(posedge clk) begin
        eject_local_reg<=eject_local;
    end
            
            
    assign EjectSlotAvail_local=1;
    always@(posedge clk) begin
        if(eject_send_local && EjectSlotAvail_local) begin
            fd=$fopen("dump.txt","a");
            $strobe("Displaying in %m\t");
            $strobe("reduction packet\t");
            $strobe("packet arrives from (%d,%d,%d) whose id is %d at cycle #%d\n",eject_local_reg[SrcXCoordPos+CoordWidth-1:SrcXCoordPos],eject_local_reg[SrcYCoordPos+CoordWidth-1:SrcYCoordPos],eject_local_reg[SrcZCoordPos+CoordWidth-1:SrcZCoordPos],eject_local_reg[SrcPacketIDPos+7:SrcPacketIDPos],cycle_counter);
            $fdisplay(fd,"Arriving\t");
            //format [src.x] [src.y] [src.z] [dst.x] [dst.y] [dst.z] [id] [time] [packet type]
            $fdisplay(fd,"%d %d %d %d %d %d %d %d 10",eject_local[SrcXCoordPos+CoordWidth-1:SrcXCoordPos],eject_local[SrcYCoordPos+CoordWidth-1:SrcYCoordPos],eject_local[SrcZCoordPos+CoordWidth-1:SrcZCoordPos],X,Y,Z,eject_local[SrcPacketIDPos+7:SrcPacketIDPos],cycle_counter);
            $fclose(fd);
        end
    end


`endif
`ifdef SINGLECAST
    reg [DataWidth-1:0] data[DataSize-1:0];
    //all the data share the same path, so each data will use all the entry
    reg [7:0] data_ptr;
    reg [IndexWidth-1:0] table_index;


    assign inject_receive_local=inject_local[DataWidth-1];

    assign inject_local=(data_ptr>=DataSize)?0:{data[data_ptr][DataWidth-1:IndexPos+IndexWidth],table_index,data[data_ptr][IndexPos-1:0]};
    
    always@(posedge clk) begin
        if(rst) begin
            table_index<=0;
            data_ptr<=0;
        end
        else if(routing_table[table_index+1][RoutingTableWidth-1]&&inject_receive_local) begin
            if(InjectSlotAvail_local) begin
                table_index<=table_index+1;
                data_ptr<=data_ptr;
                fd=$fopen("dump.txt","a");
                if(fd)
                    $display("file: dump.txt open successfully\n");
                else
                    $display("file open failed\n");
                $strobe("Displaying in %m\t");
                $strobe("reduction packet\t");
                $strobe("data from (%d, %d, %d) whose id #%d is injected into the network at cycle %d",XCoord,YCoord,ZCoord,data_ptr,cycle_counter);
                //format [src.x] [src.y] [src.z] [id] [time] [packet type]
                $fdisplay(fd,"Departuring: \n %d %d %d %d %d 10",XCoord,YCoord,ZCoord,data_ptr,cycle_counter);
                $fclose(fd);

            end
            else begin
                table_index<=table_index;
                data_ptr<=data_ptr;
            end
        end
        else begin
            table_index<=0;
            if(data[data_ptr][DataWidth-1]) begin
                data_ptr<=data_ptr+1;
            end
            else
                data_ptr<=data_ptr;
        end
    end
    assign EjectSlotAvail_local=1;
    always@(posedge clk) begin
        eject_local_reg<=eject_local;
    end
    always@(posedge clk) begin
        if(eject_send_local && EjectSlotAvail_local) begin
            fd=$fopen("dump.txt","a");
            $strobe("Displaying in %m\t");
            $strobe("singcast packet\t");
            $strobe("packet arrives from (%d,%d,%d) whose id is %d at cycle #%d\n",eject_local_reg[SrcXCoordPos+CoordWidth-1:SrcXCoordPos],eject_local_reg[SrcYCoordPos+CoordWidth-1:SrcYCoordPos],eject_local_reg[SrcZCoordPos+CoordWidth-1:SrcZCoordPos],eject_local_reg[SrcPacketIDPos+7:SrcPacketIDPos],cycle_counter);
            $fdisplay(fd,"Arriving\t");
            //format [src.x] [src.y] [src.z] [dst.x] [dst.y] [dst.z] [id] [time] [packet type]
            $fdisplay(fd,"%d %d %d %d %d %d %d %d 8",eject_local[SrcXCoordPos+CoordWidth-1:SrcXCoordPos],eject_local[SrcYCoordPos+CoordWidth-1:SrcYCoordPos],eject_local[SrcZCoordPos+CoordWidth-1:SrcZCoordPos],X,Y,Z,eject_local[SrcPacketIDPos+7:SrcPacketIDPos],cycle_counter);
            $fclose(fd);
        end
    end


    
`endif


    
    assign XCoord=X;
    assign YCoord=Y;
    assign ZCoord=Z;
            
                
endmodule

    

	 

    
    
