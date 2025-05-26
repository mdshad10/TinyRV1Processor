//========================================================================
// Mux2_4b_GL
//========================================================================

`ifndef MUX2_4B_GL
`define MUX2_4B_GL

`include "Mux2_1b_GL.v"

module Mux2_4b_GL
(
  (* keep=1 *) input  wire [3:0] in0,
  (* keep=1 *) input  wire [3:0] in1,
  (* keep=1 *) input  wire       sel,
  (* keep=1 *) output wire [3:0] out
);

 /*This implementation uses 4 muxes which each output a 1 bit value of the 4 bit output */
  
  //This mux outputs the first bit of the output
  Mux2_1b_GL mux0
  ( .in0(in0[0]),
    .in1(in1[0]),
    .sel(sel),
    .out(out[0])
  );
  //This mux outputs the second bit of the output
   Mux2_1b_GL mux1
  ( .in0(in0[1]),
    .in1(in1[1]),
    .sel(sel),
    .out(out[1])
  );
  //This mux outputs the third bit of the output
   Mux2_1b_GL mux2
  ( .in0(in0[2]),
    .in1(in1[2]),
    .sel(sel),
    .out(out[2])
  );
  //This mux outputs the fourth bit of the output
   Mux2_1b_GL mux3
  ( .in0(in0[3]),
    .in1(in1[3]),
    .sel(sel),
    .out(out[3])
  );

endmodule

`endif /* MUX2_4B_GL */

