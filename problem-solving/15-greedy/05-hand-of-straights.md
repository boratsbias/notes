# Hand of Straights

[Problem Link](https://leetcode.com/problems/hand-of-straights/)

## Approach

Partition cards into groups of consecutive cards of length `groupSize`.

Count frequencies with a Counter. Process cards in sorted order: for each smallest remaining card `x`, form a group `x, x+1, ..., x+groupSize-1` and decrement counts. If any card in the group is missing, return false.

A min-heap of unique cards works similarly.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def isNStraightHand(self, hand: List[int], groupSize: int) -> bool:
        if len(hand) % groupSize:
            return False

        count = Counter(hand)

        for card in sorted(count):
            if count[card] == 0:
                continue
            need = count[card]
            for k in range(card, card + groupSize):
                if count[k] < need:
                    return False
                count[k] -= need

        return True
```
