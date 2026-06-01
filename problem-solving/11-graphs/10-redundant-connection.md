# Redundant Connection

[Problem Link](https://leetcode.com/problems/redundant-connection/)

## Approach

The graph is a tree plus one extra edge that creates a cycle. Find the last edge in the input that closes a cycle.

Use Union-Find: for each edge, if both endpoints already belong to the same component, that edge is redundant. Otherwise, union them.

Process edges in order and return the first redundant one found while scanning to the end (the last such edge in the problem's ordering).

**Time Complexity:** O(n × α(n)), nearly O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def findRedundantConnection(self, edges: List[List[int]]) -> List[int]:
        parent = list(range(len(edges) + 1))
        rank = [0] * (len(edges) + 1)

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        def union(a, b):
            ra, rb = find(a), find(b)
            if ra == rb:
                return False
            if rank[ra] < rank[rb]:
                ra, rb = rb, ra
            parent[rb] = ra
            if rank[ra] == rank[rb]:
                rank[ra] += 1
            return True

        for u, v in edges:
            if not union(u, v):
                return [u, v]
```
