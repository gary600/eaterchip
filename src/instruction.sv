`default_nettype none

// NOP: no-op
// LDA x: A <- [x] 
// LDB x: B <- [x]
// STA x: [x] <- A
// STB x: [x] <- B
// LIA x: A <- x
// LIB x: B <- x
// ADD: A <- A+B
// SUB: A <- A-B
// JMP x: jump x
// BRC x: jump x if carry
// BRZ x: jump x if zero
// DSP: display A
// HLT: halt

module InstructionDecoder(
  inout tri [7:0] bus,
  output Control control,
  input logic clock, reset
);

  logic [3:0] instr; // The current instruction
  logic [3:0] arg; // The instruction's argument
  logic [2:0] counter; // The microinstruction counter (instruction "progress")

  always_ff @(posedge clock, posedge reset, posedge control.instr_end) begin
    if (reset) begin // Async reset
      instr <= '0;
      arg <= '0;
      counter <= '0;
    end
    else if (control.instr_end) // Async end-of-instruction
      counter <= 0;
    else begin // Regular sync clock
      if (control.instr_end)
        counter <= '0;
      else
        counter <= counter + 3'b1;
      if (control.instr_write)
        {instr, arg} <= bus;
    end
  end

  always_comb begin
    control = '0;

    casez ({instr, counter})
      // The first two steps of every instruction are the same
      7'b????_000: {control.pc_read, control.mem_write_addr} = '1;
      7'b????_001: {control.mem_read, control.instr_write, control.pc_inc} = '1;

      // 0: NOP
      7'b0000_???: control.instr_end = 1;

      // 1-4: Set the address
      7'b0001_010,
      7'b0010_010,
      7'b0011_010,
      7'b0100_010:
        {control.instr_read_arg, control.mem_write_addr} = '1;
      // 1: LDA
      7'b0001_011: {control.mem_read, control.a_write} = '1;
      // 2: LDB
      7'b0010_011: {control.mem_read, control.b_write} = '1;
      // 3: STA
      7'b0011_011: {control.a_read, control.mem_write} = '1;
      // 4: STB
      7'b0100_011: {control.b_read, control.mem_write} = '1;

      // 5: LIA
      7'b0101_010: {control.instr_read_arg, control.a_write} = '1;
      // 6: LIB
      7'b0110_010: {control.instr_read_arg, control.b_write} = '1;

      // 7: ADD
      7'b0111_010: {control.alu_read, control.alu_set_flags, control.a_write} = '1;
      // 8: SUB
      7'b1000_010: {control.alu_sub, control.alu_read, control.alu_set_flags, control.a_write} = '1;
      // 9: TST
      7'b1001_010: {control.alu_sub, control.alu_set_flags} = '1;

      // A: JMP
      7'b1010_010: {control.instr_read_arg, control.pc_write} = '1;
      // B: BRC
      7'b1011_010:
        if (control.alu_flag_carry)
          {control.instr_read_arg, control.pc_write} = '1;
        else
          control.instr_end = 1;
      // C: BRZ
      7'b1100_010:
        if (control.alu_flag_zero)
          {control.instr_read_arg, control.pc_write} = '1;
        else
          control.instr_end = 1;
      
      // F: HLT
      7'b1111_010: control.clock_halt = 1;

      default: control.instr_end = 1;
    endcase

    if (control.instr_read_arg)
      bus = {4'b0, arg};
    else
      bus = 'z;
  end


endmodule