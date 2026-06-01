# Palindrome Partitioning

[Problem Link](https://leetcode.com/problems/palindrome-partitioning/)

## Approach

Backtrack over cut positions in the string.

From each start index, try every end index such that the substring is a palindrome. If valid, add it to the path and recurse on the remainder.

When the start index reaches the end of the string, save the partition.

Checking palindromes with two pointers per candidate is simple. Precomputing a palindrome table speeds repeated checks on large inputs.

**Time Complexity:** O(n * 2^n) worst case  
**Space Complexity:** O(n) recursion depth excluding output

## Code

```python
class Solution:
    def partition(self, s: str) -> List[List[str]]:
        result = []

        def is_palindrome(text):
            return text == text[::-1]

        def backtrack(start, path):
            if start == len(s):
                result.append(path[:])
                return
            for end in range(start + 1, len(s) + 1):
                piece = s[start:end]
                if is_palindrome(piece):
                    path.append(piece)
                    backtrack(end, path)
                    path.pop()

        backtrack(0, [])
        return result
```
