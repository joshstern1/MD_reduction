//Purpose: simulate the Multigigabit transceiver (MGT) of Altera Stratix V
//Author: Jiayi Sheng
//Organization: CAAD lab @ Boston University
//Start date: Dec 9th 2015
//

module internode_link
#(
    parameter WIDTH=64,
    parameter DELAY=100,
    parameter x=0,
    parameter y=0,
    parameter z=0,
    parameter dir=3'b000//direction of this MGT 000 for x+, 001 for x-, 010 for y+, 011 for y-, 100 for z+, 101 for z-
)
(
    input rst;
    //tx signals
    input tx_clk, // this is the clock driving the writing side of the transmitter
    input [WIDTH-1:0] tx_par_data,
    output [WIDTH-1:0] tx_ser_data,//when simulation, this is the fake version of serial data, so it has the same width as the parallel data
    output tx_ready,//only when this signal is high, the tx_par_data can be transmitted

    //rx signals
    input rx_clk, // this is the clock driving the reading side of the receiver, usually in a unified design, it is the same as the tx_clk
    output [WIDTH-1:0] rx_par_data,
    input [WIDTH-1:0] rx_ser_data,//when simulation, this is the fake version of serial data, so it has the same width as the parallel data
    output rx_ready
)   
    reg [WIDTH-1:0] shift_reg_tx[DELAY/2-1:0];//half of the delay is consumed at the tx side, shift_reg_tx[0] connect to the tx_par_data
    reg [WIDTH-1:0] shift_reg_rx[DELAY/2-1:0];//the other half of the delay is consumed at the rx side, shift_reg_rx[0] connects to the rx_par_data

    assign tx_ready=1;
    assign rx_ready=1;//for simulation, the tx and rx ready signals both remain high
    
    integer i=0;
    always@(posedge tx_clk) begin
        if(rst) begin
            for(i=0;i<DELAY/2-1;i=i+1) begin
                shift_reg_tx[i]<=0;
            end
        end
        else begin
            shift_reg_tx[0]<=tx_par_data;
            for(i=0;i<DELAY/2-2;i=i+1) begin
                shift_reg_tx[i+1]<=shift_reg_tx[i];
            end
        end
    end
    assign tx_ser_data=shift_reg_tx[DElAY/2-1];

    always@(posedge rx_clk) begin
        if(rst) begin
            for(i=0;i<DELAY/2-1;i=i+1) begin
                shift_reg_rx[i]<=0;
            end
        end
        else begin
            shift_reg_rx[DELAY/2-1]<=rx_ser_data;
            for(i=DELAY/2-2;i>=0;i=i-1) begin
                shift_reg_rx[i]<=shift_reg_rx[i+1];
            end
        end
    end
    assign rx_par_data<=shift_reg_rx[0];
endmodule
    

    


    
