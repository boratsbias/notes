# Sum of Two Integers

[Problem Link](https://leetcode.com/problems/sum-of-two-integers/)

## Approach

Add `a` and `b` without using `+` or `-`.

Use bitwise operations:

- `carry = (a & b) << 1`
- `a = a ^ b` (sum without carry)
- Repeat until carry is 0

Python integers are unbounded, so mask to 32 bits and handle sign extension for negative results.

**Time Complexity:** O(1) bounded word size  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def getSum(self, a: int, b: int) -> int:
        mask = 0xFFFFFFFF

        while b:
            carry = (a & b) << 1
            a = (a ^ b) & mask
            b = carry & mask

        return a if a <= 0x7FFFFFFF else ~(a ^ mask)
```
