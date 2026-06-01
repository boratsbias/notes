# Combination Sum

[Problem Link](https://leetcode.com/problems/combination-sum/)

## Approach

Sort candidates and backtrack, allowing reuse of the same number.

At each step, try candidates from the current index onward. If the remaining target reaches zero, save the path. If it goes negative, stop.

Sorting lets us break early when a candidate exceeds the remaining target.

Trying all multisets without pruning repeats work. Start-index backtracking with early exit is cleaner.

**Time Complexity:** O(2^target) in the worst case  
**Space Complexity:** O(target) recursion depth excluding output

## Code

```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        result = []
        candidates.sort()

        def backtrack(start, remaining, path):
            if remaining == 0:
                result.append(path[:])
                return
            for i in range(start, len(candidates)):
                if candidates[i] > remaining:
                    break
                path.append(candidates[i])
                backtrack(i, remaining - candidates[i], path)
                path.pop()

        backtrack(0, target, [])
        return result
```
