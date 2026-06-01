# Partition Labels

[Problem Link](https://leetcode.com/problems/partition-labels/)

## Approach

Each letter must lie entirely in one partition. For each letter, record its last index in the string.

Scan left to right while tracking the end of the current partition as the farthest last index among letters seen so far.

When the scan index reaches that end, close a partition and start the next.

**Time Complexity:** O(n)  
**Space Complexity:** O(1) alphabet size

## Code

```python
class Solution:
    def partitionLabels(self, s: str) -> List[int]:
        last = {c: i for i, c in enumerate(s)}
        start = 0
        end = 0
        result = []

        for i, c in enumerate(s):
            end = max(end, last[c])
            if i == end:
                result.append(end - start + 1)
                start = i + 1

        return result
```
