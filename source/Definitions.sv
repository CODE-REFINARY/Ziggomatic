// Package Name:   Definitions
// Project Name:   CSE141L
// Created:        2020.5.27
// Revised:        2022.1.13
//
// This file defines the parameters used in the ALU.
// `import` the package into each module that needs it.
// Packages are very useful for declaring global variables.

package Definitions;
    // There are many ways to define constants in [System]Verilog.
    // You may come across others in examples, and some forms are
    // simpler / more appropriate for different contexts.

   // We have 4 bit opcodes
   typedef enum logic [3:0] {
       ADD, // 0000
       AND, // 0001
       OR0, // 0010
       XOR, // 0011
	   //NOT,  0100 maybe we don't need this
	   MOL, // 0100
	   ADI, // 0101
	   BNE, // 0110
	   SET, // 0111
	   SLL, // 1000
	   SRL, // 1001
	   //JMP   1010 maybe we don't need this
	   MOU, // 1010
	   LW0, // 1011
	   SW0, // 1100
	   ZER, // 1101
	   PAR, // 1110
	   ACK  // 1111 (Terminate Program)
   } op_mne;

endpackage // Definitions
