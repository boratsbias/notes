# Construct Binary Tree from Preorder and Inorder Traversal

[Problem Link](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)

## Approach

The first preorder value is the root. Find that value in inorder: everything left is the left subtree, everything right is the right subtree.

Use a hash map from value to inorder index for **O(1)** lookup. Recursively build left and right partitions using pointer ranges.

Brute force index searches per node cost **O(n²)**. The map reduces total work to **O(n)**.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        index = {val: i for i, val in enumerate(inorder)}
        self.pre_idx = 0

        def dfs(left, right):
            if left > right:
                return None
            root_val = preorder[self.pre_idx]
            self.pre_idx += 1
            root = TreeNode(root_val)
            mid = index[root_val]
            root.left = dfs(left, mid - 1)
            root.right = dfs(mid + 1, right)
            return root

        return dfs(0, len(inorder) - 1)
```
