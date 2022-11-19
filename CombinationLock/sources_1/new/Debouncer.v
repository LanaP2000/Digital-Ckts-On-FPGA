`timescale 1ns / 1ps

module Debouncer(
    input Clock,
    input Button,
    output Pulse
    );
    
    reg clk100=1'b0;
    reg [18:0] count=18'b0;
    reg Q1=1'b0;
    reg Q2=1'b0;
    reg Q3=1'b0;
    reg Q4=1'b0;
    reg Q5=1'b0;
    wire PB_HIGH;
    reg D1=1'b0;
    reg D2=1'b0;

    //100 Hz clock
    always @ (posedge Clock)
    begin
        count <= (count == 499999)? 0 : count+1;//499999
        clk100 <= (count == 499999) ? ~clk100 : clk100;
    end
    //Synchronizer to filter debounce
    always@(posedge clk100)
    begin
            Q1 <= Button;
            Q2 <= Q1;
            Q3 <= Q2;
            Q4 <= Q3;
            Q5 <= Q4;
    end
        
    assign PB_HIGH = Q5 & Q4 & Q3 & Q2 & Q1; 
    
    always@(posedge Clock)
    begin
        D1 <= PB_HIGH; //new value
        D2 <= D1;     //old value
        
    end
    
    // Pulse Generation:       
    assign Pulse =  D1 & (~D2);    
endmodule
