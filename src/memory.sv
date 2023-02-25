`default_nettype none

module Memory(
  inout tri [7:0] bus,
  input logic clock, reset,
  input logic write, write_addr, read // control signals
);

  logic [3:0] addr;
  logic [7:0] mem [0:15];

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      addr = '0;
      // mem = {16{8'b0}}; // TODO: figure out syntax
    end
    else
      if (write_addr)
        addr <= bus[3:0];
      else if (write)
        mem[addr] <= bus;
  end

  always_comb
    if (read)
      bus = mem[addr];
    else
      bus = 'z;

endmodule