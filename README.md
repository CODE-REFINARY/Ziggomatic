# Ziggomatic
##The Ziggomatic is a single cycle processor design I created in system verilog for a university course on computer architecture. 

* Every instruction that is read into the machine is only 9 bits. This limitation was initially a very difficult obstalce but I quickly realized that limitations encourage imagination and I came up with a pretty interesting way to carry out R-type instructions (think MIPS) without fully specifying each of the 8 bit registers. My method relied on operated exclusively on adjacent registers for isntructions that used multiple operands.
* The instructions in the inst_mem.txt are encoded as plaintext 0s and 1s and mimic a realy binary albeit with actual ascii text. The actual program specified here transforms the 32 bit messages occupying the first 16 slots of data memory into their corresponding hamming codes with the correct parity bits calculated and added. These encodings can be accessed by checking the next 32 slots of data memory.
