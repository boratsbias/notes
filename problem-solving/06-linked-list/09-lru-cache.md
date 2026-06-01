# LRU Cache

[Problem Link](https://leetcode.com/problems/lru-cache/)

## Approach

Combine a hash map from keys to nodes with a doubly linked list ordered by recency.

- `get`: return the value and move the node to the front (most recently used).
- `put`: update or insert the key at the front. If capacity is exceeded, remove the tail (least recently used).

Both operations are **O(1)** because map lookup and list splicing are constant time.

A single linked list cannot remove the tail in **O(1)** without knowing the previous node. Doubly linked nodes fix that.

**Time Complexity:** O(1) get and put  
**Space Complexity:** O(capacity)

## Code

```python
class Node:
    def __init__(self, key=0, val=0):
        self.key = key
        self.val = val
        self.prev = None
        self.next = None


class LRUCache:

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = {}
        self.head = Node()
        self.tail = Node()
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev

    def _insert_front(self, node):
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def get(self, key: int) -> int:
        if key not in self.cache:
            return -1
        node = self.cache[key]
        self._remove(node)
        self._insert_front(node)
        return node.val

    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            node = self.cache[key]
            node.val = value
            self._remove(node)
            self._insert_front(node)
            return

        node = Node(key, value)
        self.cache[key] = node
        self._insert_front(node)

        if len(self.cache) > self.capacity:
            lru = self.tail.prev
            self._remove(lru)
            del self.cache[lru.key]
```
