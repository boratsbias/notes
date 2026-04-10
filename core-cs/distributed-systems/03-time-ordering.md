# Time and Ordering

Time and ordering are fundamental challenges in distributed systems. There is no global clock. Different nodes may observe events in different orders. Without careful handling, concurrent updates can lead to inconsistency.

## The Problem with Physical Clocks

**Clock skew:** different nodes have different times. Even with NTP (Network Time Protocol), clocks can differ by milliseconds to seconds.

**Clock drift:** quartz oscillators run at slightly different frequencies. Without synchronization, a machine gains or loses seconds per day.

**NTP:** synchronizes clocks using a hierarchy of time servers. Typical accuracy: ~1-50 ms on the internet; ~0.1-1 ms on a LAN.

**PTP (Precision Time Protocol, IEEE 1588):** sub-microsecond accuracy using hardware timestamps. Used in financial systems, 5G, and high-frequency trading.

**Consequences of skew:** if event $A$ happens before event $B$ but $A$'s timestamp is later than $B$'s (due to skew), using timestamps to order events gives wrong results.

**True Time (Google Spanner):** uses GPS receivers and atomic clocks in every datacenter. Provides `TT.now()` with a bounded uncertainty interval $[t_{\text{earliest}}, t_{\text{latest}}]$. Spanner waits out the uncertainty before committing to ensure external consistency.

## Logical Clocks

Logical clocks capture causality without relying on physical time.

**Causality:** event $A$ **causally precedes** event $B$ (written $A \to B$) if:
1. $A$ and $B$ are in the same process and $A$ comes first.
2. $A$ is a message send and $B$ is the corresponding receive.
3. There exists $C$ such that $A \to C$ and $C \to B$ (transitivity).

If neither $A \to B$ nor $B \to A$, the events are **concurrent** (causally independent).

## Lamport Timestamps

Proposed by Leslie Lamport in 1978. Assign a monotonically increasing integer to each event.

**Rules:**
1. Each process maintains a counter $L$, initialized to 0.
2. On each internal event or send: $L \leftarrow L + 1$; assign $L$ to the event.
3. On receiving a message with timestamp $t$: $L \leftarrow \max(L, t) + 1$; assign $L$ to the receive event.

**Property:** if $A \to B$, then $L(A) < L(B)$.

**Limitation:** the converse is not true: $L(A) < L(B)$ does not imply $A \to B$. Concurrent events may have any relative timestamp ordering.

**Tie-breaking:** to create a total order, break ties by process ID: compare $(L, \text{pid})$ lexicographically.

## Vector Clocks

Vector clocks capture causality precisely. Each process maintains a vector of counters, one per process.

**Rules:**
1. Process $i$ initializes $V_i = [0, 0, \ldots, 0]$.
2. On internal event or send: $V_i[i] \leftarrow V_i[i] + 1$.
3. On send: attach current $V_i$ to the message.
4. On receive of message with timestamp $t$ at process $i$: $V_i[j] \leftarrow \max(V_i[j], t[j])$ for all $j$; then $V_i[i] \leftarrow V_i[i] + 1$.

**Comparison:** $V \leq W$ if $V[i] \leq W[i]$ for all $i$.

- $A \to B$ iff $V(A) < V(B)$ (i.e., $V(A) \leq V(B)$ and $V(A) \neq V(B)$).
- $A$ and $B$ are concurrent iff neither $V(A) \leq V(B)$ nor $V(B) \leq V(A)$.

**Example:** processes P1, P2, P3. P1 sends to P2 at $[1,0,0]$; P2 receives and increments: $[1,1,0]$.

**Space cost:** $O(n)$ per event where $n$ is the number of processes. Expensive in large systems.

**Applications:** version vectors in DynamoDB, CRDTs, distributed debugging, conflict detection.

## Version Vectors

A simplified form of vector clocks used for tracking object versions at replicas.

Each replica has a counter in the version vector. When a replica accepts a write, it increments its own counter. Two versions are concurrent if neither is dominated by the other.

**DynamoDB:** uses version vectors. On concurrent writes, the application or a merge function resolves the conflict.

## Hybrid Logical Clocks (HLC)

Combine physical time and logical counters. Tracks causality while keeping the clock close to wall-clock time.

$$\text{HLC} = (l, c)$$
- $l$: the maximum observed physical time.
- $c$: a logical counter for events within the same $l$.

**Properties:** $\text{HLC}(A) < \text{HLC}(B)$ iff $A \to B$. $l$ stays within a small bounded skew of physical time. Used in CockroachDB and TiDB.

## Ordering and Snapshots

**Consistent global snapshot (Chandy-Lamport algorithm):** captures a snapshot of a distributed system such that the snapshot is consistent (no causality violations).

**Algorithm:**
1. Any process $P_i$ initiates: records its own local state; sends a marker on all outgoing channels.
2. On receiving a marker on channel $C_{ji}$: if not yet snapshotted, record own state and send markers on all other channels; record the state of channel $C_{ji}$ as the messages received since $P_j$'s last marker.

**Applications:** global checkpoint for recovery, distributed deadlock detection, distributed debugging.

## Sequence Numbers and Monotonic Clocks

**Monotonic clock:** guaranteed to never go backward on a single machine. Used for measuring elapsed time (not wall-clock time). `clock_gettime(CLOCK_MONOTONIC)` in Linux.

**Sequence numbers:** assigned by a centralized counter service. Globally ordered; requires coordination. Used in Kafka (partition offsets), distributed logs, database LSNs.

**Snowflake ID (Twitter):** 64-bit ID composed of timestamp (41 bits), machine ID (10 bits), sequence number (12 bits). Globally unique, roughly ordered, no coordination needed per ID (each machine has its own sequence counter).
