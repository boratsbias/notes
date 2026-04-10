# Neural Networks

## Core Idea

A neural network is a parametric function $f_\theta: \mathbb{R}^d \to \mathbb{R}^k$ composed of alternating linear transformations and element-wise nonlinearities. It is a **universal function approximator**: given sufficient width, a single hidden layer can approximate any continuous function on a compact domain to arbitrary precision.

## The Neuron (Perceptron)

The basic computational unit:

$$z = \mathbf{w}^T \mathbf{x} + b, \quad a = \sigma(z)$$

- $\mathbf{x} \in \mathbb{R}^d$: input vector
- $\mathbf{w} \in \mathbb{R}^d$: weight vector
- $b \in \mathbb{R}$: bias term
- $\sigma$: activation function (nonlinearity)
- $a$: activation (output)

Without the nonlinearity $\sigma$, stacking neurons is equivalent to a single linear transformation.

## Feedforward Neural Network (MLP)

A **Multi-Layer Perceptron** is a sequence of $L$ layers:

$$\mathbf{h}^{(0)} = \mathbf{x}$$

$$\mathbf{z}^{(l)} = W^{(l)} \mathbf{h}^{(l-1)} + \mathbf{b}^{(l)}, \quad l = 1, \ldots, L$$

$$\mathbf{h}^{(l)} = \sigma(\mathbf{z}^{(l)})$$

$$\hat{\mathbf{y}} = \mathbf{h}^{(L)}$$

where $W^{(l)} \in \mathbb{R}^{n_l \times n_{l-1}}$ and $\mathbf{b}^{(l)} \in \mathbb{R}^{n_l}$.

**Parameter count:** $\sum_{l=1}^L (n_l \cdot n_{l-1} + n_l)$

## Layer Types

| Layer | Operation | Parameters |
|-------|-----------|-----------|
| Fully connected (Dense) | $W\mathbf{h} + \mathbf{b}$ | $n_l \cdot n_{l-1} + n_l$ |
| Convolutional | Sliding kernel over spatial dims | $k \times k \times C_\text{in} \times C_\text{out}$ |
| Recurrent (RNN) | $h_t = \sigma(W_h h_{t-1} + W_x x_t + b)$ | $n_h(n_h + n_x) + n_h$ |
| Attention | $\text{softmax}(QK^T/\sqrt{d_k})V$ | $3 \cdot d \cdot d_k + d_v \cdot d$ |

## Network Architecture Terminology

- **Width:** number of neurons per layer ($n_l$)
- **Depth:** number of layers ($L$)
- **Hidden layer:** any layer that is not input or output
- **Input layer:** $\mathbf{h}^{(0)} = \mathbf{x}$; no parameters
- **Output layer:** $\mathbf{h}^{(L)}$; activation depends on task

**Output activations by task:**

| Task | Output activation | Loss |
|------|------------------|------|
| Binary classification | Sigmoid | Binary cross-entropy |
| Multi-class classification | Softmax | Categorical cross-entropy |
| Regression | None (linear) | MSE |
| Multi-label classification | Sigmoid per output | Binary cross-entropy |

## Universal Approximation Theorem

A feedforward network with a single hidden layer of width $N$ and a non-polynomial activation function can approximate any continuous function $f: [0,1]^d \to \mathbb{R}$ to within $\epsilon$ in the sup-norm, for any $\epsilon > 0$.

**Limitations of the theorem:**
- Existence does not imply learnability (gradient descent may not find the weights).
- The required width $N$ may be exponential in $d$.
- Depth provides exponential expressiveness gains over width for certain functions.

## Computational Graph

A neural network is a **directed acyclic graph (DAG)** where:
- Nodes represent operations or variables.
- Edges represent data flow (tensors).

This representation enables automatic differentiation via the chain rule. See [Backpropagation](07-backpropagation).

## Matrix Form (Batch Processing)

For a batch of $n$ examples, stack inputs row-wise: $X \in \mathbb{R}^{n \times d}$.

$$Z^{(l)} = H^{(l-1)} W^{(l)T} + \mathbf{1}\mathbf{b}^{(l)T}$$

$$H^{(l)} = \sigma(Z^{(l)})$$

Modern frameworks (PyTorch, JAX, TensorFlow) use this batched form with broadcasting.

## Expressiveness vs. Depth

For piecewise linear networks (ReLU), a depth-$L$ network with width $n$ can represent up to $O((n/d)^{(L-1)d} \cdot n^d)$ linear regions in input space. Depth increases expressiveness exponentially; doubling width increases it polynomially.

Functions with hierarchical structure (images, language) are efficiently represented by deep networks but require exponentially wide shallow networks.
