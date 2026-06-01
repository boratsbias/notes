# Maximum Product Subarray

[Problem Link](https://leetcode.com/problems/maximum-product-subarray/)

## Approach

A negative number can flip a small product into a large one, so track both the maximum and minimum product ending at each index.

For each `nums[i]`:

- `curr_max = max(nums[i], nums[i] * prev_max, nums[i] * prev_min)`
- `curr_min = min(nums[i], nums[i] * prev_max, nums[i] * prev_min)`

Update the global answer with `curr_max`. Kadane's variant for products.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        best = nums[0]
        curr_max = curr_min = 1

        for num in nums:
            if num < 0:
                curr_max, curr_min = curr_min, curr_max
            curr_max = max(num, curr_max * num)
            curr_min = min(num, curr_min * num)
            best = max(best, curr_max)

        return best
```
