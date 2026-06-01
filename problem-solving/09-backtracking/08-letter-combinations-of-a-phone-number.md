# Letter Combinations of a Phone Number

[Problem Link](https://leetcode.com/problems/letter-combinations-of-a-phone-number/)

## Approach

Map each digit to its letters and backtrack one digit at a time.

At each depth, append every possible letter for the current digit and recurse to the next digit. When all digits are processed, save the built string.

Iterative cartesian product also works. Backtracking matches the standard phone keypad template.

**Time Complexity:** O(4^n * n) where n is digit count  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def letterCombinations(self, digits: str) -> List[str]:
        if not digits:
            return []

        phone = {
            "2": "abc",
            "3": "def",
            "4": "ghi",
            "5": "jkl",
            "6": "mno",
            "7": "pqrs",
            "8": "tuv",
            "9": "wxyz",
        }
        result = []

        def backtrack(idx, path):
            if idx == len(digits):
                result.append("".join(path))
                return
            for letter in phone[digits[idx]]:
                path.append(letter)
                backtrack(idx + 1, path)
                path.pop()

        backtrack(0, [])
        return result
```
