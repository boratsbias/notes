# Lexical Analysis

Lexical analysis (scanning) is the first phase of compilation. It reads the raw character stream of the source program and produces a sequence of tokens, which are the atomic units of meaning in the language.

## Tokens

A **token** is a pair (token class, attribute value).

**Token classes:** keyword (`if`, `while`, `return`), identifier, integer literal, float literal, string literal, operator (`+`, `<=`, `==`), delimiter (`;`, `{`, `(`), whitespace (usually discarded), comment (usually discarded).

**Examples:**

```
x = y + 3.14;
```

| Lexeme | Token class | Attribute |
|--------|------------|-----------|
| `x` | ID | "x" |
| `=` | ASSIGN | |
| `y` | ID | "y" |
| `+` | PLUS | |
| `3.14` | FLOAT_LIT | 3.14 |
| `;` | SEMICOLON | |

The parser works with token classes; attribute values are stored in the symbol table or AST.

## Regular Expressions

Token patterns are described by regular expressions (regex).

**Operations:**
- Concatenation: `ab` matches "ab".
- Union: `a|b` matches "a" or "b".
- Kleene star: `a*` matches "", "a", "aa", ...
- One or more: `a+` = `aa*`.
- Optional: `a?` = `a|ε`.
- Character class: `[a-z]` matches any lowercase letter.

**Examples:**
- Integer literal: `[0-9]+`
- Identifier: `[a-zA-Z_][a-zA-Z0-9_]*`
- Float literal: `[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?`
- C-style comment: `/\*([^*]|\*+[^*/])*\*+/`

## Finite Automata

Regex patterns are recognized by finite automata (FA).

**NFA (Nondeterministic Finite Automaton):** states connected by labeled transitions; multiple transitions on the same input and epsilon (empty) transitions are allowed. Easy to construct from regex (Thompson's construction).

**DFA (Deterministic Finite Automaton):** exactly one transition per state per input symbol; no epsilon transitions. Fast to simulate ($O(n)$ for an $n$-character input).

**NFA to DFA (subset construction):** each DFA state is a set of NFA states. The DFA state for a set $S$ has a transition on input $a$ to the set of all NFA states reachable from any state in $S$ via $a$ and then epsilon transitions.

**DFA minimization:** merge equivalent states (states that behave identically for all inputs). Reduces DFA size; Hopcroft's algorithm runs in $O(n \log n)$.

## Lexer Construction

**Thompson's construction:** given a regex, build an NFA.
- Base case: single character $a$ becomes a two-state NFA.
- Concatenation: connect the accept state of NFA1 to the start state of NFA2 via epsilon.
- Union: new start state with epsilon transitions to both NFA starts.
- Kleene star: add epsilon back-loop and bypass.

**Pipeline:**

```
Regex -> NFA (Thompson) -> DFA (subset construction) -> min DFA -> lexer code
```

**Longest match rule:** the lexer takes the longest possible match at each position. `>=` is one token (GREQ), not `>` followed by `=`.

**Keyword priority:** when the identifier pattern and a keyword pattern both match (e.g., `if`), keywords take priority. Implemented by checking the identifier value against a keyword table.

## Lexer Generators

Tools that generate lexers automatically from regex specifications.

**lex / flex:** C-based lexer generator. Specify token patterns with actions in a `.l` file; flex generates a C function `yylex()`.

```
[0-9]+        { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z_]+    { return lookup_keyword(yytext); }
[ \t\n]+      { /* skip whitespace */ }
```

**ANTLR:** generates lexers and parsers in multiple languages (Java, Python, C#).

**Hand-written lexers:** used in production compilers (GCC, Clang, Rust) for speed and better error messages. Implemented as a switch on the current character with manual state tracking.

## Handling Lexer Complexity

**String literals:** accumulate characters between quotes; handle escape sequences (`\n`, `\\`, `\"`).

**Multi-line comments:** `/* ... */`. Requires tracking nesting depth (C does not allow nested; some languages do) and line numbers for error messages.

**Line and column tracking:** increment line counter on `\n`; reset column. Store position at token start for error reporting.

**Lookahead:** some tokens require looking one character ahead. `>` vs `>=`: read `>`; peek at next character; emit `GREQ` if `=`, else emit `GT` and return the peeked character to the input.
