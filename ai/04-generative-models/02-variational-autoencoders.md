# Variational Autoencoders

Variational Autoencoders (VAEs) are latent variable generative models trained by maximizing a tractable lower bound on the log-likelihood. They simultaneously learn a generative model $p_\theta(x \mid z)$ and an inference model (encoder) $q_\phi(z \mid x)$.

## The Generative Model

$$p_\theta(x) = \int p_\theta(x \mid z) p(z) \, dz$$

- **Prior:** $p(z) = \mathcal{N}(0, I)$, a standard Gaussian in $\mathbb{R}^d$.
- **Decoder:** $p_\theta(x \mid z)$, a neural network mapping latent $z$ to a distribution over $x$.
- **Marginal likelihood:** the integral is intractable for nonlinear decoders.

## The ELBO

Since $\log p_\theta(x)$ is intractable, introduce an approximate posterior $q_\phi(z \mid x)$ (the encoder) and derive the **Evidence Lower Bound (ELBO)**:

$$\log p_\theta(x) \geq \mathcal{L}(\theta, \phi; x) = \mathbb{E}_{q_\phi(z \mid x)}[\log p_\theta(x \mid z)] - D_\text{KL}(q_\phi(z \mid x) \| p(z))$$

**Derivation:**

$$\log p_\theta(x) = \mathcal{L}(\theta, \phi; x) + D_\text{KL}(q_\phi(z \mid x) \| p_\theta(z \mid x)) \geq \mathcal{L}$$

since $D_\text{KL} \geq 0$. Equality holds when $q_\phi(z \mid x) = p_\theta(z \mid x)$ exactly.

**Reconstruction term:** $\mathbb{E}_{q_\phi}[\log p_\theta(x \mid z)]$. Encourages the decoder to reconstruct $x$ from $z$.

**KL term:** $D_\text{KL}(q_\phi(z \mid x) \| p(z))$. Regularizes the posterior toward the prior. For Gaussian encoder and prior, has a closed form:

$$D_\text{KL}(\mathcal{N}(\mu, \sigma^2 I) \| \mathcal{N}(0, I)) = \frac{1}{2}\sum_{j=1}^d (\mu_j^2 + \sigma_j^2 - \log \sigma_j^2 - 1)$$

## Gaussian VAE

**Encoder:** $q_\phi(z \mid x) = \mathcal{N}(\mu_\phi(x), \text{diag}(\sigma^2_\phi(x)))$

The encoder network outputs $\mu_\phi(x)$ and $\log \sigma^2_\phi(x)$ (log-variance for numerical stability).

**Decoder:** depends on data type:
- Continuous data: $p_\theta(x \mid z) = \mathcal{N}(\mu_\theta(z), \sigma^2 I)$, reconstruction loss = MSE.
- Binary data: $p_\theta(x \mid z) = \text{Bernoulli}(\mu_\theta(z))$, reconstruction loss = binary cross-entropy.

## The Reparameterization Trick

The ELBO involves $\mathbb{E}_{q_\phi(z \mid x)}[\cdot]$. Naive Monte Carlo sampling $z \sim q_\phi(z \mid x)$ is not differentiable with respect to $\phi$.

**Reparameterization:** sample $\epsilon \sim \mathcal{N}(0, I)$, then set:

$$z = \mu_\phi(x) + \sigma_\phi(x) \odot \epsilon$$

Now $z$ is a deterministic function of $\phi$ and $\epsilon$. Gradients $\partial z / \partial \phi$ exist and backpropagation flows through the sampling operation.

## Training Objective

$$\mathcal{L}(\theta, \phi; x) = -\mathcal{L}_\text{recon} + \mathcal{L}_\text{KL}$$

Maximize ELBO = maximize reconstruction likelihood + minimize KL divergence.

Mini-batch ELBO with one MC sample per data point (low variance in practice):

$$\mathcal{L} \approx \log p_\theta(x \mid z) - D_\text{KL}(q_\phi(z \mid x) \| p(z)), \quad z = \mu_\phi(x) + \sigma_\phi(x) \odot \epsilon$$

## KL Annealing and $\beta$-VAE

**KL collapse:** early in training, the KL term can dominate and push $q_\phi(z \mid x) \to p(z)$, making the encoder ignore the input. The decoder then learns to ignore $z$; latent space is unused.

**KL annealing:** start with $\beta = 0$ (pure reconstruction), gradually increase $\beta$ to 1.

**$\beta$-VAE (Higgins et al. 2017):** intentionally upweight the KL term by $\beta > 1$:

$$\mathcal{L}_\beta = \mathbb{E}_{q_\phi}[\log p_\theta(x \mid z)] - \beta \cdot D_\text{KL}(q_\phi(z \mid x) \| p(z))$$

Encourages disentangled latent representations: individual $z_j$ correspond to independent factors of variation. $\beta = 1$ recovers the standard VAE.

## Latent Space Properties

A well-trained VAE encodes semantically similar inputs to nearby latent codes. The continuous, smooth latent space enables:

- **Interpolation:** linearly interpolate between two encodings $z_1, z_2$ and decode intermediate points.
- **Arithmetic:** $z_\text{man with glasses} - z_\text{man} + z_\text{woman} \approx z_\text{woman with glasses}$.
- **Conditional generation:** condition decoder on class label or other attribute.

## Hierarchical VAEs

A single Gaussian posterior is a weak approximation. Hierarchical VAEs stack multiple latent layers:

$$p_\theta(x) = \int p_\theta(x \mid z_1) p_\theta(z_1 \mid z_2) \cdots p_\theta(z_{L-1} \mid z_L) p(z_L) \, dz_{1:L}$$

**NVAE, VDVAE:** deep hierarchical VAEs with residual connections in the latent hierarchy. Achieve competitive image generation quality.

## VQ-VAE (Vector Quantized VAE)

Replaces the continuous Gaussian latent with a discrete codebook:

1. Encoder maps $x$ to continuous vectors $z_e(x) \in \mathbb{R}^d$.
2. Each vector is replaced by the nearest codebook entry: $z_q = \arg\min_{e_k} \|z_e - e_k\|$.
3. Decoder reconstructs $x$ from $z_q$.

**Straight-through estimator:** since argmin is non-differentiable, pass gradients directly from decoder input to encoder output. Codebook updated via exponential moving average.

**Loss:** $\mathcal{L} = \|x - \hat{x}\|^2 + \|sg(z_e) - e\|^2 + \beta \|z_e - sg(e)\|^2$

where $sg$ is stop-gradient. Used in DALL-E (v1), AudioCodec, and as backbone for image generation with Transformers.

## Comparison with Other Generative Models

| Property | VAE | GAN | Diffusion |
|----------|-----|-----|----------|
| Exact likelihood | No (ELBO) | No | No (ELBO) |
| Sampling speed | Fast | Fast | Slow |
| Sample quality | Moderate (blurry) | High | Highest |
| Latent space | Structured, smooth | Unstructured | Implicit |
| Training stability | Stable | Unstable (mode collapse) | Stable |
| Encoder (inference) | Yes | No | No (or DDIM inversion) |
