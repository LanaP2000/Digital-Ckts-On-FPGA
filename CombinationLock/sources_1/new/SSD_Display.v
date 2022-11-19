module SSD_Display(
    input Clock,
    input [3:0] Number,
    input [2:0] Selector,
    output reg [3:0] ANODE,
    output reg [7:0] CATHODE
    );

    reg [7:0] ssd0;
    reg [7:0] ssd1;
    reg [7:0] ssd2;
    reg [7:0] ssd3;
    reg ssdClock;	//500 Hz Clock
    reg [1:0] select=2'b0;
    reg [17:0] count = 18'b0;
    
    parameter period = 100000;
    //ssd decoding    //dpabcdefg
    parameter L     = 8'b11110001;
    parameter O     = 8'b10000001;
    parameter C     = 8'b10110001;
    parameter k     = 8'b11111000;
    parameter P     = 8'b10011000;
    parameter A     = 8'b10001000;
    parameter S     = 8'b10100100;
    parameter F     = 8'b10111000;
    parameter I     = 8'b11111001;
    parameter dash  = 8'b11111110;
    parameter off   = 8'b11111111;
// According to Basys 3 reference manual: 
//Common anode and cathode values for all segments, therefore,
//for each of the 4 digits to appear continuously illuminated,
// all four digits should be driven at least once in the range 
// of 1ms to 16 ms i.e. 1KHz to 60 Hz. 

//Selecting 8 ms as the refresh period, digit period = refresh period/4 = 8ms/4 = 2ms
//Required Clock Frequency is 1/(2ms) = (500 Hz)

    always @ (posedge Clock)
    begin
    count <= (count == period-1)? 0 : count+1;
    ssdClock <= (count == period-1) ? ~ssdClock : ssdClock;
    end

//A 2 bit Scanner for 4 SSDs
//with a 500 Hz clock 
    always@(posedge ssdClock)
    begin
        select <= select + 2'b01;
    end

//Selecting Anode values
    always@(*)
    begin
        case (select)
        2'b00:ANODE = 4'b1110; //AN0 is ON
        2'b01:ANODE = 4'b1101; //AN1 is ON
        2'b10:ANODE = 4'b1011; //AN2 is ON
        2'b11:ANODE = 4'b0111;	//AN3 is ON
        endcase
    end   
//
//Decoding Values to be displayed on each ssd
always@(*)
begin
	case (Selector)
	3'b000: ssd3 = L; 
	3'b001: ssd3 = ssd(Number); 
	3'b010: ssd3 = dash; 
	3'b011: ssd3 = dash;   
	3'b100: ssd3 = dash; 	
	3'b101: ssd3 = dash; 	
	3'b110: ssd3 = P; 
	3'b111: ssd3 = F; 
	default: ssd3 = off;
	endcase
end	

always@(*)
begin
	case (Selector)
	3'b000: ssd2 = O; 
	3'b001: ssd2 = dash; 
	3'b010: ssd2 = ssd(Number); 
	3'b011: ssd2 = dash; 
	3'b100: ssd2 = dash;   
	3'b101: ssd2 = dash; 	
	3'b110: ssd2 = A; 
	3'b111: ssd2 = A; 
	default: ssd2 = off;
	endcase
end

always@(*)
begin
	case (Selector)
	3'b000: ssd1 = C;	
	3'b001: ssd1 = dash;	
	3'b010: ssd1 = dash;	
	3'b011: ssd1 = ssd(Number);	
	3'b100: ssd1 = dash;	
	3'b101: ssd1 = dash;	
	3'b110: ssd1 = S; 
	3'b111: ssd1 = I;	
	default: ssd1 = off;
	endcase
end

always@(*)
begin
	case (Selector)
	3'b000: ssd0 = k;	// OFF
	3'b001: ssd0 = dash;	// OFF	
	3'b010: ssd0 = dash;	// OFF	
	3'b011: ssd0 = dash;	// OFF
	3'b100: ssd0 = ssd(Number);	// OFF	
	3'b101: ssd0 = dash;	// OFF	
	3'b110: ssd0 = S; // Units place of Timer
	3'b111: ssd0 = L;	// OFF	
	default: ssd0 = off;
	endcase
end

//Selecting Cathode values
     always@(*)
     begin
         case (select)
         2'b00:CATHODE = ssd0; 
         2'b01:CATHODE = ssd1; 
         2'b10:CATHODE = ssd2; 
         2'b11:CATHODE = ssd3; 
         endcase
     end

// Binary to Seven Segment Display (0 to F: Hexadecimal)	
function [7:0]ssd;
input [3:0] bin;
begin
	case (bin)
		4'b0000: ssd = 8'b10000001;
		4'b0001: ssd = 8'b11001111;
		4'b0010: ssd = 8'b10010010;
		4'b0011: ssd = 8'b10000110;	
		4'b0100: ssd = 8'b11001100;
		4'b0101: ssd = 8'b10100100;
		4'b0110: ssd = 8'b10100000;
		4'b0111: ssd = 8'b10001111;	
		4'b1000: ssd = 8'b10000000;
		4'b1001: ssd = 8'b10000100;
		4'b1010: ssd = 8'b10001000;
		4'b1011: ssd = 8'b11100000;	
		4'b1100: ssd = 8'b10110001;
		4'b1101: ssd = 8'b11000010;
		4'b1110: ssd = 8'b10110000;
		4'b1111: ssd = 8'b10111000;	
	endcase
end
endfunction
 
endmodule
