`default_nettype none

typedef struct packed {

  // Clock module
  logic clock_halt;

  // Program counter module
  logic pc_write, pc_read, pc_inc;

  // A register
  logic a_write, a_read;

  // B register
  logic b_write, b_read;

  // Memory module
  logic mem_write_addr, mem_write, mem_read;

  // ALU module 
  logic alu_read, alu_sub, alu_set_flags, alu_flag_carry, alu_flag_zero;
  
  // Control module
  logic instr_write, instr_read_arg, instr_end;

} Control;