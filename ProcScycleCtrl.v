//========================================================================
// ProcScycleCtrl
//========================================================================

`ifndef PROC_SCYCLE_CTRL_V
`define PROC_SCYCLE_CTRL_V

`include "tinyrv1.v"

module ProcScycleCtrl
(
  (* keep=1 *) input  logic        rst,

  // Control Signals (Control Unit -> Datapath)

  (* keep=1 *) output logic  [1:0] c2d_pc_sel,
  (* keep=1 *) output logic  [1:0] c2d_imm_type,
  (* keep=1 *) output logic        c2d_op2_sel,
  (* keep=1 *) output logic        c2d_alu_func,
  (* keep=1 *) output logic  [2:0] c2d_wb_sel,
  (* keep=1 *) output logic        c2d_rf_wen,
  (* keep=1 *) output logic        c2d_imemreq_val,
  (* keep=1 *) output logic        c2d_dmemreq_val,
  (* keep=1 *) output logic        c2d_dmemreq_type,
  (* keep=1 *) output logic        c2d_out0_en,
  (* keep=1 *) output logic        c2d_out1_en,
  (* keep=1 *) output logic        c2d_out2_en,

  // Status Signals (Datapath -> Control Unit)

  (* keep=1 *) input  logic [31:0] d2c_inst,
  (* keep=1 *) input  logic        d2c_eq
);

  // Localparams for different control signals

  // verilator lint_off UNUSED
  localparam imm_i = 2'd0;
  localparam imm_s = 2'd1;
  localparam imm_j = 2'd2;
  localparam imm_b = 2'd3;
  
  // OP for ALU
  localparam add   = 1'd0;
  localparam comp  = 1'd1;

  
  // Selects for the mux connected to the PC
  localparam pc_4  = 2'd0;
  localparam jal_t = 2'd1;
  localparam jr_t  = 2'd2;
  
  // Selects for mux that determines input for ALU
  localparam rf     = 1'd0;
  localparam imm  = 1'd1;
  
  // Selects for mux for the regfile(write)
  localparam in0s  = 3'd0;
  localparam in1s  = 3'd1;
  localparam in2s  = 3'd2;
  localparam mult  = 3'd3;
  localparam alu   = 3'd4;
  localparam mem   = 3'd5;
  localparam pc4   = 3'd6;
  localparam rfd0  = 3'd7;

  // verilator lint_on UNUSED
  
  // Assign PC sel value for BNE
  logic [1:0] pc_bne; 
  
  always_comb begin
  if (d2c_eq)
    pc_bne = 2'd0;
  else
    pc_bne = 2'd1;
  end

  // Task for setting control signals
  task automatic cs
  (
    input logic [1:0] pc_sel,
    input logic [1:0] imm_type,
    input logic       op2_sel,
    input logic       alu_func,
    input logic [2:0] wb_sel,
    input logic       rf_wen,
    input logic       imemreq_val,
    input logic       dmemreq_val,
    input logic       dmemreq_type
  );
    c2d_pc_sel       = pc_sel;
    c2d_imm_type     = imm_type;
    c2d_op2_sel      = op2_sel;
    c2d_alu_func     = alu_func;
    c2d_wb_sel       = wb_sel;
    c2d_rf_wen       = rf_wen;
    c2d_imemreq_val  = imemreq_val;
    c2d_dmemreq_val  = dmemreq_val;
    c2d_dmemreq_type = dmemreq_type;
  endtask

  logic [11:0] csr_bits;
  assign csr_bits = d2c_inst[31:20];

  // Control signal table

  always_comb begin
    c2d_out0_en = 1'b0;
    c2d_out1_en = 1'b0;
    c2d_out2_en = 1'b0;
    if ( rst )
      cs( '0, '0, '0, '0, '0, '0, '0, '0, '0);
    else begin
      casez ( d2c_inst )
                          //    pc      imm     op2   alu   wb    rf  imem dmem  dmem
                          //    sel     type    sel   func  sel   wen  val  val  type
        `TINYRV1_INST_ADDI: cs( pc_4,   imm_i,  imm,  add,  alu,  1,   1,   0,   'x);
        `TINYRV1_INST_ADD : cs( pc_4,   'x,     rf,   add,  alu,  1,   1,   0,   'x);
        `TINYRV1_INST_MUL : cs( pc_4,   'x,     'x,   'x,   mult, 1,   1,   0,   'x);
        `TINYRV1_INST_LW  : cs( pc_4,   imm_i,  imm,  add,  mem,  1,   1,   1,    0);
        `TINYRV1_INST_SW  : cs( pc_4,   imm_s,  imm,  add,  'x,   0,   1,   1,    1);
        `TINYRV1_INST_JAL : cs( jal_t,  imm_j,  'x,   'x,   pc4,  1,   1,   0,   'x);
        `TINYRV1_INST_JR  : cs( jr_t,   'x,     'x,   'x,   'x,   0,   1,   0,   'x);
        `TINYRV1_INST_BNE : cs( pc_bne, imm_b,  rf,   comp, 'x,   0,   1,   0,   'x);
        `TINYRV1_INST_CSRR: begin
         case(csr_bits)
          `TINYRV1_CSR_IN0: cs( pc_4,   'x,     'x,   'x,   in0s, 1,   1,   0,   'x);
          `TINYRV1_CSR_IN1: cs( pc_4,   'x,     'x,   'x,   in1s, 1,   1,   0,   'x);
          `TINYRV1_CSR_IN2: cs( pc_4,   'x,     'x,   'x,   in2s, 1,   1,   0,   'x);
          default:          cs( pc_4,   'x,     'x,   'x,   'x,   1,   1,   0,   'x);
          endcase
        end
        `TINYRV1_INST_CSRW: begin
          case(csr_bits)
          `TINYRV1_CSR_OUT0: begin
            c2d_out0_en = 1'b1;
            c2d_out1_en = 1'b0;
            c2d_out2_en = 1'b0;
                            cs( pc_4,   'x,     'x,   'x,  rfd0,  0,   1,   0,   'x);
           end
          `TINYRV1_CSR_OUT1: begin
            c2d_out0_en = 1'b0;
            c2d_out1_en = 1'b1;
            c2d_out2_en = 1'b0;
                            cs( pc_4,  'x,      'x,   'x,   rfd0,  0,   1,   0,  'x);
           end
          `TINYRV1_CSR_OUT2: begin
            c2d_out0_en = 1'b0;
            c2d_out1_en = 1'b0;
            c2d_out2_en = 1'b1;
                            cs( pc_4,  'x,      'x,   'x,   rfd0,  0,   1,   0,  'x);
           end
          default: 
                            cs( pc_4,  'x,      'x,   'x,   rfd0,  0,   1,   0,  'x);
          endcase
        end
        default:            cs( 'x,    'x,     'x,   'x,   'x,   'x,   1,  'x,   'x);
      endcase
    end
  end

endmodule

`endif /* PROC_SCYCLE_CTRL_V */
