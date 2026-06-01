# Subtree of Another Tree

[Problem Link](https://leetcode.com/problems/subtree-of-another-tree/)

## Approach

At each node in `root`, check whether the subtree starting there matches `subRoot` using the same-tree logic.

Traverse the main tree. Whenever values align at the root, run a full comparison of both subtrees.

Serializing both trees and checking substring matching works but adds string overhead. Direct comparison is simpler.

**Time Complexity:** O(n * m) in the worst case  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def isSubtree(self, root: Optional[TreeNode], subRoot: Optional[TreeNode]) -> bool:
        if not root:
            return False
        if self._same(root, subRoot):
            return True
        return self.isSubtree(root.left, subRoot) or self.isSubtree(root.right, subRoot)

    def _same(self, p, q):
        if not p and not q:
            return True
        if not p or not q or p.val != q.val:
            return False
        return self._same(p.left, q.left) and self._same(p.right, q.right)
```
