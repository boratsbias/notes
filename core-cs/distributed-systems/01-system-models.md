# System Models

System models formally describe the assumptions we make about a distributed system: how processes behave, how they communicate, and what kinds of failures can occur. Choosing the right model is critical because it determines what problems can be solved and which protocols are correct.

## Process Models

### Crash-Stop (Fail-Stop)

A process either runs correctly or permanently stops. It does not send incorrect messages. Other processes can eventually detect the failure.

**Assumption:** there exists a failure detector that will eventually mark the crashed process as failed.

**When it applies:** tightly coupled clusters with hardware failure detection, heartbeat-based monitoring.

**Protocols:** most practical consensus protocols (Paxos, Raft) assume crash-stop with partial synchrony.

### Crash-Recovery

A process may crash at any time and later restart. It can lose all in-memory state. It may retain state written to stable storage (disk, SSD) before the crash.

**Key requirement:** protocols must handle messages from a process that has restarted (it may have forgotten previous agreements). Use stable storage and monotonically increasing epoch numbers to distinguish old from new incarnations.

**When it applies:** most real systems (processes restart after crashes).

### Byzantine (Arbitrary) Failure

A process may exhibit arbitrary behavior: send wrong values, lie, omit messages, replay old messages, act maliciously.

**When it applies:** blockchain networks, multi-party systems without trust, hardware subject to bit flips.

**Cost:** Byzantine fault tolerance (BFT) requires $3f + 1$ nodes to tolerate $f$ Byzantine faults. Twice the overhead of crash-stop tolerance ($2f + 1$ nodes).

## Communication Models

### Synchronous Model

**Assumptions:**
- There is a known upper bound on message transmission time.
- There is a known upper bound on relative process clock drift.
- There is a known upper bound on processing time per step.

**Consequence:** timeouts can reliably detect failures. If no response arrives within the timeout, the other party has failed.

**Drawback:** unrealistic for WANs. Unpredictable GC pauses, network congestion, and OS scheduling can violate the bound.

### Asynchronous Model

**Assumptions:** no bounds on message delays, processing times, or clock drift.

**Consequence:** a timeout cannot distinguish a crashed process from a slow one.

**FLP Impossibility result:** in a purely asynchronous system with even one crash-stop failure, no deterministic consensus protocol can guarantee termination.

**Why it matters:** shows that consensus (and thus reliable coordination) in a fully asynchronous model is theoretically unsolvable. Practical systems add partial synchrony assumptions.

### Partial Synchrony

**The realistic model.** The system is asynchronous most of the time but periods of synchrony eventually occur. Alternatively, bounds exist but are unknown in advance.

**Consequence:** during asynchronous periods, liveness may be violated (no progress); during synchronous periods, safety is maintained and progress can be made.

**Paxos and Raft:** proven correct in the partial synchrony model. They always maintain safety (never commit incorrect values) and guarantee liveness when the network stabilizes.

## Failure Detectors

A failure detector is a distributed oracle that gives each process a list of processes it suspects have failed.

**Properties:**
- **Completeness:** eventually, every crashed process is suspected by every correct process.
- **Accuracy:** a correct process is never (or only temporarily) suspected.

**Perfect failure detector:** complete + accurate. Requires synchronous communication; impossible in general asynchronous settings.

**Eventually perfect failure detector ($\Diamond P$):** eventually accurate. Used to prove equivalence to consensus in partial synchrony.

**Heartbeats:** the practical implementation of failure detection. Each process sends periodic heartbeats; others suspect failure if no heartbeat arrives within a timeout.

**Adaptive timeouts:** adjust timeout based on observed message latency to reduce false positives under high load (e.g., Phi Accrual Failure Detector used in Cassandra and Akka).

## Network Models

### Message Loss and Duplication

Real networks drop, delay, duplicate, and reorder messages.

**At-most-once delivery:** the sender does not retry; the message is either delivered once or not at all. Simple; may lose messages.

**At-least-once delivery:** the sender retries until acknowledged; the receiver may get duplicates. Common with heartbeats and retry loops.

**Exactly-once delivery:** each message is processed exactly once. Requires deduplication (idempotence or message IDs). The hardest to achieve; required for financial transactions.

**Idempotent operations:** safe to apply multiple times. `SET x = 5` is idempotent; `INCREMENT x` is not. Designing for idempotence simplifies at-least-once systems.

### Synchronous vs. Asynchronous I/O

**Synchronous I/O:** a process blocks until the I/O completes.

**Asynchronous I/O (event-driven, callback-based):** the process issues I/O and continues executing; a callback fires when complete. Used in high-performance servers (Node.js, Nginx, io_uring on Linux).

## Consistency and Timing Assumptions

**Linearizability:** the strongest single-object consistency model. Operations appear to take effect atomically at some point between their invocation and response. Requires coordination; typically achievable only in synchronous or partially synchronous systems.

**Eventual consistency:** given no new updates, all replicas will eventually converge. Achievable in asynchronous systems; sacrifices real-time guarantees.

The choice of system model and consistency guarantee determine which algorithms are correct and what performance is achievable.
