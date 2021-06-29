
timeunit 1ns;
timeprecision 100ps;

module counter( input logic [4:0] data,
                input logic load, enable,
                input logic clk, rst_,
                output logic [4:0] count);

  always_ff @(posedge clk or negedge rst_)
  begin : always_blk
    if (!rst_)        //Active low asynchronous reset
      count <= 5'b0;
    else
    begin : counter_blk
      if (load)
        count <= data;
      else if (enable)
        count <= count + 1;
      else
        count <= count;
    end : counter_blk
  end : always_blk
endmodule
