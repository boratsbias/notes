# Node Classification

Node classification assigns a label to each node in a graph, leveraging both node features and the graph structure. It is the most studied task in graph machine learning.

## Problem Setup

Given a graph $G = (V, E)$ with node features $X \in \mathbb{R}^{n \times d}$ and partial labels $Y_L = \{y_v : v \in V_L\}$ for a labeled subset $V_L \subset V$, predict labels for unlabeled nodes $V \setminus V_L$.

**Transductive setting:** the graph and all node features (including unlabeled nodes) are seen during training. The model is not expected to generalize to unseen nodes. Standard in citation networks (Cora, Citeseer, PubMed).

**Inductive setting:** the model must generalize to new nodes/graphs not seen during training. Required for production systems (new users, new molecules).

## Benchmarks

| Dataset | Nodes | Edges | Classes | Task |
|---------|-------|-------|---------|------|
| Cora | 2708 | 5429 | 7 | Citation topic |
| Citeseer | 3327 | 4732 | 6 | Citation topic |
| PubMed | 19717 | 44338 | 3 | Citation topic |
| ogbn-arxiv | 169k | 1.2M | 40 | Paper category |
| ogbn-products | 2.5M | 61M | 47 | Product category |

**Evaluation:** accuracy or macro-F1 on test nodes.

## Label Propagation

A simple and effective semi-supervised baseline. Propagate known labels to unlabeled nodes along edges.

**Iterative label propagation:**

$$Y^{(t+1)} = \alpha \tilde{A} Y^{(t)} + (1-\alpha) Y^{(0)}$$

where $\tilde{A} = D^{-1/2} A D^{-1/2}$ is the normalized adjacency, $\alpha \in (0,1)$ is a retention factor, and $Y^{(0)}$ has known labels for $V_L$ and zeros elsewhere.

Converges to a closed-form solution: $(I - \alpha \tilde{A})^{-1} (1-\alpha) Y^{(0)}$.

**Assumption:** connected nodes tend to have the same label (homophily). Fails for heterophilic graphs.

## Graph Neural Network Approach

A $K$-layer GNN computes node representations by aggregating information from $K$-hop neighborhoods:

$$h_v^{(0)} = X_v$$

$$h_v^{(k)} = \text{UPDATE}^{(k)}\!\left(h_v^{(k-1)},\, \text{AGGREGATE}^{(k)}\!\left(\{h_u^{(k-1)} : u \in \mathcal{N}(v)\}\right)\right)$$

Final representation: $z_v = h_v^{(K)}$. Classification: $\hat{y}_v = \text{softmax}(W z_v)$.

**Loss:** cross-entropy on labeled nodes only:

$$\mathcal{L} = -\sum_{v \in V_L} \log \hat{y}_{v, y_v}$$

See [Graph Neural Networks](05-graph-neural-networks) for specific architectures (GCN, GraphSAGE, GAT).

## Homophily vs. Heterophily

**Homophily:** connected nodes tend to have the same label. Most citation/social graphs. Standard GNNs exploit homophily well.

**Heterophily:** connected nodes tend to have different labels. Fraud detection, certain social networks (opposites attract).

**Homophily ratio:**

$$h = \frac{|\{(u,v) \in E : y_u = y_v\}|}{|E|}$$

$h \approx 1$: strong homophily. $h \approx 0$: strong heterophily.

**Models for heterophily:**
- **H2GCN:** separate ego (self) and neighbor aggregations; use higher-order neighborhoods.
- **GPRGNN:** learn signed aggregation weights per hop. Allows the model to amplify or suppress neighbor information.
- **ACM-GCN:** combine low-pass (neighbor) and high-pass (difference from neighbor) filtering.

## Scalability

Standard GNNs face a neighbor explosion problem: the computation graph of a node grows exponentially with depth ($\lvert\mathcal{N}^K(v)\rvert = O(d_\text{avg}^K)$).

**GraphSAGE sampling:** sample a fixed number of neighbors at each hop. Enables minibatch training.

**Cluster-GCN:** partition the graph into clusters; train on full subgraphs (clusters). Reduces inter-cluster edges sampled; stable gradient estimates.

**GraphSAINT:** sample random subgraphs (node, edge, or random walk based); train GNN on each subgraph with importance sampling correction.

## Self-Supervised Pretraining for Nodes

When labels are scarce, pretrain GNNs with self-supervised objectives:

**Contrastive node learning:** create two augmented views of the graph (feature masking, edge dropping); maximize agreement between the same node's representations across views (GRACE, GraphCL).

**Node feature prediction:** mask node features; train GNN to reconstruct them (GPT-Graph, GraphMAE).

**Deep Graph Infomax:** maximize mutual information between local node representations and a global summary vector.
