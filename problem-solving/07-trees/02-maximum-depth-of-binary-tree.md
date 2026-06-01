# Maximum Depth of Binary Tree

[Problem Link](https://leetcode.com/problems/maximum-depth-of-binary-tree/)

## Approach

The depth of a tree is 1 plus the maximum depth of its left and right subtrees.

Recursively compute depth for each child and return the larger result plus one.

An iterative level-order traversal counting layers also works but needs a queue. Post-order recursion is concise.

**Time Complexity:** O(n)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def maxDepth(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0
        return 1 + max(self.maxDepth(root.left), self.maxDepth(root.right))
```
