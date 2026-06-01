# Clone Graph

[Problem Link](https://leetcode.com/problems/clone-graph/)

## Approach

Build a deep copy of the graph while avoiding infinite loops from cycles.

Use a hash map from original nodes to their clones:

- If a node is already cloned, return the existing clone from the map.
- Otherwise, create a new node with the same value, store it in the map, then clone all neighbors recursively (or with BFS).

BFS works the same way: enqueue the original node, clone it if needed, and attach cloned neighbors as you visit them.

**Time Complexity:** O(V + E)  
**Space Complexity:** O(V) for the map and recursion or queue

## Code

```python
class Solution:
    def cloneGraph(self, node: Optional["Node"]) -> Optional["Node"]:
        if not node:
            return None

        clones = {}

        def dfs(original):
            if original in clones:
                return clones[original]
            copy = Node(original.val)
            clones[original] = copy
            for neighbor in original.neighbors:
                copy.neighbors.append(dfs(neighbor))
            return copy

        return dfs(node)
```
