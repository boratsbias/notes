# Deadlocks

## Definition

A set of processes is deadlocked when every process in the set is waiting for an event that can only be triggered by another process in the set. No process can proceed.

## Four Necessary Conditions (Coffman Conditions)

All four must hold simultaneously for deadlock to occur:

1. **Mutual exclusion**: At least one resource is held in a non-shareable mode
2. **Hold and wait**: A process holds resources while waiting for additional resources
3. **No preemption**: Resources cannot be forcibly taken from a process; they must be released voluntarily
4. **Circular wait**: A circular chain of processes exists, each waiting for a resource held by the next

## Resource Allocation Graph (RAG)

A directed graph to model resource allocation state.

- **Circles** = processes
- **Squares** = resource types (dots inside = instances)
- **Request edge** P → R = process P is waiting for resource R
- **Assignment edge** R → P = resource R is assigned to process P

**Cycle detection:**
- If each resource type has **one instance**: cycle → deadlock
- If resources have **multiple instances**: cycle is necessary but not sufficient for deadlock

## Deadlock Handling Strategies

### 1. Prevention (Eliminate a Coffman Condition)

**Eliminate mutual exclusion:** Make resources shareable (not always possible).

**Eliminate hold-and-wait:**
- Require process to request ALL resources before starting (low utilization, starvation possible)
- Require process to release all held resources before requesting new ones

**Eliminate no preemption:**
- If a process requests a resource and can't get it, release all currently held resources and retry
- Works for resources whose state can be saved/restored (CPU registers, memory)

**Eliminate circular wait:**
- Impose a total ordering on resource types
- Require processes to request resources in increasing order
- Guarantees no cycle can form

### 2. Avoidance (Stay in Safe State)

Requires advance knowledge of maximum resource needs per process.

**Safe state:** A state where the OS can find a sequence to allocate resources such that every process completes.

If we're in a safe state → no deadlock. If in unsafe state → deadlock is possible (but not certain).

**Banker's Algorithm** (Dijkstra):

```
For each process i:
  Need[i] = Max[i] - Allocation[i]

Safety Algorithm:
  Work = Available
  Finish[i] = false for all i
  Find i such that Finish[i]=false AND Need[i] ≤ Work
  Work += Allocation[i]; Finish[i] = true
  Repeat until no such i
  If all Finish[i] = true → safe state
```

Resource request: Grant only if resulting state is safe.

**Limitation:** Must know maximum needs in advance. Not practical for most OS use.

### 3. Detection and Recovery

Allow deadlock to occur, detect it, then recover.

**Detection:**
- Single instance per resource type: detect cycle in RAG
- Multiple instances: run a detection algorithm (similar to Banker's safety check but with actual allocations)

**Recovery options:**

**Process termination:**
- Kill all deadlocked processes (simple, expensive)
- Kill one at a time until deadlock broken (needs re-detection after each kill)
- Priority for killing: lowest priority, most time remaining, most resources held

**Resource preemption:**
- Select a victim process and take its resources
- Roll back the victim to a safe state (requires checkpointing)
- Must avoid starvation (same process should not always be victim)

### 4. Ignorance (Ostrich Algorithm)

Pretend deadlock never happens. Reboot or let user handle it.

Used in most practical OS (Linux, Windows) because:
- Deadlocks are rare in normal usage
- Prevention/avoidance is expensive and limits performance
- Users can kill processes manually

## Livelock

Processes are not blocked but keep retrying failed operations and make no progress.

Example: Two processes each step aside for the other in a corridor and keep doing so forever.

Solution: Introduce randomness in retry timing (e.g., Ethernet CSMA/CD backoff).

## Starvation vs Deadlock

| | Deadlock | Starvation |
|--|---------|-----------|
| Cause | Circular wait for resources | Indefinite low-priority waiting |
| Affected processes | All in the cycle | Low-priority processes |
| Resolution | Break the cycle | Aging (increase priority over time) |

## Practical Examples

**Database deadlock:** Two transactions each hold a lock and wait for the other's lock.
- Detection: Databases run periodic deadlock detection and roll back one transaction.

**Mutex deadlock in code:**
```c
// Thread 1          // Thread 2
lock(A);            lock(B);
lock(B);  // waits  lock(A);  // waits
```
Solution: Always acquire locks in the same order.

**Dining philosophers:** Classic model of circular wait (see Process Synchronization notes).
