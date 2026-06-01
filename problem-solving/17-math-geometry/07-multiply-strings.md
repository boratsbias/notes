# Multiply Strings

[Problem Link](https://leetcode.com/problems/multiply-strings/)

## Approach

Multiply two numeric strings without converting to built-in big integers.

Schoolbook multiplication: digit `i` of `num1` and digit `j` of `num2` contribute to position `i + j` in the result (from the right).

Store partial sums in an array of length `len(num1) + len(num2)`, then build the answer string skipping leading zeros.

**Time Complexity:** O(m × n)  
**Space Complexity:** O(m + n)

## Code

```python
class Solution:
    def multiply(self, num1: str, num2: str) -> str:
        if num1 == "0" or num2 == "0":
            return "0"

        m, n = len(num1), len(num2)
        pos = [0] * (m + n)

        for i in range(m - 1, -1, -1):
            for j in range(n - 1, -1, -1):
                mul = int(num1[i]) * int(num2[j])
                p1, p2 = i + j, i + j + 1
                total = mul + pos[p2]
                pos[p1] += total // 10
                pos[p2] = total % 10

        start = 0
        while start < len(pos) - 1 and pos[start] == 0:
            start += 1

        return "".join(str(d) for d in pos[start:])
```
