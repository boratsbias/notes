# Design Add and Search Words Data Structure

[Problem Link](https://leetcode.com/problems/design-add-and-search-words-data-structure/)

## Approach

Store words in a trie. Exact prefix walks are the same as a normal trie.

For search with `.` wildcards, DFS from the current node: try all children when the character is `.`, otherwise follow the matching child.

A flat list of words forces **O(n * m)** scan per query. The trie prunes mismatched prefixes early.

**Time Complexity:** O(m) addWord, O(26^m) worst case for search with wildcards  
**Space Complexity:** O(total characters stored)

## Code

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.end = False


class WordDictionary:

    def __init__(self):
        self.root = TrieNode()

    def addWord(self, word: str) -> None:
        node = self.root
        for ch in word:
            if ch not in node.children:
                node.children[ch] = TrieNode()
            node = node.children[ch]
        node.end = True

    def search(self, word: str) -> bool:
        def dfs(node, idx):
            if idx == len(word):
                return node.end
            ch = word[idx]
            if ch == ".":
                return any(dfs(child, idx + 1) for child in node.children.values())
            if ch not in node.children:
                return False
            return dfs(node.children[ch], idx + 1)

        return dfs(self.root, 0)
```
