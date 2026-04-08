# Process Scheduling

## Goals of Scheduling

Different scenarios have different objectives:

| Goal | Description |
|------|-------------|
| CPU utilization | Keep CPU as busy as possible |
| Throughput | Maximize jobs completed per time unit |
| Turnaround time | Minimize time from submission to completion |
| Waiting time | Minimize time spent in ready queue |
| Response time | Minimize time from request to first response |
| Fairness | Each process gets a fair share of CPU |

## Scheduler Types

**Long-term (job) scheduler:** Admits processes from disk to memory. Controls degree of multiprogramming. Rare in modern systems (everything is admitted immediately).

**Short-term (CPU) scheduler:** Selects which ready process runs next. Runs very frequently (every few ms).

**Medium-term scheduler:** Swaps processes in/out of memory (swapping). Reduces degree of multiprogramming when memory is tight.

## Preemptive vs Non-Preemptive

**Non-preemptive:** Once CPU is given, process keeps it until it blocks or terminates. Simple, no race conditions. Bad for interactive systems.

**Preemptive:** OS can forcibly take CPU away (via timer interrupt). Required for interactive/real-time systems. Needs synchronization for shared data.

## Scheduling Algorithms

### First-Come, First-Served (FCFS)

Processes run in arrival order. Non-preemptive.

- Simple to implement (FIFO queue)
- **Convoy effect:** Short processes stuck behind long ones
- Poor for interactive workloads

```
P1(24ms), P2(3ms), P3(3ms) arrive at t=0
Order: P1→P2→P3
Average wait: (0+24+27)/3 = 17ms
```

### Shortest Job First (SJF)

Run the process with the shortest next CPU burst. Optimal for minimizing average wait time.

- **Non-preemptive SJF:** Current job finishes before switching
- **Preemptive SJF (SRTF):** If new job has shorter remaining time, preempt current job
- Problem: Cannot know the next CPU burst length in advance
- Approximation: Exponential averaging — `τ_{n+1} = α·t_n + (1-α)·τ_n`

### Round Robin (RR)

Each process gets a **time quantum** q. After q ms, it's preempted and goes to back of ready queue.

- Fair, good response time for interactive processes
- If q is large → degenerates to FCFS
- If q is very small → too many context switches (overhead dominates)
- Rule of thumb: 80% of CPU bursts should be shorter than q

### Priority Scheduling

Each process has a priority. Highest priority runs first. Can be preemptive or non-preemptive.

**Problem — Starvation:** Low-priority processes may never run.
**Solution — Aging:** Gradually increase priority of waiting processes.

### Multilevel Queue Scheduling

Ready queue split into multiple queues by process type:
- Foreground (interactive) — higher priority, RR
- Background (batch) — lower priority, FCFS

Queues have fixed priority. Processes cannot move between queues.

### Multilevel Feedback Queue (MLFQ)

Processes can move between queues based on behavior. The most general and widely used.

**Rules:**
1. Higher priority → run first
2. Equal priority → RR
3. New jobs start at highest priority
4. If job uses full time slice → demote to lower queue
5. If job blocks before using full slice → keep same priority (or boost)
6. After some time period, move all jobs to top queue (prevents starvation)

## Linux Completely Fair Scheduler (CFS)

Modern Linux default scheduler. Uses a red-black tree ordered by **virtual runtime (vruntime)**.

- Each process accumulates vruntime proportional to real time spent running
- CFS always picks the process with **lowest vruntime** (leftmost in tree)
- Nice values adjust the rate at which vruntime accumulates (nice -20 = slow accumulation = more CPU)
- Target latency: every runnable process gets a turn within this window
- Minimum granularity: prevents too many context switches when many processes exist

## Multiprocessor Scheduling

**Asymmetric multiprocessing (AMP):** One master CPU handles all scheduling decisions.

**Symmetric multiprocessing (SMP):** Each CPU schedules itself from a shared ready queue or per-CPU queue.

### Per-CPU Queues vs Global Queue

| | Global Queue | Per-CPU Queue |
|--|-------------|--------------|
| Load balancing | Natural | Requires explicit load balancing |
| Cache performance | Poor (cache misses when migrated) | Good (CPU affinity) |
| Scalability | Lock contention | Better |

**Load balancing:** Push migration (overloaded CPU pushes tasks) or pull migration (idle CPU pulls tasks).

**Processor affinity:** Prefer to keep a process on the same CPU to exploit warm caches. Soft affinity = preference, hard affinity = requirement.

**NUMA awareness:** Memory access is faster for local NUMA node. Scheduler tries to keep threads near their memory.

## Scheduling Metrics

**Turnaround time** = completion time − arrival time

**Waiting time** = turnaround time − burst time

**Response time** = time of first response − arrival time

**CPU utilization** = CPU busy time / total time

**Throughput** = number of processes completed per unit time

## Real-Time Scheduling

**Hard real-time:** Deadlines must never be missed (medical devices, aircraft control).

**Soft real-time:** Deadlines are important but occasional misses acceptable (video streaming).

### Rate-Monotonic (RM)
Static priority. Higher frequency → higher priority. Optimal for fixed-priority preemptive scheduling.
Schedulable if: `∑(Ci/Ti) ≤ n(2^(1/n) - 1)`

### Earliest Deadline First (EDF)
Dynamic priority. Nearest deadline → highest priority. Optimal for preemptive scheduling (can achieve 100% utilization theoretically).
