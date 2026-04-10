# Introduction to Databases

A database is an organized collection of data that supports efficient storage, retrieval, and modification. A Database Management System (DBMS) is the software layer that manages the database and provides a query interface.

## Why Use a Database?

**Without a DBMS:** store data in files. Problems: data redundancy (same data in multiple files), inconsistency (updates in one file not reflected in others), difficulty querying, no concurrency control (two programs writing simultaneously can corrupt data), no crash recovery.

**With a DBMS:** data abstraction, declarative queries, consistency enforcement, concurrent access, crash recovery, access control.

## Core Concepts

**Data model:** a conceptual framework for representing data and relationships. Relational, document, key-value, graph, column-family, time-series.

**Schema:** the structure of the database: tables, columns, data types, constraints.

**Instance:** the actual data stored at a given point in time.

**Query language:** a way to retrieve and manipulate data. SQL (relational), MongoDB Query Language, Cypher (graph), DynamoDB API.

**Transaction:** a unit of work that must execute atomically (all or nothing).

## DBMS Architecture

```
Application
  -> Query Interface (SQL)
  -> Query Processor
       -> Parser
       -> Optimizer
       -> Execution Engine
  -> Storage Engine
       -> Buffer Pool (page cache)
       -> Storage Manager (files, pages)
  -> Transaction Manager
       -> Lock Manager
       -> Log Manager
```

**Query processing pipeline:**
1. **Parse:** validate SQL syntax; build a parse tree.
2. **Rewrite:** apply logical transformations (view substitution, predicate pushdown).
3. **Optimize:** enumerate physical plans; estimate costs; choose the best plan.
4. **Execute:** run the plan and return results.

## Data Abstraction Levels

**Physical level:** how data is stored on disk (pages, files, indexes).

**Logical level:** what data is stored (tables, columns, types, constraints).

**View level:** a customized view of data for a specific user or application.

This separation enables changes at one level without affecting others.

## ACID Properties

**Atomicity:** a transaction either commits (all changes applied) or aborts (all changes rolled back). No partial updates.

**Consistency:** a transaction takes the database from one consistent state to another. All constraints hold before and after.

**Isolation:** concurrent transactions execute as if they were serial. One transaction's intermediate state is not visible to others.

**Durability:** once a transaction commits, its changes persist even after a crash.

## Types of Databases

| Type | Model | Examples | Best For |
|------|-------|---------|---------|
| Relational | Tables, SQL | PostgreSQL, MySQL, SQLite, Oracle | Structured data, complex queries |
| Document | JSON documents | MongoDB, Firestore, Couchbase | Nested, schema-flexible data |
| Key-value | Simple lookup | Redis, DynamoDB, Memcached | Caching, session data |
| Column-family | Wide rows | Cassandra, HBase | Write-heavy, analytics |
| Graph | Nodes, edges | Neo4j, Amazon Neptune | Relationships, social networks |
| Time-series | Timestamped events | InfluxDB, TimescaleDB | IoT, metrics, logs |
| Search | Inverted index | Elasticsearch, Solr | Full-text search |

## CAP Theorem

A distributed database can guarantee at most two of three properties:

**Consistency:** all nodes see the same data at the same time.

**Availability:** every request receives a response (not necessarily the latest data).

**Partition tolerance:** the system continues to operate despite network partitions.

Since network partitions are unavoidable in distributed systems, the real choice is between consistency and availability during a partition.

**CP systems (consistency + partition tolerance):** HBase, Zookeeper. May be unavailable during partitions.

**AP systems (availability + partition tolerance):** Cassandra, CouchDB. May return stale data during partitions.

## OLTP vs. OLAP

**OLTP (Online Transaction Processing):** many short read/write transactions; normalized schema; row-oriented storage. Examples: PostgreSQL, MySQL. Use case: applications (banking, e-commerce).

**OLAP (Online Analytical Processing):** complex analytical queries over large datasets; star/snowflake schema; column-oriented storage. Examples: Redshift, BigQuery, Snowflake, ClickHouse. Use case: business intelligence, data warehousing.

**HTAP (Hybrid Transactional/Analytical Processing):** handle both workloads. Examples: TiDB, SingleStore.
