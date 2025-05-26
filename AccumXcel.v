//========================================================================
// AccumXcel
//========================================================================

`ifndef ACCUM_XCEL_V
`define ACCUM_XCEL_V

`include "AccumXcelDpath.v"
`include "AccumXcelCtrl.v"

module AccumXcel
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  (* keep=1 *) input  logic        go,
  (* keep=1 *) input  logic [13:0] size,

  (* keep=1 *) output logic        result_val,
  (* keep=1 *) output logic [31:0] result,

  (* keep=1 *) output logic        memreq_val,
  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data
);
  // Internal Control Signals
  logic go_en;
  logic fetch_count_en;
  logic mux_en;
  logic accum_en; 
  logic reg_mem_en;
  logic [31:0] equal;
  
  AccumXcelCtrl ctrl
  (
    .clk             (clk),
    .rst             (rst),
    .go              (go),
    .result_val      (result_val),
    .memreq_val      (memreq_val),
    .go_en           (go_en),
    .fetch_count_en  (fetch_count_en),
    .mux_en          (mux_en),
    .accum_en        (accum_en),
    .reg_mem_en      (reg_mem_en),
    .equal           (equal)
  );

  AccumXcelDpath dpath
  (
    .clk             (clk),
    .rst             (rst),
    .size            (size),
    .result          (result),
    .memreq_addr     (memreq_addr),
    .memresp_data    (memresp_data),
    .go_en           (go_en),
    .fetch_count_en  (fetch_count_en),
    .mux_en          (mux_en),
    .accum_en        (accum_en),
    .reg_mem_en      (reg_mem_en),
    .equal           (equal)
  );

endmodule

`endif /* ACCUM_XCEL_V */

