// Module Name:    ALU
// Project Name:   CSE141L
//
// Additional Comments:
//   combinational (unclocked) ALU

// includes package "Definitions"
import Definitions::*;

module ALU #(parameter W=8, Ops=4)(
  input        [W-1:0]   InputA,     // data inputs
                         InputB,
  input        [Ops-1:0] OP,         // ALU opcode, part of microcode
  output logic [W-1:0]   Out,        // data output
  output logic           ZER0,        // output = zero flag    !(Out)
  output logic           PAR0        // out parity flag        ^(Out)
									 // you may provide additional status flags, if desired
);

op_mne op_mnemonic;

always_comb begin
  // No Op = default
  Out = 0;
  op_mnemonic = op_mne'(OP);
  
  
  case(OP)
    ADD : Out = InputA + InputB;        // add
	ADI : Out = InputA + InputB;		// add InputA to a 2 bit immediate
    AND : Out = InputA & InputB;        // bitwise AND
    OR0 : Out = InputA | InputB;        // bitwise AND
    XOR : Out = InputA ^ InputB;        // bitwise exclusive OR
	BNE : Out = InputA - InputB;		// subtract
	SLL : Out = InputA << InputB;		// logical left shift by InputB # of bits		WE ARE NOT BARREL SHIFTING
	SRL : Out = InputA >> InputB;		// logical right shift by InputB # of bits		WE ARE NOT BARREL SHIFTING
	/*NOT : Out = ~InputA;				// bitwise NOT*/
	ZER : Out = 8'h00;					// wire the output to zero
	PAR : Out = ^InputA;
	MOL : Out = InputA;
	MOU : Out = InputA;
    default : Out = 8'bxxxx_xxxx;       // Quickly flag illegal ALU
  endcase

  ZER0 = ~|Out;                     // reduction NOR		1 only if every bit of Out is zero
  PAR0 = ^Out;                      // reduction XOR		1 only if there's an odd # of 1s in Out
end

endmodule
