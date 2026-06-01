# Alien Dictionary

[Problem Link](https://leetcode.com/problems/alien-dictionary/)

## Approach

Extract character ordering rules by comparing adjacent words. The first differing character between word `i` and word `i + 1` gives a directed edge `c1 -> c2`.

Build a graph and indegrees, then run topological sort. If a cycle exists or the sort uses fewer characters than the alphabet, return `""`.

Also validate prefix violations: if a longer word is a prefix of the next shorter word, no valid order exists.

**Time Complexity:** O(C) where C is total characters across words  
**Space Complexity:** O(1) alphabet size, at most 26 nodes

## Code

```python
class Solution:
    def alienOrder(self, words: List[str]) -> str:
        graph = defaultdict(set)
        indegree = {c: 0 for word in words for c in word}

        for i in range(len(words) - 1):
            w1, w2 = words[i], words[i + 1]
            if len(w1) > len(w2) and w1.startswith(w2):
                return ""
            for c1, c2 in zip(w1, w2):
                if c1 != c2:
                    if c2 not in graph[c1]:
                        graph[c1].add(c2)
                        indegree[c2] += 1
                    break

        queue = deque([c for c in indegree if indegree[c] == 0])
        order = []

        while queue:
            c = queue.popleft()
            order.append(c)
            for nei in graph[c]:
                indegree[nei] -= 1
                if indegree[nei] == 0:
                    queue.append(nei)

        return "".join(order) if len(order) == len(indegree) else ""
```
