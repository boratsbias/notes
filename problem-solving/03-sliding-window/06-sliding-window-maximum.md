# Sliding Window Maximum

[Problem Link](https://leetcode.com/problems/sliding-window-maximum/)

## Approach

Use a monotonic decreasing deque that stores indices of elements in the current window, largest at the front.

For each new index:

- Remove indices from the back while the current value is greater, since they can never become the maximum.
- Remove the front index if it falls outside the window.
- Append the current index and record the front value once the window is full.

A max heap works but lazy deletion makes each step **O(log n)**. The deque gives **O(1)** amortized work per element.

**Time Complexity:** O(n)  
**Space Complexity:** O(k) for the deque

## Code

```python
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        dq = deque()
        result = []

        for i, num in enumerate(nums):
            while dq and nums[dq[-1]] <= num:
                dq.pop()
            dq.append(i)

            if dq[0] <= i - k:
                dq.popleft()

            if i >= k - 1:
                result.append(nums[dq[0]])

        return result
```
