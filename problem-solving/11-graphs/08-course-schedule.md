# Course Schedule

[Problem Link](https://leetcode.com/problems/course-schedule/)

## Approach

Detect whether the prerequisite graph has a cycle. If it does, some courses cannot be finished.

Build an adjacency list and an indegree array. Enqueue all courses with indegree 0 and process them in topological order (Kahn's algorithm).

If the number of processed courses equals `numCourses`, there is no cycle.

DFS cycle detection with three states (unvisited, visiting, visited) also works.

**Time Complexity:** O(V + E)  
**Space Complexity:** O(V + E)

## Code

```python
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        graph = [[] for _ in range(numCourses)]
        indegree = [0] * numCourses

        for course, prereq in prerequisites:
            graph[prereq].append(course)
            indegree[course] += 1

        queue = deque([i for i in range(numCourses) if indegree[i] == 0])
        taken = 0

        while queue:
            node = queue.popleft()
            taken += 1
            for nxt in graph[node]:
                indegree[nxt] -= 1
                if indegree[nxt] == 0:
                    queue.append(nxt)

        return taken == numCourses
```
