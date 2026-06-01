# Subsets II

[Problem Link](https://leetcode.com/problems/subsets-ii/)

## Approach

Sort the array first so duplicates are adjacent.

Use start-index backtracking like subsets, but skip duplicate values at the same recursion level by continuing when `nums[i] == nums[i - 1]` and `i > start`.

Sorting plus same-level skipping prevents duplicate subsets such as `[1, 2]` and `[2, 1]` when values repeat.

**Time Complexity:** O(n * 2^n) worst case  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def subsetsWithDup(self, nums: List[int]) -> List[List[int]]:
        result = []
        nums.sort()

        def backtrack(start, path):
            result.append(path[:])
            for i in range(start, len(nums)):
                if i > start and nums[i] == nums[i - 1]:
                    continue
                path.append(nums[i])
                backtrack(i + 1, path)
                path.pop()

        backtrack(0, [])
        return result
```
