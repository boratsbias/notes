# Eigenvalues and Eigenvectors

## Definition

For a square matrix $A \in \mathbb{R}^{n \times n}$, a non-zero vector $\mathbf{v}$ is an **eigenvector** with **eigenvalue** $\lambda$ if:

$$A\mathbf{v} = \lambda\mathbf{v}$$

Geometrically: $A$ only scales $\mathbf{v}$ (does not rotate it). $\lambda$ tells you by how much.

## Computing Eigenvalues

Rewrite $A\mathbf{v} = \lambda\mathbf{v}$ as $(A - \lambda I)\mathbf{v} = \mathbf{0}$.

This has a non-trivial solution iff $A - \lambda I$ is singular:

$$\det(A - \lambda I) = 0$$

This is the **characteristic polynomial** of $A$. Its roots are the eigenvalues.

**Example for 2×2:**
$$\det\begin{pmatrix}a-\lambda & b \\ c & d-\lambda\end{pmatrix} = (a-\lambda)(d-\lambda) - bc = 0$$

## Properties

- An $n \times n$ matrix has exactly $n$ eigenvalues (counting multiplicity, in $\mathbb{C}$)
- $\text{tr}(A) = \sum_i \lambda_i$
- $\det(A) = \prod_i \lambda_i$
- Eigenvectors for distinct eigenvalues are linearly independent
- Real symmetric matrices have **real eigenvalues** and **orthogonal eigenvectors**

## Eigendecomposition

If $A$ has $n$ linearly independent eigenvectors $\mathbf{v}_1, \ldots, \mathbf{v}_n$ with eigenvalues $\lambda_1, \ldots, \lambda_n$:

$$A = Q \Lambda Q^{-1}$$

where $Q = [\mathbf{v}_1 | \cdots | \mathbf{v}_n]$ and $\Lambda = \text{diag}(\lambda_1, \ldots, \lambda_n)$.

**For symmetric matrices:** $A = Q \Lambda Q^T$ (since $Q$ is orthogonal: $Q^{-1} = Q^T$)

**When does it exist?** Only for diagonalizable matrices (all $n$ eigenvectors linearly independent).

## Spectral Theorem

Any **real symmetric matrix** $A$ can be decomposed as:

$$A = Q \Lambda Q^T = \sum_i \lambda_i \mathbf{q}_i \mathbf{q}_i^T$$

where $Q$ is orthogonal and $\Lambda$ is real diagonal.

Covariance matrices and kernel matrices are symmetric positive semi-definite → always diagonalizable with real non-negative eigenvalues.

## Powers and Functions of Matrices

Eigendecomposition makes matrix powers easy:

$$A^k = Q \Lambda^k Q^{-1}$$

$$f(A) = Q f(\Lambda) Q^{-1}$$

where $f(\Lambda) = \text{diag}(f(\lambda_1), \ldots, f(\lambda_n))$.

Used in: computing matrix exponential $e^A$ for ODEs, RNNs, state-space models.

## Positive Definite Matrices

$A$ is **positive definite** (PD) iff all eigenvalues $\lambda_i > 0$.

$A$ is **positive semi-definite** (PSD) iff all $\lambda_i \geq 0$.

Equivalently: $A$ is PD iff $\mathbf{x}^T A \mathbf{x} > 0$ for all $\mathbf{x} \neq \mathbf{0}$.

**In ML:**
- Covariance matrices are always PSD
- Gram matrices $K_{ij} = k(\mathbf{x}_i, \mathbf{x}_j)$ must be PSD for valid kernel functions
- The Hessian at a local minimum is PD

## Relationship to SVD

For $A \in \mathbb{R}^{m \times n}$ with SVD $A = U\Sigma V^T$:

- Left singular vectors $U$ = eigenvectors of $AA^T$
- Right singular vectors $V$ = eigenvectors of $A^T A$
- Singular values $\sigma_i = \sqrt{\lambda_i(A^T A)}$

For square symmetric matrices: singular values = |eigenvalues|.

## Principal Component Analysis (PCA)

PCA finds the directions of maximum variance in data.

Given centered data matrix $X \in \mathbb{R}^{n \times d}$:
1. Compute covariance matrix: $C = \frac{1}{n} X^T X$
2. Eigendecompose: $C = Q\Lambda Q^T$
3. Principal components = eigenvectors $\mathbf{q}_i$ (ordered by decreasing $\lambda_i$)
4. Project: $Z = XQ_k$ where $Q_k$ = top-$k$ eigenvectors

The eigenvalue $\lambda_i$ = variance explained along $\mathbf{q}_i$.

## Spectral Methods in Graphs

For a graph with adjacency matrix $A$ or Laplacian $L = D - A$:

- Eigenvalues of $L$ (spectrum) encode graph structure
- Second smallest eigenvalue (Fiedler value) measures connectivity
- Eigenvectors of $L$ = smooth graph signals, used in **spectral GNNs**

## Eigenvalues in Optimization

The Hessian's eigenvalues determine the loss landscape curvature:

- All positive → convex local bowl → gradient descent converges
- Mix of positive/negative → saddle point
- Smallest eigenvalue → sharpest direction → sets gradient descent step size limit: $\eta < 2/\lambda_{\max}$

**Condition number** $\kappa = \lambda_{\max} / \lambda_{\min}$ determines convergence rate.

## Power Iteration

Iterative algorithm to find the dominant eigenvector:

```
v = random unit vector
repeat:
    v = Av
    v = v / ||v||
```

Converges to the eigenvector for $\lambda_{\max}$. Rate depends on $|\lambda_1 / \lambda_2|$.

Used in: PageRank, spectral clustering initialization.

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Eigendecomposition | PCA, spectral clustering, matrix functions |
| Positive definiteness | Covariance matrices, kernels, Hessian |
| SVD relationship | Low-rank approximation, PCA via SVD |
| Graph Laplacian spectrum | Spectral GNNs, graph embeddings |
| Hessian eigenvalues | Loss landscape, gradient descent convergence |
| Power iteration | PageRank, dominant directions |
| Spectral theorem | Diagonalizing covariance/kernel matrices |
