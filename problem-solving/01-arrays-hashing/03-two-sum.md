# Two Sum

[Problem Link](https://leetcode.com/problems/two-sum/)

## Approach

Use a hash map to store each number and its index as you iterate through the array.

For each number, compute the complement by subtracting it from the target.

- If the complement is already in the map, the two indices that form the answer have been found.
- Otherwise, store the current number and its index in the map.

A brute force approach checks every pair of elements, which takes **O(n²)** time. Using a hash map reduces lookups to **O(1)** on average, so the answer can be found in a single pass.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        seen = {}

        for i, num in enumerate(nums):
            complement = target - num

            if complement in seen:
                return [seen[complement], i]

            seen[num] = i
```
