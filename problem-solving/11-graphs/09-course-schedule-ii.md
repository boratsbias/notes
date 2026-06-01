# Course Schedule II

[Problem Link](https://leetcode.com/problems/course-schedule-ii/)

## Approach

Return one valid topological ordering of courses, or an empty list if a cycle exists.

Use Kahn's algorithm: repeatedly take a course with indegree 0, append it to the result, and reduce indegree of its dependents.

If the result length is less than `numCourses`, a cycle blocked some courses.

DFS post-order collection is an alternative, but BFS with indegrees is straightforward.

**Time Complexity:** O(V + E)  
**Space Complexity:** O(V + E)

## Code

```python
class Solution:
    def findOrder(self, numCourses: int, prerequisites: List[List[int]]) -> List[int]:
        graph = [[] for _ in range(numCourses)]
        indegree = [0] * numCourses

        for course, prereq in prerequisites:
            graph[prereq].append(course)
            indegree[course] += 1

        queue = deque([i for i in range(numCourses) if indegree[i] == 0])
        order = []

        while queue:
            node = queue.popleft()
            order.append(node)
            for nxt in graph[node]:
                indegree[nxt] -= 1
                if indegree[nxt] == 0:
                    queue.append(nxt)

        return order if len(order) == numCourses else []
```
