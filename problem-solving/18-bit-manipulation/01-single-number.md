# Single Number

[Problem Link](https://leetcode.com/problems/single-number/)

## Approach

Every number appears twice except one. XOR cancels pairs: `a ^ a = 0` and `a ^ 0 = a`.

XOR all numbers together. The result is the unique element.

Sorting or hash maps work but use extra time or space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        result = 0
        for num in nums:
            result ^= num
        return result
```
