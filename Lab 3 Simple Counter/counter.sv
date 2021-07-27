module counter(	input logic [4:0] data,
				input load, enable,
				input clk, rst_,
				output logic [4:0] count);
		
	timeunit 1ns;
	timeprecision 100ps;
	
	always_ff @(posedge clk)
	begin: always_blk
		unique if (!rst_)
			count = 5'b0;
		else if (load)
			count = data;
		else if (enable)
			count++;
		else
			count = count;
	end : always_blk
endmodule 