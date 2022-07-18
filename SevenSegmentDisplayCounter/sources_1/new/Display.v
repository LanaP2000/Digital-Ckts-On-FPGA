`timescale 1ns / 1ps

module Display #(IWL = 4, OWL = 8)
                (input CLK,
                 output reg [IWL-1:0] Anode,
                 output reg [OWL-1:0] Out);
    
reg [OWL*2-1:0] counter;
reg [(2*OWL)+IWL-1:0] refresh_counter;
reg [IWL-1:0] hexNum, SW;
wire [IWL-3:0] anode_counter;
wire ENABLE;

initial counter = 0;
    
    always @ (posedge CLK) begin
        if (counter >= 99999999) 
            counter <= 0;
        else
            counter <= counter + 1;
    end 
    
    assign ENABLE = (counter == 99999999) ? 1 : 0;
    
    always @ (posedge CLK) begin
        if (ENABLE == 1)
            SW <= SW - 1;
    end
    
    always @(posedge CLK) begin
        refresh_counter <= refresh_counter + 1;
    end 
    
    assign anode_counter = refresh_counter[19:18];
    
    always @(*)
    begin
        case(anode_counter)
            2'b00: begin
                Anode = 4'b0111; 
                hexNum = SW;
            end
            2'b01: begin
                Anode = 4'b1011; 
                hexNum = SW;
            end
            2'b10: begin
                Anode = 4'b1101; 
                hexNum = SW;
            end
            2'b11: begin
                Anode = 4'b1110; 
                hexNum = SW;
            end
        endcase
    end
    
    // Cathode pattern
    always @ (*) begin
        case (hexNum)
            0:  Out = 7'b1000000;
            1:  Out = 7'b1111001;
            2:  Out = 7'b0100100;
            3:  Out = 7'b0110000;
            4:  Out = 7'b0011001;
            5:  Out = 7'b0010010;
            6:  Out = 7'b0000010;
            7:  Out = 7'b1111000;
            8:  Out = 7'b0000000;
            9:  Out = 7'b0010000;
            10: Out = 7'b0001000;
            11: Out = 7'b0000011;
            12: Out = 7'b1000110;
            13: Out = 7'b0100001;
            14: Out = 7'b0000110;
            15: Out = 7'b0001110;
            default: 
                Out = 7'b1111111;
        endcase
    end
    
endmodule
