//Purpose: general-purpose buffer more realistic fifo
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Feb 10th 2015
//

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
  	
    wire[buffer_depth-1:0] head_next;
	wire[buffer_depth-1:0] tail_next;
	
    reg[buffer_depth-1:0] head;
	reg[buffer_depth-1:0] tail;

	reg[buffer_width-1:0] fifo[FIFO_depth-1:0];  

    assign empty=(head==tail);
	assign full=(tail==FIFO_depth-1)?(head==0):(head==tail+1);
	assign head_next=(head==FIFO_depth-1)?0:head+1;
	assign tail_next=(tail==FIFO_depth-1)?0:tail+1;

    always@(posedge clk) begin
        if(consume) begin
            if(empty)
                out<=0;
            else
                out<=fifo[head];
        end
    end

    always@(posedge clk) begin
        if(produce && ~full) begin
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
        
