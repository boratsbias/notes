# Balanced Binary Tree

[Problem Link](https://leetcode.com/problems/balanced-binary-tree/)

## Approach

A tree is balanced if every node's left and right subtree heights differ by at most 1.

Use a post-order helper that returns height, but return -1 as a sentinel if any subtree is unbalanced.

If either child is unbalanced or height difference exceeds 1, bubble up failure immediately.

Checking balance separately at every node repeats work. The sentinel height avoids recomputation.

**Time Complexity:** O(n)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def isBalanced(self, root: Optional[TreeNode]) -> bool:
        def height(node):
            if not node:
                return 0
            left = height(node.left)
            if left == -1:
                return -1
            right = height(node.right)
            if right == -1:
                return -1
            if abs(left - right) > 1:
                return -1
            return 1 + max(left, right)

        return height(root) != -1
```
