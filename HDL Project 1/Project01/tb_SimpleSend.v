// tb_SimpleSend.v
// test bench for WS2812B LED strip driver
// VERY basic design, sends same color to all modules

`timescale 1ns/1ns
module tb_SimpleSend;
	wire	dataOut;
	reg   [15:4] sw;
	reg   [3:1]  NumLEDs;
	reg 	Go, clk, reset;

	wire		shipGRB, Done, allDone, Ready2Go;
	wire [1:0]	qmode;
	wire		LoadGRBPattern, ShiftPattern, StartCoding, ClrCounter, IncCounter, theBit, bdone;
	wire [7:0]	Count;

	SSStateMachine	sssm(shipGRB,Done,Go,clk,reset,allDone,Ready2Go);
	GRBStateMachine grbsm(qmode,Done,LoadGRBPattern,ShiftPattern,StartCoding,ClrCounter,IncCounter,
                              shipGRB,theBit,bdone,Count,NumLEDs,clk,reset,allDone);
	ShiftRegister   shftr(theBit,sw,LoadGRBPattern,ShiftPattern,clk,reset);
	BitCounter	btcnt(Count,ClrCounter,IncCounter,clk,reset);
	NZRbitGEN	nzrgn(dataOut,bdone,qmode,StartCoding,clk,reset);
  
  always // Note:  1/100M = 10E-9
    #5 clk = !clk;

  initial begin
    $dumpfile("tb_SimpleSend.vcd");
    $dumpvars(0,tb_SimpleSend);
    clk=0; reset=1; Go=0; 
    NumLEDs=3'b001;  // number of LED modules
    sw=12'h4A9;  // arbitrary setting for bits set to all modules
    #20 reset=0; 
  // reset is 281,000 ns
  // bits are 1,280 ns each, or 30,720 ns per module
  // that's 311,720 ns for just one module
  #315000 $finish;
   end  
  
  initial begin
    #40  Go=1;   // press Go button
    #80  Go=0;   // release Go button
     
  end  
endmodule
