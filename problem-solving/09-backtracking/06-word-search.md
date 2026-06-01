# Word Search

[Problem Link](https://leetcode.com/problems/word-search/)

## Approach

DFS from every cell with backtracking.

At each step, check bounds, character match, and whether the cell is already visited. Mark the cell visited, explore four directions, then undo the mark.

Prune immediately when the current character does not match.

Building a trie helps when searching many words on one board. For a single word, plain DFS is enough.

**Time Complexity:** O(m * n * 4^L) where L is word length  
**Space Complexity:** O(L) recursion depth

## Code

```python
class Solution:
    def exist(self, board: List[List[str]], word: str) -> bool:
        rows, cols = len(board), len(board[0])

        def dfs(r, c, idx):
            if idx == len(word):
                return True
            if r < 0 or c < 0 or r >= rows or c >= cols:
                return False
            if board[r][c] != word[idx]:
                return False

            temp = board[r][c]
            board[r][c] = "#"
            found = (
                dfs(r + 1, c, idx + 1)
                or dfs(r - 1, c, idx + 1)
                or dfs(r, c + 1, idx + 1)
                or dfs(r, c - 1, idx + 1)
            )
            board[r][c] = temp
            return found

        for r in range(rows):
            for c in range(cols):
                if dfs(r, c, 0):
                    return True
        return False
```
