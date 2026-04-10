# Score Based Models

Score-based models learn the **score function** of the data distribution, which is the gradient of the log-density with respect to the data:

$$s_\theta(x) \approx \nabla_x \log p_\text{data}(x)$$

The score points in the direction of increasing data density. Knowing it is sufficient for sampling (via Langevin dynamics) without ever computing the intractable partition function $Z$.

## Why the Score?

For an EBM $p_\theta(x) = e^{-E_\theta(x)} / Z(\theta)$:

$$\nabla_x \log p_\theta(x) = -\nabla_x E_\theta(x)$$

The partition function $Z(\theta)$ drops out! The score can be learned and used without normalization.

## Score Matching

**Hyvärinen (2005):** minimize the expected squared distance between the model score and the data score:

$$J_\text{SM}(\theta) = \mathbb{E}_{p_\text{data}}\!\left[\frac{1}{2}\|s_\theta(x) - \nabla_x \log p_\text{data}(x)\|^2\right]$$

The data score $\nabla_x \log p_\text{data}(x)$ is unknown, but integration by parts yields an equivalent objective that only requires $p_\text{data}$ samples:

$$J_\text{SM}(\theta) = \mathbb{E}_{p_\text{data}}\!\left[\text{tr}(\nabla_x s_\theta(x)) + \frac{1}{2}\|s_\theta(x)\|^2\right] + \text{const}$$

The trace of the Jacobian $\text{tr}(\nabla_x s_\theta(x))$ is expensive to compute exactly; approximated via Hutchinson's estimator.

## Denoising Score Matching

Add Gaussian noise $\tilde{x} = x + \sigma \epsilon$ to perturbed samples and learn the score of the noisy distribution:

$$J_\text{DSM}(\theta) = \mathbb{E}_{\tilde{x}, x}\!\left[\|s_\theta(\tilde{x}, \sigma) - \nabla_{\tilde{x}} \log q_\sigma(\tilde{x}|x)\|^2\right]$$

The conditional score is available in closed form:

$$\nabla_{\tilde{x}} \log q_\sigma(\tilde{x}|x) = -\frac{\tilde{x} - x}{\sigma^2}$$

So the network learns to predict $(\tilde{x} - x)/\sigma^2$, equivalent to predicting the noise:

$$J_\text{DSM} \propto \mathbb{E}\!\left[\|s_\theta(\tilde{x}, \sigma) + \epsilon/\sigma\|^2\right]$$

**Connection to diffusion:** denoising score matching is exactly the training objective of DDPM (noise prediction loss). See [Diffusion Models](04-diffusion-models).

## Noise Conditional Score Network (NCSN)

Song & Ermon (2019). Train a single network $s_\theta(x, \sigma)$ conditioned on the noise level $\sigma$ to estimate scores at multiple noise scales $\sigma_1 > \sigma_2 > \cdots > \sigma_L$:

$$\mathcal{L} = \sum_{l=1}^L \lambda(\sigma_l) \mathbb{E}_{p_{\sigma_l}(\tilde{x}|x)}\!\left[\|s_\theta(\tilde{x}, \sigma_l) - \nabla_{\tilde{x}} \log p_{\sigma_l}(\tilde{x}|x)\|^2\right]$$

Sampling via **annealed Langevin dynamics**: start at high noise, run Langevin, reduce noise level, repeat.

## Stochastic Differential Equations (SDEs)

Song et al. (2021) unifies diffusion models and score-based models under a continuous SDE framework.

**Forward SDE** (noising process):

$$dx = f(x, t) \, dt + g(t) \, dW$$

- $f$: drift coefficient (deterministic).
- $g$: diffusion coefficient (noise scale).
- $W$: standard Wiener process (Brownian motion).

**Reverse SDE** (denoising process, Anderson 1982):

$$dx = [f(x, t) - g(t)^2 \nabla_x \log p_t(x)] \, dt + g(t) \, d\bar{W}$$

This requires the score $\nabla_x \log p_t(x)$ at each time $t$, which is learned by the score network $s_\theta(x, t)$.

**DDPM as SDE:** corresponds to the Variance Preserving (VP) SDE with specific $f$ and $g$.

**SMLD (NCSN) as SDE:** corresponds to the Variance Exploding (VE) SDE.

## Probability Flow ODE

Every SDE has a corresponding deterministic ODE with the same marginal densities:

$$\frac{dx}{dt} = f(x, t) - \frac{1}{2} g(t)^2 \nabla_x \log p_t(x)$$

**Benefits of ODE sampling:**
- Deterministic; exact inversion via reverse-time ODE (enables image editing).
- Can use fast ODE solvers (fewer function evaluations than SDE).
- Enables exact likelihood computation via the instantaneous change of variables formula.

**DDIM** is a special case of the probability flow ODE sampler.

## Score Distillation Sampling (SDS)

Uses a pretrained diffusion model's score as a loss to optimize a separate model (e.g., NeRF, mesh, image):

$$\nabla_\theta \mathcal{L}_\text{SDS} = \mathbb{E}_{t, \epsilon}\!\left[w(t)(\hat{\epsilon}_\phi(z_t, t, c) - \epsilon) \frac{\partial z}{\partial \theta}\right]$$

The diffusion model provides a gradient signal without differentiating through the entire diffusion process. Used in DreamFusion (text-to-3D), Magic3D, and text-guided image editing.

## Tweedie's Formula

The posterior mean estimate of $x_0$ given noisy $x_t$:

$$\mathbb{E}[x_0 | x_t] = \frac{x_t + (1-\bar{\alpha}_t) s_\theta(x_t, t)}{\sqrt{\bar{\alpha}_t}}$$

Reveals that the score function at noise level $t$ is equivalent to the optimal denoiser. Connects denoising, score matching, and diffusion in a single formula.

## Connections Between Model Families

| Framework | Score Perspective |
|-----------|------------------|
| DDPM | Predicts noise $\epsilon = -\sigma \cdot s(x_t, t)$ (equivalent to score) |
| NCSN | Directly predicts $\nabla_x \log p_\sigma(x)$ |
| SDE framework | Unifies both via VP/VE SDE |
| Flow matching | Learns the vector field $v_t$ instead of the score; equivalent in limit |
| EBM | Score = negative energy gradient $-\nabla_x E_\theta(x)$ |

The score function is the central quantity connecting diffusion models, EBMs, and normalizing flows.
