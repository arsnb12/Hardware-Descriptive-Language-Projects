// TopLevelSCUWARM.v
// Jerry Hamann
// EE 4490 Fall 2017

module TopLevelSCUWARM(sevenSegmentsa2g,anodeDrives,theReg,TopHalf,PushButton,RegView,clk,reset);
  output [0:6]    sevenSegmentsa2g;
  output [3:0]    anodeDrives;
  input  [3:0]    theReg;
  input           TopHalf, PushButton, RegView, clk, reset;

  wire   [31:0]   theRegVal,Inst;
  wire   [3:0]    the7SegVal;
  wire   [3:0]    setA, setB, setC, setD;

  SingleCycleProcessor    scpuw(.DBtheRegVal(theRegVal),.Instr(Inst),.DBtheReg(theReg),.clk(PushButton),.reset(reset));
  Mux4Machine             mux4m(.muxd(the7SegVal),.adrive(anodeDrives),.A(setA),.B(setB),
                                .C(setC),.D(setD),.clk(clk),.reset(reset),.blank(4'b0000));
  Hex27Seg                hx27s(.Leds(sevenSegmentsa2g),.HexVal(the7SegVal));

  assign  setA = RegView ? (TopHalf ? theRegVal[31:28] : theRegVal[15:12]) :
                     (TopHalf ? Inst[31:28] : Inst[15:12]);
  assign  setB = RegView ? (TopHalf ? theRegVal[27:24] : theRegVal[11:8]) :
                     (TopHalf ? Inst[27:24] : Inst[11:8]);
  assign  setC = RegView ? (TopHalf ? theRegVal[23:20] : theRegVal[7:4]) :
                     (TopHalf ? Inst[23:20] : Inst[7:4]);
  assign  setD = RegView ? (TopHalf ? theRegVal[19:16] : theRegVal[3:0]) :
                     (TopHalf ? Inst[19:16] : Inst[3:0]);
endmodule
