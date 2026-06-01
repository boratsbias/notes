# Implement Trie

[Problem Link](https://leetcode.com/problems/implement-trie-prefix-tree/)

## Approach

Each trie node stores children in a dictionary and a flag marking the end of a word.

- `insert`: walk character by character, creating nodes as needed, then mark the final node.
- `search`: walk the word and return true only if the end flag is set.
- `startsWith`: walk the prefix and return whether the path exists.

A hash map of all strings supports lookup but prefix queries scan many keys. A trie shares prefixes and keeps prefix checks efficient.

**Time Complexity:** O(m) per operation where m is word or prefix length  
**Space Complexity:** O(total characters stored)

## Code

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.end = False


class Trie:

    def __init__(self):
        self.root = TrieNode()

    def insert(self, word: str) -> None:
        node = self.root
        for ch in word:
            if ch not in node.children:
                node.children[ch] = TrieNode()
            node = node.children[ch]
        node.end = True

    def search(self, word: str) -> bool:
        node = self._traverse(word)
        return node is not None and node.end

    def startsWith(self, prefix: str) -> bool:
        return self._traverse(prefix) is not None

    def _traverse(self, text):
        node = self.root
        for ch in text:
            if ch not in node.children:
                return None
            node = node.children[ch]
        return node
```
