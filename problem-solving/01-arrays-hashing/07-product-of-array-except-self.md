# Product of Array Except Self

[Problem Link](https://leetcode.com/problems/product-of-array-except-self/)

## Approach

The product at index i equals the product of everything to the left of i times the product of everything to the right of i.

Build the answer in one pass using prefix and suffix products without division:

- First pass left to right: store at each index the product of all elements before it.
- Second pass right to left: multiply each position by the running product of all elements to its right.

A brute force solution recomputes products for every index in **O(n²)** time. The two-pass method runs in **O(n)** time and meets the follow-up constraint of **O(1)** extra space if the output array does not count toward space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1) extra space excluding the output array

## Code

```python
class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        result = [1] * n

        prefix = 1
        for i in range(n):
            result[i] = prefix
            prefix *= nums[i]

        suffix = 1
        for i in range(n - 1, -1, -1):
            result[i] *= suffix
            suffix *= nums[i]

        return result
```
