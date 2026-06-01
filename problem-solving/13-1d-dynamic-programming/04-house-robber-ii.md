# House Robber II

[Problem Link](https://leetcode.com/problems/house-robber-ii/)

## Approach

Houses are arranged in a circle, so the first and last houses cannot both be robbed.

Run the House Robber I logic twice:

- Once on `nums[0..n-2]` (exclude last house)
- Once on `nums[1..n-1]` (exclude first house)

Return the maximum of the two results. Handle `n == 1` separately.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def rob(self, nums: List[int]) -> int:
        if len(nums) == 1:
            return nums[0]

        def linear(arr):
            prev, curr = 0, 0
            for num in arr:
                prev, curr = curr, max(curr, prev + num)
            return curr

        return max(linear(nums[:-1]), linear(nums[1:]))
```
