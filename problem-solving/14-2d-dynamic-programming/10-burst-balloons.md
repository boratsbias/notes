# Burst Balloons

[Problem Link](https://leetcode.com/problems/burst-balloons/)

## Approach

Bursting balloon `i` last in a range gives coins `nums[left] * nums[i] * nums[right]` plus best results from the subranges on both sides.

Pad `nums` with `1` at both ends. Let `dp[l][r]` be max coins bursting all balloons strictly between `l` and `r`, where `l` and `r` are boundary indices never burst in that subproblem.

Try every `k` in `(l, r)` as the last balloon burst in the interval.

Interval DP: fill by increasing length.

**Time Complexity:** O(n³)  
**Space Complexity:** O(n²)

## Code

```python
class Solution:
    def maxCoins(self, nums: List[int]) -> int:
        balloons = [1] + nums + [1]
        n = len(balloons)
        dp = [[0] * n for _ in range(n)]

        for length in range(3, n + 1):
            for left in range(n - length + 1):
                right = left + length - 1
                for k in range(left + 1, right):
                    dp[left][right] = max(
                        dp[left][right],
                        balloons[left] * balloons[k] * balloons[right]
                        + dp[left][k]
                        + dp[k][right],
                    )

        return dp[0][n - 1]
```
