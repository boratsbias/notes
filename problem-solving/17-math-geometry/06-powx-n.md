# Pow(x, n)

[Problem Link](https://leetcode.com/problems/powx-n/)

## Approach

Compute `x^n` in **O(log n)** time using binary exponentiation.

If `n` is negative, invert `x` and use `|n|`.

While `n > 0`, if the current bit of `n` is set, multiply the result by the current power of `x`. Square `x` and halve `n`.

**Time Complexity:** O(log n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def myPow(self, x: float, n: int) -> float:
        if n < 0:
            x = 1 / x
            n = -n

        result = 1.0
        while n:
            if n & 1:
                result *= x
            x *= x
            n >>= 1

        return result
```
