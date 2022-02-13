// VGAClient.v - Example VGA color computation client
// 
// UW EE4490 Fall 2019
// 
// Adapted from original code by Jerry C. Hamann.
// 
// Edited by Luke Cloud and Moteeb Albaqami to obtain requirements for Project 3.
// Computes the desired color at pix (X,Y) and must do this fast. Colors are
// defined to produce a solitary game in which the user must deflect a square
// icon with a rectanular bar. The purpose of the game is to prevent the icon
// from passing the bar and touching the bottom of the defined game area. The
// color of the icon, bar, border, and background can be changed with switches.
// The speed and direction of the bar can also be changed with switches, as
// well as the speed of the icon.
// 

module VGAClient(RED,GREEN,BLUE,CurrentX,CurrentY,VBlank,HBlank,
                 SWITCH,CLK_100MHz,Button,Reset);
    output reg	[3:0]	RED, GREEN, BLUE;
    input		[10:0]	CurrentX, CurrentY;
    input				VBlank, HBlank;
    input		[14:0]	SWITCH;
    input				CLK_100MHz;
    input				Button; // Button input added to start game
	input				Reset; // Added to reset bar and icon positions



	// Go variable used to define a default state at the start of each game
    reg Go = 0;
	
	// Go variable reset at Reset and loss of a game
	always @(posedge CLK_100MHz)
		if(Reset)
			Go <= 0;
		else if(Button && !Go)
			Go <= 1;
		else if(move_top && shape_top == 500)
		    Go <= 0;
		else
			Go <= Go;
			
			

	// Variables created to define the bar
	parameter BAR_WIDTH = 150;
	
	reg  [10:0] bar_left  = 325;
	wire [10:0] bar_right = bar_left + BAR_WIDTH;
	
	reg [10:0] bar_top	  = 498;
	reg [10:0] bar_bottom = 479;	
	
	// Variable created to change the speed of the bar with switch inputs
	wire [2:0] bar_speed;
	assign bar_speed = SWITCH[3:2] + 1;
	
	// Timers created to change the speed of the bar
	reg [29:0] bar_timer = 0;
	reg		   bar_one_sec_timer = 0;
	
	always @(posedge CLK_100MHz)
		bar_timer <= (Reset || bar_timer == 500000 - bar_speed * 85000) ? 0:bar_timer + 1;
		
	always @(posedge CLK_100MHz)
		bar_one_sec_timer <= (bar_timer == 500000 - bar_speed * 85000) ? 1:0;

	// Determining the left position of the bar
	always @(posedge bar_one_sec_timer)
		if(Go)
			if(SWITCH[0])
				bar_left <= bar_left;
			else if(SWITCH[1])
				bar_left <= (bar_right < 698) ? bar_left + 1:bar_left; 
			else 
				bar_left <= (bar_left > 102) ? bar_left - 1:bar_left; 
		else
			bar_left <= 325;



	// Variables created to define the icon
	parameter WIDTH  = 20;
	parameter HEIGHT = 20; 
	
	reg  [10:0] shape_left	= 390;
	wire [10:0] shape_right	= shape_left + WIDTH;

	reg  [10:0] shape_bottom = 458;
	wire [10:0] shape_top	 = shape_bottom + HEIGHT;
	
	reg move_right = 0;
	reg move_top   = 0;

	// Variable created to change the speed of the icon with switch inputs	
	wire [2:0] speed;
	assign speed = SWITCH[5:4] + 1;
	
	// Timers created to change the speed of the icon
	reg [29:0] timer = 0;
	reg		   one_sec_timer = 0;
	
	always @(posedge CLK_100MHz)
		timer <= (Reset || timer == 500000-speed*75000) ? 0:timer + 1;
		
	always @(posedge CLK_100MHz)
		one_sec_timer <= (timer == 500000-speed*75000) ? 1:0;	

	// Determining the left and bottom positions of the icon
	always @(posedge one_sec_timer)
		if(Go) begin			
			if(move_right) begin
				shape_left <= shape_left + 1; 
				move_right <= (shape_right == 700) ? 0:1; end
			else begin
				shape_left <= shape_left - 1;
				move_right <= (shape_left == 100) ? 1:0; end
			
			if(move_top) begin
				shape_bottom <= shape_bottom + 2;
				if(shape_top == 480 && shape_right >= bar_left &&
				   shape_left <= bar_right)
					move_top <= 0;
				else if(shape_top == 500)
					move_top <= 0;
				else
					move_top <= 1; end
			else begin
				shape_bottom <= shape_bottom - 2;
				move_top <= (shape_bottom == 100) ? 1:0; end
		end
		else begin
			shape_left <= 390;
			shape_bottom <= 456;
			move_right <= SWITCH[1];
		end
		
		

	// Setting game colors based on switch inputs
	wire [3:0] R = SWITCH[9] ? 4'hf:4'h0;
	wire [3:0] G = SWITCH[10] ? 4'hf:4'h0;
	wire [3:0] B = SWITCH[11] ? 4'hf:4'h0;
	
	wire [3:0] R_B = SWITCH[12] ? 4'h0:4'hf;
	wire [3:0] G_B = SWITCH[13] ? 4'h0:4'hf;
	wire [3:0] B_B = SWITCH[14] ? 4'h0:4'hf;	



	// Using switch inputs, defined boundries, and bar/shape limits to determine
	// color at pix (X,Y)
    always @(*)
        if(VBlank || HBlank)
            {RED,GREEN,BLUE} = 0; // Must drive colors only during non-blanking times.
        else 
			if((CurrentX >= shape_left && CurrentX <= shape_right) &&
			   (CurrentY >= shape_bottom && CurrentY <= shape_top))
				{RED,GREEN,BLUE} = {R,G,B};
			else if((CurrentX >= bar_left && CurrentX <= bar_right) &&
			        (CurrentY >= bar_bottom && CurrentY <= bar_top))
				{RED,GREEN,BLUE} = {R,G,B};
			else if(CurrentX < 100 || CurrentX > 700 || CurrentY < 100 || CurrentY > 500)
				{RED,GREEN,BLUE} = {R,G,B};
			else  
				{RED,GREEN,BLUE} = {R_B,G_B,B_B};
	
 endmodule