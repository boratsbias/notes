# Lowest Common Ancestor of a Binary Search Tree

[Problem Link](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-search-tree/)

## Approach

Use BST ordering. Start at the root:

- If both values are smaller, go left.
- If both values are larger, go right.
- Otherwise the current node is the split point and the LCA.

Searching both subtrees like a normal binary tree ignores the BST property and costs more time.

**Time Complexity:** O(h)  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def lowestCommonAncestor(self, root: TreeNode, p: TreeNode, q: TreeNode) -> TreeNode:
        while root:
            if p.val < root.val and q.val < root.val:
                root = root.left
            elif p.val > root.val and q.val > root.val:
                root = root.right
            else:
                return root
```
