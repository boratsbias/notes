# K Closest Points to Origin

[Problem Link](https://leetcode.com/problems/k-closest-points-to-origin/)

## Approach

Maintain a max heap of size k ordered by squared distance.

For each point, push `(distance, point)` onto the heap. If size exceeds k, pop the farthest point.

The heap then holds the k closest points. Squared distance avoids square roots without changing ordering.

Sorting all points costs **O(n log n)**. The size-k heap runs in **O(n log k)** time.

**Time Complexity:** O(n log k)  
**Space Complexity:** O(k)

## Code

```python
class Solution:
    def kClosest(self, points: List[List[int]], k: int) -> List[List[int]]:
        heap = []

        for x, y in points:
            dist = -(x * x + y * y)
            heapq.heappush(heap, (dist, x, y))
            if len(heap) > k:
                heapq.heappop(heap)

        return [[x, y] for _, x, y in heap]
```
