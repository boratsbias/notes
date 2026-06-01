# Container With Most Water

[Problem Link](https://leetcode.com/problems/container-with-most-water/)

## Approach

Use two pointers at the left and right ends of the height array.

The area between them is limited by the shorter line. Compute that area, update the maximum, then move the pointer at the shorter line inward. Moving the taller line inward cannot increase area because width shrinks and height is still capped by the shorter side.

Checking every pair takes **O(n²)** time. The two-pointer greedy move runs in **O(n)** time.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def maxArea(self, height: List[int]) -> int:
        left, right = 0, len(height) - 1
        best = 0

        while left < right:
            width = right - left
            h = min(height[left], height[right])
            best = max(best, width * h)

            if height[left] < height[right]:
                left += 1
            else:
                right -= 1

        return best
```
