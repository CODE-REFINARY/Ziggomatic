`timescale 1ns/ 1ps

// Test bench
// Arithmetic Logic Unit

//
// INPUT: A, B
// op: 000, A ADD B
// op: 100, A_AND B
// ...
// Please refer to definitions.sv for support ops (make changes if necessary)
// OUTPUT A op B
// equal: is A == B?
// even: is the output even?
//
import Definitions::*;

module ALU_tb;

// Define signals to interface with the ALU module
logic [ 7:0] INPUTA;  // data inputs
logic [ 7:0] INPUTB;
logic [ 3:0] op;      // ALU opcode, part of microcode
wire[ 7:0] OUT;
wire Zero;
wire Parity;

// store file handler
integer fd;
initial begin
	fd = $fopen("alu_transcript.txt", "w");
	$fdisplay(fd, "The test results for individual ALU operations are recorded below\n\n");
end

// Define a helper wire for comparison
logic [ 7:0] expected;

op_mne op_mnemonic;

// Instatiate and connect the Unit Under Test
ALU uut(
  .InputA(INPUTA),
  .InputB(INPUTB),
  .OP(op),
  .Out(OUT)
);


// The actual testbench logic
initial begin
  INPUTA = 1;
  INPUTB = 1;
  op= ADD; 	 // ADD
  test_alu_func; // void function call
  #5;

  INPUTA = 2;
  INPUTB = 1;
  op= AND; 	 // AND
  test_alu_func; // void function call
  #5;
  
  INPUTA = 4;
  INPUTB = 1;
  op= OR0; 	 // OR0
  test_alu_func; // void function call
  #5;
  
  INPUTA = 3;
  INPUTB = 3;
  op= XOR; 	 // XOR
  test_alu_func; // void function call
  #5;
  
  INPUTA = 6;
  INPUTB = 6;
  op= BNE; 	 // SUB - We are using subtract exclusively for BEQ. Therefore these two terms are used interchangeably
  test_alu_func; // void function call
  #5;

  INPUTA = 3;
  INPUTB = 3;
  op= SLL; 	 // Left Shift
  test_alu_func; // void function call
  #5;
  
  INPUTA = 15;
  INPUTB = 2;
  op= SRL; 	 // Right Shift
  test_alu_func; // void function call
  #5;
  
$fdisplay(fd, "End Of Report");
$fclose(fd);
end

task test_alu_func;
  op_mnemonic = op_mne'(op);
  case (op)
    ADD: expected = INPUTA + INPUTB;      // ADD
    AND: expected = INPUTA & INPUTB;	    // AND
    OR0: expected = INPUTA | INPUTB;      // OR
    XOR: expected = INPUTA ^ INPUTB;      // XOR
    BNE: expected = INPUTA - INPUTB;		// SUB
    SLL: expected = INPUTA << INPUTB;     // Logical Shift Left
	SRL: expected = INPUTA >> INPUTB;		// Logical Shift Right
  endcase
  #1;
  
  $fdisplay(fd, "Operation: %s, Opcode: %b", op_mnemonic.name(), op_mnemonic);
  
  if(expected == OUT) begin
	$fdisplay(fd, "VALID RESULT: inputs = %b %b, Output: %b, Zero %b, Parity %b", INPUTA, INPUTB, OUT, Zero, Parity);
  end else begin
	$fdisplay(fd, "INVALID RESULT: inputs = %b %b, Output: %b, Zero %b, Parity %b", INPUTA, INPUTB, OUT, Zero, Parity);
  end
	$fdisplay(fd, "\n\n");
endtask

initial begin
  $dumpfile("alu.vcd");
  $dumpvars();
  $dumplimit(104857600); // 2**20*100 = 100 MB, plenty.
end

endmodule
