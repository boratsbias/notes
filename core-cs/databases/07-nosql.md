# NoSQL

NoSQL (Not Only SQL) databases are a broad category of data stores that do not use the relational model. They were developed to address scalability and flexibility challenges that arise when relational databases meet modern web-scale workloads.

## Why NoSQL?

**Relational databases excel at:** complex queries, joins, transactions, strong consistency, structured data with a stable schema.

**Relational databases struggle with:**
- Horizontal scaling (sharding is hard).
- Very high write throughput.
- Flexible or rapidly changing schemas.
- Hierarchical, graph, or time-series data.
- Globally distributed data with low-latency local reads.

NoSQL databases trade some of the guarantees of relational databases (typically some of ACID) for scalability, flexibility, or performance.

## Key-Value Stores

The simplest NoSQL model. A key maps to an opaque value.

**Redis:**
- In-memory; persistence via RDB snapshots and AOF (Append-Only File) logging.
- Rich data types: strings, lists, hashes, sets, sorted sets (ZSETs), streams, HyperLogLogs.
- Sorted sets: `O(\log n)` ordered operations using a skip list internally.
- Use cases: caching, sessions, leaderboards, rate limiting, pub/sub, job queues, distributed locks.

**DynamoDB:**
- AWS managed key-value and document store.
- Partition key (required) + optional sort key form the primary key.
- Consistent single-digit millisecond latency at any scale.
- Single-table design: put multiple entity types in one table to minimize query round trips.
- Secondary indexes (GSI, LSI) enable alternate access patterns.

**Memcached:** simple in-memory cache. No persistence; no complex data types. Pure LRU cache.

## Document Stores

Documents (typically JSON) are the unit of storage. Rich query capabilities on document fields.

**MongoDB:**
- Collections of JSON documents (stored as BSON).
- Flexible schema: documents in the same collection can have different fields.
- Query language: `find`, `aggregate` (pipeline).
- Indexes: B-tree, text, geo, compound.
- Replication: replica sets (one primary, multiple secondaries).
- Sharding: horizontal partitioning by shard key.
- Transactions: multi-document ACID transactions (since MongoDB 4.0).
- Use cases: content management, catalogs, user profiles, event logging.

**Example query:**

```javascript
db.orders.aggregate([
  { $match: { status: "completed", total: { $gt: 100 } } },
  { $group: { _id: "$customer_id", orderCount: { $sum: 1 }, totalSpent: { $sum: "$total" } } },
  { $sort: { totalSpent: -1 } },
  { $limit: 10 }
])
```

## Column-Family Stores

Data is organized as rows with sparse, column-family-grouped columns. Optimized for high write throughput and linear horizontal scalability.

**Apache Cassandra:**
- Distributed; no single point of failure; no master.
- Data model: keyspaces (similar to databases) -> tables -> partition key + clustering key + columns.
- Partition key determines which node stores the row (consistent hashing).
- Clustering key determines the order of rows within a partition.
- **Denormalization required:** queries must be known in advance; design tables around queries (query-first design).
- Tunable consistency: `ONE`, `QUORUM`, `ALL` for reads and writes.
- Use cases: time-series, IoT, write-heavy workloads, globally distributed data.

**HBase:**
- Runs on HDFS; inspired by Google Bigtable.
- Strong consistency (unlike Cassandra's eventual consistency).
- Used at Facebook (Messages), LinkedIn.

**Example Cassandra schema (time-series):**

```cql
CREATE TABLE sensor_readings (
    sensor_id UUID,
    timestamp TIMESTAMP,
    value DOUBLE,
    PRIMARY KEY (sensor_id, timestamp)
) WITH CLUSTERING ORDER BY (timestamp DESC);
```

## Graph Databases

Store nodes (entities) and edges (relationships) with properties on both.

**Neo4j:**
- Property graph model.
- Cypher query language.
- Multi-hop traversal is efficient: follow edges without expensive joins.

```cypher
MATCH (p:Person)-[:KNOWS]->(friend)-[:KNOWS]->(fof)
WHERE p.name = 'Alice' AND NOT (p)-[:KNOWS]->(fof) AND fof <> p
RETURN DISTINCT fof.name
```

**Use cases:** social networks, fraud detection, recommendation engines, network topology, knowledge graphs.

## CAP and BASE

NoSQL databases often relax ACID in favor of **BASE**:

**B**asically **A**vailable: the system guarantees availability (responses, possibly stale).

**S**oft state: the state may change over time even without input (due to eventual consistency propagation).

**E**ventually consistent: given no new updates, all replicas will eventually converge to the same value.

**Eventual consistency:** writes propagate asynchronously. A read may return stale data shortly after a write. Examples: DynamoDB (default), Cassandra (QUORUM is stronger).

**Strong consistency:** after a write commits, all subsequent reads see the new value. Examples: Zookeeper, Google Spanner, CockroachDB.

## Choosing Between Relational and NoSQL

| Criterion | Relational | NoSQL |
|-----------|-----------|-------|
| Data structure | Fixed schema, tabular | Flexible, varied |
| Query complexity | Complex joins, ad hoc | Predefined access patterns |
| Consistency | Strong (ACID) | Tunable (eventual to strong) |
| Scale-out | Difficult | Native |
| Write throughput | Moderate | Very high (some) |
| Transactions | Full ACID | Limited (varies) |
| Examples | PostgreSQL, MySQL | MongoDB, Cassandra, Redis |

Many modern architectures use **polyglot persistence**: different data stores for different use cases. PostgreSQL for transactional data, Redis for caching, Elasticsearch for search, Cassandra for time-series.
