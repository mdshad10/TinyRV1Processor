//========================================================================
// RegfileZ2r1w_32x32b_RTL
//========================================================================
// Register file with 32 32-bit entries, two read ports, and one write
// port. Reading register zero should always return zero. If waddr ==
// raddr then rdata should be the old data.

`ifndef REGFILE_Z_2R1W_32X32B_RTL
`define REGFILE_Z_2R1W_32X32B_RTL

module RegfileZ2r1w_32x32b_RTL
(
  (* keep=1 *) input  logic        clk,

  (* keep=1 *) input  logic        wen,
  (* keep=1 *) input  logic  [4:0] waddr,
  (* keep=1 *) input  logic [31:0] wdata,

  (* keep=1 *) input  logic  [4:0] raddr0,
  (* keep=1 *) output logic [31:0] rdata0,

  (* keep=1 *) input  logic  [4:0] raddr1,
  (* keep=1 *) output logic [31:0] rdata1
);

  // 32-bit register file with 32 entries (each with 32-bit data)
  logic [31:0] regfiles [31:0]; 

  always_ff @(posedge clk) begin
    if (wen && waddr != 5'b00000) begin 
      regfiles[waddr] <= wdata;        // Store the data in the selected register
    end
  end

  always_comb begin
    if (raddr0 == 5'b00000) begin
      rdata0 = 32'b0;                  // Register 0 always reads as 0
    end 

    else if (raddr0 == waddr) begin
      rdata0 = regfiles[raddr0];       // If raddr0 is the same as the write address, return the previous data 
    end 

    else begin
      rdata0 = regfiles[raddr0];       // Otherwise, return the data from the selected register
    end

    if (raddr1 == 5'b00000) begin
      rdata1 = 32'b0;                  // Register 0 always reads as 0
    end 

    else if (raddr1 == waddr) begin
      rdata1 = regfiles[raddr1];       // If raddr1 is the same as the write address, return the previous data 
    end   

    else begin
      rdata1 = regfiles[raddr1];       // Otherwise, return the data from the selected register
    end
  end

endmodule

`endif /* REGFILE_Z_2R1W_32x32b_RTL */

