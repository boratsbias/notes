# Meeting Rooms II

[Problem Link](https://leetcode.com/problems/meeting-rooms-ii/)

## Approach

Find the minimum number of conference rooms needed at once.

Sort meetings by start time. Use a min-heap of end times for ongoing meetings.

For each meeting, if the earliest ending meeting finishes before this one starts, reuse that room (pop the heap). Push the current meeting's end time.

The heap size is the peak number of concurrent meetings.

Chronological sorting of all start and end events also works.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        intervals.sort(key=lambda x: x[0])
        heap = []

        for start, end in intervals:
            if heap and heap[0] <= start:
                heapq.heappop(heap)
            heapq.heappush(heap, end)

        return len(heap)
```
