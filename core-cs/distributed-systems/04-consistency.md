# Consistency Models

Consistency models define the guarantees a distributed system makes about when and how updates become visible to different readers. Stronger consistency is easier to reason about but typically requires more coordination and higher latency. Weaker consistency enables higher availability and lower latency but places a greater burden on application developers.

## Why Consistency is Hard

In a distributed system, data is replicated across multiple nodes for availability and performance. When a write occurs on one replica, it takes time to propagate to others. During this propagation window:
- Different readers may see different values.
- The same reader may see a newer value and then a staler one.
- A writer may not immediately see its own write on a different replica.

Consistency models specify exactly which of these behaviors are allowed.

## Linearizability (Atomic Consistency)

The strongest single-object consistency model. Every operation appears to take effect instantaneously at some single point between its invocation and its response. The total order of operations is consistent with real time.

**Intuition:** the system behaves as if there is one copy of the data and all operations are executed sequentially, even though there are multiple replicas.

**Example:** if client A writes `x = 1` and client B then reads `x`, B must see 1. If B starts reading after A's write completes, B cannot see the old value.

**How to achieve:** use a consensus protocol (Paxos, Raft) to agree on a total order of writes. Every read reads from the agreed-upon log.

**Cost:** requires coordination on every operation; high latency; reduced availability during partitions (CP in CAP).

**Used in:** etcd, Zookeeper (for coordination primitives), Google Spanner (with True Time).

## Sequential Consistency

All operations appear to execute in some total sequential order, consistent with the order seen by each individual process. But the total order need not match real time.

**Weaker than linearizability:** a read may return a stale value as long as all processes agree on the same sequence of operations.

**Used in:** theoretical analyses; some replicated state machines.

## Causal Consistency

Operations that are causally related must be seen in the same order by all processes. Concurrent operations may be seen in different orders by different processes.

**Causally related:** $A$ causes $B$ if $A \to B$ (Lamport's happens-before). Example: Bob reads Alice's post, then comments. Others must see the post before the comment.

**Stronger than eventual consistency; weaker than sequential consistency.**

**Implementation:** track causality with vector clocks; delay delivery of a message until all causally prior messages have been delivered.

**Used in:** COPS (Cassandra-like with causal consistency), some MongoDB deployments.

## Eventual Consistency

Given no new updates, all replicas will eventually converge to the same value. No bound is placed on how long convergence takes.

**The weakest useful consistency model.** Replicas can diverge temporarily; conflicts must be resolved.

**Conflict resolution strategies:**
- **Last Write Wins (LWW):** the write with the highest timestamp wins. Simple; loses data when clocks are skewed.
- **Multi-value (siblings):** retain all concurrent versions; let the application or the user merge.
- **CRDTs (Conflict-free Replicated Data Types):** design operations so that any order of application converges to the same result.

**Used in:** Cassandra (default), DynamoDB (default), DNS.

## Read-Your-Writes Consistency

After a client performs a write, it will always see that write in subsequent reads (even if they go to a different replica).

**Common implementation:** route reads from the same client to the same replica; or read from the primary after a write; or use session tokens that encode the write's version.

**Why it matters:** users expect to see their own updates immediately (update profile photo; refresh; still see old photo is confusing).

## Monotonic Read Consistency

Once a client has seen a value for a variable, it will never see an older value in future reads. Reads do not go backward in time.

**Implementation:** assign a replica a session token; route subsequent reads to a replica at least as up-to-date.

## Monotonic Write Consistency

Writes by the same client are applied in the order in which they were issued.

## PRAM (Pipeline RAM) Consistency

Combines monotonic read, monotonic write, and read-your-writes. All writes by a single process are applied in program order to all replicas. Writes by different processes may be seen in different orders.

## Consistency in Practice

Most databases expose consistency through **isolation levels** (for transactions) and **consistency levels** (for replication).

**Cassandra consistency levels:**

| Level | Reads/Writes | Description |
|-------|-------------|-------------|
| ONE | Read/Write | One replica responds |
| QUORUM | Read/Write | Majority of replicas respond |
| ALL | Read/Write | All replicas respond |
| LOCAL_QUORUM | Read/Write | Majority in local datacenter |

With `QUORUM` for both reads and writes (and replication factor $N$): since $\lceil N/2 \rceil + \lceil N/2 \rceil > N$, the read and write sets overlap, guaranteeing strong consistency.

**DynamoDB:** read can be eventually consistent (default, lower latency) or strongly consistent (reads from the leader; higher latency, not available for global tables).

## CRDT (Conflict-free Replicated Data Types)

Data structures designed to be merged correctly regardless of the order updates are applied.

**G-Counter (Grow-only):** vector of per-node increments. Merge = elementwise max. Value = sum.

**PN-Counter:** two G-counters (positive and negative increments). Supports increment and decrement. Merge both G-counters independently.

**LWW-Register:** a register with a timestamp. Merge = take the higher timestamp. Risk of data loss with clock skew.

**OR-Set (Observed-Remove Set):** supports add and remove. Each add gets a unique tag; remove explicitly removes all tags for that element. Merge = union of all tags.

**Used in:** Redis (sorted sets), Riak, collaborative editors (Logoot, LSEQ, RGA for text), Apple Notes sync.
