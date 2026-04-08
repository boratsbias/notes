# Real-Time Systems

## Definition

A real-time system must respond to inputs within a **guaranteed time bound (deadline)**. Correctness depends on both the result and the time it is delivered.

## Hard vs Soft Real-Time

| | Hard Real-Time | Soft Real-Time |
|--|---------------|---------------|
| Deadline | Must never be missed | Best effort, occasional misses acceptable |
| Consequence of miss | System failure (crash, injury, death) | Degraded quality (dropped frames, jitter) |
| Examples | Aircraft controls, pacemakers, airbag sensors | Video streaming, audio playback, games |

## Key Concepts

**Task/Job:** A unit of work with a timing constraint.

**Period (T):** For periodic tasks, how often the task recurs.

**Execution time (C):** Worst-case CPU time needed to complete the task.

**Deadline (D):** Latest time by which task must complete. Often D = T (implicit deadline).

**CPU utilization:** For a task set with n periodic tasks: `U = Σ(Ci/Ti)`

## Schedulability

A task set is **schedulable** if all tasks can meet their deadlines.

**Necessary condition:** `U = Σ(Ci/Ti) ≤ 1`

## Real-Time Scheduling Algorithms

### Rate-Monotonic Scheduling (RMS)

Static priority. Tasks with **shorter period** get **higher priority**. Priority is fixed at design time.

**Optimal** among all fixed-priority preemptive algorithms.

**Schedulability bound:**
```
U ≤ n(2^(1/n) - 1)
```
As n → ∞: U ≤ ln(2) ≈ 0.693

A task set with U ≤ 0.693 is always schedulable under RMS.
A set with U > 1 is never schedulable.
U between 0.693 and 1: may or may not be schedulable (need exact analysis).

**Example (2 tasks):**
- T1: C=1, T=4 (period 4ms, execution 1ms)
- T2: C=2, T=6 (period 6ms, execution 2ms)
- U = 1/4 + 2/6 = 0.25 + 0.33 = 0.58 ≤ 0.828 → schedulable

### Earliest Deadline First (EDF)

Dynamic priority. Task with **nearest absolute deadline** gets highest priority. Priority changes as deadlines approach.

**Optimal** for preemptive uniprocessor scheduling — can achieve U = 1 (100% utilization).

Harder to implement and analyze than RMS. Priority inversions more complex. Less predictable on overload.

### Least Laxity First (LLF)

Dynamic priority based on **laxity = deadline - remaining execution time - current time**.

Task with least slack (closest to missing deadline) runs first. Similar performance to EDF.

### Deadline Monotonic Scheduling (DMS)

Like RMS but assigns priority based on relative deadline (shorter deadline = higher priority). Better than RMS when D < T.

## Priority Inversion

When a high-priority task is blocked waiting for a resource held by a low-priority task, and a medium-priority task preempts the low-priority task.

```
High (H) ←blocked← resource held by Low (L)
Medium (M) preempts L
H waits for M (which has nothing to do with the resource)
```

**Mars Pathfinder bug (1997):** Priority inversion caused system resets on Mars. Fixed by enabling priority inheritance.

### Priority Inheritance Protocol (PIP)

When a low-priority task holds a resource needed by a high-priority task, the low-priority task temporarily **inherits** the high priority.

- L inherits H's priority while holding resource
- M cannot preempt L (L now runs at H's priority)
- L completes, releases resource, H runs
- L's priority returns to normal

### Priority Ceiling Protocol (PCP)

Each resource has a **priority ceiling** = the highest priority of any task that may lock it.

A task can lock a resource only if its priority is higher than the ceiling of all currently locked resources (by other tasks).

- Prevents deadlocks (in addition to priority inversion)
- At most one blocking per task
- More complex to implement

## Real-Time Operating Systems (RTOS)

### Key RTOS Characteristics

- **Deterministic scheduling:** Guaranteed response times
- **Low interrupt latency:** Fast context switch
- **Preemptive kernel:** Kernel code can be preempted
- **Priority-based scheduling:** Hard priority levels respected
- **Real-time clocks:** High-resolution timers
- **Minimal jitter:** Consistent, predictable execution

### Examples

| RTOS | Domain |
|------|--------|
| VxWorks | Aerospace, defense |
| QNX | Automotive, medical devices |
| FreeRTOS | Embedded, IoT |
| RTEMS | Space systems |
| PREEMPT_RT Linux | Industrial automation |
| Zephyr | IoT |

### Linux as RTOS

Standard Linux is **not** real-time — it has unbounded latency (kernel preemption disabled in many code paths).

**PREEMPT_RT patch:** Converts most spinlocks to mutexes, makes interrupt handlers preemptible. Achieves soft real-time guarantees (latency typically < 100μs).

**Xenomai / RTAI:** Co-kernel approach. Run a real-time kernel alongside Linux. Linux runs as lowest-priority task. Hard real-time with full Linux API available.

## Jitter

**Jitter:** Variation in timing (release time jitter, response time jitter).

Real-time systems must characterize and bound jitter.

Sources of jitter:
- Interrupt handling delays
- Cache misses
- Memory bus contention
- DMA activity
- OS scheduling overhead

**Mitigation:**
- Lock critical code in cache (cache locking)
- Disable interrupts during critical sections
- Dedicate a CPU core to real-time tasks
- Use NUMA-aware allocation

## Worst-Case Execution Time (WCET)

Real-time scheduling requires knowing the worst-case CPU time for each task.

**Measurement-based:** Run many times, take maximum. May miss rare slow paths.

**Static analysis:** Analyze all paths through code, model pipeline and cache effects. Tools: aiT, SWEET, Bound-T.

WCET analysis is hard in practice due to:
- Out-of-order execution
- Cache effects
- Branch prediction
- Memory bus contention (multicore)

## Real-Time Communication

**Time-Triggered (TT):** Communication occurs at predefined times. Highly predictable. CAN bus, FlexRay, TSN (Time-Sensitive Networking).

**Event-Triggered (ET):** Communication on events. Flexible but harder to bound latency. CAN (mostly event-triggered in practice).

**Time-Sensitive Networking (TSN):** IEEE 802.1 standards for deterministic Ethernet. Used in automotive (Automotive Ethernet), industrial (IIoT).
