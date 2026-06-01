# Coin Change 2

[Problem Link](https://leetcode.com/problems/coin-change-ii/)

## Approach

Count the number of combinations that sum to `amount`. Each coin can be used unlimited times.

Unbounded knapsack: iterate coins outer loop, amounts inner loop forward so each combination is counted once per coin ordering.

`dp[a] += dp[a - coin]` for `a` from `coin` to `amount`.

Swapping loops and iterating amounts outer would count permutations instead of combinations.

**Time Complexity:** O(amount × n)  
**Space Complexity:** O(amount)

## Code

```python
class Solution:
    def change(self, amount: int, coins: List[int]) -> int:
        dp = [0] * (amount + 1)
        dp[0] = 1

        for coin in coins:
            for a in range(coin, amount + 1):
                dp[a] += dp[a - coin]

        return dp[amount]
```
