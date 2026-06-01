# Reverse Bits

[Problem Link](https://leetcode.com/problems/reverse-bits/)

## Approach

Reverse the 32 bits of unsigned integer `n`.

Build the result bit by bit: shift `result` left, add `n & 1`, then shift `n` right. Repeat 32 times.

**Time Complexity:** O(1) fixed 32 steps  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def reverseBits(self, n: int) -> int:
        result = 0
        for _ in range(32):
            result = (result << 1) | (n & 1)
            n >>= 1
        return result
```
