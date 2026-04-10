# Parallelism

Parallelism allows multiple operations to proceed simultaneously, dramatically increasing throughput. Modern systems exploit parallelism at every level: within a single instruction, across instructions, across cores, and across machines.

## Taxonomy (Flynn's)

**SISD (Single Instruction Single Data):** classic sequential processor. One instruction stream, one data stream.

**SIMD (Single Instruction Multiple Data):** one instruction operates on multiple data elements in parallel. CPU vector units (AVX, NEON), GPU cores.

**MISD (Multiple Instruction Single Data):** rare; used in fault-tolerant systems.

**MIMD (Multiple Instruction Multiple Data):** multiple independent instruction streams, each on different data. Multicore CPUs, distributed systems.

## Instruction-Level Parallelism (ILP)

Multiple independent instructions execute simultaneously within a single core.

**Superscalar:** issue multiple instructions per cycle using multiple execution units.

**Out-of-order execution (OOO):** execute instructions as soon as their operands are ready, regardless of program order.

**VLIW:** the compiler explicitly schedules multiple operations into parallel bundles.

**Limits to ILP:**

- **True data dependences (RAW):** instruction $j$ needs the result of instruction $i$.
- **Control dependences:** instructions after a branch cannot execute until the branch is resolved (mitigated by speculation).
- **Memory aliases:** the compiler/hardware may not know whether two memory addresses are different.

**IPC (Instructions Per Cycle):** modern OOO cores achieve 3-5 IPC on typical workloads; theoretical max is the issue width (4-6).

## SIMD (Vector) Parallelism

One instruction operates on a vector of data elements simultaneously.

**x86 SIMD evolution:**
- SSE: 128-bit registers (XMM); 4 floats or 2 doubles.
- AVX / AVX2: 256-bit registers (YMM); 8 floats or 4 doubles.
- AVX-512: 512-bit registers (ZMM); 16 floats or 8 doubles.

**ARM SIMD:** NEON (128-bit); SVE / SVE2 (scalable vector length: 128-2048 bits).

**RISC-V:** V extension (scalable vectors).

**Example (AVX single-precision float):**

```c
// Scalar: 8 iterations
for (int i = 0; i < 8; i++) c[i] = a[i] + b[i];

// AVX: 1 instruction for all 8
__m256 va = _mm256_load_ps(a);
__m256 vb = _mm256_load_ps(b);
__m256 vc = _mm256_add_ps(va, vb);
_mm256_store_ps(c, vc);
```

**Auto-vectorization:** modern compilers can automatically vectorize loops with simple access patterns.

## Thread-Level Parallelism (Multicore)

Multiple cores on a single chip, each executing an independent thread.

**Shared memory multiprocessor:** all cores share the same physical memory. Communicate via shared variables. Requires synchronization (locks, atomics, barriers).

**Cache coherence:** when multiple cores have cached copies of the same memory location, writes must be visible to all cores.

**MESI protocol:** cache line states: Modified, Exclusive, Shared, Invalid.
- A core wanting to write must obtain the line in Modified state; other copies are invalidated.
- A cache miss (or read) fetches the line in Shared or Exclusive state.
- A write to a Shared line requires a bus transaction to invalidate other copies.

**Coherence traffic:** at high core counts, cache coherence can become a bottleneck (false sharing, coherence storms).

**NUMA (Non-Uniform Memory Access):** in multi-socket systems, memory attached to socket A has lower latency from cores on socket A than from cores on socket B. Locality-aware thread and memory allocation is critical for performance.

## Hardware Multithreading

A single core holds multiple thread contexts and switches between them.

**Fine-grained multithreading:** switch thread every cycle. Hides latency but halves IPC for each thread.

**Coarse-grained multithreading:** switch only on long stalls (e.g., cache miss). Less overhead.

**Simultaneous multithreading (SMT / Hyper-Threading):** two threads share execution resources every cycle. The core fills pipeline slots with instructions from either thread. Intel HT: 2 threads/core; AMD SMT: 2 threads/core. Throughput gain: 15-30% on mixed workloads.

## GPU Architecture

A GPU has thousands of simple cores optimized for SIMD throughput.

**NVIDIA GPU (CUDA):** organized into SMs (Streaming Multiprocessors). Each SM has 64-128 CUDA cores. Threads execute in groups of 32 (warps). All threads in a warp execute the same instruction (SIMT: Single Instruction Multiple Threads). Latency hiding: when a warp stalls (memory), another warp runs.

**Memory hierarchy:** registers (fastest), shared memory (L1 per SM), L2 cache, global DRAM (HBM on datacenter GPUs).

**Compute capability:** NVIDIA assigns a compute capability version to each GPU architecture (e.g., 8.0 = Ampere, 9.0 = Hopper).

**CUDA programming model:** launch a grid of thread blocks; each block assigned to an SM; threads within a block can synchronize and use shared memory.

## Multiprocessor Scalability

**Amdahl's Law:** with fraction $f$ parallelizable and $N$ cores:

$$\text{Speedup} = \frac{1}{(1-f) + f/N}$$

For $f = 0.95, N = 100$: speedup $\approx 17\times$ (not $100\times$).

**Gustafson's Law:** as the problem scales with more cores (weak scaling), the parallel fraction increases and near-linear speedup is achievable.

**Scalability bottlenecks:** synchronization overhead, memory bandwidth, cache coherence traffic, load imbalance.

## Memory Consistency Models

**Sequential consistency:** all threads see the same interleaving of all memory operations. Expensive to implement.

**Relaxed models (TSO, ARM, RISC-V):** hardware may reorder independent memory operations. Programs must use memory barriers or atomic operations with acquire/release semantics for correct synchronization.

**C++11 memory model:** defines `std::atomic` with acquire, release, seq_cst, relaxed orderings.
