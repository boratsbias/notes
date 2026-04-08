# Tensor Operations

## What is a Tensor?

A tensor is a multi-dimensional array generalizing scalars, vectors, and matrices:

| Rank | Name | Shape | Example |
|------|------|-------|---------|
| 0 | Scalar | $()$ | loss value |
| 1 | Vector | $(n)$ | embedding |
| 2 | Matrix | $(m, n)$ | weight matrix |
| 3 | 3-D tensor | $(b, m, n)$ | batch of matrices |
| 4 | 4-D tensor | $(b, c, h, w)$ | batch of images |

In ML frameworks (PyTorch, NumPy), tensors are the fundamental data structure.

## Indexing and Slicing

```python
T[i]          # select along first dimension
T[i, j]       # select element
T[:, 1:3]     # slice rows, select cols 1 and 2
T[..., -1]    # last element along last dim (ellipsis)
```

## Reshaping

**Reshape:** change shape without changing data. Total elements must match.

```python
T.reshape(a, b, c)   # explicit shape
T.view(a, -1)        # -1 infers the size
T.flatten()          # 1-D
```

**Squeeze / Unsqueeze:** remove or add dimensions of size 1.

```python
T.squeeze(dim)       # remove dim if size=1
T.unsqueeze(dim)     # insert dim of size 1
```

## Transposing and Permuting

**Transpose** swaps two dimensions:
```python
T.T           # transpose last two dims
T.transpose(0, 1)
```

**Permute** reorders all dimensions:
```python
T.permute(2, 0, 1)  # (a,b,c) → (c,a,b)
```

Common use: converting image format $(B, H, W, C) \to (B, C, H, W)$.

## Broadcasting

Allows operations on tensors with different shapes — smaller tensor is "broadcast" across larger.

**Rules:**
1. Align shapes from the right
2. Dimensions are compatible if equal or one of them is 1
3. Size-1 dimensions are stretched to match

```
(3, 1, 5) + (2, 5)
→ (3, 1, 5) + (1, 2, 5)   # align from right
→ (3, 2, 5)                # broadcast
```

Broadcasting is zero-copy — no actual data duplication.

## Elementwise Operations

Applied independently to each element (same shape required, or broadcastable):

```python
A + B, A * B, A / B   # arithmetic
torch.exp(T), torch.log(T), torch.sqrt(T)
torch.relu(T), torch.sigmoid(T)
```

## Reduction Operations

Reduce along one or more dimensions:

```python
T.sum(dim=0)     # sum across rows
T.mean(dim=-1)   # mean across last dim
T.max(dim=1)     # max across cols
T.norm(dim=2)    # L2 norm across dim 2
```

`keepdim=True` preserves the reduced dimension as size 1 (useful for broadcasting).

## Matrix Multiplication

**2-D:** standard matmul
```python
torch.mm(A, B)        # (m,k) × (k,n) → (m,n)
```

**Batched matmul:** last two dims are the matrix dims, batch dims must broadcast
```python
torch.bmm(A, B)       # (b,m,k) × (b,k,n) → (b,m,n)
torch.matmul(A, B)    # general: handles any batch dims
A @ B                 # operator syntax
```

**Einstein summation (einsum):**
```python
torch.einsum('bik,bjk->bij', Q, K)  # attention scores
torch.einsum('ij,jk->ik', A, B)     # matmul
torch.einsum('ii->', A)             # trace
torch.einsum('ij->ji', A)           # transpose
```

Einsum is expressive and efficient — preferred for complex contractions.

## Outer Product and Kronecker Product

```python
torch.outer(a, b)     # (n,) × (m,) → (n,m)
torch.kron(A, B)      # Kronecker product
```

## Concatenation and Stacking

```python
torch.cat([A, B], dim=0)    # concatenate along existing dim
torch.stack([A, B], dim=0)  # stack along new dim
```

## Tensor Contraction

Generalized multiply-and-sum over shared indices. Einsum handles all contractions:

```python
# Frobenius inner product: sum(A * B)
torch.einsum('ij,ij->', A, B)

# Batch outer product
torch.einsum('bi,bj->bij', x, y)

# Attention: softmax(QK^T / sqrt(d_k)) V
scores = torch.einsum('bhid,bhjd->bhij', Q, K) / math.sqrt(d_k)
out = torch.einsum('bhij,bhjd->bhid', scores, V)
```

## Memory Layout (Contiguous vs Non-Contiguous)

Tensors are stored in memory as 1-D arrays with **strides** describing how to step through each dimension.

- After transpose/permute, tensor may be **non-contiguous** (strides don't match natural order)
- `.contiguous()` makes a copy in natural row-major order
- Non-contiguous tensors can cause errors with some ops — use `.contiguous()` before `.view()`

## Sparse Tensors

Most entries are zero → store only non-zero values and their indices.

```python
torch.sparse_coo_tensor(indices, values, size)
```

Used in: graph adjacency matrices, NLP bag-of-words, recommendation systems.

## Tensor Decompositions

Generalize matrix decompositions to higher-order tensors:

| Decomposition | Description | Use |
|---------------|-------------|-----|
| CP (CANDECOMP/PARAFAC) | Sum of rank-1 tensors | Compression, knowledge graphs |
| Tucker | Core tensor + factor matrices | Multilinear PCA |
| TT (Tensor Train) | Chain of 3-D tensors | Compressing weight tensors |

**Tensor train decomposition** used to compress large weight matrices in transformers with minimal loss of expressivity.

## Gradient Flow Through Tensor Ops

All tensor operations in frameworks like PyTorch support autograd:

- Reshaping, permuting: gradients are reshaped back
- Reduction (sum, mean): gradient broadcasts back
- Elementwise: gradient multiplied elementwise by local derivative
- Matmul: see matrix calculus notes

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| 4-D tensors $(B, C, H, W)$ | CNNs — image batches |
| 3-D tensors $(B, T, D)$ | Transformers — token sequences |
| Batched matmul | Attention, feedforward layers |
| Einsum | Attention scores, custom layer implementations |
| Broadcasting | Loss computation, normalization |
| Transpose/permute | Data format conversion |
| Sparse tensors | Graph ML, NLP sparse features |
| Tensor decomposition | Model compression, parameter efficiency |
