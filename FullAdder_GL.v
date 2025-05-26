//========================================================================
// FullAdder_GL
//========================================================================

`ifndef FULL_ADDER_GL_V
`define FULL_ADDER_GL_V

module FullAdder_GL
(
  (* keep=1 *) input  wire in0,
  (* keep=1 *) input  wire in1,
  (* keep=1 *) input  wire cin,
  (* keep=1 *) output wire cout,
  (* keep=1 *) output wire sum
);

/*This implementation creates a full adder by taking two inputs, any cin input
  and outputs a carryout value and a sum*/
  wire  min1, min2, min3, min4, min5, min6, min7;

  assign min1  = ~in0 & ~in1 &  cin;
  assign min2  = ~in0 &  in1 & ~cin; 
  assign min3  = ~in0 &  in1 &  cin; 
  assign min4  =  in0 & ~in1 & ~cin; 
  assign min5  =  in0 & ~in1 &  cin;
  assign min6  =  in0 &  in1 & ~cin; 
  assign min7  =  in0 &  in1 &  cin; 

  assign cout  =   min3 |  min5 |  min6 | min7;
  assign sum   =   min1 |  min2 |  min4 | min7;
  
endmodule

`endif /* FULL_ADDER_GL_V */

