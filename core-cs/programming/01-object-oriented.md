# Object-Oriented Programming

## Overview

Object-oriented programming (OOP) is a paradigm that organizes software around *objects*: bundles of data (fields/attributes) and behavior (methods) that model real-world or conceptual entities. Rather than thinking in terms of procedures operating on data, OOP treats data and behavior as inseparable.

## Core Concepts

### Classes and Objects

A **class** is a blueprint that defines the structure and behavior of a type. An **object** (or instance) is a concrete realization of that blueprint created at runtime.

```python
class Dog:
    def __init__(self, name):
        self.name = name

    def bark(self):
        return f"{self.name} says woof"

fido = Dog("Fido")  # fido is an object
```

### Encapsulation

Encapsulation is the bundling of data and the methods that operate on it, combined with hiding internal implementation details from the outside world. Access modifiers (`public`, `private`, `protected`) control visibility.

The goal is to enforce invariants. External code can only interact through a defined interface (the public API), not by directly poking at internal fields.

### Inheritance

A class can inherit the fields and methods of a parent (base) class, then extend or override them. This models "is-a" relationships and promotes code reuse.

```java
class Animal {
    void eat() { ... }
}

class Dog extends Animal {
    void bark() { ... }
}
```

Inheritance creates a hierarchy. A `Dog` is-an `Animal`, so it can do everything `Animal` can do plus more. Deep inheritance hierarchies tend to become brittle over time. The recommendation from modern practice is to prefer composition over inheritance.

### Polymorphism

Polymorphism allows different types to be treated uniformly through a shared interface. There are two main kinds:

**Subtype polymorphism (runtime)**: a reference to a base type can point to an instance of any subtype. The correct method is dispatched at runtime via the virtual dispatch mechanism.

```java
Animal a = new Dog();
a.makeSound();  // calls Dog's implementation
```

**Parametric polymorphism (compile-time / generics)**: functions and types that work uniformly over any type. `List<T>` in Java is an example.

**Ad-hoc polymorphism (overloading)**: multiple methods with the same name but different parameter types.

### Abstraction

Abstraction means exposing only what is necessary and hiding complexity. Abstract classes and interfaces define contracts without providing full implementations.

An interface specifies *what* an object can do. The implementation specifies *how*.

```java
interface Shape {
    double area();
}

class Circle implements Shape {
    double area() { return Math.PI * r * r; }
}
```

## Object Relationships

- **Association**: one object uses another (a `Car` has a reference to an `Engine`)
- **Aggregation**: "has-a" with independent lifecycles (`Team` has `Player` objects)
- **Composition**: "has-a" where the child cannot exist without the parent (`House` has `Room` objects)
- **Dependency**: one object depends on another temporarily (passed as an argument)

## SOLID Principles

SOLID is a widely used set of design principles for OOP:

- **Single Responsibility**: a class should have only one reason to change
- **Open/Closed**: open for extension, closed for modification
- **Liskov Substitution**: subtypes must be substitutable for their base types without altering correctness
- **Interface Segregation**: many small, specific interfaces are better than one large general one
- **Dependency Inversion**: depend on abstractions, not concrete implementations

## Design Patterns

OOP gave rise to a vocabulary of recurring design patterns, catalogued in the influential "Gang of Four" book. Common ones include:

- **Singleton**: a class with only one instance
- **Factory**: delegates object creation to a method or class
- **Observer**: objects subscribe to events emitted by another object
- **Strategy**: encapsulates interchangeable algorithms behind an interface
- **Decorator**: adds behavior to an object without modifying its class

## Examples of OOP Languages

- **Smalltalk**: one of the original OOP languages, everything is an object
- **Java**: class-based, strong static typing, "everything in a class"
- **C++**: adds OOP to C, supports multiple inheritance
- **Python**: dynamically typed, flexible OOP with duck typing
- **Ruby**: everything is an object, including primitives
- **Kotlin/Swift**: modern, pragmatic OOP with functional features

## Strengths

- Natural way to model real-world entities and their relationships
- Encapsulation enforces modularity and protects invariants
- Polymorphism enables extensible, pluggable designs
- Large ecosystem of proven design patterns

## Weaknesses

- Shared mutable state still causes bugs, especially in concurrent code
- Inheritance can create tight coupling and fragile hierarchies
- Can lead to over-engineering with unnecessary abstractions
- Object graphs can make reasoning about memory and performance harder
