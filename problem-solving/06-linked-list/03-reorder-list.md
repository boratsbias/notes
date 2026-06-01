# Reorder List

[Problem Link](https://leetcode.com/problems/reorder-list/)

## Approach

Three steps:

1. Find the middle with slow and fast pointers.
2. Reverse the second half starting at the node after the middle.
3. Merge the first half and reversed second half by alternating nodes.

The result interleaves `L0, Ln, L1, Ln-1, ...` without extra array storage.

Copying values into a list uses **O(n)** extra space. Pointer manipulation stays **O(1)** extra space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def reorderList(self, head: Optional[ListNode]) -> None:
        if not head or not head.next:
            return

        slow, fast = head, head
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next

        second = slow.next
        slow.next = None

        prev, curr = None, second
        while curr:
            nxt = curr.next
            curr.next = prev
            prev = curr
            curr = nxt
        second = prev

        first = head
        while second:
            tmp1, tmp2 = first.next, second.next
            first.next = second
            second.next = tmp1
            first = tmp1
            second = tmp2
```
