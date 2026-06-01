# Top K Frequent Elements

[Problem Link](https://leetcode.com/problems/top-k-frequent-elements/)

## Approach

Count how often each number appears using a frequency map.

To return the k most frequent elements, use a bucket sort style approach:

- Create buckets indexed from 0 to n, where bucket i holds all numbers that appear exactly i times.
- Fill each bucket by iterating through the frequency map.
- Walk buckets from highest frequency down to 1, collecting numbers until k elements are gathered.

A min heap of size k also works: push each (frequency, number) pair and pop when the heap exceeds k. That costs **O(n log k)** time. Bucket sort runs in **O(n)** time when values are bounded by array length.

**Time Complexity:** O(n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        count = {}
        for num in nums:
            count[num] = count.get(num, 0) + 1

        buckets = [[] for _ in range(len(nums) + 1)]
        for num, freq in count.items():
            buckets[freq].append(num)

        result = []
        for freq in range(len(buckets) - 1, 0, -1):
            for num in buckets[freq]:
                result.append(num)
                if len(result) == k:
                    return result
```
