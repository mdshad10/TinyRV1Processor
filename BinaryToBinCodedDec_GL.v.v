//========================================================================
// BinaryToBinCodedDec_GL
//========================================================================

`ifndef BINARY_TO_BIN_CODED_DEC_GL_V
`define BINARY_TO_BIN_CODED_DEC_GL_V

module BinaryToBinCodedDec_GL
(
  (* keep=1 *) input  wire [4:0] in,
  (* keep=1 *) output wire [3:0] tens,
  (* keep=1 *) output wire [3:0] ones
);

/*  This implementation connects 32 wires to 32 different combinations of binary numbers that represent
    numbers 0-31 using and statements. If the binary number inputed matches the combination represented by
    a wire then the min term is assigned a value of 1; otherwise its assigned a 0. A combination of these 32 
    wires are connected to 7 different segments using or statements to represent when the segment should be 
    If any of the segment contains a min term with a value of 1, then it will negate the value and 
    be assigned a 0 to represent the segment is turned on. This procedure is done twice to represent the tens and 
    ones place for each number 0-32.  */
    
  wire min0, min1, min2, min3, min4, min5, min6, min7, min8, min9, min10, min11, min12, min13, min14, min15, min16, 
       min17, min18, min19, min20, min21, min22, min23, min24 , min25, min26, min27, min28, min29, min30, min31;
 
  assign min0  = ~in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
  assign min1  = ~in[4] & ~in[3] & ~in[2] & ~in[1] &  in[0];
  assign min2  = ~in[4] & ~in[3] & ~in[2] &  in[1] & ~in[0];
  assign min3  = ~in[4] & ~in[3] & ~in[2] &  in[1] &  in[0];
  assign min4  = ~in[4] & ~in[3] &  in[2] & ~in[1] & ~in[0];
  assign min5  = ~in[4] & ~in[3] &  in[2] & ~in[1] &  in[0];
  assign min6  = ~in[4] & ~in[3] &  in[2] &  in[1] & ~in[0];
  assign min7  = ~in[4] & ~in[3] &  in[2] &  in[1] &  in[0];
  assign min8  = ~in[4] &  in[3] & ~in[2] & ~in[1] & ~in[0];
  assign min9  = ~in[4] &  in[3] & ~in[2] & ~in[1] &  in[0];
  assign min10 = ~in[4] &  in[3] & ~in[2] &  in[1] & ~in[0];
  assign min11 = ~in[4] &  in[3] & ~in[2] &  in[1] &  in[0];
  assign min12 = ~in[4] &  in[3] &  in[2] & ~in[1] & ~in[0];
  assign min13 = ~in[4] &  in[3] &  in[2] & ~in[1] &  in[0];
  assign min14 = ~in[4] &  in[3] &  in[2] &  in[1] & ~in[0];
  assign min15 = ~in[4] &  in[3] &  in[2] &  in[1] &  in[0];
  assign min16 =  in[4] & ~in[3] & ~in[2] & ~in[1] & ~in[0];
  assign min17 =  in[4] & ~in[3] & ~in[2] & ~in[1] &  in[0];
  assign min18 =  in[4] & ~in[3] & ~in[2] &  in[1] & ~in[0];
  assign min19 =  in[4] & ~in[3] & ~in[2] &  in[1] &  in[0];
  assign min20 =  in[4] & ~in[3] &  in[2] & ~in[1] & ~in[0];
  assign min21 =  in[4] & ~in[3] &  in[2] & ~in[1] &  in[0];
  assign min22 =  in[4] & ~in[3] &  in[2] &  in[1] & ~in[0];
  assign min23 =  in[4] & ~in[3] &  in[2] &  in[1] &  in[0];
  assign min24 =  in[4] &  in[3] & ~in[2] & ~in[1] & ~in[0];
  assign min25 =  in[4] &  in[3] & ~in[2] & ~in[1] &  in[0];
  assign min26 =  in[4] &  in[3] & ~in[2] &  in[1] & ~in[0];
  assign min27 =  in[4] &  in[3] & ~in[2] &  in[1] &  in[0];
  assign min28 =  in[4] &  in[3] &  in[2] & ~in[1] & ~in[0];
  assign min29 =  in[4] &  in[3] &  in[2] & ~in[1] &  in[0];
  assign min30 =  in[4] &  in[3] &  in[2] &  in[1] & ~in[0];
  assign min31 =  in[4] &  in[3] &  in[2] &  in[1] &  in[0];

  assign tens[0] = ~ (min0  | min1  | min2  | min3  | min4  | min5  | min6 | min7 | min8 | min9 | min20 | min21 | min22 | 
                      min23 | min24 | min25 | min26 | min27 | min28 | min29);
  assign tens[1] = ~ (min0  | min1  | min2  | min3  | min4  | min5  | min6 | min7 | min8 | min9 | min10 | min11 | min12 | 
                      min13 | min14 | min15 | min16 | min17 | min18 | min19);
  assign tens[2] =    0;
  assign tens[3] =    0;

  assign ones[0] = ~ (min0  | min2  | min4  | min6  | min8  | min10 | min12 | min14 | min16 | min18 | min20 | min22 | min24 | 
                      min26 | min28 | min30);
  assign ones[1] = ~ (min0  | min1  | min4  | min5  | min8  | min9  | min10 | min11 | min14 | min15 | min18 | min19 | min20 | 
                      min21 | min24 | min25 | min28 | min29 | min30 | min31);
  assign ones[2] = ~ (min0  | min1  | min2  | min3  | min8  | min9  | min10 | min11 | min12 | min13 | min18 | min19 | min20 | 
                      min21 | min22 | min23 | min28 | min29 | min30 | min31);
  assign ones[3] = ~ (min0  | min1  | min2  | min3  | min4  | min5  | min6  | min7  | min10 | min11 | min12 | min13 | min14 | 
                      min15 | min16 | min17 | min20 | min21 | min22 | min23 | min24 | min25 | min26 | min27 | min30 | min31);


endmodule

`endif /* BINARY_TO_BIN_CODED_DEC_GL_V */

