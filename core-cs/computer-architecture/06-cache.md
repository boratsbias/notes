# Cache Memory

Caches are small, fast memories that store copies of frequently accessed data from slower, larger memory. They exploit temporal and spatial locality to dramatically reduce average memory access time.

## Cache Fundamentals

**Cache hit:** the requested data is in the cache. Fast: typically 4-50 cycles depending on cache level.

**Cache miss:** the data is not in the cache. Must fetch from the next level (slower memory). A miss to DRAM costs ~100-200 cycles.

**Hit rate $h$:** fraction of accesses that are hits.

**Average memory access time (AMAT):**

$$\text{AMAT} = h \times T_{\text{hit}} + (1-h) \times T_{\text{miss}}$$

For $h = 0.95$, $T_{\text{hit}} = 4$, $T_{\text{miss}} = 200$:

$$\text{AMAT} = 0.95 \times 4 + 0.05 \times 200 = 3.8 + 10 = 13.8 \text{ cycles}$$

## Cache Structure

A cache consists of **sets**. Each set consists of **ways** (lines). Each line holds a **block** (chunk of data).

**Parameters:**
- $S$: number of sets.
- $E$: number of ways (associativity).
- $B$: block size in bytes.
- Total capacity: $S \times E \times B$.

**Address decomposition (byte address):**

```
[  Tag  |  Set index  |  Block offset  ]
   t bits    s bits         b bits

s = log2(S),  b = log2(B)
```

### Direct-Mapped ($E = 1$)

Each address maps to exactly one cache line. Fast; but prone to conflict misses (two frequently used addresses map to the same line and evict each other).

### Fully Associative ($S = 1$)

All lines are in one set. A block can go anywhere. Maximum flexibility; expensive hardware (parallel comparison across all ways).

### Set-Associative ($1 < E < C/B$)

A compromise. Address maps to a set; within the set, the block can occupy any of the $E$ ways. 4-way and 8-way are common.

**Higher associativity reduces conflict misses.** Beyond 8-way, the improvement is marginal.

## Cache Placement and Replacement Policies

**Placement:** on a miss, which location in the set to fill.

**Replacement policy:** which existing line to evict when the set is full.

- **LRU (Least Recently Used):** evict the line not accessed for the longest time. Best hit rate; expensive to implement exactly for high associativity.
- **Pseudo-LRU:** approximation of LRU; used in practice.
- **FIFO:** evict the line that has been in the cache the longest.
- **Random:** evict a random line. Surprisingly competitive; easy to implement.
- **LFU (Least Frequently Used):** evict the line with the fewest accesses.

## Write Policies

**Write-hit policy:**
- **Write-through:** write to both cache and memory immediately. Simple; ensures consistency. High write traffic to memory.
- **Write-back:** write only to cache; mark the line dirty. Write to memory only when the line is evicted. Less memory traffic; more complex.

**Write-miss policy:**
- **Write-allocate (fetch-on-write):** on a write miss, fetch the block into cache, then update it. Used with write-back.
- **No-write-allocate:** on a write miss, write directly to memory without caching. Used with write-through.

Most modern CPUs: **write-back + write-allocate**.

## Cache Miss Types

**3C Model:**

**Compulsory misses (cold misses):** first access to a block always misses. Cannot be avoided; only reduced by prefetching.

**Capacity misses:** the working set is larger than the cache. Even a fully associative cache of the same size would miss.

**Conflict misses:** multiple blocks map to the same set and evict each other. Eliminated by full associativity; reduced by higher associativity.

(Some add a 4th C: **Coherence misses** in multiprocessor systems.)

## Multi-Level Caches

Modern CPUs have L1, L2, and L3 caches.

**L1:** split into instruction cache (L1-I) and data cache (L1-D). Very small (32-64 KB), very fast (4-5 cycles). Per-core.

**L2:** unified (instructions + data). Larger (256 KB - 1 MB), somewhat slower (12-15 cycles). Per-core.

**L3:** large unified cache shared across all cores (8-64 MB on modern CPUs), slower (30-50 cycles).

**Inclusive vs. exclusive caches:**
- **Inclusive:** L2 contains all lines in L1. Simplifies coherence but wastes L2 capacity.
- **Exclusive:** a line is in exactly one level. Better use of total cache space.
- **Non-inclusive (NINE):** L2 may or may not contain L1 lines. Modern CPUs (Intel, AMD) use this.

## Cache-Conscious Programming

**Row-major vs. column-major:** C arrays are row-major. Iterating column-by-column in a 2D array causes a miss on every access.

```c
// Cache-friendly: row-major access
for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++)
        sum += A[i][j];

// Cache-unfriendly: column-major access
for (int j = 0; j < N; j++)
    for (int i = 0; i < N; i++)
        sum += A[i][j];
```

**Cache blocking (tiling):** for matrix multiply, iterate over tiles that fit in cache.

**False sharing:** two cores write to different variables that share a cache line. Each write invalidates the other core's copy. Pad structures to cache line size (64 bytes) to avoid.

**Alignment:** align large data structures to cache line boundaries.

**Prefetching:** use hardware prefetchers by accessing memory in predictable patterns. Use `__builtin_prefetch` for software hints.
