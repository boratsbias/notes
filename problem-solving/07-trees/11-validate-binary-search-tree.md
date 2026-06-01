# Validate Binary Search Tree

[Problem Link](https://leetcode.com/problems/validate-binary-search-tree/)

## Approach

Each node must fall within a valid range `(min_val, max_val)` inherited from ancestors.

At the root the range is unbounded. For the left child, the upper bound becomes the parent value. For the right child, the lower bound becomes the parent value.

Checking only immediate children misses cases where a deeper node violates BST order.

**Time Complexity:** O(n)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        def validate(node, low, high):
            if not node:
                return True
            if not (low < node.val < high):
                return False
            return validate(node.left, low, node.val) and validate(node.right, node.val, high)

        return validate(root, float("-inf"), float("inf"))
```
