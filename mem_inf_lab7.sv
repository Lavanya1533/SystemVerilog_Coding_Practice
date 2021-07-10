
// Define the interface
interface mem_inf (input logic clk);
         logic read; 
         logic write; 
         logic [4:0] addr; 
         logic [7:0] data_in;     // data TO memory
         logic [7:0] data_out;     // data FROM memory
		 
		modport mem (input read, write, addr, data_in, clk, 
						output data_out);
							
		modport tb (output read, write, addr, data_in, 
					input data_out, clk,
					import write_mem, read_mem);
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
		
endinterface	: mem_inf