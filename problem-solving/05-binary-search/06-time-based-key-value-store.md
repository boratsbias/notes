# Time Based Key-Value Store

[Problem Link](https://leetcode.com/problems/time-based-key-value-store/)

## Approach

Store each key in a hash map mapping to a list of `(timestamp, value)` pairs appended in increasing timestamp order.

For `get(key, timestamp)`, binary search on that key's list for the largest timestamp less than or equal to the query.

Linear scan on each get is **O(n)**. Binary search per get is **O(log n)** with **O(1)** set time.

**Time Complexity:** O(1) set, O(log n) get  
**Space Complexity:** O(n) total stored entries

## Code

```python
class TimeMap:

    def __init__(self):
        self.store = defaultdict(list)

    def set(self, key: str, value: str, timestamp: int) -> None:
        self.store[key].append((timestamp, value))

    def get(self, key: str, timestamp: int) -> str:
        entries = self.store[key]
        left, right = 0, len(entries) - 1
        result = ""

        while left <= right:
            mid = (left + right) // 2
            if entries[mid][0] <= timestamp:
                result = entries[mid][1]
                left = mid + 1
            else:
                right = mid - 1

        return result
```
