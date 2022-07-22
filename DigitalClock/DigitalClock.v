`timescale 1ns / 1ps

module DigitalClock #(parameter DWL = 8)
                     (input CLK, CLR,
                      input [DWL-7:0] Mode,
                      input minUP, hourUP,
                      output [DWL-2:0] Segment,
                      output [DWL-5:0] Anode,
                      output ALARM);

wire minsUP, hoursUP;
wire [DWL-5:0] Minute, Minute_TEN, Hour, Hour_TEN;
    
ClockSystem         #(.DWL(DWL)) 
                    UUT0 (.CLK(CLK), .CLR(CLR), .Mode(Mode), .minUP(minsUP), .hourUP(hoursUP), 
                          .Hours_LSB(Hour),     .Minutes_LSB(Minute),
                          .Hours_MSB(Hour_TEN), .Minutes_MSB(Minute_TEN),
                          .ALARM(ALARM));

ButtonDebouncer     UUT1 (.CLK(CLK), .Button(minUP), .DebouncedButton(minsUP));

ButtonDebouncer     UUT2 (.CLK(CLK), .Button(hourUP), .DebouncedButton(hoursUP));

SevenSegmentDisplay #(.DWL(DWL)) 
                    UUT3 (.CLK(CLK), .In0(Minute), .In1(Minute_TEN), .In2(Hour), .In3(Hour_TEN), 
                          .Anode(Anode), .Segment(Segment));  

    
endmodule
