//========================================================================
// BinaryToSevenSeg_GL
//========================================================================

`ifndef BINARY_TO_SEVEN_SEG_GL_V
`define BINARY_TO_SEVEN_SEG_GL_V

module BinaryToSevenSeg_GL
(
  (* keep=1 *) input  wire [3:0] in,
  (* keep=1 *) output wire [6:0] seg
);

  /* This implementation connects 16 wires to 16 different combinations of binary numbers that represent
  numbers 0-15 using and statements. If the binary number inputed matches the combination represented by
  a wire then the min term is assigned a value of 1; otherwise its assigned a 0. A combination of these 16 
  wires are connected to 7 different segments using or statements to represent when the segment should be 
  turned on. If any of the segment contains a min term with a value of 1, then it will negate the value and 
  be assigned a 0 to represent the segment is turned on. */

  wire min0, min1, min2, min3, min4, min5, min6, min7, min8, min9, min10, min11, min12, min13, min14, min15;
  
  assign min0  = ~in[3] & ~in[2] & ~in[1] & ~in[0];
  assign min1  = ~in[3] & ~in[2] & ~in[1] &  in[0];
  assign min2  = ~in[3] & ~in[2] &  in[1] & ~in[0];
  assign min3  = ~in[3] & ~in[2] &  in[1] &  in[0];
  assign min4  = ~in[3] &  in[2] & ~in[1] & ~in[0];
  assign min5  = ~in[3] &  in[2] & ~in[1] &  in[0];
  assign min6  = ~in[3] &  in[2] &  in[1] & ~in[0];
  assign min7  = ~in[3] &  in[2] &  in[1] &  in[0];
  assign min8  =  in[3] & ~in[2] & ~in[1] & ~in[0];
  assign min9  =  in[3] & ~in[2] & ~in[1] &  in[0];
  assign min10 =  in[3] & ~in[2] &  in[1] & ~in[0];
  assign min11 =  in[3] & ~in[2] &  in[1] &  in[0];
  assign min12 =  in[3] &  in[2] & ~in[1] & ~in[0];
  assign min13 =  in[3] &  in[2] & ~in[1] &  in[0];
  assign min14 =  in[3] &  in[2] &  in[1] & ~in[0];
  assign min15 =  in[3] &  in[2] &  in[1] &  in[0];
  
  assign seg[0] = ~(min0 | min2 | min3 | min5 | min6  | min7  | min8  | min9  | min10 | min11 | min12 | min13 | min14 | min15);
  assign seg[1] = ~(min0 | min1 | min2 | min3 | min4  | min7  | min8  | min9  | min10 | min11 | min12 | min13 | min14 | min15);
  assign seg[2] = ~(min0 | min1 | min3 | min4 | min5  | min6  | min7  | min8  | min9  | min10 | min11 | min12 | min13 | min14 | 
                    min15);
  assign seg[3] = ~(min0 | min2 | min3 | min5 | min6  | min8  | min10 | min11 | min12 | min13 | min14 | min15);
  assign seg[4] = ~(min0 | min2 | min6 | min8 | min10 | min11 | min12 | min13 | min14 | min15); 
  assign seg[5] = ~(min0 | min4 | min5 | min6 | min8  | min9  | min10 | min11 | min12 | min13 | min14 | min15);
  assign seg[6] = ~(min2 | min3 | min4 | min5 | min6  | min8  | min9  | min10 | min11 | min12 | min13 | min14 | min15);

endmodule

`endif /* BINARY_TO_SEVEN_SEG_GL_V */

