# Semi Supervised Learning

## Core Idea

Semi supervised learning uses a small labeled dataset together with a larger unlabeled dataset.

This is useful when collecting raw data is easy but labeling it is expensive.

## Motivation

Suppose we have:

- labeled set $\mathcal{D}_L = \{(\mathbf{x}_i, y_i)\}$
- unlabeled set $\mathcal{D}_U = \{\mathbf{x}_j\}$

The goal is to learn from both so that performance is better than using labeled data alone.

## Key Assumptions

Semi supervised methods often rely on one or more of these assumptions:

### Smoothness Assumption

Nearby points should have similar predictions.

### Cluster Assumption

Decision boundaries should pass through low-density regions.

### Manifold Assumption

High-dimensional data lies near a lower-dimensional manifold, and labels vary smoothly on that manifold.

## Common Approaches

### Pseudo-Labeling

1. train on labeled data
2. predict labels for unlabeled examples
3. keep confident predictions as additional training targets

### Consistency Regularization

The model should make similar predictions under small perturbations of the same input.

If $a(\mathbf{x})$ is an augmentation:

$$f_\theta(\mathbf{x}) \approx f_\theta(a(\mathbf{x}))$$

### Graph-Based Methods

Build a graph of examples and propagate labels across neighboring points.

### Generative Approaches

Model the input distribution and the label structure jointly.

## Benefits

- reduces labeling cost
- improves performance in low-label settings
- uses unlabeled data that would otherwise be wasted

## Risks

- wrong pseudo-labels can reinforce errors
- unlabeled data from a different distribution can hurt performance
- confidence estimates may be poorly calibrated

## Applications

- medical imaging
- speech recognition
- document classification
- vision tasks with expensive annotations
