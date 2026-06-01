# Generate Parentheses

[Problem Link](https://leetcode.com/problems/generate-parentheses/)

## Approach

Use backtracking with two counters: open parentheses used so far and close parentheses used so far.

At each step:

- Add `(` if open count is below n.
- Add `)` if close count is below open count.

When the string length reaches 2n, save it.

Generating all strings and filtering valid ones wastes work on invalid combinations. The counters guarantee validity during construction.

**Time Complexity:** O(4^n / sqrt(n)) for Catalan number of valid strings  
**Space Complexity:** O(n) recursion depth excluding output

## Code

```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        result = []

        def backtrack(path, open_count, close_count):
            if len(path) == 2 * n:
                result.append("".join(path))
                return
            if open_count < n:
                path.append("(")
                backtrack(path, open_count + 1, close_count)
                path.pop()
            if close_count < open_count:
                path.append(")")
                backtrack(path, open_count, close_count + 1)
                path.pop()

        backtrack([], 0, 0)
        return result
```
