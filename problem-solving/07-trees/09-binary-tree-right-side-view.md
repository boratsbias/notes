# Binary Tree Right Side View

[Problem Link](https://leetcode.com/problems/binary-tree-right-side-view/)

## Approach

Return the rightmost node at each level.

Use BFS and take the last node dequeued in each level. Alternatively, DFS visiting right before left records the first node seen at each depth.

Both approaches are **O(n)**. BFS matches the level-order definition directly.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []

        result = []
        queue = deque([root])

        while queue:
            level_size = len(queue)
            for i in range(level_size):
                node = queue.popleft()
                if i == level_size - 1:
                    result.append(node.val)
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)

        return result
```
