# Distance Metrics

## What is a Distance Metric?

A **metric** $d: X \times X \to \mathbb{R}$ satisfies:
1. Non-negativity: $d(x, y) \geq 0$
2. Identity of indiscernibles: $d(x, y) = 0 \iff x = y$
3. Symmetry: $d(x, y) = d(y, x)$
4. Triangle inequality: $d(x, z) \leq d(x, y) + d(y, z)$

**Similarity measures** (e.g., cosine similarity) are related but don't always satisfy all metric axioms.

## Euclidean Distance (L2)

$$d(\mathbf{x}, \mathbf{y}) = \|\mathbf{x} - \mathbf{y}\|_2 = \sqrt{\sum_i (x_i - y_i)^2}$$

- Most common; natural in geometric space
- Sensitive to scale → normalize features first
- Grows with dimension (curse of dimensionality)

**Squared Euclidean:** $d^2 = \lVert\mathbf{x} - \mathbf{y}\rVert_2^2$ — often used since it avoids the square root and has the same minimizers.

## Manhattan Distance (L1, City Block)

$$d(\mathbf{x}, \mathbf{y}) = \|\mathbf{x} - \mathbf{y}\|_1 = \sum_i |x_i - y_i|$$

- More robust to outliers than L2
- Encourages sparsity (L1 regularization analogy)
- Preferred in high dimensions

## Minkowski Distance (Lp)

Generalization of L1 and L2:

$$d_p(\mathbf{x}, \mathbf{y}) = \left(\sum_i |x_i - y_i|^p\right)^{1/p}$$

- $p=1$: Manhattan
- $p=2$: Euclidean
- $p \to \infty$: Chebyshev ($\max_i |x_i - y_i|$)

## Cosine Similarity and Distance

**Similarity:**
$$\cos(\mathbf{x}, \mathbf{y}) = \frac{\mathbf{x} \cdot \mathbf{y}}{\|\mathbf{x}\| \|\mathbf{y}\|}$$

Range: $[-1, 1]$. Measures the **angle** between vectors — ignores magnitude.

**Cosine distance:** $d = 1 - \cos(\mathbf{x}, \mathbf{y})$

- Not a proper metric (violates triangle inequality in general), but widely used
- Preferred for high-dimensional sparse data: NLP embeddings, document similarity
- Equivalent to L2 distance on unit-normalized vectors

## Dot Product Similarity

$$s(\mathbf{x}, \mathbf{y}) = \mathbf{x} \cdot \mathbf{y} = \sum_i x_i y_i$$

- Used in attention mechanisms (scaled dot product)
- Combines both angle and magnitude
- Fast to compute via matrix multiplication

## Hamming Distance

Number of positions where two binary strings (or sequences) differ:

$$d_H(\mathbf{x}, \mathbf{y}) = \sum_i \mathbf{1}[x_i \neq y_i]$$

Used in: error-correcting codes, comparing categorical vectors, locality-sensitive hashing.

## Jaccard Similarity

For sets $A$ and $B$:

$$J(A, B) = \frac{|A \cap B|}{|A \cup B|}$$

**Jaccard distance:** $1 - J(A, B)$

Used in: document similarity (token sets), recommendation systems, near-duplicate detection.

## Edit Distance (Levenshtein)

Minimum number of single-character edits (insertions, deletions, substitutions) to transform one string into another.

- $O(mn)$ dynamic programming algorithm
- Used in: spell checking, NLP, DNA sequence alignment

## Mahalanobis Distance

Generalizes Euclidean distance to account for correlations between features:

$$d_M(\mathbf{x}, \mathbf{y}) = \sqrt{(\mathbf{x}-\mathbf{y})^T \Sigma^{-1} (\mathbf{x}-\mathbf{y})}$$

where $\Sigma$ is the covariance matrix.

- Reduces to Euclidean when $\Sigma = I$
- Scale-invariant and accounts for feature correlations
- Used in: anomaly detection, Gaussian distribution (exponent), metric learning

## KL Divergence (Probabilistic Distance)

Not a true metric (asymmetric), but widely used as a distributional distance:

$$D_{KL}(p \| q) = \sum_x p(x) \log \frac{p(x)}{q(x)}$$

See [Information Theory](04-information-theory.md) for full details.

## Jensen-Shannon Divergence

Symmetrized, smoothed version of KL:

$$\text{JSD}(p \| q) = \frac{1}{2} D_{KL}(p \| m) + \frac{1}{2} D_{KL}(q \| m), \quad m = \frac{p+q}{2}$$

- Bounded in $[0, 1]$ (with $\log_2$)
- $\sqrt{\text{JSD}}$ is a proper metric
- Used in: GANs (original GAN objective minimizes JSD)

## Wasserstein Distance (Earth Mover's Distance)

Minimum "work" to transform one distribution into another:

$$W_1(p, q) = \inf_{\gamma \in \Gamma(p,q)} \mathbb{E}_{(x,y)\sim\gamma}[\|x - y\|]$$

where $\Gamma(p, q)$ = set of joint distributions with marginals $p$ and $q$.

- Meaningful even when distributions have non-overlapping support (unlike KL)
- $W_1$: used in Wasserstein GAN (WGAN) for stable training
- Computationally expensive for high dimensions (approximated via Sinkhorn algorithm)

## Kernel-Based Distances

**Maximum Mean Discrepancy (MMD):**

$$\text{MMD}(p, q) = \|\mu_p - \mu_q\|_\mathcal{H}$$

where $\mu_p$ is the mean embedding of $p$ in a reproducing kernel Hilbert space.

Used in: MMD GAN, two-sample testing, domain adaptation.

## Summary Table

| Metric | Input Type | Key Property | ML Use |
|--------|-----------|--------------|--------|
| Euclidean (L2) | Vectors | Geometric distance | k-NN, clustering |
| Manhattan (L1) | Vectors | Robust to outliers | Sparse settings |
| Cosine | Vectors | Angle only | NLP embeddings |
| Dot product | Vectors | Angle + magnitude | Attention |
| Hamming | Bits/strings | Discrete | Hashing, codes |
| Jaccard | Sets | Overlap ratio | Document similarity |
| Mahalanobis | Vectors | Accounts for covariance | Anomaly detection |
| KL divergence | Distributions | Information loss | Variational inference |
| Wasserstein | Distributions | Geometry-aware | GANs |
| MMD | Distributions | Kernel-based | Domain adaptation |

## Curse of Dimensionality

In high dimensions:
- Distance concentrates: all points become nearly equidistant
- $\min d / \max d \to 1$ as $d \to \infty$
- k-NN becomes unreliable

Mitigations: dimensionality reduction (PCA, t-SNE, UMAP), cosine distance, learned metrics.

## Metric Learning

Learn a distance function $d_\theta(\mathbf{x}, \mathbf{y})$ from data (rather than using a fixed one).

**Approaches:**
- **Siamese networks:** learn embeddings where $d(x, y)$ is small iff $x$ and $y$ are similar
- **Triplet loss:** $d(a, p) + \text{margin} < d(a, n)$ (anchor, positive, negative)
- **Contrastive loss:** minimize distance between positive pairs, maximize for negatives

Used in: face recognition, few-shot learning, retrieval.
