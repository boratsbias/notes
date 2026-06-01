# Median of Two Sorted Arrays

[Problem Link](https://leetcode.com/problems/median-of-two-sorted-arrays/)

## Approach

Binary search on the shorter array to partition both arrays so the left halves contain the smaller half of all elements.

Let partition indices `i` and `j` satisfy:

- `max(left_part) <= min(right_part)` across both arrays
- left side size equals `(m + n + 1) // 2`

The median comes from the max of the left side and the min of the right side, depending on total length parity.

Merging both arrays costs **O(m + n)** time and extra space. Partition binary search runs in **O(log(min(m, n)))** time.

**Time Complexity:** O(log(min(m, n)))  
**Space Complexity:** O(1)

## Code

```python
class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        if len(nums1) > len(nums2):
            nums1, nums2 = nums2, nums1

        m, n = len(nums1), len(nums2)
        total_left = (m + n + 1) // 2
        left, right = 0, m

        while left <= right:
            i = (left + right) // 2
            j = total_left - i

            left1 = float("-inf") if i == 0 else nums1[i - 1]
            right1 = float("inf") if i == m else nums1[i]
            left2 = float("-inf") if j == 0 else nums2[j - 1]
            right2 = float("inf") if j == n else nums2[j]

            if left1 <= right2 and left2 <= right1:
                if (m + n) % 2:
                    return max(left1, left2)
                return (max(left1, left2) + min(right1, right2)) / 2
            if left1 > right2:
                right = i - 1
            else:
                left = i + 1

        return 0.0
```
