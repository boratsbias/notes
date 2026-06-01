# Longest Palindromic Substring

[Problem Link](https://leetcode.com/problems/longest-palindromic-substring/)

## Approach

Expand around every center. A palindrome is symmetric about its center, which can be a single character or between two characters.

For each index `i`, expand from `(i, i)` and `(i, i + 1)` while characters match. Track the longest palindrome found.

Dynamic programming on substrings `s[i..j]` works in **O(n²)** time and space but uses more memory.

**Time Complexity:** O(n²)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def longestPalindrome(self, s: str) -> str:
        start = end = 0

        def expand(left, right):
            nonlocal start, end
            while left >= 0 and right < len(s) and s[left] == s[right]:
                left -= 1
                right += 1
            if right - left - 1 > end - start:
                start = left + 1
                end = right - 1

        for i in range(len(s)):
            expand(i, i)
            expand(i, i + 1)

        return s[start : end + 1]
```
