# Relational Model

The relational model is the theoretical foundation of relational databases. Proposed by E.F. Codd in 1970, it remains the dominant data model for operational databases. Data is organized in relations (tables), and operations are expressed in relational algebra.

## Relational Algebra

The formal query language for the relational model. Every SQL query can be expressed as a relational algebra expression.

### Fundamental Operations

**Selection ($\sigma$):** returns rows satisfying a predicate.

$$\sigma_{\text{dept}='CS'}(\text{Student})$$

Equivalent SQL: `SELECT * FROM Student WHERE dept = 'CS'`

**Projection ($\pi$):** returns specified columns.

$$\pi_{\text{name, dept}}(\text{Student})$$

Equivalent SQL: `SELECT name, dept FROM Student`

**Cartesian product ($\times$):** combine every row of one relation with every row of another.

$$\text{Student} \times \text{Course}$$

**Rename ($\rho$):** rename a relation or attribute.

$$\rho_{S}(\text{Student})$$

**Union ($\cup$):** all rows from both relations (schemas must be compatible).

**Difference ($-$):** rows in the first but not the second.

**Intersection ($\cap$):** rows in both (derived: $R \cap S = R - (R - S)$).

### Derived Operations

**Join ($\bowtie$):** combine rows from two relations on a condition.

$$\text{Student} \bowtie_{\text{Student.dept\_id = Dept.id}} \text{Dept}$$

Types: inner join, left outer join, right outer join, full outer join, natural join (on all common attributes), cross join (cartesian product).

**Division ($\div$):** find values in $R$ related to all values in $S$. Equivalent to "for all" queries.

## Keys and Constraints

**Superkey:** a set of attributes that uniquely identifies each tuple.

**Candidate key:** a minimal superkey (no proper subset is a superkey).

**Primary key:** the chosen candidate key. Values must be unique and not NULL.

**Foreign key:** references the primary key of another relation. Enforces **referential integrity**: the referenced row must exist.

**Integrity constraints:**
- **Domain constraint:** each attribute value must be of the declared type.
- **NOT NULL:** attribute cannot be NULL.
- **UNIQUE:** all values in a column are distinct.
- **CHECK:** arbitrary predicate on a row or column.
- **Primary key:** unique + not null.
- **Foreign key:** referenced row must exist (or be null if nullable).

**ON DELETE / ON UPDATE actions for foreign keys:**
- `RESTRICT`: prevent deletion/update of referenced row.
- `CASCADE`: propagate delete/update to referencing rows.
- `SET NULL`: set referencing attribute to NULL.
- `SET DEFAULT`: set referencing attribute to default value.

## Functional Dependencies

A **functional dependency (FD)** $X \to Y$ means: if two rows agree on attributes $X$, they must agree on $Y$.

**Example:** `StudentID -> Name, Email` (a student ID determines name and email).

**Armstrong's Axioms:**
- **Reflexivity:** if $Y \subseteq X$, then $X \to Y$.
- **Augmentation:** if $X \to Y$, then $XZ \to YZ$.
- **Transitivity:** if $X \to Y$ and $Y \to Z$, then $X \to Z$.

**Closure of $X$ ($X^+$):** the set of all attributes determined by $X$ using the FDs. Used to check if $X$ is a superkey and to find all FDs implied by a set.

## Normalization

Decompose relations to eliminate redundancy and update anomalies. See [Normalization](04-normalization) for full treatment.

**Update anomaly:** changing redundant data in one place but not another.

**Insertion anomaly:** cannot insert a row without also inserting unrelated data.

**Deletion anomaly:** deleting a row loses unrelated information.

## Relational Calculus

An alternative formal query language equivalent in expressive power to relational algebra.

**Tuple relational calculus:** `{t | P(t)}` - the set of tuples $t$ satisfying predicate $P$. Basis for SQL.

**Domain relational calculus:** variables range over attribute values. Basis for QBE (Query By Example).

## Null Values

**NULL** represents an unknown or absent value. It is not a value itself.

**Three-valued logic:** predicates can be TRUE, FALSE, or UNKNOWN. `NULL = NULL` evaluates to UNKNOWN (not TRUE). `NULL IS NULL` is TRUE.

**Aggregation:** most aggregate functions (SUM, AVG, COUNT) ignore NULLs. `COUNT(*)` counts rows; `COUNT(column)` ignores NULLs.

**Outer joins:** left outer join returns all rows from the left relation; unmatched right-side columns are NULL. Useful for "find all X and their Y if it exists".

## Relational Database Schema Design

**Step 1: Requirements analysis.** Understand the domain; identify entities and relationships.

**Step 2: ER modeling.** Draw an ER diagram.

**Step 3: ER to relational mapping.**
- Each entity becomes a table.
- Each M:N relationship becomes a junction table.
- Each 1:N relationship is represented by a foreign key in the N side.
- Each 1:1 relationship: merge into one table or foreign key in either direction.

**Step 4: Normalization.** Eliminate redundancy; achieve 3NF or BCNF.

**Step 5: Denormalization.** Add controlled redundancy for performance (materialized views, summary tables).
