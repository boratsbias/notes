# Semantic Analysis

Semantic analysis checks that the source program has consistent meaning beyond syntactic correctness. It enforces language rules that cannot be expressed in a CFG, and annotates the AST with type information used by later phases.

## What Semantic Analysis Checks

**Type checking:** operands of an expression have compatible types; function call arguments match the declared parameter types; assignment target and source are compatible.

**Scope and name resolution:** every identifier is declared before use; identifiers refer to the correct declaration in the appropriate scope; no redeclaration in the same scope.

**Control flow:** `break` and `continue` appear inside loops; `return` types match the function's declared return type.

**Object-specific rules:** virtual method override compatibility; interface implementation completeness.

These checks cannot be expressed in a CFG because they involve context (what was declared elsewhere in the program).

## Symbol Table and Scoping

The symbol table maps identifiers to their attributes. Semantic analysis builds and queries it during AST traversal.

**Scoping rules:** most languages use lexical (static) scoping. A name refers to the innermost enclosing scope in which it is declared.

**Implementation:** maintain a stack of hash tables. Entering a block pushes a new table. Exiting pops it. Lookup searches from top to bottom.

```
{                      // push scope 1
    int x = 5;
    {                  // push scope 2
        int y = x;     // y -> scope 2; x found in scope 1
        {              // push scope 3
            int x = 3; // shadows outer x
        }              // pop scope 3
    }                  // pop scope 2
}                      // pop scope 1
```

**Forward references:** some languages allow using a name before its declaration (mutual recursion in functions). Handle with a two-pass approach: first pass collects all declarations; second pass resolves references.

## Type Systems

A type system assigns types to expressions and checks consistency.

**Static vs. dynamic typing:** static typing checks types at compile time (C, Java, Rust); dynamic typing checks at runtime (Python, Ruby). Static typing enables early error detection and optimizations.

**Strong vs. weak typing:** strong typing prohibits implicit coercions (Python, Java); weak typing allows them (C: implicit int/pointer casts, JavaScript).

**Type inference:** the compiler infers types from context without explicit annotations. Hindley-Milner type inference (ML, Haskell) infers principal types for all expressions.

## Type Checking Algorithm

For each AST node, compute the type of the node and check against expected types.

**Literals:**
- Integer literal: `int`.
- Float literal: `float`.
- String literal: `string`.
- `true` / `false`: `bool`.

**Binary operations:**
- `+`, `-`, `*` on `int` operands: result is `int`.
- `+`, `-`, `*` on `float` operands: result is `float`.
- `int` and `float`: implicit widening of `int` to `float`.
- `+` on strings: string concatenation.
- `==`, `!=`: operands must have compatible types; result is `bool`.

**Function calls:** check that the number and types of arguments match the function signature.

**Assignment:** the right-hand side type must be assignable to the left-hand side type (same type or subtype).

## Type Coercion and Widening

**Widening conversions:** safe, no information loss. `int` to `long`, `float` to `double`, subtype to supertype.

**Narrowing conversions:** may lose information. `long` to `int`, `double` to `float`. Require explicit cast in most strongly-typed languages.

**Coercion insertion:** during type checking, insert explicit conversion nodes into the AST:

```
int x = 3;
float y = x + 1.5;
// AST: BinOp('+', IntToFloat(x), 1.5)
```

## Type Equivalence

**Structural equivalence:** two types are equivalent if they have the same structure (same fields with same types, same parameter types). Used in C (for struct), Go, TypeScript.

**Name equivalence:** two types are equivalent only if they have the same name. Used in Java, C (for typedefs), Pascal.

```c
typedef struct { int x; } Point;
typedef struct { int x; } Size;
// Name equivalence: Point != Size despite same structure
```

## Attribute Grammars

Formal framework for describing semantic analysis. Attributes are associated with grammar symbols; semantic rules compute attribute values.

**Synthesized attributes:** computed from child attributes (bottom-up). Type of an expression is synthesized from its operands.

**Inherited attributes:** passed from parent to child (top-down). Scope information is inherited.

In practice, compilers implement this with AST traversals rather than formal attribute grammars.

## Semantic Errors

```
int x = "hello";     // type error: string assigned to int
y = 3;               // error: y not declared
int x; int x;        // error: x redeclared
return "ok";         // error: return type mismatch (expected int)
break;               // error: break outside loop
```

Good error messages include source location, the problematic expression, and the expected vs. found type.
