# Binary Tree Level Order Traversal

[Problem Link](https://leetcode.com/problems/binary-tree-level-order-traversal/)

## Approach

Use BFS with a queue.

Process nodes level by level: record the queue size at the start of each iteration and dequeue exactly that many nodes, enqueueing their children.

DFS with depth tracking also works but BFS naturally groups nodes by level.

**Time Complexity:** O(n)  
**Space Complexity:** O(n) for the queue

## Code

```python
class Solution:
    def levelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:
        if not root:
            return []

        result = []
        queue = deque([root])

        while queue:
            level = []
            for _ in range(len(queue)):
                node = queue.popleft()
                level.append(node.val)
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
            result.append(level)

        return result
```
