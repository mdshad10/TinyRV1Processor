//========================================================================
// AccumXcelDpath
//========================================================================

`ifndef ACCUM_XCEL_DPATH_V
`define ACCUM_XCEL_DPATH_V
`include "Register_RTL.v"
`include "Adder_32b_GL.v"
`include "Mux2_RTL.v"
`include "ALU_32b.v"

module AccumXcelDpath
(
  (* keep=1 *) input  logic        clk,
  (* keep=1 *) input  logic        rst,

  // I/O Interface

  (* keep=1 *) input  logic [13:0] size,
  (* keep=1 *) output logic [31:0] result,

  // Memory Interface

  (* keep=1 *) output logic [15:0] memreq_addr,
  (* keep=1 *) input  logic [31:0] memresp_data,
  (* keep=1 *) input  logic        go_en,
  (* keep=1 *) input  logic        fetch_count_en,
  (* keep=1 *) input  logic        mux_en,
  (* keep=1 *) input  logic        accum_en, 
  (* keep=1 *) input  logic        reg_mem_en,
  (* keep=1 *) output logic [31:0] equal

);

  logic [31:0] result_nxt;
  logic [31:0] mux_out;
  
  // Multiplexer to select between 0 and the next result value
  Mux2_RTL#(32) adder_mux
  (
    .in0(0),
    .in1(result_nxt),
    .sel(mux_en),
    .out(mux_out)
  );
  
  // Register for result, updated based on fetch_count_en
  Register_RTL#(.p_nbits(32)) reg_counter
  (
    .clk(clk),
    .rst(rst),                   
    .en(fetch_count_en),          
    .d(mux_out),          
    .q(result)               
  );
  
  // Adder to compute the next result value
  Adder_32b_GL reg_addr
  (
    .in0 (result),             
    .in1 (memresp_data),           
    .sum (result_nxt)     
  );

  logic [31:0] memreq_addr_nxt;

  logic [15:0] unused_memreq_addr_nxt;
  assign unused_memreq_addr_nxt = memreq_addr_nxt[31:16];
  
  // Register for memory address, updated based on reg_mem_en
  Register_RTL#(.p_nbits(16)) reg_memory
  (
    .clk(clk),
    .rst(rst),
    .en(reg_mem_en),
    .d(memreq_addr_nxt[15:0]),
    .q(memreq_addr)
  );
  
  // Adder to calculate the next memory request address
  Adder_32b_GL mem_addr
  (
    .in0 ({16'b0,memreq_addr}),        
    .in1 (4),    
    .sum (memreq_addr_nxt)       
  );
  
  logic [31:0] accum_reg;
  logic [31:0] accum_next;

  // Register for accumulator
  Register_RTL#(.p_nbits(32)) reg_accum
  (
    .clk(clk),
    .rst(rst),               
    .en(accum_en),           
    .d(accum_next),          
    .q(accum_reg)            
  );
  
  // Adder to update accumulator value
  Adder_32b_GL accum_addr
  (
    .in0 (accum_reg),        
    .in1 (1),    
    .sum (accum_next)       
  );
  
  logic [13:0] size_nxt;
  
  // Register to hold the size input value
  Register_RTL#(.p_nbits(14)) reg_size
  (
    .clk(clk),
    .rst(rst),             
    .en(go_en),          
    .d(size),          
    .q(size_nxt)         
  );
  
  // ALU to compare accumulator value with size and compute equality
  ALU_32b alu
  (
    .in0(accum_reg),
    .in1({18'b0,size_nxt}),
    .op(1'b1),
    .out(equal)
  );


endmodule
`endif /* ACCUM_XCEL_DPATH_V */

