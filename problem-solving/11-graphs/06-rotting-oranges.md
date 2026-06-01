# Rotting Oranges

[Problem Link](https://leetcode.com/problems/rotting-oranges/)

## Approach

Model the spread of rot as multi-source BFS on a grid.

Enqueue all initially rotten oranges with time 0. Each minute, rot spreads to adjacent fresh oranges.

Track the maximum time reached when a fresh orange becomes rotten. After BFS, if any fresh orange remains, return -1.

DFS is a poor fit because all rotten oranges spread simultaneously each minute.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m × n) for the queue

## Code

```python
class Solution:
    def orangesRotting(self, grid: List[List[int]]) -> int:
        rows, cols = len(grid), len(grid[0])
        queue = deque()
        fresh = 0

        for r in range(rows):
            for c in range(cols):
                if grid[r][c] == 2:
                    queue.append((r, c, 0))
                elif grid[r][c] == 1:
                    fresh += 1

        minutes = 0
        while queue:
            r, c, t = queue.popleft()
            minutes = max(minutes, t)
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] == 1:
                    grid[nr][nc] = 2
                    fresh -= 1
                    queue.append((nr, nc, t + 1))

        return minutes if fresh == 0 else -1
```
