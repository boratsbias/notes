# Detect Squares

[Problem Link](https://leetcode.com/problems/detect-squares/)

## Approach

Count axis-aligned squares with the given point as one corner.

Store all points and their frequencies in a hash map (duplicates matter).

For a new point `(x, y)`, any square with this corner needs a second point `(x, y2)` or `(x2, y)` sharing a side. The fourth corner is `(x2, y2)`.

Add the product of frequencies of the three other corners for each valid pair.

**Time Complexity:** O(1) per add (store point), O(n) per count where n is number of points  
**Space Complexity:** O(n)

## Code

```python
class DetectSquares:
    def __init__(self):
        self.points = defaultdict(int)

    def add(self, point: List[int]) -> None:
        self.points[tuple(point)] += 1

    def count(self, point: List[int]) -> int:
        x, y = point
        total = 0

        for (x2, y2), c in self.points.items():
            if x == x2 or y == y2 or abs(x - x2) != abs(y - y2):
                continue
            total += c * self.points[(x, y2)] * self.points[(x2, y)]

        return total
```
