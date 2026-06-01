# Binary Tree Maximum Path Sum

[Problem Link](https://leetcode.com/problems/binary-tree-maximum-path-sum/)

## Approach

A max path can bend at any node, using at most one branch from each side plus the node itself.

Post-order DFS returns the best downward path sum from a node to one of its children. At each node, update the global answer with `left_gain + node.val + right_gain` where negative gains are treated as 0.

Return to the parent only the better single-side gain plus the node value.

Checking every pair of nodes is **O(n²)**. One traversal is **O(n)**.

**Time Complexity:** O(n)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def maxPathSum(self, root: Optional[TreeNode]) -> int:
        self.best = float("-inf")

        def gain(node):
            if not node:
                return 0
            left = max(gain(node.left), 0)
            right = max(gain(node.right), 0)
            self.best = max(self.best, left + node.val + right)
            return node.val + max(left, right)

        gain(root)
        return self.best
```
