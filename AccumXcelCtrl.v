//========================================================================
// AccumXcelCtrl
//========================================================================

`ifndef ACCUM_XCEL_CTRL_V
`define ACCUM_XCEL_CTRL_V
`include "Register_RTL.v"

module AccumXcelCtrl
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // I/O Interface

  (* keep=1 *) input  logic        go,
  (* keep=1 *) output logic        result_val,

  // Memory Interface

  (* keep=1 *) output logic        memreq_val,
  (* keep=1 *) output logic        go_en,
  (* keep=1 *) output logic        fetch_count_en,
  (* keep=1 *) output logic        mux_en,
  (* keep=1 *) output logic        accum_en, 
  (* keep=1 *) output logic        reg_mem_en,
  (* keep=1 *) input  logic [31:0] equal

);
  // States
  localparam STATE_IDLE  = 2'b00;
  localparam STATE_FETCH = 2'b01;
  localparam STATE_DONE  = 2'b10;

  // Internal Signals
  logic [1:0] state;
  logic [1:0] next_state;

  // State Register
  Register_RTL#(.p_nbits(2)) reg_state
  (
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .d(next_state),
    .q(state)
  );
  
  logic [30:0] unused_wire;
  assign unused_wire = equal[31:1];

  // State Transition Logic
  always_comb begin

    case (state)

      STATE_IDLE:  next_state = (go) ? STATE_FETCH : STATE_IDLE;
      STATE_FETCH: next_state = (equal[0]) ? STATE_DONE : STATE_FETCH;
      STATE_DONE:  next_state = STATE_DONE;
      default:     next_state = STATE_IDLE;

    endcase
  end

  // Output Logic
  always_comb begin
    // Default outputs
    result_val      = 0;
    memreq_val      = 0;
    mux_en          = 0;
    fetch_count_en  = 0;
    reg_mem_en      = 0; 
    accum_en        = 0;
    go_en           = 0;

    case (state)

      STATE_IDLE: begin
        mux_en          = 0;
        fetch_count_en  = 1;
        reg_mem_en      = 0; 
        memreq_val      = 0;
        accum_en        = 1;
        result_val      = 0;
        go_en           = go;
      end

      STATE_FETCH: begin
        go_en           = 0;
        mux_en          = 1;
        fetch_count_en  = 1;
        reg_mem_en      = 1; 
        memreq_val      = 1;
        accum_en        = 1;
        result_val      = 0;
      end

      STATE_DONE: begin
        go_en           = 0;
        mux_en          = 0;
        reg_mem_en      = 0; 
        fetch_count_en  = 0;
        memreq_val      = 0;
        accum_en        = 0;
        result_val      = 1;
     
      end
      default: begin
      end
    endcase
  end
  

endmodule

`endif /* ACCUM_XCEL_CTRL_V */

