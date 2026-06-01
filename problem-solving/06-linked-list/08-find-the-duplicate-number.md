# Find the Duplicate Number

[Problem Link](https://leetcode.com/problems/find-the-duplicate-number/)

## Approach

Treat the array as a linked list where index `i` points to `nums[i]`. A duplicate means two indices point to the same next node, which creates a cycle.

Use Floyd's algorithm:

1. Find the intersection inside the cycle with slow and fast pointers.
2. Reset one pointer to the start and advance both one step at a time until they meet at the cycle entrance, which is the duplicate value.

Sorting or using a hash set modifies space or violates constraints. Cycle detection uses **O(1)** extra space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def findDuplicate(self, nums: List[int]) -> int:
        slow = fast = nums[0]

        while True:
            slow = nums[slow]
            fast = nums[nums[fast]]
            if slow == fast:
                break

        slow = nums[0]
        while slow != fast:
            slow = nums[slow]
            fast = nums[fast]

        return slow
```
