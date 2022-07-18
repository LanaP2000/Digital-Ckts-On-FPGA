`timescale 1ns / 1ps

module BCDCounter #(parameter DWL = 4)
                   (input CLK, ENABLE, LOAD, UP, CLR,
                    input [DWL-1:0] D,
                    output reg CO,
                    output reg [DWL-1:0] Q);
    
    always @ (posedge CLK) begin
        if (CLR)
            Q <= 0;
        else begin
            if (LOAD == 1 && ENABLE == 1)
                Q <= D;
            if (LOAD == 0 && ENABLE == 1 && UP == 1) 
                Q <= Q + 1;
            if (LOAD == 0 && ENABLE == 1 && UP == 0) 
                Q <= Q - 1;
        end
        if (Q == 4'b0 || Q == 4'b1001)
                CO <= 1;
            else
                CO <= 0;
    end
    
endmodule
