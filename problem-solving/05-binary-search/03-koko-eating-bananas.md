# Koko Eating Bananas

[Problem Link](https://leetcode.com/problems/koko-eating-bananas/)

## Approach

Binary search on eating speed `k` from 1 to `max(piles)`.

For a candidate speed, compute total hours needed to finish all piles. If Koko can finish within `h` hours, try a slower speed. Otherwise try a faster speed.

The minimum valid speed is the answer.

Trying every speed from 1 to max pile size is **O(n * max(piles))**. Binary search on the answer space runs in **O(n log max(piles))** time.

**Time Complexity:** O(n log max(piles))  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def minEatingSpeed(self, piles: List[int], h: int) -> int:
        def hours_needed(speed):
            return sum((pile + speed - 1) // speed for pile in piles)

        left, right = 1, max(piles)
        while left < right:
            mid = (left + right) // 2
            if hours_needed(mid) <= h:
                right = mid
            else:
                left = mid + 1

        return left
```
