# Unsupervised Learning

## Core Idea

Unsupervised learning tries to discover structure in data without using target labels.

We are given only inputs $\mathbf{x}_1, \mathbf{x}_2, \ldots, \mathbf{x}_n$ and want to learn patterns such as groups, low-dimensional structure, or probability distributions.

## Main Goals

- clustering similar examples
- reducing dimensionality
- estimating density
- detecting anomalies
- learning compact representations

## Clustering

Clustering groups examples that are similar according to some distance or similarity measure.

### K-Means

K-means partitions data into $K$ clusters by minimizing within-cluster squared distance:

$$\sum_{k=1}^K \sum_{\mathbf{x}_i \in C_k} \|\mathbf{x}_i - \mu_k\|_2^2$$

It alternates between:

1. assigning points to the nearest centroid
2. recomputing centroids

### Hierarchical Clustering

Builds a tree of clusters by repeatedly merging or splitting groups.

### DBSCAN

Finds dense regions and treats isolated points as noise.

## Dimensionality Reduction

High-dimensional data is often easier to analyze after projection into a smaller space.

### PCA

Principal component analysis finds directions of maximum variance.

- useful for compression
- useful for visualization
- useful for denoising

### Nonlinear Methods

Methods such as t-SNE and UMAP are often used for visualization of complex manifolds.

## Density Estimation

Density estimation attempts to model the data distribution $P(\mathbf{x})$.

Examples:

- Gaussian mixture models
- kernel density estimation
- autoregressive density models

## Anomaly Detection

Points that do not fit the dominant structure can be treated as anomalies.

Common approaches:

- distance-based methods
- density-based methods
- reconstruction-based methods

## Challenges

- no ground truth labels for easy evaluation
- results can depend strongly on scale and feature choice
- different methods capture different notions of structure

## Evaluation

Unsupervised learning is often evaluated by:

- cluster quality measures
- reconstruction error
- downstream task usefulness
- visual inspection in low-dimensional embeddings
