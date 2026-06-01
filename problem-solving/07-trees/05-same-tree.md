# Same Tree

[Problem Link](https://leetcode.com/problems/same-tree/)

## Approach

Two trees are the same if their roots match and their left and right subtrees are the same.

Recursively compare structure and values at each node.

An iterative parallel traversal with two stacks works too. Recursion mirrors the definition directly.

**Time Complexity:** O(n)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
        if not p and not q:
            return True
        if not p or not q or p.val != q.val:
            return False
        return self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```
