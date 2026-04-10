# Introduction to Compilers

A compiler is a program that translates source code written in one language into an equivalent program in another language, typically from a high-level language to machine code or an intermediate representation. Understanding compiler construction reveals how programming languages work and how programs are transformed into efficient executable code.

## What a Compiler Does

A compiler reads source text and produces target code, preserving the meaning of the source program. The process is structured as a sequence of phases, each building on the output of the previous one.

```
Source program
  -> Lexical Analysis    (characters -> tokens)
  -> Syntax Analysis     (tokens -> parse tree)
  -> Semantic Analysis   (parse tree -> annotated AST)
  -> IR Generation       (AST -> intermediate representation)
  -> Optimization        (IR -> optimized IR)
  -> Code Generation     (IR -> target code)
  -> Target program
```

Each phase can detect errors and report them with source location information.

## Compiler vs. Interpreter

**Compiler:** translates the entire program before execution. The target program runs independently of the compiler. Examples: C, C++, Rust, Go.

**Interpreter:** reads and executes source statements one at a time (or after partial compilation). Source (or bytecode) is needed at runtime. Examples: Python (CPython), Ruby, JavaScript (without JIT).

**Hybrid (bytecode + JIT):** compile to bytecode (Java .class, Python .pyc); interpret bytecode at runtime; JIT-compile hot paths to native code. Examples: JVM, CPython with JIT (PyPy), V8 (JavaScript).

| Property | Compiler | Interpreter | JIT |
|----------|---------|-------------|-----|
| Execution speed | Fast | Slow | Near-native |
| Startup time | Slow (compile once) | Fast | Medium |
| Portability | Platform-specific | Portable | Portable |
| Error reporting | Compile time | Runtime | Mixed |

## Compiler Phases in Detail

**Front end:** analysis phases that are language-specific and machine-independent.
- Lexical analysis (scanning).
- Syntax analysis (parsing).
- Semantic analysis.

**Middle end:** language-independent, machine-independent transformations.
- IR generation.
- Optimization.

**Back end:** machine-specific code generation.
- Instruction selection.
- Register allocation.
- Instruction scheduling.

## Symbol Table

A data structure maintained throughout compilation that maps identifiers to their attributes: type, scope, memory location.

**Scope rules:** the symbol table manages scopes (nested scopes in block-structured languages). When entering a block, push a new scope. When leaving, pop it.

**Attributes stored:** name, kind (variable, function, type), data type, scope level, memory offset or register, function signature (parameter types, return type).

## Error Handling

A compiler must detect and report errors without crashing or producing incorrect code.

**Lexical errors:** invalid characters, unterminated strings.

**Syntax errors:** mismatched parentheses, missing semicolons. A good parser recovers and continues parsing (panic mode recovery, phrase-level recovery).

**Semantic errors:** type mismatches, undefined variables, redeclared identifiers.

The compiler should: report the error with source line and column, recover to find further errors, avoid cascading false errors.

## Example Languages and Compilers

| Language | Compiler | Notes |
|---------|---------|-------|
| C | GCC, Clang | LLVM IR backend |
| C++ | G++, Clang++ | Complex front end (templates) |
| Rust | rustc | Borrow checker in semantic analysis |
| Java | javac | Compiles to JVM bytecode |
| Swift | swiftc | LLVM backend |
| Go | gc | Fast compilation; single binary |

## LLVM

The dominant modern compiler infrastructure. A reusable, modular collection of compiler and toolchain technologies.

**Architecture:** language-specific front ends (Clang for C/C++/ObjC; rustc; swiftc) lower source to LLVM IR. The LLVM middle end optimizes IR. Multiple back ends generate machine code (x86-64, ARM, RISC-V, WebAssembly).

**LLVM IR:** strongly typed, static single assignment (SSA) form, infinite virtual registers. Platform-independent; enables powerful cross-language optimization.
