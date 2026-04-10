# Replication

Replication is the practice of maintaining multiple copies of data on different nodes. It enables fault tolerance (survive node failures), read scalability (serve reads from multiple replicas), and geographic distribution (serve users from nearby replicas).

## Why Replicate?

**Fault tolerance:** if a node storing the only copy of data crashes, the data is lost. With $n$ replicas, $n-1$ can fail without data loss.

**Read scalability:** a single server can handle a limited number of read requests. Distribute reads across replicas.

**Low-latency global access:** place replicas in multiple regions; users read from the closest replica.

**High availability:** replicas continue serving requests when the primary fails.

## Single-Leader Replication

One node is designated the **leader** (primary, master). All writes go to the leader. The leader writes to its log and sends changes to **followers** (replicas, secondaries).

**Replication lag:** followers are behind the leader by some amount (milliseconds to seconds).

**Synchronous replication:** the leader waits for at least one follower to confirm the write before acknowledging to the client. Strong durability; slower writes.

**Asynchronous replication:** the leader acknowledges immediately; replicates in the background. Faster writes; may lose acknowledged writes if leader fails before replication.

**Semi-synchronous:** one synchronous follower; the rest asynchronous. Balances durability and performance.

### Failover

When the leader fails, a follower must be promoted to leader.

**Automatic failover (Raft, Paxos-based):** the system detects failure and elects a new leader automatically.

**Manual failover:** a human operator triggers the promotion. Slower; avoids split-brain risk.

**Split-brain:** two nodes both believe they are the leader. Both accept writes; divergence is hard to reconcile. Prevent with fencing tokens (epoch numbers) or by requiring a quorum to recognize the leader.

### Replication Methods

**Statement-based replication:** replicate the SQL statement. Non-deterministic functions (`NOW()`, `RAND()`) produce different values on replicas. Rare in modern databases.

**Write-ahead log (WAL) shipping:** stream the WAL from leader to followers; followers replay the log. Used by PostgreSQL. Tightly coupled to the storage engine; versions must match.

**Row-based (logical) replication:** replicate the actual data changes (before and after images of rows). Less coupled to storage internals; easier cross-version migration. Used by MySQL binlog row format.

**Trigger-based replication:** triggers on the leader generate change events; an application process ships them to followers. Flexible; high overhead.

## Multi-Leader Replication

Multiple nodes can accept writes. Each leader replicates to the other leaders.

**Use cases:** multi-datacenter deployments (local leader in each datacenter for low-latency writes); offline-capable clients (each device is its own leader).

**Conflict resolution required:** two leaders may accept conflicting writes to the same record.

**Conflict detection:** using version vectors or timestamps.

**Conflict resolution strategies:**
- **Last write wins (LWW):** the write with the highest timestamp wins.
- **Merge:** application-defined merge function.
- **CRDT:** use data structures that converge automatically.

**Tools:** Tungsten Replicator, MySQL NDB Cluster, CouchDB, Cassandra (multi-datacenter leaderless).

## Leaderless Replication (Dynamo-style)

No designated leader. Any replica can accept writes. Consistency is achieved through quorums.

**Parameters:** $N$ = replication factor; $W$ = write quorum; $R$ = read quorum.

**Strong consistency condition:** $W + R > N$.

**Common configuration:** $N = 3$, $W = 2$, $R = 2$. Any 2 of 3 replicas must respond to both reads and writes. Tolerates 1 node failure.

**Read repair:** when a reader gets different values from different replicas, it writes the newer value back to out-of-date replicas.

**Anti-entropy:** background process that compares replicas and reconciles differences. Uses Merkle trees to efficiently find divergent data.

**Hinted handoff:** if a replica is unavailable, another replica temporarily holds writes destined for it; when the unavailable replica recovers, the writes are delivered.

**Used in:** DynamoDB, Cassandra, Riak, Voldemort.

## Replication Topologies

**Full mesh:** every leader replicates to every other leader. $O(n^2)$ connections.

**Star:** one central node receives all writes and distributes to followers. Central node is a bottleneck.

**Circular (ring):** each node replicates to the next. A failure in one node interrupts the ring.

## Handling Replication Lag

**Reading from the leader:** always strongly consistent; increases leader load.

**Read-your-writes consistency:** route reads from the same client to the same replica, or to the leader for a configurable period after writes.

**Monotonic reads:** use sticky sessions (always read from the same replica) or track the replication position.

**Bounded staleness:** guarantee that reads are at most $t$ seconds behind the leader. Application can choose to wait or degrade.

## Replication in Practice

**PostgreSQL:** streaming replication (WAL shipping + physical replication). Supports synchronous and asynchronous standby replicas. Logical replication for selective replication.

**MySQL:** binlog replication. Asynchronous by default; semi-synchronous with plugin. Used extensively for read scaling (read replicas).

**Cassandra:** peer-to-peer gossip; tunable consistency; multi-datacenter leaderless replication with LOCAL_QUORUM.

**MongoDB:** replica sets (single-leader with automatic failover via Raft-like election). Read from secondaries with `readPreference`.
