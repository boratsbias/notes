# Number of Connected Components in an Undirected Graph

[Problem Link](https://leetcode.com/problems/number-of-connected-components-in-an-undirected-graph/)

## Approach

Count how many separate connected pieces exist in an undirected graph.

Union-Find: start with `n` components and decrement the count each time a successful union merges two different components.

DFS/BFS from each unvisited node also works: each new search increments the component count.

**Time Complexity:** O(V + E)  
**Space Complexity:** O(V)

## Code

```python
class Solution:
    def countComponents(self, n: int, edges: List[List[int]]) -> int:
        parent = list(range(n))
        components = n

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        for u, v in edges:
            pu, pv = find(u), find(v)
            if pu != pv:
                parent[pv] = pu
                components -= 1

        return components
```
