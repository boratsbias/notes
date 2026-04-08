# Linear Algebra

## Scalars, Vectors, Matrices, Tensors

- **Scalar:** single number, e.g. $x \in \mathbb{R}$
- **Vector:** 1-D array of numbers, $\mathbf{x} \in \mathbb{R}^n$
- **Matrix:** 2-D array, $\mathbf{A} \in \mathbb{R}^{m \times n}$
- **Tensor:** n-D generalization of matrices

## Vector Operations

| Operation | Notation | Result |
|-----------|----------|--------|
| Dot product | $\mathbf{a} \cdot \mathbf{b} = \sum_i a_i b_i$ | scalar |
| Outer product | $\mathbf{a} \mathbf{b}^T$ | matrix |
| Element-wise (Hadamard) | $\mathbf{a} \odot \mathbf{b}$ | vector |
| Cross product | $\mathbf{a} \times \mathbf{b}$ | vector (3-D only) |

## Matrix Operations

**Transpose:** $(A^T)_{ij} = A_{ji}$

**Matrix multiplication:** $C = AB$ where $C_{ij} = \sum_k A_{ik} B_{kj}$
- Requires inner dimensions to match: $(m \times k)(k \times n) = (m \times n)$
- Not commutative: $AB \neq BA$ in general

**Inverse:** $A^{-1}$ exists iff $A$ is square and non-singular ($\det(A) \neq 0$). $A A^{-1} = I$

## Special Matrices

| Type | Property |
|------|----------|
| Identity $I$ | $AI = IA = A$ |
| Diagonal | Non-zero only on diagonal |
| Symmetric | $A = A^T$ |
| Orthogonal | $A^T A = I$, columns are orthonormal |
| Positive definite | $\mathbf{x}^T A \mathbf{x} > 0$ for all $\mathbf{x} \neq 0$ |
| Positive semi-definite | $\mathbf{x}^T A \mathbf{x} \geq 0$ |

## Norms

Measure the "size" of a vector or matrix.

**Vector norms:**
- $L^1$ norm: $\|\mathbf{x}\|_1 = \sum_i |x_i|$
- $L^2$ norm (Euclidean): $\|\mathbf{x}\|_2 = \sqrt{\sum_i x_i^2}$
- $L^\infty$ norm: $\|\mathbf{x}\|_\infty = \max_i |x_i|$
- $L^p$ norm: $\|\mathbf{x}\|_p = \left(\sum_i |x_i|^p\right)^{1/p}$

**Matrix norms:**
- Frobenius norm: $\|A\|_F = \sqrt{\sum_{i,j} A_{ij}^2}$

## Linear Independence and Rank

- Vectors are **linearly independent** if no vector can be written as a linear combination of the others.
- **Rank** of a matrix = number of linearly independent rows (or columns).
- A matrix $A \in \mathbb{R}^{m \times n}$ has rank at most $\min(m, n)$.
- **Full rank** means rank equals $\min(m, n)$.

## Determinant

- Scalar measure of how much a matrix scales volume.
- $\det(AB) = \det(A)\det(B)$
- $\det(A^{-1}) = 1 / \det(A)$
- $\det(A) = 0$ iff $A$ is singular (non-invertible).

## Linear Systems

$A\mathbf{x} = \mathbf{b}$

- Unique solution if $A$ is invertible: $\mathbf{x} = A^{-1}\mathbf{b}$
- No solution (overdetermined, inconsistent) or infinitely many (underdetermined)
- Solved in practice via Gaussian elimination, LU decomposition — NOT by computing $A^{-1}$ directly

## Decompositions

### LU Decomposition
$A = LU$ where $L$ is lower triangular, $U$ is upper triangular. Used for solving linear systems efficiently.

### QR Decomposition
$A = QR$ where $Q$ is orthogonal, $R$ is upper triangular. Used in least squares, Gram-Schmidt.

### Eigendecomposition
$A = Q \Lambda Q^{-1}$ where $\Lambda$ = diagonal matrix of eigenvalues. Only valid for diagonalizable square matrices.

### Singular Value Decomposition (SVD)
$A = U \Sigma V^T$
- $U \in \mathbb{R}^{m \times m}$: left singular vectors (orthogonal)
- $\Sigma \in \mathbb{R}^{m \times n}$: diagonal, singular values $\sigma_i \geq 0$
- $V \in \mathbb{R}^{n \times n}$: right singular vectors (orthogonal)
- Works for **any** matrix (not just square)
- Singular values = $\sqrt{\text{eigenvalues of } A^T A}$

**Key uses in ML:**
- PCA (principal component analysis)
- Low-rank approximations (compress data, reduce noise)
- Pseudoinverse: $A^+ = V \Sigma^+ U^T$

## Least Squares

Solve $A\mathbf{x} \approx \mathbf{b}$ when the system is overdetermined.

**Normal equations:** $A^T A \mathbf{x} = A^T \mathbf{b}$

**Solution:** $\mathbf{x} = (A^T A)^{-1} A^T \mathbf{b}$ — the pseudoinverse projection.

Used heavily in linear regression.

## Projections

Project $\mathbf{b}$ onto the column space of $A$:

$$\mathbf{p} = A(A^T A)^{-1} A^T \mathbf{b}$$

The projection matrix $P = A(A^T A)^{-1} A^T$ satisfies $P^2 = P$ (idempotent) and $P^T = P$.

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Matrix multiply | Forward/backward pass in neural nets |
| SVD | PCA, recommendation systems, NLP (LSA) |
| Dot product | Attention scores, cosine similarity |
| Orthogonality | Weight initialization, QR in optimization |
| Norms | Regularization ($L^1$, $L^2$), gradient clipping |
| Determinant | Change of variables in normalizing flows |
| Positive definiteness | Covariance matrices, kernels |
