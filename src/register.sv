`default_nettype none

module Register(
  inout tri [7:0] bus,
  output logic [7:0] val,
  input logic clock, reset,
  input logic write, read // control signals
);

  always_ff @(posedge clock, posedge reset)
    if (reset)
      val <= '0;
    else if (write)
      val <= bus;
  
  always_comb
    if (read)
      bus = val;
    else
      bus = 'z;

endmodule