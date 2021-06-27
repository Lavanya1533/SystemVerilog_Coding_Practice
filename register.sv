module register
( input [7:0] data,
  input enable, clk, rst_,
  output logic [7:0] out);

    timeunit 1ns;
    timeprecision 100ps;

    always_ff @ (posedge clk or negedge rst_) begin
      if (!rst_)        // Active low, asynchronous reset
        out <= 8'b0;
      else begin
        if (enable)  // Pass input to output  if enable is high
          out <= data;
        else
          out <= out; // Retain the output if enbale is low
      end
    end
endmodule
