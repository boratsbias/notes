# Code Optimization

Code optimization transforms a program to run faster, use less memory, or consume less energy, while preserving its semantics. Optimizations are applied to the IR before code generation.

## Optimization Goals

**Execution speed:** reduce the number of instructions executed; reduce instruction latency.

**Code size:** smaller code fits in instruction cache better; important for embedded systems.

**Memory usage:** reduce stack and heap allocation; improve cache locality.

**Power consumption:** fewer operations = less power.

Optimizations must be **semantics-preserving**: the optimized program must produce the same observable outputs as the original for all valid inputs.

## Local Optimizations (Within a Basic Block)

### Constant Folding

Evaluate constant expressions at compile time.

```
t = 3 * 4 + 1    =>   t = 13
if 1 < 2 goto L  =>   goto L
```

### Constant Propagation

If a variable is always assigned a constant, replace all uses with the constant.

```
x = 5
y = x + 3    =>   y = 8
```

### Dead Code Elimination

Remove instructions whose results are never used.

```
t = a * b    # t never used after this
y = c + d
# Remove the first instruction
```

### Common Subexpression Elimination (CSE)

If an expression is computed multiple times with the same operands, compute it once and reuse the result.

```
t1 = a + b
t2 = a + b    =>   t1 = a + b; t2 = t1
```

### Algebraic Simplification

Apply mathematical identities.

```
x = a + 0    =>   x = a
x = a * 1    =>   x = a
x = a * 0    =>   x = 0
x = a * 2    =>   x = a + a  (or x = a << 1)
x = a ** 2   =>   x = a * a
```

### Copy Propagation

Replace uses of a copy target with the copy source.

```
x = y
z = x + 1    =>   z = y + 1
```

## Global Optimizations (Across Basic Blocks)

### Data Flow Analysis

Compute properties of the program at each point using equations over the CFG.

**Reaching definitions:** which assignments to variable $x$ could have been the last assignment before a given point?

**Live variable analysis:** which variables hold values that will be used later? Dead assignments can be eliminated.

**Available expressions:** which expression values computed earlier are still valid (no operand has been reassigned)?

**Data flow equations (live variables, backward analysis):**

$$\text{LiveOut}(B) = \bigcup_{S \in \text{succ}(B)} \text{LiveIn}(S)$$

$$\text{LiveIn}(B) = \text{Use}(B) \cup (\text{LiveOut}(B) \setminus \text{Def}(B))$$

Solve iteratively (worklist algorithm) until fixed point.

### Global CSE

Eliminate expressions that are available at the current point (computed on all paths to this point without their operands being redefined).

### Global Dead Code Elimination

Remove instructions whose defined variables are not live at the point of definition.

## Loop Optimizations

Loops account for most execution time. Loop optimizations have the highest impact.

### Loop Invariant Code Motion (LICM)

Move computations whose operands do not change in the loop to before the loop.

```
for i in range(n):
    y = x * 2      # x is loop-invariant
    a[i] = y + i

# After LICM:
y = x * 2
for i in range(n):
    a[i] = y + i
```

### Strength Reduction

Replace expensive operations with cheaper ones inside loops.

```
# Original: multiplication each iteration
for i in range(n):
    a[i] = i * k

# After strength reduction: add instead of multiply
t = 0
for i in range(n):
    a[i] = t
    t += k
```

### Induction Variable Elimination

Remove redundant induction variables that are linear functions of the primary induction variable.

### Loop Unrolling

Replicate the loop body multiple times to reduce loop overhead and enable further optimizations.

```
# Original
for i in range(0, n, 1):
    a[i] = b[i] + c[i]

# After 4x unrolling
for i in range(0, n, 4):
    a[i]   = b[i]   + c[i]
    a[i+1] = b[i+1] + c[i+1]
    a[i+2] = b[i+2] + c[i+2]
    a[i+3] = b[i+3] + c[i+3]
```

### Loop Fusion and Fission

**Fusion:** combine two adjacent loops with the same iteration space into one. Reduces loop overhead; improves locality.

**Fission:** split one loop into two. Improves cache behavior when the two operations use different arrays.

## Interprocedural Optimizations

### Inlining

Replace a function call with the body of the callee. Eliminates call overhead; enables further optimizations on the combined code (e.g., constant folding through the call).

```
int square(int x) { return x * x; }
y = square(a + 1);
// After inlining:
t = a + 1;
y = t * t;
```

### Devirtualization

For virtual (polymorphic) function calls, determine the concrete type at compile time and replace with a direct call. Enables inlining of virtual calls.

## Optimization Levels (GCC/Clang)

| Flag | Optimizations enabled |
|------|----------------------|
| `-O0` | None (default; fast compile) |
| `-O1` | Basic: dead code, CSE, constant folding |
| `-O2` | All standard: LICM, inlining, loop opts |
| `-O3` | Aggressive: vectorization, more inlining |
| `-Os` | Optimize for size |
| `-Oz` | Aggressively minimize size |
