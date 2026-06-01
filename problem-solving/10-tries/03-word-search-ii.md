# Word Search II

[Problem Link](https://leetcode.com/problems/word-search-ii/)

## Approach

Build a trie from all words. DFS on the board while walking trie nodes.

At each cell, move to the child for that character. When a trie node marks the end of a word, add the word to the result and optionally remove it from the trie to avoid duplicates.

Prune when the current character has no trie child.

Running Word Search once per word repeats board work. One trie-guided DFS shares prefix exploration.

**Time Complexity:** O(m * n * 4^L + total word length)  
**Space Complexity:** O(total word length)

## Code

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.word = None


class Solution:
    def findWords(self, board: List[List[str]], words: List[str]) -> List[str]:
        root = TrieNode()
        for word in words:
            node = root
            for ch in word:
                node = node.children.setdefault(ch, TrieNode())
            node.word = word

        rows, cols = len(board), len(board[0])
        result = []

        def dfs(r, c, node):
            ch = board[r][c]
            next_node = node.children.get(ch)
            if not next_node:
                return

            if next_node.word:
                result.append(next_node.word)
                next_node.word = None

            board[r][c] = "#"
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < rows and 0 <= nc < cols and board[nr][nc] != "#":
                    dfs(nr, nc, next_node)
            board[r][c] = ch

            if not next_node.children:
                node.children.pop(ch, None)

        for r in range(rows):
            for c in range(cols):
                dfs(r, c, root)

        return result
```
