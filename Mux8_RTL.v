//========================================================================
// Mux8_RTL
//========================================================================

`ifndef MUX8_RTL
`define MUX8_RTL

module Mux8_RTL
#(
  parameter p_nbits = 1
)(
  (* keep=1 *) input  logic [p_nbits-1:0] in0,
  (* keep=1 *) input  logic [p_nbits-1:0] in1,
  (* keep=1 *) input  logic [p_nbits-1:0] in2,
  (* keep=1 *) input  logic [p_nbits-1:0] in3,
  (* keep=1 *) input  logic [p_nbits-1:0] in4,
  (* keep=1 *) input  logic [p_nbits-1:0] in5,
  (* keep=1 *) input  logic [p_nbits-1:0] in6,
  (* keep=1 *) input  logic [p_nbits-1:0] in7,
  (* keep=1 *) input  logic         [2:0] sel,
  (* keep=1 *) output logic [p_nbits-1:0] out
);

  // output is the input value corresponding to the binary value of select 

  always_comb begin
    case (sel)
      3'b000: out = in0;
      3'b001: out = in1;
      3'b010: out = in2;
      3'b011: out = in3;
      3'b100: out = in4;
      3'b101: out = in5;
      3'b110: out = in6;
      3'b111: out = in7;
      default: out = 'x;
    endcase
  end
endmodule

`endif /* MUX8_RTL */

