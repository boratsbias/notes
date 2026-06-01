# Word Ladder

[Problem Link](https://leetcode.com/problems/word-ladder/)

## Approach

Find the shortest transformation sequence from `beginWord` to `endWord` where each step changes exactly one letter and the result is in `wordList`.

Treat words as nodes and connect words that differ by one character. BFS from `beginWord` finds the minimum number of steps.

For faster neighbor lookup, iterate over all 26 letters at each position and check whether the mutated word is in a set built from `wordList`.

Bi-directional BFS can reduce the search space but the single-direction BFS pattern is enough for interviews.

**Time Complexity:** O(M² × N) where M is word length and N is list size  
**Space Complexity:** O(N)

## Code

```python
class Solution:
    def ladderLength(self, beginWord: str, endWord: str, wordList: List[str]) -> int:
        words = set(wordList)
        if endWord not in words:
            return 0

        queue = deque([(beginWord, 1)])

        while queue:
            word, steps = queue.popleft()
            if word == endWord:
                return steps

            for i in range(len(word)):
                for c in "abcdefghijklmnopqrstuvwxyz":
                    if c == word[i]:
                        continue
                    nxt = word[:i] + c + word[i + 1 :]
                    if nxt in words:
                        words.remove(nxt)
                        queue.append((nxt, steps + 1))

        return 0
```
