# Regular Expression Matching

[Problem Link](https://leetcode.com/problems/regular-expression-matching/)

## Approach

Support `.` (any single character) and `*` (zero or more of the preceding element).

Let `dp[i][j]` mean `s[0:i]` matches `p[0:j]`.

If `p[j - 1]` is not `*`:

- Match when characters equal or pattern has `.`, and `dp[i - 1][j - 1]` is true.

If `p[j - 1]` is `*`:

- Zero occurrences: `dp[i][j - 2]`
- One or more: if `s[i - 1]` matches `p[j - 2]` (or `.`), then `dp[i - 1][j]`

**Time Complexity:** O(m × n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        prev = [False] * (len(p) + 1)
        prev[0] = True

        for j in range(2, len(p) + 1):
            if p[j - 1] == "*":
                prev[j] = prev[j - 2]

        for i in range(1, len(s) + 1):
            curr = [False] * (len(p) + 1)
            for j in range(1, len(p) + 1):
                if p[j - 1] == "*":
                    curr[j] = curr[j - 2]
                    if p[j - 2] == s[i - 1] or p[j - 2] == ".":
                        curr[j] = curr[j] or prev[j]
                elif p[j - 1] == s[i - 1] or p[j - 1] == ".":
                    curr[j] = prev[j - 1]
            prev = curr

        return prev[-1]
```
