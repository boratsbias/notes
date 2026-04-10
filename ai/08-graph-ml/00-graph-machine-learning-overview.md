# Graph Machine Learning Overview

## Core Idea

Graph machine learning studies models for data where entities and relationships matter as much as the entities themselves.

A graph is typically written as:

$$G = (V, E)$$

where $V$ is the set of nodes and $E$ is the set of edges.

## Why Graphs Matter

Many real systems are relational:

- social networks
- citation networks
- molecules
- knowledge graphs
- recommender systems
- transportation networks

Ignoring the graph structure often loses essential information.

## Basic Representations

### Adjacency Matrix

For $n$ nodes, the adjacency matrix $A \in \mathbb{R}^{n \times n}$ stores whether nodes are connected.

$$A_{ij} =
\begin{cases}
1 & \text{if edge } i \to j \text{ exists} \\
0 & \text{otherwise}
\end{cases}$$

### Node Features

Each node can also have a feature vector $\mathbf{x}_i$.

### Edge Features

Edges may carry weights, types, or timestamps.

## Common Tasks

| Task | Goal |
|------|------|
| Node classification | Predict a label for each node |
| Link prediction | Predict whether an edge should exist |
| Graph classification | Predict a label for the entire graph |
| Node ranking | Score important or central nodes |
| Graph generation | Create new graphs with desired structure |

## Message Passing

Most graph neural networks update node representations by aggregating information from neighbors.

A generic layer looks like:

$$\mathbf{h}_i^{(k+1)} = \phi\left(W^{(k)} \cdot \text{AGG}\left(\left\{\mathbf{h}_j^{(k)} : j \in \mathcal{N}(i)\right\}\right)\right)$$

where $\mathcal{N}(i)$ is the neighborhood of node $i$.

## Important Architectures

| Model | Main Idea |
|-------|-----------|
| GCN | Normalized neighborhood averaging |
| GraphSAGE | Sample and aggregate neighbors |
| GAT | Use attention over neighbors |
| MPNN | General message-passing framework |

## Challenges

- irregular structure compared with grids
- variable graph size
- oversmoothing in deep GNNs
- scalability on large graphs
- heterogeneity of node and edge types

## Useful Concepts

- homophily: connected nodes tend to be similar
- heterophily: connected nodes can be different
- graph Laplacian
- random walks
- positional encodings on graphs

## Applications

- fraud detection
- molecular property prediction
- recommendation
- knowledge base completion
- traffic forecasting
- scientific discovery
