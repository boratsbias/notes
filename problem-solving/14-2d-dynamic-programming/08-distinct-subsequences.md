# Distinct Subsequences

[Problem Link](https://leetcode.com/problems/distinct-subsequences/)

## Approach

Count how many distinct subsequences of `s` equal `t`.

Let `dp[i][j]` be the count for `s[0:i]` and `t[0:j]`.

If `s[i - 1] == t[j - 1]`, either use that character or skip it:

- `dp[i][j] = dp[i - 1][j - 1] + dp[i - 1][j]`

Otherwise:

- `dp[i][j] = dp[i - 1][j]`

Base: empty `t` matches once for any prefix of `s`.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def numDistinct(self, s: str, t: str) -> int:
        prev = [0] * (len(t) + 1)
        prev[0] = 1

        for i in range(1, len(s) + 1):
            curr = [0] * (len(t) + 1)
            curr[0] = 1
            for j in range(1, len(t) + 1):
                curr[j] = prev[j]
                if s[i - 1] == t[j - 1]:
                    curr[j] += prev[j - 1]
            prev = curr

        return prev[-1]
```
