# Encode and Decode Strings

[Problem Link](https://leetcode.com/problems/encode-and-decode-strings/)

## Approach

When multiple strings are joined with a simple delimiter, a string that contains the delimiter can break decoding. Encode each string with its length first so the decoder knows exactly how many characters to read next.

Use a format like `length#string` for every entry. While decoding:

- Read digits until `#` to get the length.
- Read exactly that many characters as one original string.
- Repeat until the encoded buffer is exhausted.

This avoids ambiguity regardless of what characters appear inside the strings.

**Time Complexity:** O(n) for encode and decode combined, where n is the total number of characters across all strings  
**Space Complexity:** O(n) for the encoded output (excluding output lists required by the problem)

## Code

```python
class Solution:
    def encode(self, strs: List[str]) -> str:
        encoded = ""
        for s in strs:
            encoded += str(len(s)) + "#" + s
        return encoded

    def decode(self, s: str) -> List[str]:
        result = []
        i = 0

        while i < len(s):
            j = i
            while s[j] != "#":
                j += 1
            length = int(s[i:j])
            i = j + 1
            result.append(s[i:i + length])
            i += length

        return result
```
