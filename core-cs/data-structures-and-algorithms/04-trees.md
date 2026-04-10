# Trees

A tree is a hierarchical data structure where each node has zero or more children, with exactly one root and no cycles. Trees model hierarchical relationships: file systems, organization charts, parse trees, decision trees.

## Terminology

**Root:** the topmost node; has no parent.

**Leaf:** a node with no children.

**Height of a node:** the number of edges on the longest path from the node to a leaf.

**Depth of a node:** the number of edges from the root to the node.

**Degree:** the number of children.

**Subtree:** a node and all its descendants.

**Full binary tree:** every node has 0 or 2 children.

**Complete binary tree:** all levels are fully filled except possibly the last, which is filled from left to right.

**Perfect binary tree:** all internal nodes have 2 children; all leaves at the same depth.

## Binary Tree

Each node has at most 2 children: left and right.

```python
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
```

## Tree Traversals

### Depth-First Traversals

**Inorder (LNR):** left, node, right. For a BST, yields elements in sorted order.

**Preorder (NLR):** node, left, right. Useful for copying the tree or generating prefix expressions.

**Postorder (LRN):** left, right, node. Useful for deleting the tree or computing tree height.

```python
def inorder(root):
    if not root: return
    inorder(root.left)
    print(root.val)
    inorder(root.right)
```

**Iterative inorder using a stack:**

```python
def inorder_iter(root):
    stack, result = [], []
    cur = root
    while cur or stack:
        while cur:
            stack.append(cur)
            cur = cur.left
        cur = stack.pop()
        result.append(cur.val)
        cur = cur.right
    return result
```

### Breadth-First Traversal (Level Order)

Process nodes level by level using a queue.

```python
from collections import deque

def level_order(root):
    if not root: return []
    q = deque([root])
    result = []
    while q:
        level = []
        for _ in range(len(q)):
            node = q.popleft()
            level.append(node.val)
            if node.left: q.append(node.left)
            if node.right: q.append(node.right)
        result.append(level)
    return result
```

## Binary Search Tree (BST)

A binary tree satisfying the BST property: for every node, all values in the left subtree are less than the node's value, and all values in the right subtree are greater.

**Operations:** search, insert, delete: $O(h)$ where $h$ is the height. For a balanced tree: $O(\log n)$. For a degenerate (linear) tree: $O(n)$.

**Insert:**

```python
def insert(root, val):
    if not root: return TreeNode(val)
    if val < root.val: root.left = insert(root.left, val)
    elif val > root.val: root.right = insert(root.right, val)
    return root
```

**Delete:** three cases:
1. Leaf: remove directly.
2. One child: replace node with its child.
3. Two children: replace with inorder successor (smallest in right subtree); delete successor from right subtree.

## Self-Balancing BSTs

A plain BST can degenerate. Self-balancing trees maintain $O(\log n)$ height.

**AVL Tree:** the height difference between left and right subtrees (balance factor) is at most 1. On insert/delete, perform rotations to restore balance.

**Red-Black Tree:** each node is red or black; constraints on coloring maintain $O(\log n)$ height. Less strictly balanced than AVL; fewer rotations on insert/delete. Used in C++ `std::map`, Java `TreeMap`, Linux kernel.

**Rotations:**

```
Left rotation at x:            Right rotation at y:
    x               y               y           x
   / \             / \             / \         / \
  a   y    ->     x   c    ->     x   c ->    a   y
     / \         / \             / \             / \
    b   c       a   b           a   b           b   c
```

## Heaps

A complete binary tree satisfying the heap property.

**Min-heap:** parent $\leq$ children. The root is the minimum.

**Max-heap:** parent $\geq$ children. The root is the maximum.

**Array representation:** node $i$: parent = $(i-1)/2$; left child = $2i+1$; right child = $2i+2$.

**Operations:**
- `insert`: append at end; sift up. $O(\log n)$.
- `extract-min/max`: swap root with last; remove last; sift down. $O(\log n)$.
- `heapify`: build a heap from an array. $O(n)$.

**Applications:** priority queue, heap sort, Dijkstra's algorithm, top-$k$ problems.

## Trie (Prefix Tree)

A tree where each node represents a character; paths from root to nodes spell out strings. Efficient for prefix-based operations.

**Insert/Search/StartsWith:** $O(m)$ where $m$ is the string length. Independent of the number of strings stored.

**Applications:** autocomplete, spell checking, IP routing (radix trie), string matching.

```python
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for ch in word:
            node = node.children.setdefault(ch, TrieNode())
        node.is_end = True

    def search(self, word):
        node = self.root
        for ch in word:
            if ch not in node.children: return False
            node = node.children[ch]
        return node.is_end
```

## Segment Tree

A binary tree over an array that supports range queries (sum, min, max) and point updates in $O(\log n)$.

**Build:** $O(n)$. **Query:** $O(\log n)$. **Update:** $O(\log n)$.

**Lazy propagation:** defer updates to subtrees until needed. Enables range updates in $O(\log n)$.

## B-Tree

A self-balancing search tree where nodes can have many children (order $m$: up to $m-1$ keys and $m$ children). Keeps all leaves at the same depth.

**Applications:** file systems (HFS+, NTFS, ext4), databases (indexes). Minimizes disk I/O by keeping the tree shallow.

**B+ Tree:** all data stored in leaves; internal nodes are only index. Leaves are linked for efficient range scans. Used by MySQL InnoDB, PostgreSQL.
