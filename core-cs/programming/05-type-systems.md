# Type Systems

## Overview

A type system is a set of rules that assigns a property called a *type* to every term in a program (variables, expressions, functions, modules). Types constrain how values can be used and what operations are valid on them. A well-designed type system catches a large class of bugs before the program runs.

## Why Types Matter

Without types, a program can freely mix values in nonsensical ways: adding a string to a file handle, calling a null value as a function, treating a user ID as a price. Type systems prevent these errors. The stronger the type system, the more guarantees it provides.

## Static vs. Dynamic Typing

### Static Typing

Types are checked at compile time. Every variable, parameter, and return value has a type known before the program runs. If types do not match, the program does not compile.

```java
int x = "hello";  // compile error
```

Languages: Java, C, C++, Rust, Go, Haskell, Kotlin, Swift, TypeScript.

Benefits: errors caught early, better tooling (autocomplete, refactoring), documentation in the code itself, performance optimizations.

### Dynamic Typing

Types are checked at runtime. Values carry their type, but variables do not. A variable can hold any value.

```python
x = 42
x = "hello"   # perfectly valid
```

Languages: Python, Ruby, JavaScript, PHP, Lisp, Clojure.

Benefits: flexibility, shorter code for small programs, easier to write generic code without annotations.

Tradeoff: type errors appear at runtime, possibly in production.

## Strong vs. Weak Typing

This axis is about whether the language allows implicit coercions between types.

**Strongly typed**: the language refuses to automatically convert between unrelated types. Python and Haskell are strongly typed.

```python
"3" + 3   # TypeError in Python
```

**Weakly typed**: the language performs implicit coercions freely. JavaScript is a common example.

```javascript
"3" + 3   // "33" in JavaScript (number coerced to string)
```

Note: strong/weak and static/dynamic are independent axes. Python is dynamically and strongly typed. C is statically but relatively weakly typed (implicit int conversions, unsafe casts).

## Type Inference

Type inference allows the compiler to deduce types without the programmer writing annotations everywhere.

```haskell
-- Haskell infers x :: Int and the return type
add x y = x + y
```

```kotlin
val name = "Alice"   // inferred as String
```

Inference makes statically typed code less verbose while retaining the full benefits of static checking.

## Nominal vs. Structural Typing

**Nominal typing**: two types are compatible only if they share a name (declared to be related via inheritance or implements).

```java
interface Flyable { void fly(); }
class Bird implements Flyable { ... }  // must explicitly declare
```

**Structural typing** (duck typing): two types are compatible if they have the same structure, regardless of name. TypeScript uses structural typing.

```typescript
interface Point { x: number; y: number; }
function print(p: Point) { ... }

const obj = { x: 1, y: 2, z: 3 };
print(obj);  // valid — obj has all required fields
```

## Gradual Typing

Gradual typing lets you mix typed and untyped code in the same program. You can start with a dynamically typed codebase and incrementally add type annotations.

Examples: TypeScript (adds types to JavaScript), mypy/Pyright (adds types to Python), Typed Racket.

## Algebraic Data Types

Algebraic data types (ADTs) allow composing types in two ways:

**Product types** (records/structs): hold a value of type A *and* a value of type B.

```haskell
data Point = Point { x :: Double, y :: Double }
```

**Sum types** (tagged unions/variants): hold a value of type A *or* a value of type B.

```haskell
data Result a e = Ok a | Err e
```

Sum types are especially powerful for modeling states that are mutually exclusive. Pattern matching exhaustively handles every case, so the compiler warns if a case is missed.

## Null and Option Types

Null references are a common source of runtime errors. Tony Hoare, who invented null, called it his "billion-dollar mistake."

Modern type systems address this with option/maybe types: a value is explicitly either something or nothing.

```rust
fn find_user(id: u32) -> Option<User> {
    if found { Some(user) } else { None }
}

match find_user(42) {
    Some(user) => println!("{}", user.name),
    None       => println!("not found"),
}
```

Rust, Haskell, Kotlin, Swift, and Scala all handle null this way. The type system forces you to handle the absent case.

## Generics and Parametric Polymorphism

Generics allow writing code that works over any type, parameterized by a type variable.

```java
List<String> names = new ArrayList<>();
names.add("Alice");
```

```haskell
map :: (a -> b) -> [a] -> [b]
```

This is called parametric polymorphism. The function behaves the same regardless of the type parameter.

## Type Classes and Traits

Type classes (Haskell) and traits (Rust, Scala) are a form of ad-hoc polymorphism. They define an interface that a type must implement to be used in a context.

```haskell
class Eq a where
    (==) :: a -> a -> Bool
```

Any type can implement `Eq`. Functions can then be written to work with any type that implements it.

```rust
fn largest<T: PartialOrd>(list: &[T]) -> &T { ... }
```

## Dependent Types

Dependent types allow types to depend on values. This enables expressing very precise specifications in the type system.

```idris
-- A vector type that carries its length in the type
head : Vect (S n) a -> a  -- only callable on non-empty vectors
```

Languages: Idris, Agda, Coq, Lean. Used in formal verification and proof assistants.

## Linear and Affine Types

**Linear types**: a value must be used exactly once. **Affine types**: a value must be used at most once.

Rust's ownership system is built on affine types. Once ownership of a value is moved, the original binding is no longer valid. This prevents use-after-free and double-free bugs at compile time.

## Type Systems and Safety

The relationship between type systems and program safety:

- A **sound** type system guarantees that well-typed programs never encounter type errors at runtime
- A **complete** type system accepts all programs that are correct
- Most practical type systems sacrifice completeness for usability (some correct programs are rejected)

Haskell and Rust have very sound type systems. TypeScript intentionally has some unsoundness for practicality.
