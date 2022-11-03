// Project Name:   CSE141L
// Module Name:    ProgCtr
// Description:    instruction fetch (pgm ctr) for processor

//
// Parameters:
//  A: Number of address bits in instruction memory
module ProgCtr #(parameter A=10)(
  input                Reset,       // reset, init, etc. -- force PC to 0
                       Start,       // begin program (request issued by test bench)
                       Clk,         // PC can change on pos. edges only
                       BranchRelEn, // jump unconditionally to Target value
  input        [7:0]   Target,      // branch offset
  output logic [A-1:0] ProgCtr,      // the program counter register itself
  output logic		   Going,		// indicate whether PC is ticking
  input				   forward
);


logic StartCount;

// program counter can clear to 0, increment, or jump
always_ff @(posedge Clk) begin
  if(Reset)
    ProgCtr <= 0;
  else if(BranchRelEn)             // relative jump'
	if (forward) begin
		ProgCtr <= ProgCtr + Target;
	end
	else begin
		ProgCtr <= ProgCtr + -Target;
	end
  else
    ProgCtr <= ProgCtr + 'b1;      // default increment

  Going <= '0;

  // Handle the Start signal by overriding normal behavior
  if (Reset) begin
    StartCount <= '0;
  end
  else begin
    // Detect rising edge of Start
    if (Start == '1) begin
      StartCount <= 1;
	  ProgCtr <= ProgCtr;
    end
    // don't let things go anywhere until first Start
    if (StartCount == '0) begin
      ProgCtr <= ProgCtr;
	end
	// indicate that PC is currently ticking
	if (StartCount == '1 && Start == '0) begin
		Going <= '1;
	end
  end
end
endmodule
