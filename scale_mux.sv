localparam WIDTH = 8;

module scale_mux #(WIDTH)( input logic [WIDTH-1: 0] in_a, in_b,
                  input logic sel_a,
                  output logic [WIDTH-1 : 0] out);
    always_comb
    begin : always_blk
      unique case (sel_a)
        1'b1    : out = in_a;
        1'b0    : out = in_b;
        default : out = 1'bx;
      endcase
    end : always_blk
endmodule
