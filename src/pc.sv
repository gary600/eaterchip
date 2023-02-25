`default_nettype none

module ProgramCounter(
  inout tri [7:0] bus,
  input logic clock, reset,
  input logic write, read, inc
);

  logic [3:0] pc;

  always_ff @(posedge clock or posedge reset)
    if (reset) // async reset
      pc <= '0;
    else if (write) // sync write
      pc <= bus[3:0];
    else if (inc) // sync increment
      pc <= pc + 1;

  always_comb begin
    if (read)
      bus = {4'b0, pc};
    else
      bus = 'z;
  end



endmodule