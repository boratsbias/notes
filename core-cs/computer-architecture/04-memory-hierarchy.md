# Memory Hierarchy

Memory access is the dominant performance bottleneck in modern systems. The memory hierarchy exploits locality to provide the illusion of fast, large memory using a pyramid of storage technologies.

## Why a Hierarchy?

**Speed vs. capacity tradeoff:** fast memory (SRAM) is small and expensive; large memory (DRAM, disk) is slow and cheap. No single technology combines speed, capacity, and affordability.

**Locality principle:**

**Temporal locality:** a recently accessed item is likely to be accessed again soon (loop variable, instruction in a tight loop).

**Spatial locality:** if one item is accessed, nearby items will likely be accessed soon (sequential array traversal, adjacent instructions).

The hierarchy exploits locality: keep recently and frequently used data in fast memory close to the CPU.

## Memory Hierarchy Levels

| Level | Technology | Typical size | Typical latency | Bandwidth |
|-------|-----------|-------------|----------------|-----------|
| L1 cache (per core) | SRAM | 32-64 KB | 4-5 cycles | ~1 TB/s |
| L2 cache (per core) | SRAM | 256 KB - 1 MB | 12-15 cycles | ~500 GB/s |
| L3 cache (shared) | SRAM | 8-64 MB | 30-50 cycles | ~200 GB/s |
| DRAM (main memory) | DRAM | 8-128 GB | 100-200 cycles | ~50 GB/s |
| NVMe SSD | Flash | 512 GB - 8 TB | 100 µs | ~7 GB/s |
| HDD | Magnetic | 1-20 TB | 5-10 ms | ~200 MB/s |

## DRAM (Dynamic RAM)

Stores each bit as charge on a capacitor. Capacitors leak; must be refreshed periodically.

**Organization:** DRAM is organized in rows and columns. Accessing a row copies it into a row buffer (fast subsequent access to the same row).

**Latency:** opening a row (RAS), selecting a column (CAS), and reading (RAS-to-CAS delay, CAS latency). Typical: ~100 ns (100 cycles at 1 GHz).

**DRAM types:** DDR4 (current standard): 3200-5600 MT/s; DDR5 (latest): 4800-8400 MT/s. HBM (High Bandwidth Memory, stacked on-die): 1-2 TB/s; used in GPUs and ML accelerators.

## Virtual Memory

Provides each process with the illusion of a large, private address space. Maps virtual addresses to physical addresses; allows overcommitting physical memory (use disk as overflow).

See [Operating Systems: Memory Management] for detailed treatment.

**Key architectural support:**
- **TLB (Translation Lookaside Buffer):** cache of recent virtual-to-physical address translations. L1 TLB: 64 entries, 1-cycle lookup. L2 TLB: 1024+ entries, 4-6 cycles.
- **Page table walker:** hardware that traverses the page table on a TLB miss.

**TLB miss cost:** walking a 4-level page table takes 4 memory accesses (each potentially a cache miss). Huge pages (2 MB, 1 GB) reduce TLB misses by covering more address space per entry.

## Memory-Mapped I/O

Peripheral devices are mapped into the physical address space. The CPU reads/writes device registers using ordinary load/store instructions to specific physical addresses.

**Memory-mapped registers** vs. **port-mapped I/O (IN/OUT instructions, x86)**.

## Memory Bandwidth and Latency

**Bandwidth-bound computation:** limited by the rate of data transfer to/from memory. GPU matrix operations, streaming algorithms.

**Latency-bound computation:** limited by the round-trip time for memory accesses. Pointer-chasing, linked list traversal, sparse access.

**Prefetching:** predict future memory accesses and issue them early. Hardware prefetchers detect stride patterns. Software prefetch instructions (`_mm_prefetch`).

**Non-temporal stores (streaming stores):** bypass the cache for write-once data. Avoids polluting the cache with data that will never be reread.

## Memory Ordering

The CPU may reorder memory operations for performance. The memory model defines what reorderings are visible to other processors.

**Sequentially consistent (SC):** all processors see a single global order of all memory operations. Simple; expensive.

**x86 TSO (Total Store Order):** stores may be delayed in a store buffer; loads may bypass stores. Relatively strong; most SC programs work without extra barriers.

**ARM weak memory model:** extensive reordering allowed. Requires explicit memory barriers (`DMB`, `DSB`) for synchronization.

**Memory barriers / fences:** instructions that prevent reordering across them. `MFENCE` (x86), `DMB` (ARM), `fence` (RISC-V).

**Acquire/release semantics:** load-acquire (no loads/stores after it can move before it); store-release (no loads/stores before it can move after it). Used to implement mutexes and lock-free data structures.
