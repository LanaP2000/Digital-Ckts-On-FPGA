`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:02 11/21/2020 
// Design Name: 
// Module Name: binarytoBCD
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


module binarytoBCD(
    input [5:0] mins, 
    input [4:0] hours, 
    output reg [3:0] hours_LSB=4'd0,
    output reg [3:0] mins_LSB=4'd0,
    output reg [3:0] hours_MSB=4'd0,
    output reg [3:0] mins_MSB=4'd0
    );
    


	
    always @(*) 
    begin
	 
	 
	 hours_MSB<=hours/10;
	 mins_MSB<=mins/10;
    
	
	 hours_LSB<=hours%10;
	 mins_LSB<=mins%10;
	 end
    endmodule
