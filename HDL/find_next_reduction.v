//Purpose: find the index of the next available inputs
//find the index of next 1 in the seven_fifo_avail_bit from the position of cur_idx
///Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Mar 2nd 2015
//
//
module find_next_reduction(
    input [6:0] seven_fifo_avail_bit,
    input [2:0] cur_idx, //cur_idx must be one of 0,1,2,3,4,5,6
    output reg [2:0] next_idx
);
    reg [6:0] shift_to_cur_idx; //shift the cur_idx to the right most bit
    always@(*) begin
        if(cur_idx==3'd0) begin
            shift_to_cur_idx=seven_fifo_avail_bit;
        end
        else if(cur_idx==3'd1) begin
            shift_to_cur_idx={seven_fifo_avail_bit[0],seven_fifo_avail_bit[6:1]};
        end
        else if(cur_idx==3'd2) begin
            shift_to_cur_idx={seven_fifo_avail_bit[1:0],seven_fifo_avail_bit[6:2]};
        end
        else if(cur_idx==3'd3) begin
            shift_to_cur_idx={seven_fifo_avail_bit[2:0],seven_fifo_avail_bit[6:3]};
        end
        else if(cur_idx==3'd4) begin
            shift_to_cur_idx={seven_fifo_avail_bit[3:0],seven_fifo_avail_bit[6:4]};
        end
        else if(cur_idx==3'd5) begin
            shift_to_cur_idx={seven_fifo_avail_bit[4:0],seven_fifo_avail_bit[6:5]};
        end
        else if(cur_idx==3'd6) begin
            shift_to_cur_idx={seven_fifo_avail_bit[5:0],seven_fifo_avail_bit[6]};
        end
        else begin
            shift_to_cur_idx=seven_fifo_avail_bit;
        end
    end


    always@(*) begin
        if(cur_idx!=7) begin 
            if(shift_to_cur_idx[1]) begin
                next_idx=(cur_idx>5)?cur_idx-6:cur_idx+1;
            end
            else if(shift_to_cur_idx[2]) begin
                next_idx=(cur_idx>4)?cur_idx-5:cur_idx+2;

            end
            else if(shift_to_cur_idx[3]) begin
                next_idx=(cur_idx>3)?cur_idx-4:cur_idx+3;
            end
            else if(shift_to_cur_idx[4]) begin
                next_idx=(cur_idx>2)?cur_idx-3:cur_idx+4;
            end
            else if(shift_to_cur_idx[5]) begin
                next_idx=(cur_idx>1)?cur_idx-2:cur_idx+5;

            end
            else if(shift_to_cur_idx[6]) begin
                next_idx=(cur_idx>0)?cur_idx-1:cur_idx+6;
            end
            else begin
                next_idx=7;
            end
        end
        else begin// this means the the shift_to_cur_idx is the same as the seven_fifo_avail_bit
            if(shift_to_cur_idx[0]) begin
                next_idx=0;
            end
            else if(shift_to_cur_idx[1]) begin
                next_idx=1;
            end
            else if(shift_to_cur_idx[2]) begin
                next_idx=2;
            end
            else if(shift_to_cur_idx[3]) begin
                next_idx=3;
            end
            else if(shift_to_cur_idx[4]) begin
                next_idx=4;
            end
            else if(shift_to_cur_idx[5]) begin
                next_idx=5;
            end
            else if(shift_to_cur_idx[6]) begin
                next_idx=6;
            end
            else begin
                next_idx=7;
            end
        end
    end


    

endmodule
