# Graph Classification

Graph classification assigns a label to an entire graph. It is central to molecular property prediction, protein function classification, and social network analysis.

## Problem Setup

Given a dataset of labeled graphs $\{(G_1, y_1), \ldots, (G_N, y_N)\}$, learn a function $f: G \mapsto y$.

**Molecular graphs:** atoms are nodes (with features: element, charge, hybridization); bonds are edges (with features: bond type). Predict properties: toxicity, solubility, drug-likeness, reaction yield.

**Social graphs:** nodes are users; edges are interactions. Predict community type, spam, or sentiment.

## Readout (Graph Pooling)

A GNN computes node representations $\{h_v^{(K)}\}$. To get a graph-level representation, aggregate all node representations:

**Sum pooling:**

$$h_G = \sum_{v \in V} h_v^{(K)}$$

**Mean pooling:**

$$h_G = \frac{1}{|V|} \sum_{v \in V} h_v^{(K)}$$

**Max pooling:**

$$h_G = \max_{v \in V} h_v^{(K)} \quad \text{(elementwise)}$$

**Sum is more expressive than mean:** sum can distinguish graphs with different numbers of nodes with the same feature distribution; mean cannot.

## Hierarchical Pooling

Flat global pooling loses structural information (topology of clusters). Hierarchical pooling coarsens the graph in stages, analogous to CNN pooling over spatial feature maps.

**DiffPool (Ying et al. 2018):** at each layer, learn a soft cluster assignment matrix $S^{(l)} \in \mathbb{R}^{n_l \times n_{l+1}}$ via a GNN:

$$A^{(l+1)} = S^{(l)T} A^{(l)} S^{(l)}$$
$$X^{(l+1)} = S^{(l)T} H^{(l)}$$

The cluster assignment GNN and the embedding GNN are trained jointly with the classification loss + an auxiliary link prediction loss (encourage assignment to capture structure).

**MinCUT Pool:** minimize the ratio cut:

$$\min_S \frac{\text{tr}(S^T L S)}{\text{tr}(S^T D S)}$$

## Weisfeiler-Leman (WL) Subtree Kernel

A classical graph kernel (not GNN-based). Iteratively relabels nodes by hashing their neighborhood label multisets:

$$l_v^{(k)} = \text{hash}\!\left(l_v^{(k-1)},\, \{\!\{l_u^{(k-1)}: u \in \mathcal{N}(v)\}\!\}\right)$$

After $K$ iterations, represent the graph as the multiset of all node labels across all iterations. Compare graphs via kernel on these multisets.

WL-1 is equivalent to the expressivity of standard message-passing GNNs. WL-$k$ (higher-order) is more expressive but exponentially more expensive.

## GIN (Graph Isomorphism Network)

Xu et al. (2019). Designed to be maximally expressive within the 1-WL hierarchy.

**Key insight:** sum aggregation + MLP update is as powerful as the WL test; mean or max aggregation is strictly weaker.

$$h_v^{(k)} = \text{MLP}^{(k)}\!\left((1+\epsilon^{(k)}) h_v^{(k-1)} + \sum_{u \in \mathcal{N}(v)} h_u^{(k-1)}\right)$$

$\epsilon$ is a learnable scalar (or fixed to 0). The MLP maps the sum to a representation that can distinguish any multisets distinguishable by WL.

**Graph-level readout:**

$$h_G = \text{CONCAT}\!\left(\text{READOUT}(\{h_v^{(k)}: v \in V\})\, \text{for } k = 0, \ldots, K\right)$$

Concatenating representations across all layers (not just the last) captures structure at multiple scales.

## Benchmarks

**TU Datasets:** MUTAG, RDT-B, IMDB-B/M, COLLAB. Classical small-scale benchmarks. Many have no node features; topology alone is the signal.

**OGB-molhiv / OGB-molpcba:** molecular property prediction from SMILES. Standard large-scale molecular benchmarks. Uses ROC-AUC.

**ZINC:** molecular solubility regression. Tests the ability to capture subtle structural differences.

## Evaluation

**Classification:** accuracy, ROC-AUC (for imbalanced molecular datasets).

**Regression:** MAE or RMSE (e.g., molecular property prediction).

**Data splits:** scaffold splits (OGB) are more realistic than random splits for molecules: test set contains scaffolds (core structures) not seen in training.

## Beyond WL Expressivity

Standard message-passing GNNs cannot distinguish certain non-isomorphic graphs (e.g., regular graphs). Approaches to improve expressivity:

**Higher-order GNNs (k-GNN):** operate on $k$-tuples of nodes; can distinguish graphs indistinguishable by WL. Exponential complexity in $k$.

**Random node features:** assign random features to nodes before running GNN. Breaks symmetry; allows distinguishing isomorphic-looking structures. Random but effective.

**Structural encodings:** add topological features (degree, cycle membership, random walk landing probabilities) as extra node features before the GNN.

**SignNet / BasisNet:** use eigenvectors of the graph Laplacian as positional encodings. Sign-equivariant or basis-equivariant MLPs process these features robustly.
