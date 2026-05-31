# Auto-Encoding Variational Bayes (VAE) (2013)

**Authors:** Diederik P. Kingma, Max Welling
**Area:** Deep Learning, Generative Models
**Link:** [arXiv](https://arxiv.org/abs/1312.6114)

## What the paper argues

Learning a generative model over high-dimensional data (images, text) requires computing intractable integrals over latent variables. VAE introduces a neural network encoder that approximates the otherwise intractable posterior, jointly trained with a decoder using a variational lower bound. The result is a generative model with a smooth, continuous latent space that can be sampled and interpolated.

## Architecture

```
Input x
  ↓
Encoder q_φ(z|x)  →  outputs μ and σ (not a single point, a distribution)
  ↓
Sample z ~ N(μ, σ²)   using reparameterization trick: z = μ + σ · ε, ε ~ N(0,1)
  ↓
Decoder p_θ(x|z)  →  reconstructs x from z
```

The **reparameterization trick** is the key technical contribution: by expressing z = μ + σ·ε with ε ~ N(0,1), the sampling operation moves outside the computation graph and gradients can flow back through μ and σ to the encoder.

## The ELBO objective

Training maximizes the Evidence Lower BOund (ELBO):

```
ELBO = E_{q(z|x)}[log p(x|z)]  -  KL(q(z|x) || p(z))
        ─────────────────────     ──────────────────────
         reconstruction loss        regularization term
```

The reconstruction loss pushes the decoder to reproduce the input. The KL term pulls the encoder's posterior toward the standard Gaussian prior N(0,I), making the latent space smooth and compact so that arbitrary z samples decode into plausible outputs.

## Results and impact

VAEs produce a smooth interpolable latent space: points between two latent codes decode to sensible intermediate images. Became a foundational generative model used for representation learning, anomaly detection, and as a component in diffusion models (Stable Diffusion encodes images into a VAE latent space before running the diffusion process).
