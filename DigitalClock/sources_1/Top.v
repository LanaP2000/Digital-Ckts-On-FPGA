`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  alarm_clock
//////////////////////////////////////////////////////////////////////////////////
module alarm_clock(
input clk,
input clr, //sw15
input [1:0] mode, //sw0-sw1
input hour_up, //button Left for hour increase
input min_up, //button right for min increase
output  [6:0] seg,
output  [3:0] an,
output  alarm // led 0
    );


wire [3:0] min, min_ten,hour,hour_ten;
wire mins_up,hours_up;
button_debouncer mins_button_debouncer(
.clk(clk), 
.button(min_up), 
.debounced_button(mins_up)
);

button_debouncer hours_button_debouncer(
.clk(clk), 
.button(hour_up), 
.debounced_button(hours_up)
);

// Instantiate the digital_clock module
digital_clock clock_inst (
    .clk(clk), 
    .clr(clr), 
    .mode(mode), 
    .min_up(mins_up), 
    .hour_up(hours_up), 
    .alarm(alarm), 
    .min_LSB(min), 
    .min_MSB(min_ten), 
    .hr_LSB(hour), 
    .hr_MSB(hour_ten)
    );

// Instantiate the sevenseg_driver module
sevenseg_driver SSD (
    .clk(clk), 
    .in3(hour_ten), 
    .in2(hour), 
    .in1(min_ten), 
    .in0(min), 
    .seg(seg), 
    .an(an)
    );



endmodule
