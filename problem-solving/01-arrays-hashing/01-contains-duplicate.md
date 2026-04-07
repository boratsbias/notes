# Contains Duplicate

**Problem:** [Link](https://leetcode.com/problems/contains-duplicate/)

## Idea
Use a set to track numbers seen so far.  
If a number already exists in the set, a duplicate is found.

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

## Complexity

**Time:** O(n)  
**Space:** O(n)