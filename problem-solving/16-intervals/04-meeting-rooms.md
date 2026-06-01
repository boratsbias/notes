# Meeting Rooms

[Problem Link](https://leetcode.com/problems/meeting-rooms/)

## Approach

A person can attend all meetings if no two intervals overlap.

Sort by start time and check whether any interval starts before the previous one ends.

If `intervals[i][0] < intervals[i - 1][1]`, overlap exists.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def canAttendMeetings(self, intervals: List[List[int]]) -> bool:
        intervals.sort(key=lambda x: x[0])

        for i in range(1, len(intervals)):
            if intervals[i][0] < intervals[i - 1][1]:
                return False

        return True
```
