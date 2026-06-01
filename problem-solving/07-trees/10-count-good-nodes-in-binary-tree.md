# Count Good Nodes in Binary Tree

[Problem Link](https://leetcode.com/problems/count-good-nodes-in-binary-tree/)

## Approach

A node is good if no ancestor has a strictly greater value.

DFS from the root, passing the maximum value seen on the path so far. Count the node if its value is at least that maximum, then update the maximum for children.

Checking all ancestors per node repeats comparisons. One max value per path is enough.

**Time Complexity:** O(n)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def goodNodes(self, root: TreeNode) -> int:
        self.count = 0

        def dfs(node, max_so_far):
            if not node:
                return
            if node.val >= max_so_far:
                self.count += 1
            max_so_far = max(max_so_far, node.val)
            dfs(node.left, max_so_far)
            dfs(node.right, max_so_far)

        dfs(root, root.val)
        return self.count
```
