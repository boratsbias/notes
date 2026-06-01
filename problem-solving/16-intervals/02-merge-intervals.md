# Merge Intervals

[Problem Link](https://leetcode.com/problems/merge-intervals/)

## Approach

Sort intervals by start time. Merge overlapping intervals into one.

Keep a result list. For each interval, if it overlaps the last merged interval (start <= last end), extend the last end. Otherwise append a new interval.

Overlapping sorted intervals always touch or overlap the most recent merged block.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(n) for output

## Code

```python
class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort(key=lambda x: x[0])
        merged = []

        for start, end in intervals:
            if not merged or start > merged[-1][1]:
                merged.append([start, end])
            else:
                merged[-1][1] = max(merged[-1][1], end)

        return merged
```
