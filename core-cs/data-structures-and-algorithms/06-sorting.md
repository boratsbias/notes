# Sorting

Sorting algorithms arrange elements in a specified order (ascending or descending). Sorting is one of the most fundamental operations in computing and is a prerequisite for many other algorithms (binary search, merge, kd-tree construction).

## Comparison-Based Sorting

These algorithms compare elements pairwise. The optimal lower bound for comparison-based sorting is $\Omega(n \log n)$.

**Proof sketch:** there are $n!$ possible orderings of $n$ elements. A decision tree of comparisons must have at least $n!$ leaves. A binary tree with $n!$ leaves has height $\geq \log_2(n!) = \Theta(n \log n)$.

## Merge Sort

**Strategy:** divide and conquer. Split the array in half; recursively sort each half; merge the two sorted halves.

```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i]); i += 1
        else:
            result.append(right[j]); j += 1
    return result + left[i:] + right[j:]
```

**Time:** $O(n \log n)$ in all cases.

**Space:** $O(n)$ auxiliary.

**Stable:** equal elements maintain their relative order.

**Applications:** external sorting (when data doesn't fit in memory), sorting linked lists.

## Quick Sort

**Strategy:** partition the array around a pivot; recursively sort each partition.

```python
def quicksort(arr, lo=0, hi=None):
    if hi is None: hi = len(arr) - 1
    if lo < hi:
        p = partition(arr, lo, hi)
        quicksort(arr, lo, p - 1)
        quicksort(arr, p + 1, hi)

def partition(arr, lo, hi):
    pivot = arr[hi]
    i = lo - 1
    for j in range(lo, hi):
        if arr[j] <= pivot:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    arr[i+1], arr[hi] = arr[hi], arr[i+1]
    return i + 1
```

**Time:** $O(n \log n)$ average; $O(n^2)$ worst case (always picks smallest/largest as pivot).

**Space:** $O(\log n)$ stack space.

**Not stable** (standard implementation).

**Optimizations:**
- Random pivot selection: avoids worst case in practice.
- Median-of-three pivot: choose median of first, middle, last elements.
- 3-way partition (Dutch National Flag): handles many duplicate keys efficiently.
- Introsort (C++ `std::sort`): quicksort, switch to heapsort if depth exceeds $2 \log n$; switch to insertion sort for small subarrays.

## Heap Sort

**Strategy:** build a max-heap; repeatedly extract the maximum.

**Time:** $O(n \log n)$ guaranteed.

**Space:** $O(1)$ (in-place).

**Not stable.**

**Less cache-friendly than quicksort** due to non-sequential memory access.

## Insertion Sort

**Strategy:** build the sorted array one element at a time by inserting each new element into its correct position.

```python
def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key:
            arr[j+1] = arr[j]
            j -= 1
        arr[j+1] = key
```

**Time:** $O(n^2)$ worst case; $O(n)$ if already nearly sorted.

**Space:** $O(1)$.

**Stable.**

**Use case:** very small arrays (typically $n \leq 16$); nearly sorted data. Used as the base case in timsort and introsort.

## Selection Sort

Find the minimum element and swap it to position 0; repeat for position 1, 2, ...

**Time:** $O(n^2)$ always.

**Not stable** (standard implementation).

**Use case:** rarely; minimizes number of swaps (useful when swapping is expensive).

## Bubble Sort

Repeatedly swap adjacent out-of-order elements.

**Time:** $O(n^2)$ worst case; $O(n)$ if already sorted (with early termination).

**Stable.** **Rarely used** in practice.

## Counting Sort

For integer keys in range $[0, k)$: count occurrences of each key; compute prefix sums; place elements.

**Time:** $O(n + k)$.

**Space:** $O(n + k)$.

**Stable.**

**Use case:** large arrays of small integers.

## Radix Sort

Sort integers digit by digit, from least significant to most significant (LSD radix sort), using counting sort for each digit.

**Time:** $O(d(n + b))$ where $d$ = number of digits, $b$ = base (typically 10 or 256).

For fixed-width integers (32-bit, 64-bit): $O(n)$.

**Stable.** **Space:** $O(n + b)$.

## Timsort

The hybrid algorithm used in Python (`sorted`, `list.sort`) and Java (for objects).

**Strategy:** identify natural runs (already sorted subsequences); if a run is too short, extend it with insertion sort; merge runs using a merge sort variant with galloping mode for uneven merges.

**Time:** $O(n \log n)$ worst case; $O(n)$ best case (already sorted).

**Stable.** **Space:** $O(n)$.

## Algorithm Comparison

| Algorithm | Best | Average | Worst | Space | Stable |
|-----------|------|---------|-------|-------|--------|
| Merge sort | $O(n \log n)$ | $O(n \log n)$ | $O(n \log n)$ | $O(n)$ | Yes |
| Quick sort | $O(n \log n)$ | $O(n \log n)$ | $O(n^2)$ | $O(\log n)$ | No |
| Heap sort | $O(n \log n)$ | $O(n \log n)$ | $O(n \log n)$ | $O(1)$ | No |
| Insertion sort | $O(n)$ | $O(n^2)$ | $O(n^2)$ | $O(1)$ | Yes |
| Timsort | $O(n)$ | $O(n \log n)$ | $O(n \log n)$ | $O(n)$ | Yes |
| Counting sort | $O(n+k)$ | $O(n+k)$ | $O(n+k)$ | $O(n+k)$ | Yes |
| Radix sort | $O(dn)$ | $O(dn)$ | $O(dn)$ | $O(n+b)$ | Yes |
