// Create Date:    2019.01.25
// Last Update:    2022.05.06
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

// Datapath wires leaving the regfile are 8 bits wide and the regfile itself
// contains 8 registers.
module RegFile #(parameter W=8, A=3)(
  input                Clk,
  input                Reset,
  input                WriteEn,
  input        [2:0] RaddrA,    // address pointers
  input        [2:0] RaddrB,    // address pointers
  input        [2:0] Waddr,     // address pointers
  input        [7:0] DataIn,    // data for registers
  
  output logic [7:0] DataOutA,  //   showing two different ways to handle
  output logic [7:0] DataOutB,  //   DataOutX, for pedagogic reasons only
  output logic [7:0] JumpTarget
);


// W bits wide [W-1:0] and 2**A registers deep
//   When W=8 bit wide registers and A=4 to address 16 registers
//   then this could be written `logic [7:0] registers[16]`
logic [8] Registers[8];


// combinational reads
always_comb begin
	assign      DataOutA = Registers[RaddrA];
	assign		DataOutB = Registers[RaddrB];
	assign		JumpTarget = Registers[3'b111];	// R7 always holds the jump target
end

// sequential (clocked) writes
always_ff @ (posedge Clk) begin
  integer i;
  if (Reset) begin
    for (i = 0; i < 8; i = i + 1) begin
      Registers[i] <= '0;
    end
  end else if (WriteEn) begin
    Registers[Waddr] <= DataIn;
  end
end



endmodule
