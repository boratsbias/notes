# Pacific Atlantic Water Flow

[Problem Link](https://leetcode.com/problems/pacific-atlantic-water-flow/)

## Approach

Reverse the flow: instead of checking whether water from each cell can reach both oceans, check which cells each ocean can reach by moving to equal or higher heights.

Run DFS or BFS from all Pacific border cells (top and left) and mark reachable cells. Do the same from Atlantic border cells (bottom and right).

Cells reachable from both searches can drain to both oceans. Return their coordinates.

Starting from every interior cell and simulating flow is slower and harder to get right.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m × n)

## Code

```python
class Solution:
    def pacificAtlantic(self, heights: List[List[int]]) -> List[List[int]]:
        rows, cols = len(heights), len(heights[0])
        pacific, atlantic = set(), set()

        def dfs(r, c, visited, prev_height):
            if (
                r < 0
                or r >= rows
                or c < 0
                or c >= cols
                or (r, c) in visited
                or heights[r][c] < prev_height
            ):
                return
            visited.add((r, c))
            dfs(r + 1, c, visited, heights[r][c])
            dfs(r - 1, c, visited, heights[r][c])
            dfs(r, c + 1, visited, heights[r][c])
            dfs(r, c - 1, visited, heights[r][c])

        for c in range(cols):
            dfs(0, c, pacific, heights[0][c])
            dfs(rows - 1, c, atlantic, heights[rows - 1][c])
        for r in range(rows):
            dfs(r, 0, pacific, heights[r][0])
            dfs(r, cols - 1, atlantic, heights[r][cols - 1])

        return [[r, c] for r, c in pacific & atlantic]
```
