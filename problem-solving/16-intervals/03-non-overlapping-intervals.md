# Non-overlapping Intervals

[Problem Link](https://leetcode.com/problems/non-overlapping-intervals/)

## Approach

Minimize removals so remaining intervals do not overlap. Equivalent to keeping the maximum number of non-overlapping intervals.

Sort by end time. Greedily keep an interval if its start is at or after the end of the last kept interval.

Count kept intervals and subtract from total length.

Sorting by start and using a min-heap is another valid greedy view.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def eraseOverlapIntervals(self, intervals: List[List[int]]) -> int:
        intervals.sort(key=lambda x: x[1])
        kept = 0
        end = float("-inf")

        for start, finish in intervals:
            if start >= end:
                kept += 1
                end = finish

        return len(intervals) - kept
```
