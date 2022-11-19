`timescale 1ns / 1ps

module DataPath(
    input Clock,
    input Reset,
    input [3:0] Number,
    input Validate,
    input ShiftA,
    input ShiftB,
    input ResetA,
    
    output Pass,
    output Reverse 
    );
    
    //A register-To save entered combination
    reg [15:0] A;
    
    //B register-Saves the actual combination
    reg [15:0] B;
    wire [15:0] RevB;
    
    //A register
    always@(posedge Clock)
    begin
        if(ResetA)
            A <= 16'b0;
        else if(ShiftA)//save entered combination
            if(Validate)
                A <= {A[11:0],Number};
     end           

    //B register
    always@(posedge Clock)
    begin
        if(Reset)
            B <= 16'h1234;//initial combination upon global reset
        else if(ShiftB)//set new combination
            if(Validate)
                B <= {B[11:0],Number};
     end
     
     assign RevB = {B[3:0],B[7:4],B[11:8],B[15:12]};
     
     assign Pass = (A==B) ? 1'b1 : 1'b0;
     assign Reverse = (A==RevB) ? 1'b1 : 1'b0;
     
endmodule
