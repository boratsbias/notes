# Trapping Rain Water

[Problem Link](https://leetcode.com/problems/trapping-rain-water/)

## Approach

Water above index i is trapped up to `min(max_left, max_right) - height[i]` when that value is positive.

Use two pointers at the ends with running max heights from the left and right:

- Process the side with the smaller max boundary, because that side limits the water level at the current pointer.
- Update the answer with trapped water at that index, then move that pointer inward and refresh its side max.

Precomputing prefix and suffix max arrays uses **O(n)** extra space. Two pointers keep extra space at **O(1)** while still visiting each index once.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def trap(self, height: List[int]) -> int:
        left, right = 0, len(height) - 1
        left_max, right_max = 0, 0
        water = 0

        while left < right:
            if height[left] < height[right]:
                left_max = max(left_max, height[left])
                water += left_max - height[left]
                left += 1
            else:
                right_max = max(right_max, height[right])
                water += right_max - height[right]
                right -= 1

        return water
```
