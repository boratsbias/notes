# Intermediate Code Generation

Intermediate code generation translates the annotated AST into an intermediate representation (IR), a lower-level but still machine-independent form. The IR is the input to optimization and code generation phases.

## Why an Intermediate Representation?

**Separation of concerns:** the front end (language-specific) and back end (machine-specific) communicate through a common IR. An $m$-language, $n$-target compiler needs only $m + n$ components instead of $m \times n$.

**Optimization:** most optimizations are cleaner and more powerful on IR than on source or machine code.

**Portability:** the same IR can target multiple architectures.

## Three-Address Code (TAC)

The most common IR for imperative languages. Each instruction has at most three operands: two sources and one destination.

**Instruction forms:**

```
x = y op z       binary operation
x = op y         unary operation
x = y            copy
goto L           unconditional jump
if x goto L      conditional jump
if x relop y goto L  comparison branch
x = y[i]         indexed load
x[i] = y         indexed store
x = &y           address-of
x = *y           pointer load
*x = y           pointer store
param x          push argument
call f, n        call function f with n arguments
x = call f, n    call with return value
return x         function return
```

**Temporaries:** the compiler generates fresh temporary variables (e.g., `t1`, `t2`) to hold intermediate results.

**Example:** `a = b * c + d * e`

```
t1 = b * c
t2 = d * e
a  = t1 + t2
```

## Static Single Assignment (SSA) Form

Every variable is defined exactly once. If a variable has multiple definitions at different paths, use phi-functions at join points.

```
# Original
x = 1
if cond:
    x = 2
# use x

# SSA form
x1 = 1
if cond:
    x2 = 2
x3 = phi(x1, x2)   # x3 = x1 if came from left, x2 from right
# use x3
```

**Benefits of SSA:**
- Simplifies data-flow analysis (each use has exactly one definition).
- Enables many optimizations: dead code elimination, constant propagation, value numbering.

SSA is the standard IR for LLVM, GCC's GIMPLE, and most modern optimizing compilers.

## AST to TAC Translation

**Arithmetic expressions:** generate a new temporary for each subexpression.

```
def gen_expr(node):
    if node is BinOp:
        t1 = gen_expr(node.left)
        t2 = gen_expr(node.right)
        t  = new_temp()
        emit(f"{t} = {t1} {node.op} {t2}")
        return t
    elif node is Var:
        return node.name
    elif node is Lit:
        return str(node.value)
```

**Boolean expressions with short-circuit evaluation:**

```
# x && y: jump to false if x is false; don't evaluate y
if_false x goto false_label
if_false y goto false_label
result = 1
goto end
false_label: result = 0
end:
```

**Control flow:**

```
# if (cond) then S1 else S2
t = gen_expr(cond)
if_false t goto else_label
gen_stmt(S1)
goto end_label
else_label: gen_stmt(S2)
end_label:
```

**While loop:**

```
# while (cond) S
begin_label:
t = gen_expr(cond)
if_false t goto end_label
gen_stmt(S)
goto begin_label
end_label:
```

## Other IR Formats

**Stack-based IR (JVM bytecode):** operands are pushed onto a stack; instructions pop their operands and push results. Compact; easy to generate; harder to optimize.

**LLVM IR:** typed SSA in text form. Explicit types for all values. Phi-nodes. Multiple function parameters. Rich type system (pointers, arrays, structs, vectors).

**RTL (Register Transfer Language):** GCC's low-level IR. Represents machine instructions abstractly with virtual registers. Used in the back end.

## Basic Blocks and Control Flow Graphs

A **basic block** is a maximal sequence of instructions with no internal branches: one entry, one exit.

**Leaders:** the first instruction, any branch target, and any instruction after a branch starts a new basic block.

**Control flow graph (CFG):** nodes are basic blocks; edges represent possible control flow. An edge from block $A$ to block $B$ if $B$ could execute immediately after $A$.

```
B1: t1 = x * 2; if t1 > 10 goto B3
B2: y = t1 + 1; goto B4
B3: y = t1 - 1; goto B4
B4: return y
```

The CFG is the substrate for data-flow analysis and most optimizations.
