TinyRV1 Processor & Accelerator Design Project
This project focuses on the design, implementation, simulation, and hardware prototyping of a TinyRV1 single-cycle processor and a specialized accumulate accelerator. It is divided into multiple stages, progressing from low-level Verilog components to full system synthesis and real-time FPGA demonstration. The project culminates in a comparative analysis between general-purpose and specialized architectures.

Project Goals
Build a functional RISC-V-like processor (TinyRV1) from the ground up

Prototype and test the processor on an FPGA using real switches and displays

Design and evaluate a specialized hardware accelerator

Analyze and compare area, performance, and design complexity

Deliver a comprehensive engineering report summarizing your design, methods, and insights

Phase 1: Foundation – Processor Components 
Objective:
Design and verify key datapath elements using modular and hierarchical RTL and GL Verilog.

Tasks:

Develop components: multiplexers, registers, ALU, multiplier, immediate generator

Exhaustively test each module individually

Follow strict Verilog modeling rules (e.g., structural GL for adders)

Phase 2: Integration – Single-Cycle Processor
Objective:
Integrate components into a complete single-cycle TinyRV1 processor.

Tasks:

Build a structural datapath based on provided block diagram

Design a centralized control unit using a casez-based FSM

Implement support for all TinyRV1 instructions: ADDI, ADD, MUL, LW, SW, JAL, JR, BNE, CSRR/CSRW

Develop targeted testbenches for each instruction

Use trace-based testing to validate instruction sequencing

Phase 3: Custom Hardware – Accumulate Accelerator 
Objective:
Design a highly optimized finite-state-machine-based hardware accelerator to sum array elements.

Tasks:

Implement datapath using only structural RTL

Design a standalone FSM controller (no always_ff)

Test and validate performance using waveform inspection and result checking

Compare execution behavior to the general-purpose processor
