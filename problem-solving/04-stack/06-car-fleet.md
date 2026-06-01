# Car Fleet

[Problem Link](https://leetcode.com/problems/car-fleet/)

## Approach

Sort cars by starting position. Process from the target backward so each car only interacts with the car directly ahead.

For each car, compute time to reach the target: `(target - position) / speed`.

If a car needs more time than the fleet in front, it forms a new fleet. Otherwise it joins the existing fleet and adopts the slower arrival time.

Simulating every pairwise interaction is unnecessary. Sorting plus a single backward pass captures fleet merging.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(n) for sorting, O(1) extra otherwise

## Code

```python
class Solution:
    def carFleet(self, target: int, position: List[int], speed: List[int]) -> int:
        cars = sorted(zip(position, speed), reverse=True)
        fleets = 0
        current_time = 0

        for pos, spd in cars:
            time = (target - pos) / spd
            if time > current_time:
                fleets += 1
                current_time = time

        return fleets
```
