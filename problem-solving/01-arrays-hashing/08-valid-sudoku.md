# Valid Sudoku

[Problem Link](https://leetcode.com/problems/valid-sudoku/)

## Approach

Only filled cells need to be checked. For each digit placed at row r and column c:

- It must not already appear in row r.
- It must not already appear in column c.
- It must not already appear in the 3x3 box that contains (r, c).

Use three sets of sets (or hash sets keyed by row, column, and box id). Box id can be computed as `(r // 3) * 3 + (c // 3)`.

If any digit violates one of these constraints, the board is invalid. If every filled cell passes, the board is valid.

**Time Complexity:** O(1) because the board is fixed at 9x9  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def isValidSudoku(self, board: List[List[str]]) -> bool:
        rows = [set() for _ in range(9)]
        cols = [set() for _ in range(9)]
        boxes = [set() for _ in range(9)]

        for r in range(9):
            for c in range(9):
                val = board[r][c]
                if val == ".":
                    continue

                box = (r // 3) * 3 + (c // 3)
                if val in rows[r] or val in cols[c] or val in boxes[box]:
                    return False

                rows[r].add(val)
                cols[c].add(val)
                boxes[box].add(val)

        return True
```
