# Jump Game II

[Problem Link](https://leetcode.com/problems/jump-game-ii/)

## Approach

Find the minimum jumps to reach the last index when each position guarantees reachability.

Use BFS-like greedy layers: within the current jump range, track the farthest index reachable with one more jump.

When `i` reaches the end of the current range, increment jumps and extend the range to `farthest`.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def jump(self, nums: List[int]) -> int:
        jumps = 0
        end = 0
        farthest = 0

        for i in range(len(nums) - 1):
            farthest = max(farthest, i + nums[i])
            if i == end:
                jumps += 1
                end = farthest

        return jumps
```
