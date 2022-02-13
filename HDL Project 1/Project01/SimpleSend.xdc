## SimpleSend.xdc
## EE4490 
## Modified from a previous version by Jerry Hamann
## XDC file for introductory GRB LED driver, assuming BASYS3
## with a Artix-7 FPGA (XC7A34T-1 CPG236C).
## Adapted from the Digilent-supplied file Basys3_Master.xdc
##
## Updated to include inputs for Project 1 level 4

## Clock signal (Generated on-board the Artix-7) 10 ns period (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Switches
# sw[0] for reset signal
set_property PACKAGE_PIN V17 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]

# sw[1-3] to specify speed for maxCount
set_property PACKAGE_PIN V16 [get_ports {speed[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {speed[0]}]
set_property PACKAGE_PIN W16 [get_ports {speed[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {speed[1]}]
set_property PACKAGE_PIN W17 [get_ports {speed[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {speed[2]}]
	
#sw[4-7] upper 4 bits of Blue byte, sw[7] is the MSB
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
	
#sw[8-11] upper 4 bits of Red byte, sw[11] is the MSB	
set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
	
#sw[12-15] upper 4 bits of Green byte, sw[15] is the MSB	
set_property PACKAGE_PIN W2 [get_ports {sw[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
set_property PACKAGE_PIN U1 [get_ports {sw[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
set_property PACKAGE_PIN T1 [get_ports {sw[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
set_property PACKAGE_PIN R2 [get_ports {sw[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]
 
## LEDs
# led0, to signify when it's okay to press a button again
set_property PACKAGE_PIN U16 [get_ports {Ready2Go}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Ready2Go}] 
 
## Button
# BTNC
    set_property PACKAGE_PIN U18 [get_ports {Go}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Go}]
    set_property PACKAGE_PIN T18 [get_ports {Up}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Up}]
    set_property PACKAGE_PIN U17 [get_ports {Down}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Down}]
    set_property PACKAGE_PIN T17 [get_ports {Right}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Right}]
    set_property PACKAGE_PIN W19 [get_ports {Left}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Left}]
		
## 7 segment display
set_property PACKAGE_PIN W7 [get_ports {Leds[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[0]}]
set_property PACKAGE_PIN W6 [get_ports {Leds[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[1]}]
set_property PACKAGE_PIN U8 [get_ports {Leds[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[2]}]
set_property PACKAGE_PIN V8 [get_ports {Leds[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[3]}]
set_property PACKAGE_PIN U5 [get_ports {Leds[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[4]}]
set_property PACKAGE_PIN V5 [get_ports {Leds[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[5]}]
set_property PACKAGE_PIN U7 [get_ports {Leds[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Leds[6]}]

## anode drive
set_property PACKAGE_PIN U2 [get_ports {adrive[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[0]}]
set_property PACKAGE_PIN U4 [get_ports {adrive[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[1]}]
set_property PACKAGE_PIN V4 [get_ports {adrive[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[2]}]
set_property PACKAGE_PIN W4 [get_ports {adrive[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {adrive[3]}]
	
###Pmod Header JA
##Sch name = JA1
# this is the data being sent to the LED strip
set_property PACKAGE_PIN J1 [get_ports {dataOut}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dataOut}]                    
	
## End of file SimpleSend.xdc
