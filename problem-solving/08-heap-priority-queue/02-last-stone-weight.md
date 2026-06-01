# Last Stone Weight

[Problem Link](https://leetcode.com/problems/last-stone-weight/)

## Approach

Use a max heap of stone weights. Python's heapq is a min heap, so store negated values.

Repeatedly pop the two largest stones, smash them, and push the difference if positive.

Sorting each round is slower. A heap gives **O(log n)** per smash.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def lastStoneWeight(self, stones: List[int]) -> int:
        heap = [-stone for stone in stones]
        heapq.heapify(heap)

        while len(heap) > 1:
            first = -heapq.heappop(heap)
            second = -heapq.heappop(heap)
            if first != second:
                heapq.heappush(heap, -(first - second))

        return -heap[0] if heap else 0
```
