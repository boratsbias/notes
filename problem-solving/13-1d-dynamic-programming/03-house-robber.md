# House Robber

[Problem Link](https://leetcode.com/problems/house-robber/)

## Approach

At each house, choose to rob it (and skip the previous house) or skip it (and keep the best from before).

Let `dp[i]` be the maximum money robbing houses `0..i`:

- `dp[i] = max(dp[i - 1], dp[i - 2] + nums[i])`

Base: `dp[0] = nums[0]`, `dp[1] = max(nums[0], nums[1])`.

Track only two previous values for **O(1)** space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def rob(self, nums: List[int]) -> int:
        prev, curr = 0, 0

        for num in nums:
            prev, curr = curr, max(curr, prev + num)

        return curr
```
