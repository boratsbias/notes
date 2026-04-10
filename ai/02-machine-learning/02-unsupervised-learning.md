# Unsupervised Learning

## Concept / Definition

Unsupervised learning extracts structure from unlabeled samples

Dataset
$$
D = \{x_i\}_{i=1}^n, \qquad x_i \in \mathbb{R}^d
$$

Goals: clustering, density estimation, dimensionality reduction, latent factor discovery

## Mathematical Formulation

Density estimation
$$
\hat{\theta} = \arg\max_\theta \sum_{i=1}^n \log p_\theta(x_i)
$$

Clustering as within-cluster distortion minimization
$$
\min_{\{C_k,\mu_k\}_{k=1}^K} \sum_{k=1}^K \sum_{x_i \in C_k} \|x_i - \mu_k\|_2^2
$$

PCA as variance maximization
$$
\max_{W \in \mathbb{R}^{d \times m}} \operatorname{tr}(W^\top S W)
\quad \text{s.t.} \quad W^\top W = I
$$
where
$$
S = \frac{1}{n} \sum_{i=1}^n (x_i - \bar{x})(x_i - \bar{x})^\top
$$

## Conditions / Properties

PCA stationarity from eigenvalue problem
$$
S w = \lambda w
$$

k-means decreases objective monotonically under alternating minimization

Identifiability often weak: latent variables may be recoverable only up to permutation, rotation, or scaling

Clustering quality without labels needs internal criteria such as silhouette or likelihood

## Algorithms / Methods

| Method | Objective | Key update |
|---|---|---|
| k-means | minimize within-cluster SSE | assign to nearest centroid, recompute means |
| GMM | maximize mixture likelihood | EM updates for responsibilities |
| PCA | maximize projected variance | top eigenvectors of covariance |
| Hierarchical clustering | linkage criterion | greedy merges/splits |
| DBSCAN | density connectivity | expand from core points |

k-means assignment
$$
c_i = \arg\min_{k} \|x_i - \mu_k\|_2^2
$$

k-means centroid update
$$
\mu_k = \frac{1}{|C_k|} \sum_{x_i \in C_k} x_i
$$

GMM responsibility
$$
\gamma_{ik} = \frac{\pi_k \mathcal{N}(x_i \mid \mu_k, \Sigma_k)}{\sum_{j=1}^K \pi_j \mathcal{N}(x_i \mid \mu_j, \Sigma_j)}
$$

## Variants / Extensions

| Variant | Extension | Use case |
|---|---|---|
| Spectral clustering | graph Laplacian embedding | nonconvex cluster geometry |
| Kernel PCA | nonlinear feature map | manifold structure |
| ICA | independent latent sources | source separation |
| NMF | nonnegative factors | parts-based decomposition |
| Autoencoder | neural reconstruction | nonlinear representation learning |

## Practical Notes

Distance-based methods depend strongly on scaling

For high dimension
$$
\|x_i - x_j\|_2
$$
may concentrate, weakening nearest-neighbor intuition

Choice of $K$ in clustering can use elbow, BIC, AIC, or silhouette, but no universal optimum exists

Unsupervised objectives may not align with downstream predictive task
