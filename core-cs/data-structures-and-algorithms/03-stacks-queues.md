# Stacks and Queues

Stacks and queues are linear ADTs that restrict how elements are added and removed. Their constraints make them the right tool for a specific class of problems.

## Stack

A stack is a **LIFO (Last In First Out)** data structure. The element most recently added is the first to be removed.

**Operations:**
- `push(x)`: add element to top. $O(1)$.
- `pop()`: remove and return top element. $O(1)$.
- `peek() / top()`: return top element without removing. $O(1)$.
- `isEmpty()`: return true if empty. $O(1)$.

**Implementations:**
- Array: maintain a top index. `push` = increment and assign; `pop` = return and decrement.
- Linked list: push/pop at head. $O(1)$ both.

### Applications

**Function call stack:** the OS/runtime maintains a call stack. Each function call pushes a frame; return pops it. Stack overflow = too many nested calls.

**Expression evaluation and parsing:**
- Balanced parentheses check.
- Infix-to-postfix conversion (shunting-yard algorithm).
- Postfix expression evaluation.

**Depth-First Search (DFS):** iterative DFS uses an explicit stack instead of recursion.

**Undo/redo:** push operations onto a stack; undo pops and reverses.

**Monotonic stack:** a stack maintaining a monotone (increasing or decreasing) sequence. Used to find next greater element, largest rectangle in histogram, daily temperatures.

### Monotonic Stack: Next Greater Element

For each element, find the next greater element to its right.

```python
def next_greater(arr):
    n = len(arr)
    result = [-1] * n
    stack = []   # indices; stack[bottom] to stack[top] = decreasing values
    for i in range(n):
        while stack and arr[stack[-1]] < arr[i]:
            idx = stack.pop()
            result[idx] = arr[i]
        stack.append(i)
    return result
```

**Time:** $O(n)$. Each element is pushed and popped at most once.

## Queue

A queue is a **FIFO (First In First Out)** data structure. The element added first is the first to be removed.

**Operations:**
- `enqueue(x)`: add to the rear. $O(1)$.
- `dequeue()`: remove from the front. $O(1)$.
- `peek() / front()`: inspect front without removing. $O(1)$.
- `isEmpty()`: $O(1)$.

**Implementations:**
- **Circular array:** use `head` and `tail` indices wrapping modulo capacity. Efficient fixed-size queue.
- **Linked list:** enqueue at tail, dequeue from head. $O(1)$ both. Python's `collections.deque`.
- **Two stacks:** one for enqueue, one for dequeue. Amortized $O(1)$ per operation.

### Two-Stack Queue

```python
class Queue:
    def __init__(self):
        self.inbox = []
        self.outbox = []

    def enqueue(self, x):
        self.inbox.append(x)

    def dequeue(self):
        if not self.outbox:
            while self.inbox:
                self.outbox.append(self.inbox.pop())
        return self.outbox.pop()
```

Each element is moved at most once: $O(1)$ amortized.

### Applications

**Breadth-First Search (BFS):** use a queue to process nodes level by level.

**Level-order tree traversal:** enqueue root; for each dequeued node, enqueue its children.

**Producer-consumer:** a queue buffers work between threads.

**Sliding window maximum:** maintain a deque of candidate maximum indices.

## Deque (Double-Ended Queue)

Supports insertion and removal at both ends in $O(1)$.

Python: `collections.deque`. C++: `std::deque`. Java: `ArrayDeque`.

**Sliding window maximum (monotonic deque):**

Maintain a deque of indices; the front holds the index of the maximum in the current window.

```python
from collections import deque

def max_sliding_window(arr, k):
    dq = deque()
    result = []
    for i, x in enumerate(arr):
        # Remove elements outside the window
        while dq and dq[0] < i - k + 1:
            dq.popleft()
        # Remove elements smaller than x (they can't be max)
        while dq and arr[dq[-1]] < x:
            dq.pop()
        dq.append(i)
        if i >= k - 1:
            result.append(arr[dq[0]])
    return result
```

**Time:** $O(n)$.

## Priority Queue (Heap)

Not strictly a stack or queue, but a close relative. Elements are dequeued in priority order (smallest or largest first) rather than insertion order.

**`heapq` (Python):** min-heap. `heappush`, `heappop`. $O(\log n)$.

**Applications:** Dijkstra's algorithm, task scheduling, median maintenance, top-$k$ elements.

## Stack vs. Queue Summary

| Property | Stack (LIFO) | Queue (FIFO) |
|----------|-------------|-------------|
| Insert | push (top) | enqueue (rear) |
| Remove | pop (top) | dequeue (front) |
| Peek | top | front |
| Use: DFS | Yes | No |
| Use: BFS | No | Yes |
| Use: Undo | Yes | No |
| Use: Scheduling | No | Yes |
