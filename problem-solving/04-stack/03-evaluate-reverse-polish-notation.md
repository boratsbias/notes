# Evaluate Reverse Polish Notation

[Problem Link](https://leetcode.com/problems/evaluate-reverse-polish-notation/)

## Approach

Scan tokens left to right with a stack.

- Numbers are pushed onto the stack.
- Operators pop the top two values, apply the operation, and push the result back.

The final answer is the single value left on the stack.

Building an expression tree works but uses extra structure. A stack directly mirrors postfix evaluation.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def evalRPN(self, tokens: List[str]) -> int:
        stack = []
        ops = {
            "+": lambda a, b: a + b,
            "-": lambda a, b: a - b,
            "*": lambda a, b: a * b,
            "/": lambda a, b: int(a / b),
        }

        for token in tokens:
            if token in ops:
                b = stack.pop()
                a = stack.pop()
                stack.append(ops[token](a, b))
            else:
                stack.append(int(token))

        return stack[0]
```
