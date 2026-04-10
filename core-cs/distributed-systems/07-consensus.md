# Consensus

Consensus is the problem of getting a set of distributed processes to agree on a single value, even when some processes fail. It is the core primitive underlying distributed databases, replicated state machines, leader election, and distributed coordination.

## The Consensus Problem

**Formal definition:** processes propose values; all non-faulty processes must decide on a single value satisfying:

**Termination:** every non-faulty process eventually decides.

**Agreement:** no two non-faulty processes decide on different values.

**Validity:** the decided value must have been proposed by some process.

**Integrity:** each process decides at most once.

## FLP Impossibility

**Fischer, Lynch, Paterson (1985):** in a purely asynchronous system, there is no deterministic algorithm that guarantees consensus in the presence of even a single crash-stop failure.

**Intuition:** in a fully asynchronous model, a process cannot distinguish a slow process from a crashed one. There always exists an execution where the algorithm cannot safely terminate.

**Practical resolution:** add partial synchrony assumptions (timeouts) or use randomization to break the impossibility.

## Paxos

The classic consensus algorithm, proposed by Leslie Lamport. Handles crash-stop failures; requires a majority ($\lfloor n/2 \rfloor + 1$) of nodes to be alive.

### Single-Decree Paxos (Choosing One Value)

**Roles:** **Proposer** (initiates proposals), **Acceptor** (votes on proposals), **Learner** (learns the decided value).

**Phase 1: Prepare/Promise**

1. Proposer chooses a proposal number $n$ (globally unique, monotonically increasing).
2. Sends `Prepare(n)` to a quorum of acceptors.
3. Each acceptor responds with `Promise(n, accepted_n, accepted_v)` where `accepted_n, accepted_v` is the highest-numbered proposal the acceptor has previously accepted (or null if none). The acceptor promises not to accept proposals with numbers $< n$.

**Phase 2: Accept/Accepted**

1. If the proposer receives promises from a quorum:
   - If any acceptor reported a previously accepted value, use the value associated with the highest accepted proposal number.
   - Otherwise, the proposer may use its own proposed value.
2. Sends `Accept(n, v)` to the quorum.
3. Each acceptor accepts and sends `Accepted(n, v)` unless it has since promised a higher-numbered proposal.
4. Once a quorum of acceptors send `Accepted`, the value $v$ is **chosen**.

**Safety:** a quorum of acceptors ensures any two quorums overlap by at least one node. The overlapping node carries the highest accepted value forward.

### Multi-Paxos

A single Paxos round chooses one value. For a replicated log (deciding on a sequence of values), **Multi-Paxos** elects a stable leader that skips Phase 1 for subsequent log entries. The leader can drive Phase 2 directly until leadership is challenged.

**Problems with Paxos:**
- Difficult to implement correctly (many subtle edge cases).
- Does not describe leader election, log compaction, or membership change.
- "Paxos is a bit hard to understand" (Lamport himself noted this).

## Raft

Designed by Ongaro and Ousterhout (2013) as an understandable alternative to Paxos. Raft is equivalent to Multi-Paxos in terms of safety and liveness properties.

### Leader Election

**Terms:** time is divided into terms (monotonically increasing integers). Each term begins with a leader election.

**Process:**
1. Nodes start as **followers**. If no heartbeat from a leader for an election timeout (150-300 ms random), a follower becomes a **candidate**.
2. Candidate increments its term, votes for itself, sends `RequestVote(term, last_log_index, last_log_term)` to all others.
3. A node grants a vote if: it has not voted in this term, and the candidate's log is at least as up-to-date as its own.
4. If a candidate receives a majority of votes, it becomes the **leader**.

**Log up-to-date criterion:** compare last log term first; if equal, compare last log index. Higher is more up-to-date.

### Log Replication

1. Clients send commands to the leader.
2. Leader appends the command to its log; sends `AppendEntries(term, prevLogIndex, prevLogTerm, entries[], leaderCommit)` to all followers.
3. Followers append the entries if `prevLogIndex/prevLogTerm` match. Respond success or failure.
4. Once a majority of nodes have logged the entry, the leader **commits** it and applies it to the state machine.
5. Leader notifies followers of the commit; they apply to their state machines.

**Log matching property:** if two logs have an entry with the same index and term, they are identical in all entries up to that index.

### Safety

**Election restriction:** a candidate must have a log at least as up-to-date as any voter's log to win election. Guarantees the elected leader has all committed entries.

**Leader completeness:** if an entry is committed in a given term, it will be present in the logs of all future leaders.

### Log Compaction (Snapshots)

To prevent unbounded log growth, periodically take a snapshot of the current state machine state and discard preceding log entries. The snapshot is stored with the last included index and term.

### Membership Change

**Joint consensus:** use a two-phase approach. Enter a joint configuration ($C_\text{old,new}$) that requires majorities of both old and new configurations for decisions; then transition to $C_\text{new}$.

**Single-server changes:** add or remove one server at a time. Safe if majority of nodes agree.

## Byzantine Fault Tolerance (BFT)

Paxos and Raft assume crash-stop failures. Byzantine faults (nodes may lie or send arbitrary messages) require stronger protocols.

**PBFT (Practical Byzantine Fault Tolerance, Castro & Liskov 1999):** requires $3f + 1$ nodes to tolerate $f$ Byzantine faults (vs. $2f + 1$ for crash-stop). Three-phase protocol (pre-prepare, prepare, commit).

**Modern BFT:** HotStuff (used in Diem/Libra), Tendermint (used in Cosmos blockchain), SBFT. These achieve linear message complexity vs. quadratic for PBFT.

## Implementations

| System | Algorithm | Use case |
|--------|---------|---------|
| etcd | Raft | Kubernetes cluster state |
| CockroachDB | Raft (per range) | Distributed SQL |
| TiKV | Raft | Distributed KV for TiDB |
| Google Chubby | Paxos | Lock service |
| Apache Zookeeper | Zab (Paxos variant) | Coordination service |
| Consul | Raft | Service discovery |
| VoltDB | Multi-Paxos | In-memory SQL |
