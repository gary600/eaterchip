`default_nettype none

module Alu(
  inout tri [7:0] bus,
  output logic flag_carry, flag_zero, // flags
  input logic [7:0] a, b, // addends
  input logic clock, reset,
  input logic read, sub, set_flags // control signals
);

  logic carry, zero;

  always_comb begin
    if (read) begin
      if (sub)
        {carry, bus} = a - b;
      else
        {carry, bus} = a + b;
    end
    else begin
      {carry, 8'b0} = a + b;
      bus = 'z;
    end
  end

  assign zero = (bus == '0);

  always_ff @(posedge clock, posedge reset)
    if (reset) begin
      flag_carry <= 0;
      flag_zero <= 0;
    end
    else begin
      flag_carry <= carry;
      flag_zero <= zero;
    end

endmodule