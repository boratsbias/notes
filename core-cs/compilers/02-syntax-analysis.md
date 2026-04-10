# Syntax Analysis

Syntax analysis (parsing) is the second phase of compilation. It takes the token stream from the lexer and determines whether it forms a valid program according to the language grammar, producing a parse tree or abstract syntax tree (AST).

## Context-Free Grammars

Programming language syntax is described by a **context-free grammar (CFG)** $G = (V, T, P, S)$:

- $V$: non-terminals (syntactic categories, e.g., `Expr`, `Stmt`).
- $T$: terminals (tokens, e.g., `ID`, `+`, `if`).
- $P$: productions (rules), each of the form $A \to \alpha$ where $A \in V$ and $\alpha \in (V \cup T)^*$.
- $S \in V$: start symbol.

**Example grammar fragment:**

```
Expr  -> Expr + Term | Term
Term  -> Term * Factor | Factor
Factor -> ( Expr ) | ID | INT
```

**Derivation:** repeatedly replace a non-terminal using a production. A sentence is derivable if it can be reached from $S$.

**Parse tree:** each internal node is a non-terminal; children are the right-hand side of the applied production; leaves are terminals.

## Ambiguity

A grammar is **ambiguous** if some string has more than one parse tree (or equivalently, more than one leftmost or rightmost derivation).

**Example:** `E -> E + E | E * E | id` is ambiguous. `id + id * id` can be parsed as `(id+id)*id` or `id+(id*id)`.

**Resolution:** rewrite the grammar to encode precedence and associativity:

```
E  -> E + T | T          (+ is left-associative, lower precedence)
T  -> T * F | F          (* is left-associative, higher precedence)
F  -> ( E ) | id
```

## Top-Down Parsing (LL)

Parse the input from left to right, constructing a leftmost derivation.

**Recursive descent:** implement each non-terminal as a recursive function. Look at the current token to decide which production to apply.

```python
def parse_expr():
    left = parse_term()
    while current_token == PLUS:
        consume(PLUS)
        right = parse_term()
        left = BinOp('+', left, right)
    return left
```

**FIRST and FOLLOW sets:**
- $\text{FIRST}(\alpha)$: set of terminals that can begin strings derived from $\alpha$. Includes $\epsilon$ if $\alpha$ can derive the empty string.
- $\text{FOLLOW}(A)$: set of terminals that can appear immediately after $A$ in some sentential form.

**LL(1) grammars:** for each non-terminal $A$ and each token $t$, at most one production can be chosen. Requires no left recursion and no ambiguity in FIRST sets.

**Left recursion elimination:** $A \to A\alpha | \beta$ is left-recursive. Rewrite as:

$$A \to \beta A', \quad A' \to \alpha A' | \epsilon$$

**Predictive parsing table:** $M[A, t]$ = the production to use when the current non-terminal is $A$ and the lookahead is $t$. If $t \in \text{FIRST}(\alpha)$: add $A \to \alpha$. If $\epsilon \in \text{FIRST}(\alpha)$ and $t \in \text{FOLLOW}(A)$: add $A \to \alpha$.

## Bottom-Up Parsing (LR)

Parse by recognizing handles (substrings matching a production right-hand side) and reducing them.

**Shift-reduce parsing:** maintain a stack of grammar symbols. At each step, either:
- **Shift:** push the next input token onto the stack.
- **Reduce:** pop a right-hand side from the stack; push the corresponding left-hand side.

**LR(1) parsing:** the most powerful deterministic bottom-up parsing method. Uses a DFA over grammar items to decide shift vs. reduce.

**Grammar items:** $A \to \alpha \cdot \beta$ where the dot marks the current parsing position. Items represent "I have seen $\alpha$; I expect $\beta$ next."

**LR(0) items:** items without lookahead. **LR(1) items:** items with one lookahead token. **LALR(1):** merge LR(1) states with the same core (same set of items minus lookaheads). Smaller tables; used by yacc/bison.

**Parsing table:** ACTION[state, token] = shift $s$ / reduce $A \to \alpha$ / accept / error. GOTO[state, non-terminal] = next state after reducing.

**Conflict types:**
- **Shift-reduce conflict:** should we shift the next token or reduce the current handle? Usually resolved by preferring shift (handles the dangling else).
- **Reduce-reduce conflict:** two different productions can reduce at the same state. Indicates grammar ambiguity or inadequacy.

## Abstract Syntax Tree

The parse tree contains all grammar symbols including punctuation. The **AST** is a simplified tree containing only the semantically relevant structure.

**Differences:**
- Parentheses are not in the AST (structure is captured by tree shape).
- List constructs become flat lists.
- Operator precedence is captured by nesting.

**Example:** `a + b * c` AST:

```
    +
   / \
  a   *
     / \
    b   c
```

## Parser Generators

**yacc / bison:** LALR(1) parser generators for C. Specify grammar with actions; bison generates a C function `yyparse()`.

**ANTLR:** LL(*) parser generator. Handles a wider class of grammars; generates parsers in multiple languages.

**PEG (Parsing Expression Grammars):** ordered choice (`/` instead of `|`); no ambiguity by definition; unlimited lookahead. Tools: pest (Rust), pyparsing (Python).
