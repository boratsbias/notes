# Minimum Window Substring

[Problem Link](https://leetcode.com/problems/minimum-window-substring/)

## Approach

Use a variable-size sliding window over `s` with two frequency maps: one for required characters in `t` and one for the current window.

Expand the right pointer until the window contains all characters from `t` with sufficient counts. Then shrink from the left while the window remains valid, recording the smallest valid substring.

Track how many required character types still need to be satisfied with a `have` counter compared to `need`.

Checking every substring is **O(n²)** or worse. The two-pointer window visits each index a constant number of times.

**Time Complexity:** O(n + m) where n is len(s) and m is len(t)  
**Space Complexity:** O(1) for the fixed character maps

## Code

```python
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        if not t or not s:
            return ""

        need = {}
        for ch in t:
            need[ch] = need.get(ch, 0) + 1

        have = 0
        required = len(need)
        window = {}
        left = 0
        best = (float("inf"), 0, 0)

        for right, ch in enumerate(s):
            window[ch] = window.get(ch, 0) + 1
            if ch in need and window[ch] == need[ch]:
                have += 1

            while have == required:
                if right - left + 1 < best[0]:
                    best = (right - left + 1, left, right)
                left_ch = s[left]
                window[left_ch] -= 1
                if left_ch in need and window[left_ch] < need[left_ch]:
                    have -= 1
                left += 1

        return "" if best[0] == float("inf") else s[best[1]: best[2] + 1]
```
