# Decode Ways

[Problem Link](https://leetcode.com/problems/decode-ways/)

## Approach

Count ways to decode a digit string where `'1'..'26'` map to `'A'..'Z'`.

Let `dp[i]` be the number of ways to decode the prefix ending at index `i`:

- If the single digit `s[i]` is valid (`'1'..'9'`), add `dp[i - 1]`.
- If the two-digit substring `s[i-1:i+1]` is between 10 and 26, add `dp[i - 2]`.

Base: `dp[0] = 1` (empty prefix). Handle leading `'0'` as zero ways.

**Time Complexity:** O(n)  
**Space Complexity:** O(1) with rolling variables

## Code

```python
class Solution:
    def numDecodings(self, s: str) -> int:
        if not s or s[0] == "0":
            return 0

        prev2, prev1 = 1, 1

        for i in range(1, len(s)):
            curr = 0
            if s[i] != "0":
                curr += prev1
            two = int(s[i - 1 : i + 1])
            if 10 <= two <= 26:
                curr += prev2
            prev2, prev1 = prev1, curr

        return prev1
```
