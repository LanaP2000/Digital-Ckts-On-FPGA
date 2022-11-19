## Clock signal
set_property PACKAGE_PIN W5 [get_ports Clock]							
	set_property IOSTANDARD LVCMOS33 [get_ports Clock]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clock]

## Switches
set_property PACKAGE_PIN V17 [get_ports {Number[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Number[0]}]
set_property PACKAGE_PIN V16 [get_ports {Number[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Number[1]}]
set_property PACKAGE_PIN W16 [get_ports {Number[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Number[2]}]
set_property PACKAGE_PIN W17 [get_ports {Number[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Number[3]}]
set_property PACKAGE_PIN R2 [get_ports {Reset}]					
        set_property IOSTANDARD LVCMOS33 [get_ports {Reset}]

## LEDs
set_property PACKAGE_PIN U16 [get_ports {Alarm}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Alarm}]  

##7 segment display
set_property PACKAGE_PIN W7 [get_ports {CATHODE[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[6]}]
set_property PACKAGE_PIN W6 [get_ports {CATHODE[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[5]}]
set_property PACKAGE_PIN U8 [get_ports {CATHODE[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[4]}]
set_property PACKAGE_PIN V8 [get_ports {CATHODE[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[3]}]
set_property PACKAGE_PIN U5 [get_ports {CATHODE[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[2]}]
set_property PACKAGE_PIN V5 [get_ports {CATHODE[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[1]}]
set_property PACKAGE_PIN U7 [get_ports {CATHODE[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[0]}]

set_property PACKAGE_PIN V7 [get_ports {CATHODE[7]}]							
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[7]}]

set_property PACKAGE_PIN U2 [get_ports {ANODE[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[0]}]
set_property PACKAGE_PIN U4 [get_ports {ANODE[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[1]}]
set_property PACKAGE_PIN V4 [get_ports {ANODE[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[2]}]
set_property PACKAGE_PIN W4 [get_ports {ANODE[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[3]}]	   
	
##Buttons
    set_property PACKAGE_PIN U18 [get_ports Change]                        
        set_property IOSTANDARD LVCMOS33 [get_ports Change]
    set_property PACKAGE_PIN W19 [get_ports Open_Close]                        
        set_property IOSTANDARD LVCMOS33 [get_ports Open_Close]
    set_property PACKAGE_PIN T17 [get_ports Validate]                        
        set_property IOSTANDARD LVCMOS33 [get_ports Validate]
	   		