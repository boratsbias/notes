# Normalizing Flows

Normalizing flows are generative models that learn an **exact, invertible** mapping between a simple base distribution and the data distribution. They provide exact likelihood evaluation and efficient sampling.

## The Core Idea

Let $z \sim p_Z(z)$ be a simple distribution (e.g., $\mathcal{N}(0, I)$). Define an invertible, differentiable function $f_\theta: \mathcal{Z} \to \mathcal{X}$. Then $x = f_\theta(z)$ is a sample from the model.

**Change of variables formula:**

$$p_X(x) = p_Z(f_\theta^{-1}(x)) \left|\det J_{f_\theta^{-1}}(x)\right|$$

or equivalently, writing $z = g_\theta(x) = f_\theta^{-1}(x)$:

$$\log p_X(x) = \log p_Z(g_\theta(x)) + \log \left|\det J_{g_\theta}(x)\right|$$

The log absolute Jacobian determinant accounts for the volume change of the transformation.

## Composing Flows

A normalizing flow is typically a composition of $K$ simple invertible transformations:

$$x = f_K \circ f_{K-1} \circ \cdots \circ f_1(z)$$

$$\log p_X(x) = \log p_Z(z) + \sum_{k=1}^K \log \left|\det J_{f_k^{-1}}(x_{k-1})\right|$$

Each $f_k$ must be:
1. Invertible.
2. Have a tractable Jacobian determinant.

## Coupling Layers

The dominant building block. Split $x$ into two halves $[x_1, x_2]$:

$$y_1 = x_1$$
$$y_2 = x_2 \odot \exp(s(x_1)) + t(x_1)$$

where $s$ (scale) and $t$ (translation) are arbitrary neural networks of $x_1$.

**Inverse:**

$$x_1 = y_1$$
$$x_2 = (y_2 - t(y_1)) \odot \exp(-s(y_1))$$

**Jacobian determinant:** $\det J = \prod_i \exp(s_i(x_1))$, which is trivially computed as $\sum_i s_i(x_1)$.

Networks $s$ and $t$ can be arbitrarily complex (no invertibility constraint on them), enabling expressive transformations with cheap Jacobian computation.

## Autoregressive Flows

Generalize coupling layers. Each dimension is transformed conditioned on all previous ones:

$$y_i = f(x_i; c_i), \quad c_i = g(x_1, \ldots, x_{i-1})$$

**Masked Autoregressive Flow (MAF):** uses a MADE-style masked MLP to compute all conditionals in one forward pass. Fast density estimation; slow sampling (sequential).

**Inverse Autoregressive Flow (IAF):** reverses the direction. Fast sampling; slow density estimation. Useful as a posterior in VAEs (IAF-VAE).

| Flow | Forward (density) | Inverse (sampling) |
|------|------------------|--------------------|
| MAF | Fast (parallel) | Slow (sequential) |
| IAF | Slow (sequential) | Fast (parallel) |
| Coupling | Fast | Fast |

## Real NVP (Non-Volume Preserving)

Stacks multiple coupling layers, alternating which half of dimensions is kept fixed. Uses checkerboard and channel-wise masking for images.

$$\log p(x) = \log p_Z(z) + \sum_{k=1}^K \sum_i s_k^{(i)}(x_1)$$

Provides exact likelihood for images; competitive with PixelCNN on density estimation.

## Glow

Extension of Real NVP with:
- **Actnorm:** per-channel affine transform initialized via data-dependent statistics (replaces batch norm).
- **Invertible 1×1 convolution:** a learnable permutation of channels (generalizes fixed checkerboard masking). Jacobian determinant: $\log |\det W|$ computed via LU decomposition.
- **Affine coupling layers.**

Architecture: $L$ levels, each with $K$ steps of (Actnorm → 1×1 Conv → Affine Coupling).

First model to demonstrate high-quality $256\times256$ face synthesis with exact likelihoods.

## Continuous Normalizing Flows (CNF)

Instead of discrete transformation steps, define a continuous-time flow via an ODE:

$$\frac{dx}{dt} = f_\theta(x, t), \quad x(0) = z, \quad x(1) = \tilde{x}$$

**Instantaneous change of variables:**

$$\frac{d \log p(x(t))}{dt} = -\text{tr}\!\left(\frac{\partial f_\theta}{\partial x(t)}\right)$$

The trace of the Jacobian (much cheaper than the determinant) is the only quantity needed. Stochastic trace estimators (Hutchinson) make this scalable.

**FFJORD:** uses Hutchinson's estimator for unbiased, cheap log-likelihood. Solve the ODE with a black-box ODE solver.

### Flow Matching

A more efficient training paradigm for CNFs (Lipman et al. 2022):

Instead of maximizing likelihood via the ODE, directly regress the vector field that transforms $p_0$ to $p_1$:

$$\mathcal{L}_\text{FM} = \mathbb{E}_{t, x(t)}\!\left[\|v_\theta(x(t), t) - u_t(x(t))\|^2\right]$$

where $u_t$ is a target vector field (e.g., a straight-line path between noise and data). Simpler and more scalable than FFJORD. Used in Stable Diffusion 3 (rectified flows).

## Spline Flows

Replace affine coupling transforms with monotone splines (piecewise-polynomial bijections). More expressive per layer; still have tractable inverses and Jacobians.

**Neural Spline Flows:** rational-quadratic splines with learnable knots. State of the art for tabular density estimation.

## Comparison with Other Generative Models

| Property | Normalizing Flow | VAE | GAN | Diffusion |
|----------|-----------------|-----|-----|----------|
| Exact likelihood | Yes | No (ELBO) | No | No (ELBO) |
| Sampling speed | Fast | Fast | Fast | Slow |
| Latent space | Yes (exact inversion) | Approximate | None | Implicit |
| Expressiveness | Limited by architecture | High | High | Highest |
| Training stability | Stable (MLE) | Stable | Unstable | Stable |
| Memory | High (invertibility) | Low | Low | Moderate |

## Applications

- **Density estimation:** model tabular data distributions; anomaly detection.
- **Variational inference:** IAF as flexible posterior in VAEs.
- **Physics simulations:** normalizing flows as surrogate models for complex posteriors.
- **Image synthesis:** Glow (high-res faces), Real NVP.
- **Audio:** WaveGlow (WaveNet + Glow for TTS).
