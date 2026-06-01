# Binary Search

[Problem Link](https://leetcode.com/problems/binary-search/)

## Approach

Maintain `left` and `right` pointers on the sorted array.

Repeatedly check the middle index:

- If `nums[mid] == target`, return mid.
- If `nums[mid] < target`, search the right half.
- Otherwise search the left half.

Stop when the search space is empty.

Linear scan is **O(n)**. Binary search halves the range each step for **O(log n)** time.

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
            if nums[mid] < target:
                left = mid + 1
            else:
                right = mid - 1

        return -1
```
