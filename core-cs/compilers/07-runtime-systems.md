# Runtime Systems

The runtime system is the infrastructure that supports a running program. It manages memory, provides type information at runtime, supports garbage collection, implements dynamic dispatch, and handles exceptions.

## Memory Layout of a Running Process

```
High address
+------------------+
|       Stack      |  grows downward; function frames
|        |         |
|        v         |
|                  |
|        ^         |
|        |         |
|       Heap       |  grows upward; dynamic allocation
+------------------+
|    BSS segment   |  uninitialized global/static variables
+------------------+
|   Data segment   |  initialized global/static variables
+------------------+
|   Text segment   |  executable machine code
Low address
```

## Stack Frames (Activation Records)

Each function call creates a **stack frame** (activation record) on the call stack.

**Contents:**
- Return address (where to resume after the call).
- Saved registers (caller-saved or callee-saved as per ABI).
- Local variables.
- Spilled registers.
- Parameters (if more than register argument limit).
- Dynamic link (pointer to caller's frame, for languages with nested functions).

**Frame pointer (RBP/FP):** a stable reference point within the frame. Local variables are accessed as `[rbp - offset]`. Optional: leaf functions and fixed-frame functions can use RSP-relative addressing (omit frame pointer with `-fomit-frame-pointer`).

**Stack overflow:** if recursion is too deep, the stack pointer collides with the heap. Operating system raises a signal (SIGSEGV). Detected via stack guard pages.

## Dynamic Memory Allocation

The heap provides memory whose lifetime is not tied to a function call.

**`malloc` / `free` (C):** explicit allocation and deallocation. Risk of memory leaks (forget to free) and dangling pointers (use after free).

**`new` / `delete` (C++):** same as malloc/free but calls constructors/destructors.

**Allocator internals:**
- **Free list:** maintain a linked list of free blocks.
- **Segregated free lists:** separate lists for different size classes. Fast for common sizes.
- **Buddy allocator:** split and merge blocks in powers of two. Used in the Linux kernel.
- **Slab allocator:** pre-allocate pools of fixed-size objects. Very fast for object allocation.

**Fragmentation:**
- **External fragmentation:** free blocks are too small/scattered for a large allocation.
- **Internal fragmentation:** allocated block is larger than requested.

## Garbage Collection

Automatic memory management. The runtime tracks and reclaims unreachable objects.

### Reference Counting

Each object has a reference count. Increment on copy; decrement on assignment or scope exit. When count reaches zero, free the object.

**Pros:** simple; immediate reclamation; works with destructors.

**Cons:** cannot collect cycles. Requires cycle detection (CPython uses a generational cycle detector).

### Mark and Sweep

1. **Mark phase:** starting from roots (stack variables, global variables), traverse all reachable objects and mark them.
2. **Sweep phase:** scan the heap; free all unmarked objects.

**Stop-the-world:** simple mark-and-sweep stops all threads during collection. Causes latency spikes.

### Copying GC

Divide the heap into two semispaces. Copy live objects from the from-space to the to-space compactly; flip. The old from-space is reclaimed entirely.

**Benefits:** no fragmentation; fast allocation (bump pointer). **Cost:** uses 2$\times$ the memory.

### Generational GC

Most objects die young (the generational hypothesis). Divide the heap into generations:

- **Young generation (nursery):** small; collected frequently (minor GC).
- **Old generation (tenured):** large; collected rarely (major GC).

Objects that survive several young-gen collections are promoted to the old generation.

**Write barrier:** when an old-gen object gets a reference to a young-gen object, record it in a remembered set. Minor GC uses the remembered set as additional roots.

JVM G1, ZGC, Shenandoah, Python GC, Go GC, .NET GC all use generational collection.

## Dynamic Dispatch (Vtables)

In object-oriented languages, method calls on a base-class pointer must dispatch to the correct derived-class method at runtime.

**Vtable:** each class has a virtual dispatch table: an array of function pointers, one per virtual method.

**Object layout:**

```
[vptr] -> [vtable]
[field1]    [method1 ptr]
[field2]    [method2 ptr]
```

Calling `obj->method()` compiles to: load `vptr` from `obj`; load method pointer from vtable at fixed offset; call through pointer. One extra indirection vs. a direct call.

## Exception Handling

**Throw-and-catch:** unwinding the call stack to find a matching catch handler.

**Table-based (zero-cost) exception handling (C++, Java):** compile-time tables describe which regions of code have active handlers and how to unwind. No overhead when no exception is thrown; expensive when an exception is thrown.

**`setjmp` / `longjmp`:** C mechanism for non-local jumps. Saves the stack state; longjmp restores it. Does not run destructors; not suitable for C++ RAII.

**RAII (Resource Acquisition Is Initialization):** C++ idiom. Resources are tied to object lifetimes. Destructors are called when objects go out of scope, including during stack unwinding.

## Just-In-Time (JIT) Compilation

Compile bytecode or IR to native machine code at runtime, after observing the program's behavior.

**Profiling:** identify hot methods (frequently called) and hot loops.

**Speculative optimization:** assume observed types continue to hold; compile fast specialized code; insert deoptimization guards.

**Deoptimization:** if a speculation fails, fall back to the interpreter or recompile with fewer assumptions.

JVM HotSpot, V8 (TurboFan), PyPy, LuaJIT, .NET RyuJIT all use JIT compilation.
