// GRBStateMachine.v
// Output qmode tells the NZRbitGEN module whether to send a 0, 1, or RESET
// Updated to support new WS2812B reset code of > 280 us
// bdone ticks every bit period (1.28 us)
// RESET is > 280 us, use 281000 clks = 281 us

module GRBStateMachine(qmode,Done,LoadGRBPattern,ShiftPattern,StartCoding,
					   ClrCounter,IncCounter,ShipGRB,theBit,bdone,Count,NumLEDs,
					   clk,reset,allDone);
	output [1:0] qmode;
	output		 allDone, Done, LoadGRBPattern, ShiftPattern, StartCoding, ClrCounter,
				 IncCounter;
	input		 ShipGRB, theBit, bdone;
	input [7:0]	 Count;
	input [3:1]  NumLEDs;
	input		 clk, reset;
  
	reg			S, nS;
	parameter	SSHIPRET=1'b0, SSHIPGRB=1'b1;

	reg	[7:0]	COMPAREVAL;
	reg	[14:0]	rCount;  // counter for RESET time

	always @(posedge clk)
		if(reset)
			S <= SSHIPRET;
		else
			S <= nS;

	always @(*)
		case(S)
			SSHIPRET:  nS = ShipGRB ? SSHIPGRB:SSHIPRET;
			SSHIPGRB:  nS = (bdone && (Count==COMPAREVAL)) ? SSHIPRET:SSHIPGRB;
			default:   nS = SSHIPRET;
		endcase

	assign LoadGRBPattern = (S==SSHIPRET)&&ShipGRB;
	assign ClrCounter     = (S==SSHIPRET)&&ShipGRB;
	assign StartCoding    = (S==SSHIPRET)&&ShipGRB;
	assign ShiftPattern   = (S==SSHIPGRB)&&bdone;
	assign IncCounter     = (S==SSHIPGRB)&&bdone;
	assign qmode          = (S==SSHIPRET) ? 2'b10:{1'b0,theBit};
	assign Done           = (S==SSHIPGRB)&&bdone&&(Count==COMPAREVAL);
	assign allDone        = (S==SSHIPRET)&&(rCount==15'd28100); // 281 us

//	assign allDone  = (S==SSHIPRET)&&(rCount==15'd3000); // for testing only  

	always @(*)
		case(NumLEDs) // how many LED modules?
			3'b001:  COMPAREVAL = 23;  // 1*24 = 24 bits
			3'b010:  COMPAREVAL = 47;  // 2*24 = 48 bits
			3'b011:  COMPAREVAL = 71;  // 3*24 = 72 bits
			3'b100:  COMPAREVAL = 95;  // 4*24 = 96 bits
			3'b101:  COMPAREVAL = 119; // 5*24 = 120 bits
			default: COMPAREVAL = 23;  // default to one module
		endcase

	always @(posedge clk)
		// counts time for RESET, 10 ns per tick
		begin
			if(reset || Done) // Done sending bits, start RESET
				rCount <= 0;
			else if (S==SSHIPRET)
				rCount <= rCount+1; 
			else
				rCount <= rCount;
		end
 
endmodule

