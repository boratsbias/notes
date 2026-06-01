# Combination Sum II

[Problem Link](https://leetcode.com/problems/combination-sum-ii/)

## Approach

Each candidate may be used once. Sort the array and use start-index backtracking.

Skip duplicates at the same level when `candidates[i] == candidates[i - 1]` and `i > start`.

When the remaining target hits zero, save the path.

This combines the no-reuse rule from combinations with duplicate skipping from subsets II.

**Time Complexity:** O(2^n) worst case  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        candidates.sort()

        def backtrack(start, remaining, path):
            if remaining == 0:
                result.append(path[:])
                return
            for i in range(start, len(candidates)):
                if i > start and candidates[i] == candidates[i - 1]:
                    continue
                if candidates[i] > remaining:
                    break
                path.append(candidates[i])
                backtrack(i + 1, remaining - candidates[i], path)
                path.pop()

        backtrack(0, target, [])
        return result
```
