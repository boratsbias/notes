# Graph Attention Networks (GAT) (2018)

**Authors:** Petar Velickovic, Guillem Cucurull, Arantxa Casanova, Adriana Romero, Pietro Lio, Yoshua Bengio
**Area:** Graph Learning, Deep Learning
**Link:** [arXiv](https://arxiv.org/abs/1710.10903)

## What the paper argues

GCN aggregates neighbors with fixed weights determined by graph degree. Not all neighbors are equally informative, and the model has no way to weight them differently. GAT argues that attention should be computed over the neighborhood based on node features, so the model learns which neighbors matter more for each node.

## Attention over neighborhoods

For each node i and each neighbor j, an attention coefficient is computed:

```
e_{ij} = LeakyReLU( a^T · [W h_i || W h_j] )

α_{ij} = softmax_j(e_{ij}) = exp(e_{ij}) / Σ_{k ∈ N(i)} exp(e_{ik})
```

The new node representation is:

```
h_i' = σ( Σ_{j ∈ N(i)} α_{ij} · W h_j )
```

Node i aggregates its neighbors weighted by learned attention scores, not fixed degree normalization.

## Multi-head attention

K independent attention heads are run in parallel:

```
h_i' = ||_{k=1}^K  σ( Σ_{j ∈ N(i)} α_{ij}^k · W^k h_j )
```

Different heads learn to attend to different types of structural relationships. In the final layer, heads are averaged rather than concatenated.

## Advantage over GCN

GCN cannot assign different importance to different neighbors. GAT can: a node that is highly relevant to the prediction gets a high attention score; an irrelevant neighbor gets near zero. The attention weights are also fully differentiable, so the model learns which structure matters from the task supervision.

## Results and impact

State of the art on Cora, Citeseer, PubMed, and protein interaction networks. Demonstrated that attention is as powerful on graphs as on sequences. One of the most cited GNN architectures and the basis for many subsequent graph transformer models.
