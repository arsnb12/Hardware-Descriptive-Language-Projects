// ShiftRegister.v
// Determines the 24-bit control word for an LED module
// Shifts it out one bit at a time
// Keeps sending the same 24 bits, so same color to all modules

module ShiftRegister(CurrentBit,sw,LoadRegister,RotateRegisterLeft,clk,reset);
	output			CurrentBit;
	input [119:0]	sw; // changed to support to support added functionality // [15:4] sw; 
	input			LoadRegister, RotateRegisterLeft;
	input			clk, reset;

	// default is now sw // parameter DEFAULTREG=24'h0F0F0F;  // white, half brightness

	reg [119:0]  TheReg, nTheReg; // , defaultReg;  // 24 bits for GRB control

	always @(posedge clk)
		TheReg <= reset ? sw:nTheReg;
	  
	// sw is now 120 bits from InputSM.v
	always @(TheReg, LoadRegister, RotateRegisterLeft, sw)
		if(LoadRegister)
			nTheReg = sw;
		else if(RotateRegisterLeft)
			nTheReg = {TheReg[118:0],TheReg[119]};
		else
			nTheReg = TheReg;

	assign  CurrentBit = TheReg[119];
endmodule
