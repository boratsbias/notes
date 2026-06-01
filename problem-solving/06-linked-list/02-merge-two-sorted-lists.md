# Merge Two Sorted Lists

[Problem Link](https://leetcode.com/problems/merge-two-sorted-lists/)

## Approach

Use a dummy head and build the merged list by always attaching the smaller of the two current nodes.

Advance the pointer on the list that contributed the node. When one list ends, attach the remainder of the other.

Merging into arrays and sorting loses the in-place linked list structure and costs **O(n log n)** time.

**Time Complexity:** O(n + m)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
        dummy = ListNode()
        tail = dummy

        while list1 and list2:
            if list1.val <= list2.val:
                tail.next = list1
                list1 = list1.next
            else:
                tail.next = list2
                list2 = list2.next
            tail = tail.next

        tail.next = list1 if list1 else list2
        return dummy.next
```
