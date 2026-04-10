# Shallow Neural Networks

A **shallow neural network** has exactly one hidden layer between input and output. Despite their simplicity, shallow networks are the theoretical basis for the universal approximation theorem and serve as the building block for understanding deeper architectures.

$$\hat{y} = W^{(2)} \sigma(W^{(1)} \mathbf{x} + \mathbf{b}^{(1)}) + \mathbf{b}^{(2)}$$

## Architecture

```
Input layer     Hidden layer      Output layer
x_1  ─┐
x_2  ─┤──► [h_1, h_2, ..., h_n] ──► [y_1, ..., y_k]
...   ─┘
x_d
```

- **Input:** $\mathbf{x} \in \mathbb{R}^d$
- **Hidden:** $\mathbf{h} = \sigma(W^{(1)}\mathbf{x} + \mathbf{b}^{(1)}) \in \mathbb{R}^n$
- **Output:** $\hat{\mathbf{y}} = W^{(2)}\mathbf{h} + \mathbf{b}^{(2)} \in \mathbb{R}^k$

**Total parameters:** $d \cdot n + n + n \cdot k + k = n(d + k + 1) + k$

## Forward Pass

For a single input $\mathbf{x} \in \mathbb{R}^d$:

**Layer 1 (hidden):**

$$z_j^{(1)} = \sum_{i=1}^d w_{ji}^{(1)} x_i + b_j^{(1)}, \quad j = 1, \ldots, n$$

$$h_j = \sigma(z_j^{(1)})$$

**Layer 2 (output):**

$$\hat{y}_k = \sum_{j=1}^n w_{kj}^{(2)} h_j + b_k^{(2)}$$

## Learning in a Shallow Network

The network minimizes empirical risk:

$$\hat{\theta} = \arg\min_{W^{(1)}, \mathbf{b}^{(1)}, W^{(2)}, \mathbf{b}^{(2)}} \frac{1}{n} \sum_{i=1}^n \mathcal{L}(\hat{y}_i, y_i)$$

The output weights $W^{(2)}$ enter the loss linearly (fixing $\mathbf{h}$, the problem is convex in $W^{(2)}$). The hidden weights $W^{(1)}$ make the overall problem non-convex.

## Representational Capacity

For a width-$n$ ReLU network:
- Creates at most $n$ "kinks" (breakpoints) in 1-D: can represent any piecewise linear function with $\leq n$ pieces.
- In $d$ dimensions: partitions input space into at most $\sum_{j=0}^d \binom{n}{j}$ regions, each with a linear function.

**Width needed for $\epsilon$-approximation:** Typically exponential in $d$ for multivariate functions. This curse of dimensionality motivates depth.

## Universal Approximation (Formal Statement)

**Cybenko (1989):** For any continuous $f: [0,1]^d \to \mathbb{R}$ and $\epsilon > 0$, there exist $n$, $W^{(1)}$, $W^{(2)}$, $\mathbf{b}$ such that:

$$\sup_{x \in [0,1]^d} |f(x) - \hat{f}(x)| < \epsilon$$

for any non-constant, bounded, monotone continuous activation $\sigma$.

**Hornik (1991):** Extends to any non-polynomial $\sigma$.

The theorem guarantees existence but not efficient constructibility or learnability via gradient descent.

## When Shallow Networks Suffice

- Low-dimensional inputs ($d \leq$ a few hundred).
- Smooth, simple target functions.
- Small datasets where deep networks overfit.
- Interpretability is required.

Examples: logistic regression (no hidden layer), one-hidden-layer MLP for tabular data, radial basis function networks.

## Comparison to Deep Networks

| Property | Shallow | Deep |
|----------|---------|------|
| Parameters for same function | Exponentially more | Polynomial |
| Optimization landscape | Fewer saddle points | More complex |
| Feature learning | One level of features | Hierarchical |
| Generalization (typical) | Worse on structured data | Better |
| Interpretability | Easier | Harder |

Shallow networks are best understood as the foundation: understanding their forward pass, loss landscape, and gradient flow directly extends to deeper architectures. See [Deep Neural Networks](02-deep-neural-networks).
