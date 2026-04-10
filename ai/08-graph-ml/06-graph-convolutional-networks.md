# Graph Convolutional Networks

Graph Convolutional Networks (GCN) generalize convolution from regular grids (images) to irregular graph structures, enabling efficient learning of node representations from both features and topology.

## Spectral Graph Convolution

Convolution on graphs can be defined in the spectral domain via the graph Fourier transform.

For signal $x \in \mathbb{R}^n$ (one feature per node), convolution with filter $g$:

$$x *_G g = U g_\theta(\Lambda) U^T x$$

where $U$ contains the eigenvectors of $L = D - A$ and $g_\theta(\Lambda) = \text{diag}(\theta_0, \ldots, \theta_{n-1})$ is a diagonal filter parameterized by $\theta$.

**Problems:**
- $O(n^2)$ computation (eigen-decomposition of $L$).
- $n$ filter parameters (one per eigenvalue).
- Not spatially localized; does not generalize across graphs.

## ChebNet: Polynomial Approximation

Defferrard et al. (2016). Approximate the filter with a degree-$K$ Chebyshev polynomial:

$$g_\theta(\tilde{\Lambda}) \approx \sum_{k=0}^{K} \theta_k T_k(\tilde{\Lambda})$$

where $\tilde{\Lambda} = \frac{2}{\lambda_\max}\Lambda - I$ (rescaled to $[-1,1]$) and $T_k$ are Chebyshev polynomials ($T_0 = 1$, $T_1 = x$, $T_k = 2x T_{k-1} - T_{k-2}$).

**Advantages:**
- $O(K m)$ complexity (no eigen-decomposition).
- $K$-localized: aggregates exactly $K$-hop neighborhoods.
- $K$ learnable parameters per filter.

## GCN: First-Order Approximation

Kipf & Welling (2017). Simplify ChebNet to $K = 1$ (first order) and $\lambda_\max \approx 2$:

$$g_\theta * x \approx \theta_0 x + \theta_1 (L - I) x = \theta_0 x - \theta_1 D^{-1/2} A D^{-1/2} x$$

Further simplify by setting $\theta = \theta_0 = -\theta_1$:

$$g_\theta * x \approx \theta (I + D^{-1/2} A D^{-1/2}) x$$

**Renormalization trick:** replace $I + D^{-1/2} A D^{-1/2}$ with $\tilde{D}^{-1/2} \tilde{A} \tilde{D}^{-1/2}$ where $\tilde{A} = A + I$ (add self-loops) and $\tilde{D}_{ii} = \sum_j \tilde{A}_{ij}$.

**GCN layer:**

$$H^{(l+1)} = \sigma\!\left(\tilde{D}^{-1/2} \tilde{A} \tilde{D}^{-1/2} H^{(l)} W^{(l)}\right)$$

$H^{(l)} \in \mathbb{R}^{n \times d_l}$: node representations at layer $l$.
$W^{(l)} \in \mathbb{R}^{d_l \times d_{l+1}}$: learnable weight matrix.
$\tilde{D}^{-1/2} \tilde{A} \tilde{D}^{-1/2}$: symmetric normalized adjacency with self-loops (precomputed).

**Per-node form:**

$$h_v^{(l+1)} = \sigma\!\left(W^{(l)} \sum_{u \in \mathcal{N}(v) \cup \{v\}} \frac{h_u^{(l)}}{\sqrt{d_v+1}\sqrt{d_u+1}}\right)$$

Degree normalization prevents aggregated features from scaling with node degree.

## Properties of GCN

**Low-pass filtering:** the normalized adjacency $\hat{A} = \tilde{D}^{-1/2} \tilde{A} \tilde{D}^{-1/2}$ has eigenvalues in $[0,1]$. Repeated multiplication by $\hat{A}$ is a low-pass filter: it smooths the signal, bringing connected nodes' features closer. This is why GCN works well under homophily.

**Semi-supervised classification:** use labeled nodes only in the cross-entropy loss; propagate information via GCN to unlabeled nodes.

**Precomputation:** since $\hat{A}$ does not depend on parameters, we can precompute $\hat{A}^K X$ before training. SGC (Simple Graph Convolution) removes non-linearities between layers; the entire model becomes logistic regression on $\hat{A}^K X$.

## GraphSAGE

Hamilton et al. (2017). Inductive GNN with neighborhood sampling.

**Sampling:** for each node, uniformly sample a fixed number $S_k$ of neighbors at each layer $k$. Bounded computation regardless of node degree.

**Aggregation options:** mean, LSTM, max-pool.

**Mean aggregation:**

$$h_v^{(k)} = \sigma\!\left(W^{(k)} \cdot [h_v^{(k-1)}, \text{mean}(\{h_u^{(k-1)}: u \in \mathcal{N}_s(v)\})]\right)$$

$\mathcal{N}_s(v)$: sampled neighbors of $v$.

**Inductive:** new nodes not seen during training are handled by sampling their neighborhoods and running the GNN forward pass. Standard for production graph ML systems.

## APPNP

Klicpera et al. (2019). Separate feature transformation (MLP) from propagation (personalized PageRank).

**Personalized PageRank propagation:**

$$H^{(k+1)} = (1-\alpha) \hat{A} H^{(k)} + \alpha H^{(0)}$$

where $H^{(0)}$ is the MLP output on raw features and $\alpha$ is the teleport probability.

At convergence: $H^* = \alpha (I - (1-\alpha)\hat{A})^{-1} H^{(0)}$ (the personalized PageRank of $H^{(0)}$).

This effectively aggregates information from the entire graph while ensuring the output is anchored to the node's own features ($H^{(0)}$). Avoids over-smoothing for large $K$.

## SIGN (Scalable Inception Graph Neural Networks)

Precompute multi-hop aggregations $\hat{A}^k X$ for $k = 1, \ldots, K$; concatenate with $X$; apply an MLP. Fully parallelizable; no neighbor sampling needed at training time. Scales to billion-edge graphs.
