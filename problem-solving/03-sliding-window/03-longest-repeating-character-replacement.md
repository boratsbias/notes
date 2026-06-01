# Longest Repeating Character Replacement

[Problem Link](https://leetcode.com/problems/longest-repeating-character-replacement/)

## Approach

Maintain a sliding window and track the count of each character inside it.

The window is valid when:

`window_length - max_frequency <= k`

If it becomes invalid, shrink from the left until the condition holds again. The answer is the largest valid window length.

We do not need the exact max frequency when shrinking because we only care about increasing the best answer. When the window grows again, max frequency can only stay the same or increase.

Trying every substring is **O(n²)**. The sliding window runs in **O(n)** time with a fixed alphabet size.

**Time Complexity:** O(n)  
**Space Complexity:** O(1) for the 26-letter count array

## Code

```python
class Solution:
    def characterReplacement(self, s: str, k: int) -> int:
        count = [0] * 26
        left = 0
        max_freq = 0
        best = 0

        for right, char in enumerate(s):
            idx = ord(char) - ord("A")
            count[idx] += 1
            max_freq = max(max_freq, count[idx])

            while (right - left + 1) - max_freq > k:
                count[ord(s[left]) - ord("A")] -= 1
                left += 1

            best = max(best, right - left + 1)

        return best
```
