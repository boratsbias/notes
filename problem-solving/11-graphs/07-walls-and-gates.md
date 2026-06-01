# Walls and Gates

[Problem Link](https://leetcode.com/problems/walls-and-gates/)

## Approach

Treat each gate (`0`) as a BFS source and fill empty rooms (`INF`) with their distance to the nearest gate.

Multi-source BFS from all gates at once avoids running a separate search from every empty room.

When visiting a neighbor that is still `INF`, set it to `dist + 1` and enqueue it. Skip walls (`-1`).

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m × n) for the queue

## Code

```python
class Solution:
    def wallsAndGates(self, rooms: List[List[int]]) -> None:
        rows, cols = len(rooms), len(rooms[0])
        queue = deque()

        for r in range(rows):
            for c in range(cols):
                if rooms[r][c] == 0:
                    queue.append((r, c))

        while queue:
            r, c = queue.popleft()
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < rows and 0 <= nc < cols and rooms[nr][nc] == 2147483647:
                    rooms[nr][nc] = rooms[r][c] + 1
                    queue.append((nr, nc))
```
