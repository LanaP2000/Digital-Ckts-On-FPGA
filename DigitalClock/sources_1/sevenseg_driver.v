`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:02 11/21/2020 
// Design Name: 
// Module Name: sevenseg_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sevenseg_driver(
    input clk,       		
    input [3:0] in3,		
    input [3:0] in2,		
    input [3:0] in1,		
    input [3:0] in0,		
    output reg [3:0] an=4'b1111,
    output reg [6:0] seg=7'b1111111
    
    );
    
    wire [6:0] seg0, seg1, seg2, seg3;
    reg [12:0] segclk=13'd0; 
    reg [1:0] state=2'd0;

	 
    //instantiating the seven segment decoder four times
     Decoder_7_segment disp0(in0,seg0);
     Decoder_7_segment disp1(in1,seg1);
     Decoder_7_segment disp2(in2,seg2);
     Decoder_7_segment disp3(in3,seg3);
       
    
    always @(posedge clk)
	begin
    segclk<= segclk+1'b1; //counter goes up by 1
	end
	
    always @(posedge segclk[12])
    begin
        case(state)
        
        2'd0: begin
                seg<=seg0;
                an<=4'b1110;
                state<=2'b01;
                end
                
        2'd1: begin
                seg<=seg1;
                an<=4'b1101;
                state<=2'b10;
                end

        2'd2: begin
                seg<=seg2;
                an<=4'b1011;
                state<=2'b11;
                end
                
        2'd3: begin
                seg<=seg3;
                an<=4'b0111;
                state<=2'b00;
                end
                
         endcase

    
    end
        
   
endmodule
