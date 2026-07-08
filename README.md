# OTTER MCU - RISC-V Processor Implementation

A SystemVerilog implementation of the OTTER MCU, a small RISC-V based microcontroller built and tested for the Digilent Basys 3 FPGA board. This project was developed as a hands-on computer architecture project to better understand how a processor datapath, control unit, memory system, and I/O interface work together at the hardware level.

## Overview

This project implements a custom OTTER MCU using modular SystemVerilog components. The design follows a RISC-V style architecture and includes the major blocks needed for instruction fetch, decode, execute, memory access, writeback, branching, and basic memory-mapped I/O.

The processor was built in Vivado and targeted for the Basys 3 board. Assembly programs were written and converted into memory files for testing the processor in simulation and on hardware.

## Features

* RISC-V style processor datapath implemented in SystemVerilog
* Modular hardware design with separate components for:

  * ALU
  * Register file
  * Program counter
  * Immediate generator
  * Branch address generator
  * Branch condition generator
  * Control unit decoder
  * Control unit FSM
* Support for common RISC-V instruction formats:

  * R-type arithmetic and logic instructions
  * I-type arithmetic, load, and `jalr` instructions
  * S-type store instructions
  * B-type branch instructions
  * U-type `lui` and `auipc`
  * J-type `jal`
* Memory-mapped I/O interface using:

  * `IOBUS_IN`
  * `IOBUS_OUT`
  * `IOBUS_ADDR`
  * `IOBUS_WR`
* Basys 3 FPGA constraint file included
* Assembly test programs and memory dump files included for verification
* Vivado project files included for simulation, synthesis, and implementation

## Project Structure

```text
OTTER-MCU/
├── Deliverables/
│   ├── MyOtterFiles/
│   │   ├── ALU.sv
│   │   ├── Branch_Address_Gen.sv
│   │   ├── Branch_Conditional_Gen.sv
│   │   ├── CU_DCDR.sv
│   │   ├── CU_FSM.sv
│   │   ├── IMM_GEN.sv
│   │   ├── Mux.sv
│   │   ├── OTTERMCU.sv
│   │   ├── PCMux.sv
│   │   ├── PCregister.sv
│   │   └── REG_FILE.sv
│   ├── FinalHW_Assembly_Code.pdf
│   ├── MyOtterFiles.zip
│   └── finalsw_dump1.mem
├── OTTERMCU_v3/
│   └── Vivado project files
├── 233Final.asm
├── Basys3_Master.xdc
├── FinalSW.drawio
├── OTTER_Architecture_NoInterrupts.pdf
├── RARS_OTTER_v1.55.jar
├── RISCV_Assembler_Manual_4_04.pdf
├── Test_All_Debug.txt
├── finalsw_dump1.mem
└── additional assembly test files
```

## Hardware Architecture

The top-level processor module connects the main datapath and control logic together. At a high level, the processor includes:

1. **Program Counter**
   Holds the current instruction address and updates based on normal execution, branches, jumps, and resets.

2. **Instruction Memory / Data Memory Interface**
   Uses the current PC to fetch instructions and uses ALU results for data memory addressing.

3. **Register File**
   Stores general-purpose register values and supports two read ports and one write port.

4. **ALU**
   Performs arithmetic, logic, shift, and comparison operations.

5. **Immediate Generator**
   Extracts and sign-extends immediates for RISC-V instruction formats.

6. **Branch Logic**
   Computes branch and jump target addresses and evaluates branch conditions.

7. **Control Unit**
   Uses a decoder and finite state machine to generate datapath control signals for each instruction type.

## Main Modules

| Module                      | Purpose                                                            |
| --------------------------- | ------------------------------------------------------------------ |
| `OTTERMCU.sv`               | Top-level MCU module connecting datapath, control, memory, and I/O |
| `ALU.sv`                    | Performs arithmetic, logic, shift, and comparison operations       |
| `REG_FILE.sv`               | Implements the processor register file                             |
| `IMM_GEN.sv`                | Generates immediates for RISC-V instruction formats                |
| `CU_DCDR.sv`                | Decodes instructions and selects ALU, PC, and writeback behavior   |
| `CU_FSM.sv`                 | Controls instruction fetch, execute, and writeback states          |
| `Branch_Address_Gen.sv`     | Calculates branch and jump target addresses                        |
| `Branch_Conditional_Gen.sv` | Evaluates branch comparison conditions                             |
| `PCregister.sv`             | Stores and updates the program counter                             |
| `Mux.sv` / `PCMux.sv`       | Multiplexers used throughout the datapath                          |

## Tools Used

* **SystemVerilog** - hardware design
* **Xilinx Vivado** - simulation, synthesis, implementation, and bitstream generation
* **Digilent Basys 3 FPGA board** - hardware target
* **RARS OTTER** - RISC-V assembly development and memory file generation
* **Draw.io** - architecture/block diagram documentation

## Running the Project

### 1. Open the Vivado Project

Open the Vivado project file located in:

```text
OTTERMCU_v3/OTTERMCU_v3.xpr
```

### 2. Review or Add Source Files

The main SystemVerilog source files are located in:

```text
Deliverables/MyOtterFiles/
```

The Vivado project also contains source and simulation files under:

```text
OTTERMCU_v3/OTTERMCU_v3.srcs/
```

### 3. Load a Program

Assembly files are included in the root directory. Example files include:

```text
233Final.asm
push7segLEDtest.asm
sort_subroutine_test.asm
dividesubtetst.asm
```

Memory initialization files are also included, such as:

```text
finalsw_dump1.mem
```

These files can be used to load programs into instruction memory for simulation or hardware testing.

### 4. Simulate

Use the included simulation files in the Vivado project to test processor behavior before programming the FPGA.

Example simulation files include:

```text
OTTERMCUwrappersim.sv
hw6sim.sv
```

### 5. Implement on Basys 3

Use the included constraint file:

```text
Basys3_Master.xdc
```

Then run synthesis, implementation, and bitstream generation in Vivado.

## What I Learned

This project helped me connect concepts from computer architecture to an actual hardware implementation. Some of the main skills I practiced were:

* Designing modular SystemVerilog components
* Building and debugging a processor datapath
* Implementing a finite state machine for control logic
* Decoding RISC-V instructions into hardware control signals
* Testing assembly programs on a custom processor
* Working with Vivado simulation and FPGA implementation
* Debugging hardware behavior using small test programs and memory dumps

## Future Improvements

Possible improvements for this project include:

* Cleaning up the Vivado project structure so only necessary source files are tracked
* Adding a clearer simulation guide with expected outputs
* Expanding instruction support
* Adding interrupt/CSR functionality
* Creating a full testbench with automated pass/fail checks
* Adding diagrams directly to this README
* Documenting the memory map for switches, LEDs, seven-segment display, and other Basys 3 I/O

## Status

This project is a student computer architecture implementation of the OTTER MCU on the Basys 3 FPGA. It includes the main SystemVerilog processor modules, assembly test programs, Vivado project files, and final deliverables used for testing and demonstration.
