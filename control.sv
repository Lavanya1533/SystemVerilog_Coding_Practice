///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : control.sv
// Title       : Control Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Control module
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

// import SystemVerilog package for opcode_t and state_t
import typedefs::*;

module control  (
                output logic      load_ac ,
                output logic      mem_rd  ,
                output logic      mem_wr  ,
                output logic      inc_pc  ,
                output logic      load_pc ,
                output logic      load_ir ,
                output logic      halt    ,
                input  opcode_t   opcode  , // opcode type name must be opcode_t
                input             zero    , // '1' when CPU accumulator is zero and '0' otherwise
                input             clk     ,
                input             rst_);
// SystemVerilog: time units and time precision specification
timeunit 1ns;
timeprecision 100ps;

state_t ps, ns;

//Present state logic of Mealy machine
always_ff @(posedge clk or negedge rst_)
  if (!rst_)
    ps <= state_t '(3'b000);
  else
     ps <= ns;

  //Next state logic of Mealy machine

  always_comb begin
    unique case (ps)
      3'b000    : begin
                    ns      = state_t '(3'b001);
                    mem_rd  = 1'b0;
                    load_ir = 1'b0;
                    halt    = 1'b0;
                    inc_pc  = 1'b0;
                    load_ac = 1'b0;
                    load_pc = 1'b0;
                    mem_wr  = 1'b0;
      end
      3'b001    : begin
                    ns      = state_t '(3'b010);
                    mem_rd  = 1'b1;
                    load_ir = 1'b0;
                    halt    = 1'b0;
                    inc_pc  = 1'b0;
                    load_ac = 1'b0;
                    load_pc = 1'b0;
                    mem_wr  = 1'b0;
      end
      3'b010    : begin
                    ns      = state_t '(3'b011);
                    mem_rd  = 1'b1;
                    load_ir = 1'b1;
                    halt    = 1'b0;
                    inc_pc  = 1'b0;
                    load_ac = 1'b0;
                    load_pc = 1'b0;
                    mem_wr  = 1'b0;
      end
      3'b011    : begin
                    ns      = state_t '(3'b100);
                    mem_rd  = 1'b1;
                    load_ir = 1'b1;
                    halt    = 1'b0;
                    inc_pc  = 1'b0;
                    load_ac = 1'b0;
                    load_pc = 1'b0;
                    mem_wr  = 1'b0;
      end
      3'b100    : begin
                    ns      = state_t '(3'b101);
                    mem_rd  = 1'b0;
                    load_ir = 1'b0;
                      if (opcode == HLT)
                        halt = 1'b1;
                      else
                        halt    = 1'b0;
                    inc_pc  = 1'b1;
                    load_ac = 1'b0;
                    load_pc = 1'b0;
                    mem_wr  = 1'b0;
      end
      3'b101    : begin
                    ns = state_t '(3'b110);
                    if (opcode inside {ADD, AND, XOR, LDA})
                      mem_rd = 1'b1;
                    else
                      mem_rd = 1'b0;
                    load_ir = 1'b0;
                    halt    = 1'b0;
                    inc_pc  = 1'b0;
                    load_ac = 1'b0;
                    load_pc = 1'b0;
                    mem_wr  = 1'b0;
      end
      3'b110    : begin
                    ns = state_t '(3'b111);
                    if (opcode inside {ADD, AND, XOR, LDA})
                      mem_rd = 1'b1;
                    else
                      mem_rd = 1'b0;
                    load_ir = 1'b0;
                    halt    = 1'b0;
                    if (opcode == SKZ && zero == 1'b1)
                      inc_pc = 1'b1;
                    else
                      inc_pc = 1'b0;
                    if (opcode inside {ADD, AND, XOR, LDA})
                      load_ac = 1'b1;
                    else
                      load_ac = 1'b0;
                    if (opcode == JMP)
                      load_pc = 1'b1;
                    else
                      load_pc = 1'b0;
                    mem_wr  = 1'b0;
      end
      3'b111    : begin
                    ns = state_t '(3'b000);
                    if (opcode inside {ADD, AND, XOR, LDA})
                      mem_rd = 1'b1;
                    else
                      mem_rd = 1'b0;
                    load_ir = 1'b0;
                    halt    = 1'b0;
                    if (opcode == JMP)
                      inc_pc = 1'b1;
                    else
                      inc_pc = 1'b0;
                    if (opcode inside {ADD, AND, XOR, LDA})
                      load_ac = 1'b1;
                    else
                      load_ac = 1'b0;
                    if (opcode == JMP)
                      load_pc = 1'b1;
                    else
                      load_pc = 1'b0;
                    if (opcode == STO)
                      mem_wr = 1'b1;
                    else
                      mem_wr  = 1'b0;
      end
      default   : ns = state_t '(3'b000);
    endcase
  end
endmodule
