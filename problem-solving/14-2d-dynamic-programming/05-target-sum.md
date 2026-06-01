# Target Sum

[Problem Link](https://leetcode.com/problems/target-sum/)

## Approach

Assign each number a `+` or `-` sign so the total equals `target`.

Let `P` be the sum of positively signed numbers and `N` the sum of negatively signed numbers. Then `P - N = target` and `P + N = total`, so `P = (target + total) / 2`.

Reduce to: count subsets of `nums` that sum to `P`. Use 0/1 knapsack DP like Partition Equal Subset Sum.

If `target + total` is odd or `abs(target) > total`, return 0.

**Time Complexity:** O(n × sum)  
**Space Complexity:** O(sum)

## Code

```python
class Solution:
    def findTargetSumWays(self, nums: List[int], target: int) -> int:
        total = sum(nums)
        if (target + total) % 2 or abs(target) > total:
            return 0

        subset_sum = (target + total) // 2
        dp = [0] * (subset_sum + 1)
        dp[0] = 1

        for num in nums:
            for s in range(subset_sum, num - 1, -1):
                dp[s] += dp[s - num]

        return dp[subset_sum]
```
