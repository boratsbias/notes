# Edit Distance

[Problem Link](https://leetcode.com/problems/edit-distance/)

## Approach

Find the minimum insert, delete, and replace operations to turn `word1` into `word2`.

Let `dp[i][j]` be the edit distance between `word1[0:i]` and `word2[0:j]`.

If characters match: `dp[i][j] = dp[i - 1][j - 1]`.

Otherwise: `dp[i][j] = 1 + min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1])` for delete, insert, replace.

Base: converting to or from empty string costs the other length.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        prev = list(range(len(word2) + 1))

        for i in range(1, len(word1) + 1):
            curr = [i] + [0] * len(word2)
            for j in range(1, len(word2) + 1):
                if word1[i - 1] == word2[j - 1]:
                    curr[j] = prev[j - 1]
                else:
                    curr[j] = 1 + min(prev[j], curr[j - 1], prev[j - 1])
            prev = curr

        return prev[-1]
```
