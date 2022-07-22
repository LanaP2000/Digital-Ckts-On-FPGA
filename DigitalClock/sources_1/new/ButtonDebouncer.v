`timescale 1ns / 1ps

module ButtonDebouncer (input CLK,
                        input Button,
                        output reg DebouncedButton);
    
initial DebouncedButton = 1'b0;

localparam Limit = 1023;
reg [19:0] History = 12'd0;

    always @ (posedge CLK) begin
        History <= {History [18:0], Button};
        DebouncedButton <= (History == Limit) ? 1'b1 : 1'b0;
    end
    
endmodule
