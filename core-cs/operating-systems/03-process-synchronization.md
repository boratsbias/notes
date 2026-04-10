# Process Synchronization

## The Critical Section Problem

A **critical section** is a code segment that accesses shared data. If two processes are in their critical sections simultaneously, a **race condition** occurs; the outcome depends on execution order.

**Requirements for a correct solution:**

1. **Mutual exclusion**: Only one process in the critical section at a time
2. **Progress**: If no one is in the CS and some want to enter, selection cannot be postponed indefinitely
3. **Bounded waiting**: A process must not wait forever to enter the CS

## Peterson's Solution (Software)

Two-process solution using shared variables `turn` and `flag[]`.

```c
// Process Pi
flag[i] = true;
turn = j;
while (flag[j] && turn == j);
// --- critical section ---
flag[i] = false;
```

Correct but only works for two processes. Modern CPUs may reorder instructions, breaking it without memory barriers.

## Hardware Solutions

### Test-and-Set (TAS)
```c
bool test_and_set(bool *target) {
    bool rv = *target;
    *target = true;     // atomically
    return rv;
}
```

```c
// Spinlock with TAS
while (test_and_set(&lock));  // busy wait
// --- critical section ---
lock = false;
```

### Compare-and-Swap (CAS)
```c
int compare_and_swap(int *val, int expected, int new_val) {
    if (*val == expected) { *val = new_val; return expected; }
    return *val;
}
```

Used in lock-free data structures. x86 instruction: `CMPXCHG`.

## Mutex Locks

High-level abstraction over hardware instructions.

```c
acquire();
// --- critical section ---
release();
```

**Spinlock:** Busy-waits (spins) in acquire. Good for short CS on multiprocessors (no context switch overhead).

**Blocking mutex:** Puts thread to sleep if lock unavailable. Better for long CS or uniprocessors.

## Semaphores

Integer variable with two atomic operations:

- `wait(S)` (P, down): Decrements S. If S < 0, block.
- `signal(S)` (V, up): Increments S. If processes waiting, wake one.

```c
wait(S):    signal(S):
S--;        S++;
if S < 0:   if S <= 0:
  block()     wakeup(process)
```

**Binary semaphore:** S ∈ {0, 1}; works like a mutex.

**Counting semaphore:** S = N; controls access to N instances of a resource.

### Producer-Consumer with Semaphore

```c
semaphore mutex = 1;    // mutual exclusion
semaphore empty = N;    // count of empty slots
semaphore full  = 0;    // count of filled slots

// Producer
wait(empty);
wait(mutex);
// add item to buffer
signal(mutex);
signal(full);

// Consumer
wait(full);
wait(mutex);
// remove item from buffer
signal(mutex);
signal(empty);
```

## Monitors

High-level synchronization construct. A monitor encapsulates:
- Shared data
- Procedures that operate on that data
- Condition variables

Only one process can be active inside the monitor at a time (mutual exclusion is automatic).

### Condition Variables

```c
condition x;
x.wait();    // suspend calling process, release monitor lock
x.signal();  // resume one waiting process
```

**Hoare semantics:** Signaler immediately gives monitor to waiter (waiter runs next).
**Mesa semantics:** Signaler continues running; waiter goes back to ready queue. Requires `while` instead of `if` for condition checks. Used in practice (Java, Pthreads).

### Monitor Example: Bounded Buffer

```java
monitor BoundedBuffer {
    int buffer[N];
    int count = 0;
    condition notFull, notEmpty;

    void insert(int item) {
        while (count == N) notFull.wait();
        buffer[...] = item;
        count++;
        notEmpty.signal();
    }

    int remove() {
        while (count == 0) notEmpty.wait();
        count--;
        notFull.signal();
        return buffer[...];
    }
}
```

## Classic Synchronization Problems

### Readers-Writers Problem

Multiple readers can read simultaneously. Writers need exclusive access.

**First readers-writers (readers preference):** No reader waits unless a writer has already been granted access.

```c
semaphore rw_mutex = 1;  // exclusive access for writers
semaphore mutex    = 1;  // protect read_count
int read_count = 0;

// Writer
wait(rw_mutex);
// write
signal(rw_mutex);

// Reader
wait(mutex);
read_count++;
if (read_count == 1) wait(rw_mutex);
signal(mutex);
// read
wait(mutex);
read_count--;
if (read_count == 0) signal(rw_mutex);
signal(mutex);
```

Problem: Writers can starve. **Second readers-writers** gives preference to writers.

### Dining Philosophers Problem

5 philosophers, 5 forks. Each needs 2 forks to eat.

**Naive solution** (each picks left then right) → deadlock.

**Solutions:**
1. Allow at most 4 philosophers to sit at a time
2. Pick both forks atomically (monitor)
3. Odd philosophers pick left-then-right; even pick right-then-left (asymmetric)

Monitor solution:
```c
enum {THINKING, HUNGRY, EATING} state[5];
condition self[5];

void pickup(int i) {
    state[i] = HUNGRY;
    test(i);
    if (state[i] != EATING) self[i].wait();
}

void test(int i) {
    if (state[i] == HUNGRY &&
        state[(i+4)%5] != EATING &&
        state[(i+1)%5] != EATING) {
        state[i] = EATING;
        self[i].signal();
    }
}
```

## Deadlock vs Livelock vs Starvation

| Problem | Description |
|---------|-------------|
| Deadlock | Processes blocked forever, each waiting for the other |
| Livelock | Processes keep changing state but make no progress |
| Starvation | A process is indefinitely denied resources |

## Memory Ordering and Barriers

Modern CPUs and compilers reorder instructions for performance. This breaks naive synchronization.

- **Memory barrier / fence:** Instruction that prevents reordering across the barrier
- `mfence` (x86), `dmb` (ARM)
- C11/C++11: `atomic_thread_fence()`, `std::atomic` with appropriate memory order

Memory order options (C++):
- `relaxed`: no ordering guarantees
- `acquire`: no reads/writes can be reordered before this load
- `release`: no reads/writes can be reordered after this store
- `seq_cst`: total sequential consistency (default, most expensive)
