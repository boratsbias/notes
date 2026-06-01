# Permutation in String

[Problem Link](https://leetcode.com/problems/permutation-in-string/)

## Approach

A permutation of `s1` is any substring of `s2` with the same character counts.

Use a fixed-size sliding window of length `len(s1)` over `s2`. Compare frequency arrays for `s1` and the current window.

When the counts match, a permutation exists. Slide the window one step at a time by adding the new right character and removing the leftmost character.

Sorting all substrings of `s2` costs **O(n² log n)** or worse. The fixed window with count arrays runs in **O(n)** time.

**Time Complexity:** O(n)  
**Space Complexity:** O(1) for the 26-letter count arrays

## Code

```python
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        if len(s1) > len(s2):
            return False

        need = [0] * 26
        window = [0] * 26

        for ch in s1:
            need[ord(ch) - ord("a")] += 1

        k = len(s1)
        for i, ch in enumerate(s2):
            window[ord(ch) - ord("a")] += 1
            if i >= k:
                window[ord(s2[i - k]) - ord("a")] -= 1
            if i >= k - 1 and window == need:
                return True

        return False
```
