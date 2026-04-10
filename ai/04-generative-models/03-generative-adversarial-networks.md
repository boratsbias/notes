# Generative Adversarial Networks

Generative Adversarial Networks (GANs) frame generative modeling as a two-player minimax game between a **generator** $G$ and a **discriminator** $D$. The generator tries to fool the discriminator; the discriminator tries to distinguish real from generated samples.

## The Minimax Objective

$$\min_G \max_D \; V(G, D) = \mathbb{E}_{x \sim p_\text{data}}[\log D(x)] + \mathbb{E}_{z \sim p(z)}[\log(1 - D(G(z)))]$$

- $G_\theta: z \to x$; maps noise $z \sim \mathcal{N}(0,I)$ to a sample in data space.
- $D_\phi: x \to [0,1]$; estimates the probability that $x$ is real.

**Optimal discriminator** (for fixed $G$):

$$D^*(x) = \frac{p_\text{data}(x)}{p_\text{data}(x) + p_G(x)}$$

**Optimal generator:** at the global optimum, $p_G = p_\text{data}$ and $D^*(x) = 1/2$ everywhere.

**Minimax connection:** at the optimal discriminator, the minimax objective equals $2 \cdot \text{JSD}(p_\text{data} \| p_G) - \log 4$, where JSD is the Jensen-Shannon divergence.

## Training in Practice

Alternate between:

1. **Discriminator step:** sample real batch $\{x_i\}$ and fake batch $\{G(z_i)\}$; maximize $V$ w.r.t. $\phi$.
2. **Generator step:** sample $\{z_i\}$; minimize $V$ w.r.t. $\theta$.

**Non-saturating generator loss:** instead of minimizing $\log(1 - D(G(z)))$ (saturates early), maximize $\log D(G(z))$. Same fixed point but stronger gradients early in training.

## Training Instabilities

### Mode Collapse

Generator produces a limited subset of the data distribution, ignoring most modes. Discriminator cannot distinguish this since it only sees the current generator output.

**Mitigations:** minibatch discrimination, unrolled GANs, diverse training objectives.

### Vanishing Gradients

If the discriminator is too good early on, $D(G(z)) \approx 0$ and $\nabla_\theta \log(1-D(G(z))) \approx 0$. Generator receives no useful signal.

**Mitigations:** non-saturating loss, careful learning rate balancing, Wasserstein loss.

### Training Oscillation

Generator and discriminator do not converge to a fixed point but cycle around it.

## Wasserstein GAN (WGAN)

Replaces JSD with **Earth Mover's (Wasserstein-1) distance**, which is smoother and provides meaningful gradients even when the distributions have disjoint support:

$$W(p, q) = \sup_{\|f\|_L \leq 1} \mathbb{E}_{x \sim p}[f(x)] - \mathbb{E}_{x \sim q}[f(x)]$$

The critic $f$ (unbounded, replaces $D$) must satisfy the 1-Lipschitz constraint.

**WGAN objective:**

$$\min_G \max_{\|f\|_L \leq 1} \mathbb{E}_{x \sim p_\text{data}}[f(x)] - \mathbb{E}_{z}[f(G(z))]$$

**Gradient penalty (WGAN-GP):** enforce Lipschitz by penalizing $|\nabla_{\hat{x}} f(\hat{x})| \neq 1$, where $\hat{x}$ is sampled along straight lines between real and fake:

$$\mathcal{L}_\text{GP} = \lambda \, \mathbb{E}_{\hat{x}}[(\|\nabla_{\hat{x}} f(\hat{x})\|_2 - 1)^2]$$

More stable training than weight clipping.

## Progressive GAN (ProGAN)

Trains both generator and discriminator starting at low resolution ($4\times4$) and progressively adds layers to increase resolution. New layers are faded in smoothly using a blending factor $\alpha$.

Produces very high-quality faces (CelebA-HQ); enables 1024×1024 image generation. Foundation for StyleGAN.

## StyleGAN / StyleGAN2

Introduces a **mapping network** $f: z \to w$ (8-layer MLP) that maps the latent code $z$ to an intermediate latent space $\mathcal{W}$. Style vectors from $\mathcal{W}$ are injected via **Adaptive Instance Normalization (AdaIN)** at each generator layer:

$$\text{AdaIN}(x_i, y) = y_{s,i} \frac{x_i - \mu(x_i)}{\sigma(x_i)} + y_{b,i}$$

where $y = (y_s, y_b)$ come from a learned affine transform of $w$.

**StyleGAN2 improvements:** removes normalization artifacts via demodulation, path length regularization for smooth $\mathcal{W}$ space.

**Stochastic variation:** per-pixel Gaussian noise injected at each layer adds fine-grained stochastic detail (hair, pores) independent of the style code.

The $\mathcal{W}$ space is more disentangled than $\mathcal{Z}$ because the mapping network can learn to linearize the data manifold.

## Conditional GANs (cGAN)

Condition both generator and discriminator on a label $y$:

$$\min_G \max_D \; \mathbb{E}[\log D(x, y)] + \mathbb{E}[\log(1 - D(G(z, y), y))]$$

**Projection discriminator:** project label embedding and take inner product with discriminator features. Stronger conditioning than concatenation.

**BigGAN:** large-scale cGAN with class-conditional BatchNorm in generator and truncation trick ($z$ sampled from truncated normal for quality/diversity tradeoff).

## Image-to-Image Translation

### Pix2Pix

Paired image-to-image translation (edge maps to photos, segmentation to scenes). Combines adversarial loss with L1 reconstruction loss:

$$\mathcal{L} = \mathcal{L}_\text{cGAN}(G, D) + \lambda \mathbb{E}[\|y - G(x)\|_1]$$

### CycleGAN

Unpaired image translation. Two generators $G: X \to Y$ and $F: Y \to X$. Cycle consistency:

$$\mathcal{L}_\text{cyc} = \mathbb{E}[\|F(G(x)) - x\|_1] + \mathbb{E}[\|G(F(y)) - y\|_1]$$

Learns mappings without paired data (horses to zebras, summer to winter).

## GAN Evaluation

**FID (Fréchet Inception Distance):** standard metric. Lower is better. See [Generative Modeling Overview](00-generative-modeling-overview).

**Precision and Recall:** precision = sample fidelity; recall = mode coverage.

**Truncation trick:** sample $z$ from a truncated normal. Higher truncation: better quality, less diversity.

## Comparison of Key GAN Variants

| Variant | Key Contribution | Metric |
|---------|-----------------|--------|
| Vanilla GAN | Original formulation | JSD |
| WGAN | Wasserstein distance | W-distance |
| WGAN-GP | Gradient penalty for Lipschitz | W-distance |
| ProGAN | Progressive growing | FID (faces) |
| StyleGAN2 | Style-based generator, $\mathcal{W}$ space | FID (SOTA faces) |
| BigGAN | Large-scale class-conditional | FID (ImageNet) |
| CycleGAN | Unpaired image translation | FID, user study |
