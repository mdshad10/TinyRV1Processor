//========================================================================
// Multiplier_32x32b_RTL
//========================================================================

`ifndef MULTIPLIER_32x32B_RTL_V
`define MULTIPLIER_32x32B_RTL_V

module Multiplier_32x32b_RTL
(
  (* keep=1 *) input  logic [31:0] in0,
  (* keep=1 *) input  logic [31:0] in1,
  (* keep=1 *) output logic [31:0] prod
);

  // prod is assigned the product of inputs in0 and in1

  assign prod = in0 * in1;

endmodule

`endif /* MULTIPLIER_32x32B_RTL_V */

