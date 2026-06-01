# Longest Increasing Path in a Matrix

[Problem Link](https://leetcode.com/problems/longest-increasing-path-in-a-matrix/)

## Approach

Find the longest strictly increasing path in the matrix. Paths cannot reuse cells.

DFS with memoization from each cell: `dfs(r, c)` returns the longest path starting at `(r, c)`.

Only move to neighbors with strictly greater values. Cache results to avoid recomputation.

Topological sort by height also works but memoized DFS is direct.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m × n) for memo and recursion

## Code

```python
class Solution:
    def longestIncreasingPath(self, matrix: List[List[int]]) -> int:
        rows, cols = len(matrix), len(matrix[0])
        memo = {}

        def dfs(r, c):
            if (r, c) in memo:
                return memo[(r, c)]

            best = 1
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < rows and 0 <= nc < cols and matrix[nr][nc] > matrix[r][c]:
                    best = max(best, 1 + dfs(nr, nc))

            memo[(r, c)] = best
            return best

        return max(dfs(r, c) for r in range(rows) for c in range(cols))
```
