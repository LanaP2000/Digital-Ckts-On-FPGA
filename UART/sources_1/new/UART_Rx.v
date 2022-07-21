`timescale 1ns / 1ps

module UART_Rx #(parameter DWL = 8)
                (input CLK, EN,
                 input serialData,
                 input BUSY,
                 output reg rByte,
                 output reg [DWL-1:0] rData);
                 
reg [DWL-6:0] bitPose = 3'h0;
reg [DWL-5:0] sample = 3'h0;
reg [DWL-1:0] scratch = 8'b0;

localparam S_Start = 2'b00, S_Data = 2'b01, S_Stop = 2'b10;  

reg [DWL-7:0] state = S_Start;

    always @(posedge CLK) begin
	   if (BUSY)
	       rByte <= 0;

	   if (EN) begin
	       case (state)
		      S_Start: begin
			     if ((!serialData || sample != 0) & !BUSY)
				    sample <= sample + 4'b1; 

			     if (sample == 15) begin
				    state <= S_Data;
				    bitPose <= 0;
				    sample <= 0;
				    scratch <= 0;
			     end
		      end
		      S_Data: begin
			     sample <= sample + 4'b1;
			     if (sample == 4'h8) begin
				    scratch[bitPose[2:0]] <= serialData;
				    bitPose <= bitPose + 4'b1;
			     end
			     if (bitPose == 8 && sample == 15)
				    state <= S_Stop;
		         end
		      S_Stop: begin
			     if (sample == 15 || (sample >= 8 && !serialData)) begin
				    state <= S_Start;
				    rData <= scratch;
				    rByte <= 1'b1;
				    sample <= 0;
			     end 
			     else begin
				    sample <= sample + 4'b1;
			     end
		      end
		      default: begin
			     state <= S_Start;
		      end
		  endcase
	  end
    end
                 
endmodule
