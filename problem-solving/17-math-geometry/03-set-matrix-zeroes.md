# Set Matrix Zeroes

[Problem Link](https://leetcode.com/problems/set-matrix-zeroes/)

## Approach

If a cell is 0, its entire row and column should become 0. Do this in constant extra space.

Use the first row and first column as markers for which rows and columns must be zeroed. Track separately whether the first row or column originally contained a zero.

Pass 1: mark zeros in row 0 and column 0. Pass 2: zero cells using markers. Pass 3: zero marked first row and column if needed.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def setZeroes(self, matrix: List[List[int]]) -> None:
        rows, cols = len(matrix), len(matrix[0])
        row0 = any(matrix[0][c] == 0 for c in range(cols))
        col0 = any(matrix[r][0] == 0 for r in range(rows))

        for r in range(1, rows):
            for c in range(1, cols):
                if matrix[r][c] == 0:
                    matrix[r][0] = 0
                    matrix[0][c] = 0

        for r in range(1, rows):
            for c in range(1, cols):
                if matrix[r][0] == 0 or matrix[0][c] == 0:
                    matrix[r][c] = 0

        if row0:
            for c in range(cols):
                matrix[0][c] = 0
        if col0:
            for r in range(rows):
                matrix[r][0] = 0
```
