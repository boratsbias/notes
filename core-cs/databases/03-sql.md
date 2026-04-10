# SQL

SQL (Structured Query Language) is the standard language for querying and manipulating relational databases. It is declarative: you specify *what* you want, not *how* to compute it.

## Data Definition Language (DDL)

Defines the database schema.

```sql
CREATE TABLE Student (
    id       INT          PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    email    VARCHAR(200) UNIQUE,
    dept_id  INT          REFERENCES Dept(id) ON DELETE SET NULL,
    gpa      DECIMAL(3,2) CHECK (gpa >= 0.0 AND gpa <= 4.0)
);

ALTER TABLE Student ADD COLUMN year INT;
ALTER TABLE Student DROP COLUMN year;

DROP TABLE Student;
TRUNCATE TABLE Student;  -- remove all rows, keep table
```

## Data Manipulation Language (DML)

Query and modify data.

### SELECT

```sql
SELECT name, gpa
FROM   Student
WHERE  dept_id = 3
  AND  gpa > 3.5
ORDER BY gpa DESC
LIMIT 10;
```

**Clauses execute in this logical order:**

```
FROM -> JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT
```

### INSERT

```sql
INSERT INTO Student (id, name, email, dept_id, gpa)
VALUES (1, 'Alice', 'alice@example.com', 3, 3.9);

-- Insert from query
INSERT INTO HonorsStudents (id, name)
SELECT id, name FROM Student WHERE gpa >= 3.7;
```

### UPDATE

```sql
UPDATE Student
SET gpa = gpa + 0.1
WHERE dept_id = 3;
```

### DELETE

```sql
DELETE FROM Student
WHERE gpa < 1.0;
```

## Joins

```sql
-- INNER JOIN: only matching rows
SELECT s.name, d.name AS dept
FROM   Student s
JOIN   Dept d ON s.dept_id = d.id;

-- LEFT OUTER JOIN: all students, null dept if no match
SELECT s.name, d.name
FROM   Student s
LEFT JOIN Dept d ON s.dept_id = d.id;

-- CROSS JOIN: cartesian product
SELECT s.name, c.name
FROM   Student s
CROSS JOIN Course c;

-- SELF JOIN: join a table with itself
SELECT a.name AS student, b.name AS advisor
FROM   Student a
JOIN   Student b ON a.advisor_id = b.id;
```

## Aggregation and GROUP BY

```sql
SELECT dept_id,
       COUNT(*)        AS num_students,
       AVG(gpa)        AS avg_gpa,
       MAX(gpa)        AS max_gpa,
       MIN(gpa)        AS min_gpa,
       SUM(gpa)        AS total_gpa
FROM   Student
GROUP BY dept_id
HAVING AVG(gpa) > 3.0
ORDER BY avg_gpa DESC;
```

**Aggregate functions:** `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `STRING_AGG`, `ARRAY_AGG`.

`WHERE` filters before grouping; `HAVING` filters after grouping.

## Subqueries

```sql
-- Scalar subquery
SELECT name FROM Student
WHERE gpa = (SELECT MAX(gpa) FROM Student);

-- IN subquery
SELECT name FROM Student
WHERE dept_id IN (SELECT id FROM Dept WHERE name = 'CS');

-- EXISTS subquery
SELECT name FROM Student s
WHERE EXISTS (
    SELECT 1 FROM Enrollment e WHERE e.student_id = s.id
);

-- Correlated subquery (references outer query)
SELECT name FROM Student s
WHERE gpa > (SELECT AVG(gpa) FROM Student WHERE dept_id = s.dept_id);
```

## Common Table Expressions (CTEs)

Named temporary result sets for readability and reuse.

```sql
WITH TopStudents AS (
    SELECT id, name, gpa
    FROM   Student
    WHERE  gpa >= 3.9
),
CSTopStudents AS (
    SELECT t.* FROM TopStudents t
    JOIN   Dept d ON t.dept_id = d.id  -- error: dept_id not in CTE
    -- use differently structured CTE for this
)
SELECT * FROM TopStudents;
```

**Recursive CTE:** for hierarchical queries.

```sql
WITH RECURSIVE Ancestors(id, name, parent_id) AS (
    -- Base case: starting node
    SELECT id, name, parent_id FROM Org WHERE id = 5
    UNION ALL
    -- Recursive step
    SELECT o.id, o.name, o.parent_id
    FROM   Org o
    JOIN   Ancestors a ON o.id = a.parent_id
)
SELECT * FROM Ancestors;
```

## Window Functions

Compute a value for each row relative to a partition of rows.

```sql
SELECT name, dept_id, gpa,
       RANK()        OVER (PARTITION BY dept_id ORDER BY gpa DESC) AS rank_in_dept,
       AVG(gpa)      OVER (PARTITION BY dept_id)                   AS dept_avg,
       ROW_NUMBER()  OVER (ORDER BY gpa DESC)                      AS overall_rank,
       LAG(gpa, 1)   OVER (ORDER BY id)                            AS prev_gpa,
       SUM(gpa)      OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum
FROM   Student;
```

**Window functions:** `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`, `LAG`, `LEAD`, `FIRST_VALUE`, `LAST_VALUE`, `SUM/AVG/COUNT` (as window functions).

## Indexes

```sql
CREATE INDEX idx_student_dept ON Student(dept_id);
CREATE UNIQUE INDEX idx_student_email ON Student(email);
CREATE INDEX idx_student_gpa_dept ON Student(dept_id, gpa DESC);  -- composite
```

Indexes speed up queries at the cost of slower writes and additional storage.

## Transactions

```sql
BEGIN;
UPDATE Account SET balance = balance - 100 WHERE id = 1;
UPDATE Account SET balance = balance + 100 WHERE id = 2;
COMMIT;  -- or ROLLBACK;
```

**Isolation levels:**

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  -- default in most DBs
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

## Views

```sql
CREATE VIEW CSStudents AS
SELECT s.id, s.name, s.gpa
FROM   Student s
JOIN   Dept d ON s.dept_id = d.id
WHERE  d.name = 'CS';

-- Materialized view (PostgreSQL): cached on disk
CREATE MATERIALIZED VIEW dept_stats AS
SELECT dept_id, COUNT(*) AS n, AVG(gpa) AS avg_gpa
FROM   Student GROUP BY dept_id;
REFRESH MATERIALIZED VIEW dept_stats;
```
