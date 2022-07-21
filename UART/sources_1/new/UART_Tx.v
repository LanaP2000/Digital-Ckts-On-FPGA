`timescale 1ns / 1ps

module UART_Tx #(parameter DWL = 8)
                (input CLK, RST, EN, WE,
                 input [DWL-1:0] parallelData,
                 output BUSY,
                 output reg serialData);

reg [DWL-6:0] bitPose = 3'h0;
reg [DWL-1:0] data = 8'h0;

localparam S_Idle = 2'b00, S_Start = 2'b01, S_Data = 2'b10, S_Stop = 2'b11;
    
reg [DWL-7:0] state, next_state; 

    // STATE REGISTER
    always @ (posedge CLK) begin
        if (RST)
            state <= S_Idle;
        else
            state <= next_state;
    end
    
    // NEXT STATE LOGIC
    always @ (state) begin
        case (state)
            // IDLE
            S_Idle: begin
                if (WE) begin
                    next_state = S_Start;
                end
            end
            // START
            S_Start: begin
                if (EN) begin
                    next_state = S_Data;
                end
            end
            // DATA
            S_Data: begin
                if (EN) begin
                    if (bitPose == 3'h7)
                        next_state = S_Stop;
                end
            end
            // STOP
            S_Stop: begin
                if (EN) begin
                    next_state = S_Idle;
                end
            end
            // DEFAULT
            default: begin
                next_state = S_Idle;
            end
        endcase
    end
    
    // OUTPUT LOGIC
    always @ (state) begin
        case (state)
            // IDLE
            S_Idle: begin
                if (WE) begin
                    data = parallelData;
                    bitPose = 3'h0;
                end
            end
            // START
            S_Start: begin
                if (EN) begin
                    serialData = 0;
                end
            end
            // DATA
            S_Data: begin
                if (EN) begin
                    serialData = data[bitPose];
                    if (bitPose != 3'h7) 
                        bitPose = bitPose + 3'h1;
                end
            end
            // STOP
            S_Stop: begin
                if (EN)
                    serialData = 1;
            end
            // DEFAULT
            default: begin
                serialData = 1;
            end
        endcase
    end
    
    assign BUSY = (next_state != S_Idle);
    
endmodule
