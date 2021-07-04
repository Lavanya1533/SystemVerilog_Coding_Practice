// package with opcode_t declaration
import typedefs_v2::*;

// SystemVerilog: time unit and time precision specification
timeunit 1ns;
timeprecision 100ps;

module alu (  input logic [7:0] accum,
              input logic [7:0] data,
              input opcode_t opcode,
              input clk,
              output logic [7:0] out,
              output logic zero); // zero = '1' when accum is '0' otherwise '0'

    always_comb begin
      if (!accum)
        zero = 1'b1;
      else
        zero = 1'b0;
    end

    always_ff @(negedge clk)
    begin
      unique case (opcode)
        3'b000  : out = accum;
        3'b001  : out = accum;
        3'b010  : out = data + accum;
        3'b011  : out = data & accum;
        3'b100  : out = data ^ accum;
        3'b101  : out = data;
        3'b110  : out = accum;
        3'b111  : out = accum;
        default : out = 8'b0;
      endcase
    end
  endmodule
