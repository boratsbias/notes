# Arrays

An array is a contiguous block of memory storing elements of the same type, accessed by index. It is the most fundamental data structure and the basis for many others.

## Memory Layout

Elements are stored sequentially. The address of element $i$ is:

$$\text{addr}(i) = \text{base} + i \times \text{sizeof(element)}$$

This means element access is $O(1)$: compute the address and dereference. No traversal needed.

**Cache efficiency:** arrays have excellent spatial locality. Sequential access patterns fill cache lines efficiently, leading to high performance in practice even for $O(n)$ algorithms.

## Operations and Complexity

| Operation | Time | Notes |
|-----------|------|-------|
| Access by index | $O(1)$ | Direct address computation |
| Search (unsorted) | $O(n)$ | Linear scan |
| Search (sorted) | $O(\log n)$ | Binary search |
| Insert at end | $O(1)$ amortized | Dynamic array |
| Insert at position $i$ | $O(n)$ | Shift right |
| Delete at position $i$ | $O(n)$ | Shift left |
| Append (dynamic) | $O(1)$ amortized | |

## Static vs. Dynamic Arrays

**Static array:** fixed size set at creation. Allocated on stack or heap. Size must be known at compile time (C-style arrays) or allocation time.

**Dynamic array (resizable array):** doubles capacity when full. Examples: Python `list`, Java `ArrayList`, C++ `std::vector`, Rust `Vec`.

**Amortized analysis of append:** when full, allocate a new array of size $2n$ and copy. Cost of $n$ appends to an empty array:

$$n \times O(1) + O(1) + O(2) + O(4) + \ldots + O(n) = O(n) + O(n) = O(n)$$

Amortized cost per append: $O(1)$.

**Load factor:** `len / capacity`. Some implementations shrink when load factor falls below a threshold (e.g., 0.25).

## Common Array Operations

### Two-Pointer Technique

Maintain two indices that move toward each other or in the same direction.

**Reverse an array in-place:**

```python
def reverse(arr):
    lo, hi = 0, len(arr) - 1
    while lo < hi:
        arr[lo], arr[hi] = arr[hi], arr[lo]
        lo += 1; hi -= 1
```

**Two sum (sorted array):** find two elements summing to target.

```python
def two_sum(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo < hi:
        s = arr[lo] + arr[hi]
        if s == target: return (lo, hi)
        elif s < target: lo += 1
        else: hi -= 1
    return None
```

### Sliding Window

Maintain a window of fixed or variable size over the array.

**Maximum sum subarray of length $k$:**

```python
def max_sum_window(arr, k):
    s = sum(arr[:k])
    best = s
    for i in range(k, len(arr)):
        s += arr[i] - arr[i - k]
        best = max(best, s)
    return best
```

**Time:** $O(n)$ vs. $O(nk)$ for naive.

### Prefix Sums

Precompute cumulative sums to answer range sum queries in $O(1)$.

```python
prefix = [0] * (n + 1)
for i in range(n):
    prefix[i+1] = prefix[i] + arr[i]

# Sum of arr[l..r] (inclusive):
range_sum = prefix[r+1] - prefix[l]
```

**2D prefix sums:** extend to matrices for $O(1)$ rectangle sum queries.

## Binary Search

Search a sorted array for a target in $O(\log n)$.

```python
def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = lo + (hi - lo) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1
```

**Variants:**
- **Lower bound:** first index where `arr[i] >= target`.
- **Upper bound:** first index where `arr[i] > target`.

```python
def lower_bound(arr, target):
    lo, hi = 0, len(arr)
    while lo < hi:
        mid = (lo + hi) // 2
        if arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid
    return lo
```

## Kadane's Algorithm

Maximum sum contiguous subarray in $O(n)$.

```python
def max_subarray(arr):
    best = cur = arr[0]
    for x in arr[1:]:
        cur = max(x, cur + x)
        best = max(best, cur)
    return best
```

**Invariant:** `cur` is the maximum sum of a subarray ending at the current position.

## Matrices (2D Arrays)

A 2D array in row-major layout: `A[i][j]` is at `base + (i * cols + j) * sizeof(element)`.

**Transpose:** $A^T[i][j] = A[j][i]$. $O(n^2)$.

**Matrix multiplication:** $C[i][j] = \sum_k A[i][k] \times B[k][j]$. Naive: $O(n^3)$. Strassen: $O(n^{2.807})$. Cache-efficient blocking: significant constant factor improvement.

**Rotation 90° clockwise in-place:** transpose, then reverse each row.

## Bit Arrays

Pack $n$ bits into $\lceil n/64 \rceil$ 64-bit integers for $8 \times$ space efficiency. Useful for sets, visited arrays, Bloom filter internals.
