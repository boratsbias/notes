# Add Two Numbers

[Problem Link](https://leetcode.com/problems/add-two-numbers/)

## Approach

Walk both lists simultaneously, adding corresponding digits plus carry.

Create a result node for each digit sum modulo 10 and propagate carry. Continue while either list has nodes or carry remains.

Converting lists to integers fails for very large numbers. Digit-by-digit addition handles arbitrary length.

**Time Complexity:** O(max(m, n))  
**Space Complexity:** O(max(m, n)) for the output list

## Code

```python
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        dummy = ListNode()
        curr = dummy
        carry = 0

        while l1 or l2 or carry:
            val = carry
            if l1:
                val += l1.val
                l1 = l1.next
            if l2:
                val += l2.val
                l2 = l2.next
            carry, digit = divmod(val, 10)
            curr.next = ListNode(digit)
            curr = curr.next

        return dummy.next
```
