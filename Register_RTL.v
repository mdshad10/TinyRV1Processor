//========================================================================
// Register_RTL
//========================================================================

`ifndef REGISTER_RTL_V
`define REGISTER_RTL_V

module Register_RTL
#(
  parameter p_nbits = 1
)(
  input  logic               clk,
  input  logic               rst,
  input  logic               en,
  input  logic [p_nbits-1:0] d,
  output logic [p_nbits-1:0] q
);

  always_ff @(posedge clk) begin // At the positive/rising clock edge
    if ( rst )
      q <= '0;           // If reset is active, clear the register (set q to 0)
    else if ( en ) 
      q <= d;            // If enabled, load the data 'd' into the register (q = d)                       
  end                    // If reset and enable are not active, the register holds its value

endmodule

`endif /* REGISTER_RTL_V */

