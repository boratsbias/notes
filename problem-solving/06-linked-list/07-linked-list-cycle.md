# Linked List Cycle

[Problem Link](https://leetcode.com/problems/linked-list-cycle/)

## Approach

Use Floyd's cycle detection with slow and fast pointers.

Slow moves one step, fast moves two. If they meet, a cycle exists. If fast reaches the end, there is no cycle.

Storing visited nodes in a set works but uses **O(n)** space. Two pointers use **O(1)** space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def hasCycle(self, head: Optional[ListNode]) -> bool:
        slow = fast = head

        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            if slow is fast:
                return True

        return False
```
