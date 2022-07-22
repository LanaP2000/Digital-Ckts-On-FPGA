`timescale 1ns / 1ps

module SevenSegmentDisplay #(parameter DWL = 8)
                            (input CLK,
                             input [DWL-5:0] In0, In1, In2, In3,
                             output reg [DWL-5:0] Anode,
                             output reg [DWL-2:0] Segment);

wire [DWL-2:0] Segment0, Segment1, Segment2, Segment3;
reg [DWL+4:0] InternalCLK = 0;
reg [DWL-7:0] state = 0;
 
Decoder #(.DWL(DWL))         
        UUT0 (.BCD(In0), .Segment(Segment0));

Decoder #(.DWL(DWL))         
        UUT1 (.BCD(In1), .Segment(Segment1));

Decoder #(.DWL(DWL)) 
        UUT2 (.BCD(In2), .Segment(Segment2));

Decoder #(.DWL(DWL)) 
        UUT3 (.BCD(In3), .Segment(Segment3));
        

    always @ (posedge CLK) begin
        InternalCLK <= InternalCLK + 1;
    end    
    
    always @ (posedge InternalCLK) begin
        case (state)
            0: begin
                Segment <= Segment0;
                Anode <= 4'b1110;
                state <= 2'b01;
            end
            1: begin
                Segment <= Segment1;
                Anode <= 4'b1101;
                state <= 2'b10;
            end
            2: begin
                Segment <= Segment2;
                Anode <= 4'b1110;
                state <= 2'b11;
            end
            3: begin
                Segment <= Segment3;
                Anode <= 4'b0111;
                state <= 2'b00;
            end
        endcase
    end
    
endmodule
