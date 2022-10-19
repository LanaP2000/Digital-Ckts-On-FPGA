`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:56:59 03/19/2021
// Design Name:   alarm_clock
// Module Name:   C:/Users/user/Documents/task/ALARM_CLOCK/testbench.v
// Project Name:  ALARM_CLOCK
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alarm_clock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg clk;
	reg clr;
	reg [1:0] mode;
	reg hour_up;
	reg min_up;
	

	// Outputs
	wire [6:0] seg;
	wire [3:0] an;
	wire alarm;

	// Instantiate the Unit Under Test (UUT)
	alarm_clock uut (
		.clk(clk), 
		.clr(clr), 
		.mode(mode), 
		.min_up(min_up), 
		.hour_up(hour_up), 
		.seg(seg), 
		.an(an), 
		.alarm(alarm)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clr = 0;
		mode = 0;
		min_up = 0;
		hour_up = 0;


		// Wait 100 ns for global reset to finish
		#100;
        mode=0;
		  #100000;
		  #100000;
		  #100000;
		  #100000;
		  mode=1;
		  #10;
		  min_up = 1;
		  #500;
		  min_up = 0;
		  #500;
		  min_up = 1;
		  #500;
                    min_up = 0;
		  #500;
		  min_up = 1;
		  hour_up = 1;
		  #500;
                    min_up = 0; hour_up = 0;
		  #500;
		  hour_up = 1;
		  #500;
                              min_up = 0; hour_up = 0;
		  #500;
		  hour_up = 1;
		  #500;
                              min_up = 0; hour_up = 0;
		  #50000;
		  min_up = 0;
		  #10;
mode=2;
		  
		  
		  
		// Add stimulus here

	end
      always #1 clk=~clk;
endmodule

