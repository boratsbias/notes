# Interleaving String

[Problem Link](https://leetcode.com/problems/interleaving-string/)

## Approach

Check whether `s3` can be formed by interleaving `s1` and `s2` in order.

Let `dp[i][j]` mean the prefix `s1[0:i]` and `s2[0:j]` can form `s3[0:i+j]`.

Transition:

- If `s1[i - 1] == s3[i + j - 1]`, then `dp[i][j] |= dp[i - 1][j]`
- If `s2[j - 1] == s3[i + j - 1]`, then `dp[i][j] |= dp[i][j - 1]`

Base: `dp[0][0] = True`.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(n) with one row

## Code

```python
class Solution:
    def isInterleave(self, s1: str, s2: str, s3: str) -> bool:
        if len(s1) + len(s2) != len(s3):
            return False

        prev = [False] * (len(s2) + 1)
        prev[0] = True

        for i in range(len(s1) + 1):
            curr = [False] * (len(s2) + 1)
            for j in range(len(s2) + 1):
                if i > 0 and s1[i - 1] == s3[i + j - 1]:
                    curr[j] |= prev[j]
                if j > 0 and s2[j - 1] == s3[i + j - 1]:
                    curr[j] |= curr[j - 1]
            prev = curr

        return prev[-1]
```
