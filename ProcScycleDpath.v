 //========================================================================
// ProcScycleDpath
//========================================================================

`ifndef PROC_SCYCLE_DPATH_V
`define PROC_SCYCLE_DPATH_V

`include "tinyrv1.v"
`include "Register_RTL.v"
`include "Adder_32b_GL.v"
`include "RegfileZ2r1w_32x32b_RTL.v"
`include "ALU_32b.v"
`include "ImmGen_RTL.v"
`include "Multiplier_32x32b_RTL.v"
`include "Mux2_RTL.v"
`include "Mux8_RTL.v"
`include "Mux4_RTL.v"

module ProcScycleDpath
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
  (* keep=1 *) output logic [31:0] trace_data,

  // Control Signals (Control Unit -> Datapath)

  (* keep=1 *) input  logic  [1:0] c2d_pc_sel,
  (* keep=1 *) input  logic  [1:0] c2d_imm_type,
  (* keep=1 *) input  logic        c2d_op2_sel,
  (* keep=1 *) input  logic        c2d_alu_func,
  (* keep=1 *) input  logic  [2:0] c2d_wb_sel,
  (* keep=1 *) input  logic        c2d_rf_wen,
  (* keep=1 *) input  logic        c2d_imemreq_val,
  (* keep=1 *) input  logic        c2d_dmemreq_val,
  (* keep=1 *) input  logic        c2d_dmemreq_type,
  (* keep=1 *) input  logic        c2d_out0_en,
  (* keep=1 *) input  logic        c2d_out1_en,
  (* keep=1 *) input  logic        c2d_out2_en,

  // Status Signals (Datapath -> Control Unit)

  (* keep=1 *) output logic [31:0] d2c_inst,
  (* keep=1 *) output logic        d2c_eq
);

  assign dmemreq_type  = c2d_dmemreq_type;

  // Fetch Logic

  logic [31:0] pc, pc_next;
  logic [31:0] pcmux_out;
  
  // PC Register
  Register_RTL#(32) pc_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (1'b1),
    .d   (pcmux_out),
    .q   (pc)
  );

  assign imemreq_addr = pc;
  assign imemreq_val  = c2d_imemreq_val;
  
  // Adder computes PC+4
  Adder_32b_GL pc_adder
  (
    .in0 (pc),
    .in1 (32'd4),
    .sum (pc_next)
  );
  
  // PC
  
  logic [31:0] adderimm_sum;
  logic [31:0] jr_targ;
  
  // Mux that selects the input for the PC register
  Mux4_RTL #(.p_nbits(32)) pcmux
  (
    .in0 (pc_next),
    .in1 (adderimm_sum),
    .in2 (jr_targ),
    .in3 (32'b0),
    .sel (c2d_pc_sel),
    .out (pcmux_out)
  );

  logic [31:0] inst;
  assign inst = imemresp_data;
  assign d2c_inst = inst;

  logic [`TINYRV1_INST_RS1_NBITS-1:0] rs1;
  logic [`TINYRV1_INST_RS2_NBITS-1:0] rs2;
  logic [`TINYRV1_INST_RD_NBITS-1:0]  rd;

  assign rs1 = inst[`TINYRV1_INST_RS1];
  assign rd  = inst[`TINYRV1_INST_RD];
  assign rs2 = inst[`TINYRV1_INST_RS2];

  // Register File

  logic [31:0] rf_wdata;
  logic [31:0] rf_rdata0;
  logic [31:0] rf_rdata1;

  RegfileZ2r1w_32x32b_RTL rf
  (
    .clk    (clk),
    .wen    (c2d_rf_wen),
    .waddr  (rd),
    .wdata  (rf_wdata),

    .raddr0 (rs1),
    .rdata0 (rf_rdata0),

    .raddr1 (rs2),
    .rdata1 (rf_rdata1)
  );
  
  assign jr_targ = rf_rdata0;
  assign dmemreq_wdata = rf_rdata1;

  // Immediate Generation

  logic [31:0] immgen_imm;

  ImmGen_RTL immgen
  (
    .inst     (inst),
    .imm_type (c2d_imm_type),
    .imm      (immgen_imm)
   );

  // Adder Immgen

  Adder_32b_GL adderimm
  (
    .in0  (immgen_imm),
    .in1  (pc),
    .sum  (adderimm_sum)
  );

  // Mux for ALU
  logic [31:0] mux_alu_out;
  
  // Mux that chooses what data is inputted to the ALU
  Mux2_RTL #(.p_nbits(32)) alumux
  (
    .in0 (rf_rdata1),
    .in1 (immgen_imm),
    .sel (c2d_op2_sel),
    .out (mux_alu_out)
  );
  
  // MULTIPLIER

  logic [31:0] mult_out;
  
  Multiplier_32x32b_RTL multiplier 
  (
    .in0  (rf_rdata0),
    .in1  (rf_rdata1),
    .prod (mult_out)
  );
  
  // ALU

  logic [31:0] alu_out;
  
  // ALU adds or takes the equality of the inputs
  ALU_32b alu
  (
    .in0 (rf_rdata0),
    .in1 (mux_alu_out),
    .op  (c2d_alu_func),
    .out (alu_out)
  );
  
  assign d2c_eq = alu_out [0:0];
  
  // Memory Setup

  assign dmemreq_addr = alu_out;
  assign dmemreq_val  = c2d_dmemreq_val;
  
  // MUX

  logic [31:0] rf_mux_out;
  
  // Mux that selects data for the (write) regfile

  Mux8_RTL #(.p_nbits(32)) rf_mux
  (
    .in0 (in0),
    .in1 (in1),
    .in2 (in2),
    .in3 (mult_out),
    .in4 (alu_out),
    .in5 (dmemresp_rdata),
    .in6 (pc_next),
    .in7 (rf_rdata0),
    .sel (c2d_wb_sel),
    .out (rf_mux_out)
  );
  
  // CSR register 0
  Register_RTL#(.p_nbits(32)) csr_reg_out0
  (
    .clk (clk),
    .rst (rst),
    .en  (c2d_out0_en),
    .d   (rf_mux_out),
    .q   (out0)
  );
  
  // CSR register 1
  Register_RTL#(.p_nbits(32)) csr_reg_out1
  (
    .clk (clk),
    .rst (rst),
    .en  (c2d_out1_en),
    .d   (rf_mux_out),
    .q   (out1) 
  );
  
  // CSR register 2
  Register_RTL#(.p_nbits(32)) csr_reg_out2
  (
    .clk (clk),
    .rst (rst),
    .en  (c2d_out2_en),
    .d   (rf_mux_out),
    .q   (out2) 
  );

  assign rf_wdata = rf_mux_out;

  // Trace Output

  assign trace_val  = imemreq_val;
  assign trace_addr = pc;
  assign trace_data = rf_wdata;

endmodule

`endif /* PROC_SCYCLE_DPATH_V */

