# Generative Modeling Overview

## What is Generative Modeling?

A generative model learns the underlying data distribution $p(x)$ (or joint $p(x, y)$) so it can produce new samples that look like they came from that distribution. This contrasts with discriminative models, which only learn $p(y|x)$.

**Formal objective:** given samples $\{x_i\}_{i=1}^n \sim p_\text{data}(x)$, learn a model $p_\theta(x)$ such that $p_\theta \approx p_\text{data}$.

## Why Generative Models Matter

- **Data synthesis:** generate training data for downstream tasks, augment rare classes.
- **Representation learning:** learn compact latent spaces that capture semantic structure.
- **Density estimation:** assign likelihoods to inputs; detect anomalies, do compression.
- **Conditional generation:** generate $x$ given conditioning signal $c$ (text-to-image, speech synthesis, code generation).
- **Understanding:** modeling $p(x)$ requires understanding the data, not just discriminating classes.

## The Core Challenge

$p_\text{data}(x)$ is unknown and lives in a very high-dimensional space (e.g., a $256 \times 256$ RGB image is a point in $\mathbb{R}^{196608}$). The model must generalize from finite samples to a continuous distribution.

**Curse of dimensionality:** naive approaches (histograms, KDE) become hopelessly sparse in high dimensions. All modern generative models use some form of structured inductive bias to make this tractable.

## Taxonomy of Generative Models

| Family | Tractable likelihood | Sampling speed | Key mechanism |
|--------|---------------------|---------------|---------------|
| Autoregressive | Yes (exact) | Slow (sequential) | Chain rule factorization |
| VAE | Approximate (ELBO) | Fast | Amortized variational inference |
| GAN | No | Fast | Adversarial training |
| Normalizing Flow | Yes (exact) | Fast | Invertible transformations |
| Diffusion | Approximate (ELBO) | Slow (iterative) | Denoising score matching |
| Energy-based | Unnormalized | Slow (MCMC) | Learned energy function |
| Score-based | No explicit | Slow (SDE/ODE) | Score function estimation |

## Evaluating Generative Models

Evaluation is harder than for discriminative models since there is no single ground-truth label.

### Sample Quality

**FID (Fréchet Inception Distance):** compares statistics of real and generated images in a feature space (InceptionV3 activations):

$$\text{FID} = \|\mu_r - \mu_g\|^2 + \text{Tr}\!\left(\Sigma_r + \Sigma_g - 2(\Sigma_r \Sigma_g)^{1/2}\right)$$

Lower is better. Most widely used metric for images.

**IS (Inception Score):** measures sharpness (low $H(y|x)$) and diversity (high $H(y)$):

$$\text{IS} = \exp(\mathbb{E}_x[D_\text{KL}(p(y|x) \| p(y))])$$

Higher is better, but does not compare to real data.

**Precision and Recall:** precision measures sample quality (fraction of generated samples that are realistic); recall measures coverage (fraction of real data modes that are captured).

### Likelihood

For models that compute exact or approximate log-likelihood, report **bits per dimension (BPD)**:

$$\text{BPD} = -\frac{\log_2 p_\theta(x)}{d}$$

where $d$ is the dimensionality. Lower is better.

**Caveat:** high likelihood does not guarantee good visual quality, and vice versa. Pixel-level likelihoods weight all dimensions equally; perceptual quality depends on high-level structure.

## Latent Variable Models

Many generative models introduce a latent variable $z$:

$$p_\theta(x) = \int p_\theta(x|z) p(z) \, dz$$

The prior $p(z)$ is typically $\mathcal{N}(0, I)$. Sampling: draw $z \sim p(z)$, then $x \sim p_\theta(x|z)$.

The integral is generally intractable, motivating approximate inference (VAEs) or implicit models (GANs).

## Conditional Generation

All generative model families can be conditioned on a signal $c$:

$$p_\theta(x|c) \quad \text{or} \quad p_\theta(x|z, c)$$

**Conditioning mechanisms:** concatenate $c$ to input, use cross-attention (Transformers), use classifier-free guidance (diffusion models), or condition via adaptive normalization (AdaIN, FiLM).

**Classifier-free guidance (Ho & Salimans 2021):** interpolate between conditional and unconditional score:

$$\tilde{\nabla}_x \log p(x|c) = (1 + w)\nabla_x \log p_\theta(x|c) - w \nabla_x \log p_\theta(x)$$

Guidance scale $w > 0$ trades diversity for fidelity. Used in DALL-E 2, Stable Diffusion, Imagen.

## Common Architectures Used as Backbones

| Architecture | Typical Use |
|-------------|------------|
| U-Net | Diffusion model denoiser (image) |
| Transformer (decoder) | Autoregressive models (language, image) |
| Transformer (encoder-decoder) | Conditional generation (text-to-image) |
| ResNet / CNN | GAN generator and discriminator |
| MLP | Normalizing flows (coupling layers) |
