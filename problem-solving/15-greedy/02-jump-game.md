# Jump Game

[Problem Link](https://leetcode.com/problems/jump-game/)

## Approach

Track the farthest index reachable from the start.

Scan left to right. If the current index is beyond `goal`, you cannot reach it. Otherwise update `goal = max(goal, i + nums[i])`.

Return true if `goal` reaches or passes the last index.

Trying every jump path is exponential.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def canJump(self, nums: List[int]) -> bool:
        goal = 0

        for i in range(len(nums)):
            if i > goal:
                return False
            goal = max(goal, i + nums[i])

        return True
```
