// Project Name:   Ziggomatic
// Module Name:    Ctrl
// Create Date:    ?
// Last Update:    2022.11.23

// control decoder (combinational, not clocked)
// inputs from ... [instrROM, ALU flags, ?]
// outputs to ...  [program_counter (fetch unit), ?]
import Definitions::*;

module Ctrl (
  input           [8:0] Instruction,    // machine code
  input           ZeroFlag,
  output logic    Jump,
                  BranchEn,             // enable PC to change to jump 
                  RegWrEn,              // enable registers to be written to in the regfile
                  MemWrEn,              // enable data to be written to data memory
					        MemREn,               // enable reads from data memory
                  LoadInst,             // mem or ALU to reg_file ?
                  Ack,                  // bit signal that execution of the current program has terminated
					        LUTSel,               // select which LUT (memory or jump) to read from
					        RegImm,               // operand 2 is an immediate or register?
					        ImmLut,               // read a LUT or IMM value?
					        AluOrLut,             // read value from ALU or currently selected LUT?
					        MemOrJmpLut           // 
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
