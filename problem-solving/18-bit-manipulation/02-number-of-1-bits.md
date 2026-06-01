# Number of 1 Bits

[Problem Link](https://leetcode.com/problems/number-of-1-bits/)

## Approach

Count set bits in the unsigned 32-bit representation of `n`.

Repeatedly clear the lowest set bit with `n &= n - 1` and count until `n` is 0.

Alternatively, shift and check the least significant bit each step.

**Time Complexity:** O(1) at most 32 iterations  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def hammingWeight(self, n: int) -> int:
        count = 0
        while n:
            n &= n - 1
            count += 1
        return count
```
