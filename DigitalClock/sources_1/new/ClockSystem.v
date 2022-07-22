`timescale 1ns / 1ps

module ClockSystem #(parameter DWL = 8)
                    (input CLK, CLR,
                     input [DWL-7:0] Mode,
                     input minUP, hourUP,
                     output [DWL-5:0] Hours_LSB,
                     output [DWL-5:0] Minutes_LSB,
                     output [DWL-5:0] Hours_MSB,
                     output [DWL-5:0] Minutes_MSB,
                     output ALARM);
 
localparam ONESECOND = 1_666_665;
    
reg [(DWL*4)+1:0] counter;
reg ALARM_LED = 1'b0;
reg CLOCK = 1'b0;
reg Start = 1'b0;
reg [DWL-5:0] Minutes_ALARM = 6'd0;
reg [DWL-4:0] Hours_ALARM = 5'd0;
reg [DWL-6:0] Seconds_ALARM = 3'd0;
reg [DWL-3:0] Seconds = 6'd0;
reg [DWL-3:0] Minutes = 5'd0;
reg [DWL-4:0] Hours = 5'd0;

wire [DWL-5:0] HourLSB, MinuteLSB, HourMSB, MinuteMSB;
wire [DWL-5:0] HourLSBALARM, MinuteLSBALARM, HourMSBALARM, MinuteMSBALARM;

    assign ALARM = (Seconds_ALARM < 5) ?  ALARM_LED : 1'b0;
    assign Hours_LSB = (Mode != 2'b01) ? HourLSB : HourLSBALARM;
    assign Minutes_LSB = (Mode != 2'b01) ? MinuteLSB : MinuteLSBALARM;
    assign Hours_MSB = (Mode != 2'b01) ? HourMSB : HourMSBALARM;
    assign Minutes_MSB = (Mode != 2'b01) ? MinuteMSB : MinuteMSBALARM;

    always @ (posedge CLK) begin
        if (counter == ONESECOND) begin
            counter <= 27'd0;
            CLOCK <= 1'b1;
        end
        else begin
            counter <= counter + 1;
            CLOCK <= 1'b0;
        end
        if (CLR) begin
            Start <= 1'b0;
            counter <= 27'd0;
            CLOCK <= 1'b0;
        end
        else
            Start <= 1'b1;
    end
    
    always @ (posedge CLK) begin
        if (CLR) begin
            Seconds <= 6'd0;
            Minutes <= 6'd0;
            Hours <= 5'd0;
        end
        else if (Start && CLOCK && (Mode != 2'b01)) begin
            Seconds <= (Seconds == 59) ? 6'd0 : (Seconds + 1);
            if (Seconds == 59) begin
                Minutes <= (Minutes == 59) ? 6'd0 : (Minutes + 1);
            end
            if (Minutes == 59) begin
                Hours <= (Hours == 12) ? 5'd0 : (Hours + 1);
            end
        end
        else begin
            Minutes_ALARM <= (CLR || ((Minutes_ALARM == 6'd59) && minUP)) ? 6'd0 : (minUP) ? Minutes_ALARM + 1 : Minutes_ALARM;
            Hours_ALARM <= (CLR || ((Hours_ALARM == 5'd12) && hourUP)) ? 5'd0 : (hourUP) ? Hours_ALARM + 1 : Hours_ALARM;

        end
        
        if ((Hours == Hours_ALARM) && (Minutes == Minutes_ALARM) && (Mode == 2'b10)) begin
            ALARM_LED <= 1;
            Seconds_ALARM <= (Seconds_ALARM == 6) ? Seconds_ALARM : CLOCK ? Seconds_ALARM + 1 : Seconds_ALARM;
        end
        else begin
            ALARM_LED <= 0;
            Seconds_ALARM <= 0;
        end
    end
    
System #(.DWL(DWL)) 
       UUT0 (.Minutes(Minutes), .Hours(Hours), 
             .Hours_LSB(Hour_LSB), .Minutes_LSB(Minute_LSB),
             .Hours_MSB(Hour_MSB), .Minutes_MSB(Minute_MSB));

System #(.DWL(DWL)) 
       UUT1 (.Minutes(Minutes_ALARM), .Hours(Hours_ALARM), 
             .Hours_LSB(HourLSBALARM), .Minutes_LSB(MinuteLSBALARM),
             .Hours_MSB(HourMSBALARM), .Minutes_MSB(MinuteMSBALARM));
    
endmodule
