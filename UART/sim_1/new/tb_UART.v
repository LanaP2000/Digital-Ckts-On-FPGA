`timescale 1ns / 1ps

module tb_UART();

parameter DWL = 8;
parameter ClockPeriod = 10;
reg CLK, RST;
reg Rx;
wire Tx;

UART #(.DWL(DWL))
     DUT (.CLK(CLK), .RST(RST), .Rx(Rx), .Tx(Tx));
     
    initial begin : ClockGenerator
        CLK = 1'b0;
        forever #(ClockPeriod / 2) CLK = ~CLK;
    end
    
    initial begin : TestVectorGenerator
        RST = 1'b1; 
        @(posedge CLK) RST = 1'b0;
        Rx = 1'b1;
        forever #(92553) Rx = ~Rx;
    end

endmodule
