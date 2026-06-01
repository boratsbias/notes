# Longest Consecutive Sequence

[Problem Link](https://leetcode.com/problems/longest-consecutive-sequence/)

## Approach

Put every number in a hash set so membership checks are **O(1)** on average.

A sequence can only be extended upward from its smallest element. For each number, start counting only if `num - 1` is not in the set. Then walk `num, num + 1, num + 2, ...` while each value exists and track the longest streak.

Sorting first works but costs **O(n log n)** time. The set approach finds each streak once and runs in **O(n)** time.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        num_set = set(nums)
        longest = 0

        for num in num_set:
            if num - 1 in num_set:
                continue

            length = 1
            while num + length in num_set:
                length += 1

            longest = max(longest, length)

        return longest
```
