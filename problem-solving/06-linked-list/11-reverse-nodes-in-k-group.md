# Reverse Nodes in k-Group

[Problem Link](https://leetcode.com/problems/reverse-nodes-in-k-group/)

## Approach

Use a dummy node and advance in groups of k.

For each group:

1. Check that k nodes remain.
2. Reverse exactly those k nodes iteratively.
3. Connect the reversed segment back to the surrounding list.

Keep a pointer to the node before each group so reconnecting is **O(1)** per group.

Reversing the entire list first and then regrouping is harder to wire correctly. In-place group reversal is direct.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def reverseKGroup(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        group_prev = dummy

        while True:
            kth = self._get_kth(group_prev, k)
            if not kth:
                break

            group_next = kth.next
            prev, curr = kth.next, group_prev.next

            while curr != group_next:
                nxt = curr.next
                curr.next = prev
                prev = curr
                curr = nxt

            tmp = group_prev.next
            group_prev.next = kth
            group_prev = tmp

        return dummy.next

    def _get_kth(self, node, k):
        while node and k:
            node = node.next
            k -= 1
        return node
```
