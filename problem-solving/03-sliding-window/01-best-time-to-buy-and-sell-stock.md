# Best Time to Buy and Sell Stock

[Problem Link](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/)

## Approach

Track the lowest price seen so far and the maximum profit achievable by selling at the current price.

As we scan left to right:

- Update the minimum buy price when we see a lower value.
- Compute profit if we sold today and keep the best profit.

This is a one-pass sliding window over the timeline where the window start is the cheapest buy day and the window end is the current day.

A brute force approach checks every buy and sell pair in **O(n²)** time. Kadane-style scanning reduces this to **O(n)** with **O(1)** space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        min_price = float("inf")
        max_profit = 0

        for price in prices:
            min_price = min(min_price, price)
            max_profit = max(max_profit, price - min_price)

        return max_profit
```
