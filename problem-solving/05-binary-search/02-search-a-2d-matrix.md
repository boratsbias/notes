# Search a 2D Matrix

[Problem Link](https://leetcode.com/problems/search-a-2d-matrix/)

## Approach

Treat the matrix as a sorted 1D array. Row-major order is non-decreasing because each row is sorted and the first value of a row is greater than the last value of the previous row.

Binary search on index `0` to `m * n - 1` and map a mid index to `(row, col)` with `mid // n` and `mid % n`.

Searching row by row with binary search on each row misses the global ordering across rows.

**Time Complexity:** O(log(m * n))  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        if not matrix or not matrix[0]:
            return False

        m, n = len(matrix), len(matrix[0])
        left, right = 0, m * n - 1

        while left <= right:
            mid = (left + right) // 2
            value = matrix[mid // n][mid % n]
            if value == target:
                return True
            if value < target:
                left = mid + 1
            else:
                right = mid - 1

        return False
```
