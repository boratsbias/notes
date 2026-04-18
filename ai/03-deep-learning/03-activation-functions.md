# Activation Functions

Activation functions introduce **nonlinearity** into neural networks. Without them, any depth of linear layers collapses to a single linear transformation. The choice of activation affects gradient flow, training speed, and representational capacity.

## Requirements for a Good Activation

- **Nonlinear:** otherwise stacking layers is useless.
- **Differentiable (almost everywhere):** required for gradient-based training.
- **Non-saturating (ideally):** saturating activations kill gradients in deep networks.
- **Computationally cheap:** called billions of times per training step.

## Sigmoid

$$\sigma(z) = \frac{1}{1 + e^{-z}} \in (0, 1)$$

**Derivative:** $\sigma'(z) = \sigma(z)(1 - \sigma(z))$

**Maximum derivative:** $0.25$ at $z = 0$.

**Problems:**
- **Saturates** at both tails: $\sigma'(z) \approx 0$ for $\lvert z \rvert \gg 0$. Gradients vanish in deep networks.
- **Output not zero-centered:** all outputs positive; leads to zig-zagging gradient updates.
- **Expensive:** requires exponential.

**Use:** output layer for binary classification; gating mechanisms (LSTM, GRU).

## Tanh

$$\tanh(z) = \frac{e^z - e^{-z}}{e^z + e^{-z}} = 2\sigma(2z) - 1 \in (-1, 1)$$

**Derivative:** $\tanh'(z) = 1 - \tanh^2(z)$

**Maximum derivative:** $1.0$ at $z = 0$.

**Advantages over sigmoid:** zero-centered output. Stronger gradient at origin.

**Problems:** still saturates at tails; vanishing gradients in deep networks.

**Use:** hidden layers in RNNs and shallow networks. Largely replaced by ReLU in feedforward layers.

## ReLU (Rectified Linear Unit)

$$\text{ReLU}(z) = \max(0, z)$$

**Derivative:**

$$\text{ReLU}'(z) = \begin{cases} 1 & z > 0 \\ 0 & z < 0 \end{cases}$$

**Advantages:**
- Non-saturating for $z > 0$: gradients pass through unchanged.
- Computationally trivial (comparison + threshold).
- Induces sparsity: about 50% of neurons are inactive on average.
- Empirically accelerates convergence compared to sigmoid/tanh.

**Problems:**
- **Dying ReLU:** if a neuron's pre-activation is always negative (e.g., after a large negative gradient update), it outputs 0 permanently and receives zero gradient. Learning stops for that neuron.
- Not zero-centered.
- Not differentiable at $z = 0$ (subgradient $\{0\}$ used in practice).

**Use:** default activation for hidden layers in MLPs and CNNs.

## Leaky ReLU

$$\text{LeakyReLU}(z) = \begin{cases} z & z > 0 \\ \alpha z & z \leq 0 \end{cases}$$

Typically $\alpha = 0.01$. Fixes dying ReLU by allowing a small gradient for $z < 0$.

## PReLU (Parametric ReLU)

Same as Leaky ReLU but $\alpha$ is a learned parameter. Adds minimal overhead; can improve accuracy on large datasets.

## ELU (Exponential Linear Unit)

$$\text{ELU}(z) = \begin{cases} z & z > 0 \\ \alpha(e^z - 1) & z \leq 0 \end{cases}$$

- Smooth, differentiable everywhere.
- Negative outputs bring mean activations closer to zero (reduces bias shift).
- Slower to compute due to exponential.

## SELU (Scaled ELU)

$$\text{SELU}(z) = \lambda \cdot \text{ELU}(z)$$

With specific $\lambda \approx 1.0507$ and $\alpha \approx 1.6733$. Self-normalizing: activations converge to zero mean and unit variance under mild conditions, making batch normalization unnecessary. Requires `LeCun Normal` initialization and fully connected architectures.

## GELU (Gaussian Error Linear Unit)

$$\text{GELU}(z) = z \cdot \Phi(z) = z \cdot \frac{1}{2}\left[1 + \text{erf}\!\left(\frac{z}{\sqrt{2}}\right)\right]$$

where $\Phi$ is the standard normal CDF. Approximated as:

$$\text{GELU}(z) \approx 0.5z\left(1 + \tanh\!\left(\sqrt{2/\pi}(z + 0.044715z^3)\right)\right)$$

- Smooth, non-monotone.
- Stochastic interpretation: $\text{GELU}(z) = z \cdot P(Z \leq z)$ for $Z \sim \mathcal{N}(0,1)$.
- Default activation in BERT, GPT, and most modern Transformers.

## SiLU / Swish

$$\text{SiLU}(z) = z \cdot \sigma(z)$$

Smooth, non-monotone, unbounded above. Performs well in EfficientNet and many vision models. Close to GELU.

## Softmax

$$\text{softmax}(\mathbf{z})_k = \frac{e^{z_k}}{\sum_{j=1}^K e^{z_j}}$$

- Outputs sum to 1; interpreted as probabilities.
- Numerically stable version: subtract $\max(\mathbf{z})$ before exponentiating.
- **Not** an activation for hidden layers; used only in the output layer for multi-class classification.

**Temperature scaling:** $\text{softmax}(\mathbf{z} / T)$. Low $T \to 0$ sharpens to argmax; high $T \to \infty$ flattens to uniform. Used in knowledge distillation and language model decoding.

## Comparison

| Activation | Range | Saturates | Zero-centered | Dying neurons | Typical Use |
|-----------|-------|-----------|--------------|---------------|------------|
| Sigmoid | $(0,1)$ | Yes (both) | No | No | Output (binary), gates |
| Tanh | $(-1,1)$ | Yes (both) | Yes | No | RNNs, shallow nets |
| ReLU | $[0, \infty)$ | No (pos) | No | Yes | MLPs, CNNs |
| Leaky ReLU | $\mathbb{R}$ | No | No | No | MLPs, CNNs |
| ELU | $(-\alpha, \infty)$ | No | Near-zero mean | No | Deep MLPs |
| GELU | $\mathbb{R}$ | No | No | No | Transformers |
| Swish/SiLU | $\mathbb{R}$ | No | No | No | Vision models |
| Softmax | $(0,1)^K$ | Yes | No | No | Output (multi-class) |
