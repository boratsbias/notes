# Longest Substring Without Repeating Characters

[Problem Link](https://leetcode.com/problems/longest-substring-without-repeating-characters/)

## Approach

Use a sliding window with a hash map that stores the most recent index of each character.

Expand the window by moving the right pointer. When a duplicate appears inside the window, move the left pointer past the previous occurrence of that character.

Track the maximum window size seen. Updating the left pointer with `max(left, last_index + 1)` handles cases where the duplicate lies outside the current window.

Checking every substring takes **O(n²)** time. The sliding window visits each character at most twice, giving **O(n)** time.

**Time Complexity:** O(n)  
**Space Complexity:** O(min(n, alphabet size))

## Code

```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        last_seen = {}
        left = 0
        best = 0

        for right, char in enumerate(s):
            if char in last_seen and last_seen[char] >= left:
                left = last_seen[char] + 1
            last_seen[char] = right
            best = max(best, right - left + 1)

        return best
```
