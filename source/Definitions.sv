// Package Name:   Definitions
// Project Name:   Ziggomatic
// Created:        2020.5.27
// Revised:        2022.11.24
//
// This file defines the parameters used in the ALU.
// `import` the package into each module that needs it.

package Definitions;

   // All opcodes are 4-bit and 3 characters in length
   // "0" character is appended to enforce 3-character opcode length
   // operand pairs are 2-bit values that expand into two 3-bit values 
   // Register 6 (R6) is used in loads and stores to specify which index of datamemory to access
   // Register 7 (R7) is used in branches to specify how much to advance the program counter
   typedef enum logic [3:0] {
       ADD, // 0000 2 bits to specify pair of adjacent source registers and 3 bits to specify destination register. Perform decimal add operation
       AND, // 0001 2 bits to specify pair of adjacent source registers and 3 bits to specify destination register. Perform bitwise and operation 
       OR0, // 0010 2 bits to specify pair of adjacent source registers adn 3 bits to specify destination register. Perform bitwise or operation
       XOR, // 0011 2 bits to specify pair of adjacent source registers adn 3 bits to specify destination register. Perform bitwise exclusive or operation
	   MOL, // 0100 3 bits to specify destination register and 2 bits to specify source register. A 0-bit is appended to the be the MSB of source register. Performs a copy of source register value into destination register.
	   ADI, // 0101 3 bits to specify source register which is the same as the destination register. 2 bits to specify immediate value. Performs decimal add. 
	   BNE, // 0110 2 bits to specify operand registers. 3 bits to select row of 3:8 LUT decoder. If operand values are not equal then set PC = PC + 1 + R7 
	   SET, // 0111 3 bits to select row of 3:8 LUT decoder. 1 bit to specify memory LUT or relative branch destination LU (1 for memory). 1 bit to specify destination as either R6 (1) or R7 (0). 
	   SLL, // 1000 3 bits to specify source register which is the same as the destination register. 2 bits to specify immediate amount to shift by. Perform logical shift left by specified amount.
	   SRL, // 1001 3 bits to specify source register which is the same as the destination register. 2 bits to specify immediate amount to shift by. Perform logical shift right by specified amount. 
	   MOU, // 1010 3 bits to specify desination register and 2 bits to specify source register. A 1-bit is appended to be the MSB of the source register. Performs a copy of source register value into destination register. 
	   LW0, // 1011 3 bits to specify destination register. Performs an access of data memory with index specified by R6. This data is written to the destination register
	   SW0, // 1100 3 bits to specify source register. Performs a write of the source register value to data memory with index specified by R6. 
	   ZER, // 1101 3 bits to specify source and destination register. Performs a "zero-out" of the specified register.
	   PAR, // 1110 3 bits to specify source and destination register. Calculates the bitwise exclusive-or of each bit and writes the resulting bit to the same register. 
	   ACK  // 1111 Flag the testbench to terminate execution
   } op_mne;

endpackage // Definitions
