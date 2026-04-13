# Metaprogramming

## Overview

Metaprogramming is writing code that treats other code as data: generating, transforming, or inspecting programs at compile time or runtime. Instead of writing repetitive boilerplate by hand, metaprogramming lets a program write that code for you, or enables constructs that are not possible in the base language.

## Code Generation

The simplest form of metaprogramming is generating source code from a template or description.

Examples:

- **Protocol Buffers / Thrift**: a `.proto` schema file generates serialization/deserialization code in multiple languages
- **ORM code generation**: a database schema generates model classes
- **OpenAPI generators**: an API spec generates client SDKs
- **Yeoman / scaffolding tools**: generate project boilerplate

This kind of metaprogramming happens outside the language itself. The generated code is then compiled normally.

## Macros

Macros are a language feature that lets you write code that transforms code at compile time, before the normal compilation phase.

### C Preprocessor Macros

C macros perform textual substitution before parsing:

```c
#define MAX(a, b) ((a) > (b) ? (a) : (b))
int x = MAX(3, 5);  // becomes ((3) > (5) ? (3) : (5))
```

These are fragile: they operate on raw text, not the syntax tree, so they can produce surprising results. They have no concept of types or scope.

### Hygienic Macros

Lisp/Scheme and Rust have *hygienic* macros that operate on the abstract syntax tree (AST), not raw text. They avoid accidental variable capture.

**Rust macros** (`macro_rules!`):

```rust
macro_rules! vec {
    ($($x:expr),*) => {
        {
            let mut v = Vec::new();
            $(v.push($x);)*
            v
        }
    };
}

let v = vec![1, 2, 3];
```

Rust also has procedural macros: full Rust functions that take a token stream and produce a token stream. Used for `#[derive(Debug)]`, `#[serde(rename_all = "camelCase")]`, and custom attributes.

**Clojure macros** (Lisp tradition): since code is data (homoiconicity), macros are ordinary functions that receive unevaluated code and return new code:

```clojure
(defmacro unless [condition & body]
  `(if (not ~condition) (do ~@body)))

(unless false (println "runs"))
```

### Syntax Extensions and Compiler Plugins

Some languages allow plugging into the compiler to add new syntax or transformations. Scala's macro system and Haskell's Template Haskell work at this level.

## Reflection

Reflection is the ability of a program to inspect and modify its own structure at runtime: examine types, list methods, read annotations, and call methods by name.

### Introspection

Read-only inspection of the program's structure:

```python
class Foo:
    def bar(self): pass

print(dir(Foo))           # list attributes and methods
print(type(Foo()))        # <class '__main__.Foo'>
import inspect
print(inspect.getsource(Foo.bar))  # source code as a string
```

### Runtime Modification

Some languages allow modifying classes and objects at runtime:

```ruby
class String
    def shout
        upcase + "!!!"
    end
end

"hello".shout   # "HELLO!!!"
```

This is called **monkey patching** in Ruby and Python. Powerful, but dangerous: it can break libraries unexpectedly.

### Java Reflection

```java
Class<?> clazz = Class.forName("com.example.MyService");
Method method = clazz.getMethod("process", String.class);
method.invoke(instance, "input");
```

Java reflection is used heavily in frameworks (Spring, Hibernate, JUnit) to wire components and discover structure at runtime without code changes. The cost is reduced type safety and runtime overhead.

## Annotations and Decorators

Annotations (Java) and decorators (Python, TypeScript) attach metadata to code elements. The metadata can then be read by frameworks or tools at compile time or runtime.

```python
@app.route("/users")
def get_users():
    return users
```

The `@app.route` decorator registers the function with Flask's routing table. The function itself is unchanged; the decorator wraps or annotates it.

```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue
    private Long id;
}
```

JPA reads these annotations via reflection to map the class to database tables.

## Homoiconicity

A language is homoiconic if its code is represented as a data structure of the language itself. In Lisp, code is written as lists, and lists are the primary data structure. This makes it trivial to write macros: a macro receives a list (the code), manipulates it as data, and returns a new list.

```clojure
'(+ 1 2)   ; this is both code and a list of three elements
```

Homoiconicity is one reason Lisps have always had the most powerful macro systems.

## Compile-Time Computation

Some languages allow running arbitrary code at compile time:

**C++ `constexpr`**: evaluate expressions at compile time:

```cpp
constexpr int factorial(int n) {
    return n <= 1 ? 1 : n * factorial(n - 1);
}
static_assert(factorial(5) == 120);  // checked at compile time
```

**C++ templates**: the template instantiation system is Turing-complete. Template metaprogramming can compute types and values during compilation.

**Zig `comptime`**: Zig makes compile-time computation a first-class feature. Any `comptime` block runs during compilation.

**Rust `const fn`**: similar to C++ `constexpr`, allows computation in `const` contexts.

## Domain-Specific Languages (DSLs)

Metaprogramming is often used to embed a DSL inside a host language.

An **internal DSL** is built using the host language's features (macros, operator overloading, method chaining) to look like a specialized language:

```ruby
# RSpec — an internal DSL for testing in Ruby
describe "Calculator" do
    it "adds two numbers" do
        expect(add(2, 3)).to eq(5)
    end
end
```

An **external DSL** is a separate language with its own parser. SQL, regular expressions, and CSS are external DSLs.

## Code as Data: AST Manipulation

Some tools work directly with the AST of source code:

- **Babel** (JavaScript): transforms an AST to transpile modern JS to older versions, or apply custom transformations
- **Clang plugins** (C/C++): add custom analysis or transformations to the Clang compiler
- **Tree-sitter**: parse source code into syntax trees for editors and analysis tools

## Use Cases

- Reducing boilerplate: `#[derive(Debug, Clone, Serialize)]` in Rust auto-generates common implementations
- Frameworks and DI containers: Spring uses reflection to wire beans
- Testing tools: mocking frameworks inspect class structures to generate fakes
- ORMs: map between objects and database rows
- Serialization: generate JSON/binary encoding from type definitions
- Linters and formatters: analyze and rewrite ASTs

## Tradeoffs

Metaprogramming is powerful but comes with costs:

- Code becomes harder to read and trace because what runs differs from what is written
- Compile errors from macros are often confusing
- Reflection bypasses the type system and can fail at runtime
- IDE support (go to definition, autocomplete) often degrades
- Overuse leads to "magic" that new contributors cannot understand

The right amount of metaprogramming is usually the minimum needed to eliminate genuine repetition or enable an abstraction that would otherwise be impossible.
