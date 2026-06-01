# Reverse Integer

[Problem Link](https://leetcode.com/problems/reverse-integer/)

## Approach

Reverse digits of a 32-bit signed integer. Return 0 if the reversed value overflows.

Repeatedly pop the last digit from `x` and push it onto `result`:

- `digit = x % 10`
- `x //= 10`
- `result = result * 10 + digit`

Before multiplying, check 32-bit bounds: `result > MAX // 10` or `(result == MAX // 10 and digit > 7)` (and symmetric check for negatives).

**Time Complexity:** O(log x)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def reverse(self, x: int) -> int:
        INT_MAX = 2**31 - 1
        INT_MIN = -2**31
        result = 0
        sign = -1 if x < 0 else 1
        x = abs(x)

        while x:
            digit = x % 10
            x //= 10
            if result > INT_MAX // 10 or (result == INT_MAX // 10 and digit > 7):
                return 0
            result = result * 10 + digit

        result *= sign
        return result if INT_MIN <= result <= INT_MAX else 0
```
