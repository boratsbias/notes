# Data Models

A data model defines how data is represented, organized, and queried. The choice of data model determines what operations are natural and efficient.

## Relational Model

Proposed by Edgar Codd in 1970. Data is organized as a collection of **relations** (tables).

**Key concepts:**
- **Relation (table):** a set of rows (tuples), each with the same attributes (columns).
- **Attribute:** a named column with a domain (type).
- **Tuple (row):** a single record.
- **Schema:** the name of the relation and its attributes with types.
- **Primary key:** a set of attributes that uniquely identifies each tuple.
- **Foreign key:** a set of attributes that references the primary key of another relation.

**Example:**

```
Student(id INT PK, name VARCHAR, dept_id INT FK -> Dept)
Dept(id INT PK, name VARCHAR)
```

**Query language:** SQL (Structured Query Language), based on relational algebra.

**Strengths:** strong theoretical foundation; declarative queries; enforced integrity constraints; powerful joins.

**Used in:** PostgreSQL, MySQL, SQLite, Oracle, SQL Server.

## Document Model

Data is organized as **documents** (typically JSON or BSON).

```json
{
  "_id": "student_123",
  "name": "Alice",
  "dept": {"name": "CS", "building": "Gates"},
  "courses": [
    {"code": "CS101", "grade": "A"},
    {"code": "CS201", "grade": "B+"}
  ]
}
```

**Strengths:** flexible schema (documents in the same collection can have different fields); natural fit for hierarchical or nested data; no need for joins (embed related data).

**Weaknesses:** no standard query language; joins are expensive; consistency guarantees vary.

**Used in:** MongoDB, Firestore, CouchDB, RavenDB.

## Key-Value Model

The simplest model: a mapping from keys to values. The DBMS treats values as opaque blobs.

**Operations:** `get(key)`, `put(key, value)`, `delete(key)`.

**Strengths:** extremely fast (O(1) for all operations); horizontally scalable; simple.

**Weaknesses:** no structure in values; no complex queries; no joins.

**Used in:** Redis (values can be strings, lists, sets, hashes, sorted sets), DynamoDB (structured key-value), Memcached (pure cache).

## Column-Family Model

Data is organized as rows with sparse, dynamically typed columns grouped into **column families**.

**Example (Cassandra):**

```
Table: user_events
Partition key: user_id
Clustering key: event_timestamp
Columns: event_type, event_data
```

**Strengths:** excellent write throughput; horizontal scalability; efficient for queries on a subset of columns.

**Weaknesses:** data modeling must match query patterns; no joins; limited consistency options.

**Used in:** Apache Cassandra, HBase, Google Bigtable.

## Graph Model

Data is organized as **nodes** (entities) and **edges** (relationships), both with properties.

```
(:Person {name: "Alice"})-[:KNOWS]->(:Person {name: "Bob"})
```

**Strengths:** natural for relationship-heavy data; efficient multi-hop traversal; expressive query languages (Cypher, Gremlin).

**Weaknesses:** harder to scale horizontally; less mature tooling than relational.

**Used in:** Neo4j, Amazon Neptune, JanusGraph.

**Use cases:** social networks, fraud detection, recommendation engines, knowledge graphs.

## Time-Series Model

Optimized for sequences of timestamped measurements.

**Key properties:** immutable past data; write-heavy with sequential timestamps; queries typically involve time ranges and aggregations.

```
measurement: cpu_usage
tags: host=server1, datacenter=us-east
time: 2024-01-15T12:00:00Z, value: 72.3
time: 2024-01-15T12:00:05Z, value: 74.1
```

**Used in:** InfluxDB, TimescaleDB, Prometheus, Apache Druid.

## Wide-Column / Columnar Storage

**Row-oriented storage (OLTP):** stores entire rows together. Fast for retrieving all columns of a row (point lookups, updates).

**Column-oriented storage (OLAP):** stores each column separately. Fast for aggregations over one or a few columns of many rows. Excellent compression (similar values together). Used in analytics databases.

| Store | Row-based | Column-based |
|-------|----------|-------------|
| Storage | All cols of a row together | All rows of a col together |
| Read all cols of one row | 1 I/O | $n$ I/Os |
| Aggregate over 1 col | Read all cols | Read 1 col |
| Best for | OLTP | OLAP |
| Examples | PostgreSQL, MySQL | Redshift, Parquet, DuckDB |

## Entity-Relationship Model

A conceptual data model used for database design. Entities (things), attributes (properties), and relationships (associations between entities).

**ER diagram components:**
- **Entity:** rectangle.
- **Attribute:** oval.
- **Relationship:** diamond.
- **Cardinality:** 1:1, 1:N, M:N.

ER diagrams are translated to relational schemas: entities become tables; M:N relationships become join tables.

## Choosing a Data Model

| Requirement | Best Model |
|-------------|-----------|
| Complex queries, joins, integrity | Relational |
| Flexible, nested, hierarchical data | Document |
| Simple caching, sessions | Key-value |
| Write-heavy, distributed, time data | Column-family |
| Relationship traversal | Graph |
| Timestamped metrics, events | Time-series |
| Analytical aggregations | Columnar |
