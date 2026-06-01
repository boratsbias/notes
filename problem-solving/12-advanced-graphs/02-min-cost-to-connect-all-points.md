# Min Cost to Connect All Points

[Problem Link](https://leetcode.com/problems/min-cost-to-connect-all-points/)

## Approach

Connect all points with minimum total Manhattan edge weight. This is a Minimum Spanning Tree problem on a complete graph.

Use Kruskal's algorithm with Union-Find: sort all edges by cost, add an edge if it connects two different components.

Prim's algorithm with a min-heap from any start node also works.

Brute force over all subsets of edges is exponential.

**Time Complexity:** O(n² log n) for Kruskal on n² edges  
**Space Complexity:** O(n²)

## Code

```python
class Solution:
    def minCostConnectPoints(self, points: List[List[int]]) -> int:
        n = len(points)
        edges = []
        for i in range(n):
            for j in range(i + 1, n):
                cost = abs(points[i][0] - points[j][0]) + abs(points[i][1] - points[j][1])
                edges.append((cost, i, j))
        edges.sort()

        parent = list(range(n))
        rank = [0] * n

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

        total = 0
        used = 0
        for cost, u, v in edges:
            if union(u, v):
                total += cost
                used += 1
                if used == n - 1:
                    break

        return total
```
