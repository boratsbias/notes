# Graph Attention Networks

Graph Attention Networks (GAT) compute edge weights dynamically via self-attention rather than using fixed normalized weights. This allows the model to assign different importance to different neighbors during aggregation.

## Motivation

GCN uses fixed normalized weights $\frac{1}{\sqrt{d_u d_v}}$. These are determined by the graph topology alone; the model cannot learn to focus on more informative neighbors.

**Attention:** learn importance weights $\alpha_{uv}$ based on the features of the node pair $(u,v)$. More informative neighbors receive higher weight.

## GAT Layer

**Step 1: Compute attention logits.** For each edge $(u,v)$, apply a shared attention mechanism $a: \mathbb{R}^{d'} \times \mathbb{R}^{d'} \to \mathbb{R}$:

$$e_{uv} = a(W h_u, W h_v) = \text{LeakyReLU}(\mathbf{a}^T [W h_u \| W h_v])$$

$W \in \mathbb{R}^{d' \times d}$: shared linear transformation. $\mathbf{a} \in \mathbb{R}^{2d'}$: attention vector. $\|$: concatenation.

**Step 2: Normalize with softmax** over the neighborhood of $v$:

$$\alpha_{uv} = \frac{\exp(e_{uv})}{\sum_{k \in \mathcal{N}(v) \cup \{v\}} \exp(e_{kv})}$$

**Step 3: Weighted aggregation:**

$$h_v' = \sigma\!\left(\sum_{u \in \mathcal{N}(v) \cup \{v\}} \alpha_{uv} W h_u\right)$$

## Multi-Head Attention

Run $K$ independent attention heads; concatenate (or average) their outputs:

$$h_v' = \|_{k=1}^K \sigma\!\left(\sum_{u \in \mathcal{N}(v) \cup \{v\}} \alpha_{uv}^k W^k h_u\right)$$

For the final layer, average instead of concatenate:

$$h_v' = \sigma\!\left(\frac{1}{K}\sum_{k=1}^K \sum_{u \in \mathcal{N}(v) \cup \{v\}} \alpha_{uv}^k W^k h_u\right)$$

Multiple heads allow the model to attend to different types of neighbor relationships simultaneously.

## GATv2

Brody et al. (2022). Standard GAT has a static attention problem: the ranking of neighbors by attention weight is fixed regardless of the query node's features.

**Problem in original GAT:** the ranking of $e_{uv}$ depends only on $W h_u$ (independent of $h_v$), making it equivalent to a linear function of $h_u$ for a fixed $h_v$.

**GATv2 fix:** apply the non-linearity after adding the two projections:

$$e_{uv} = \mathbf{a}^T \text{LeakyReLU}(W [h_u \| h_v])$$

Now the attention is dynamic: the ranking of neighbors changes depending on $h_v$. GATv2 is strictly more expressive than GAT.

## Properties and Behavior

**Attention weights as interpretability:** the learned $\alpha_{uv}$ can be inspected to understand which edges the model relies on. Visualizing high-attention edges reveals the most informative relationships.

**Caveats:** attention does not always correlate with importance for prediction. Gradient-based attribution is often more faithful than attention-based explanations.

**Sparse attention:** in large graphs, restrict attention to the existing edges (local neighborhood). GATv2 only computes attention over $\mathcal{N}(v)$, not all $n$ nodes; $O(m)$ complexity.

**Global attention (Transformer-style):** compute attention over all pairs of nodes. $O(n^2)$ complexity; feasible only for small graphs. Used in Graphormer.

## Edge Features in Attention

Extend the attention mechanism to incorporate edge features $e_{uv}$:

$$\text{logit}_{uv} = \mathbf{a}^T \text{LeakyReLU}(W_u h_u + W_v h_v + W_e e_{uv})$$

Edge features are especially important for molecular graphs (bond type, distance) and knowledge graphs (relation type).

## Comparison with GCN

| Property | GCN | GAT |
|----------|-----|-----|
| Edge weights | Fixed (degree-based) | Learned (feature-based) |
| Neighbor importance | Topology only | Features + topology |
| Parameters | $O(d \cdot d')$ | $O(d \cdot d' + 2d')$ per head |
| Interpretability | None | Attention weights |
| Inductive | Yes | Yes |
| Over-smoothing | More prone | Similar |

GAT generally outperforms GCN on benchmark node classification tasks, particularly when there is heterophily or when neighbors vary significantly in informativeness.

## Applications

**Molecular property prediction:** different atoms and bonds contribute differently to a molecule's property. Attention learns to focus on the functional groups most relevant to the property.

**Knowledge graph reasoning:** given a source entity and a relation, attention over neighbors helps traverse multi-hop reasoning paths.

**Traffic forecasting:** road segments influence each other; attention learns which road segments are most correlated with the target segment's traffic.
