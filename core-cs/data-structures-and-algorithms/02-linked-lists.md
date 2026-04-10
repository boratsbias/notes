# Linked Lists

A linked list is a linear data structure where each element (node) stores a value and a pointer to the next node. Unlike arrays, linked lists do not require contiguous memory, making insertions and deletions efficient at arbitrary positions.

## Node Structure

```python
class Node:
    def __init__(self, val):
        self.val = val
        self.next = None   # singly linked
        # self.prev = None  # additionally for doubly linked
```

**Singly linked list:** each node has one pointer (`next`). Traversal: forward only.

**Doubly linked list:** each node has `next` and `prev`. Traversal: forward and backward. Efficient deletion of a given node (no need to find its predecessor).

**Circular linked list:** the last node's `next` points to the first. Used in round-robin scheduling.

## Operations and Complexity

| Operation | Singly | Doubly | Notes |
|-----------|--------|--------|-------|
| Access by index | $O(n)$ | $O(n)$ | Must traverse |
| Search | $O(n)$ | $O(n)$ | Linear scan |
| Insert at head | $O(1)$ | $O(1)$ | |
| Insert at tail | $O(1)$ | $O(1)$ | With tail pointer |
| Insert at position $i$ | $O(n)$ | $O(n)$ | Find predecessor first |
| Delete head | $O(1)$ | $O(1)$ | |
| Delete given node | $O(n)$ | $O(1)$ | Need predecessor for singly |
| Delete by value | $O(n)$ | $O(n)$ | Must find node first |

**vs. Arrays:** linked lists are better for frequent insertions/deletions in the middle; arrays are better for random access and cache performance.

## Common Operations

### Reverse a Linked List

Iterative, $O(n)$ time, $O(1)$ space:

```python
def reverse(head):
    prev, curr = None, head
    while curr:
        nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt
    return prev
```

Recursive:

```python
def reverse(head):
    if not head or not head.next:
        return head
    new_head = reverse(head.next)
    head.next.next = head
    head.next = None
    return new_head
```

### Detect a Cycle (Floyd's Algorithm)

Use two pointers: slow moves 1 step, fast moves 2 steps. If they meet, there is a cycle.

```python
def has_cycle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow is fast:
            return True
    return False
```

**Find cycle start:** after detection, reset slow to head. Move both one step at a time; they meet at the cycle entry.

### Find Middle

Fast and slow pointers: when fast reaches the end, slow is at the midpoint.

```python
def middle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    return slow
```

### Merge Two Sorted Lists

```python
def merge(l1, l2):
    dummy = Node(0)
    cur = dummy
    while l1 and l2:
        if l1.val <= l2.val:
            cur.next = l1; l1 = l1.next
        else:
            cur.next = l2; l2 = l2.next
        cur = cur.next
    cur.next = l1 or l2
    return dummy.next
```

### Remove Nth Node from End

Two-pointer: advance fast $n$ steps ahead; move both until fast reaches end.

```python
def remove_nth(head, n):
    dummy = Node(0); dummy.next = head
    slow = fast = dummy
    for _ in range(n + 1):
        fast = fast.next
    while fast:
        slow = slow.next; fast = fast.next
    slow.next = slow.next.next
    return dummy.next
```

## Dummy Head Node

A sentinel node before the real head simplifies edge cases (inserting/deleting at position 0). Always return `dummy.next` as the new head.

## Skip List

A probabilistic data structure built on linked lists. Maintains multiple levels of forward pointers (like an index). Provides $O(\log n)$ expected time for search, insert, and delete.

**Structure:** level 0 is the full list; each higher level is a subset of the level below. A node is promoted to the next level with probability $p$ (typically $0.5$ or $0.25$).

Used in Redis sorted sets (ZSET) and LevelDB/RocksDB memtable.

## XOR Linked List

A memory-efficient doubly linked list that stores `XOR(prev, next)` instead of two separate pointers. Requires only one pointer field per node. Rarely used in practice (breaks garbage collectors).

## When to Use Linked Lists

**Use when:**
- Frequent insertions/deletions at arbitrary positions.
- Implementing queues (O(1) enqueue/dequeue with head/tail pointers).
- Implementing undo functionality (stack of changes).
- Merging sorted lists.

**Avoid when:**
- Random access is needed.
- Memory overhead of pointers is a concern.
- Cache performance is critical (poor spatial locality).
