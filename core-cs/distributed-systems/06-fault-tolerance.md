# Fault Tolerance

Fault tolerance is the ability of a system to continue operating correctly in the presence of failures of some of its components. A fault-tolerant system detects failures, isolates them, and recovers without losing correctness or availability.

## Terminology

**Fault:** the underlying cause (a hardware defect, a software bug, a dropped packet).

**Error:** the manifestation of a fault in the system's state.

**Failure:** when a system component deviates from its specified behavior, resulting in incorrect output or unavailability.

**Fault tolerance:** the system provides correct service despite faults.

**Resilience:** the system's ability to adapt to and recover from faults quickly.

## Types of Faults

**Hardware faults:** disk crashes, RAM bit flips, CPU failures, power outages, NIC failures. Rate: a typical disk has a 1-5% annual failure rate; in a 10,000-disk cluster, 27-137 disks fail per day.

**Software faults:** bugs that crash a process, memory leaks, infinite loops, off-by-one errors, incorrect assumptions about dependencies.

**Human errors:** misconfiguration is the leading cause of outages. Incorrect firewall rules, wrong database credentials, accidentally deleting data.

**Network faults:** packet loss, latency spikes, partitions (one part of the network cannot communicate with another), asymmetric partitions (A can reach B but B cannot reach A).

## Failure Detectors

See [System Models](01-system-models) for formal treatment.

**Heartbeats:** process $A$ sends periodic pings to $B$; if $B$ does not reply within a timeout, $A$ suspects $B$ has failed.

**Phi Accrual Failure Detector (Cassandra, Akka):** instead of a binary yes/no, computes a suspicion level $\phi$ based on observed heartbeat intervals. The application sets a threshold for when to treat the process as failed.

**Adaptive timeouts:** measure round-trip times; set timeout as a multiple (e.g., $2\times$) of the 99th-percentile RTT.

## Redundancy

The fundamental technique for fault tolerance: have multiple copies so that failing one does not cause system failure.

**Hardware redundancy:** RAID for disks; redundant power supplies; ECC memory; dual NICs.

**Information redundancy:** error-correcting codes (ECC, LDPC, Reed-Solomon) for detecting and correcting data corruption.

**Time redundancy:** retry operations; transactions with rollback on failure.

**Process redundancy:** run multiple instances; if one fails, another takes over.

## Checkpointing and Recovery

**Checkpoint:** save the state of a process or system to stable storage at regular intervals. On failure, restart from the last checkpoint rather than from the beginning.

**Recovery log:** record every state change. On recovery, replay the log from the last checkpoint.

**Message logging:** record all messages received. On recovery, replay messages to restore state after the checkpoint.

## Circuit Breaker Pattern

Prevent a failing service from being repeatedly called when it is clearly unavailable.

**States:**
- **Closed (normal):** requests pass through; failure rate monitored.
- **Open:** failure rate exceeded threshold; requests fail immediately without attempting the call.
- **Half-open:** after a timeout, allow a limited number of test requests; if they succeed, close; if they fail, open again.

**Benefits:** fail fast; prevent cascading failures; allow failing services time to recover.

**Implementations:** Hystrix (Netflix, now maintenance mode), Resilience4j, Envoy (circuit breaking in service mesh).

## Bulkhead Pattern

Isolate components so that a failure in one does not consume all resources and cascade.

**Analogy:** ship bulkheads divide the hull into watertight compartments; one leak does not sink the ship.

**Implementation:** use separate thread pools, connection pools, or process groups for different operations. If one pool is exhausted, others are unaffected.

## Timeouts and Retries

**Timeouts:** every remote call must have a timeout. Without it, a slow server can cause the client to block indefinitely, consuming threads or connections.

**Retries:** on transient failure (network glitch, server overloaded), retry the request. Only safe for **idempotent** operations.

**Exponential backoff with jitter:** do not retry immediately. Wait $1 \text{ s}, 2 \text{ s}, 4 \text{ s}, \ldots, \text{max}$. Add random jitter to avoid the thundering herd problem (all clients retry at the same time).

```
delay = min(cap, base * 2^attempt) * random(0.5, 1.0)
```

## Chaos Engineering

Deliberately inject failures into a production system to verify fault tolerance.

**Netflix Chaos Monkey:** randomly terminates EC2 instances. Forces engineers to design services that tolerate instance failures.

**Chaos Kong:** terminates an entire AWS region.

**Principles:** define steady state; hypothesize it holds under failure; run experiments; verify or disprove.

**Tools:** Chaos Monkey, Gremlin, AWS Fault Injection Service, Chaos Mesh (Kubernetes).

## Distributed Coordination Services

Fault-tolerant coordination primitives needed by distributed applications.

**Apache Zookeeper:** strongly consistent (linearizable) key-value store. Provides: distributed locks, leader election, service discovery, configuration management. Uses Zab (Zookeeper Atomic Broadcast), a Paxos variant.

**etcd:** consensus-based key-value store using Raft. Used by Kubernetes for cluster state. Provides: distributed locks, leader election, watch (notification on key changes).

**Use cases:** naming services, configuration distribution, distributed locks, group membership.

## Recovery Strategies

**Fail-stop:** stop the process on fault; let another replica take over. Simple; requires external management.

**Restart in place:** the failed process restarts from a saved checkpoint on the same node. Works if the fault was transient (e.g., OOM killed due to temporary spike).

**Failover:** promote a replica to primary. Requires replication lag to be minimal (synchronous replication or fast catchup).

**Active-active:** multiple nodes handle requests simultaneously; a failure of one is immediately absorbed by the others. Highest availability; requires conflict handling for writes.
