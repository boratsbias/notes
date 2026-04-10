# Pipelining

Pipelining overlaps the execution of multiple instructions. While one instruction is being executed, the next is being decoded, and the one after that is being fetched. This increases throughput without reducing individual instruction latency.

## Basic Concept

**Analogy:** a car wash with four stages (wash, rinse, dry, wax). Without pipelining, one car uses all four stations sequentially; with pipelining, four cars are processed simultaneously, one at each station.

**Instruction pipeline:** divide instruction execution into $k$ stages; process $k$ instructions in parallel.

**Throughput:** ideally, one instruction completes per cycle (CPI = 1) once the pipeline is full.

**Latency:** an individual instruction still takes $k$ cycles.

**Speedup:** $k\times$ throughput improvement (ideal); reduced by hazards and stalls in practice.

## Five-Stage Pipeline (MIPS Classic)

| Stage | Name | Operation |
|-------|------|-----------|
| IF | Instruction Fetch | Read instruction from instruction memory using PC; PC += 4 |
| ID | Instruction Decode / Register Read | Decode opcode; read register file |
| EX | Execute | ALU operation; branch condition evaluation; address computation |
| MEM | Memory Access | Load or store data memory |
| WB | Write Back | Write result to register file |

**Pipeline registers:** `IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`. Each holds the instruction's partial results as it advances through stages.

## Hazard Details and Solutions

### Data Hazards

**RAW (Read After Write):** producer has not yet written; consumer reads stale value.

Without forwarding:

```
ADD r1, r2, r3    # writes r1 at end of WB (cycle 5)
SUB r4, r1, r5   # reads r1 at ID (cycle 3) -> stale!
```

**Forwarding paths:**
- EX/MEM -> EX input: results from the EX stage are available 1 cycle later.
- MEM/WB -> EX input: results available 2 cycles later.

**Load-use hazard:** the loaded value is not available until after MEM; forwarding to EX of the immediately next instruction is impossible. Must insert 1 stall (bubble).

```
LW  r1, 0(r2)    # r1 available after MEM (cycle 4)
ADD r3, r1, r4   # needs r1 at EX (cycle 4) -> stall 1 cycle
```

**Compiler interleaving:** the compiler (or assembler) can insert an independent instruction between the load and its use to fill the stall slot.

### Control Hazards

Branches are resolved during EX (or later); the two instructions after a branch have already been fetched and decoded.

**Flush on misprediction:** squash instructions fetched on the wrong path (set them to NOPs). Costs 2-3 cycles per mispredicted branch.

**Branch prediction:** predict taken or not-taken; fetch the predicted path; flush if wrong.

**Delayed branches (MIPS):** the instruction in the branch delay slot always executes. The compiler places a useful instruction there (often the instruction before the branch in the original code). Avoids the flush in the simple case.

**Branch target buffer (BTB):** cache mapping branch PC to predicted target address. Fetch from the predicted target immediately in the IF stage.

## Deeper Pipelines

Modern CPUs have 10-20+ pipeline stages for higher clock frequencies (shorter stages = shorter cycle time).

**Example: Intel Core architecture:** ~14-16 stages.

**Benefits:** higher clock frequency.

**Costs:** more stages = deeper mispredict penalty (15-20 cycles instead of 2-3). Branch prediction accuracy becomes even more critical.

**Diminishing returns:** beyond a certain depth, the overhead of pipeline registers and the mispredict penalty outweigh the clock frequency gains.

## Superscalar Pipeline

Issue multiple instructions per cycle by replicating pipeline stages.

**Issue width:** the number of instructions issued per cycle. Modern CPUs: 4-6 wide.

**In-order superscalar:** issue up to $w$ instructions in program order each cycle. Limited by dependences.

**Out-of-order:** see [CPU Organization](03-cpu) for Tomasulo's algorithm.

## VLIW (Very Long Instruction Word)

The compiler explicitly packs multiple operations into a single wide instruction word. No dynamic scheduling hardware needed.

**Advantages:** simpler hardware; lower power.

**Disadvantages:** binary compatibility issues (recompile for each chip); code size bloat (NOPs for empty slots).

Used in DSPs (TI C6000, Qualcomm Hexagon) and Itanium (largely unsuccessful for general computing).

## Pipeline Performance Analysis

**Actual CPI:**

$$\text{CPI} = 1 + \text{structural stall cycles/inst} + \text{data hazard stall cycles/inst} + \text{control stall cycles/inst}$$

**Example:** 5-stage pipeline; 20% branches; 5% misprediction rate; 15-cycle mispredict penalty; no structural or data stalls.

$$\text{CPI} = 1 + 0.20 \times 0.05 \times 15 = 1 + 0.15 = 1.15$$

**CPU time:**

$$T = \text{Inst count} \times \text{CPI} \times \text{Cycle time}$$
