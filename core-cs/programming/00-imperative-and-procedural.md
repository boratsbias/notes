# Imperative and Procedural Programming

## Overview

Imperative programming is a paradigm that describes computation as a sequence of statements that change program state. You tell the machine *how* to do something, step by step. It is the oldest and most hardware-close style of programming, directly reflecting how CPUs execute instructions.

Procedural programming is a subset of imperative programming. It organizes the sequence of steps into reusable units called procedures (also called functions, routines, or subroutines). This was a major structural improvement over raw imperative code.

## Core Concepts

### State and Mutation

Programs maintain state through variables. Execution proceeds by reading and modifying that state.

```python
count = 0
count = count + 1  # mutation
```

### Control Flow

The programmer explicitly controls the order of execution using:

- **Sequence**: statements run top to bottom
- **Selection**: `if`, `else`, `switch` branch on conditions
- **Iteration**: `for`, `while`, `do-while` repeat blocks

### Procedures and Subroutines

A procedure is a named block of code that can be called from multiple places. This enables code reuse and decomposition of complex problems.

```c
int add(int a, int b) {
    return a + b;
}
```

Key ideas that procedures bring:

- **Abstraction**: callers do not need to know the implementation
- **Parameters and return values**: allow data to flow in and out
- **Local scope**: variables declared inside a procedure do not pollute the outer scope
- **The call stack**: each procedure call pushes a frame onto the stack, tracking local variables and the return address

### Scope and Lifetime

Variables have a scope (where they are visible) and a lifetime (how long they exist). Procedural languages introduced lexical scoping, where scope is determined by the structure of the source code rather than the runtime call order.

## Structured Programming

In the 1960s and 70s, Dijkstra argued that unrestricted use of `goto` made programs hard to reason about. Structured programming replaced `goto` with structured control flow constructs (loops, conditionals). This became the foundation of languages like C, Pascal, and FORTRAN.

The key insight: any computable algorithm can be expressed using only sequence, selection, and iteration.

## Memory Model

Procedural languages typically work with:

- **Stack memory**: local variables and function frames, automatically managed
- **Heap memory**: dynamically allocated memory, managed manually (C) or by a GC
- **Global/static memory**: variables that persist for the program's lifetime

## Examples of Procedural Languages

- **C**: the canonical procedural language. Gave birth to most modern syntax conventions.
- **Pascal**: designed for teaching structured programming
- **FORTRAN**: scientific computing, the first high-level language
- **BASIC**: early personal computing
- **Go**: a modern language that leans procedural despite supporting some OOP features

## Strengths

- Simple mental model: read the code top to bottom
- Close to the hardware, high performance
- Predictable memory usage
- Easy to trace bugs with a debugger

## Weaknesses

- Large programs become hard to manage as shared mutable state grows
- No natural way to model entities or relationships (OOP addresses this)
- Procedures can have hidden dependencies through global state
- Does not scale well to concurrent or parallel workloads without care
