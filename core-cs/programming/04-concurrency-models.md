# Concurrency Models

## Overview

Concurrency is the ability of a program to deal with multiple tasks that are in progress at the same time. This is distinct from parallelism: concurrent tasks may be interleaved on a single core, while parallel tasks truly execute simultaneously on multiple cores. A good concurrency model makes it easier to write correct programs that handle multiple things at once.

## Shared Memory and Threads

The traditional model for concurrency uses threads that share a common address space.

### Threads

A thread is an independent flow of execution within a process. Multiple threads share the same heap memory but have separate stacks. The OS scheduler decides which thread runs when.

### The Problem: Race Conditions

When two threads access shared data and at least one is writing, without coordination, a race condition occurs. The outcome depends on the scheduling order.

```python
# Both threads read x=0, both add 1, both write 1 — result is 1, not 2
x = 0
def increment():
    global x
    x = x + 1
```

### Mutexes and Locks

A mutex (mutual exclusion lock) ensures only one thread enters a critical section at a time.

```python
import threading
lock = threading.Lock()

def increment():
    global x
    with lock:
        x = x + 1
```

Lock-based programming is error-prone:

- **Deadlock**: two threads each hold a lock the other needs, and both wait forever
- **Priority inversion**: a high-priority thread blocked by a low-priority thread holding a lock
- **Lock contention**: many threads competing for the same lock reduces parallelism

### Condition Variables and Semaphores

Condition variables let threads wait until some condition is true. Semaphores generalize mutexes to allow N concurrent accesses. Together with locks, they are the building blocks of classic synchronization.

### Monitors

A monitor bundles a mutex and condition variables together with the data they protect. Java's `synchronized` keyword implements a monitor per object.

## Software Transactional Memory (STM)

STM applies database-style transactions to memory. Threads declare a transaction block; the runtime detects conflicts and retries if needed. The programmer does not manage locks directly.

```clojure
(dosync
  (alter account1 - amount)
  (alter account2 + amount))
```

If another thread modifies `account1` or `account2` concurrently, the transaction is retried. STM avoids deadlocks and is composable, but has overhead from tracking reads/writes.

## Message Passing

Instead of sharing memory, threads (or processes) communicate by sending messages. There is no shared state, so many concurrency bugs disappear by construction.

### CSP (Communicating Sequential Processes)

CSP, formalized by Tony Hoare, models concurrent systems as independent processes that communicate over channels. A send and receive must happen simultaneously (rendezvous).

**Go** implements CSP with goroutines and channels:

```go
ch := make(chan int)

go func() {
    ch <- 42  // send
}()

value := <-ch  // receive
```

The Go motto captures the idea: "Do not communicate by sharing memory; instead, share memory by communicating."

### The Actor Model

Actors are independent units of computation that communicate by sending asynchronous messages to each other's mailboxes. Each actor processes one message at a time and can:

- Send messages to other actors
- Create new actors
- Change its own behavior for the next message

There is no shared state between actors. This model is fault-tolerant by design.

**Erlang/Elixir** are built around actors (called processes):

```elixir
pid = spawn(fn ->
  receive do
    {:hello, sender} -> send(sender, :world)
  end
end)

send(pid, {:hello, self()})
```

Erlang's "let it crash" philosophy pairs with supervisors that automatically restart failed actors. This model powers Whatsapp, Discord, and large telecom systems.

**Akka** brings the actor model to the JVM (Scala/Java).

## Event Loop and Async I/O

Instead of using multiple threads, a single-threaded event loop handles concurrency by interleaving I/O-bound tasks without blocking.

When a task is waiting for I/O (a network response, a file read), the event loop parks it and runs another task. When the I/O completes, the original task resumes.

```javascript
async function fetchData(url) {
    const response = await fetch(url);  // yield control while waiting
    const data = await response.json();
    return data;
}
```

Node.js popularized this model for servers. Python's `asyncio`, Rust's `tokio`, and Kotlin's coroutines follow similar principles.

This model works well for I/O-heavy workloads. It performs poorly for CPU-heavy work since there is only one thread.

## Coroutines and Green Threads

Coroutines are functions that can pause and resume. They are lighter weight than OS threads.

**Green threads** (user-space threads) are scheduled by the runtime, not the OS. Thousands can exist in one process with low overhead.

Go's goroutines are green threads: cheap to create (a few KB of stack), multiplexed onto OS threads by the Go runtime.

## Parallelism with Data Decomposition

For CPU-bound work, true parallelism is needed. Common patterns:

- **Fork-join**: split work into sub-tasks, run in parallel, merge results. Java's `ForkJoinPool` and `parallel streams` use this.
- **MapReduce**: map a function over partitions of data in parallel, then reduce the results. The model behind Hadoop and Spark.
- **SIMD / GPU**: apply the same instruction to many data elements simultaneously.

## Immutability as a Concurrency Tool

If data cannot be mutated, it can be freely shared between threads without synchronization. This is why functional programming and concurrency pair well together. Clojure's persistent data structures and Rust's ownership system both enforce this at the language level.

## Rust's Ownership Model

Rust's compiler statically enforces that:

- Only one thread can mutate data at a time (no data races)
- References cannot outlive the data they point to (no dangling pointers)

This makes Rust programs free of data races by construction, without a GC.

## Summary of Models

| Model | Sharing | Communication | Examples |
|---|---|---|---|
| Shared memory + locks | Shared mutable state | Direct access | Java, C++, Python threads |
| STM | Shared, transactional | Direct access | Clojure, Haskell STM |
| CSP | No sharing | Synchronous channels | Go |
| Actor model | No sharing | Async message passing | Erlang, Akka |
| Event loop | Single thread | Callbacks / async/await | Node.js, asyncio |
| Ownership (Rust) | Controlled sharing | Direct access | Rust |
