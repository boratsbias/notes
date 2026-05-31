---
title: "Graph Attention Networks (GAT)"
authors: "Petar Velickovic et al."
year: 2018
area: Graph Learning, Deep Learning
link: https://arxiv.org/abs/1710.10903
---

## GCN's fixed-weight limitation

GCN aggregates each node's neighborhood using weights fixed by the graph's degree structure. A node with five neighbors averages all five equally, with no mechanism for the model to down-weight irrelevant or noisy neighbors. This is a strong assumption: in citation networks, some papers cite tangentially related work; in social networks, not all connections carry equal information. GCN cannot distinguish an informative neighbor from a distracting one because its aggregation weights are determined entirely by graph topology, not by learned features.

## Attention over neighbors

GAT introduces learned attention weights over each node's neighborhood. For a node i and a neighbor j, the unnormalized attention coefficient is computed as:

$$e_{ij} = \text{LeakyReLU}\!\left(\mathbf{a}^\top \cdot \left[W\mathbf{h}_i \,\|\, W\mathbf{h}_j\right]\right)$$

where $W$ is a shared linear transformation, $\mathbf{a}$ is a learnable attention vector, and $\|$ denotes concatenation. These are then normalized across the neighborhood using softmax:

$$\alpha_{ij} = \frac{\exp(e_{ij})}{\sum_{k \in \mathcal{N}(i)} \exp(e_{ik})}$$

The updated node representation is $\mathbf{h}_i' = \sigma\!\left(\sum_{j \in \mathcal{N}(i)} \alpha_{ij} W\mathbf{h}_j\right)$. The attention weights are computed entirely from node features, requiring no knowledge of the global graph structure beyond the adjacency.

## Multi-head attention and specialization

GAT uses multi-head attention: K independent attention mechanisms run in parallel, and their outputs are concatenated for intermediate layers or averaged for the final output layer. This stabilizes training and lets different heads specialize in different types of neighbor relationships. Nodes can effectively assign near-zero attention to uninformative neighbors, making GAT more robust on heterogeneous or noisy graphs where GCN's uniform aggregation fails. The model implicitly learns which parts of the graph structure matter for the task, supervised only by node classification labels.

## Results and impact

GAT achieved state-of-the-art results on Cora, Citeseer, PubMed, and protein interaction datasets, outperforming GCN and GraphSAGE across benchmarks. It demonstrated that the attention mechanism, which had proven transformative for sequences in the transformer, is equally powerful on graph-structured data. GAT is among the most cited graph neural network architectures and remains a standard baseline. The core idea, that neighbor weights should be learned from features rather than fixed by topology, directly influenced the design of every subsequent graph attention variant.
