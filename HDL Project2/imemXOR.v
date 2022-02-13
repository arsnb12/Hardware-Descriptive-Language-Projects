// imemXOR.v
// Very simple instruction memory for ARM single-cycle model.
// "Digital Design and Computer Architecture ARM EDITION," S.L. Harris and D.M. Harris.
// EE 4490 adapted from code by Jerry C. Hamann

module imemXOR(RD,A);
  output  [31:0]  RD;
  input   [31:0]  A;

  reg     [31:0]  RD;

  always @(A)
    case(A[5:2])
      4'b0000: RD = 32'hE202_2000;  //      AND  R2,R2,#0
	  4'b0001: RD = 32'hE382_3005;  //      ORR R3,R2,#5
	  4'b0010: RD = 32'hE383_4005;  //      ORR R4,R3,#5
	  4'b0011: RD = 32'hE022_2004;  //      EOR R2,R4
    endcase
endmodule