`timescale 1ns / 1ps

module SevenSegmentDisplay #(parameter DWL = 8)
                            (input CLK,
                             input [DWL-6:0] Select,
                             input [DWL-5:0] Number,
                             output reg [DWL-5:0] Anode,
                             output reg [DWL-1:0] Cathode);
    
reg [DWL-1:0] ssd0, ssd1, ssd2, ssd3;
reg ssdCLK; // 500 MHz
reg [DWL+1:0] counter;
reg [DWL-7:0] selector;

localparam ClockPeriod = 100000;

localparam L     = 8'b11110001;
localparam O     = 8'b10000001;
localparam C     = 8'b10110001;
localparam k     = 8'b11111000;
localparam P     = 8'b10011000;
localparam A     = 8'b10001000;
localparam S     = 8'b10100100;
localparam F     = 8'b10111000;
localparam I     = 8'b11111001;
localparam PRIME = 8'b11111110;
localparam OFF   = 8'b11111111;

    always @ (posedge ssdCLK) begin
        counter <= (counter == ClockPeriod - 1) ? 0 : (counter + 1);
        ssdCLK  <= (counter == ClockPeriod - 1) ? ~ssdCLK : ssdCLK;
    end
    
    always @ (posedge ssdCLK) begin
        selector <= selector + 1;
    end
    
    always @ (*) begin
        case (selector)
            2'b00:
                Anode = 4'b1110; // AN0
            2'b01:
                Anode = 4'b1101; // AN1
            2'b10:
                Anode = 4'b1011; // AN2
            2'b11:
                Anode = 4'b0111; // AN3
        endcase
    end
    
    always @ (*) begin
        case (selector)
            2'b00:
                Cathode = ssd0; 
            2'b01:
                Cathode = ssd1;
            2'b10:
                Cathode = ssd2; 
            2'b11:
                Cathode = ssd3; 
        endcase
    end
    
    always @ (*) begin
        case (Select)
            3'b000:
                ssd0 = k;
            3'b001:
                ssd0 = PRIME;
            3'b010:
                ssd0 = PRIME;
            3'b011:
                ssd0 = PRIME;
            3'b100:
                ssd0 = ssd(Number);
            3'b101:
                ssd0 = PRIME;
            3'b110:
                ssd0 = S;
            3'b111:
                ssd0 = L;
            default:
                ssd0 = OFF;
        endcase
    end
    
    always @ (*) begin
        case (Select)
            3'b000:
                ssd1 = C;
            3'b001:
                ssd1 = PRIME;
            3'b010:
                ssd1 = PRIME;
            3'b011:
                ssd1 = ssd(Number);
            3'b100:
                ssd1 = PRIME;
            3'b101:
                ssd1 = PRIME;
            3'b110:
                ssd1 = S;
            3'b111:
                ssd1 = I;
            default:
                ssd1 = OFF;
        endcase
    end
    
    always @ (*) begin
        case (Select)
            3'b000:
                ssd2 = O;
            3'b001:
                ssd2 = PRIME;
            3'b010:
                ssd2 = ssd(Number);
            3'b011:
                ssd2 = PRIME;
            3'b100:
                ssd2 = PRIME;
            3'b101:
                ssd2 = PRIME;
            3'b110:
                ssd2 = A;
            3'b111:
                ssd2 = A;
            default:
                ssd2 = OFF;
        endcase
    end
    
    always @ (*) begin
        case (Select)
            3'b000:
                ssd3 = L;
            3'b001:
                ssd3 = ssd(Number);
            3'b010:
                ssd3 = PRIME;
            3'b011:
                ssd3 = PRIME;
            3'b100:
                ssd3 = PRIME;
            3'b101:
                ssd3 = PRIME;
            3'b110:
                ssd3 = P;
            3'b111:
                ssd3 = F;
            default:
                ssd3 = OFF;
        endcase
    end
    
    function [DWL-1:0] ssd;
        input [DWL-5:0] binary; begin
            case (binary)
                4'b0000:
                    ssd = 8'b10000001;
                4'b0001:
                    ssd = 8'b11001111;
                4'b0010:
                    ssd = 8'b10010010;
                4'b0011:
                    ssd = 8'b10000110;
                4'b0100:
                    ssd = 8'b11001100;
                4'b0101:
                    ssd = 8'b10100100;
                4'b0110:
                    ssd = 8'b10100000;
                4'b0111:
                    ssd = 8'b10001111;
                4'b1000:
                    ssd = 8'b10000000;
                4'b1001:
                    ssd = 8'b10000100;
                4'b1010:
                    ssd = 8'b10001000;
                4'b1011:
                    ssd = 8'b11100000;
                4'b1100:
                    ssd = 8'b10110001;
                4'b1101:
                    ssd = 8'b11000010;
                4'b1110:
                    ssd = 8'b10110000;
                4'b1111:
                    ssd = 8'b10111000;
            endcase
        end
    endfunction
        
    
endmodule
