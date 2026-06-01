# Kth Largest Element in a Stream

[Problem Link](https://leetcode.com/problems/kth-largest-element-in-a-stream/)

## Approach

Keep a min heap of size k containing the k largest elements seen so far.

On add:

- Push the new value.
- If size exceeds k, pop the smallest.

The heap root is always the kth largest element.

Sorting after every add is **O(n log n)**. The size-k heap gives **O(log k)** per add.

**Time Complexity:** O(log k) add  
**Space Complexity:** O(k)

## Code

```python
class KthLargest:

    def __init__(self, k: int, nums: List[int]):
        self.k = k
        self.heap = nums
        heapq.heapify(self.heap)
        while len(self.heap) > k:
            heapq.heappop(self.heap)

    def add(self, val: int) -> int:
        heapq.heappush(self.heap, val)
        if len(self.heap) > self.k:
            heapq.heappop(self.heap)
        return self.heap[0]
```
