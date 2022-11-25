// Create Date:    15:50:22 10/02/2019
// Project Name:   CSE141L
// Module Name:    InstROM 
// Description: Instruction ROM template preprogrammed with instruction values
//
// Revision:       2020.08.08
// Last Update:    2022.01.13

// Parameters:
//  A: Number of address bits in instruction memory
//  W: Width of instruction memory entry
module InstROM #(parameter A=10, W=9) (
  input        [A-1:0] InstAddress,
  output logic [W-1:0] InstOut
);

// Declare 2-dimensional array, W bits wide, 2**A words deep
logic [W-1:0] inst_rom[2**A];

// Update the instruction memory out port
always_comb InstOut = inst_rom[InstAddress];

// Fill instruction memory with values from inst_mem.txt
initial begin
  $readmemb("./programs/inst_mem.txt", inst_rom);
end	

endmodule
