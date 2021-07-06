interface ifa (input clk, rst);
	logic [7:0] addr;
	logic as, rw, ds, da;
	logic [15:0] data;
	
	modport read	(output  addr, as, rw, ds, input da, data);
	modport mrg	(input addr, as, rw, ds, output da, data);
endinterface: ifs

module busread(ifa.read rbus);
endmodule	: busread

module busmgr(ifa.mrg wbus);
endmodule	: busmgr

module testbench;
logic clk;
logic rst;

ifa busa(clk, rst);

busread U1 (.rbus(busa));
busmgr U2 (.wbus(busa));

endmodule: testbench
