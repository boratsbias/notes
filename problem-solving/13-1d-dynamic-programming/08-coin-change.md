# Coin Change

[Problem Link](https://leetcode.com/problems/coin-change/)

## Approach

Find the fewest coins needed to make amount `amount`, or -1 if impossible.

Let `dp[a]` be the minimum coins for amount `a`. Initialize `dp[0] = 0` and others to infinity.

For each amount from 1 to `amount`, try every coin:

- `dp[a] = min(dp[a], 1 + dp[a - coin])` when `a - coin >= 0`

Bottom-up avoids recursion overhead. Unbounded knapsack style: each coin can be reused.

**Time Complexity:** O(amount × n)  
**Space Complexity:** O(amount)

## Code

```python
class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:
        dp = [float("inf")] * (amount + 1)
        dp[0] = 0

        for a in range(1, amount + 1):
            for coin in coins:
                if a >= coin:
                    dp[a] = min(dp[a], 1 + dp[a - coin])

        return dp[amount] if dp[amount] != float("inf") else -1
```
