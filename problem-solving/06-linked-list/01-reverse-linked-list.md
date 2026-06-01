# Reverse Linked List

[Problem Link](https://leetcode.com/problems/reverse-linked-list/)

## Approach

Iterate with three pointers: `prev`, `curr`, and `next`.

At each node, save the next pointer, point the current node backward, then advance all pointers.

Recursion also works but uses **O(n)** call stack space. Iterative reversal uses **O(1)** extra space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        prev = None
        curr = head

        while curr:
            nxt = curr.next
            curr.next = prev
            prev = curr
            curr = nxt

        return prev
```
