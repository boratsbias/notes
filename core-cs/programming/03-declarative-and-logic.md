# Declarative and Logic Programming

## Overview

Declarative programming is a paradigm where you describe *what* you want to compute, not *how* to compute it. You specify the desired result or constraints, and the language runtime or engine figures out the execution.

Logic programming is a subset of declarative programming. It expresses computation as a set of logical facts and rules, and queries are answered by searching for proofs.

## Declarative Programming

### The Core Idea

In imperative code, you control every step. In declarative code, you state the goal.

```sql
-- Declarative: describe what you want
SELECT name FROM employees WHERE salary > 100000;

-- Imperative equivalent would loop through rows manually
```

The programmer is freed from specifying the algorithm. The runtime (SQL engine, SAT solver, build system) chooses the strategy.

### Characteristics

- Describes the problem domain, not the control flow
- Often closer to the problem's specification
- The runtime can optimize execution independently of the programmer
- Side effects are minimized or eliminated

### Examples of Declarative Domains

**SQL**: the canonical declarative language. You describe the query; the database engine chooses joins, indexes, and execution plans.

**HTML/CSS**: you declare the structure and style of a document. The browser renders it. You do not write a loop to lay out each element.

**Make / build systems**: declare dependencies between targets. The build system decides order of execution.

**React (declarative UI)**: you describe what the UI should look like given the current state. React decides the minimal DOM updates needed.

```jsx
// Declarative: describe the target state
<Button disabled={isLoading} onClick={submit}>
  {isLoading ? "Loading..." : "Submit"}
</Button>
```

**Regular expressions**: describe a pattern, not the parsing algorithm.

**Infrastructure as code** (Terraform, Kubernetes YAML): declare desired infrastructure state; the tool reconciles it.

## Logic Programming

### The Core Idea

Logic programming is based on formal logic. A program is a set of:

- **Facts**: things that are unconditionally true
- **Rules**: things that are true if other things are true
- **Queries**: questions asked against the fact/rule base

The engine uses an inference mechanism (typically a form of resolution) to search for answers.

### Prolog

Prolog is the most widely known logic programming language. Facts and rules are written as Horn clauses.

```prolog
% Facts
parent(tom, bob).
parent(bob, ann).

% Rule
grandparent(X, Z) :- parent(X, Y), parent(Y, Z).

% Query
?- grandparent(tom, ann).
% yes
```

The Prolog engine searches the database to find variable bindings that satisfy the query. If there are multiple solutions, it can backtrack to find all of them.

### Unification

Unification is the process of making two terms equal by finding appropriate variable bindings. It is the core mechanism behind Prolog's search. `X = foo(bar)` succeeds and binds `X` to `foo(bar)`.

### Backtracking

When a rule fails, Prolog backtracks: it undoes the last choice and tries an alternative. This gives it the ability to search over all possible solutions without the programmer writing search code explicitly.

### Constraint Logic Programming (CLP)

CLP extends logic programming with constraints over domains like integers, reals, or finite domains. The solver prunes the search space using constraint propagation.

```prolog
:- use_module(library(clpfd)).

puzzle(X, Y) :-
    X in 1..10, Y in 1..10,
    X + Y #= 12,
    X #> Y.
```

This is used heavily in scheduling, planning, and combinatorial optimization.

### Datalog

Datalog is a subset of Prolog designed for databases. It restricts the language to avoid infinite loops and guarantees termination. Used in program analysis tools (Doop, Soufflé), deductive databases, and some distributed systems.

## Declarative vs. Logic

| Aspect | Declarative (general) | Logic programming |
|---|---|---|
| Basis | Describe what, not how | Formal logic (facts + rules) |
| Execution | Runtime chooses strategy | Inference engine searches for proof |
| Examples | SQL, HTML, CSS, React | Prolog, Datalog, ASP |
| Side effects | Minimized | Minimal or none in pure form |

## Answer Set Programming (ASP)

ASP is a form of declarative logic programming focused on solving hard combinatorial problems. A program defines a set of possible "answer sets" (stable models), and the solver finds all of them. Used in AI planning, configuration, and bioinformatics.

## Strengths

- Code is concise and close to the problem specification
- Easy to verify and reason about
- The runtime can optimize without programmer intervention
- Naturally expressive for search, constraint, and database problems

## Weaknesses

- Limited control over performance (you trust the runtime)
- Debugging is harder because execution order is opaque
- Logic programming can be slow on large search spaces without careful constraint use
- Adoption outside niche domains (databases, AI, formal methods) is limited
