# Maximum Subarray

[Problem Link](https://leetcode.com/problems/maximum-subarray/)

## Approach

Kadane's algorithm tracks the best sum ending at the current index.

For each number, either extend the current subarray or start fresh at this number:

- `curr = max(num, curr + num)`
- Update global best with `curr`

Divide and conquer also works in **O(n log n)** but Kadane's is simpler and linear.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        best = nums[0]
        curr = 0

        for num in nums:
            curr = max(num, curr + num)
            best = max(best, curr)

        return best
```
