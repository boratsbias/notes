# Unsupervised Learning

## Concept / Definition

Unsupervised learning extracts structure from unlabeled samples

Dataset
$$D = \{x_i\}_{i=1}^n, \qquad x_i \in \mathbb{R}^d$$

Goals: clustering, density estimation, dimensionality reduction, latent factor discovery

## Mathematical Formulation

Density estimation
$$\hat{\theta} = \arg\max_\theta \sum_{i=1}^n \log p_\theta(x_i)$$

Clustering as within-cluster distortion minimization
$$\min_{\{C_k,\mu_k\}_{k=1}^K} \sum_{k=1}^K \sum_{x_i \in C_k} \|x_i - \mu_k\|_2^2$$

PCA as variance maximization
$$\max_{W \in \mathbb{R}^{d \times m}} \operatorname{tr}(W^\top S W) \quad \text{s.t.} \quad W^\top W = I$$
where
$$S = \frac{1}{n} \sum_{i=1}^n (x_i - \bar{x})(x_i - \bar{x})^\top$$

## Conditions / Properties

PCA stationarity from eigenvalue problem
$$S w = \lambda w$$

k-means decreases objective monotonically under alternating minimization

Identifiability often weak: latent variables may be recoverable only up to permutation, rotation, or scaling

Clustering quality without labels needs internal criteria such as silhouette or likelihood

## Algorithms / Methods

<table>
<tr><th>Method</th><th>Objective</th><th>Key update</th></tr>
<tr><td>k-means</td><td>minimize within-cluster SSE</td><td>assign to nearest centroid, recompute means</td></tr>
<tr><td>GMM</td><td>maximize mixture likelihood</td><td>EM updates for responsibilities</td></tr>
<tr><td>PCA</td><td>maximize projected variance</td><td>top eigenvectors of covariance</td></tr>
<tr><td>Hierarchical clustering</td><td>linkage criterion</td><td>greedy merges/splits</td></tr>
<tr><td>DBSCAN</td><td>density connectivity</td><td>expand from core points</td></tr>
</table>

k-means assignment
$$c_i = \arg\min_{k} \|x_i - \mu_k\|_2^2$$

k-means centroid update
$$\mu_k = \frac{1}{|C_k|} \sum_{x_i \in C_k} x_i$$

GMM responsibility
$$\gamma_{ik} = \frac{\pi_k \mathcal{N}(x_i \mid \mu_k, \Sigma_k)}{\sum_{j=1}^K \pi_j \mathcal{N}(x_i \mid \mu_j, \Sigma_j)}$$

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Extension</th><th>Use case</th></tr>
<tr><td>Spectral clustering</td><td>graph Laplacian embedding</td><td>nonconvex cluster geometry</td></tr>
<tr><td>Kernel PCA</td><td>nonlinear feature map</td><td>manifold structure</td></tr>
<tr><td>ICA</td><td>independent latent sources</td><td>source separation</td></tr>
<tr><td>NMF</td><td>nonnegative factors</td><td>parts-based decomposition</td></tr>
<tr><td>Autoencoder</td><td>neural reconstruction</td><td>nonlinear representation learning</td></tr>
</table>

## Practical Notes

Distance-based methods depend strongly on scaling

For high dimension
$$\|x_i - x_j\|_2$$
may concentrate, weakening nearest-neighbor intuition

Choice of $K$ in clustering can use elbow, BIC, AIC, or silhouette, but no universal optimum exists

Unsupervised objectives may not align with downstream predictive task
