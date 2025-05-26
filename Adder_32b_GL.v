//========================================================================
// Adder_32b_GL
//========================================================================

`ifndef ADDER_32B_GL
`define ADDER_32B_GL

`include "AdderCarrySelect_8b_GL.v"

module Adder_32b_GL
(
  (* keep=1 *) input  wire [31:0] in0,
  (* keep=1 *) input  wire [31:0] in1,
  (* keep=1 *) output wire [31:0] sum
);

  wire carry_0, carry_1, carry_2;

  // Instantiate four 8-bit carry-select adders to form a 32-bit adder
  
  // Computes the sum of the least significant 8 bits
  AdderCarrySelect_8b_GL adder0 
  (
    .in0  (in0[7:0]),
    .in1  (in1[7:0]),
    .cin  (1'b0),
    .cout (carry_0),
    .sum  (sum[7:0])
  );

  // Computes the sum of the bits 8-15
  AdderCarrySelect_8b_GL adder1 
  (
    .in0  (in0[15:8]),
    .in1  (in1[15:8]),
    .cin  (carry_0),
    .cout (carry_1),
    .sum  (sum[15:8])
  );
 
  // Computes the sum of the bits 16-23
  AdderCarrySelect_8b_GL adder2 
  (
    .in0  (in0[23:16]),
    .in1  (in1[23:16]),
    .cin  (carry_1),
    .cout (carry_2),
    .sum  (sum[23:16])
  );

  wire unused_wire ;
  
  // Computes the sum of the most significant 8 bits
  AdderCarrySelect_8b_GL adder3 
  (
    .in0  (in0[31:24]),
    .in1  (in1[31:24]),
    .cin  (carry_2),
    .cout (unused_wire),
    .sum  (sum[31:24])
  );

endmodule

`endif /* ADDER_32B_GL */


