`timescale 1ns / 1ps

module tb_BCDCounter();

parameter DWL = 4;
parameter ClockPeriod = 10;
reg CLK, ENABLE, LOAD, UP, CLR;
reg [DWL-1:0] D;
wire CO;
wire [DWL-1:0] Q;

BCDCounter #(.DWL(DWL)) 
           DUT (.CLK(CLK), .ENABLE(ENABLE), .LOAD(LOAD), .UP(UP), .CLR(CLR), 
                .D(D), .CO(CO), .Q(Q));

    initial begin : ClockGenerator
        CLK = 1'b0;
        forever #(ClockPeriod / 2) CLK = ~CLK;
    end
    
    initial begin : TestVectorGenerator
        @(posedge CLK) CLR = 0;
        @(posedge CLK) D = 4'b0010;
        @(posedge CLK) LOAD = 1; ENABLE = 1;
        repeat (7) begin
            @(posedge CLK) LOAD = 0; ENABLE = 1; UP = 1; 
        end
        repeat (9) begin
            @(posedge CLK) LOAD = 0; ENABLE = 1; UP = 0;
        end
        @(posedge CLK) CLR = 1;
        @(posedge CLK); @(posedge CLK);
        $finish;
    end

endmodule
