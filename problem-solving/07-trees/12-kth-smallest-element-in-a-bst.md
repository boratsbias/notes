# Kth Smallest Element in a BST

[Problem Link](https://leetcode.com/problems/kth-smallest-element-in-a-bst/)

## Approach

In-order traversal of a BST visits values in sorted order.

Perform iterative in-order traversal with a stack, counting nodes as they are popped. Return the value on the kth pop.

Collecting all values into a list uses **O(n)** space. Stopping after k steps uses **O(h)** stack space.

**Time Complexity:** O(h + k)  
**Space Complexity:** O(h)

## Code

```python
class Solution:
    def kthSmallest(self, root: Optional[TreeNode], k: int) -> int:
        stack = []
        curr = root

        while curr or stack:
            while curr:
                stack.append(curr)
                curr = curr.left
            curr = stack.pop()
            k -= 1
            if k == 0:
                return curr.val
            curr = curr.right
```
