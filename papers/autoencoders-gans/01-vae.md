---
title: "Auto-Encoding Variational Bayes (VAE)"
year: 2013
authors: Diederik P. Kingma, Max Welling
area: Deep Learning, Generative Models
link: https://arxiv.org/abs/1312.6114
---

## The generative modeling problem

Learning a generative model over high-dimensional data like images requires computing the marginal likelihood p(x) = ∫ p(x|z) p(z) dz. This integral is intractable because it sums over all possible latent configurations z. Exact inference is impossible for all but trivial distributions, and naive Monte Carlo estimation is too expensive. The VAE addresses this by approximating the true posterior p(z|x) with a learned encoder network, then optimizing a tractable lower bound on log p(x).

## The ELBO and what it contains

The core contribution is the Evidence Lower BOund (ELBO), which the model maximizes:

ELBO = E_{q(z|x)}[log p(x|z)] - KL(q(z|x) || p(z))

The first term is the reconstruction objective: sample a latent code z from the encoder's distribution q_φ(z|x), pass it through the decoder p_θ(x|z), and measure how well the decoder reproduces the original input x. The second term is a KL divergence that regularizes the encoder's approximate posterior toward the standard Gaussian prior N(0, I). Without this term, the encoder would learn to map each input to a narrow spike in latent space, making the space useless for sampling because arbitrary z values would land in empty, unlearned regions.

## The reparameterization trick

Sampling z from q(z|x) is non-differentiable, so gradients cannot flow back through the sampling step to the encoder parameters. The reparameterization trick resolves this by writing z = μ + σ · ε where ε ~ N(0, 1). The stochasticity moves into ε, which has no learned parameters, while μ and σ are deterministic outputs of the encoder. Gradients can now flow through μ and σ normally, making the entire model trainable end-to-end with standard backpropagation.

## Latent space structure and applications

After training, the KL term forces the encoder to produce posteriors that overlap with N(0, I), which makes the latent space smooth and continuous. Interpolating linearly between two latent codes produces semantically intermediate outputs. Sampling a random z decodes into a plausible data point. These properties enable interpolation between data points, latent arithmetic, and anomaly detection by measuring reconstruction error plus KL divergence for out-of-distribution inputs. Stable Diffusion uses a VAE to compress 512×512 images into a 4×64×64 latent space before running the diffusion process, reducing compute by roughly 48x compared to operating in pixel space.

## Results and impact

The VAE established variational inference as a practical tool for deep generative modeling. The reparameterization trick became a standard component for training any latent variable model with continuous latent codes. The ELBO formulation directly influenced subsequent work including conditional VAEs, hierarchical VAEs, and VQ-VAE. The framework remains foundational to the latent diffusion architecture that underlies most production image generation systems.
