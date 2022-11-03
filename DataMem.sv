// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    DataMem
// Last Update:    2022.01.13

// Memory can only read _or_ write each cycle, so there is just a single
// address pointer for both read and write operations.
//
// Parameters:
//  - A: Address Width. This controls the number of entries in memory
//  - W: Data Width. This controls the size of each entry in memory
// This memory can hold `(2**A) * W` bits of data.
//
// WI22 is a 256-entry single-byte (8 bit) data memory.
module DataMem #(parameter W=8, A=8) (
  input                 Clk,
                        Reset,
                        WriteEn,
						ReadEn,
  input       [A-1:0]   DataAddress, // A-bit-wide pointer to 256-deep memory
  input       [W-1:0]   DataIn,      // W-bit-wide data path, also
  output logic[W-1:0]   DataOut
);

// 8x256 two-dimensional array -- the memory itself
logic [W-1:0] Core[0:2**A-1];

// reads are combinational
always_comb
  if (ReadEn) begin
	DataOut = Core[DataAddress];
  end

// writes are sequential
always_ff @ (posedge Clk)
  /*
  // Reset response is needed only for initialization.
  // (see inital $readmemh above for another choice)
  //
  // If you do not need to preload your data memory with any constants,
  // you may omit the `if (Reset) ... else` and go straight to `if(WriteEn)`
  */

  if(Reset) begin
    // Usually easier to initialize memory by reading from file, as above.
	Core[180] <= 8'b11110000;	// extract b8:b5 from LSW to put into MSW
	Core[181] <= 8'b00000001;	// extract b1 to put into b4 of LSW
	Core[182] <= 8'b11110000;	// extract b11:b8 from MSW for p4
	Core[183] <= 8'b11100000;	// extract b4:b2 from LSW for p4
	Core[184] <= 8'b11001100;	// extract b11:b10,b7:b6 from MSW
	Core[185] <= 8'b11001000;	// extract b4:b3,b1 from LSW
	Core[186] <= 8'b10101010;	// extract b11,b9,b7,b5 from MSW
	Core[187] <= 8'b10101000;	// extract b4,b2,b1 from LSW
	Core[188] <= 8'b11111111;	// extract b11:b5,p8
	Core[189] <= 8'b11111110;	// extract b4:b1,p4,p2,p1
	
	Core[200] <= 8'b00000000;	// counter start
	Core[201] <= 8'b00100000;	// counter end
  end else if(WriteEn) begin
    // Do the actual writes
    Core[DataAddress] <= DataIn;
  end
endmodule
