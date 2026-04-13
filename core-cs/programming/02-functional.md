# Functional Programming

## Overview

Functional programming (FP) is a paradigm that treats computation as the evaluation of mathematical functions. It emphasizes immutability, avoiding shared state, and expressing programs as transformations of data. The central idea: a function always returns the same output for the same input, and produces no side effects.

## Core Concepts

### Pure Functions

A pure function has two properties:

1. **Determinism**: given the same inputs, it always returns the same output
2. **No side effects**: it does not modify any external state, write to disk, print to console, or mutate its arguments

```python
# Pure
def add(a, b):
    return a + b

# Impure (reads external state, modifies a list)
total = 0
def add_to_total(n):
    global total
    total += n
```

Pure functions are easy to test, easy to reason about, and safe to compose or parallelize.

### Immutability

In FP, data is not mutated. Instead of changing a value, you create a new value. This eliminates an entire class of bugs caused by unexpected mutation.

```clojure
; In Clojure, vectors are immutable
(def v [1 2 3])
(conj v 4)   ; => [1 2 3 4]  — v is unchanged
```

### First-Class and Higher-Order Functions

Functions are first-class values: they can be assigned to variables, passed as arguments, and returned from other functions.

A **higher-order function** is one that takes a function as an argument or returns one.

```python
numbers = [1, 2, 3, 4, 5]
squares = list(map(lambda x: x ** 2, numbers))
evens = list(filter(lambda x: x % 2 == 0, numbers))
```

Common higher-order functions: `map`, `filter`, `reduce`, `sort`, `compose`.

### Function Composition

Composition is the idea of building complex functions by combining simpler ones. If `f` and `g` are functions, then `(f . g)(x) = f(g(x))`.

```haskell
double = (*2)
increment = (+1)
doubleThenIncrement = increment . double
doubleThenIncrement 3  -- => 7
```

### Closures

A closure is a function that captures variables from its surrounding scope. It "closes over" those variables, carrying them along.

```javascript
function makeCounter() {
    let count = 0;
    return function() {
        count += 1;
        return count;
    };
}
const counter = makeCounter();
counter();  // 1
counter();  // 2
```

### Recursion

FP favors recursion over iteration because loops require mutable state (an index or accumulator that changes). Recursive functions express repetition by a function calling itself.

**Tail recursion**: when the recursive call is the last operation in the function, compilers can optimize it into a loop (tail-call optimization), avoiding stack overflow.

```haskell
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

### Algebraic Data Types and Pattern Matching

Functional languages often support algebraic data types (ADTs): composite types formed by combining others. Pattern matching allows destructuring these types cleanly.

```haskell
data Shape = Circle Double | Rectangle Double Double

area :: Shape -> Double
area (Circle r)        = pi * r * r
area (Rectangle w h)   = w * h
```

## Referential Transparency

An expression is referentially transparent if it can be replaced with its evaluated value without changing the program's behavior. This holds for pure functions. It enables equational reasoning: you can substitute and simplify expressions like algebraic equations.

## Handling Side Effects

Real programs need side effects (I/O, state, exceptions). FP languages handle this without abandoning purity:

- **Haskell**: uses the `IO` monad to track effects in the type system
- **Elm**: strictly pure; all effects are managed by the runtime through commands and subscriptions
- **Scala/F#**: pragmatic mix, allows impure code but encourages purity

## Lazy Evaluation

Some FP languages (notably Haskell) evaluate expressions only when needed. This enables:

- Working with infinite data structures (streams)
- Short-circuit evaluation naturally
- Performance gains when values are never used

```haskell
naturals = [1..]           -- infinite list
take 5 naturals            -- [1,2,3,4,5]
```

## Examples of Functional Languages

- **Haskell**: pure, lazy, strongly typed, with an advanced type system
- **Clojure**: a Lisp on the JVM, dynamically typed, immutable data by default
- **Erlang / Elixir**: FP designed for concurrency and fault tolerance
- **F#**: pragmatic FP on .NET
- **Scala**: hybrid FP/OOP on the JVM
- **Elm**: FP for frontend UIs, no runtime exceptions

Languages like JavaScript, Python, Kotlin, and Swift support functional patterns even though they are not purely functional.

## Strengths

- Pure functions are trivially testable and composable
- Immutability eliminates race conditions and shared-state bugs
- Concise, expressive code with higher-order functions
- Mathematical foundations make formal reasoning possible

## Weaknesses

- Immutability can have performance overhead (persistent data structures mitigate this)
- Steep learning curve for developers coming from OOP/imperative backgrounds
- Lazy evaluation can make performance and memory behavior harder to predict
- I/O and state management require learning monads or effect systems
