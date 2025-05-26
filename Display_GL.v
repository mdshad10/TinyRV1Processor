//========================================================================
// Display_GL
//========================================================================

`ifndef DISPLAY_GL_V
`define DISPLAY_GL_V

`include "BinaryToBinCodedDec_GL.v"
`include "BinaryToSevenSeg_GL.v"

module Display_GL
(
  (* keep=1 *) input  wire [4:0] in,
  (* keep=1 *) output wire [6:0] seg_tens,
  (* keep=1 *) output wire [6:0] seg_ones
);

  /*This implementation takes a input of 5 bits and outputs two 4 bit numbers representing
    the ones and tens place using the BinaryToBinCodedDec module. */
  
  wire [3:0]binary_to_bin_output_tens;
  wire [3:0]binary_to_bin_output_ones;

  BinaryToBinCodedDec_GL binary_to_bin_coded
  (
    .in   (in),
    .tens (binary_to_bin_output_tens),
    .ones (binary_to_bin_output_ones)
  );
  
  /*Then this implementation uses the BinaryToSevenSegOpt to take the two 4 bit inputs and outputs a 
    seven bit number corresponding to what segmentsts are turned on for the display for each input(tens and ones). */
    
  wire [6:0]binary_to_seven_output_ones;
  wire [6:0]binary_to_seven_output_tens;

  BinaryToSevenSeg_GL binary_to_seven_seg_unopt_ones
  (
    .in  (binary_to_bin_output_ones),
    .seg (binary_to_seven_output_ones)
  );

  BinaryToSevenSeg_GL binary_to_seven_seg_unopt_tens
  (
    .in  (binary_to_bin_output_tens),
    .seg (binary_to_seven_output_tens)
  );

  assign seg_ones = binary_to_seven_output_ones;
  assign seg_tens = binary_to_seven_output_tens;



endmodule

`endif /* DISPLAY_GL_V */

