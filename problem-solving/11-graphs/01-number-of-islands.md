# Number of Islands

[Problem Link](https://leetcode.com/problems/number-of-islands/)

## Approach

Treat each `'1'` cell as part of a land mass and count how many separate connected components exist.

Use DFS or BFS from every unvisited land cell:

- Mark the current cell as visited (mutate the grid or use a visited set).
- Explore all four neighbors that are in bounds and contain land.
- Each time you start a search from an unvisited `'1'`, increment the island count.

A Union-Find approach also works by merging adjacent land cells, but DFS/BFS is simpler for a grid.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m × n) for recursion or the BFS queue in the worst case

## Code

```python
class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        if not grid:
            return 0

        rows, cols = len(grid), len(grid[0])
        count = 0

        def dfs(r, c):
            if r < 0 or r >= rows or c < 0 or c >= cols or grid[r][c] != "1":
                return
            grid[r][c] = "0"
            dfs(r + 1, c)
            dfs(r - 1, c)
            dfs(r, c + 1)
            dfs(r, c - 1)

        for r in range(rows):
            for c in range(cols):
                if grid[r][c] == "1":
                    count += 1
                    dfs(r, c)

        return count
```
