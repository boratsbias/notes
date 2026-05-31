---
title: "Semi-Supervised Classification with Graph Convolutional Networks (GCN)"
authors: "Thomas N. Kipf, Max Welling"
year: 2016
area: Graph Learning, Deep Learning
link: https://arxiv.org/abs/1609.02907
---

## The node classification problem

In graph-structured data such as citation networks and social networks, nodes have feature vectors and edges encode relationships. The goal is to classify nodes using only a small fraction of labeled examples. The central assumption is homophily: connected nodes tend to belong to the same class. If this holds, a model that lets labeled nodes propagate their signal to unlabeled neighbors across the graph can leverage the full structure as an implicit regularizer, even though supervision is only applied at labeled nodes.

## The propagation rule

The paper's core contribution is a simple, efficient layer-wise propagation rule:

$$H^{(l+1)} = \sigma\!\left(\tilde{D}^{-1/2}\,\tilde{A}\,\tilde{D}^{-1/2}\,H^{(l)}\,W^{(l)}\right)$$

Here $\tilde{A} = A + I$ is the adjacency matrix with added self-loops so each node attends to its own features, $\tilde{D}$ is the corresponding degree matrix used for symmetric normalization, $H^{(l)}$ is the node feature matrix at layer $l$, and $W^{(l)}$ is a learnable weight matrix. In plain terms: each node's new representation is the normalized average of its own and its neighbors' previous representations, passed through a linear transformation and a nonlinearity. The symmetric normalization by degree prevents high-degree nodes from dominating the aggregation. Each additional layer extends the receptive field by one hop, so a two-layer GCN lets every node incorporate features from its two-hop neighborhood.

## Semi-supervised training and spectral grounding

Training applies cross-entropy loss only over labeled nodes, but the graph convolution operates over all nodes in every forward pass. Unlabeled nodes receive representations shaped by the labeled nodes in their neighborhood through the propagation mechanism, giving the model access to graph structure without requiring labels everywhere. The propagation rule is derived as a first-order approximation of spectral graph convolutions from graph signal processing theory, giving the method a principled motivation beyond the intuitive neighborhood aggregation view.

## Results and impact

A two-layer GCN outperformed all prior semi-supervised methods on the Cora, Citeseer, and PubMed citation benchmarks using only 20 labels per class. The approach was simple to implement, fast to train, and interpretable. It established the message-passing paradigm that virtually all subsequent graph neural network architectures follow: aggregate neighbor information, transform, repeat. Methods including GraphSAGE, GAT, GIN, and most graph learning systems are direct descendants of this propagation framework.
