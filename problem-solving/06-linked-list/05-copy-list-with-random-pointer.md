# Copy List with Random Pointer

[Problem Link](https://leetcode.com/problems/copy-list-with-random-pointer/)

## Approach

Use a hash map from original nodes to their copies.

First pass: create a copy for every node and store the mapping.

Second pass: set each copy's `next` and `random` using the map.

Interleaving copied nodes into the original list saves space but needs careful rewiring. The hash map is clearer and still linear time.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def copyRandomList(self, head: Optional[Node]) -> Optional[Node]:
        if not head:
            return None

        old_to_new = {}

        curr = head
        while curr:
            old_to_new[curr] = Node(curr.val)
            curr = curr.next

        curr = head
        while curr:
            if curr.next:
                old_to_new[curr].next = old_to_new[curr.next]
            if curr.random:
                old_to_new[curr].random = old_to_new[curr.random]
            curr = curr.next

        return old_to_new[head]
```
