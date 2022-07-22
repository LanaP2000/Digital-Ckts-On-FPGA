`timescale 1ns / 1ps

module System #(parameter DWL = 8)
               (input [DWL-3:0] Minutes,
                input [DWL-4:0] Hours,
                output reg [DWL-5:0] Hours_LSB,
                output reg [DWL-5:0] Minutes_LSB,
                output reg [DWL-5:0] Hours_MSB,
                output reg [DWL-5:0] Minutes_MSB);
    
initial Hours_LSB = 4'd0;
initial Minutes_LSB = 4'd0;
initial Hours_MSB = 4'd0;
initial Minutes_MSB = 4'd0;

    always @ (*) begin
        Hours_LSB = Hours % 10;
        Minutes_LSB = Minutes % 10;
        Hours_MSB = Hours / 10;
        Minutes_MSB = Minutes / 10;
    end
    
endmodule
