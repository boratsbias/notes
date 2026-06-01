# Find Minimum in Rotated Sorted Array

[Problem Link](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/)

## Approach

Binary search for the rotation pivot, which is the smallest element.

Compare `nums[mid]` with `nums[right]`:

- If `nums[mid] > nums[right]`, the minimum is in the right half excluding mid.
- Otherwise the minimum is in the left half including mid.

When `left == right`, that index holds the minimum.

Scanning the array is **O(n)**. Binary search finds the pivot in **O(log n)** time.

**Time Complexity:** O(log n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def findMin(self, nums: List[int]) -> int:
        left, right = 0, len(nums) - 1

        while left < right:
            mid = (left + right) // 2
            if nums[mid] > nums[right]:
                left = mid + 1
            else:
                right = mid

        return nums[left]
```
