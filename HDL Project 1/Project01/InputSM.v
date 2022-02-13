// InputSM.v
//
// This is the controller for the datapath represented by the
// original SimpleSend.v from Dr. Wright, EE4490, Fall 2019.

module InputSM(newGo,newSW,Go,Up,Down,Left,Right,Ready2Go,clk,reset,sw,speedIn,hexVal);
	output reg		 newGo;
	output [119:0]	 newSW;
	input			 Go, Up, Down, Left, Right, Ready2Go, clk, reset;
	input [15:4]	 sw;
	input [2:0]      speedIn;
	output reg [7:0] hexVal;



	reg [2:0]	S, nS;
	parameter	SWAIT=3'b000,SGO=3'b001,SUP=3'b010,SDOWN=3'b011,
				SLEFT=3'b100,SRIGHT=3'b101,SDEBOUNCE=3'b110;
	
	reg [2:0]	speed, nSpeed;
	
	reg [30:0]	Count, nCount, maxCount, nMaxCount;
	
	reg [119:0]	theReg, nTheReg, defaultReg;

	reg [1:0]	oldS, nOldS;
	
	reg [3:0]	position, nPosition;

	reg [7:0]	nHexVal;
	

	
	always @(posedge clk)
		S <= reset ? SWAIT:nS;
		
	always @(posedge clk)
		if(reset)
			speed <= 3'b000;
		else if(hexVal==8'hF0)
			speed <= speedIn;
		else
			speed <= speed;
		
	always @(posedge clk)
		maxCount <= nMaxCount;

	always @(posedge clk)
		Count <= reset ? 0:nCount;

	always @(posedge clk)
        oldS <= reset ? 2'b00:nOldS;

	always @(posedge clk)
		defaultReg <= {5{sw[15:12],4'h0,sw[11:8],4'h0,sw[7:4],4'h0}};
		
	always @(posedge clk)
		theReg <= reset ? defaultReg:nTheReg;
		
	always @(posedge clk)
		position <= reset ? 4'h0:nPosition;
		
	always @(posedge clk)
		hexVal <= reset ? 8'h00:nHexVal;



	always @(*) // input state machine
		case(S)
			SWAIT:	if(Go&&Ready2Go)		 nS = SGO;
					else if(Up&&Ready2Go)	 nS = SUP;
					else if(Down&&Ready2Go)	 nS = SDOWN;
					else if(Left&&Ready2Go)	 nS = SLEFT;
					else if(Right&&Ready2Go) nS = SRIGHT;
					else			         nS = SWAIT;
			SGO:	if(Go)			nS = SGO;
                    else if(Up)     nS = SUP;
                    else if(Down)   nS = SDOWN;
                    else if(Left)   nS = SLEFT;
                    else if(Right)  nS = SRIGHT;
                    else            nS = SDEBOUNCE;
			SUP:	if(Go)			nS = SDEBOUNCE;
					else if(Down)	nS = SDOWN;
					else if(Left)	nS = SLEFT;
					else if(Right)	nS = SRIGHT;
					else			nS = SUP;
            SDOWN:	if(Go)			nS = SDEBOUNCE;
                    else if(Up)     nS = SUP;
                    else if(Left)   nS = SLEFT;
					else if(Right)	nS = SRIGHT;
                    else            nS = SDOWN;
			SLEFT:	if(Go)			nS = SDEBOUNCE;
					else if(Up)	    nS = SUP;
					else if(Down) 	nS = SDOWN;
					else if(Right)	nS = SRIGHT;
					else			nS = SLEFT;
			SRIGHT:	if(Go)			nS = SDEBOUNCE;
                    else if(Up)     nS = SUP;
                    else if(Down)   nS = SDOWN;
                    else if(Left)   nS = SLEFT;
                    else            nS = SRIGHT;
			SDEBOUNCE: nS = Go||Up||Down||Left||Right ? SDEBOUNCE:SWAIT;
			default: nS = SWAIT;
		endcase

	always @(*) // set maxCount for effects speed
		if(S==SWAIT)
			case(speed)
				3'b000: nMaxCount = 50000000;
				3'b001: nMaxCount = 40000000;
				3'b010: nMaxCount = 20000000;
				3'b011: nMaxCount = 10000000;
				3'b100: nMaxCount = 8000000;
				3'b101: nMaxCount = 7000000;
				3'b110: nMaxCount = 5000000;
				3'b111: nMaxCount = 4000000;
				default: nMaxCount = maxCount;
			endcase
		else nMaxCount = maxCount;

	always @(*) // counter for effects
		case(S)
			SWAIT:	nCount = 0;
			SGO:	nCount = 0;
			SUP:	nCount = Count==maxCount||Up ? 0:Count+1;
			SDOWN:	nCount = Count==maxCount||Down ? 0:Count+1;
			SLEFT:	nCount = Count==maxCount||Left ? 0:Count+1;
			SRIGHT:	nCount = Count==maxCount||Right ? 0:Count+1;
			default: nCount = 0;
		endcase
		
	always @(*) // Meally output to SSStateMachine.v
		case(S)
			SWAIT:	newGo = 1'b0;
			SGO:	newGo = Go ? 1'b1:1'b0;
			SUP:	newGo = Count==0||Up ? 1'b1:1'b0;
			SDOWN:	newGo = Count==0||Down ? 1'b1:1'b0;
			SLEFT:	newGo = Count==0||Left ? 1'b1:1'b0;
			SRIGHT:	newGo = Count==0||Right ? 1'b1:1'b0;
			default: newGo = 1'b0;
		endcase
		
	always @(*) // set old state
		case(S)
			SWAIT:	nOldS = oldS;
			SGO:	if(Go)
						nOldS = 2'b01;
					else
						nOldS = oldS;
			SUP:	if(Up&&(oldS==2'b00))
						nOldS = 2'b01;
					else
						nOldS = oldS;
			SDOWN:	if(Down&&(oldS==2'b00))
						nOldS = 2'b01;
                    else
                        nOldS = oldS;
			SLEFT:	if(Left&&(oldS==2'b00))
						nOldS = 2'b10;
					else if(Left&&(oldS==2'b01))
						nOldS = 2'b10;
                    else
                        nOldS = oldS;
			SRIGHT:	if(Right&&(oldS==2'b00))
						nOldS = 2'b10;
					else if(Right&&(oldS==2'b01))
						nOldS = 2'b10;
                    else
                        nOldS = oldS;
			default: nOldS = oldS;
		endcase
			
	always @(*) // set 120 bit output
		case(S)
			SWAIT:	nTheReg = theReg;
			SGO:	if(Go)
						nTheReg = defaultReg;
					else
						nTheReg = theReg;
			SUP:	if(Up&&(oldS==2'b00))
			            nTheReg = defaultReg;
			        else if(Count==0&&Ready2Go)
                        nTheReg = {theReg[118:96],theReg[119],theReg[94:72],theReg[95],theReg[70:48],
                                   theReg[71],theReg[46:24],theReg[47],theReg[22:0],theReg[23]};
					else
						nTheReg = theReg;
			SDOWN:	if(Down&&(oldS==2'b00))
                        nTheReg = defaultReg;
                    else if(Count==0&&Ready2Go)
                        nTheReg = {theReg[96],theReg[119:97],theReg[72],theReg[95:73],theReg[48],
                                   theReg[71:49],theReg[24],theReg[47:25],theReg[0],theReg[23:1]};
                    else
                        nTheReg = theReg;
			SLEFT:	if(Left&&(oldS==2'b00))
                        nTheReg = {{4{sw[15:12],4'h0,sw[11:8],4'h0,sw[7:4],4'h0}},
                                   {sw[11:8],4'h0,sw[7:4],4'h0,sw[15:12],4'h0}};
					else if(Left&&(oldS==2'b01))
                        nTheReg = {theReg[119:24],theReg[15:0],theReg[23:16]};
                    else if(Count==0&&Ready2Go)
                        nTheReg = {theReg[95:0],theReg[119:96]};
                    else
                        nTheReg = theReg;
			SRIGHT:	if(Right&&(oldS==2'b00))
                        nTheReg = {{sw[11:8],4'h0,sw[7:4],4'h0,sw[15:12],4'h0},
                                   {4{sw[15:12],4'h0,sw[11:8],4'h0,sw[7:4],4'h0}}};
					else if(Right&&(oldS==2'b01))
                        nTheReg = {theReg[111:96],theReg[119:112],theReg[95:0]};
                    else if(Count==0&&Ready2Go)
                        nTheReg = {theReg[23:0],theReg[119:24]};
                    else
                        nTheReg = theReg;
			default: nTheReg = theReg;
		endcase
		
	always @(*) // game position
		case(S)
			SWAIT:	nPosition = position;
			SGO:	nPosition = 3'b000;
			SUP:	nPosition = position;
			SDOWN:	nPosition = position;
			SLEFT:	if(Left&&(oldS==2'b00))
                        nPosition = 3'b101;
					else if(Left&&(oldS==2'b01))
                        nPosition = 3'b101;
                    else if(Count==0&&Ready2Go)
                        nPosition = position==3'b001 ? 3'b101:position-1;
                    else
                        nPosition = position;
			SRIGHT:	if(Right&&(oldS==2'b00))
                        nPosition = 3'b001;
					else if(Right&&(oldS==2'b01))
                        nPosition = 3'b001;
                    else if(Count==0&&Ready2Go)
                        nPosition = position==3'b101 ? 3'b001:position+1;
                    else
                        nPosition = position;
			default: nPosition = position;
		endcase

	always @(*) // set output to 7 segment displays
		case(speed)
			3'b000:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01; // 1
						3'b010: nHexVal = 8'h02; // 2
						3'b011: nHexVal = 8'h03; // 3
						3'b100: nHexVal = 8'h02; // 2
						3'b101: nHexVal = 8'h01; // 1
						default: nHexVal = hexVal;
					endcase
			3'b001:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01;
						3'b010: nHexVal = 8'h02;
						3'b011: nHexVal = 8'h04; // 4
						3'b100: nHexVal = 8'h02;
						3'b101: nHexVal = 8'h01;
						default: nHexVal = hexVal;
					endcase
			3'b010:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01;
						3'b010: nHexVal = 8'h02;
						3'b011: nHexVal = 8'h05; // 5
						3'b100: nHexVal = 8'h02;
						3'b101: nHexVal = 8'h01;
						default: nHexVal = hexVal;
					endcase
			3'b011:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01;
						3'b010: nHexVal = 8'h02;
						3'b011: nHexVal = 8'h06; // 6
						3'b100: nHexVal = 8'h02;
						3'b101: nHexVal = 8'h01;
						default: nHexVal = hexVal;
					endcase
			3'b100:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01;
						3'b010: nHexVal = 8'h02;
						3'b011: nHexVal = 8'h07; // 7
						3'b100: nHexVal = 8'h02;
						3'b101: nHexVal = 8'h01;
						default: nHexVal = hexVal;
					endcase
			3'b101:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01;
						3'b010: nHexVal = 8'h02;
						3'b011: nHexVal = 8'h08; // 8
						3'b100: nHexVal = 8'h02;
						3'b101: nHexVal = 8'h01;
						default: nHexVal = hexVal;
					endcase
			3'b110:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01;
						3'b010: nHexVal = 8'h02;
						3'b011: nHexVal = 8'h09; // 9
						3'b100: nHexVal = 8'h02;
						3'b101: nHexVal = 8'h01;
						default: nHexVal = hexVal;
				    endcase
			3'b111:	case(position)
                        3'b000: nHexVal = (S==SUP)||(S==SDOWN) ? 8'h00:8'hF0; // 0 or GO
						3'b001: nHexVal = 8'h01;
						3'b010: nHexVal = 8'h02;
						3'b011: nHexVal = 8'h10; // 10
						3'b100: nHexVal = 8'h02;
						3'b101: nHexVal = 8'h01;
						default: nHexVal = hexVal;
					endcase					
			default: nHexVal = hexVal;
		endcase
	
    assign	newSW = theReg; // Moore output to ShiftRegister.v
		
endmodule
