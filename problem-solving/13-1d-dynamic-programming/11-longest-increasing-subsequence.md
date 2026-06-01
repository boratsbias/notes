# Longest Increasing Subsequence

[Problem Link](https://leetcode.com/problems/longest-increasing-subsequence/)

## Approach

Classic **O(n²)** DP: `dp[i]` is the LIS length ending at `i`. For each `j < i` with `nums[j] < nums[i]`, update `dp[i] = max(dp[i], dp[j] + 1)`.

Patience sorting with binary search gives **O(n log n)**: maintain a list `tails` where `tails[k]` is the smallest ending value of an increasing subsequence of length `k + 1`. For each number, binary search where it fits and replace or append.

**Time Complexity:** O(n log n)  
**Space Complexity:** O(n)

## Code

```python
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        tails = []

        for num in nums:
            pos = bisect_left(tails, num)
            if pos == len(tails):
                tails.append(num)
            else:
                tails[pos] = num

        return len(tails)
```
