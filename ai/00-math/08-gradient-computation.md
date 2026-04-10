# Gradient Computation

The gradient $\nabla_\theta \mathcal{L}$ gives the direction and rate of steepest increase of the loss $\mathcal{L}$ w.r.t. parameters $\theta$. Gradient descent moves in the opposite direction.

## Four Ways to Compute Gradients

| Method | Exact? | Cost | Used in |
|--------|--------|------|---------|
| Manual (analytical) | Yes | One-time effort | Deriving update rules |
| Numerical differentiation | Approx. | $O(n)$ evaluations | Gradient checking |
| Forward-mode AD | Yes | $O(n)$ per input dim | Few inputs, many outputs |
| Reverse-mode AD | Yes | $O(1)$ passes | ML (many params, scalar loss) |

## Numerical Differentiation

**Finite difference:**
$$\frac{\partial f}{\partial x_i} \approx \frac{f(\mathbf{x} + h\mathbf{e}_i) - f(\mathbf{x} - h\mathbf{e}_i)}{2h}$$

- Requires 2 function evaluations per parameter
- For $n$ parameters: $2n$ evaluations → $O(n)$ cost, impractical for large models
- Used only for **gradient checking** (verifying autograd implementations)

**Gradient check:** confirm $\lVert\nabla_{\text{autograd}} - \nabla_{\text{numerical}}\rVert / \max(\ldots) < 10^{-5}$

## Computational Graphs

A computational graph is a DAG where:
- Nodes = operations (add, multiply, sigmoid, ...)
- Edges = data (tensors) flowing between operations

Every forward pass through a neural network constructs this graph (explicitly in PyTorch, implicitly in TF static graphs).

**Example:**
```
x → [square] → y → [sum] → L
```

## Forward-Mode Automatic Differentiation

Propagates **tangents** (directional derivatives) alongside values during a single forward pass.

For a direction $\dot{\mathbf{x}}$ (seed vector), computes $\dot{L} = \nabla L \cdot \dot{\mathbf{x}}$.

- One pass per input dimension to get the full gradient
- Efficient when: few inputs, many outputs (e.g., Jacobian rows)

**Dual numbers:** represent $(x, \dot{x})$; arithmetic rules propagate tangents automatically.

## Reverse-Mode Automatic Differentiation (Backpropagation)

Propagates **adjoints** (upstream gradients) backwards through the graph.

$$\bar{x}_i = \frac{\partial L}{\partial x_i}$$

**Algorithm:**
1. **Forward pass:** compute all node values, record the graph
2. **Backward pass:** starting from $\bar{L} = 1$, apply the chain rule backward through each node

One backward pass computes $\nabla_\theta \mathcal{L}$ for all parameters simultaneously.

**Cost:** roughly 2–3× the cost of a forward pass.

**Memory:** must store intermediate activations for the backward pass → memory bottleneck for large models.

## Backpropagation Through Common Operations

### Linear Layer $\mathbf{y} = W\mathbf{x} + \mathbf{b}$

Given $\bar{\mathbf{y}} = \frac{\partial \mathcal{L}}{\partial \mathbf{y}}$:

$$\bar{W} = \bar{\mathbf{y}} \mathbf{x}^T, \quad \bar{\mathbf{b}} = \bar{\mathbf{y}}, \quad \bar{\mathbf{x}} = W^T \bar{\mathbf{y}}$$

### Elementwise Activation $\mathbf{y} = \sigma(\mathbf{x})$

$$\bar{\mathbf{x}} = \bar{\mathbf{y}} \odot \sigma'(\mathbf{x})$$

### Softmax + Cross-Entropy (combined)

$$\bar{\mathbf{z}} = \mathbf{p} - \mathbf{y}_{\text{true}}$$

(where $\mathbf{p}$ = predicted probabilities, $\mathbf{y}_{\text{true}}$ = one-hot label)

### Sum $s = \sum_i x_i$

$$\bar{x}_i = \bar{s} \quad (\text{gradient fans out equally})$$

### Product $z = x \cdot y$

$$\bar{x} = \bar{z} \cdot y, \quad \bar{y} = \bar{z} \cdot x$$

### Max $z = \max(x, y)$

Gradient flows only through the larger input:
$$\bar{x} = \bar{z} \cdot \mathbf{1}[x > y], \quad \bar{y} = \bar{z} \cdot \mathbf{1}[y > x]$$

### Reshape / Transpose

Gradients are reshaped back to the original shape (no arithmetic, just indexing).

## Gradient Flow Problems

### Vanishing Gradients
Gradients shrink as they propagate back through many layers.

Cause: sigmoid/tanh saturate → $|\sigma'(x)| < 0.25$ everywhere.

Solutions:
- ReLU activations (gradient = 1 when active)
- Residual connections (skip connections add gradient highway)
- Batch normalization
- Better initialization (Xavier, He)

### Exploding Gradients
Gradients grow unboundedly, most commonly in RNNs.

Solutions:
- **Gradient clipping:** scale gradient if $\lVert\nabla\rVert > \text{threshold}$
- Weight regularization
- LSTM / GRU gates

## Gradient Checkpointing

Trade compute for memory: instead of storing all activations, recompute them during the backward pass.

Reduces memory from $O(\text{depth})$ to $O(\sqrt{\text{depth}})$ at the cost of one extra forward pass.

Used in: training very large transformers.

## Higher-Order Gradients

**Second-order gradient** (Hessian): $\frac{\partial^2 \mathcal{L}}{\partial \theta_i \partial \theta_j}$

Computed by differentiating through the backward pass.

Used in:
- Meta-learning (MAML, which computes gradients of gradients)
- Neural ODEs
- Regularization via Hessian trace
- Natural gradient methods
