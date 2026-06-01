# Spiral Matrix

[Problem Link](https://leetcode.com/problems/spiral-matrix/)

## Approach

Traverse the matrix in spiral order using four boundaries: top, bottom, left, right.

Move right along the top row, down the right column, left along the bottom row, up the left column, then shrink the boundaries.

Stop when top exceeds bottom or left exceeds right.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(1) excluding output

## Code

```python
class Solution:
    def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
        result = []
        top, bottom = 0, len(matrix) - 1
        left, right = 0, len(matrix[0]) - 1

        while top <= bottom and left <= right:
            for c in range(left, right + 1):
                result.append(matrix[top][c])
            top += 1

            for r in range(top, bottom + 1):
                result.append(matrix[r][right])
            right -= 1

            if top <= bottom:
                for c in range(right, left - 1, -1):
                    result.append(matrix[bottom][c])
                bottom -= 1

            if left <= right:
                for r in range(bottom, top - 1, -1):
                    result.append(matrix[r][left])
                left += 1

        return result
```
