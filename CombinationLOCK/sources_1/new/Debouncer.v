`timescale 1ns / 1ps

module Debouncer (input CLK,
                  input Button,
                  output PULSE);
    
reg [17:0] counter = 18'b0;
reg CLOCK = 0; // 100 MHz
reg Q1, Q2, Q3, Q4, Q5 = 0;
reg D1, D2 = 0;
wire PB_HIGH;
    
    always @ (posedge CLK) begin
        counter <= (counter == 499999) ? 0 : (counter + 1);
        CLOCK <= (counter == 499999) ? ~CLOCK : CLOCK;
    end
    
    always @ (posedge CLOCK) begin
        Q1 <= Button;
        Q2 <= Q1;
        Q3 <= Q2;
        Q4 <= Q3;
        Q5 <= Q4;
    end
    
    assign PB_HIGH = Q1 & Q2 & Q3 & Q4 & Q5;
    
    always @ (posedge CLOCK) begin
        D1 <= PB_HIGH;
        D2 <= D1;
    end
    
    assign PULSE = D1 & (~D2);
    
endmodule
