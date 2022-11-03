// Design Name:    CSE141L
// Module Name:    memLUT	-	Memory Lookup Table (Program 1)


module memLUTProg1(
  input        [ 2:0] Addr,		// This module is just a 3:8 decoder
  output logic [ 7:0] Target	// 8 bit wide addresses in datamem
);

always_comb begin
  case(Addr)
    3'b000: Target = 180;	// this is the first index where program 1 masks are stored
    3'b001: Target = 200;	// where we keep the counter
    3'b010: Target = 30;	// where we store values
    3'b011: Target = 99;	// negative offset for jumping
    3'b100: Target = 0;
    3'b101: Target = 0;
    3'b110: Target = 62;
    3'b111: Target = 91;
  endcase
end
endmodule
