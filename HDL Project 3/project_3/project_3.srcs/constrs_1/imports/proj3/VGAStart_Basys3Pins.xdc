#  VGAStart_Basys3Pins.xdc
#  
#  UW EE4490 Fall 2019
#  
#  Adapted from original code by Jerry C. Hamann.
#  Derived from master XDC file provided for Basys3 rev B board by Digilent Inc.
#  
#  Edited by Luke Cloud and Moteeb Albaqami to obtain requirements for Project 3.

## Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK_100MHz]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK_100MHz]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK_100MHz]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Switches - more switches added for Project 3 requirements
set_property PACKAGE_PIN V17 [get_ports {SWITCH[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[0]}]
set_property PACKAGE_PIN V16 [get_ports {SWITCH[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[1]}]
set_property PACKAGE_PIN W16 [get_ports {SWITCH[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[2]}]
set_property PACKAGE_PIN W17 [get_ports {SWITCH[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[3]}]
set_property PACKAGE_PIN W15 [get_ports {SWITCH[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[4]}]
set_property PACKAGE_PIN V15 [get_ports {SWITCH[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[5]}]
set_property PACKAGE_PIN W14 [get_ports {SWITCH[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[6]}]
set_property PACKAGE_PIN W13 [get_ports {SWITCH[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[7]}]
set_property PACKAGE_PIN V2 [get_ports {SWITCH[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[8]}]
set_property PACKAGE_PIN T3 [get_ports {SWITCH[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[9]}]
set_property PACKAGE_PIN T2 [get_ports {SWITCH[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[10]}]
set_property PACKAGE_PIN R3 [get_ports {SWITCH[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[11]}]
set_property PACKAGE_PIN W2 [get_ports {SWITCH[12]}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[12]}]
set_property PACKAGE_PIN U1 [get_ports {SWITCH[13]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[13]}]
set_property PACKAGE_PIN T1 [get_ports {SWITCH[14]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[14]}]    
	
# SW15
set_property PACKAGE_PIN R2 [get_ports {Reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Reset}]
	
## Buttons - added for Project 3 requirements
set_property PACKAGE_PIN U18 [get_ports {Button}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Button}]
 
## VGA Connector
set_property PACKAGE_PIN G19 [get_ports {RED[0]}]				
    set_property IOSTANDARD LVCMOS33 [get_ports {RED[0]}]
set_property PACKAGE_PIN H19 [get_ports {RED[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RED[1]}]
set_property PACKAGE_PIN J19 [get_ports {RED[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RED[2]}]
set_property PACKAGE_PIN N19 [get_ports {RED[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {RED[3]}]
set_property PACKAGE_PIN N18 [get_ports {BLUE[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {BLUE[0]}]
set_property PACKAGE_PIN L18 [get_ports {BLUE[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {BLUE[1]}]
set_property PACKAGE_PIN K18 [get_ports {BLUE[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {BLUE[2]}]
set_property PACKAGE_PIN J18 [get_ports {BLUE[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {BLUE[3]}]
set_property PACKAGE_PIN J17 [get_ports {GREEN[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {GREEN[0]}]
set_property PACKAGE_PIN H17 [get_ports {GREEN[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {GREEN[1]}]
set_property PACKAGE_PIN G17 [get_ports {GREEN[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {GREEN[2]}]
set_property PACKAGE_PIN D17 [get_ports {GREEN[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {GREEN[3]}]
set_property PACKAGE_PIN P19 [get_ports HS]						
	set_property IOSTANDARD LVCMOS33 [get_ports HS]
set_property PACKAGE_PIN R19 [get_ports VS]						
	set_property IOSTANDARD LVCMOS33 [get_ports VS]

# End of VGAStart_Basys3Pins.xdc
