# Gas Station

[Problem Link](https://leetcode.com/problems/gas-station/)

## Approach

A full circuit is possible only if total gas is at least total cost.

If the sum is sufficient, there is exactly one valid starting index when scanning greedily.

Track current tank while moving station to station. If tank drops below 0, reset the start to the next station and tank to 0.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def canCompleteCircuit(self, gas: List[int], cost: List[int]) -> int:
        if sum(gas) < sum(cost):
            return -1

        start = 0
        tank = 0

        for i in range(len(gas)):
            tank += gas[i] - cost[i]
            if tank < 0:
                start = i + 1
                tank = 0

        return start
```
