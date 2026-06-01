# Best Time to Buy and Sell Stock with Cooldown

[Problem Link](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/)

## Approach

Track three states while scanning prices:

- `held`: max profit if holding a stock
- `sold`: max profit if just sold today (cooldown next day)
- `rest`: max profit if not holding and not in cooldown from a sale today

Transitions each day:

- `held = max(held, rest - price)` (buy)
- `sold = held + price` (sell)
- `rest = max(rest, sold)` (wait or finish cooldown)

Start with `held = -inf`, `sold = 0`, `rest = 0`.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        held, sold, rest = float("-inf"), 0, 0

        for price in prices:
            prev_sold = sold
            sold = held + price
            held = max(held, rest - price)
            rest = max(rest, prev_sold)

        return max(sold, rest)
```
