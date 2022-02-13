// VGAStart.v - Top level module for example VGA driver implementation in Verilog
// 
// UW EE4490 Fall 2019
// 
// Adapted from original code by Jerry C. Hamann.
// 
// Edited by Luke Cloud and Moteeb Albaqami to obtain requirements for Project 3.


module FirstVGA(VS,HS,RED,GREEN,BLUE,SWITCH,CLK_100MHz,Reset,Button);
    output      	VS, HS; 
    output [3:0]    RED, GREEN, BLUE;
    input  [14:0]	SWITCH;
    input           CLK_100MHz, Reset, Button;
    
    wire            HBlank, VBlank;
    wire   [10:0]   CurrentX, CurrentY;

    // Connect to driver of VGA signals
    VGALLDriver vgadll(.VS(VS),.HS(HS),.VBlank(VBlank),.HBlank(HBlank),
                       .CurrentX(CurrentX),.CurrentY(CurrentY), 
                       .CLK_100MHz(CLK_100MHz),.Reset(Reset));
   
    // Connect to "client" which produces pixel color based on (X,Y) location
	// Button and Reset inputs added for Project 3 requirements
    VGAClient   vgacl(.RED(RED),.GREEN(GREEN),.BLUE(BLUE),
                      .CurrentX(CurrentX),.CurrentY(CurrentY),.VBlank(VBlank),.HBlank(HBlank),
                      .SWITCH(SWITCH),.CLK_100MHz(CLK_100MHz),.Button(Button),.Reset(Reset));
endmodule
