module register(	input logic [7:0] data,
					input enable, clk,
					input rst_,
					output logic [7:0] out);
	
	timeunit 1ns;
	timeprecision 100ps;
	
	always_ff @(posedge clk)
	begin
		priority if (!rst_)
			out <= 8'b0;
		else if (enable)
			out <= data;
		else	
			out <= out;
	end
endmodule
	
	