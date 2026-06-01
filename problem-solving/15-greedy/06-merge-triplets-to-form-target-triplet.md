# Merge Triplets to Form Target Triplet

[Problem Link](https://leetcode.com/problems/merge-triplets-to-form-target-triplet/)

## Approach

You may take triplets where each coordinate is at most the target. Ignore any triplet that exceeds the target in any position.

Collect all coordinates from usable triplets into three sets (one per index). The target is reachable if each target value appears in its corresponding set.

Taking triplets greedily in order is unnecessary once you filter invalid ones.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def mergeTriplets(self, triplets: List[List[int]], target: List[int]) -> bool:
        good = set()

        for a, b, c in triplets:
            if a > target[0] or b > target[1] or c > target[2]:
                continue
            if a == target[0]:
                good.add(0)
            if b == target[1]:
                good.add(1)
            if c == target[2]:
                good.add(2)

        return len(good) == 3
```
