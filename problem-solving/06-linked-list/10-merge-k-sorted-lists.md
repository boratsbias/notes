# Merge k Sorted Lists

[Problem Link](https://leetcode.com/problems/merge-k-sorted-lists/)

## Approach

Push the head of every list into a min heap keyed by node value.

Repeatedly pop the smallest node, attach it to the result, and push its next node if one exists.

Merging lists one pair at a time can cost **O(n log k)** with poor constants. A heap always picks the global minimum in **O(log k)** per node.

**Time Complexity:** O(n log k) where n is total nodes  
**Space Complexity:** O(k) for the heap

## Code

```python
class Solution:
    def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
        heap = []
        for i, node in enumerate(lists):
            if node:
                heapq.heappush(heap, (node.val, i, node))

        dummy = ListNode()
        tail = dummy

        while heap:
            _, i, node = heapq.heappop(heap)
            tail.next = node
            tail = tail.next
            if node.next:
                heapq.heappush(heap, (node.next.val, i, node.next))

        return dummy.next
```
