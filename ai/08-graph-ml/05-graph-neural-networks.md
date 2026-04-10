# Graph Neural Networks

Graph Neural Networks (GNNs) generalize deep learning to graph-structured data by learning node representations through iterative neighborhood aggregation. They are the dominant approach for all graph ML tasks.

## The Message Passing Framework

A GNN computes node representations through $K$ rounds of message passing. At each round $k$:

1. **Message:** each node $u$ sends a message to its neighbor $v$:
   $$m_{u \to v}^{(k)} = \text{MESSAGE}^{(k)}(h_u^{(k-1)}, h_v^{(k-1)}, e_{uv})$$

2. **Aggregate:** node $v$ aggregates messages from all neighbors:
   $$m_v^{(k)} = \text{AGGREGATE}^{(k)}\!\left(\{m_{u \to v}^{(k)}: u \in \mathcal{N}(v)\}\right)$$

3. **Update:** node $v$ updates its representation:
   $$h_v^{(k)} = \text{UPDATE}^{(k)}(h_v^{(k-1)}, m_v^{(k)})$$

**Initialization:** $h_v^{(0)} = X_v$ (node features).

**Output:** after $K$ layers, $h_v^{(K)}$ summarizes the $K$-hop neighborhood of $v$.

## Receptive Field and Depth

After $K$ message passing steps, each node has "seen" all nodes within $K$ hops.

**Over-smoothing:** with too many layers ($K \gg$ graph diameter), all node representations converge to the same value. The graph signal becomes over-smoothed; node representations become indistinguishable.

**Practical depth:** most GNNs use $K = 2$–$4$ layers. Deeper networks require residual connections, initial residual connections (GCNII), or dropedge to avoid over-smoothing.

## Aggregation Functions

The choice of AGGREGATE determines what GNNs can represent.

**Sum:** $m_v = \sum_{u \in \mathcal{N}(v)} h_u$. Injective on multisets; most expressive (GIN).

**Mean:** $m_v = \frac{1}{|\mathcal{N}(v)|}\sum_{u \in \mathcal{N}(v)} h_u$. Cannot distinguish different-size neighborhoods with the same distribution.

**Max:** $m_v = \max_{u \in \mathcal{N}(v)} h_u$ (elementwise). Cannot count neighbors.

**Attention:** $m_v = \sum_{u} \alpha_{uv} h_u$ with learned attention weights. See [Graph Attention Networks](07-graph-attention-networks).

**LSTM:** treat neighbor set as a sequence (random order); apply LSTM aggregation. Expressive but order-dependent.

**Principal Neighbourhood Aggregation (PNA):** apply multiple aggregators (mean, max, min, std) and multiple scalers ($1$, $\log(d+1)$, $1/\log(d+1)$); concatenate. More expressive than any single aggregator.

## Update Functions

**Linear:** $h_v^{(k)} = W [h_v^{(k-1)}; m_v^{(k)}]$. Simple; GCN style.

**MLP:** $h_v^{(k)} = \text{MLP}([h_v^{(k-1)}; m_v^{(k)}])$. More expressive.

**Residual:** $h_v^{(k)} = h_v^{(k-1)} + \text{MLP}([h_v^{(k-1)}; m_v^{(k)}])$. Stabilizes deep GNNs.

**GRU update (GGNN):** treat the node update as a GRU with $h_v^{(k-1)}$ as the hidden state and $m_v^{(k)}$ as the input.

## Equivariance and Invariance

**Permutation equivariance:** if nodes are reordered, the output representations are reordered accordingly. Standard for node-level tasks.

$$f(PX, PAP^T) = P f(X, A) \quad \text{for any permutation matrix } P$$

**Permutation invariance:** the output is unchanged under node reordering. Required for graph-level tasks (graph classification).

$$f(PX, PAP^T) = f(X, A)$$

Achieved by applying an invariant readout (sum, mean, max) after the equivariant GNN.

## GNN Limitations

**1-WL expressivity ceiling:** standard message-passing GNNs are at most as expressive as the 1-WL test. Cannot distinguish all non-isomorphic graphs.

**Over-smoothing:** deep GNNs lose discriminative power.

**Over-squashing:** information from distant nodes must flow through a bottleneck of nodes with limited capacity. Nodes at the center of a graph receive exponentially diluted long-range information.

**Scalability:** full graph training requires loading the entire adjacency in memory. Mini-batch sampling is required for large graphs.

## Expressivity Beyond WL

**$k$-GNNs:** operate on $k$-tuples of nodes; $k$-WL test. More expressive; $O(n^k)$ complexity.

**NGNN (Nested GNN):** for each node, extract its $r$-hop subgraph; run a GNN on the subgraph; use the subgraph embedding as a node feature in the outer GNN. More expressive at manageable cost.

**Randomized features:** add random node identifiers or random features to break symmetry. Simple; empirically strong.

## Graph Transformers

Apply Transformer self-attention to graph nodes.

**Challenge:** standard attention is $O(n^2)$; efficient for small graphs (molecules) but not for large graphs.

**Graphormer (Ying et al. 2021):** encode graph structure via centrality encoding (degree as bias), spatial encoding (shortest path distance as attention bias), and edge encoding (edge features in attention). State of the art on molecular benchmarks.

**GPS (General, Powerful, Scalable):** combine message-passing with Transformer attention at each layer. Modular; achieves strong results across benchmarks.
