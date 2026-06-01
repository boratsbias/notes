# Valid Parentheses

[Problem Link](https://leetcode.com/problems/valid-parentheses/)

## Approach

Use a stack to track opening brackets in the order they appear.

For each character:

- Push opening brackets onto the stack.
- For closing brackets, the top of the stack must be the matching opener. If not, the string is invalid.

After scanning the string, the stack must be empty.

Counting brackets without order fails on cases like `"(]"`. The stack enforces correct nesting in one pass.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def isValid(self, s: str) -> bool:
        pairs = {")": "(", "]": "[", "}": "{"}
        stack = []

        for ch in s:
            if ch in pairs:
                if not stack or stack[-1] != pairs[ch]:
                    return False
                stack.pop()
            else:
                stack.append(ch)

        return not stack
```
