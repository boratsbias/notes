# CPU Organization

CPU organization describes the internal microarchitecture of a processor: how the hardware stages are structured, how instructions flow through them, and how the CPU achieves high performance.

## Datapath and Control

**Datapath:** the collection of functional units (ALU, registers, multiplexers) and the wiring connecting them.

**Control unit:** generates control signals that govern the datapath: which registers to read, what operation the ALU performs, where to write the result.

**Single-cycle CPU:** each instruction completes in one clock cycle. The cycle time is determined by the longest instruction (load: fetch, decode, register read, ALU, memory, register write). Slow due to long cycle time.

**Multi-cycle CPU:** break each instruction into multiple shorter cycles; reuse hardware across cycles. Better cycle time; instructions take 3-5 cycles.

## The Classic Five-Stage Pipeline

Modern CPUs pipeline instruction execution. The stages overlap: while one instruction is in stage $n$, the next is in stage $n-1$.

```
IF: Instruction Fetch    - read instruction from memory (using PC)
ID: Instruction Decode   - decode opcode; read source registers
EX: Execute              - ALU operation or address computation
MEM: Memory Access       - load from or store to data memory
WB: Write Back           - write result to destination register
```

**Throughput:** in steady state, one instruction completes per cycle (CPI = 1). Latency per instruction is still 5 cycles.

**Pipeline registers:** hold values between stages. At the end of each cycle, all pipeline registers are updated simultaneously.

## Hazards

Hazards are situations that prevent the next instruction from executing in its designated cycle.

### Structural Hazard

Two instructions need the same hardware resource in the same cycle. Modern CPUs avoid this by duplicating resources (separate instruction and data caches; multiple execution units).

### Data Hazard (RAW)

An instruction depends on the result of a preceding instruction not yet written back.

```
ADD r1, r2, r3    # writes r1 in WB (cycle 5)
SUB r4, r1, r5   # reads r1 in ID (cycle 3)
```

**Stalling (inserting bubbles):** wait for the result to be available. Wastes 2 cycles for back-to-back dependent instructions.

**Forwarding (bypassing):** pass the result directly from the output of EX or MEM stage to the input of EX, without waiting for WB.

```
EX/MEM.ALUresult -> EX stage input (forward 1 cycle)
MEM/WB.ALUresult -> EX stage input (forward 2 cycles)
```

Forwarding eliminates most RAW stalls. Load-use hazards (when EX result comes from memory) still require 1 stall.

### Control Hazard (Branch Hazard)

Conditional branches change the PC; the pipeline doesn't know which instruction to fetch next until the branch is resolved.

**Stalling:** wait until branch outcome is known. Costs 2-3 cycles per branch.

**Branch prediction:** predict taken or not-taken; fetch the predicted path. Flush on misprediction.

**Branch delay slot (MIPS):** the instruction after the branch is always executed. The compiler fills the delay slot with a useful instruction.

## Superscalar Execution

Issue multiple instructions per cycle using multiple parallel execution units.

**In-order superscalar:** issue $w$ consecutive instructions per cycle if no hazards. Simple; limited by dependences.

**Out-of-order (OOO) execution:** issue instructions out of program order when operands are ready, regardless of earlier stalled instructions.

**OOO pipeline stages:**

```
IF -> ID -> Rename -> Issue/Dispatch -> Execute -> Complete -> Retire
```

**Register renaming:** map architectural registers to physical registers to eliminate WAW and WAR hazards. Only true RAW hazards remain.

**Reservation stations (Tomasulo's algorithm):** each functional unit has a queue of waiting instructions. An instruction issues when all its source operands are available.

**Reorder buffer (ROB):** instructions are committed (retired) in-order, even though they execute out-of-order. Ensures precise exceptions and correct program behavior.

**Speculative execution:** execute instructions after a predicted branch before the branch outcome is known. Flush on misprediction.

## Branch Prediction

A mispredicted branch flushes 10-20+ pipeline stages, losing many cycles. Branch prediction accuracy is critical.

**1-bit predictor:** remember the last outcome; predict the same.

**2-bit saturating counter:** state machine with 4 states (strongly taken, weakly taken, weakly not-taken, strongly not-taken). More stable for loops.

**Two-level adaptive predictor (local history):** index the predictor with a shift register of the last $k$ branch outcomes. Learns periodic patterns.

**TAGE (TAgged GEometric history length predictor):** uses multiple tables indexed with different history lengths; the table with the longest matching history wins. State-of-the-art accuracy (>99.5%).

## Execution Units

Modern CPUs have multiple parallel execution units:

- Integer ALU (multiple): add, subtract, compare.
- Multiplication unit: integer multiply, multiply-accumulate.
- Floating-point unit (FPU): FP arithmetic.
- Load/Store units: memory reads and writes.
- Branch unit: evaluates branch conditions.
- SIMD unit: vector operations (AVX, NEON).

**Apple M3 (2023):** 16-wide decode, 6 integer ALUs, 4 FP/SIMD units, 4 load/store units. Exceptional IPC.
