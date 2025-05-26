//========================================================================
// ImmGen_RTL
//========================================================================
// Generate immediate from a TinyRV1 instruction.
//
//  imm_type == 0 : I-type (ADDI)
//  imm_type == 1 : S-type (SW)
//  imm_type == 2 : J-type (JAL)
//  imm_type == 3 : B-type (BNE)
//

`ifndef IMM_GEN_RTL_V
`define IMM_GEN_RTL_V

module ImmGen_RTL
(
  (* keep=1 *) input  logic [31:0] inst,
  (* keep=1 *) input  logic  [1:0] imm_type,
  (* keep=1 *) output logic [31:0] imm
);

  // Always comb block that computes the immediate value based on imm_type
  always_comb begin
    case (imm_type)
      2'b00: // I-type (ADDI)
        imm = { {21{inst[31]}}, inst[30:20] };  // Sign-extend immediate to 32 bits

      2'b01: // S-type (SW)
        imm = { {21{inst[31]}}, inst[30:25], inst[11:7] };  // Sign-extend immediate to 32 bits

      2'b10: // J-type (JAL)
        imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 }; // Sign-extend immediate to 32 bits

      2'b11: // B-type (BNE)
        imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 }; // Sign-extend immediate to 32 bits

      default:
        imm = 32'b0; // Default case 
    endcase
  end

  logic [6:0] unused;
  assign unused = inst[6:0];

endmodule

`endif /* IMM_GEN_RTL_V */

