# Diameter of Binary Tree

[Problem Link](https://leetcode.com/problems/diameter-of-binary-tree/)

## Approach

The diameter is the longest path between any two nodes, measured in edges.

During a post-order height computation, the path through the current node is `left_height + right_height`. Track the maximum of this value across all nodes.

Returning height from the helper keeps each node processed once.

Checking every pair of nodes is **O(n²)**. One DFS with height tracking is **O(n)**.

**Time Complexity:** O(n)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        self.best = 0

        def height(node):
            if not node:
                return 0
            left = height(node.left)
            right = height(node.right)
            self.best = max(self.best, left + right)
            return 1 + max(left, right)

        height(root)
        return self.best
```
