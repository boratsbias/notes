# Word Break

[Problem Link](https://leetcode.com/problems/word-break/)

## Approach

Determine whether `s` can be segmented into dictionary words.

Let `dp[i]` mean the prefix `s[0:i]` can be segmented. Set `dp[0] = True`.

For each end index `i`, try every start `j < i`. If `dp[j]` is true and `s[j:i]` is in the word set, then `dp[i] = True`.

BFS over reachable indices is an alternative graph view of the same idea.

**Time Complexity:** O(n² × m) where m is average word length for hashing  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def wordBreak(self, s: str, wordDict: List[str]) -> bool:
        words = set(wordDict)
        dp = [False] * (len(s) + 1)
        dp[0] = True

        for i in range(1, len(s) + 1):
            for j in range(i):
                if dp[j] and s[j:i] in words:
                    dp[i] = True
                    break

        return dp[len(s)]
```
