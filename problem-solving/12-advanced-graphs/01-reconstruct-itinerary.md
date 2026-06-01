# Reconstruct Itinerary

[Problem Link](https://leetcode.com/problems/reconstruct-itinerary/)

## Approach

Find a lexicographically smallest Eulerian path that uses every ticket exactly once, starting from `"JFK"`.

Build a graph of destinations sorted alphabetically for each airport. Use Hierholzer's algorithm (DFS): repeatedly walk to the next unused edge, backtrack when stuck, and prepend airports to the result.

Sorting neighbors ensures the first complete itinerary found is lexicographically smallest.

**Time Complexity:** O(E log E) for sorting edges, O(E) traversal  
**Space Complexity:** O(E)

## Code

```python
class Solution:
    def findItinerary(self, tickets: List[List[str]]) -> List[str]:
        graph = defaultdict(list)
        for src, dst in tickets:
            graph[src].append(dst)
        for src in graph:
            graph[src].sort()

        route = []

        def dfs(airport):
            while graph[airport]:
                dfs(graph[airport].pop(0))
            route.append(airport)

        dfs("JFK")
        return route[::-1]
```
