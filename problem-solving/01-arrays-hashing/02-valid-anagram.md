# Valid Anagram

[Problem Link](https://leetcode.com/problems/valid-anagram/)

## Approach

Use a frequency counter to keep track of how many times each character appears.

First check whether the two strings have the same length.  
If their lengths differ, they cannot be anagrams.

Then iterate through the first string and store the frequency of each character in a dictionary.

Next iterate through the second string:

- If a character is not present in the dictionary, the strings are not anagrams.
- Otherwise decrease the frequency of that character.

If any count becomes negative, the strings are not anagrams.  
If all characters are processed successfully, the strings are anagrams.

Another possible approach is sorting both strings and comparing them. However, sorting requires **O(n log n)** time.

Using a frequency map allows us to verify the character counts in a single pass through the strings.

**Time Complexity:** O(n)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        if len(s) != len(t):
            return False

        count = {}

        for char in s:
            count[char] = count.get(char, 0) + 1

        for char in t:
            if char not in count:
                return False
            count[char] -= 1

            if count[char] < 0:
                return False

        return True
```
