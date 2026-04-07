# Contains Duplicate

[Problem Link](https://leetcode.com/problems/contains-duplicate/)

## Explanation

Use a set to track numbers that have already appeared.  
If a number appears again, a duplicate exists.  
  
A set is used instead of a list because checking membership in a set is O(1) on average, while checking in a list takes O(n).  
  
Another possible approach is sorting the array and checking adjacent elements, but sorting takes O(n log n) time and may modify the input.  
  
Using a set allows us to detect duplicates in a single pass through the array.  
  
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
