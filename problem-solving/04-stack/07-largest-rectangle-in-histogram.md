# Largest Rectangle in Histogram

[Problem Link](https://leetcode.com/problems/largest-rectangle-in-histogram/)

## Approach

Use a monotonic increasing stack of indices. When a shorter bar appears, bars on the stack can no longer extend rightward, so compute their maximum rectangle width.

For each popped index, height is `heights[popped]`. The width extends from the new stack top plus one to the current index minus one.

Append a sentinel height of 0 at the end to flush remaining bars.

Checking every pair of bars is **O(n²)**. Each index is pushed and popped once for **O(n)** time.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def largestRectangleArea(self, heights: List[int]) -> int:
        stack = []
        best = 0
        heights.append(0)

        for i, h in enumerate(heights):
            while stack and heights[stack[-1]] > h:
                height = heights[stack.pop()]
                width = i if not stack else i - stack[-1] - 1
                best = max(best, height * width)
            stack.append(i)

        heights.pop()
        return best
```
