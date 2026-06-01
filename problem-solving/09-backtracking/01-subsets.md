# Subsets

[Problem Link](https://leetcode.com/problems/subsets/)

## Approach

Use backtracking to explore include or skip decisions for each index.

At every step, append the current path to the result, then try adding each remaining element one at a time while advancing the start index to avoid duplicates.

Iterating bitmask combinations also works. Backtracking is the standard template for subset generation.

**Time Complexity:** O(n * 2^n)  
**Space Complexity:** O(n) recursion depth excluding output

## Code

```python
class Solution:
    def subsets(self, nums: List[int]) -> List[List[int]]:
        result = []

        def backtrack(start, path):
            result.append(path[:])
            for i in range(start, len(nums)):
                path.append(nums[i])
                backtrack(i + 1, path)
                path.pop()

        backtrack(0, [])
        return result
```
