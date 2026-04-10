# Transactions

A transaction is a sequence of database operations that must execute as a single logical unit. Transactions are the mechanism for maintaining consistency and reliability in the face of concurrent access and system failures.

## ACID Properties

**Atomicity:** all operations in a transaction commit or all roll back. No partial execution.

**Consistency:** a transaction takes the database from one valid state to another. All integrity constraints hold before and after.

**Isolation:** concurrent transactions execute as if they were serial. Each transaction sees a consistent snapshot; intermediate states are hidden from others.

**Durability:** once committed, changes persist even after a crash.

## Transaction Lifecycle

```sql
BEGIN;
    -- read and write operations
COMMIT;    -- make changes permanent

-- or
ROLLBACK;  -- undo all changes since BEGIN
```

**Savepoints:**

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
SAVEPOINT before_transfer;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- something goes wrong:
ROLLBACK TO SAVEPOINT before_transfer;
COMMIT;
```

## Concurrency Problems

Without proper isolation, concurrent transactions can cause:

**Dirty read:** a transaction reads data written by an uncommitted transaction.

**Non-repeatable read:** a transaction reads the same row twice and gets different values (another transaction committed in between).

**Phantom read:** a transaction runs the same query twice and gets different sets of rows (another transaction inserted/deleted rows).

**Lost update:** two transactions read the same value, both modify it, one overwrites the other's update.

**Write skew:** two transactions read overlapping data and write to non-overlapping data, violating a constraint.

## Isolation Levels

SQL standard defines four isolation levels, trading performance for isolation:

| Isolation Level | Dirty Read | Non-Rep Read | Phantom |
|----------------|-----------|-------------|---------|
| READ UNCOMMITTED | Possible | Possible | Possible |
| READ COMMITTED | Prevented | Possible | Possible |
| REPEATABLE READ | Prevented | Prevented | Possible |
| SERIALIZABLE | Prevented | Prevented | Prevented |

**READ COMMITTED:** the default in PostgreSQL and Oracle. Each query sees only committed data. Different queries in the same transaction may see different data.

**REPEATABLE READ:** the default in MySQL InnoDB. A snapshot is taken at the start of the transaction; all reads see that snapshot.

**SERIALIZABLE:** transactions execute as if they were serial. Highest isolation; most expensive.

## Concurrency Control Mechanisms

### Locking (Pessimistic)

Acquire locks before accessing data; release after commit/rollback.

**Shared lock (S):** multiple transactions can hold it simultaneously; used for reads.

**Exclusive lock (X):** only one transaction at a time; used for writes.

**Lock compatibility:**

| | S held | X held |
|--|--------|--------|
| Request S | Compatible | Incompatible |
| Request X | Incompatible | Incompatible |

**Two-Phase Locking (2PL):**
- **Growing phase:** acquire locks; do not release any.
- **Shrinking phase:** release locks; do not acquire any.

2PL guarantees serializability. **Strict 2PL:** hold all locks until commit; prevents dirty reads; used in most systems.

**Deadlock:** two transactions each hold a lock the other needs. Detection: wait-for graph cycle. Resolution: abort one transaction (victim selection). Prevention: lock ordering or timeouts.

### MVCC (Multi-Version Concurrency Control)

Writers do not block readers; readers do not block writers. Each write creates a new version; readers see the appropriate version for their snapshot.

**How it works (PostgreSQL):** each row version (tuple) has `xmin` (transaction that created it) and `xmax` (transaction that deleted/updated it). A read sees a tuple if `xmin` is committed before the reader's snapshot and `xmax` is absent or not yet committed.

**Benefits:** readers never wait for writers; good read scalability; snapshot isolation is natural.

**Garbage collection:** old row versions must be vacuumed. PostgreSQL's autovacuum.

### Optimistic Concurrency Control (OCC)

Read and execute without locking; at commit time, validate that no conflicts occurred; if conflicts exist, abort and retry.

**Good for:** low contention workloads; read-heavy workloads. **Bad for:** high contention (many aborts and retries).

## Write-Ahead Logging (WAL)

The key mechanism for atomicity and durability.

**Rule:** every change is written to the log (WAL) before it is written to the database pages.

**Redo:** on crash, reapply all committed transactions' log records.

**Undo:** on crash, roll back all uncommitted transactions' changes using log records.

**Checkpoint:** periodically flush dirty pages to disk and write a checkpoint record to the WAL. Limits the amount of log that must be replayed on recovery.

**Log sequence number (LSN):** monotonically increasing identifier for each log record. Used to ensure ordering.

WAL is also used for replication (streaming WAL to a replica).

## Distributed Transactions

When a transaction spans multiple databases or services, coordination is needed.

**Two-Phase Commit (2PC):**

1. **Prepare phase:** the coordinator asks each participant to prepare (write data and log; lock resources; vote yes or no).
2. **Commit phase:** if all voted yes, coordinator sends commit; all participants commit. If any voted no, coordinator sends abort; all roll back.

**Problems:** the coordinator is a single point of failure; if the coordinator crashes after prepare but before commit, participants may be stuck (in-doubt transactions).

**Three-Phase Commit (3PC):** adds a pre-commit phase to avoid blocking. Complex; rarely used.

**Saga pattern:** break a distributed transaction into a sequence of local transactions, each with a compensating transaction for rollback. Used in microservices.
