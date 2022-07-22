`timescale 1ns / 1ps

module Datapath #(parameter DWL = 8)
                 (input CLK, RST,
                  input [DWL-5:0] Number,
                  input Validate,
                  input ShiftA, ShiftB,
                  input RSTA,
                  output Pass,
                  output Reverse);
                  
reg [(DWL*2)-1:0] A, B;
wire [(DWL*2)-1:0] RevB;

    always @ (posedge CLK) begin
        if (RSTA)
            A <= 0;
        else if (ShiftA) begin
            if (Validate)
                A <= {A[11:0], Number};
        end
    end
    
    always @ (posedge CLK) begin
        if (RST)
            B <= 16'h1234;
        else if (ShiftB) begin
            if (Validate)
                B <= {B[11:0], Number};
        end
    end
    
    assign RevB = {B[3:0], B[7:4], B[11:8], B[15:12]};
    assign Pass = (A == B) ? 1'b1 : 1'b0;
    assign Reverse = (A == RevB) ? 1'b1 : 1'b0;            
                  
endmodule
