//========================================================================
// Mux2_1b_GL
//========================================================================

`ifndef MUX2_1B_GL
`define MUX2_1B_GL

module Mux2_1b_GL
(
  (* keep=1 *) input  in0,
  (* keep=1 *) input  in1,
  (* keep=1 *) input  sel,
  (* keep=1 *) output out
);

 //This implements a mux where an output is produced based on two inputs and a select value 
  wire  min1, min3, min6, min7;
  
  assign min1  =  in0 & ~in1 & ~sel;
  assign min3  =  in0 &  in1 & ~sel; 
  assign min6  = ~in0 &  in1 &  sel; 
  assign min7  =  in0 &  in1 &  sel; 
  
  assign out   =   min1 | min3 | min6 | min7;
  
endmodule

`endif /* MUX2_1B_GL */

