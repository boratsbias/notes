# Climbing Stairs

[Problem Link](https://leetcode.com/problems/climbing-stairs/)

## Approach

To reach step `n`, you came from step `n - 1` (one step) or step `n - 2` (two steps).

Define `dp[i]` as the number of distinct ways to reach step `i`:

- `dp[i] = dp[i - 1] + dp[i - 2]`
- Base cases: `dp[1] = 1`, `dp[2] = 2`

This is Fibonacci. Only the last two values are needed, so space can be **O(1)**.

Recursion without memoization repeats work and is **O(2^n)**.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def climbStairs(self, n: int) -> int:
        if n <= 2:
            return n

        prev, curr = 1, 2
        for _ in range(3, n + 1):
            prev, curr = curr, prev + curr

        return curr
```
