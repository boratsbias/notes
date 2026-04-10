# Graphs

A graph is a data structure consisting of vertices (nodes) and edges (connections between vertices). Graphs model relationships: networks, maps, dependencies, social connections, state machines.

## Definitions

**Directed graph (digraph):** edges have a direction. Edge $(u, v)$ goes from $u$ to $v$ but not necessarily from $v$ to $u$.

**Undirected graph:** edges are bidirectional. Edge $\{u, v\}$ connects $u$ and $v$.

**Weighted graph:** edges have associated numeric weights (costs, distances).

**Path:** a sequence of vertices connected by edges.

**Cycle:** a path that starts and ends at the same vertex.

**DAG (Directed Acyclic Graph):** a directed graph with no cycles.

**Connected graph:** every pair of vertices is connected by a path (undirected). **Strongly connected:** every vertex is reachable from every other vertex (directed).

**Degree:** number of edges incident to a vertex. **In-degree / out-degree** for directed graphs.

**Tree:** a connected, acyclic undirected graph. $n$ vertices, $n-1$ edges.

## Graph Representations

### Adjacency List

For each vertex, store a list of its neighbors. Space: $O(V + E)$.

```python
graph = {
    0: [1, 2],
    1: [0, 3],
    2: [0, 3],
    3: [1, 2]
}
```

**Best for:** sparse graphs (most real-world graphs). Efficient edge iteration.

### Adjacency Matrix

$n \times n$ boolean (or weight) matrix where `matrix[u][v] = True` if edge $(u, v)$ exists. Space: $O(V^2)$.

**Best for:** dense graphs; $O(1)$ edge existence query.

### Edge List

A list of `(u, v)` or `(u, v, weight)` tuples. Space: $O(E)$.

**Best for:** Kruskal's MST algorithm.

## Graph Traversal

### Breadth-First Search (BFS)

Explores layer by layer. Finds shortest paths (unweighted).

```python
from collections import deque

def bfs(graph, start):
    visited = {start}
    q = deque([start])
    while q:
        node = q.popleft()
        print(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                q.append(neighbor)
```

**Time:** $O(V + E)$. **Space:** $O(V)$ (queue).

**Applications:** shortest path (unweighted), level-order traversal, bipartite check, web crawling.

### Depth-First Search (DFS)

Explores as deep as possible before backtracking.

```python
def dfs(graph, node, visited=None):
    if visited is None: visited = set()
    visited.add(node)
    print(node)
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(graph, neighbor, visited)
```

**Time:** $O(V + E)$. **Space:** $O(V)$ (recursion stack).

**Applications:** cycle detection, topological sort, connected components, SCC, maze solving.

## Shortest Paths

### Dijkstra's Algorithm

Single-source shortest paths in a weighted graph with non-negative weights.

```python
import heapq

def dijkstra(graph, src):
    dist = {v: float('inf') for v in graph}
    dist[src] = 0
    heap = [(0, src)]     # (distance, vertex)
    while heap:
        d, u = heapq.heappop(heap)
        if d > dist[u]: continue
        for v, w in graph[u]:
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w
                heapq.heappush(heap, (dist[v], v))
    return dist
```

**Time:** $O((V + E) \log V)$ with a binary heap.

### Bellman-Ford Algorithm

Handles negative-weight edges. Detects negative cycles.

**Algorithm:** relax all edges $V-1$ times. If a relaxation succeeds in the $V$-th iteration, there is a negative cycle.

**Time:** $O(VE)$.

### Floyd-Warshall

All-pairs shortest paths. $O(V^3)$ time, $O(V^2)$ space.

$$d[i][j] = \min(d[i][j], d[i][k] + d[k][j])$$

## Minimum Spanning Tree (MST)

A spanning tree (connects all vertices) with minimum total edge weight.

### Kruskal's Algorithm

1. Sort all edges by weight.
2. Greedily add the lightest edge that does not create a cycle.
3. Use Union-Find to detect cycles.

**Time:** $O(E \log E)$.

### Prim's Algorithm

1. Start from any vertex.
2. Greedily add the minimum-weight edge connecting the MST to a non-MST vertex.
3. Use a priority queue.

**Time:** $O((V + E) \log V)$.

## Topological Sort

A linear ordering of vertices in a DAG such that for every directed edge $(u, v)$, $u$ comes before $v$.

**Kahn's algorithm (BFS-based):**

```python
from collections import deque

def topo_sort(graph, n):
    in_degree = [0] * n
    for u in range(n):
        for v in graph[u]:
            in_degree[v] += 1
    q = deque([u for u in range(n) if in_degree[u] == 0])
    order = []
    while q:
        u = q.popleft()
        order.append(u)
        for v in graph[u]:
            in_degree[v] -= 1
            if in_degree[v] == 0:
                q.append(v)
    return order if len(order) == n else []  # empty if cycle
```

**Applications:** build systems, dependency resolution, course scheduling, compiler passes.

## Union-Find (Disjoint Set Union)

Tracks connected components. Supports `union(u, v)` and `find(u)` (returns component representative).

**Path compression + union by rank:** amortized $O(\alpha(n)) \approx O(1)$.

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px == py: return False
        if self.rank[px] < self.rank[py]: px, py = py, px
        self.parent[py] = px
        if self.rank[px] == self.rank[py]: self.rank[px] += 1
        return True
```
