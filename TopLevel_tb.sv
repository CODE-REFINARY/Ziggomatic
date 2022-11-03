// Create Date:   05/01/2022
// Design Name:   TopLevel Test Bench
// Module Name:   TopLevel_tb.v
// CSE141L

// This is NOT synthesizable; use for logic simulation only
// Verilog Test Fixture created for module: TopLevel

module TopLevel_tb;

// This defines what `#1` means, so later, when the clock is
// up wait `#5` then down wait `#5` we make a 100 MHz clock.
timeunit 1ns;
// This defines the precision of delays in the simulation.
// Convention is for this to be three orders of magnitude
// more precise unless you have a reason for it to be
// something else.
timeprecision 1ps;

// To DUT Inputs
bit Reset;
bit Req;
bit Clk;

// From DUT Outputs
wire Ack;              // done flag

// Instantiate the Device Under Test (DUT)
TopLevel DUT (
  .Reset  (Reset),
  .Start  (Req ),
  .Clk    (Clk ),
  .Ack    (Ack )
);

initial begin
  #10 Reset = 'b1;
  #10 Reset = 'b0;
  #25 Req = 'b1;
  /* Testbench loads values into datamem */
  
  #25 Req = 'b0;
  // Program should start now

  // Wait for done flag, then display results
  wait (Ack);
  //wait(5000);
  #10;
  $stop;
/*
`ifdef __ICARUS__
  #500 $finish;
`else
  #500 $stop;
`endif*/
end

// This generates the system clock
always begin   // clock period = 10 Verilog time units
  #5 Clk = 1'b1;
  #5 Clk = 1'b0;
end

`ifdef __ICARUS__
// This directive is used by some toolchains (icarus, vcs, others)
// to generate waveforms. Questa/ModelSim creates these as arguments
// passed the simulator, so don't want to overwrite when running in
// those environments (hence the `ifdef guard).
integer i;
initial begin
  // Create a "Value Change Dump" file, which records every value
  // that changed during simulation [notice: this is why you have
  // to re-run simulation when you make changes before anything
  // shows up in the waveform!]
  $dumpfile("basic_proc.vcd");

  // Specify which signals to dump. With no arguments, it will
  // dump everything. Our design is small enough that (on modern
  // hardware), we can get away with this.
  $dumpvars();

  // Annoyingly (or sensibly, arguably, as memory is large) this
  // doesn't penetrate array types by default, so we have to be
  // explicit for the things that a 'worth' dumping all the time
  // (registers, registers are worth it, promise).
  //
  // With icarus, there's also a cosmetic bit to mind, this will
  // dump out a whole bunch of warnings, namely:
  //   VCD warning: array word TopLevel_tb.DUT.RF1.Registers[0]
  //   will conflict with an escaped identifier.
  // The VCD file format is limited, so the zeroth output register
  // will be renamed to \Registers[0], which _technically_ could
  // conflict with the name of another existing variable. In
  // practice, this falls into the bin of warnings that can be
  // safely ignored.
  for (i=0; i<8; i=i+1)
    $dumpvars(1, DUT.RF1.Registers[i]);

  // But we should install a quick safety net. If your design
  // runs forever, you can create huge dump files on accident,
  // so install a limit:
  $dumplimit(104857600); // 2**20*100 = 100 MB, plenty.
end
`endif

endmodule

