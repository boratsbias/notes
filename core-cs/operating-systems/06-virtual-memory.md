# Virtual Memory

## Concept

Virtual memory separates the logical address space from physical memory. Processes can run even if their entire address space isn't in RAM. Pages are brought in on demand.

**Benefits:**
- Programs can be larger than physical RAM
- More processes can run simultaneously (each partially loaded)
- Faster startup (load only what's immediately needed)
- Easy memory sharing between processes

## Demand Paging

Load pages only when they are accessed (not at process start).

**Valid-invalid bit in page table:**
- Valid (v): Page is in memory
- Invalid (i): Page is on disk or doesn't exist

**Page fault sequence:**
1. Process accesses a page marked invalid
2. Hardware raises a page fault (trap to OS)
3. OS checks: is it a valid reference or illegal access?
4. If illegal → terminate process (SIGSEGV)
5. Find a free frame (or choose a victim frame)
6. Read the page from disk into the frame
7. Update page table: mark valid, set frame number
8. Restart the faulting instruction

**Effective Access Time with paging:**
```
EAT = (1 - p) × memory_access + p × page_fault_time
```
Where p = page fault rate. Page fault service time ≈ 8ms (disk seek + rotation + transfer).
Even p = 0.001 (1 in 1000) makes EAT ~8× slower. Must keep p very low.

## Page Replacement Algorithms

When a page fault occurs and no free frames exist, OS must evict a page.

### Optimal (OPT / Bélády's)
Replace the page that won't be used for the longest time in the future. Optimal but not implementable (requires future knowledge). Used as benchmark.

### FIFO (First-In, First-Out)
Replace the page that has been in memory the longest.
- Simple, but doesn't consider usage
- **Bélády's anomaly:** More frames can cause MORE page faults with FIFO

### Least Recently Used (LRU)
Replace the page not used for the longest time. Good approximation of optimal.

**Implementation:**
- **Counter:** CPU clock value stamped on each access. Replace smallest counter. Expensive.
- **Stack:** Move accessed page to top of stack. Replace bottom. O(1) replacement but O(n) on access.

Neither is practical in hardware. Use approximations.

### LRU Approximations

**Reference bit:** Hardware sets bit to 1 when page is accessed. OS periodically clears bits.

**Additional reference bits:** 8-bit shift register per page. OS shifts bits right each period, records reference bit. Replace page with lowest binary value (least recently used).

**Clock algorithm (Second Chance):**
- Pages in a circular queue with reference bits
- "Clock hand" sweeps around
- If reference bit = 1: clear it, move on (give second chance)
- If reference bit = 0: evict this page
- Enhanced: use (reference, dirty) bits. Prefer (0,0), then (0,1), then (1,0), then (1,1)

### Counting-Based

- **LFU (Least Frequently Used):** Replace page with lowest access count
- **MFU (Most Frequently Used):** Replace page with highest count (assumption: was brought in long ago, no longer needed)
- Neither used much in practice

## Allocation of Frames

How many frames to give each process?

**Fixed allocation:**
- Equal: each process gets n/m frames (n = total, m = processes)
- Proportional: allocate based on process size

**Priority allocation:** Larger processes or higher-priority processes get more frames.

**Global replacement:** A process can steal frames from another.
- Higher throughput but one process can harm another

**Local replacement:** A process can only replace its own frames.
- More predictable per-process performance

## Thrashing

When a process doesn't have enough frames to hold its working set, it constantly page faults. The OS spends more time paging than executing: **thrashing**.

**Cause:** OS increases multiprogramming → each process has fewer frames → page faults increase → CPU utilization drops → OS admits more processes → even fewer frames → catastrophic.

**Solutions:**

**Working set model:** Track the set of pages used in the last Δ time units (working set window Δ).
- If working set > available frames → suspend process
- Ensures each active process has its working set in memory

**Page fault frequency (PFF):**
- If fault rate too high → give process more frames
- If fault rate too low → take frames away
- Simple, reactive approach

## Copy-on-Write (COW)

After `fork()`, parent and child share the same physical pages (marked copy-on-write). When either writes to a shared page, a copy is made for that process.

- Avoids copying the entire address space on fork
- Only copies pages that are actually modified
- Used by all modern UNIX/Linux systems

## Memory-Mapped Files

Map a file directly into process address space. File I/O becomes memory accesses.

```c
void *ptr = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
```

- Page faults bring in file data on demand
- `msync()` writes dirty pages back to file
- Multiple processes mapping the same file share physical pages → efficient IPC

## Kernel Memory Allocation

Kernel memory has different requirements than user memory:

**Buddy system:** Allocate memory in powers of 2. Split blocks in half until size fits. Merge adjacent buddies when freed. Fast, minimizes external fragmentation.

**Slab allocator:** Pre-allocate caches of commonly used kernel objects (task_struct, inode, etc.).
- Objects are initialized once and recycled
- Avoids repeated constructor/destructor overhead
- Linux uses SLAB, SLOB (simple), or SLUB (unqueued, default)

## Huge Pages

Regular page size is 4KB. Modern systems support huge pages (2MB or 1GB on x86-64).

**Benefits:**
- Fewer TLB entries needed to cover the same memory
- Fewer page faults for large allocations
- Better TLB coverage for databases, JVMs, etc.

**Linux:**
- `hugepages`: explicitly allocated huge pages
- `Transparent Huge Pages (THP)`: kernel automatically uses huge pages where beneficial

## NUMA and Memory Policy

In NUMA systems, memory access time depends on which node the memory is on.

- **Local allocation:** Allocate from the node the CPU is on (fastest)
- `numactl`, `set_mempolicy()` to control placement
- Linux NUMA balancing: automatically migrate pages to nodes where they're accessed
