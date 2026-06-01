# N-Queens

[Problem Link](https://leetcode.com/problems/n-queens/)

## Approach

Place queens row by row. At each row, try every column and skip placements attacked by existing queens.

Track occupied columns and both diagonal directions with sets for **O(1)** conflict checks.

When a queen is placed in every row, convert the board to the required string format.

Checking the full board naively at each step is slower. Sets for columns and diagonals prune efficiently.

**Time Complexity:** O(n!)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        result = []
        cols = set()
        diag1 = set()
        diag2 = set()
        board = [["."] * n for _ in range(n)]

        def backtrack(row):
            if row == n:
                result.append(["".join(r) for r in board])
                return
            for col in range(n):
                if col in cols or (row - col) in diag1 or (row + col) in diag2:
                    continue
                cols.add(col)
                diag1.add(row - col)
                diag2.add(row + col)
                board[row][col] = "Q"
                backtrack(row + 1)
                board[row][col] = "."
                cols.remove(col)
                diag1.remove(row - col)
                diag2.remove(row + col)

        backtrack(0)
        return result
```
