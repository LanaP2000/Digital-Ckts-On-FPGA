`timescale 1ns / 1ps

module ControlUnit #(parameter DWL = 8)
                    (input CLK, RST,
                     input Open_Close,
                     input Validate,
                     input Change,
                     input Pass,
                     input Reverse,
                     output reg ShiftA,
                     output reg ShiftB,
                     output reg RSTA,
                     output reg [DWL-6:0] Select,
                     output reg ALARM);
    
localparam S_Locked   = 4'b0000,
           Digit3     = 4'b0001,
           Digit2     = 4'b0010,
           Digit1     = 4'b0011,
           Digit0     = 4'b0100,
           S_Compare  = 4'b0101,
           S_Pass     = 4'b0110,
           S_Fail     = 4'b0111,
           Pass_Alarm = 4'b1000,
           Set3       = 4'b1001,
           Set2       = 4'b1010,
           Set1       = 4'b1011,
           Set0       = 4'b1100;
           
reg [DWL-5:0] state, next_state;

    // STATE REGISTER SEQUENTIAL LOGIC
    always @ (posedge CLK or posedge RST) begin
        if (RST)
            state <= S_Locked;
        else
            state <= next_state;
    end
    
    // NEXT STATE COMBINATIONAL LOGIC
    always @ (state, Open_Close, Change, Pass, Reverse, Validate) begin
        case (state)
            S_Locked: begin
                if (Open_Close)
                    next_state = Digit3;
                else
                    next_state = S_Locked;
            end
            Digit3: begin
                if (Validate)
                    next_state = Digit2;
                else
                    next_state = Digit3;
            end
            Digit2: begin
                if (Change)
                    next_state = Digit3;
                else if (Validate)
                    next_state = Digit1;
                else
                    next_state = Digit2;
            end
            Digit1: begin
                if (Change)
                    next_state = Digit3;
                else if (Validate)
                    next_state = Digit0;
                else
                    next_state = Digit1;
            end
            Digit0: begin
                if (Change)
                    next_state = Digit3;
                else if (Validate)
                    next_state = S_Compare;
                else
                    next_state = Digit0;
            end
            S_Compare: begin
                if (Reverse)
                    next_state = Pass_Alarm;
                else if (Pass)
                    next_state = S_Pass;
                else
                    next_state = S_Fail;
            end
            S_Pass: begin
                if (Open_Close)
                    next_state = S_Locked;
                else if (Change)
                    next_state = Set3;
                else
                    next_state = S_Pass;
            end
            Pass_Alarm: begin
                if (Open_Close)
                    next_state = S_Locked;
                else
                    next_state = Pass_Alarm;
            end
            S_Fail: begin
                if (Open_Close)
                    next_state = S_Locked;
                else
                    next_state = S_Fail;
            end
            Set3: begin
                if (Validate)
                    next_state = Set2;
                else
                    next_state = Set3;
            end
            Set2: begin
                if (Change)
                    next_state = Set3;
                else if (Validate)
                    next_state = Set1;
                else
                    next_state = Set2;
            end
            Set1: begin
                if (Change)
                    next_state = Set3;
                else if (Validate)
                    next_state = Set0;
                else
                    next_state = Set1;
            end
            Set0: begin
                if (Change)
                    next_state = Set3;
                else if (Validate)
                    next_state = S_Locked;
                else
                    next_state = Set0;
            end
            default: begin
                next_state = S_Locked;
            end
        endcase
    end
    
    // OUTPUT COMBINATIONAL LOGIC
    always @ (state) begin
        case (state)
            S_Locked: begin
                RSTA = 1;
                Select = 3'b000; // Display LOCk
            end
            Digit3: begin
                ShiftA = 1;
                Select = 3'b001; // Display 1st digit and '-' on others
            end
            Digit2: begin
                ShiftA = 1;
                Select = 3'b010; // Display 2nd digit and '-' on others
            end
            Digit1: begin
                ShiftA = 1;
                Select = 3'b011; // Display 3rd digit and '-' on others
            end
            Digit0: begin
                ShiftA = 1;
                Select = 3'b100; // Display 4th digit and '-' on others
            end
            S_Compare: begin
                Select = 3'b101; // Segments are off
            end
            S_Pass: begin
                Select = 3'b110; // Display PASS
            end
            Pass_Alarm: begin
                Select = 3'b110; // Display PASS
                ALARM = 1;
            end
            S_Fail: begin
                Select = 3'b111; // Display FAIL
            end
            Set3: begin
                ShiftB = 1;
                Select = 3'b001; // Display 1st digit and '-' on others
            end
            Set2: begin
                ShiftB = 1;
                Select = 3'b010; // Display 2nd digit and '-' on others
            end
            Set1: begin
                ShiftB = 1;
                Select = 3'b011; // Display 3rd digit and '-' on others
            end
            Set0: begin
                ShiftB = 1;
                Select = 3'b100; // Display 4th digit and '-' on others
            end
        endcase
    end
    
endmodule
