//Purpose: general-purpose buffer more realistic fifo
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Feb 10th 2015
//
`define SIM

module buffer
#(
    parameter buffer_depth=8,
    parameter buffer_width=64
)(
    input clk,
    input rst,
    input [buffer_width-1:0] in,
    input produce,
    input consume,
    output full,
    output empty,
    output reg [buffer_width-1:0] out
);
  	
    integer i;

    wire[buffer_depth-1:0] head_next;
	wire[buffer_depth-1:0] tail_next;
	
    reg[buffer_depth-1:0] head;
	reg[buffer_depth-1:0] tail;

	reg[buffer_width-1:0] fifo[buffer_depth-1:0];  
    
`ifdef SIM
    parameter sample_cycle=64;
    reg[15:0] sample_counter;
    integer fd;
    always@(posedge clk) begin
        if(rst) begin
            sample_counter<=0;
        end
        else begin
            sample_counter<=(sample_counter==sample_cycle-1)?0:sample_counter+1;
        end
    end

    always@(posedge clk) begin
        if(sample_counter==sample_cycle-1) begin
            fd=$fopen("buffer_size.txt","a");
            if(fd) begin
                $display("buffer_size.txt open successfully\n");
            end
            else begin
                $display("file open failed\n");
            end
            $strobe("Displaying in %m ");
            $strobe("buffer utilization is: ");
            $strobe("tail is %d, head is %d, util is %d ",tail, head,((tail>=head)?(tail-head):(tail-head+buffer_depth)));
            $fdisplay(fd,"%d %d",((tail>=head)?(tail-head):(tail-head+buffer_depth)),buffer_depth);
            $fclose(fd);
        end
    end


`endif
    

            

    


    


    assign empty=(head==tail);
	assign full=(tail==buffer_depth-1)?(head==0):(head==tail+1);
	assign head_next=(head==buffer_depth-1)?0:head+1;
	assign tail_next=(tail==buffer_depth-1)?0:tail+1;

    always@(posedge clk) begin
        if(consume) begin
            if(empty)
                out<=0;
            else
                out<=fifo[head];
        end
    end

    always@(posedge clk) begin
        if(rst) begin
            for(i=0;i<buffer_depth;i=i+1) begin
                fifo[i]<=0;
            end
        end
        else if(produce && ~full) begin
            fifo[tail]<=in;
        end
    end

    always@(posedge clk) begin
        if(rst) begin
            tail<=0;
        end
        else begin
            if(produce && ~full)
                tail<=tail_next;
        end
    end

    always@(posedge clk) begin
        if(rst) begin
            head<=0;
        end
        else begin
            if(consume && ~empty)
                head<=head_next;
        end
    end
endmodule
        
