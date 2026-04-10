# Weight Initialization

## Core Idea

Weight initialization sets the starting values of network parameters before training. Poor initialization causes **vanishing or exploding activations** and gradients from the very first forward/backward pass, preventing learning. Good initialization preserves the variance of activations and gradients across layers.

## Why Initialization Matters

For a layer $\mathbf{z} = W\mathbf{h} + \mathbf{b}$, the variance of a single pre-activation $z_j$:

$$\text{Var}[z_j] = n_\text{in} \cdot \text{Var}[w] \cdot \text{Var}[h] \quad \text{(assuming zero mean, independence)}$$

For variance to be preserved across layers: $n_\text{in} \cdot \text{Var}[w] = 1$, i.e., $\text{Var}[w] = 1/n_\text{in}$.

Similarly for gradients flowing backward: $n_\text{out} \cdot \text{Var}[w] = 1$.

Since $n_\text{in} \neq n_\text{out}$ in general, we compromise.

## Zero Initialization

$W = 0$: **Never use for weights.** All neurons in a layer receive identical gradients and learn identical features. Symmetry is never broken; the layer is equivalent to a single neuron.

**Biases:** initialized to zero by default (acceptable).

## Random Initialization

$W_{ij} \sim \mathcal{N}(0, \sigma^2)$ or $\text{Uniform}(-a, a)$.

If $\sigma$ is too large: activations saturate (sigmoid/tanh) or explode (ReLU).

If $\sigma$ is too small: activations and gradients vanish.

## Xavier / Glorot Initialization

**Designed for:** sigmoid and tanh activations (zero-centered, derivative near 1 at origin).

**Derivation:** requires $\text{Var}[w] = 2 / (n_\text{in} + n_\text{out})$ to approximately preserve variance in both forward and backward passes.

**Uniform variant:**

$$w \sim \text{Uniform}\!\left(-\sqrt{\frac{6}{n_\text{in} + n_\text{out}}},\ \sqrt{\frac{6}{n_\text{in} + n_\text{out}}}\right)$$

**Normal variant:**

$$w \sim \mathcal{N}\!\left(0,\ \frac{2}{n_\text{in} + n_\text{out}}\right)$$

Default initialization in Keras and PyTorch `Linear` layers.

## He (Kaiming) Initialization

**Designed for:** ReLU and variants. ReLU zeros out half the neurons, effectively halving the variance. He init doubles the variance to compensate.

**Derivation:** $\text{Var}[w] = 2 / n_\text{in}$ (fan-in mode).

**Normal variant:**

$$w \sim \mathcal{N}\!\left(0,\ \frac{2}{n_\text{in}}\right)$$

**Uniform variant:**

$$w \sim \text{Uniform}\!\left(-\sqrt{\frac{6}{n_\text{in}}},\ \sqrt{\frac{6}{n_\text{in}}}\right)$$

**Fan-out mode:** $\text{Var}[w] = 2/n_\text{out}$. Use when concerned about backward pass stability.

Default initialization in PyTorch for `Conv2d` and in most ReLU networks.

## LeCun Initialization

**Designed for:** SELU activations (self-normalizing networks).

$$w \sim \mathcal{N}\!\left(0,\ \frac{1}{n_\text{in}}\right)$$

Ensures the self-normalizing property of SELU is maintained from initialization.

## Orthogonal Initialization

Initialize weight matrix as a random orthogonal matrix (uniformly sampled from the Stiefel manifold). Constructed via SVD of a random Gaussian matrix.

**Advantage:** singular values all equal 1 at initialization; preserves gradient norms exactly.

**Use:** RNNs (combats vanishing gradients over time); very deep residual networks.

## Comparison

| Method | Designed For | $\text{Var}[w]$ |
|--------|-------------|-----------------|
| Xavier (Glorot) | Sigmoid, Tanh | $\frac{2}{n_\text{in} + n_\text{out}}$ |
| He (Kaiming) | ReLU, Leaky ReLU | $\frac{2}{n_\text{in}}$ |
| LeCun | SELU | $\frac{1}{n_\text{in}}$ |
| Orthogonal | RNNs, deep nets | Spectral norm = 1 |

## Bias Initialization

- **Standard:** $b = 0$. Symmetry breaking is provided by weight init; zero bias is neutral.
- **ReLU networks:** sometimes initialize $b = 0.01$ to ensure all neurons are active at the start.
- **Output layer:** can be initialized to match the empirical class prior (for classification) or target mean (for regression) to speed up early training.

## Batch Normalization and Initialization

Batch normalization (see [Batch Normalization](11-batch-normalization)) makes training less sensitive to initialization by normalizing pre-activations at each layer. With BN, initialization becomes less critical but still affects training dynamics in the first few steps before BN statistics stabilize.

## Practical Recommendations

- **Default ReLU/Leaky ReLU network:** He initialization.
- **Sigmoid/Tanh network:** Xavier initialization.
- **SELU network:** LeCun initialization with normal distribution.
- **Transformers:** Xavier normal is common; small init (scaled by $1/\sqrt{2L}$) sometimes applied to residual connection weights.
- **RNNs:** orthogonal for recurrent weights; Xavier/He for input-to-hidden weights.
- Always initialize biases to zero unless there is a specific reason not to.
