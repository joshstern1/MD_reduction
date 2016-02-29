//Purpose: general-purpose FIFO
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 9th 2015
//

module FIFO
#(
    parameter FIFO_depth=8,
    parameter FIFO_width=64
)
(
    input clk,
    input rst,
    input [FIFO_width-1:0] in,
    input consume,//read enabling to out port from FIFO
    input produce,//write enabling to in port to FIFO 
    output [FIFO_width-1:0] out,
    output full,
    output empty
//    output reg [FIFO_depth-1:0] util
);
	wire[FIFO_depth-1:0] head_next;
	wire[FIFO_depth-1:0] tail_next;
	reg[FIFO_depth-1:0] head;
	reg[FIFO_depth-1:0] tail;
	reg[FIFO_depth-1:0] util_reg;
	reg[FIFO_width-1:0] fifo[FIFO_depth-1:0];
    

	integer i;
	
	assign empty=(head==tail);
	assign full=(tail==FIFO_depth-1)?(head==0):(head==tail+1);
	assign head_next=(head==FIFO_depth-1)?0:head+1;
	assign tail_next=(tail==FIFO_depth-1)?0:tail+1;

	
	assign out=fifo[head];

/*    always@(*)
    begin
        if(tail>=head)
            util=tail-head;
        else
            util=tail-head+FIFO_depth;
    end*/

	always@(posedge clk)
		begin
		if(rst)
			begin
			head<={FIFO_depth{1'b0}};
			tail<={FIFO_depth{1'b0}};
			for(i=0;i<FIFO_depth;i=i+1)
				begin
				fifo[i]<=0;
			end
		end
		else
			begin
			if(empty)
				begin
				if(produce)
					begin
					fifo[tail]<=in;
					tail<=tail_next;
				end
				end
			else if(full)
				begin
				if(consume)
					begin
					fifo[head]<=0;
					head<=head_next;
				end
				end
			else //neither full nor empty
				begin
				if(consume&&produce)
					begin
					fifo[head]<=0;
					head<=head_next;
					fifo[tail]<=in;
					tail<=tail_next;
				end
				else if(consume&&(~produce))
					begin
					fifo[head]<=0;
					head<=head_next;
				end
				else if((~consume)&&produce)
					begin
					fifo[tail]<=in;
					tail<=tail_next;
				end
			end
		end
	end
	
endmodule
				
					
				
			
			
			
			
