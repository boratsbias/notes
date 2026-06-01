# Counting Bits

[Problem Link](https://leetcode.com/problems/counting-bits/)

## Approach

Return an array where `ans[i]` is the number of set bits in `i`.

DP using the lowest set bit: `dp[i] = dp[i & (i - 1)] + 1`, because removing the lowest 1 bit gives a smaller number already solved.

Alternatively: `dp[i] = dp[i >> 1] + (i & 1)` (count for half plus last bit).

**Time Complexity:** O(n)  
**Space Complexity:** O(n) for output

## Code

```python
class Solution:
    def countBits(self, n: int) -> List[int]:
        dp = [0] * (n + 1)

        for i in range(1, n + 1):
            dp[i] = dp[i & (i - 1)] + 1

        return dp
```
