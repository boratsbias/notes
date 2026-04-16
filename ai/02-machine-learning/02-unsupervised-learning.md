# Unsupervised Learning

Unsupervised learning discovers structure in data $\{x_i\}_{i=1}^n$ without any labels. The goal is to model the underlying distribution $P(X)$ or find meaningful groupings, representations, or lower-dimensional embeddings.

## Clustering

Groups data points such that intra-cluster similarity is high and inter-cluster similarity is low.

### k-Means

Partitions $n$ points into $k$ clusters by minimizing within-cluster variance:

$$\min_{\{C_k\}, \{\mu_k\}} \sum_{k=1}^K \sum_{x_i \in C_k} \|x_i - \mu_k\|^2$$

**Algorithm (Lloyd's):**
1. Initialize $k$ centroids (random, k-means++, etc.)
2. Assign each point to nearest centroid.
3. Recompute centroids as mean of assigned points.
4. Repeat until convergence.

**Complexity:** $O(nkd)$ per iteration. Converges to local optimum; sensitive to initialization.

**Choosing $k$:** elbow method on inertia, silhouette score, gap statistic.

### DBSCAN

Density-Based Spatial Clustering of Applications with Noise. Does not require specifying $k$; discovers clusters of arbitrary shape.

**Key parameters:**
- $\epsilon$: neighborhood radius
- $\text{minPts}$: minimum neighbors to be a core point

**Point types:**
- **Core point:** at least minPts points within $\epsilon$-neighborhood.
- **Border point:** within $\epsilon$ of a core point but not a core itself.
- **Noise point:** neither core nor border.

**Complexity:** $O(n \log n)$ with spatial indexing.

### Hierarchical Clustering

Builds a tree (dendrogram) of nested clusters.

- **Agglomerative (bottom-up):** each point starts as its own cluster; merge closest pairs.
- **Divisive (top-down):** start with all points; recursively split.

**Linkage criteria:**

| Linkage | Distance Between Clusters |
|---------|--------------------------|
| Single | Minimum pairwise distance |
| Complete | Maximum pairwise distance |
| Average | Mean pairwise distance |
| Ward | Minimizes variance increase on merge |

### Gaussian Mixture Models (GMM)

Assumes data is generated from a mixture of $K$ Gaussians:

$$P(x) = \sum_{k=1}^K \pi_k \mathcal{N}(x; \mu_k, \Sigma_k)$$

Fit via **EM algorithm:**
- **E-step:** compute soft cluster assignments $\gamma_{ik} = P(z_i = k \mid x_i)$
- **M-step:** update $\pi_k$, $\mu_k$, $\Sigma_k$ using weighted MLEs

Generalizes k-Means (which is GMM with spherical, equal-variance clusters and hard assignments).

### Cluster Evaluation Metrics

| Metric | Notes |
|--------|-------|
| Silhouette score | Compares intra-cluster to nearest-cluster distance. Range $[-1, 1]$, higher is better. |
| Davies-Bouldin index | Ratio of within-cluster scatter to between-cluster separation. Lower is better. |
| Adjusted Rand Index (ARI) | Compares to ground truth if available. |
| Normalized Mutual Information (NMI) | Information-theoretic comparison to ground truth. |

## Dimensionality Reduction

Maps high-dimensional data to a lower-dimensional space while preserving structure.

### Principal Component Analysis (PCA)

Finds orthogonal directions of maximum variance.

**Objective:** find projection matrix $W \in \mathbb{R}^{d \times k}$ such that variance in projected space is maximized.

**Solution:** eigenvectors of the covariance matrix $\Sigma = \frac{1}{n} X^T X$ corresponding to the $k$ largest eigenvalues.

**Equivalently:** via SVD of the centered data matrix $X = U \Sigma V^T$; principal components are columns of $V$.

**Explained variance ratio:**

$$\text{EVR}_j = \frac{\lambda_j}{\sum_i \lambda_i}$$

Cumulative EVR guides choice of $k$.

### t-SNE

t-Distributed Stochastic Neighbor Embedding. Nonlinear reduction for visualization (typically $k = 2$ or $3$).

Defines joint probabilities $p_{ij}$ (Gaussian in high-dim) and $q_{ij}$ (Student-t in low-dim), then minimizes their KL divergence:

$$\mathcal{L} = \text{KL}(P \| Q) = \sum_{i \neq j} p_{ij} \log \frac{p_{ij}}{q_{ij}}$$

Heavy-tailed $q_{ij}$ prevents crowding. Not suitable for new points (no projection formula). Perplexity hyperparameter controls neighborhood size.

### UMAP

Uniform Manifold Approximation and Projection. Faster than t-SNE; preserves more global structure. Constructs a fuzzy topological representation, then finds low-dimensional equivalent.

| Method | Global structure | Scalability | New points |
|--------|-----------------|-------------|-----------|
| PCA | Yes | $O(nd^2)$ | Yes |
| t-SNE | Partial | $O(n^2)$ (approx $O(n \log n)$) | No |
| UMAP | Better than t-SNE | $O(n)$ approx | Yes |

## Density Estimation

Models the underlying data distribution $P(X)$.

### Kernel Density Estimation (KDE)

Non-parametric estimate:

$$\hat{p}(x) = \frac{1}{nh} \sum_{i=1}^n K\!\left(\frac{x - x_i}{h}\right)$$

Common kernels: Gaussian, Epanechnikov. Bandwidth $h$ controls smoothness (bias-variance tradeoff).

### Autoencoders

Neural network encoder $z = f_\phi(x)$ and decoder $\hat{x} = g_\theta(z)$ trained to minimize reconstruction loss:

$$\mathcal{L} = \frac{1}{n}\sum_{i=1}^n \|x_i - g_\theta(f_\phi(x_i))\|^2$$

Bottleneck dimension forces a compressed representation. Variants: sparse autoencoders, denoising autoencoders, variational autoencoders (VAEs).

## Practical Considerations

- **Curse of dimensionality:** distances become uninformative in high dimensions; apply dimensionality reduction before clustering.
- **Feature scaling:** required for distance-based methods (k-Means, DBSCAN, KDE).
- **Evaluating without labels:** use internal metrics (silhouette, Davies-Bouldin) or downstream task performance.
