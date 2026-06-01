# Rotate Image

[Problem Link](https://leetcode.com/problems/rotate-image/)

## Approach

Rotate an `n × n` matrix 90 degrees clockwise in place.

Two steps:

- Transpose the matrix (swap `matrix[i][j]` with `matrix[j][i]`)
- Reverse each row

This maps `(i, j)` to `(j, n - 1 - i)` as required for clockwise rotation.

Allocating a new matrix uses **O(n²)** extra space.

**Time Complexity:** O(n²)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        n = len(matrix)

        for i in range(n):
            for j in range(i + 1, n):
                matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]

        for row in matrix:
            row.reverse()
```
