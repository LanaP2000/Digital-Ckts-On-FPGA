`timescale 1ns / 1ps

module Decoder #(parameter DWL = 8)
                (input [DWL-5:0] BCD,
                 output reg [DWL-2:0] Segment);
    
    always @ (*) begin
        case (BCD)
            0: Segment = 7'b0000001;
            1: Segment = 7'b1001111;
            2: Segment = 7'b0010010;
            3: Segment = 7'b0000110;
            4: Segment = 7'b1001100;
            5: Segment = 7'b0100100;
            6: Segment = 7'b0100000;
            7: Segment = 7'b0001111;
            8: Segment = 7'b0000000;
            9: Segment = 7'b0001100;
            default: 
                Segment = 7'b1111111;
        endcase
    end
    
endmodule
