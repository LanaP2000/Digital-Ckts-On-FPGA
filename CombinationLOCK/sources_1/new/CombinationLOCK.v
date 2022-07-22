`timescale 1ns / 1ps

module CombinationLOCK #(parameter DWL = 8)
                        (input CLK, RST,
                         input Open_Close, // BTN_L
                         input Validate,   // BTN_R
                         input Change,     // BTN_C
                         input [DWL-5:0] Number, // SW[3], SW[2], SW[1], SW[0]
                         output [DWL-5:0] Anode,
                         output [DWL-1:0] Cathode,
                         output ALARM); // LED0
                         
wire RPulse, LPulse, CPulse;
wire ShiftA, ShiftB, RSTA, Pass, Reverse;
wire [DWL-6:0] Select;

Debouncer           UUT0 (.CLK(CLK), .Button(Open_Close), .PULSE(LPulse));

Debouncer           UUT1 (.CLK(CLK), .Button(Validate), .PULSE(RPulse));

Debouncer           UUT2 (.CLK(CLK), .Button(Change), .PULSE(CPulse));     

Datapath            #(.DWL(DWL))
                    UUT3 (.CLK(CLK), .RST(RST), .Number(Number), 
                          .Validate(RPulse), .ShiftA(ShiftA), .ShiftB(ShiftB), 
                          .RSTA(RSTA), .Pass(Pass), .Reverse(Reverse));
          
ControlUnit         #(.DWL(DWL))
                    UUT4 (.CLK(CLK), .RST(RST), .Open_Close(LPulse), 
                          .Validate(RPulse), .Change(CPulse), .Pass(Pass), 
                          .Reverse(Reverse), .ShiftA(ShiftA), .ShiftB(ShiftB), 
                          .RSTA(RSTA), .Select(Select), .ALARM(ALARM));    
                    
SevenSegmentDisplay #(.DWL(DWL))
                    UUT5 (.CLK(CLK), .Select(Select), .Number(Number), 
                          .Anode(Anode), .Cathode(Cathode));          
                         
endmodule
