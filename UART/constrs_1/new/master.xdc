# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK]

#USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports Rx]						
	set_property IOSTANDARD LVCMOS33 [get_ports Rx]
set_property PACKAGE_PIN A18 [get_ports Tx]						
	set_property IOSTANDARD LVCMOS33 [get_ports Tx]
