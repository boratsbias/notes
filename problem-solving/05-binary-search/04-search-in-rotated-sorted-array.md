# Search in Rotated Sorted Array

[Problem Link](https://leetcode.com/problems/search-in-rotated-sorted-array/)

## Approach

Binary search while identifying which half remains sorted.

At each mid:

- If `nums[mid] == target`, return mid.
- If the left half `[left, mid]` is sorted, check whether target lies in that range. If yes, move right to mid minus 1. Otherwise search the right half.
- Otherwise the right half is sorted. Apply the same logic.

At least one half is always sorted in a rotated array with distinct values.

Linear scan is **O(n)**. Binary search stays **O(log n)**.

**Time Complexity:** O(log n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        left, right = 0, len(nums) - 1

        while left <= right:
            mid = (left + right) // 2
            if nums[mid] == target:
                return mid

            if nums[left] <= nums[mid]:
                if nums[left] <= target < nums[mid]:
                    right = mid - 1
                else:
                    left = mid + 1
            else:
                if nums[mid] < target <= nums[right]:
                    left = mid + 1
                else:
                    right = mid - 1

        return -1
```
