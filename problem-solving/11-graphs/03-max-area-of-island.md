# Max Area of Island

[Problem Link](https://leetcode.com/problems/max-area-of-island/)

## Approach

This is the same grid DFS/BFS pattern as Number of Islands, but track the size of each connected land component.

From each unvisited `'1'` cell, flood fill and count cells visited in that search. Update the global maximum area.

Mark cells as visited by flipping `'1'` to `'0'` or using a separate visited structure.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m × n) for recursion or BFS in the worst case

## Code

```python
class Solution:
    def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
        rows, cols = len(grid), len(grid[0])
        best = 0

        def dfs(r, c):
            if r < 0 or r >= rows or c < 0 or c >= cols or grid[r][c] != 1:
                return 0
            grid[r][c] = 0
            return (
                1
                + dfs(r + 1, c)
                + dfs(r - 1, c)
                + dfs(r, c + 1)
                + dfs(r, c - 1)
            )

        for r in range(rows):
            for c in range(cols):
                if grid[r][c] == 1:
                    best = max(best, dfs(r, c))

        return best
```
