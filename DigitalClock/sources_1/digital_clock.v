`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:02 11/21/2020 
// Design Name: 
// Module Name: digital_clock
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


module digital_clock(
		input clk,
		input clr, 
		input [1:0] mode, //sw1
		input min_up, //sw2
		input hour_up, //sw3 1 for hr & 0 for min
		output alarm,
		output [3:0] min_LSB,
		output [3:0] min_MSB,
		output [3:0] hr_LSB,
		output [3:0] hr_MSB

    );
	 
	 
	 reg [25:0] count_sec=0;
	 reg alarm_led=0;
	 reg [5:0] seconds=6'd0;
	 reg [5:0] mins=6'd0;
	 reg [4:0] hours=5'd0;
	 
	 reg [5:0] mins_alarm=6'd0;
	 reg [4:0] hours_alarm=5'd0;
	 
	 reg clock=0; 
	 reg [2:0] alarm_sec =3'd0;
	 
	 wire [3:0] hours_LSB,mins_LSB,hours_MSB,mins_MSB;

	 wire [3:0] min_LSB_alarm,min_MSB_alarm,hr_LSB_alarm,hr_MSB_alarm;
	 
    reg [26:0]  sec_count=27'd0;//60 for sec count, you will require 6 bits

    localparam onesec=1_666_665; //1second count is 99_999_999 here for testing 1 sec is 1 min 
//    localparam onesec=99; //simulation 
	 
	 reg start=1'b0;
		assign alarm=(alarm_sec<5)?alarm_led:1'b0;
		assign min_LSB=(mode!=2'b01)? mins_LSB:min_LSB_alarm;
		assign min_MSB=(mode!=2'b01)? mins_MSB:min_MSB_alarm;
		assign hr_LSB=(mode!=2'b01)? hours_LSB:hr_LSB_alarm;
		assign hr_MSB=(mode!=2'b01)? hours_MSB:hr_MSB_alarm;
	
always@(posedge clk)
begin
    if(sec_count==onesec)
        begin
        sec_count<=27'd0;
        clock<=1'b1;
        end

	else
        begin
        clock<=1'b0;
        sec_count<=sec_count+1'b1;
        end

    if(clr) 
    begin
        start<=1'b0;
        sec_count<=27'd0;
        clock<=0;
        end
    else 
        start<=1'b1;

end	 


always @(posedge clk)
begin
if (clr)
begin
    seconds<= 6'd0;
    mins<= 6'd0;
    hours<= 5'd0;
end
else if(start & clock && (mode!=2'b01))
begin

    seconds <=(seconds==59)? 6'd0: seconds +1'b1;
    
    if (seconds==59) 
    begin
    mins<=(mins==59)? 6'd0: mins +1'b1;
    
    if (mins==59)
    hours<=(hours==12)? 5'd0: hours +1'b1;
    end
end

else
begin
    mins_alarm<=(clr||((mins_alarm==6'd59) && min_up))? 6'd0: (min_up)?   mins_alarm + 1'b1:mins_alarm;
    hours_alarm<=(clr||((hours_alarm==5'd12)&& hour_up))? 5'd0:(hour_up)?  hours_alarm +1'b1:hours_alarm;

end

if((hours==hours_alarm) && (mins==mins_alarm) && (mode==2'b10)  )
begin
alarm_led<=1;
alarm_sec<=(alarm_sec==6)? alarm_sec:clock?alarm_sec+1'b1:alarm_sec;
end
else 
begin
alarm_led<=0;
alarm_sec<=0;
end

end


   //instantiating the binarytoBCD module here to convert the numbers and display the on the 7-segment
   binarytoBCD clock_run (
    .mins(mins), 
    .hours(hours), 
    .hours_LSB(hours_LSB), 
    .mins_LSB(mins_LSB), 
    .hours_MSB(hours_MSB), 
    .mins_MSB(mins_MSB)
    );
	 
	 binarytoBCD alarm_run (
    .mins(mins_alarm), 
    .hours(hours_alarm), 
    .hours_LSB(hr_LSB_alarm), 
    .mins_LSB(min_LSB_alarm), 
    .hours_MSB(hr_MSB_alarm), 
    .mins_MSB(min_MSB_alarm)
    );
	 
    
endmodule
