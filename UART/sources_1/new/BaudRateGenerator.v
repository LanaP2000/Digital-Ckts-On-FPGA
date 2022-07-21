`timescale 1ns / 1ps

module BaudRateGenerator(input CLK,
                         output Tx_CLK,
                         output Rx_CLK);
    
parameter fCLK = 100000000;  
parameter Baud_rate = 9600;
parameter TX_counter_max = fCLK / Baud_rate; 
parameter RX_counter_max = fCLK / (Baud_rate * 16);  // Reciever sampling

parameter TX_counter_WIDTH = $clog2(TX_counter_max);
parameter RX_counter_WIDTH = $clog2(RX_counter_max);

reg [TX_counter_WIDTH-1:0] TX_counter = 0;
reg [RX_counter_WIDTH-1:0] RX_counter = 0; 

assign Tx_CLK = (TX_counter == 'd0);
assign Rx_CLK = (RX_counter == 'd0);

    always @(posedge CLK) begin
	   if (RX_counter == RX_counter_max[RX_counter_WIDTH - 1:0]) 
		   RX_counter <= 0;
       else
	       RX_counter <= RX_counter + 1'b1; 
    end

    always @(posedge CLK) begin
	   if (TX_counter == TX_counter_max[TX_counter_WIDTH - 1:0]) 
	       TX_counter <= 0;
	   else
	       TX_counter <= TX_counter + 1'b1; 
    end
    
endmodule
