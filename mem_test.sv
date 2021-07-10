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
	   write_mem(i, 0, debug);

    for (int i = 0; i<32; i++)
      begin 
       // Read every address location
		read_mem(i, rdata, debug);
       // check each memory location for data = 'h00
		error_status = checkit (i, rdata, 8'h00);
      end

   // print results of test
	printstatus(error_status);
	
    $display("Data = Address Test");

    for (int i = 0; i< 32; i++)
       // Write data = address to every address location
	   write_mem (i, i, debug);
       
    for (int i = 0; i<32; i++)
      begin
       // Read every address location
		read_mem (i, rdata, debug);
       // check each memory location for data = address
		error_status = checkit(i, rdata, i);
      end

   // print results of test
	printstatus(error_status);
    $finish;
  end

// Write memory task

	task write_mem ( 	input [4:0] waddr,
						input [7:0] wdata,
						input bit debug = 1'b0);	
			@(negedge clk);
			addr 	<= waddr;
			data_in <= wdata;
			write 	<= 1'b1;
			read	<= 1'b0;
			
			@(negedge clk);
			write	<= 1'b0;
			
			@(negedge clk);
			write	<= 1'b1;
			
		if (debug == 1)
			$display("Write address is %h, data value is %h", waddr, wdata);
	endtask : write_mem
	
// Read memory task
	
	task read_mem (		input [4:0] raddr,
						output [7:0] rdata,
						input bit debug = 1'b0);
			
			@(negedge clk);
			addr 	<= raddr;
			read 	<= 1'b1;
			write 	<= 1'b0;
			
			@(negedge clk);
			read	<= 1'b0;
			rdata	= data_out;
			
			@(negedge clk);
			read	<= 1'b1;
			
			if (debug == 1)
			$display("Read address is %h, data value is %h", raddr, rdata);
	endtask	: read_mem		
	
// add result print function
	function int checkit ( 	input [4:0] address,
							input [7:0] actual, expected);
		static int error_status;
		
		if(actual !== expected)
		begin	
			$display("Error No: %h, Expected : %h, Actual : %h", error_status, expected, actual);
			error_status++;
		end
		return (error_status);
	endfunction: checkit
	
// Void function to print status of the test

	function void printstatus (input int status);
		if (status == 0)
			$display("Test pass - No error !");
		else
			$display("Test fails with error : %d", status);
	endfunction: printstatus
endmodule
