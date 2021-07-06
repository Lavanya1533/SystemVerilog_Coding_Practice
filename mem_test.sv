///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module mem_test ( input logic clk, 
                  output logic read, 
                  output logic write, 
                  output logic [4:0] addr, 
                  output logic [7:0] data_in,     // data TO memory
                  input  wire [7:0] data_out     // data FROM memory
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;

    $display("Clear Memory Test");

    for (int i = 0; i< 32; i++)
       // Write zero data to every address location
	   write_mem(

    for (int i = 0; i<32; i++)
      begin 
       // Read every address location

       // check each memory location for data = 'h00

      end

   // print results of test

    $display("Data = Address Test");

    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
       
    for (int i = 0; i<32; i++)
      begin
       // Read every address location

       // check each memory location for data = address

      end

   // print results of test

    $finish;
  end

// Write memory task

	task write_mem ( 	input [4:0] waddr,
						input [7:0] wdata,
						input bit debug = 1'b0,
						output read, write,
						output [4:0] addr,
						output [7:0] data_in);
						
			data_in <= wdata;
			addr 	<= waddr;
			read	<= 1'b0;
			write	<= 1'b1;
		#10 write	<= 1'b0;
		#10	write	<= 1'b1;
		if (debug == 1)
			$display("Write address is %h, data value is %h", waddr, wdata);
	endtask : write_mem
	
// Read memory task
	
	task read_mem (		input [4:0] raddr,
						input [7:0] data_out,
						input bit debug = 1'b0,
						output read, write,
						output [7:0] rdata,
						output [4:0] addr);
			
				addr	= raddr;
				read 	= 1'b1;
				write 	= 1'b0;
			#1	rdata	= data_out;
			#10 read 	= 1'b0;
			#10	read 	= 1'b1;
			#1	rdata	= data_out;	
			if (debug == 1)
			$display("Read address is %h, data value is %h", raddr, rdata);
	endtask	: read_mem		
// add result print function
	

endmodule
