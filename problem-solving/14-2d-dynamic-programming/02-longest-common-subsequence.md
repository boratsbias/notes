# Longest Common Subsequence

[Problem Link](https://leetcode.com/problems/longest-common-subsequence/)

## Approach

Let `dp[i][j]` be the LCS length of `text1[0:i]` and `text2[0:j]`.

If `text1[i - 1] == text2[j - 1]`, extend the LCS: `dp[i][j] = 1 + dp[i - 1][j - 1]`.

Otherwise take the best without one character: `dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])`.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(n) with rolling rows

## Code

```python
class Solution:
    def longestCommonSubsequence(self, text1: str, text2: str) -> int:
        prev = [0] * (len(text2) + 1)

        for i in range(1, len(text1) + 1):
            curr = [0] * (len(text2) + 1)
            for j in range(1, len(text2) + 1):
                if text1[i - 1] == text2[j - 1]:
                    curr[j] = 1 + prev[j - 1]
                else:
                    curr[j] = max(prev[j], curr[j - 1])
            prev = curr

        return prev[-1]
```
