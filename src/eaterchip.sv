`default_nettype none

module EaterChip();

  tri [7:0] bus;

  logic clock, reset;

  Control control;

  // Instruction decoder
  InstructionDecoder dec(
    .bus,
    .control,
    .clock,
    .reset
  );

  // Registers
  logic [7:0] a_val, b_val;
  Register reg_a(
    .bus,
    .clock,
    .reset,
    .val(a_val),
    .read(control.a_read),
    .write(control.a_write)
  );
  Register reg_b(
    .bus,
    .clock,
    .reset,
    .val(b_val),
    .read(control.b_read),
    .write(control.b_write)
  );

  Alu alu(
    .bus,
    .clock,
    .reset,
    .flag_carry(control.alu_flag_carry),
    .flag_zero(control.alu_flag_zero),
    .a(a_val),
    .b(b_val),
    .read(control.alu_read),
    .sub(control.alu_sub),
    .set_flags(control.alu_set_flags)
  );

  Memory mem(
    .bus,
    .clock,
    .reset,
    .write(control.mem_write),
    .write_addr(control.mem_write_addr),
    .read(control.mem_read)    
  );



endmodule