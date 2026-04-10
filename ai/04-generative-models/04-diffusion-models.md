# Diffusion Models

Diffusion models are latent variable generative models that learn to reverse a fixed noising process. They gradually destroy structure in data by adding Gaussian noise, then train a neural network to denoise step by step. Sampling runs the reverse process from pure noise to clean data.

## The Forward Process

Define a Markov chain that adds Gaussian noise to data over $T$ steps:

$$q(x_t | x_{t-1}) = \mathcal{N}(x_t; \sqrt{1 - \beta_t} \, x_{t-1}, \beta_t I)$$

where $\beta_1 < \beta_2 < \cdots < \beta_T$ is a **noise schedule** (small positive values).

**Key property:** $x_t$ can be sampled directly from $x_0$ in closed form. Let $\alpha_t = 1 - \beta_t$ and $\bar{\alpha}_t = \prod_{s=1}^t \alpha_s$:

$$q(x_t | x_0) = \mathcal{N}(x_t; \sqrt{\bar{\alpha}_t} \, x_0, (1 - \bar{\alpha}_t) I)$$

Equivalently: $x_t = \sqrt{\bar{\alpha}_t} \, x_0 + \sqrt{1 - \bar{\alpha}_t} \, \epsilon$, where $\epsilon \sim \mathcal{N}(0, I)$.

As $T \to \infty$ with appropriate schedule: $q(x_T) \approx \mathcal{N}(0, I)$.

## The Reverse Process

The reverse process recovers $x_0$ from $x_T$ step by step:

$$p_\theta(x_{t-1} | x_t) = \mathcal{N}(x_{t-1}; \mu_\theta(x_t, t), \Sigma_\theta(x_t, t))$$

$\mu_\theta$ and $\Sigma_\theta$ are predicted by a neural network (typically a U-Net) conditioned on the time step $t$.

**Posterior of forward process** (tractable given $x_0$):

$$q(x_{t-1} | x_t, x_0) = \mathcal{N}(x_{t-1}; \tilde{\mu}(x_t, x_0), \tilde{\beta}_t I)$$

$$\tilde{\mu}_t(x_t, x_0) = \frac{\sqrt{\bar{\alpha}_{t-1}} \beta_t}{1 - \bar{\alpha}_t} x_0 + \frac{\sqrt{\alpha_t}(1 - \bar{\alpha}_{t-1})}{1 - \bar{\alpha}_t} x_t$$

$$\tilde{\beta}_t = \frac{1 - \bar{\alpha}_{t-1}}{1 - \bar{\alpha}_t} \beta_t$$

## DDPM Training Objective

The ELBO on $\log p_\theta(x_0)$ simplifies to a denoising objective. Ho et al. (2020) show that predicting the noise $\epsilon$ is equivalent and works better in practice:

$$\mathcal{L}_\text{simple} = \mathbb{E}_{t, x_0, \epsilon}\!\left[\|\epsilon - \epsilon_\theta(\sqrt{\bar{\alpha}_t} x_0 + \sqrt{1-\bar{\alpha}_t}\epsilon, t)\|^2\right]$$

At each training step:
1. Sample $x_0 \sim p_\text{data}$, $\epsilon \sim \mathcal{N}(0,I)$, $t \sim \text{Uniform}(1, T)$.
2. Compute noisy sample $x_t = \sqrt{\bar{\alpha}_t} x_0 + \sqrt{1-\bar{\alpha}_t} \epsilon$.
3. Predict $\epsilon_\theta(x_t, t)$ with the network.
4. Minimize MSE between predicted and true noise.

Given the predicted noise, the predicted mean is:

$$\mu_\theta(x_t, t) = \frac{1}{\sqrt{\alpha_t}}\!\left(x_t - \frac{\beta_t}{\sqrt{1 - \bar{\alpha}_t}} \epsilon_\theta(x_t, t)\right)$$

## DDPM Sampling

Ancestral sampling from $x_T \sim \mathcal{N}(0, I)$:

$$x_{t-1} = \frac{1}{\sqrt{\alpha_t}}\!\left(x_t - \frac{\beta_t}{\sqrt{1-\bar{\alpha}_t}} \epsilon_\theta(x_t, t)\right) + \sqrt{\tilde{\beta}_t} \, z, \quad z \sim \mathcal{N}(0,I)$$

Requires $T = 1000$ steps. Expensive for inference.

## DDIM (Denoising Diffusion Implicit Models)

Reimagines the reverse process as a non-Markovian deterministic update, using the same trained $\epsilon_\theta$:

$$x_{t-1} = \sqrt{\bar{\alpha}_{t-1}} \underbrace{\left(\frac{x_t - \sqrt{1-\bar{\alpha}_t}\epsilon_\theta(x_t, t)}{\sqrt{\bar{\alpha}_t}}\right)}_{\text{predicted } x_0} + \sqrt{1 - \bar{\alpha}_{t-1} - \sigma_t^2} \, \epsilon_\theta(x_t, t) + \sigma_t \epsilon$$

Setting $\sigma_t = 0$ gives a **deterministic** (ODE-based) sampler. Allows using only 50-100 steps without retraining.

DDIM also enables **inversion**: given a real image $x_0$, find $x_T$ by running the ODE forward deterministically. Enables image editing.

## Noise Schedules

| Schedule | Form | Notes |
|----------|------|-------|
| Linear (DDPM) | $\beta_t$ linear from $10^{-4}$ to $0.02$ | Original; destroys signal too early |
| Cosine (iDDPM) | $\bar{\alpha}_t = \cos^2\!\left(\frac{t/T + s}{1+s} \cdot \frac{\pi}{2}\right)$ | Smoother; better for small images |
| Sigmoid | Logistic-shaped | Avoids near-zero SNR at boundaries |

## Conditional Diffusion Models

### Classifier Guidance

Train a classifier $p_\phi(y|x_t)$ on noisy images. At each denoising step, shift the mean by the classifier gradient:

$$\tilde{\mu}_\theta(x_t) = \mu_\theta(x_t) + s \cdot \Sigma_\theta \nabla_{x_t} \log p_\phi(y | x_t)$$

Guidance scale $s$ trades diversity for fidelity. Requires training a separate noisy classifier.

### Classifier-Free Guidance (CFG)

Train a single model jointly on conditional $\epsilon_\theta(x_t, t, c)$ and unconditional $\epsilon_\theta(x_t, t, \varnothing)$ (randomly drop conditioning with probability $p_\text{uncond}$):

$$\tilde{\epsilon}_\theta = (1 + w)\epsilon_\theta(x_t, t, c) - w\epsilon_\theta(x_t, t, \varnothing)$$

No separate classifier needed. $w > 0$ increases adherence to condition. Default in all modern systems (Stable Diffusion, DALL-E 3, Imagen).

## Latent Diffusion Models (LDM)

Running diffusion in pixel space is expensive. LDMs (Rombach et al. 2022 = Stable Diffusion) run diffusion in a compressed latent space:

1. Train an autoencoder (VAE or VQVAE): $x \to z = \mathcal{E}(x)$, $z \to \hat{x} = \mathcal{D}(z)$.
2. Train diffusion model in the latent space $z$ instead of pixel space $x$.
3. At inference: sample $z_0$ via reverse diffusion, decode $\hat{x} = \mathcal{D}(z_0)$.

Compression factor $f = 8$ (spatial $512\times512 \to 64\times64$) reduces compute by $\sim 64\times$.

**Conditioning in LDMs:** condition the U-Net denoiser via cross-attention on text embeddings (CLIP, T5, etc.).

## Architecture: U-Net Denoiser

The backbone for most diffusion models is a U-Net with:
- Residual blocks at each scale.
- Self-attention at low-resolution scales.
- Cross-attention for conditioning signals.
- Time embedding: $t$ encoded as sinusoidal embedding, added to residual blocks via adaptive group normalization or MLP projection.

**DiT (Diffusion Transformer):** replaces U-Net with a Vision Transformer. Scales better; used in Sora and Stable Diffusion 3.

## Key Models

| Model | Setting | Key Contribution |
|-------|---------|-----------------|
| DDPM | Pixel space, unconditional | Simplified ELBO, noise prediction |
| DDIM | Pixel space | Deterministic fast sampling |
| Stable Diffusion (LDM) | Latent space, text-conditional | Efficient latent diffusion + CFG |
| DALL-E 2 | Pixel space + CLIP | CLIP-guided prior + diffusion decoder |
| Imagen | Pixel space, cascaded | T5 text encoder + cascaded super-res |
| DiT | Latent space | Transformer denoiser |
| Sora | Video, latent | Spatiotemporal DiT |
