///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : top.sv
// Title       : top module for Memory labs 
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the top module for memory labs
// Notes       :
// Memory Lab - top-level 
// A top-level module which instantiates the memory and mem_test modules
// 
///////////////////////////////////////////////////////////////////////////

module top_lab7;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic and bit data types
logic	clk = 0;

always #5 clk = ~clk;

mem_inf mbus (clk);

// SYSTEMVERILOG:: implicit .* port connections
mem_test mtest (.mbus(mbus.tb));

// SYSTEMVERILOG:: implicit .name port connections
mem m1 (.mbus(mbus.mem));

endmodule
