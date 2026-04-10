# Searching

Searching algorithms find an element or a set of elements satisfying given criteria. The efficiency of searching depends heavily on whether the data is sorted and how it is organized.

## Linear Search

Scan every element until the target is found or the array is exhausted.

```python
def linear_search(arr, target):
    for i, x in enumerate(arr):
        if x == target:
            return i
    return -1
```

**Time:** $O(n)$ worst case.

**When to use:** unsorted data; very small arrays; searching for all occurrences; when elements are accessed sequentially (streaming data).

## Binary Search

Search a **sorted** array by repeatedly halving the search space.

```python
def binary_search(arr, target):
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = lo + (hi - lo) // 2   # avoids integer overflow
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1
```

**Time:** $O(\log n)$. Each iteration halves the range.

**Precondition:** the array must be sorted.

### Binary Search Variants

**Find leftmost (lower bound):** first index $i$ such that `arr[i] >= target`.

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

**Find rightmost (upper bound):** first index $i$ such that `arr[i] > target`.

```python
def upper_bound(arr, target):
    lo, hi = 0, len(arr)
    while lo < hi:
        mid = (lo + hi) // 2
        if arr[mid] <= target:
            lo = mid + 1
        else:
            hi = mid
    return lo
```

**Count occurrences of target:** `upper_bound(arr, target) - lower_bound(arr, target)`.

**Search on answer:** binary search on the answer space when the feasibility check is monotone.

```python
# Minimum capacity to ship packages in D days
def ship_in_d_days(weights, days):
    def can_ship(capacity):
        batches = 1; cur = 0
        for w in weights:
            if cur + w > capacity:
                batches += 1; cur = 0
            cur += w
        return batches <= days

    lo, hi = max(weights), sum(weights)
    while lo < hi:
        mid = (lo + hi) // 2
        if can_ship(mid):
            hi = mid
        else:
            lo = mid + 1
    return lo
```

## Interpolation Search

For uniformly distributed sorted data, estimate the target position instead of always picking the midpoint.

$$\text{pos} = lo + \frac{(target - arr[lo]) \times (hi - lo)}{arr[hi] - arr[lo]}$$

**Time:** $O(\log \log n)$ for uniform distributions; $O(n)$ worst case.

## Exponential Search

For sorted arrays of unknown size or when the target is near the beginning.

1. Find a range $[1, 2, 4, 8, \ldots, 2^k]$ where $arr[2^k] \geq target$.
2. Binary search within $[2^{k-1}, 2^k]$.

**Time:** $O(\log n)$. Useful for unbounded arrays.

## Searching in Trees

**Binary Search Tree (BST):** search in $O(h)$ time ($O(\log n)$ if balanced).

**Trie:** search a string of length $m$ in $O(m)$ time, independent of the number of strings.

## Hash Tables

The standard solution for $O(1)$ average-time lookup by key.

**Hash function:** maps a key to a bucket index. A good hash function distributes keys uniformly.

**Collision resolution:**

**Separate chaining:** each bucket is a linked list (or dynamic array). Lookup scans the chain.

**Open addressing:** probe a sequence of buckets until an empty one is found.
- Linear probing: `(hash + i) % n`. Simple; suffers from primary clustering.
- Quadratic probing: `(hash + i^2) % n`. Reduces clustering.
- Double hashing: `(hash1 + i * hash2) % n`. Least clustering.

**Load factor $\alpha = n / m$** (items / buckets). Performance degrades as $\alpha$ approaches 1. Typical: resize when $\alpha > 0.7$.

**Expected performance:**
- Average lookup: $O(1)$.
- Worst case (all keys collide): $O(n)$.

**Python `dict`:** open addressing with a compact table; load factor threshold 2/3. Uses SipHash for security.

## String Searching

### Naive String Search

Check all positions in the text. $O(nm)$ where $n$ = text length, $m$ = pattern length.

### KMP (Knuth-Morris-Pratt)

Precompute a failure function to skip redundant comparisons after a mismatch.

**Time:** $O(n + m)$.

**Failure function (partial match table):** `fail[i]` = length of the longest proper prefix of `pattern[:i+1]` that is also a suffix.

### Rabin-Karp

Rolling hash: hash each window of length $m$; check for match when hash values agree.

**Time:** $O(nm)$ worst case; $O(n + m)$ expected.

**Applications:** plagiarism detection (multiple pattern search), substring matching.

### Boyer-Moore

Search from right to left within the pattern; use bad-character and good-suffix heuristics to skip large sections.

**Time:** $O(nm)$ worst case; sub-linear on average. Fastest in practice for long patterns.
