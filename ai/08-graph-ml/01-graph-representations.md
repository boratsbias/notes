# Graph Representations

Graphs can be stored and processed in multiple ways. The choice of representation affects the efficiency of operations such as neighbor lookup, matrix multiplication, and graph neural network aggregation.

## Adjacency Matrix

$A \in \{0,1\}^{n \times n}$ where $A_{ij} = 1$ if $(i,j) \in E$.

**Undirected:** $A$ is symmetric. **Directed:** $A$ is asymmetric.

**Weighted:** $A_{ij} = w_{ij}$.

**Space:** $O(n^2)$. Feasible only for dense graphs.

**Operations:**
- Check if $(i,j) \in E$: $O(1)$.
- Enumerate neighbors of $i$: $O(n)$.
- Matrix-vector multiply (used in GCN): $O(n^2)$ dense; $O(m)$ sparse.

**Self-loops:** add $I$ to $A$ to include self-connections: $\tilde{A} = A + I$. Standard in GCN to include a node's own features in the aggregation.

## Adjacency List

For each node $v$, store the list of its neighbors $\mathcal{N}(v)$.

**Space:** $O(n + m)$.

**Neighbor enumeration:** $O(d_v)$. Preferred for sparse graphs (social networks, molecules typically have $m \ll n^2$).

**COO (Coordinate) format:** store two arrays `(row_idx, col_idx)` of length $m$ listing all edges. Standard sparse format for PyTorch Geometric and DGL.

**CSR (Compressed Sparse Row):** `indptr[i]` gives the start of node $i$'s neighbors in `col_idx`. Efficient for row operations; used in scipy sparse matrices.

## Degree Matrix and Laplacian

**Degree matrix:** $D = \text{diag}(d_1, \ldots, d_n)$, where $d_i = \sum_j A_{ij}$.

**Graph Laplacian:**

$$L = D - A$$

**Properties of $L$:**
- Symmetric positive semi-definite (for undirected graphs).
- All eigenvalues $\lambda_i \geq 0$.
- Smallest eigenvalue $\lambda_1 = 0$ (constant eigenvector $\mathbf{1}$).
- Number of zero eigenvalues = number of connected components.

**Normalized Laplacian:**

$$\hat{L} = D^{-1/2} L D^{-1/2} = I - D^{-1/2} A D^{-1/2}$$

Eigenvalues in $[0, 2]$. Standard in spectral graph convolution.

**Random walk Laplacian:**

$$L_\text{rw} = D^{-1} L = I - D^{-1} A$$

$D^{-1} A$ is the random walk transition matrix; $P_{ij} = A_{ij}/d_i$ is the probability of walking from $i$ to $j$.

## Graph Feature Matrices

**Node feature matrix $X \in \mathbb{R}^{n \times d}$:** row $X_v$ is the feature vector of node $v$.

**Edge feature matrix $E \in \mathbb{R}^{m \times d_e}$:** row $E_{(u,v)}$ is the feature vector of edge $(u,v)$.

In PyTorch Geometric, graphs are represented as:
- `x`: node features, shape `[n_nodes, n_node_features]`.
- `edge_index`: COO adjacency, shape `[2, n_edges]`.
- `edge_attr`: edge features, shape `[n_edges, n_edge_features]`.

## Graph Embeddings

**Node embedding $h_v \in \mathbb{R}^d$:** a vector representation of a node capturing its local structure and features.

**Graph embedding $h_G \in \mathbb{R}^d$:** a single vector representing the whole graph, used for graph classification.

## Spectral Representation

The eigendecomposition of $L$:

$$L = U \Lambda U^T$$

where $U = [u_1, \ldots, u_n]$ are eigenvectors (the graph Fourier basis) and $\Lambda = \text{diag}(\lambda_1, \ldots, \lambda_n)$ are eigenvalues.

**Graph Fourier transform:** $\hat{x} = U^T x$ transforms a node signal $x$ to the spectral domain.

**Spectral convolution:**

$$x *_G g = U((U^T x) \odot (U^T g))$$

$O(n^2)$ complexity; does not generalize to different graph structures. Motivates spatial approximations (GCN, GraphSAGE).

## Pooling and Coarsening

For hierarchical graph representations, reduce the graph size while preserving structure.

**DiffPool:** learn soft cluster assignments $S \in \mathbb{R}^{n \times k}$; compute coarsened adjacency $A' = S^T A S$ and feature $X' = S^T X$.

**MinCUT Pool:** minimize ratio cut objective via a soft assignment matrix.

**TopK / SAGPool:** retain the top-$k$ nodes by a learnable score; drop the rest.
