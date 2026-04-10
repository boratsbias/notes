# Introduction to Computer Architecture

Computer architecture defines the structure and behavior of a computer system: how hardware components are organized, how they communicate, and how software interacts with hardware. Understanding architecture is fundamental to writing efficient software and designing systems.

## Levels of Abstraction

```
Application software
  -> High-level language
  -> Assembly language
  -> Machine code (ISA)
  -> Microarchitecture (CPU implementation)
  -> Logic gates and circuits
  -> Transistors and devices
  -> Physics
```

**ISA (Instruction Set Architecture):** the contract between hardware and software. Defines the instructions a CPU can execute, the registers it exposes, the memory model, and the I/O mechanism. Multiple microarchitecture implementations can implement the same ISA.

## Core Components

**CPU (Central Processing Unit):** fetches, decodes, and executes instructions. Contains:
- **Registers:** small, fast storage inside the CPU.
- **ALU (Arithmetic Logic Unit):** performs arithmetic and logic operations.
- **Control unit:** decodes instructions; generates control signals.
- **Program counter (PC):** holds the address of the next instruction.

**Memory:** stores instructions and data. Slower than registers; organized in a hierarchy (cache, DRAM, disk).

**I/O devices:** keyboard, display, storage, network adapters. Communicate with the CPU via I/O buses.

**Interconnect (bus):** shared communication medium connecting CPU, memory, and I/O.

## The Von Neumann Architecture

The dominant model for general-purpose computers, proposed by John von Neumann in 1945.

**Key idea:** programs are stored in the same memory as data (stored-program computer). This allows programs to manipulate other programs.

**Components:**
- Memory: stores both instructions and data.
- CPU: contains ALU and control unit.
- Input/Output.
- Bus connecting them.

**Von Neumann bottleneck:** the shared bus between CPU and memory limits throughput. The CPU is often faster than memory; it stalls waiting for data. Modern systems mitigate this with caches and out-of-order execution.

## Harvard Architecture

Separate instruction and data memories (and buses). No Von Neumann bottleneck for instructions. Used in many microcontrollers (AVR, PIC) and DSPs.

Modern CPUs use a modified Harvard architecture: unified DRAM but separate instruction and data L1 caches.

## Performance Metrics

**CPI (Cycles Per Instruction):** average number of clock cycles per instruction.

$$\text{Execution time} = \text{Instruction count} \times \text{CPI} \times \text{Cycle time}$$

**Clock frequency (Hz):** number of cycles per second. Higher frequency = faster cycle; limited by heat and power.

**MIPS (Millions of Instructions Per Second):** simple throughput metric; misleading because instructions vary in complexity across ISAs.

**FLOPS (Floating-Point Operations Per Second):** relevant for scientific computing and ML.

**Amdahl's Law:** if a fraction $f$ of execution time can be improved by speedup $S$:

$$\text{Overall speedup} = \frac{1}{(1-f) + f/S}$$

The speedup is limited by the non-improved fraction. Parallelizing 90% of code with infinite cores gives at most 10$\times$ speedup.

## RISC vs. CISC

**RISC (Reduced Instruction Set Computer):** small, uniform instruction set; load/store only architecture (arithmetic only on registers); fixed instruction width; many registers. ARM, RISC-V, MIPS, SPARC.

**CISC (Complex Instruction Set Computer):** rich instruction set; memory-to-memory operations; variable-length instructions; complex addressing modes. x86-64.

**In practice:** modern x86-64 CPUs internally translate CISC instructions to RISC-like micro-ops (µops). The ISA-level distinction is less meaningful for performance than microarchitecture implementation quality.

## Modern CPU Features

**Superscalar:** issue multiple instructions per cycle by having multiple execution units. Modern CPUs issue 4-6 instructions per cycle.

**Out-of-order execution:** execute instructions in a different order than the program to avoid stalls; commit results in-order.

**Branch prediction:** predict the outcome of conditional branches to keep the pipeline full. Modern predictors achieve >99% accuracy.

**Speculative execution:** execute instructions before it is known whether they are needed (after a predicted branch). Roll back if the prediction is wrong.

**SIMD (Single Instruction Multiple Data):** execute the same operation on multiple data elements simultaneously. SSE, AVX (x86); NEON (ARM). Essential for multimedia and ML.
