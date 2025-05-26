//========================================================================
// Mux2_RTL
//========================================================================

`ifndef MUX2_RTL
`define MUX2_RTL

module Mux2_RTL
#(
  parameter p_nbits = 1
)(
  (* keep=1 *) input  logic [p_nbits-1:0] in0,
  (* keep=1 *) input  logic [p_nbits-1:0] in1,
  (* keep=1 *) input  logic               sel,
  (* keep=1 *) output logic [p_nbits-1:0] out
);

  always_comb begin
    if (sel == 1'b0)
      out = in0;            // if sel = 0, the out is in0
    else if (sel == 1'b1)   
      out = in1;            // if sel = 1, the out is in1
    else 
      out = 'x;             // default case
  end

endmodule

`endif /* MUX2_RTL */

