# Harvard Architecture 8-bit Processor (Verilog)

## Overview

This project implements a **custom 8-bit Harvard Architecture Processor** using **Verilog HDL**.
The processor features separate **instruction memory and data memory**, a **32-register file**, and an **8-bit ALU capable of arithmetic, logical, and shift operations**.

The processor executes **32-bit instructions** and supports a variety of operations including **data movement, arithmetic, logic, multiplication, division, and memory access**.

The design was developed and simulated using the **Cadence VLSI toolchain**.

---

# Processor Specifications

| Feature            | Specification             |
| ------------------ | ------------------------- |
| Architecture       | Harvard Architecture      |
| Instruction Width  | 32-bit                    |
| Register File      | 32 registers (8-bit each) |
| Data Memory        | 256 locations (8-bit)     |
| Instruction Memory | 64 locations (32-bit)     |
| Program Counter    | 6-bit                     |
| ALU Width          | 8-bit                     |
| Core               | Single Core               |

---

# Processor Architecture

![Processor Architecture](images/architecture.png)

The processor consists of the following major components:

* **Program Counter (PC)** – Generates instruction addresses.
* **Instruction Memory** – Stores 64 instructions (32-bit each).
* **Decode Unit** – Decodes opcode and extracts register operands.
* **Register File** – 32 registers each of 8 bits.
* **ALU** – Performs arithmetic and logical operations.
* **Data Memory** – 256 memory locations for load/store operations.
* **Writeback Unit** – Writes computation results back to registers.

---

# Instruction Format

![Instruction Format](images/instruction_format.png)

The processor supports multiple instruction formats depending on the operation type:

### Immediate Instruction

```
Opcode (6) | Rdst (5) | Reserved (13) | Immediate (8)
```

### Register Move

```
Opcode (6) | Rdst (5) | Reserved (16) | Rsrc (5)
```

### Load Instruction

```
Opcode (6) | Rdst (5) | Reserved (13) | Src Address (8)
```

### Store Instruction

```
Opcode (6) | Dst Address (8) | Reserved (13) | Rsrc (5)
```

### Arithmetic / Logic Instructions

```
Opcode (6) | Rdst2 (5) | Rdst1 (5) | Reserved (6) | Rsrc2 (5) | Rsrc1 (5)
```

---

# Instruction Set

![Instruction Set](images/instruction_set.png)

The processor supports **17 instructions**:

| Opcode | Instruction    | Operation                     |
| ------ | -------------- | ----------------------------- |
| 000000 | MOV Rdst, #Imm | Rdst = Immediate              |
| 000001 | MOV Rdst, Rsrc | Rdst = Rsrc                   |
| 000010 | LOAD           | Rdst = Memory[address]        |
| 000011 | STORE          | Memory[address] = Rsrc        |
| 000100 | ADD            | Rdst = Rsrc2 + Rsrc1          |
| 000101 | SUB            | Rdst = Rsrc2 − Rsrc1          |
| 000110 | NEG            | Rdst = −Rsrc1                 |
| 000111 | MUL            | {Rdst2,Rdst1} = Rsrc2 × Rsrc1 |
| 001000 | DIV            | Rdst = Rsrc2 / Rsrc1          |
| 001001 | OR             | Rdst = Rsrc2 OR Rsrc1         |
| 001010 | XOR            | Rdst = Rsrc2 XOR Rsrc1        |
| 001011 | NAND           | Rdst = !(Rsrc2 & Rsrc1)       |
| 001100 | NOR            | Rdst = !(Rsrc2 | Rsrc1)       |
| 001101 | XNOR           | Rdst = !(Rsrc2 XOR Rsrc1)     |
| 001110 | NOT            | Rdst = !Rsrc1                 |
| 001111 | LLSH           | Logical Left Shift            |
| 010000 | LRSH           | Logical Right Shift           |

---

# ALU Design

The ALU integrates multiple arithmetic and logic units:

### Carry Lookahead Adder

Used for fast **8-bit addition and subtraction**.

### Wallace Tree Multiplier

Efficient hardware multiplier used for **8-bit multiplication**.

### Logic Unit

Supports the following operations:

* AND
* OR
* XOR
* NAND
* NOR
* XNOR
* NOT

### Barrel Shifter

Implements:

* Logical Left Shift
* Logical Right Shift

---

# Verilog Modules

The processor is implemented using modular RTL design.

```
fetch.v
instruction_memory.v
Decode.v
register.v
alu.v
Datamemory.v
writeback.v
harvard_processor.v
testbench.v
```

### Module Responsibilities

| Module             | Function                                           |
| ------------------ | -------------------------------------------------- |
| fetch       | Generates program counter and fetches instructions |
| instruction_memory | Stores program instructions                        |
| Decode      | Decodes opcode and extracts operands               |
| register    | 32 x 8-bit register bank                           |
| alu                | Arithmetic and logical operations                  |
| Datamemory        | Load and store operations                          |
| writeback     | Writes results back to register file               |
| harvard_processor  | Top-level processor integration                    |
| testbench          | Simulation verification                            |

---

# Simulation Environment

The processor was designed and simulated using:

* **Cadence Genus** – RTL synthesis
* **Cadence Innovus** – Physical design
* **Cadence SimVision** – Simulation and waveform analysis

---

# Future Improvements

Possible extensions to the processor include:

* Pipeline architecture
* Hazard detection
* Branch and jump instructions
* Interrupt handling
* Cache memory
* FPGA implementation

---

# Author

**GODSON DAVID N**
ECE Student
Interest Areas:

* Processor Architecture
* FPGA Prototyping
* RTL Design / Digital Frontend Design
* Design Verification (DV)

---
