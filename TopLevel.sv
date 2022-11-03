// Design Name:      CSE141L
// Module Name:      TopLevel

///////////////////////////////////////////////////////////////////////

/*							COMPILE TIME							 */

///////////////////////////////////////////////////////////////////////
import Definitions::*;

module TopLevel(
  input        Reset,      // init/reset, active high
               Start,      // start next program
               Clk,        // clock -- posedge used inside design
  output logic Ack         // done flag from DUT
);

// InstROM outputs
wire  [ 8:0] IR1_InstOut_out;  // the 9-bit opcode
logic  [ 8:0] Active_InstOut;   // the actual Inst being executed

// ProgCtr outputs
wire [ 9:0] PC1_ProgCtr_out;  // the program counter
logic		PC1_Going_out;	  // 1 if PC is ticking 0 otherwise
logic		forward;


// LUT outputs
wire [ 7:0] JMP_LUT_Target_out;  // Target of branch/jump
wire [ 7:0] MEM_LUT_Target_out;  // Target address in memory

// Control block outputs
logic       Ctrl1_Jump_out;      // to program counter: jump
logic       Ctrl1_BranchEn_out;  // to program counter: branch enable
logic       Ctrl1_RegWrEn_out;   // reg_file write enable
logic       Ctrl1_MemWrEn_out;   // data_memory write enable
logic		Ctrl1_MemREn_out;	 // data memory read enable
logic       Ctrl1_LoadInst_out;  // TODO: Why both of these?
logic       Ctrl1_Ack_out;       // Done with program?
logic		LUT_SEL;			 // Which LUT to get output from
logic		REG_IMM;			 // get second operand from regfile or immediate
logic		IMM_LUT;			 // get output from LUT or immediate instruction field
logic		ALU_OR_LUT;			 // regfile writes from either ALU or LUT
logic		MEM_OR_JMP_LUT;		 // access from jmp or mem LUT

// Register file outputs
logic [7:0] RF1_DataOutA_out; // Contents of first selected register
logic [7:0] RF1_DataOutB_out; // Contents of second selected register
logic [7:0] JMP_Target_out;

// LUT or immediate instruction field out
logic [7:0] IMM_or_LUT_out;		  // output from LUT or immediate instruction field

// ALU outputs
logic [7:0] ALU_OUT_out;	// actual output
logic [7:0] ALU_OR_Parity_out; // output into mux
logic       ALU_Zero_out;
logic       ALU_Parity_out;

// ALU inputs
logic [7:0] InA, InB;         	// ALU operand inputs
logic [3:0] OP;					// The op that the ALU is told to read

// Data Memory outputs
logic [7:0] DM1_DataOut_out;  // data out from data_memory

logic [ 7:0] MemJmp_Lut_out;	 // data from memory alu or jp alu
logic [ 7:0] ExLut_RegValue_out; // data from lut/alu out mux
logic [ 7:0] MemEx_RegValue_out; // data in to reg file

// Indicate which of the 8 registers to select for reading or writing
logic [ 2:0]RADDR_IN1;
logic [ 2:0]RADDR_IN2;
logic [ 2:0]WADDR_IN3;

// Count the total number of clock cycles
logic[15:0] CycleCount; 

// Instruction ROM
InstROM IR1(
  .InstAddress (PC1_ProgCtr_out),
  .InstOut     (IR1_InstOut_out)
);

// Program counter module
ProgCtr PC1 (
  .Reset       (Reset),              // reset to 0
  .Start       (Start),              // Your PC will have to do something smart with this
  .Clk         (Clk),                // System CLK
  .BranchRelEn (Ctrl1_BranchEn_out),     // jump enable
  .Target      (JMP_Target_out), 	 // "where to?" or "how far?" during a jump or branch
  .ProgCtr     (PC1_ProgCtr_out),     // program count = index to instruction memory
  .Going	   (PC1_Going_out),
  .forward	   (forward)
);

// Program 1 LUTs
jmpLUTProg1 jmpLUT(
  .Addr         (Active_InstOut[4:2]),
  .Target       (JMP_LUT_Target_out)
);

memLUTProg1 memLUT(
  .Addr         (Active_InstOut[4:2]),
  .Target       (MEM_LUT_Target_out)
);

/* Program 2 LUTs
jmpLUTProg2 jmpLUT(
  .Addr         (Active_InstOut[5:2]),
  .Target       (JMP_LUT_Target_out)
); 

memLUTProg2 memLUT(
  .Addr         (Active_InstOut[5:2]),
  .Target       (MEM_LUT_Target_out)
);
*/	
/* Program 3 LUTs
jmpLUTProg3 jmpLUT(
  .Addr         (Active_InstOut[5:2]),
  .Target       (JMP_LUT_Target_out)
);

memLUTProg3 memLUT(
  .Addr         (Active_InstOut[5:2]),
  .Target       (MEM_LUT_Target_out)
);
*/

// Decode = Control Decoder + Reg_file
Ctrl Ctrl1 (
  .Instruction  (Active_InstOut),     // from instr_ROM
  .ZeroFlag		(ALU_Zero_out),
  .Jump         (Ctrl1_Jump_out),     // to PC to handle jump/branch instructions
  .BranchEn     (Ctrl1_BranchEn_out), // to PC
  .RegWrEn      (Ctrl1_RegWrEn_out),  // register file write enable
  .MemWrEn      (Ctrl1_MemWrEn_out),  // data memory write enable
  .MemREn		(Ctrl1_MemREn_out),	  //
  .LoadInst     (Ctrl1_LoadInst_out), // selects memory vs ALU output as data input to reg_file
  .Ack          (Ctrl1_Ack_out),      // "done" flag
  .LUTSel		(LUT_SEL),			  // specify LUT
  .RegImm		(REG_IMM),			  // select the immediate field instead of register value
  .ImmLut		(IMM_LUT),			  // output from LUT or immediate instruction field
  .AluOrLut		(ALU_OR_LUT),
  .MemOrJmpLut	(MEM_OR_JMP_LUT)
);

RegFile #(.W(8),.A(3)) RF1 (
  .Clk       (Clk),
  .Reset     (Reset),
  .WriteEn   (Ctrl1_RegWrEn_out),
  .RaddrA    (RADDR_IN1),      // See example below on how 3 opcode bits
  .RaddrB    (RADDR_IN2),      // could address 16 registers...
  .Waddr     (WADDR_IN3),      // mux above
  .DataIn    (MemEx_RegValue_out),
  .DataOutA  (RF1_DataOutA_out),
  .DataOutB  (RF1_DataOutB_out),
  .JumpTarget(JMP_Target_out)
);

ALU ALU1 (
  .InputA  (InA),
  .InputB  (InB),
  .OP      (OP),
  .Out     (ALU_OUT_out),
  .ZER0    (ALU_Zero_out),
  .PAR0  (ALU_Parity_out)
);

DataMem DM1(
  .DataAddress  (RF1_DataOutB_out),		//  RF1_DataOutB_out MUST be R6
  .WriteEn      (Ctrl1_MemWrEn_out),
  .ReadEn		(Ctrl1_MemREn_out),
  .DataIn       (RF1_DataOutA_out),
  .DataOut      (DM1_DataOut_out),
  .Clk          (Clk),
  .Reset        (Reset)
);


///////////////////////////////////////////////////////////////////////

/*							RUNTIME									 */

///////////////////////////////////////////////////////////////////////


///////////////////////// PROGRAM RESTART EXCEPTION LOGIC /////////////////////////
logic should_run_processor;
logic ever_start;

always_ff @(posedge Clk) begin
  if (Reset)
    ever_start <= '0;
  else if (Start)
    ever_start <= '1;
end

always_comb begin
//  should_run_processor = ever_start;
//  Active_InstOut = (should_run_processor) ? Active_InstOut : 9'b111_111_111;
	Active_InstOut = PC1_Going_out ? IR1_InstOut_out : 9'bxxx_xxx_xxx;
end


///////////////////////// INSTRUCTION DECODE LOGIC /////////////////////////
always_comb begin
	OP = Active_InstOut[8:5];
	forward=Active_InstOut[0];

	RADDR_IN1 = Active_InstOut[4:2];
	RADDR_IN2 = {1'b0, Active_InstOut[1:0]};

	// The default behavior for the write port is to write the result to the source register
	WADDR_IN3 = Active_InstOut[4:2];
	// specify adjacent registers for RaddrA and RaddrB
	if (Active_InstOut[8:7] == 2'b00 || Active_InstOut[8:5] == 4'b0110) begin
		RADDR_IN1 = {Active_InstOut[4:3], 1'b0};		// RADDR_IN1 is adjacent to RADDR_IN2 but always 1 less
		RADDR_IN2 = {Active_InstOut[4:3], 1'b1};		// RADDR_IN2 is adjacent to RADDR_IN1 and is always 1 greater
		WADDR_IN3 = Active_InstOut[2:0];				// WADDR_IN3 is the 3 bit field for R type instructions
	end

	// register logic for instructions that set or access R6 or R7
	case(Active_InstOut[8:5])
		SET: if (Active_InstOut[0] == 1'b1) begin WADDR_IN3 = 3'b110; end else begin WADDR_IN3 = 3'b111; end
		//JMP:RADDR_IN2 = 3'b111;
		LW0:RADDR_IN2 = 3'b110;
		SW0:RADDR_IN2 = 3'b110;
		MOL:RADDR_IN1 = {1'b0, Active_InstOut[1:0]};
		MOU:RADDR_IN1 = {1'b1, Active_InstOut[1:0]};
	endcase
end

///////////////////////// ALU CONTROL LOGIC /////////////////////////
assign IMM_or_LUT_out = IMM_LUT ? MEM_LUT_Target_out : {6'b000000, Active_InstOut[1:0]};
assign InA = RF1_DataOutA_out;     // connect RF out to ALU in
assign InB = REG_IMM ? IMM_or_LUT_out : RF1_DataOutB_out;     // interject switch/mux if needed/desired

///////////////////////// PROGRAM TERMINATION LOGIC /////////////////////////
assign Ack = /*(should_run_processor & Ctrl1_Ack_out) ||*/ (Active_InstOut == 9'b111_111_111);

///////////////////////// ALU / LUT / MEMORY DATAPATH OUTPUTS /////////////////////////
assign MemJmp_Lut_out = MEM_OR_JMP_LUT ? MEM_LUT_Target_out : JMP_LUT_Target_out;
assign ExLut_RegValue_out = ALU_OR_LUT ? ALU_OUT_out : MemJmp_Lut_out;
assign MemEx_RegValue_out = Ctrl1_LoadInst_out ? DM1_DataOut_out : ExLut_RegValue_out;

///////////////////////// CycleCount LOGIC /////////////////////////
always_ff @(posedge Clk)
  if (Reset)   // if(start) ?
    CycleCount <= 0;
  else if(Ctrl1_Ack_out == 0)   // if(!halt) ?
    CycleCount <= CycleCount + 'b1;
endmodule

