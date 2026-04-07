# Contains Duplicate

[Problem Link](https://leetcode.com/problems/contains-duplicate/)

## Approach

Use a set to keep track of numbers that have already appeared.

While iterating through the array:

- If the number is already in the set, a duplicate exists.
- Otherwise, add the number to the set.

A set is preferred over a list because membership checks in a set take **O(1)** on average, while checking in a list takes **O(n)**.

Another possible approach is sorting the array and checking adjacent elements. However, sorting takes **O(n log n)** time and may modify the input.

Using a set allows us to detect duplicates in a single pass through the array.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def hasDuplicate(self, nums: List[int]) -> bool:
        seen = set()

        for num in nums:
            if num in seen:
                return True
            seen.add(num)

        return False
```
