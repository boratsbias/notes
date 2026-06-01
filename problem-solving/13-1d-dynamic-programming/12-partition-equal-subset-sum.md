# Partition Equal Subset Sum

[Problem Link](https://leetcode.com/problems/partition-equal-subset-sum/)

## Approach

Partition the array into two subsets with equal sum if and only if some subset sums to `total // 2`.

If the total is odd, return false immediately.

Use 0/1 knapsack DP: `dp[s]` is true if sum `s` is achievable. For each number, iterate sums backward from `target` down to `num` and set `dp[s] = dp[s] or dp[s - num]`.

**Time Complexity:** O(n × sum)  
**Space Complexity:** O(sum)

## Code

```python
class Solution:
    def canPartition(self, nums: List[int]) -> bool:
        total = sum(nums)
        if total % 2:
            return False

        target = total // 2
        dp = [False] * (target + 1)
        dp[0] = True

        for num in nums:
            for s in range(target, num - 1, -1):
                dp[s] = dp[s] or dp[s - num]

        return dp[target]
```
