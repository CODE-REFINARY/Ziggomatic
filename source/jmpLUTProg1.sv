// Design Name:    CSE141L
// Module Name:    memLUT	-	Memory Lookup Table (Program 1)


module jmpLUTProg1(
  input        [ 2:0] Addr,		// This module is just a 3:8 decoder
  output logic [ 7:0] Target	// 8 bit wide addresses in datamem
);

always_comb begin
  case(Addr)
    3'b000: Target = 8'b00000001;
    3'b001: Target = 8'b00000011;
    3'b010: Target = 8'b00000010;
    3'b011: Target = 8'b00001111;
    3'b100: Target = 8'b00011111;
    3'b101: Target = 8'b00111111;
    3'b110: Target = 8'b01111111;
    3'b111: Target = 8'b11111111;
  endcase
end
endmodule
