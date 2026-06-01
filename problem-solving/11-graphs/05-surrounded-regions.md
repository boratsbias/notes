# Surrounded Regions

[Problem Link](https://leetcode.com/problems/surrounded-regions/)

## Approach

Only `'O'` cells connected to the border escape capture. Every other `'O'` becomes `'X'`.

First pass: DFS or BFS from every `'O'` on the border and mark those cells (or a temporary symbol) as safe.

Second pass: flip every remaining `'O'` to `'X'`, and restore safe cells back to `'O'`.

Trying to capture regions from the inside out is awkward because you must verify a region never touches the edge.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m × n) for recursion or BFS

## Code

```python
class Solution:
    def solve(self, board: List[List[str]]) -> None:
        rows, cols = len(board), len(board[0])

        def dfs(r, c):
            if r < 0 or r >= rows or c < 0 or c >= cols or board[r][c] != "O":
                return
            board[r][c] = "T"
            dfs(r + 1, c)
            dfs(r - 1, c)
            dfs(r, c + 1)
            dfs(r, c - 1)

        for r in range(rows):
            for c in range(cols):
                if (
                    board[r][c] == "O"
                    and (r == 0 or r == rows - 1 or c == 0 or c == cols - 1)
                ):
                    dfs(r, c)

        for r in range(rows):
            for c in range(cols):
                if board[r][c] == "O":
                    board[r][c] = "X"
                elif board[r][c] == "T":
                    board[r][c] = "O"
```
