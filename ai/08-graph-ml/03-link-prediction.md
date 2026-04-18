# Link Prediction

Link prediction estimates the likelihood of an edge existing between two nodes. It is fundamental for recommendation systems, knowledge graph completion, and drug interaction discovery.

## Problem Formulation

Given a graph $G = (V, E_\text{train})$ (a subset of all true edges), predict whether an edge $(u, v) \notin E_\text{train}$ exists in the true graph $G^* = (V, E^*)$.

**Transductive:** predict missing edges in the same graph.

**Inductive:** predict edges for new nodes or graphs not seen during training.

**Negative sampling:** since only positive edges are observed, sample non-edges as negatives. Random negatives are easy; hard negatives (structurally similar but absent edges) are more informative.

## Heuristic Methods

Before deep learning, hand-designed similarity scores between node pairs.

**Common Neighbors:**

$$s(u,v) = |\mathcal{N}(u) \cap \mathcal{N}(v)|$$

Two nodes are likely to connect if they share many neighbors. Works well for social networks.

**Jaccard Coefficient:**

$$s(u,v) = \frac{|\mathcal{N}(u) \cap \mathcal{N}(v)|}{|\mathcal{N}(u) \cup \mathcal{N}(v)|}$$

Normalizes by total neighbors to handle high-degree nodes.

**Adamic-Adar:**

$$s(u,v) = \sum_{w \in \mathcal{N}(u) \cap \mathcal{N}(v)} \frac{1}{\log |\mathcal{N}(w)|}$$

Weights common neighbors by inverse log degree: low-degree common neighbors are more informative (less likely to be common friends by chance).

**Resource Allocation:**

$$s(u,v) = \sum_{w \in \mathcal{N}(u) \cap \mathcal{N}(v)} \frac{1}{|\mathcal{N}(w)|}$$

**Katz Index:**

$$s(u,v) = \sum_{l=1}^\infty \beta^l |paths_{uv}^{(l)}| = (I - \beta A)^{-1} A$$

Counts paths of all lengths with exponential decay $\beta$. Captures global structure.

## Matrix Factorization

Factorize the adjacency matrix $A \approx ZZ^T$ or $A \approx UV^T$ into low-rank matrices.

**SVD decomposition:** $A = U \Sigma V^T$; use top-$k$ singular vectors. Equivalent to spectral node embeddings.

**Symmetric NMF:** find $Z \geq 0$ such that $A \approx ZZ^T$. Produces non-negative embeddings; corresponds to community structure.

**Matrix factorization for recommendation:** user-item bipartite graph; factorize the interaction matrix.

## Node2Vec / DeepWalk (Random Walk Embeddings)

Learn node embeddings that predict context nodes in random walks.

**DeepWalk:** generate random walks; treat each walk as a "sentence" of nodes; apply Word2Vec skip-gram to learn node embeddings.

**Node2Vec:** biased random walks. Two parameters:
- $p$: return probability (penalizes returning to previous node).
- $q$: in-out ratio (BFS-like vs. DFS-like walks).

$p < 1, q > 1$: local BFS exploration (community structure). $p > 1, q < 1$: global DFS exploration (structural equivalence).

**Link prediction:** given embeddings $z_u, z_v$, predict edge probability via $\sigma(z_u^T z_v)$ or $\sigma(h(z_u \odot z_v))$.

## GNN-Based Link Prediction

A GNN computes node embeddings $z_u, z_v$; a scoring function predicts edge probability.

**Dot product scoring:**

$$\hat{A}_{uv} = \sigma(z_u^T z_v)$$

**MLP scoring:** $\hat{A}_{uv} = \sigma(\text{MLP}([z_u; z_v]))$.

**Loss:** binary cross-entropy over positive and negative edge pairs:

$$\mathcal{L} = -\sum_{(u,v) \in E_\text{train}} \log \hat{A}_{uv} - \sum_{(u,v) \notin E} \log(1 - \hat{A}_{uv})$$

## SEAL (Subgraph Extraction for Link Prediction)

Zhang & Chen (2018). Extract the $h$-hop enclosing subgraph around each target link $(u,v)$; apply a GNN to the subgraph to score the link.

The subgraph provides structural information beyond node embeddings: is the pair a bridge between communities? Are they in the same clique?

**Double Radius Node Labeling (DRNL):** label each node in the subgraph with its distance to $u$ and $v$. Encodes structural role w.r.t. the target link.

SEAL significantly outperforms embedding-based methods on citation and social network datasets.

## Evaluation

**Area Under the ROC Curve (AUC):** fraction of (positive, negative) pairs where the positive is scored higher.

**Average Precision (AP):** area under precision-recall curve.

**Hits@K:** fraction of positive edges ranked in the top-$K$ among all negatives.

**MRR (Mean Reciprocal Rank):** $\frac{1}{\lvert E_\text{test} \rvert} \sum_{(u,v) \in E_\text{test}} \frac{1}{\text{rank}(v)}$ where rank is computed among all candidate nodes for a given source $u$.

OGB (Open Graph Benchmark) uses ranking-based metrics with hard negative sampling to avoid trivially easy random negatives.
