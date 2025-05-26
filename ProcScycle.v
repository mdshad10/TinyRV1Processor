//========================================================================
// ProcScycle
//========================================================================

`ifndef PROC_SCYCLE_V
`define PROC_SCYCLE_V

`include "ProcScycleDpath.v"
`include "ProcScycleCtrl.v"

module ProcScycle
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // Memory Interface

  (* keep=1 *) output logic        imemreq_val,
  (* keep=1 *) output logic [31:0] imemreq_addr,
  (* keep=1 *) input  logic [31:0] imemresp_data,

  (* keep=1 *) output logic        dmemreq_val,
  (* keep=1 *) output logic        dmemreq_type,
  (* keep=1 *) output logic [31:0] dmemreq_addr,
  (* keep=1 *) output logic [31:0] dmemreq_wdata,
  (* keep=1 *) input  logic [31:0] dmemresp_rdata,

  // I/O Interface

  (* keep=1 *) input  logic [31:0] in0,
  (* keep=1 *) input  logic [31:0] in1,
  (* keep=1 *) input  logic [31:0] in2,

  (* keep=1 *) output logic [31:0] out0,
  (* keep=1 *) output logic [31:0] out1,
  (* keep=1 *) output logic [31:0] out2,

  // Trace Interface

  (* keep=1 *) output logic        trace_val,
  (* keep=1 *) output logic [31:0] trace_addr,
  (* keep=1 *) output logic [31:0] trace_data
);

  // Control Signals (Control Unit -> Datapath)

  logic  [1:0] c2d_pc_sel;
  logic  [1:0] c2d_imm_type;
  logic        c2d_op2_sel;
  logic        c2d_alu_func;
  logic  [2:0] c2d_wb_sel;
  logic        c2d_rf_wen;
  logic        c2d_imemreq_val;
  logic        c2d_dmemreq_val;
  logic        c2d_dmemreq_type;
  logic        c2d_out0_en;
  logic        c2d_out1_en;
  logic        c2d_out2_en;

  // Status Signals (Datapath -> Control Unit)

  logic [31:0] d2c_inst;
  logic        d2c_eq;

  // Insantiate/Connect Datapath and Control Unit

  ProcScycleDpath dpath
  (
    .clk              (clk),
    .rst              (rst),
    .imemreq_val      (imemreq_val),
    .imemreq_addr     (imemreq_addr),
    .imemresp_data    (imemresp_data),
    .dmemreq_val      (dmemreq_val),
    .dmemreq_type     (dmemreq_type),
    .dmemreq_addr     (dmemreq_addr),
    .dmemreq_wdata    (dmemreq_wdata),
    .dmemresp_rdata   (dmemresp_rdata),
    .in0              (in0),
    .in1              (in1),
    .in2              (in2),
    .out0             (out0),
    .out1             (out1),
    .out2             (out2),
    .trace_val        (trace_val),
    .trace_addr       (trace_addr),
    .trace_data       (trace_data),
    .c2d_pc_sel       (c2d_pc_sel),
    .c2d_imm_type     (c2d_imm_type),
    .c2d_op2_sel      (c2d_op2_sel),
    .c2d_alu_func     (c2d_alu_func),
    .c2d_wb_sel       (c2d_wb_sel),
    .c2d_rf_wen       (c2d_rf_wen),
    .c2d_imemreq_val  (c2d_imemreq_val),
    .c2d_dmemreq_val  (c2d_dmemreq_val),
    .c2d_dmemreq_type (c2d_dmemreq_type),
    .c2d_out0_en      (c2d_out0_en),
    .c2d_out1_en      (c2d_out1_en),
    .c2d_out2_en      (c2d_out2_en),
    .d2c_inst         (d2c_inst),
    .d2c_eq           (d2c_eq)
  );

  ProcScycleCtrl ctrl
  (
    .rst              (rst),
    .c2d_pc_sel       (c2d_pc_sel),
    .c2d_imm_type     (c2d_imm_type),
    .c2d_op2_sel      (c2d_op2_sel),
    .c2d_alu_func     (c2d_alu_func),
    .c2d_wb_sel       (c2d_wb_sel),
    .c2d_rf_wen       (c2d_rf_wen),
    .c2d_imemreq_val  (c2d_imemreq_val),
    .c2d_dmemreq_val  (c2d_dmemreq_val),
    .c2d_dmemreq_type (c2d_dmemreq_type),
    .c2d_out0_en      (c2d_out0_en),
    .c2d_out1_en      (c2d_out1_en),
    .c2d_out2_en      (c2d_out2_en),
    .d2c_inst         (d2c_inst),
    .d2c_eq           (d2c_eq)
  );

endmodule

`endif /* PROC_SCYCLE_V */

