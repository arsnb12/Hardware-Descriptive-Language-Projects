// SimpleSend.v
// Top-level module for WS2812B LED strip
// Very basic design, sends same color to all modules
// Updated to support new WS2812B reset code of > 280 us
//
// Modules InputSM, Hex27Seg, and Mux4Machine added to
// add functionality up to Project 1 level 4.

module SimpleSend(dataOut,sw,speed,Go,Up,Down,Left,Right,clk,reset,Ready2Go,Leds,adrive);
	output		 dataOut, Ready2Go;
	input [15:4] sw;
	input [2:0]	 speed;
	input		 Go, Up, Down, Left, Right, clk, reset;

	output [0:6] Leds;
	output [3:0] adrive;

	wire	     shipGRB, Done, allDone;
	wire [1:0]   qmode;
	wire	     LoadGRBPattern, ShiftPattern, StartCoding, ClrCounter, IncCounter,
				 theBit, bdone;
	wire [7:0]   Count;
	wire	     newGo;
	wire [119:0] newSW;
	wire [7:0]   hexVal;
	wire [3:0]   muxd;

	InputSM			insm(newGo,newSW,Go,Up,Down,Left,Right,Ready2Go,clk,reset,sw,speed,hexVal);
	Hex27Seg        hex(Leds,muxd);
	Mux4Machine     mux(muxd,adrive,hexVal[7:4],hexVal[3:0],4'h0,4'h0,clk,reset,4'h3);



	SSStateMachine	sssm(shipGRB,Done,newGo,clk,reset,allDone,Ready2Go);
	GRBStateMachine grbsm(qmode,Done,LoadGRBPattern,ShiftPattern,StartCoding,ClrCounter,
						  IncCounter,shipGRB,theBit,bdone,Count,3'b101,clk,reset,allDone);
	ShiftRegister   shftr(theBit,newSW,LoadGRBPattern,ShiftPattern,clk,reset);
	BitCounter	    btcnt(Count,ClrCounter,IncCounter,clk,reset);
	NZRbitGEN	    nzrgn(dataOut,bdone,qmode,StartCoding,clk,reset);
	
endmodule
