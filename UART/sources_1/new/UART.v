`timescale 1ns / 1ps

module UART #(parameter DWL  = 8)
             (input CLK, RST,
              input Rx,
              output Tx);

wire Tx_CLK, Rx_CLK, BUSY, rByte;
wire [DWL-1:0] FEEDBACK;
              
UART_Tx           #(.DWL(DWL)) 
                  UUT0 (.CLK(CLK), .RST(RST), .EN(Tx_CLK), .WE(rByte), .parallelData(FEEDBACK), .BUSY(BUSY), .serialData(Tx));      
        
UART_Rx           #(.DWL(DWL))
                  UUT1 (.CLK(CLK), .EN(Rx_CLK), .serialData(rByte), .BUSY(BUSY), .rByte(rByte), .rData(FEEDBACK));
              
BaudRateGenerator UUT2 (.CLK(CLK), .Tx_CLK(Tx_CLK), .Rx_CLK(Rx_CLK));
        
              
endmodule
