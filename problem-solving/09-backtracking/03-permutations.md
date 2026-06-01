# Permutations

[Problem Link](https://leetcode.com/problems/permutations/)

## Approach

Backtrack by swapping or marking used elements.

Build the permutation one position at a time. Track which numbers are already used and try every unused choice at each depth.

When the path length equals n, append a copy to the result.

Generating all orderings with nested loops is messy. Used-array backtracking is the standard approach.

**Time Complexity:** O(n * n!)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        result = []
        used = [False] * len(nums)

        def backtrack(path):
            if len(path) == len(nums):
                result.append(path[:])
                return
            for i, num in enumerate(nums):
                if used[i]:
                    continue
                used[i] = True
                path.append(num)
                backtrack(path)
                path.pop()
                used[i] = False

        backtrack([])
        return result
```
