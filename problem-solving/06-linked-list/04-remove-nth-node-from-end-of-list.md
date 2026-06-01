# Remove Nth Node From End of List

[Problem Link](https://leetcode.com/problems/remove-nth-node-from-end-of-list/)

## Approach

Use two pointers separated by n nodes.

Advance the fast pointer n steps ahead, then move both until fast reaches the last node. The node after slow is the one to remove.

A dummy node before the head handles removing the head itself.

Counting length first requires two passes. The two-pointer method finds the target in one pass after the initial offset.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        slow = fast = dummy

        for _ in range(n + 1):
            fast = fast.next

        while fast:
            slow = slow.next
            fast = fast.next

        slow.next = slow.next.next
        return dummy.next
```
