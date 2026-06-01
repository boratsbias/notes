# Find Median from Data Stream

[Problem Link](https://leetcode.com/problems/find-median-from-data-stream/)

## Approach

Use two heaps:

- Max heap `low` for the smaller half
- Min heap `high` for the larger half

Keep sizes balanced so `low` has equal or one more element than `high`. The median is either the top of `low` or the average of both tops.

Sorting the full stream on each add is **O(n log n)**. Heaps give **O(log n)** per insertion.

**Time Complexity:** O(log n) addNum, O(1) findMedian  
**Space Complexity:** O(n)

## Code

```python
class MedianFinder:

    def __init__(self):
        self.low = []
        self.high = []

    def addNum(self, num: int) -> None:
        heapq.heappush(self.low, -num)
        heapq.heappush(self.high, -heapq.heappop(self.low))

        if len(self.low) > len(self.high) + 1:
            heapq.heappush(self.high, -heapq.heappop(self.low))
        if len(self.high) > len(self.low):
            heapq.heappush(self.low, -heapq.heappop(self.high))

    def findMedian(self) -> float:
        if len(self.low) > len(self.high):
            return -self.low[0]
        return (-self.low[0] + self.high[0]) / 2
```
