# Happy Number

[Problem Link](https://leetcode.com/problems/happy-number/)

## Approach

Repeatedly replace `n` with the sum of squares of its digits until you reach 1 (happy) or loop forever.

Detect cycles with a set of seen values, or Floyd's slow/fast pointer on the iteration function.

If a cycle appears before reaching 1, the number is not happy.

**Time Complexity:** O(log n) digits per step, constant cycle length for 32-bit integers  
**Space Complexity:** O(1) with Floyd's algorithm

## Code

```python
class Solution:
    def isHappy(self, n: int) -> bool:
        def next_num(x):
            total = 0
            while x:
                x, d = divmod(x, 10)
                total += d * d
            return total

        slow = fast = n
        while True:
            slow = next_num(slow)
            fast = next_num(next_num(fast))
            if slow == 1:
                return True
            if slow == fast:
                return slow == 1
```
