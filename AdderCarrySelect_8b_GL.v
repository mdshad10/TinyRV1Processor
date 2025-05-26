//========================================================================
// AdderCarrySelect_8b_GL
//========================================================================

`ifndef ADDER_CARRY_SELECT_8B_GL
`define ADDER_CARRY_SELECT_8B_GL

`include "AdderRippleCarry_4b_GL.v"
`include "Mux2_4b_GL.v"

module AdderCarrySelect_8b_GL
(
  (* keep=1 *) input  wire [7:0] in0,
  (* keep=1 *) input  wire [7:0] in1,
  (* keep=1 *) input  wire       cin,
  (* keep=1 *) output wire       cout,
  (* keep=1 *) output wire [7:0] sum
);

 //This implementation includes three ripple carry adders and two Mux's to represent a carry-select adder/

wire carry0;

/*This ripple carry is assigned to the original cin input and takes the first four bits of the inputs
Outputs first four bits of the sum.*/
AdderRippleCarry_4b_GL ar0
( .in0(in0[3:0]),
  .in1(in1[3:0]),
  .cin(cin),
  .cout(carry0),
  .sum(sum[3:0])
);

wire [3:0]carryupper0;
wire carry1;
//This ripple carry is assigned a set value of 0 to its cin value and takes the last four bits of the inputs
AdderRippleCarry_4b_GL ar1
( .in0(in0[7:4]),
  .in1(in1[7:4]),
  .cin(1'b0),
  .cout(carry1),
  .sum(carryupper0)
);

wire [3:0]carryupper1;
wire carry2;
//This ripple carry is assigned a set value of 1 to its cin value and takes the last four bits of the inputs
AdderRippleCarry_4b_GL ar2
( .in0(in0[7:4]),
  .in1(in1[7:4]),
  .cin(1'b1),
  .cout(carry2),
  .sum(carryupper1)
);
//This mux uses the cout from the first ripple carry (ar0) as its select. Outputs the last 4 bits of the sum
Mux2_4b_GL mux0
( .in0(carryupper0),
  .in1(carryupper1),
  .sel(carry0),
  .out(sum[7:4])
);
/*This mux uses the cout from the second (ar1) as its in0 and the cout from the third (ar2) as its in1
The select for this mux is the cout from the first ripple carry (ar0)*/
Mux2_1b_GL mux1
( .in0(carry1),
  .in1(carry2),
  .sel(carry0),
  .out(cout)
);


endmodule

`endif /* ADDER_CARRY_SELECT_8B_GL */

