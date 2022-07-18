`timescale 1ns / 1ps

module tb_Decoder();

parameter IWL = 4, OWL = 8;
reg [IWL-1:0] BCD;
wire [OWL-1:0] SW;
integer i;

Decoder #(.IWL(IWL), .OWL(OWL)) DUT (.BCD(BCD), .SW(SW));

    initial begin : TestVectorGenerator
        BCD = 0;
        for (i = 0; i < 15; i = i + 1)
            #5 BCD = i;
        #5 $finish;
    end

endmodule
