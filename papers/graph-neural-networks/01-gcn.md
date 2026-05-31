# Semi-Supervised Classification with Graph Convolutional Networks (GCN) (2016)

**Authors:** Thomas N. Kipf, Max Welling
**Area:** Graph Learning, Deep Learning
**Link:** [arXiv](https://arxiv.org/abs/1609.02907)

## What the paper argues

Node classification with few labels is hard when using only node features. But in many real graphs, connected nodes tend to have the same label (homophily). GCN argues that a simple layer-wise propagation rule that aggregates each node's own features with its neighbors' features can exploit graph structure as a regularizer, making a few labeled nodes sufficient to classify many unlabeled ones.

## Propagation rule

At each layer, each node's new representation is a normalized weighted sum of its own and neighbors' representations:

```
H^(l+1) = σ( D̃^{-1/2} Ã D̃^{-1/2}  H^(l) W^(l) )
```

where:
- Ã = A + I  (adjacency matrix with added self-loops)
- D̃ = degree matrix of Ã (for normalization)
- H^(l) = node feature matrix at layer l
- W^(l) = learnable weight matrix
- σ = non-linearity (ReLU)

In plain terms: each node's new representation is the average of its own and neighbors' previous representations, linearly transformed. A 2-layer GCN lets each node incorporate features from its 2-hop neighborhood.

## Semi-supervised training

Only a few nodes are labeled. The model is trained with cross-entropy only on those nodes, but the graph convolution layers propagate information from all nodes:

```
Loss = Σ_{labeled nodes} CE(softmax(Z_i), y_i)
```

The graph structure implicitly smooths predictions: neighboring nodes will have similar representations and therefore similar predictions, even if not labeled.

## Results and impact

GCN outperformed all prior semi-supervised methods on Cora, Citeseer, and PubMed citation networks with very few labels (20 per class). It established the message-passing GNN paradigm that virtually all subsequent graph neural network architectures follow.
