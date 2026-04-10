# Indexing

An index is a data structure that enables fast lookup of rows satisfying a query predicate. Without an index, a query must scan every row (sequential scan). With an index, it can directly locate the relevant rows.

## Why Indexes Matter

**Without index:** `SELECT * FROM Student WHERE email = 'alice@example.com'` scans all $n$ rows. $O(n)$.

**With index on email:** lookup in $O(\log n)$ (B-tree) or $O(1)$ expected (hash).

**Trade-off:** indexes speed up reads but slow down writes (the index must be updated on every INSERT, UPDATE, DELETE). They also consume additional storage.

## B-Tree Index

The default index type in PostgreSQL, MySQL, and most relational databases.

**Structure:** a balanced tree where:
- Internal nodes store keys and pointers to children.
- Leaf nodes store key-value pairs (key = indexed column, value = row identifier or the row itself).
- Leaf nodes are linked in order (B+ tree variant).

**Order $m$:** each internal node holds up to $m-1$ keys and $m$ pointers. For disk-based B-trees, $m$ is chosen so that a node fits in a single disk page (e.g., 4 KB).

**Properties:**
- All leaves are at the same depth.
- Each internal node is at least half full.
- Height: $O(\log_m n)$ for $n$ entries. With $m = 100$, a height-4 tree holds $100^4 = 100$ million entries.

**Supported operations:** equality (`=`), range (`<`, `>`, `BETWEEN`), prefix match (`LIKE 'abc%'`), `ORDER BY`, `MIN/MAX`.

**Not useful for:** suffix match (`LIKE '%abc'`), full-text search, similarity search.

## Hash Index

Uses a hash table to map keys to row locations.

**Lookup:** $O(1)$ expected for equality queries.

**Not useful for:** range queries (keys are not ordered in the hash table), prefix match, `ORDER BY`.

**PostgreSQL:** supports hash indexes; less common in practice (B-tree covers most use cases).

**In-memory databases:** hash indexes are more attractive (no disk I/O amortization needed for B-tree).

## Clustered vs. Non-Clustered Index

**Clustered index (primary index):** the table data is physically stored in the order of the index key. There can be only one clustered index per table.

- MySQL InnoDB: the primary key is always the clustered index. Rows are stored in primary key order in the B+ tree leaf pages.
- A lookup by primary key is efficient: no extra I/O to fetch the row.

**Non-clustered index (secondary index):** a separate B+ tree; leaf pages contain the index key and the row's primary key (InnoDB) or heap file location (PostgreSQL). Fetching the actual row requires a second lookup.

**Covering index:** a non-clustered index that contains all columns needed by a query. The query can be answered entirely from the index without fetching rows (index-only scan).

## Composite Index

An index on multiple columns: `CREATE INDEX idx ON Student(dept_id, gpa)`.

**Prefix rule:** the composite index can be used for queries that filter on a prefix of the indexed columns.
- `WHERE dept_id = 3`: uses the index (leftmost column).
- `WHERE dept_id = 3 AND gpa > 3.5`: uses both columns.
- `WHERE gpa > 3.5`: cannot use the index (gpa is not the leftmost column).

**Column ordering:** place the most selective (highest cardinality) columns first for equality predicates; range predicate column last.

## Partial Index

An index on a subset of rows satisfying a predicate.

```sql
CREATE INDEX idx_active_users ON Users(email) WHERE status = 'active';
```

Smaller index; useful when queries always include the predicate.

## Functional / Expression Index

Index on a computed expression.

```sql
CREATE INDEX idx_lower_email ON Users(LOWER(email));
-- Enables: WHERE LOWER(email) = 'alice@example.com'
```

## Full-Text Index

Supports searching within text content. Tokenizes text into terms; builds an inverted index (term -> set of documents/rows).

**PostgreSQL:** `CREATE INDEX idx_ft ON Articles USING GIN(to_tsvector('english', body))`. Query: `WHERE to_tsvector('english', body) @@ plainto_tsquery('database index')`.

**Elasticsearch:** purpose-built for full-text search. Stores inverted indexes; supports relevance scoring (TF-IDF, BM25), faceting, and aggregations.

## Index Selection Guidelines

**Create indexes on:**
- Primary keys (automatic).
- Foreign key columns (speed up joins; PostgreSQL does not create these automatically).
- Columns used in `WHERE`, `JOIN ON`, `ORDER BY`, `GROUP BY` clauses.
- High-cardinality columns (many distinct values) for equality predicates.

**Avoid indexes on:**
- Small tables (full scan is faster than index lookup + fetch).
- Low-cardinality columns (e.g., boolean, gender) for equality predicates.
- Columns that are updated very frequently.
- Tables with heavy write workloads.

## Query Optimizer and Index Use

The query optimizer decides whether to use an index based on estimated cost.

**Statistics:** the optimizer uses table statistics (row count, column histograms, index cardinality) to estimate the cost of different plans.

**`EXPLAIN` / `EXPLAIN ANALYZE`:**

```sql
EXPLAIN ANALYZE
SELECT * FROM Student WHERE dept_id = 3 AND gpa > 3.5;
```

Output shows the chosen plan, estimated vs. actual row counts, and execution times.

**Common issues:**
- Outdated statistics: run `ANALYZE tablename` to refresh.
- The optimizer may choose a sequential scan over an index scan if the predicate is not selective enough (e.g., matching 50% of rows).
- Force index use (as a last resort): `/*+ INDEX(Student idx_student_dept) */` (hint syntax varies by database).
