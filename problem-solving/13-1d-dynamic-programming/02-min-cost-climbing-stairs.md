# Min Cost Climbing Stairs

[Problem Link](https://leetcode.com/problems/min-cost-climbing-stairs/)

## Approach

You may start at index 0 or 1 and pay `cost[i]` to leave step `i`. The goal is minimum total cost to reach the top (past the last index).

Let `dp[i]` be the minimum cost to reach step `i`:

- `dp[i] = cost[i] + min(dp[i - 1], dp[i - 2])`
- Base: `dp[0] = cost[0]`, `dp[1] = cost[1]`

The answer is `min(dp[n - 1], dp[n - 2])` because the top can be reached from either of the last two steps.

**Time Complexity:** O(n)  
**Space Complexity:** O(1) with two rolling variables

## Code

```python
class Solution:
    def minCostClimbingStairs(self, cost: List[int]) -> int:
        prev, curr = cost[0], cost[1]

        for i in range(2, len(cost)):
            nxt = cost[i] + min(prev, curr)
            prev, curr = curr, nxt

        return min(prev, curr)
```
