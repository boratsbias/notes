# Distributed Systems

## Definition

A distributed system is a collection of independent computers that appears to its users as a single coherent system. The computers communicate by message passing over a network.

## Goals

- **Resource sharing:** Access remote hardware/software (files, CPUs, printers)
- **Transparency:** Hide distribution from users (location, migration, replication)
- **Openness:** Standard interfaces allowing heterogeneous systems to interoperate
- **Scalability:** Handle growth in users, data, and geography
- **Fault tolerance:** Continue operating despite component failures

## Challenges

**No shared clock:** Nodes have independent clocks that drift. No global "now."

**No shared memory:** All communication is via messages. Messages may be delayed, reordered, or lost.

**Partial failures:** Some nodes can fail while others continue. Detecting failures is itself unreliable.

**Network partitions:** Network can split, cutting communication between groups of nodes.

## Fallacies of Distributed Computing (Peter Deutsch)

1. The network is reliable
2. Latency is zero
3. Bandwidth is infinite
4. The network is secure
5. Topology doesn't change
6. There is one administrator
7. Transport cost is zero
8. The network is homogeneous

## Clocks and Time

### Physical Clocks

Hardware clocks drift. NTP (Network Time Protocol) synchronizes clocks over the network. Typical accuracy: 1-10ms over the internet, sub-millisecond on LAN.

**Cristian's algorithm:** Client asks server for time, adjusts for round-trip delay.

**Clock synchronization** cannot achieve perfect accuracy; messages take variable time.

### Logical Clocks

**Lamport timestamps:** Capture happens-before relationships.
- Each process maintains a counter
- Increment on each event
- Send counter with message
- On receive: `counter = max(local, received) + 1`

If A → B (A happens before B), then `L(A) < L(B)`.
But `L(A) < L(B)` does NOT mean A → B (only a necessary condition, not sufficient).

**Vector clocks:** Each process maintains a vector of counters (one per process).
- Precisely capture causal relationships
- `V(A) < V(B)` iff A causally precedes B
- Can detect concurrent events (neither happened before the other)

## CAP Theorem (Brewer's Theorem)

A distributed system can guarantee at most **two** of:

- **C**onsistency: Every read sees the most recent write
- **A**vailability: Every request receives a response (not an error)
- **P**artition tolerance: System continues operating despite network partitions

Since partitions are unavoidable in real networks, systems must choose CP or AP.

**CP:** Consistent but may reject requests during partition (etcd, HBase, ZooKeeper)
**AP:** Always available but may return stale data during partition (Cassandra, DynamoDB, CouchDB)

**PACELC (extension):** Also considers the latency-consistency tradeoff even without partitions.

## Consistency Models

From strongest to weakest:

| Model | Description |
|-------|-------------|
| Linearizability | Operations appear atomic, as if on one machine |
| Sequential consistency | All processes see same order of operations |
| Causal consistency | Causally related operations seen in order |
| Eventual consistency | All replicas converge to the same value eventually |

**Eventual consistency:** If no new updates, all replicas eventually return the same value. Allows for high availability and performance. Used by DNS, Amazon S3, Cassandra.

## Consensus

Agreement among distributed nodes on a single value despite failures.

**Requirements:**
- **Agreement:** All correct nodes decide the same value
- **Validity:** The decided value was proposed by some node
- **Termination:** All correct nodes eventually decide

**FLP Impossibility:** In an asynchronous system with even one crash-failure, consensus is impossible. (Fischer, Lynch, Paterson 1985)

Practical solutions relax the asynchrony assumption or use randomization.

### Paxos

Classic consensus algorithm. Two phases:

**Phase 1 (Prepare/Promise):**
- Proposer sends Prepare(n) to majority
- Acceptors promise not to accept proposals < n; return highest accepted value

**Phase 2 (Accept/Accepted):**
- Proposer sends Accept(n, value) to majority
- Acceptors accept if n ≥ promised

If a majority of acceptors accept → value is chosen.

Paxos is correct but complex to understand and implement.

### Raft

Consensus designed for understandability. Used in etcd, CockroachDB, TiKV.

**Leader election:** One leader per term. Leader handles all writes.

**Log replication:**
1. Client sends command to leader
2. Leader appends to log, sends AppendEntries to followers
3. Once majority acknowledge, leader commits, applies to state machine
4. Leader notifies followers, they commit

**Properties:**
- Leader has all committed entries
- Log matching: if two logs have same index and term, they are identical up to that point
- State machine safety: if a server applies an entry, no other server applies different entry for same index

### ZooKeeper (ZAB protocol)

Used for distributed coordination (service discovery, configuration, leader election). Similar to Paxos.

## Distributed Transactions

### Two-Phase Commit (2PC)

**Phase 1 (Prepare):**
- Coordinator sends Prepare to all participants
- Each participant logs to durable storage, votes Yes or No

**Phase 2 (Commit or Abort):**
- If all voted Yes → Coordinator sends Commit
- If any voted No → Coordinator sends Abort

**Problem:** If coordinator fails after Prepare but before Commit → participants are blocked (hold locks) until coordinator recovers. 2PC is **blocking**.

### Three-Phase Commit (3PC)

Adds a pre-commit phase to allow recovery without coordinator. Non-blocking but assumes no network partitions.

### Saga Pattern

For microservices: break a long transaction into a sequence of local transactions, each with a compensating transaction for rollback. Eventually consistent.

## Replication

Maintain copies of data on multiple nodes for fault tolerance and read scaling.

### Primary-Backup (Single Leader)

One primary handles writes, backups replicate asynchronously or synchronously.
- Simple, strong consistency possible
- Single point of bottleneck for writes
- Examples: MySQL replication, PostgreSQL streaming replication

### Multi-Leader

Multiple nodes accept writes. Conflict resolution needed.
- Better write availability and latency
- Complex conflict resolution
- Examples: CouchDB, DynamoDB global tables

### Leaderless (Quorum)

Writes go to W nodes, reads from R nodes. Consistent if R + W > N (quorum).
- No single point of failure
- Tunable consistency vs. availability
- Examples: Cassandra (N=3, W=2, R=2), Amazon Dynamo

## Distributed File Systems

**NFS:** Network File System. Simple, stateless (v2/v3). Client caches, no consistency guarantees.

**HDFS (Hadoop):** Write-once, large files, streaming reads. NameNode (metadata), DataNodes (blocks).

**GFS/Colossus (Google):** Append-heavy workloads, large files, commodity hardware.

**Ceph:** POSIX-compliant, no single point of failure. CRUSH algorithm for data placement.

## Remote Procedure Call (RPC)

Call a procedure on a remote machine as if it were local.

1. Client calls stub
2. Stub marshals arguments, sends message
3. Server stub unmarshals, calls procedure
4. Result marshaled and sent back
5. Client stub returns result

**Exactly-once semantics** is hard; network failures mean you may not know if the call executed. Design for **idempotency** (at-least-once is safer).

**Frameworks:** gRPC (Google, uses Protocol Buffers), Thrift (Meta), JSON-RPC.

## MapReduce

Programming model for large-scale data processing.

**Map phase:** Apply a function to each input record → produce (key, value) pairs
**Shuffle:** Group all values by key
**Reduce phase:** Aggregate values for each key

- Automatic parallelization, fault tolerance (re-execute failed tasks)
- Handles stragglers with speculative execution
- Replaced largely by Spark (in-memory) and streaming systems (Kafka, Flink)
