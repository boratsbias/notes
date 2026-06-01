# Task Scheduler

[Problem Link](https://leetcode.com/problems/task-scheduler/)

## Approach

Count task frequencies and find the maximum frequency `max_freq`.

The most frequent task creates `(max_freq - 1)` gaps of length `(n + 1)` plus one slot for the final batch of all tasks tied for max frequency.

Answer is `max(len(tasks), (max_freq - 1) * (n + 1) + max_count)` where `max_count` is how many tasks share `max_freq`.

Simulating the schedule works but is slower. The formula computes idle slots directly.

**Time Complexity:** O(n)  
**Space Complexity:** O(1) for the 26-letter frequency array

## Code

```python
class Solution:
    def leastInterval(self, tasks: List[str], n: int) -> int:
        count = Counter(tasks)
        max_freq = max(count.values())
        max_count = sum(1 for freq in count.values() if freq == max_freq)

        part_count = max_freq - 1
        part_length = n + 1
        empty_slots = part_count * part_length
        available_tasks = len(tasks) - max_freq * max_count
        idle_slots = max(0, empty_slots - available_tasks)

        return len(tasks) + idle_slots
```
