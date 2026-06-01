# Invert Binary Tree

[Problem Link](https://leetcode.com/problems/invert-binary-tree/)

## Approach

Recursively swap the left and right children of every node, then invert both subtrees.

Base case: a null node needs no work.

An iterative BFS or DFS with a queue or stack also works. Recursion is the most direct for this problem.

**Time Complexity:** O(n)  
**Space Complexity:** O(h) recursion stack where h is tree height

## Code

```python
class Solution:
    def invertTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        if not root:
            return None

        root.left, root.right = root.right, root.left
        self.invertTree(root.left)
        self.invertTree(root.right)
        return root
```
