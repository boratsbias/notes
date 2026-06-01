# Cheapest Flights Within K Stops

[Problem Link](https://leetcode.com/problems/cheapest-flights-within-k-stops/)

## Approach

Find the minimum cost from `src` to `dst` using at most `k` stops (at most `k + 1` edges).

Run a Bellman-Ford style relaxation for `k + 1` rounds: copy distances, then try relaxing every flight once per round.

Standard Dijkstra does not track stop count correctly without modifying state to `(cost, node, stops)`.

**Time Complexity:** O(k × E)  
**Space Complexity:** O(V)

## Code

```python
class Solution:
    def findCheapestPrice(
        self, n: int, flights: List[List[int]], src: int, dst: int, k: int
    ) -> int:
        dist = [float("inf")] * n
        dist[src] = 0

        for _ in range(k + 1):
            tmp = dist[:]
            for u, v, price in flights:
                if dist[u] != float("inf"):
                    tmp[v] = min(tmp[v], dist[u] + price)
            dist = tmp

        return dist[dst] if dist[dst] != float("inf") else -1
```
