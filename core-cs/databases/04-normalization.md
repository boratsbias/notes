# Normalization

Normalization is the process of structuring a relational database to reduce data redundancy and improve data integrity. It decomposes tables using functional dependencies to achieve desirable properties, defined as **normal forms**.

## Anomalies in Unnormalized Schemas

**Update anomaly:** a fact is stored redundantly; updating one copy but not others leads to inconsistency.

**Insertion anomaly:** cannot insert a row without also supplying unrelated data.

**Deletion anomaly:** deleting a row unintentionally removes unrelated information.

**Example of a problematic table:**

```
StudentCourse(student_id, student_name, dept, course_id, course_name, grade)
```

Redundancies:
- `student_name` and `dept` are repeated for every course a student takes.
- `course_name` is repeated for every student taking the course.

Anomalies:
- If a student changes their name, must update all their enrollment rows.
- Cannot add a new course without a student enrollment.
- Dropping a student's last course deletes the course name.

## Functional Dependencies (Recap)

$X \to Y$: knowing the value of $X$ is enough to determine $Y$ uniquely.

- `student_id -> student_name, dept`
- `course_id -> course_name`
- `student_id, course_id -> grade`

**Primary key determination:** $K$ is a key if $K \to \text{(all attributes)}$.

## First Normal Form (1NF)

**Rule:** all attribute values are atomic (no multi-valued attributes, no repeating groups).

**Violation example:**

```
Student(id, name, phones)       -- phones is a list: {555-1234, 555-5678}
```

**Fix:** separate table `StudentPhone(student_id, phone)`.

**1NF is assumed** by standard relational theory (all modern SQL tables are 1NF by definition).

## Second Normal Form (2NF)

**Rule:** the table is in 1NF, and every non-key attribute is **fully functionally dependent** on the entire primary key (no partial dependencies).

**Applies only when:** the primary key is composite.

**Example:** `Enrollment(student_id, course_id, student_name, course_name, grade)`.

Primary key: `(student_id, course_id)`.

Partial dependencies:
- `student_id -> student_name` (depends on part of the key).
- `course_id -> course_name` (depends on part of the key).

**Fix:** decompose.

```
Student(student_id PK, student_name)
Course(course_id PK, course_name)
Enrollment(student_id FK, course_id FK, grade)  -- PK = (student_id, course_id)
```

## Third Normal Form (3NF)

**Rule:** the table is in 2NF, and no non-key attribute is transitively dependent on the primary key.

**Transitive dependency:** $A \to B$ and $B \to C$ implies $A \to C$ transitively.

**Example:** `Employee(emp_id, dept_id, dept_name, dept_location)`.

`emp_id -> dept_id` and `dept_id -> dept_name, dept_location`, so `emp_id -> dept_name, dept_location` transitively.

**Fix:** decompose.

```
Employee(emp_id PK, dept_id FK)
Dept(dept_id PK, dept_name, dept_location)
```

**3NF sufficient for most practical schemas.** It guarantees a lossless-join decomposition that preserves all functional dependencies.

## Boyce-Codd Normal Form (BCNF)

**Rule:** for every non-trivial FD $X \to Y$, $X$ is a superkey.

BCNF is stronger than 3NF. Every BCNF relation is in 3NF, but not vice versa.

**Example:** `CourseInstructor(course, instructor, room)`.

FDs: `{course, instructor} -> room` and `room -> instructor`.

The FD `room -> instructor` violates BCNF (room is not a superkey).

**Fix:**

```
CourseRoom(course PK, room)
RoomInstructor(room PK, instructor)
```

**Trade-off:** BCNF decomposition may not preserve all FDs (unlike 3NF). Sometimes 3NF is preferred to maintain dependency preservation.

## Fourth Normal Form (4NF)

**Rule:** the table is in BCNF, and there are no non-trivial multi-valued dependencies.

**Multi-valued dependency (MVD):** $X \twoheadrightarrow Y$ means: for a given $X$, the set of $Y$ values is independent of the other attributes.

**Example:** `EmployeeSkillHobby(emp, skill, hobby)`. If employees have multiple skills and multiple hobbies independently, this has MVDs `emp ->-> skill` and `emp ->-> hobby`.

**Fix:** split into `EmployeeSkill(emp, skill)` and `EmployeeHobby(emp, hobby)`.

## Denormalization

Deliberate introduction of redundancy for performance.

**When to denormalize:**
- Join-heavy queries are too slow.
- Read performance is critical and write consistency can be managed.
- The data is analytics-oriented (OLAP).

**Techniques:**
- Duplicate attributes from frequently joined tables.
- Pre-compute aggregations (summary tables, materialized views).
- Use JSON columns for flexible nested data.

**Trade-off:** faster reads; more complex writes (must keep redundant data consistent); risk of anomalies.

## Normal Form Summary

| NF | Eliminates |
|----|-----------|
| 1NF | Multi-valued attributes, repeating groups |
| 2NF | Partial dependencies on composite key |
| 3NF | Transitive dependencies |
| BCNF | All FD violations where LHS is not a superkey |
| 4NF | Multi-valued dependencies |
