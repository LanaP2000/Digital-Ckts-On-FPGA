`timescale 1ns / 1ps

module Decoder #(parameter IWL = 4, OWL = 8)
                (input [IWL-1:0] BCD,
                 output reg [OWL-1:0] SW);
    
    always @ (*) begin
        case (BCD)
            0: SW = 7'b1000000;
            1: SW = 7'b1111001;
            2: SW = 7'b0100100;
            3: SW = 7'b0110000;
            4: SW = 7'b0011001;
            5: SW = 7'b0010010;
            6: SW = 7'b0000010;
            7: SW = 7'b1111000;
            8: SW = 7'b0000000;
            9: SW = 7'b0010000;
            default: 
                SW = 7'b1111111;
        endcase
    end
    
endmodule
