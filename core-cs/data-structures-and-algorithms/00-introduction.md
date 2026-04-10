# Introduction to Data Structures and Algorithms

Data structures and algorithms are the core of computer science. A **data structure** organizes and stores data to enable efficient access and modification. An **algorithm** is a step-by-step procedure for solving a problem.

## Why They Matter

Every program uses data structures and algorithms, whether explicitly or not. Choosing the wrong data structure can turn a fast program into an unusably slow one. A program that handles 1000 elements well may fail on a million because of algorithmic complexity.

Understanding DSA enables you to:
- Write programs that scale to large inputs.
- Recognize standard problems and apply known solutions.
- Reason about correctness and efficiency.
- Pass technical interviews.

## Asymptotic Complexity

We describe algorithm efficiency using **Big O notation**, which characterizes how runtime (or space) grows as input size $n$ grows, ignoring constant factors.

### Common Complexity Classes

| Notation | Name | Example |
|---------|------|---------|
| $O(1)$ | Constant | Hash table lookup |
| $O(\log n)$ | Logarithmic | Binary search |
| $O(n)$ | Linear | Linear scan |
| $O(n \log n)$ | Linearithmic | Merge sort |
| $O(n^2)$ | Quadratic | Bubble sort |
| $O(n^3)$ | Cubic | Naive matrix multiply |
| $O(2^n)$ | Exponential | Brute-force subsets |
| $O(n!)$ | Factorial | Brute-force permutations |

### Formal Definitions

**Big O (upper bound):** $f(n) = O(g(n))$ if there exist $c > 0$ and $n_0$ such that $f(n) \leq c \cdot g(n)$ for all $n \geq n_0$.

**Big Omega (lower bound):** $f(n) = \Omega(g(n))$ if $f(n) \geq c \cdot g(n)$.

**Big Theta (tight bound):** $f(n) = \Theta(g(n))$ if both $O$ and $\Omega$ hold.

### Analyzing Code

**Sequential statements:** add complexities.

**Loops:** multiply the body complexity by the number of iterations.

**Nested loops:** multiply all loop counts.

**Recursive algorithms:** solve the recurrence relation.

**Master Theorem:** for $T(n) = aT(n/b) + f(n)$:

- If $f(n) = O(n^{\log_b a - \epsilon})$: $T(n) = \Theta(n^{\log_b a})$.
- If $f(n) = \Theta(n^{\log_b a})$: $T(n) = \Theta(n^{\log_b a} \log n)$.
- If $f(n) = \Omega(n^{\log_b a + \epsilon})$: $T(n) = \Theta(f(n))$.

**Merge sort:** $T(n) = 2T(n/2) + O(n)$. Case 2: $T(n) = O(n \log n)$.

**Binary search:** $T(n) = T(n/2) + O(1)$. Case 1: $T(n) = O(\log n)$.

## Space Complexity

Memory usage also matters. $O(1)$ space = constant extra memory (in-place). $O(n)$ space = proportional to input size.

**Auxiliary space:** space used beyond the input itself.

**Stack space for recursion:** each recursive call uses $O(1)$ stack space. $k$-level deep recursion: $O(k)$ stack space. Deep recursion can cause stack overflow.

## Abstract Data Types vs. Data Structures

An **Abstract Data Type (ADT)** defines a type by its behavior (operations and their semantics), not its implementation.

**Stack ADT:** push, pop, peek, isEmpty.
**Queue ADT:** enqueue, dequeue, peek, isEmpty.
**Dictionary/Map ADT:** insert, delete, lookup.

A **data structure** is a concrete implementation of an ADT. A Stack can be implemented with an array or a linked list.

## Correctness

An algorithm is correct if it produces the right output for every valid input.

**Loop invariant:** a property that holds before and after each iteration. Proving the invariant holds at initialization and is preserved by each iteration proves partial correctness; combined with termination, proves total correctness.

**Example (binary search):** invariant: if the target exists, it is within `[lo, hi]`. At each step, the range halves. Terminates when `lo > hi`.

## Algorithm Design Paradigms

**Brute force:** try all possibilities. Correct but often exponential.

**Divide and conquer:** split the problem into smaller sub-problems; solve recursively; combine. Merge sort, quicksort, binary search.

**Greedy:** make the locally optimal choice at each step. Works when the greedy choice property and optimal substructure hold. Dijkstra's shortest path, Kruskal's MST.

**Dynamic programming:** solve overlapping sub-problems once and store results. Optimal substructure required. Fibonacci, longest common subsequence, knapsack.

**Backtracking:** enumerate candidates; abandon (backtrack) a candidate as soon as it cannot lead to a valid solution. N-queens, Sudoku, subset sum.

**Randomized algorithms:** use randomness. Quicksort with random pivot, Bloom filters, approximate nearest neighbor.
