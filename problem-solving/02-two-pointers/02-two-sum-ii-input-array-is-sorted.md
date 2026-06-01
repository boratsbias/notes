# Two Sum II - Input Array Is Sorted

[Problem Link](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/)

## Approach

Because the array is sorted, use two pointers at the left and right ends.

At each step, compare the sum of the two pointer values to the target:

- If the sum is too small, move the left pointer right to increase the sum.
- If the sum is too large, move the right pointer left to decrease the sum.
- If the sum equals the target, return the 1-indexed positions.

A hash map works in **O(n)** time but ignores the sorted order. Two pointers solve the problem in **O(n)** time with **O(1)** extra space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def twoSum(self, numbers: List[int], target: int) -> List[int]:
        left, right = 0, len(numbers) - 1

        while left < right:
            total = numbers[left] + numbers[right]

            if total == target:
                return [left + 1, right + 1]
            if total < target:
                left += 1
            else:
                right -= 1
```
