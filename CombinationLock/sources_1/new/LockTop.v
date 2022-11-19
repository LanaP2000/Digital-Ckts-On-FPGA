`timescale 1ns / 1ps

module LockTop(
    input Clock,
    input Reset,        //SW[7]
    input Open_Close,   //BTNL
    input Validate,     //BTNR
    input Change,       //BTNC
    input [3:0] Number, //SW[3]-SW[0]
    output Alarm,       //LED0
    output [3:0] ANODE,
    output [7:0] CATHODE    
    );
    
    //Interconnections
    wire RPulse,LPulse,CPulse;
    wire ShiftA, ShiftB, ResetA, Pass, Reverse;
    wire [2:0] Selector;
    
    //Instantiations
    //1. Debouncers for Buttons
    Debouncer DEBL (.Clock(Clock), .Button(Open_Close), .Pulse(LPulse));
    Debouncer DEBR (.Clock(Clock), .Button(Validate), .Pulse(RPulse));
    Debouncer DEBC (.Clock(Clock), .Button(Change), .Pulse(CPulse));
    
    //2. Datapath
    DataPath DP 
    (.Clock(Clock), 
     .Reset(Reset), 
     .Number(Number), 
     .Validate(RPulse), 
     .ShiftA(ShiftA),
     .ShiftB(ShiftB),
     .ResetA(ResetA),
     .Pass(Pass),
     .Reverse(Reverse)
     );
    
    //3. Controller
    ControlUnit CU
    (.Clock(Clock), 
     .Reset(Reset), 
     .Open_Close(LPulse), 
     .Validate(RPulse), 
     .Change(CPulse),
     .Pass(Pass),
     .Reverse(Reverse),        
     .ShiftA(ShiftA),
     .ShiftB(ShiftB),
     .ResetA(ResetA),
     .Selector(Selector),
     .Alarm(Alarm)
     );

    SSD_Display SSD
    (.Clock(Clock),      
     .Number(Number), 
     .Selector(Selector),
     .ANODE(ANODE),
     .CATHODE(CATHODE)
     );
     
endmodule
