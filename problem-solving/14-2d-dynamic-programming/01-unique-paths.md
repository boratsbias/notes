# Unique Paths

[Problem Link](https://leetcode.com/problems/unique-paths/)

## Approach

Count paths from top-left to bottom-right moving only right or down.

Let `dp[r][c]` be the number of paths to cell `(r, c)`:

- `dp[r][c] = dp[r - 1][c] + dp[r][c - 1]`
- First row and column are all 1

Can compress to a single row since each cell only depends on the row above and left neighbor.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(n) with one row

## Code

```python
class Solution:
    def uniquePaths(self, m: int, n: int) -> int:
        row = [1] * n

        for _ in range(1, m):
            for c in range(1, n):
                row[c] += row[c - 1]

        return row[-1]
```
