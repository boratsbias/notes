# Serialize and Deserialize Binary Tree

[Problem Link](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/)

## Approach

Use preorder DFS with a sentinel for null nodes.

Serialization writes values in preorder, using `"null"` for missing children. Deserialization reads tokens left to right and rebuilds the tree recursively.

Level-order serialization also works. Preorder with null markers makes recursive reconstruction straightforward.

**Time Complexity:** O(n) serialize and deserialize  
**Space Complexity:** O(n)

## Code

```python
class Codec:

    def serialize(self, root: Optional[TreeNode]) -> str:
        tokens = []

        def dfs(node):
            if not node:
                tokens.append("null")
                return
            tokens.append(str(node.val))
            dfs(node.left)
            dfs(node.right)

        dfs(root)
        return ",".join(tokens)

    def deserialize(self, data: str) -> Optional[TreeNode]:
        tokens = deque(data.split(","))

        def dfs():
            val = tokens.popleft()
            if val == "null":
                return None
            node = TreeNode(int(val))
            node.left = dfs()
            node.right = dfs()
            return node

        return dfs()
```
