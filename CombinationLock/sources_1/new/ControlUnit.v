`timescale 1ns / 1ps

module ControlUnit(
    input Clock,
    input Reset,
    input Open_Close,
    input Validate,
    input Change,
    input Pass,
    input Reverse,
    output reg ShiftA,
    output reg ShiftB,
    output reg ResetA,
    output reg [2:0] Selector,
    output reg Alarm
    );

//States of FSM
localparam  Locked_State     = 4'b0000,
			Digit3           = 4'b0001,
			Digit2           = 4'b0010,
			Digit1           = 4'b0011,
			Digit0           = 4'b0100,
			Compare_State    = 4'b0101,
			Pass_State	     = 4'b0110,	
			Fail_State       = 4'b0111,
			Pass_Alarm       = 4'b1000,
			Set3             = 4'b1001,
			Set2             = 4'b1010,
			Set1             = 4'b1011,
			Set0             = 4'b1100;    

//State Registers			 
reg [3:0] pr_state, nx_state;

//State Register-Sequential Logic
always@(posedge Clock, posedge Reset)
begin
	if(Reset)
		pr_state <= Locked_State;
	else
		pr_state <= nx_state;
end    

//Next State-Combination Logic
always@(pr_state,Open_Close,Change,Pass,Reverse,Validate)
begin
	case (pr_state)
	Locked_State:
		begin
			if(Open_Close)				// if user wants to Open
				nx_state = Digit3;
			else
				nx_state = Locked_State;
		end
    //Sequence of Entering the 4 digit Combination 
	Digit3:
		begin
            if(Validate)				
				nx_state = Digit2;
			else
				nx_state = Digit3;
		end		

	Digit2:
		begin
	        if (Change)
	            nx_state = Digit3;	
		    else if(Validate)				
				nx_state = Digit1;
			else
				nx_state = Digit2;
		end	

	Digit1:
		begin
	        if (Change)
                nx_state = Digit3;    
            else if(Validate)				
				nx_state = Digit0;
			else
				nx_state = Digit1;
		end	

	Digit0:
		begin
	        if (Change)
                nx_state = Digit3;    
            else if(Validate)				
				nx_state = Compare_State;
			else
				nx_state = Digit0;
		end
    
    //Comparison
    Compare_State:
		begin
            if(Reverse)                
                nx_state = Pass_Alarm;
            else if(Pass)
                nx_state = Pass_State;
            else
                nx_state = Fail_State;    
        end  

    //
    Pass_State:
        begin
            if(Open_Close)                // if user wants to Close
                nx_state = Locked_State;
            else if(Change)               // if user wants to set a new combination  
                nx_state = Set3;
            else
                nx_state = Pass_State;    
        end 

    Pass_Alarm:
    begin
        if(Open_Close)                
            nx_state = Locked_State;
        else
            nx_state = Pass_Alarm;
    end    

    Fail_State:
    begin
        if(Open_Close)                
            nx_state = Locked_State;
        else
            nx_state = Fail_State;
    end

    //Sequence of Entering the 4 digit Combination 
	Set3:
		begin
			if(Validate)				
				nx_state = Set2;
			else
				nx_state = Set3;
		end		

	Set2:
		begin
	        if (Change)
                nx_state = Set3;    
            else if(Validate)				
				nx_state = Set1;
			else
				nx_state = Set2;
		end	

	Set1:
		begin
	        if (Change)
                nx_state = Set3;    
            else if(Validate)				
				nx_state = Set0;
			else
				nx_state = Set1;
		end	

	Set0:
		begin
	        if (Change)
                nx_state = Set3;    
            else if(Validate)				
				nx_state = Locked_State;
			else
				nx_state = Set0;
		end
    
    default:nx_state = Locked_State;
    endcase
end    

//Output-Combination Logic    
always@(pr_state)
begin
//defaults
ShiftA = 1'b0; ShiftB = 1'b0;
ResetA = 1'b0; Alarm  = 1'b0;
Selector = 3'b000;
    
    case (pr_state)
    Locked_State:
    begin
        ResetA   = 1'b1;    //reset Register A that stores the entered combination
        Selector = 3'b000;//to display LOCk    
    end
    Digit3:
    begin
        ShiftA   = 1'b1;
        Selector = 3'b001;//to display 1st digit and "-" on others
    end
    Digit2:
    begin
        ShiftA   = 1'b1;
        Selector = 3'b010;//to display 2nd digit and "-" on others
    end         
    Digit1:
    begin
        ShiftA   = 1'b1;
        Selector = 3'b011;//to display 3rd digit and "-" on others
    end
    Digit0:
    begin
        ShiftA   = 1'b1;
        Selector = 3'b100;//to display 4th digit and "-" on others
    end              
    Compare_State:
    begin
        Selector = 3'b101;//all segments are off
    end
    Pass_State: 
    begin
        Selector = 3'b110;//to display PASS
    end  
    Pass_Alarm: 
    begin
        Selector = 3'b110;//to display PASS
        Alarm = 1'b1; //alarm feature
    end 
    Fail_State: 
    begin
        Selector = 3'b111;//to display PASS
    end
    Set3:
    begin
        ShiftB   = 1'b1;
        Selector = 3'b001;//to display 1st digit and "-" on others
    end
    Set2:
    begin
        ShiftB   = 1'b1;
        Selector = 3'b010;//to display 2nd digit and "-" on others
    end         
    Set1:
    begin
        ShiftB   = 1'b1;
        Selector = 3'b011;//to display 3rd digit and "-" on others
    end
    Set0:
    begin
        ShiftB   = 1'b1;
        Selector = 3'b100;//to display 4th digit and "-" on others
    end
    endcase
end
                                                               									
endmodule
