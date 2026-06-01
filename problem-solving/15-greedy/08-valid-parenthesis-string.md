# Valid Parenthesis String

[Problem Link](https://leetcode.com/problems/valid-parenthesis-string/)

## Approach

A `*` can be `(`, `)`, or empty. Track the range of possible open-parenthesis counts after each character.

- `(` increases both min and max open counts
- `)` decreases both
- `*` can decrease min (used as `)`) or increase max (used as `(`)

Keep `low >= 0` by clamping. Valid if `low == 0` at the end.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def checkValidString(self, s: str) -> bool:
        low = high = 0

        for c in s:
            if c == "(":
                low += 1
                high += 1
            elif c == ")":
                low = max(0, low - 1)
                high -= 1
            else:
                low = max(0, low - 1)
                high += 1

            if high < 0:
                return False

        return low == 0
```
