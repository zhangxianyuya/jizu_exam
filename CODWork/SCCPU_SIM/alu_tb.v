
module alu_tb();
  reg  [31:0] A, B;
  reg  [2:0]  ALUOp;
  wire [31:0] C;
  wire Zero;

  // instantiate device under test
  alu dut(
  .A(A), .B(B), .ALUOp(ALUOp), .C(C), .Zero(Zero)
  );
 
// ALU control signal
// ALU_NOP   3'b000 
// ALU_ADD   3'b001
// ALU_SUB   3'b010 
// ALU_AND   3'b011
// ALU_OR    3'b100
// ALU_SLT   3'b101
// ALU_SLTU  3'b110

  // apply inputs one at a time
  initial begin
    A = 32'hA0; B = 32'h0A; ALUOp = 3'b001; #10; // A+B 0xA0 + 0x0A
    ALUOp = 3'b010; #10;                         // A-B 0xA0 - 0x0A
    B = 32'hA0; #10;                             // A-B 0xA0 - 0xA0
  end
  
endmodule

