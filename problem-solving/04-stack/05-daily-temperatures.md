# Daily Temperatures

[Problem Link](https://leetcode.com/problems/daily-temperatures/)

## Approach

Use a monotonic decreasing stack of indices. Each index waits for the next warmer day to its right.

Scan from right to left:

- Pop indices whose temperature is less than or equal to the current day.
- The current day is the next warmer day for whatever remains on the stack.
- Push the current index.

A nested loop checks every future day in **O(n²)** time. The stack gives **O(n)** time because each index is pushed and popped once.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        n = len(temperatures)
        answer = [0] * n
        stack = []

        for i in range(n - 1, -1, -1):
            while stack and temperatures[stack[-1]] <= temperatures[i]:
                stack.pop()
            if stack:
                answer[i] = stack[-1] - i
            stack.append(i)

        return answer
```
