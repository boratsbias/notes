# Network Delay Time

[Problem Link](https://leetcode.com/problems/network-delay-time/)

## Approach

Find the time for a signal from node `k` to reach all nodes in a weighted directed graph. Return the maximum shortest-path distance, or -1 if some node is unreachable.

Run Dijkstra's algorithm from `k` using a min-heap of `(time, node)`.

Relax edges when popping a node: if `time + weight` improves the best known distance to a neighbor, push the update.

**Time Complexity:** O(E log V)  
**Space Complexity:** O(V + E)

## Code

```python
class Solution:
    def networkDelayTime(self, times: List[List[int]], n: int, k: int) -> int:
        graph = defaultdict(list)
        for u, v, w in times:
            graph[u].append((v, w))

        dist = {i: float("inf") for i in range(1, n + 1)}
        dist[k] = 0
        heap = [(0, k)]

        while heap:
            time, node = heapq.heappop(heap)
            if time > dist[node]:
                continue
            for nei, w in graph[node]:
                nxt = time + w
                if nxt < dist[nei]:
                    dist[nei] = nxt
                    heapq.heappush(heap, (nxt, nei))

        result = max(dist.values())
        return result if result < float("inf") else -1
```
