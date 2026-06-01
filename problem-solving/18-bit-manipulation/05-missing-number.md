# Missing Number

[Problem Link](https://leetcode.com/problems/missing-number/)

## Approach

Array contains `n` distinct numbers from `0` to `n` with one missing.

XOR all indices `0..n` and all values in `nums`. Pairs cancel and the missing value remains.

Sum formula `n * (n + 1) // 2 - sum(nums)` also works.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        result = len(nums)
        for i, num in enumerate(nums):
            result ^= i ^ num
        return result
```
