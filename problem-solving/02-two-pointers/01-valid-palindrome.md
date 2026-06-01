# Valid Palindrome

[Problem Link](https://leetcode.com/problems/valid-palindrome/)

## Approach

Use two pointers at the start and end of the string.

Move both pointers toward the center:

- Skip any character that is not alphanumeric.
- Compare the lowercase versions of the characters at both pointers.
- If they differ, the string is not a palindrome.

When the pointers meet or cross, every valid pair matched and the string is a palindrome.

Filtering characters into a new string first uses extra space. The two-pointer method runs in one pass with **O(1)** extra space.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def isPalindrome(self, s: str) -> bool:
        left, right = 0, len(s) - 1

        while left < right:
            while left < right and not s[left].isalnum():
                left += 1
            while left < right and not s[right].isalnum():
                right -= 1

            if s[left].lower() != s[right].lower():
                return False

            left += 1
            right -= 1

        return True
```
