timeunit 1ns;
timeprecision 100ps;

module register(  input logic [7:0] data,
                  input enable, clk, rst_,
                  output logic [7:0] out);

    always_ff @(posedge clk or negedge rst_)
    begin : always_blk

      if (!rst_)              // Active low, asynchronous reset
        out <= 8'b0;
      else begin: data_trans
        if (enable)           // Pass input to output  if enable is high
          out <= data;
        else                  // Retain the output if enbale is low
          out <= out;
      end : data_trans
    end : always_blk
endmodule
