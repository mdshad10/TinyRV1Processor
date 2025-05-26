//========================================================================
// Mux4_RTL
//========================================================================

`ifndef MUX4_RTL
`define MUX4_RTL

module Mux4_RTL
#(
  parameter p_nbits = 1
)(
  (* keep=1 *) input  logic [p_nbits-1:0] in0,
  (* keep=1 *) input  logic [p_nbits-1:0] in1,
  (* keep=1 *) input  logic [p_nbits-1:0] in2,
  (* keep=1 *) input  logic [p_nbits-1:0] in3,
  (* keep=1 *) input  logic         [1:0] sel,
  (* keep=1 *) output logic [p_nbits-1:0] out
);

  always_comb begin
    if (sel == 2'b00)
      out = in0;             // if sel is 0, output is in0
    else if (sel == 2'b01)
      out = in1;             // if sel is 1, output is in1
    else if (sel == 2'b10)
      out = in2;             // if sel is 2, output is in2
    else if (sel == 2'b11)
      out = in3;             // if sel is 3, output is in3
    else 
      out = 'x;              // default
  end

endmodule

`endif /* MUX4_RTL */

