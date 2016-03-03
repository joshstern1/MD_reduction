//Purpose: special mux of crossbar-based switch for local port which can eject more than one packet per cycle
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Mar 2nd 2015
//
//
////reduction table entry format
/*
* at most five fan-in for 3D-torus network.
for each fanin, format is as below:
|3-bit expect counter|3-bit arrival bookkeeping counter|dst   |table index| weight accumulator| payload accumulator|
|3 bits              | 3 bits                          |4 bits|16 bits    | 8 bits            | 128 bits           | 162 bits in total
* */

module mux_local
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
    input clk,
    input rst,
    input [DataWidth-1:0] in_local,
    input [DataWidth-1:0] in_yneg,
    input [DataWidth-1:0] in_ypos,
    input [DataWidth-1:0] in_xpos,
    input [DataWidth-1:0] in_xneg,
    input [DataWidth-1:0] in_zpos,
    input [DataWidth-1:0] in_zneg,
    input in_pipeline_stall_local,
    input in_pipeline_stall_yneg,
    input in_pipeline_stall_ypos,
    input in_pipeline_stall_xpos,
    input in_pipeline_stall_xneg,
    input in_pipeline_stall_zpos,
    input in_pipeline_stall_zneg,
    output send,
    output in_avail_local,
    output in_avail_yneg,
    output in_avail_ypos,
    output in_avail_xpos,
    output in_avail_xneg,
    output in_avail_zpos,
    output in_avail_zneg,
    output reg [DataWidth-1:0] out_local,// the o
    output reg [DataWidth-1:0] out_yneg,
    output reg [DataWidth-1:0] out_ypos,
    output reg [DataWidth-1:0] out_xpos,
    output reg [DataWidth-1:0] out_xneg,
    output reg [DataWidth-1:0] out_zpos,
    output reg [DataWidth-1:0] out_zneg,
    output reg [DataWidth-1:0] reduction_out
);

    wire [DataWidth-1:0] in[6:0];
    wire in_pipeline_stall[6:0];
    wire in_avail[6:0];

    wire FIFO_empty[6:0];
    wire FIFO_full[6:0];

    reg FIFO_consume[6:0];

    wire [DataWidth-1:0] FIFO_out[6:0];

    wire [PriorityWidth-1:0] priority[6:0];

    wire [2:0] reduction_grant_index;

    wire [2:0] reduction_grant_index_next;

//    wire [2:0] sel_index;
    reg [PriorityWidth-1:0] priority01; //the higher priority between the 0th port and 1st port
    reg [2:0] sel_index01;
    reg [PriorityWidth-1:0] priority23; //the higher priority between the 2nd and 3rd port
    reg [2:0] sel_index23;
    reg [PriorityWidth-1:0] priority45; //the higher priority between the 4th and 5th port
    reg [2:0] sel_index45;
    reg [PriorityWidth-1:0] priority0123; //the highest priority among the 0th port, 1st port, 2nd port and 3rd port
    reg [2:0] sel_index0123;
    reg [PriorityWidth-1:0] priority456; //the higher priority among 4th port, 5th port and 6th port
    reg [2:0] sel_index456;
    reg [PriorityWidth-1:0] priority0123456; //the highest priority among 0,1,2,3,4,5,6 ports
    reg [2:0] sel_index0123456;

    reg [DataWidth-1:0] sel_data;//the outputs from the buffers that has the highest priority
    reg [DataWidth-1:0] sel_data_RR[7];

    reg pipeline_stall;

    reg[ReductionTableWidth-1:0] reduction_table[ReductionTablesize-1:0];

    wire is_reduction;
    wire reduction_ready;

    wire [DataWidth-1:0] reduction_out;

    reg [ReductionTableWidth-1:0] reduction_table_entry;
    wire [ReductionTableWidth-1:0] reduction_table_entry_next;

    wire [2:0] next_counter;


    //this pipeline has severa stages
    //1st stage: pick the highest priority data from seven FIFOs (FR) (fifo read) 
    //2nd stage: read the reduction table (if the data is the reduction data)  (RR) (reduction read)
    //3rd stage: either write back to the reduction table or send to the output (WB)
    

    parameter InterSwitchBufferDepth=4;

    

    assign in_pipeline_stall[0]=in_pipeline_stall_local;
    assign in_pipeline_stall[1]=in_pipeline_stall_yneg;
    assign in_pipeline_stall[2]=in_pipeline_stall_ypos;
    assign in_pipeline_stall[3]=in_pipeline_stall_xpos;
    assign in_pipeline_stall[4]=in_pipeline_stall_xneg;
    assign in_pipeline_stall[5]=in_pipeline_stall_zpos;
    assign in_pipeline_stall[6]=in_pipeline_stall_zneg;

    assign in[0]=in_local;
    assign in[1]=in_yneg;
    assign in[2]=in_ypos;
    assign in[3]=in_xpos;
    assign in[4]=in_xneg;
    assign in[5]=in_zpos;
    assign in[6]=in_zneg;

    assign in_avail_local=in_avail[0];
    assign in_avail_yneg=in_avail[1];
    assign in_avail_ypos=in_avail[2];
    assign in_avail_xpos=in_avail[3];
    assign in_avail_xneg=in_avail[4];
    assign in_avail_zpos=in_avail[5];
    assign in_avail_zneg=in_avail[6];

    assign in_avail[0]=~FIFO_full[0];
    assign in_avail[1]=~FIFO_full[1];
    assign in_avail[2]=~FIFO_full[2];
    assign in_avail[3]=~FIFO_full[3];
    assign in_avail[4]=~FIFO_full[4];
    assign in_avail[5]=~FIFO_full[5];
    assign in_avail[6]=~FIFO_full[6];

//first stage:

    FIFO#(
        .FIFO_depth(InterSwitchBufferDepth),
        .FIFO_width(DataWidth)
    )FIFO_local
    (
        .clk(clk),
        .rst(rst),
        .in(in[0]),
        .produce(~in_pipeline_stall[0] && in[0][DataWidth-1]),
        .consume(FIFO_consume[0]),
        .full(FIFO_full[0]),
        .empty(FIFO_empty[0]),
        .out(FIFO_out[0])
    );

    FIFO#(
        .FIFO_depth(InterSwitchBufferDepth),
        .FIFO_width(DataWidth)
    )
    FIFO_yneg(
        .clk(clk),
        .rst(rst),
        .in(in[1]),
        .produce(~in_pipeline_stall[1] && in[1][DataWidth-1]),
        .consume(FIFO_consume[1]),
        .full(FIFO_full[1]),
        .empty(FIFO_empty[1]),
        .out(FIFO_out[1])
       
    );

    FIFO#(
        .FIFO_depth(InterSwitchBufferDepth),
        .FIFO_width(DataWidth)
    )
    FIFO_ypos(
        .clk(clk),
        .rst(rst),
        .in(in[2]),
        .produce(~in_pipeline_stall[2] && in[2][DataWidth-1]),
        .consume(FIFO_consume[2]),
        .full(FIFO_full[2]),
        .empty(FIFO_empty[2]),
        .out(FIFO_out[2])
       
    );
 
    FIFO#(
        .FIFO_depth(InterSwitchBufferDepth),
        .FIFO_width(DataWidth)
    )
    FIFO_xpos(
        .clk(clk),
        .rst(rst),
        .in(in[3]),
        .produce(~in_pipeline_stall[3] && in[3][DataWidth-1]),
        .consume(FIFO_consume[3]),
        .full(FIFO_full[3]),
        .empty(FIFO_empty[3]),
        .out(FIFO_out[3])
       
    );
 
    FIFO#(
        .FIFO_depth(InterSwitchBufferDepth),
        .FIFO_width(DataWidth)
    )
    FIFO_xneg(
        .clk(clk),
        .rst(rst),
        .in(in[4]),
        .produce(~in_pipeline_stall[4] && in[4][DataWidth-1]),
        .consume(FIFO_consume[4]),
        .full(FIFO_full[4]),
        .empty(FIFO_empty[4]),
        .out(FIFO_out[4])
       
    );
 
    FIFO#(
        .FIFO_depth(InterSwitchBufferDepth),
        .FIFO_width(DataWidth)
    )
    FIFO_zpos(
        .clk(clk),
        .rst(rst),
        .in(in[5]),
        .produce(~in_pipeline_stall[5] && in[5][DataWidth-1]),
        .consume(FIFO_consume[5]),
        .full(FIFO_full[5]),
        .empty(FIFO_empty[5]),
        .out(FIFO_out[5])
       
    );

    FIFO#(
        .FIFO_depth(InterSwitchBufferDepth),
        .FIFO_width(DataWidth)
    )
    FIFO_zneg(
        .clk(clk),
        .rst(rst),
        .in(in[6]),
        .produce(~in_pipeline_stall[6] && in[6][DataWidth-1]),
        .consume(FIFO_consume[6]),
        .full(FIFO_full[6]),
        .empty(FIFO_empty[6]),
        .out(FIFO_out[6])
    );

    always@(*) begin
        if(~FIFO_empty[0] && FIFO_out[0][ReductionBitPos]) begin
            FIFO_consume[0]=1;
        end
        else if(FIFO_out[0][ReductionBitPos] && reduction_grant_index==0) begin
            FIFO_consume[0]=1;
        end
        else begin
            FIFO_consume[0]=0;
        end
    end
    always@(*) begin
        if(~FIFO_empty[1] && FIFO_out[1][ReductionBitPos]) begin
            FIFO_consume[1]=1;
        end
        else if(FIFO_out[1][ReductionBitPos] && reduction_grant_index==1) begin
            FIFO_consume[1]=1;
        end
        else begin
            FIFO_consume[1]=0;
        end
    end
    always@(*) begin
        if(~FIFO_empty[2] && FIFO_out[2][ReductionBitPos]) begin
            FIFO_consume[2]=1;
        end
        else if(FIFO_out[2][ReductionBitPos] && reduction_grant_index==2) begin
            FIFO_consume[2]=1;
        end
        else begin
            FIFO_consume[2]=0;
        end
    end
    always@(*) begin
        if(~FIFO_empty[3] && FIFO_out[3][ReductionBitPos]) begin
            FIFO_consume[3]=1;
        end
        else if(FIFO_out[3][ReductionBitPos] && reduction_grant_index==3) begin
            FIFO_consume[3]=1;
        end
        else begin
            FIFO_consume[3]=0;
        end
    end
    always@(*) begin
        if(~FIFO_empty[4] && FIFO_out[4][ReductionBitPos]) begin
            FIFO_consume[4]=1;
        end
        else if(FIFO_out[4][ReductionBitPos] && reduction_grant_index==4) begin
            FIFO_consume[4]=1;
        end
        else begin
            FIFO_consume[4]=0;
        end
    end
    always@(*) begin
        if(~FIFO_empty[5] && FIFO_out[5][ReductionBitPos]) begin
            FIFO_consume[5]=1;
        end
        else if(FIFO_out[5][ReductionBitPos] && reduction_grant_index==5) begin
            FIFO_consume[5]=1;
        end
        else begin
            FIFO_consume[5]=0;
        end
    end
    always@(*) begin
        if(~FIFO_empty[6] && FIFO_out[6][ReductionBitPos]) begin
            FIFO_consume[6]=1;
        end
        else if(FIFO_out[6][ReductionBitPos] && reduction_grant_index==6) begin
            FIFO_consume[6]=1;
        end
        else begin
            FIFO_consume[6]=0;
        end
    end
    
    always@(posedge clk) begin
        reduction_grant_index<=reduction_grant_index_next;    
    end

    always(*) begin
        if(FIFO_out[0][ReductionBitPos]) begin
            if(reduction_grant_index~=0) begin
                reduction_grant_index_next=0;
            end
            else begin
                reduction_grant_index_next=7;
            end
        end
        else if(FIFO_out[1][ReductionBitPos]) begin
            if(reduction_grant_index~=1) begin
                reduction_grant_index_next=1;
            end
            else begin
                reduction_grant_index_next=7;
            end
        end
        else if(FIFO_out[2][ReductionBitPos]) begin
            if(reduction_grant_index~=2) begin
                reduction_grant_index_next=2;
            end
            else begin
                reduction_grant_index_next=7;
            end
        end
        else if(FIFO_out[3][ReductionBitPos]) begin
            if(reduction_grant_index~=3) begin
                reduction_grant_index_next=3;
            end
            else begin
                reduction_grant_index_next=7;
            end
        end
        else if(FIFO_out[4][ReductionBitPos]) begin
            if(reduction_grant_index~=4) begin
                reduction_grant_index_next=4;
            end
            else begin
                reduction_grant_index_next=7;
            end
        end
        else if(FIFO_out[5][ReductionBitPos]) begin
            if(reduction_grant_index~=5) begin
                reduction_grant_index_next=5;
            end
            else begin
                reduction_grant_index_next=7;
            end
        end
        else if(FIFO_out[6][ReductionBitPos]) begin
            if(reduction_grant_index~=6) begin
                reduction_grant_index_next=6;
            end
            else begin
                reduction_grant_index_next=7;
            end
        end
        else begin
            reduction_grant_index_next=7;
        end
    end
//second stage is usually doing two things, First is output those FIFO_outs that are not reduction packets, second is pick one FIFO_outs that is reduction packet
//
//
    always@(posedge clk) begin
        if(~FIFO_out[0][ReductionBitPos]) 
            out_local<=FIFO_out[0];
        else
            out_local<=0;
    end
    always@(posedge clk) begin
        if(~FIFO_out[1][ReductionBitPos]) 
            out_yneg<=FIFO_out[1];
        else
            out_yneg<=0;
    end
    always@(posedge clk) begin
        if(~FIFO_out[2][ReductionBitPos]) 
            out_ypos<=FIFO_out[2];
        else
            out_ypos<=0;
    end
    always@(posedge clk) begin
        if(~FIFO_out[3][ReductionBitPos]) 
            out_xpos<=FIFO_out[3];
        else
            out_xpos<=0;
    end
    always@(posedge clk) begin
        if(~FIFO_out[4][ReductionBitPos]) 
            out_xneg<=FIFO_out[4];
        else
            out_xneg<=0;
    end
    always@(posedge clk) begin
        if(~FIFO_out[5][ReductionBitPos]) 
            out_zpos<=FIFO_out[5];
        else
            out_zpos<=0;
    end
    always@(posedge clk) begin
        if(~FIFO_out[6][ReductionBitPos]) 
            out_zneg<=FIFO_out[6];
        else
            out_zneg<=0;
    end

    always@(posedge clk) begin
        if(reduction_grant_index!=7) begin
            reduction_out<=FIFO_out[reduction_grant_index];
        end
        else begin
            reduction_out<=0;
    






  

       

//second stage puts reduction table into a buffer which will read the reduction table entry if the packets is a reduction packet
    always@(posedge clk) begin
        sel_data_RR[0]<=FIFO_out[0];
        sel_data_RR[1]<=FIFO_out[1];
        sel_data_RR[2]<=FIFO_out[2];
        sel_data_RR[3]<=FIFO_out[3];
        sel_data_RR[4]<=FIFO_out[4];
        sel_data_RR[5]<=FIFO_out[5];
        sel_data_RR[6]<=FIFO_out[6];
    end

    
    assign is_reduction=sel_data[ReductionBitPos];



    
    

    


    always@(posedge clk) begin
        if(is_reduction) begin
            reduction_table_entry<=reduction_table[sel_data[IndexWidth+IndexPos-1:IndexPos]];
        end
    end

//third stage:
//
    

    assign next_counter=reduction_table_entry[158:156]+1;
    assign is_reduction_WB=sel_data_RR[ReductionBitPos];
    assign reduction_ready= sel_data_RR[ReductionBitPos] && (reduction_table_entry[ReductionTableWidth-1:ReductionTableWidth-3]==reduction_table_entry[ReductionTableWidth-4:ReductionTableWidth-6]+1);
    assign reduction_out={sel_data_RR[DataWidth-1:152],reduction_table_entry_next[135:128],reduction_table_entry_next[151:136],reduction_table_entry_next[127:0]};
     assign reduction_table_entry_next={reduction_table_entry[161:159],next_counter,reduction_table_entry[155:136],(reduction_table_entry[135:128]+sel_data_RR[WeightPos+WeightWidth-1:WeightPos]),(reduction_table_entry[PayloadLen-1:0]+sel_data_RR[PayloadLen-1:0])};


    always@(posedge clk) begin
        if(~is_reduction_WB) begin
            out<=sel_data_RR;
        end
        else if(reduction_ready) begin
            out<=reduction_out;
        end
        else begin
            out<=0;
        end
    end

    assign send=out[DataWidth-1];

    always@(posedge clk) begin
        if(is_reduction_WB) begin
            reduction_table[sel_data_RR[IndexWidth+IndexPos-1:IndexPos]]<=reduction_table_entry_next;
        end
    end
            


    





endmodule
        
        



    
    
    











        
    



