# Palindromic Substrings

[Problem Link](https://leetcode.com/problems/palindromic-substrings/)

## Approach

Count all palindromic substrings by expanding around each possible center.

For index `i`, expand from `(i, i)` for odd-length palindromes and `(i, i + 1)` for even-length palindromes. Each successful expansion adds one palindrome to the count.

Checking every substring directly takes **O(n³)** time.

**Time Complexity:** O(n²)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def countSubstrings(self, s: str) -> int:
        count = 0

        def expand(left, right):
            nonlocal count
            while left >= 0 and right < len(s) and s[left] == s[right]:
                count += 1
                left -= 1
                right += 1

        for i in range(len(s)):
            expand(i, i)
            expand(i, i + 1)

        return count
```
