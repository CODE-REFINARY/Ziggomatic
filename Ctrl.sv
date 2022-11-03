// Project Name:   CSE141L
// Module Name:    Ctrl
// Create Date:    ?
// Last Update:    2022.01.13

// control decoder (combinational, not clocked)
// inputs from ... [instrROM, ALU flags, ?]
// outputs to ...  [program_counter (fetch unit), ?]
import Definitions::*;

// n.b. This is an example / starter block
//      Your processor **will be different**!
module Ctrl (
  input  [8:0] Instruction,    // machine code
  input  ZeroFlag,
                               // some designs use ALU inputs here
  output logic       Jump,
                     BranchEn, // branch at all?
                     RegWrEn,  // write to reg_file (common)
                     MemWrEn,  // write to mem (store only)
					 MemREn,   // read data mem
                     LoadInst, // mem or ALU to reg_file ?
                     Ack,      // "done with program"
					 LUTSel,   // get output from JMP or MEM LUT
					 RegImm,   // operand 2 is an immediate or register?
					 ImmLut,   // output from LUT or immediate instruction field
					 AluOrLut, // 
					 MemOrJmpLut//,
					 //AluOrPar
);

always_comb begin
  // Specify RegWrEn logic
  case (Instruction[8:5])
	BNE: RegWrEn = 'b0;	// don't write on BNE
	//JMP: RegWrEn = 'b0; 	// don't write on jump
	SW0: RegWrEn = 'b0; 	// don't write on SW
	default: RegWrEn = 'b1;
  endcase
  
  //AluOrPar = ~(Instruction[8:5] == PAR);


  BranchEn = (~ZeroFlag) && (Instruction[8:5] == BNE);

  // Get output from mem LUT for bit 1 being 1 in SET
  MemOrJmpLut = Instruction[1] == 1'b1;

  // Enable LUT access only for SET
  AluOrLut = ~(Instruction[8:5] == SET);
  
  // Enable memory writes only for SW0
  MemWrEn = Instruction[8:5] == SW0;
  
  // Only read datamem during a load word
  MemREn = Instruction[8:5] == LW0;

  // Enable memory loads only for LW0
  LoadInst = Instruction[8:5] == LW0;
  
  // select the immediate field instead of register value whenever instruction isn't an R-type
  RegImm = ~(Instruction[8:7] == 2'b0 || Instruction[8:5] == BNE);
  
  // get immediate value from LUT only for SET
  ImmLut = Instruction[8:5] == SET;

  // reserve instruction = 9'b111111111; for Ack
  Ack = &Instruction;
end

endmodule
