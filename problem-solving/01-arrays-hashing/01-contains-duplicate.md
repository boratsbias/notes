# Contains Duplicate

[Problem Link](https://leetcode.com/problems/contains-duplicate/)

## Explanation

Use a set to track numbers that have already appeared.  
If a number is seen again, a duplicate exists.  
  
Time: O(n)  
Space: O(n)

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
