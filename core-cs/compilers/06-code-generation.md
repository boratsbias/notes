# Code Generation

Code generation translates the optimized IR into target machine instructions. It must select appropriate instructions, allocate physical registers, and schedule instructions to minimize execution time.

## Code Generation Phases

```
Optimized IR
  -> Instruction Selection   (IR ops -> target instructions)
  -> Register Allocation     (virtual regs -> physical regs)
  -> Instruction Scheduling  (reorder for pipeline efficiency)
  -> Target code
```

## Instruction Selection

Map IR operations to target machine instructions.

**Simple mapping:** many IR operations correspond directly to machine instructions.

```
t = a + b  ->  ADD r1, r2, r3
t = a * b  ->  MUL r1, r2, r3
```

**Complex addressing:** exploit addressing modes available on the target.

```
# x86: memory operand with displacement
t = *(base + offset)  ->  MOV rax, [rbx + 8]
```

**Tree pattern matching:** represent IR as an expression tree; use a pattern matcher to tile the tree with machine instruction templates. The tiling with minimum cost is selected (dynamic programming over the tree, BURS: bottom-up rewriting systems).

**CISC vs. RISC:**
- **RISC (ARM, RISC-V):** load/store architecture; arithmetic on registers only; simple fixed-size instructions; many registers. IR maps cleanly.
- **CISC (x86-64):** complex instructions; memory operands; variable-length encodings; fewer registers. Instruction selection exploits complex addressing modes for efficiency.

## Register Allocation

Physical registers are a scarce resource. The compiler must assign virtual registers (or variables) to physical registers; values that don't fit must be **spilled** to memory (the stack frame).

### Graph Coloring Register Allocation

Model the problem as graph coloring.

**Interference graph:** nodes are virtual registers; an edge connects two nodes if they are live at the same point (they interfere: cannot share a register).

**Graph coloring:** assign colors (physical registers) to nodes such that no adjacent nodes share a color. If the graph is $k$-colorable ($k$ = number of physical registers), no spills are needed.

**Algorithm (Chaitin):**
1. Build the interference graph using liveness analysis.
2. Simplify: remove nodes with degree $< k$ (they can always be colored).
3. Potential spill: if no node has degree $< k$, spill a node.
4. Rebuild after spilling; repeat.
5. Color the simplified graph by assigning registers.

**Coalescing:** merge copy-related nodes (variables connected by `x = y`) to eliminate the copy. May increase interference; must be done carefully.

**SSA-based allocation:** SSA form simplifies register allocation; interference graph for SSA is chordal, enabling polynomial-time optimal coloring.

### Linear Scan Register Allocation

Simpler and faster than graph coloring; used by JIT compilers (JVM HotSpot, LLVM JIT).

1. Compute live intervals for each virtual register.
2. Sort intervals by start point.
3. Allocate a physical register greedily; when registers run out, spill the interval with the largest end point.

$O(n \log n)$ in the number of variables; much faster than graph coloring's pseudo-polynomial complexity.

### Spilling

When a virtual register must be spilled:
1. Allocate a stack slot.
2. Insert a **store** after each definition of the register.
3. Insert a **load** before each use.

Minimize spill cost by choosing to spill values used infrequently (outside loops preferred over inside loops).

## Calling Conventions

Standardized rules for how functions pass arguments and return values, and which registers must be preserved across calls.

**x86-64 System V ABI (Linux/macOS):**
- Arguments: RDI, RSI, RDX, RCX, R8, R9 (first 6 integers); XMM0-XMM7 (floating-point); further arguments on stack.
- Return value: RAX (integer); XMM0 (float).
- Caller-saved (volatile): RAX, RCX, RDX, RSI, RDI, R8-R11, XMM0-XMM15.
- Callee-saved (non-volatile): RBX, RBP, R12-R15.
- Red zone: 128 bytes below RSP reserved for leaf functions (no function call needed).

**Stack frame layout:**

```
[previous frame]
[return address]      <- RSP after call
[saved RBP]           <- RBP (frame pointer)
[local variables]
[spilled registers]
[outgoing args]       <- RSP during call
```

## Instruction Scheduling

Reorder instructions to avoid pipeline stalls while preserving data dependences.

**Data dependences:**
- RAW (read after write): instruction $j$ reads a value written by instruction $i$. True dependence; cannot reorder.
- WAW (write after write): two writes to the same register.
- WAR (write after read): must write after the read completes.

**List scheduling:**
1. Build a dependence graph (DAG).
2. Maintain a ready list (instructions with all dependences satisfied).
3. Greedily pick the instruction from the ready list with the highest priority (e.g., critical path length).

**VLIW (Very Long Instruction Word):** the compiler explicitly fills instruction slots in parallel bundles. Common in DSPs (TI C6000); the Itanium (IA-64) architecture.

## Peephole Optimization

Apply local transformations on a small window of generated instructions.

```
MOV r1, r2
MOV r2, r1      # redundant if r2 not used after this
->
MOV r1, r2

ADD r1, 0       # adding zero is a no-op
->
(remove)

JMP label
label:          # jump to immediately following instruction
->
(remove)
```
