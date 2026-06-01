# Insert Interval

[Problem Link](https://leetcode.com/problems/insert-interval/)

## Approach

Insert `newInterval` into a sorted list of non-overlapping intervals and merge overlaps.

Three phases in one pass:

- Add all intervals ending before `newInterval` starts
- Merge every overlapping interval into `newInterval`
- Append the rest unchanged

Sorting first is unnecessary because input is already sorted.

**Time Complexity:** O(n)  
**Space Complexity:** O(n) for output

## Code

```python
class Solution:
    def insert(
        self, intervals: List[List[int]], newInterval: List[int]
    ) -> List[List[int]]:
        result = []
        i = 0
        n = len(intervals)

        while i < n and intervals[i][1] < newInterval[0]:
            result.append(intervals[i])
            i += 1

        while i < n and intervals[i][0] <= newInterval[1]:
            newInterval[0] = min(newInterval[0], intervals[i][0])
            newInterval[1] = max(newInterval[1], intervals[i][1])
            i += 1
        result.append(newInterval)

        while i < n:
            result.append(intervals[i])
            i += 1

        return result
```
