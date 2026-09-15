# Single-Cycle RISC-V 32-bit CPU

A single-cycle 32-bit RISC-V-based CPU implemented in Verilog, built from scratch at the RTL level without any pre-built processor IP.

## Overview

This project implements the core datapath and control logic for a single-cycle RISC-V processor, including:

- Program counter (PC) with reset and sequential/branch-target update logic
- Instruction memory (preloaded via `$readmemh`)
- 32-entry register file with synchronous write and combinational read
- Immediate generator supporting I-type, S-type, and B-type formats
- 8-function ALU (AND, OR, ADD, SUB, SLT, XOR, SLL, SRL)
- Control unit decoding R-type and I-type arithmetic instructions, plus Load, Store, and Branch opcodes
- PC-relative branch resolution using a zero-flag comparison

## Supported Instructions

Currently functional: R-type (add, sub, and, or, slt), I-type immediate arithmetic (addi, andi, slti), and beq-style branching.

## Known Limitations

- Load and Store opcodes are decoded by the control unit but are not yet connected to a data memory module in the current top-level design (`main.v`). Wiring up a data memory is planned future work.
- Branch resolution currently only supports the branch-if-equal case, using the ALU's subtract operation and the zero flag. Differentiating bne and other branch conditions requires funct3-based branch logic, which is not yet implemented.
- The testbench (`tbmain.v`) generates the clock and reset signals and dumps waveforms for GTKWave, but does not perform automated self-checking. Correctness is currently verified by manual waveform inspection rather than assertions.

## File Structure

```
src/
  alu.v         - Arithmetic logic unit
  control.v     - Main and ALU control decoders
  imgen.v       - Immediate generator
  instrmem.v    - Instruction memory
  main.v        - Top-level datapath integration
  pc.v          - Program counter register
  pcadder.v     - Next-PC calculation (sequential vs branch)
  reg.v         - Register file
sim/
  tbmain.v      - Testbench (clock and reset generation, waveform dump)
  program.mem   - Sample test program (hex-encoded instructions)
```

## Running the Simulation

Requires [Icarus Verilog](http://iverilog.icarus.com/) and [GTKWave](http://gtkwave.sourceforge.net/).

```bash
iverilog -o cpu_sim src/*.v sim/tbmain.v
vvp cpu_sim
gtkwave cpu_test.vcd
```

## Sample Program

The included `program.mem` loads the following instructions:

```
addi x1, x0, 10
addi x2, x0, 20
add  x3, x1, x2
sw   x3, 0(x0)
```

Note: the `sw` instruction is decoded correctly but currently has no data memory to write to (see Known Limitations above).

## Future Work

- Wire up a data memory module to make Load and Store instructions functional
- Add funct3-based branch condition decoding (bne, blt, bge, etc.)
- Write a self-checking testbench with automated pass/fail assertions
- Extend instruction support toward full RV32I, including U-type and J-type instructions
