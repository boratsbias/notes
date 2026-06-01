# Interval List Intersections

[Problem Link](https://leetcode.com/problems/interval-list-intersections/)

## Approach

Both lists are sorted and disjoint internally. Find every overlap between intervals from `A` and `B` with two pointers.

For current intervals `a` and `b`, the intersection (if any) is `[max(starts), min(ends)]`.

Advance the pointer whose interval ends first because it cannot intersect any later interval from the other list.

**Time Complexity:** O(m + n)  
**Space Complexity:** O(1) excluding output

## Code

```python
class Solution:
    def intervalIntersection(
        self, firstList: List[List[int]], secondList: List[List[int]]
    ) -> List[List[int]]:
        i = j = 0
        result = []

        while i < len(firstList) and j < len(secondList):
            a, b = firstList[i], secondList[j]
            start = max(a[0], b[0])
            end = min(a[1], b[1])
            if start <= end:
                result.append([start, end])
            if a[1] < b[1]:
                i += 1
            else:
                j += 1

        return result
```
