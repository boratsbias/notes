# Graph Valid Tree

[Problem Link](https://leetcode.com/problems/graph-valid-tree/)

## Approach

A valid tree on `n` nodes has exactly `n - 1` edges and no cycles.

Quick check: if `len(edges) != n - 1`, return false.

Otherwise, build the graph and run BFS or DFS from node 0. The graph is a tree if every node is reachable and no cycle appears during traversal.

Union-Find can also verify one connected component and no redundant edge.

**Time Complexity:** O(V + E)  
**Space Complexity:** O(V + E)

## Code

```python
class Solution:
    def validTree(self, n: int, edges: List[List[int]]) -> bool:
        if len(edges) != n - 1:
            return False

        graph = [[] for _ in range(n)]
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

        visited = {0}
        queue = deque([0])

        while queue:
            node = queue.popleft()
            for nei in graph[node]:
                if nei not in visited:
                    visited.add(nei)
                    queue.append(nei)

        return len(visited) == n
```
