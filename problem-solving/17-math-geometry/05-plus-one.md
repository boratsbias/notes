# Plus One

[Problem Link](https://leetcode.com/problems/plus-one/)

## Approach

Add one to a large integer stored as an array of digits, most significant digit first.

Traverse from the least significant digit (end of array). Add 1 with carry propagation.

If all digits are 9, the result needs an extra leading 1 (e.g. 999 + 1 = 1000).

**Time Complexity:** O(n)  
**Space Complexity:** O(1) excluding output

## Code

```python
class Solution:
    def plusOne(self, digits: List[int]) -> List[int]:
        for i in range(len(digits) - 1, -1, -1):
            if digits[i] < 9:
                digits[i] += 1
                return digits
            digits[i] = 0

        return [1] + digits
```
