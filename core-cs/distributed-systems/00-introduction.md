# Introduction to Distributed Systems

A distributed system is a collection of independent computers that appear to their users as a single coherent system. The computers communicate over a network, coordinate their actions, and share resources.

## Why Build Distributed Systems?

**Scalability:** a single machine has limits on CPU, memory, storage, and network bandwidth. Distribute the load across many machines.

**Availability:** if one machine fails, others continue to serve requests. Replicate data and services.

**Geographic distribution:** place servers close to users to reduce latency.

**Cost efficiency:** commodity hardware is cheaper than high-end mainframes; horizontal scaling is often more cost-effective than vertical scaling.

**Specialization:** different components can use hardware optimized for their workload (storage-optimized, compute-optimized, memory-optimized).

## Challenges

**Partial failure:** some components fail while others continue. Unlike a single machine (crash = nothing works), a distributed system must cope with some nodes being unavailable while the rest keep running.

**Network unreliability:** messages can be lost, delayed, reordered, or duplicated. A sender cannot distinguish between "the receiver crashed" and "the message was lost."

**Concurrency:** many processes run simultaneously and may conflict.

**Heterogeneity:** nodes may run different hardware, OS, and software.

**No global clock:** there is no single source of truth for time. Clocks drift. Causality must be inferred.

**Consistency:** keeping data consistent across replicas when they can be updated independently.

## Fallacies of Distributed Computing

Eight common false assumptions developers make:

1. The network is reliable.
2. Latency is zero.
3. Bandwidth is infinite.
4. The network is secure.
5. Topology doesn't change.
6. There is one administrator.
7. Transport cost is zero.
8. The network is homogeneous.

These fallacies lead to systems that work in development but fail in production.

## Properties of Distributed Systems

**Transparency:** hide distribution from users and applications. Access, location, migration, replication, failure, and concurrency transparency.

**Openness:** use standard interfaces and protocols so components can be replaced or extended.

**Scalability:** scale in size (more users, more data), geography (wider area), and administration (more organizations).

**Dependability:** availability (system is up and usable), reliability (correct operation over time), safety (no catastrophic failures), maintainability (ease of repair).

## System Models

**Communication models:**
- **Synchronous:** bounded message delays and processing times. Easier to reason about; unrealistic for WANs.
- **Asynchronous:** no bounds on delays. More realistic; harder to build fault-tolerant protocols.
- **Partially synchronous:** asynchronous most of the time, synchronous eventually. Used to prove practical protocols (Paxos, Raft).

**Failure models:**
- **Crash-stop:** a node stops working and never restarts. Others can detect it.
- **Crash-recovery:** a node may stop and restart, losing state not written to stable storage.
- **Byzantine:** a node may exhibit arbitrary behavior (send incorrect messages, lie). The hardest to handle.

**Network models:**
- **Reliable:** no message loss.
- **Fair-lossy:** messages may be lost, but will eventually get through if retried.
- **Arbitrary loss (Byzantine network):** an adversary can drop, modify, or inject messages.

## Metrics

**Latency:** time to complete one request. Measured as median (p50), p95, p99, p999.

**Throughput:** requests per second the system can sustain.

**Availability:** fraction of time the system is operational. Typically expressed as "nines": 99.9% = 8.76 hours downtime/year; 99.99% = 52.6 minutes; 99.999% = 5.26 minutes.

**Durability:** probability of data not being lost. Measured as "nines" of annual failure probability.

**Consistency:** how up-to-date reads are relative to writes.

## Horizontal vs. Vertical Scaling

**Vertical scaling (scale up):** add more CPU, RAM, storage to a single machine. Simple; no distribution challenges; limited by hardware ceilings and cost.

**Horizontal scaling (scale out):** add more machines. Requires partitioning data and load; introduces distributed system challenges. Essentially unlimited scale.

Most modern large-scale systems use horizontal scaling with a data partitioning (sharding) strategy.

## Examples of Distributed Systems

| System | Purpose |
|--------|---------|
| Google Search | Distributed web crawl, indexing, ranking |
| Amazon DynamoDB | Distributed key-value store |
| Apache Kafka | Distributed event streaming |
| Kubernetes | Distributed container orchestration |
| Cassandra | Distributed wide-column store |
| Apache Spark | Distributed data processing |
| Bitcoin | Distributed ledger (Byzantine fault tolerant) |
