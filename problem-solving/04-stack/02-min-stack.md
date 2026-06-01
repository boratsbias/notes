# Min Stack

[Problem Link](https://leetcode.com/problems/min-stack/)

## Approach

Maintain two stacks: one for all values and one that tracks the minimum at each depth.

On push, append the value to the main stack and push `min(value, current_min)` onto the min stack.

On pop, remove from both stacks. `getMin` reads the top of the min stack in **O(1)** time.

Storing the minimum in a single variable breaks after pops when an earlier minimum is removed. The auxiliary stack preserves history.

**Time Complexity:** O(1) per operation  
**Space Complexity:** O(n)

## Code

```python
class MinStack:

    def __init__(self):
        self.stack = []
        self.min_stack = []

    def push(self, val: int) -> None:
        self.stack.append(val)
        current_min = min(val, self.min_stack[-1] if self.min_stack else val)
        self.min_stack.append(current_min)

    def pop(self) -> None:
        self.stack.pop()
        self.min_stack.pop()

    def top(self) -> int:
        return self.stack[-1]

    def getMin(self) -> int:
        return self.min_stack[-1]
```
