# Swim in Rising Water

[Problem Link](https://leetcode.com/problems/swim-in-rising-water/)

## Approach

You need the minimum time `t` such that there is a path from top-left to bottom-right using only cells with height at most `t`.

Use Dijkstra on the grid where edge cost is the maximum height along the path so far. Each move updates the path cost to `max(current_cost, grid[nr][nc])`.

Alternatively, binary search the answer and check reachability with BFS/DFS at a given water level.

**Time Complexity:** O(n² log n)  
**Space Complexity:** O(n²)

## Code

```python
class Solution:
    def swimInWater(self, grid: List[List[int]]) -> int:
        n = len(grid)
        heap = [(grid[0][0], 0, 0)]
        visited = set()
        best = grid[0][0]

        while heap:
            cost, r, c = heapq.heappop(heap)
            if (r, c) in visited:
                continue
            visited.add((r, c))
            best = max(best, cost)
            if r == n - 1 and c == n - 1:
                return best
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < n and 0 <= nc < n and (nr, nc) not in visited:
                    heapq.heappush(heap, (max(cost, grid[nr][nc]), nr, nc))

        return best
```
