# Kth Largest Element in an Array

[Problem Link](https://leetcode.com/problems/kth-largest-element-in-an-array/)

## Approach

Use a size-k min heap. After processing all numbers, the root is the kth largest.

Alternatively, quickselect averages **O(n)** but the heap solution is simple and reliable.

Full sorting is **O(n log n)**. The heap approach is **O(n log k)**.

**Time Complexity:** O(n log k)  
**Space Complexity:** O(k)

## Code

```python
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        heap = []

        for num in nums:
            heapq.heappush(heap, num)
            if len(heap) > k:
                heapq.heappop(heap)

        return heap[0]
```
