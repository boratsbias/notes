# Generative Modeling Overview

## Core Idea

Generative models aim to learn the data distribution itself, or a process that can sample realistic data from it.

If data comes from an unknown distribution $P_{data}(x)$, a generative model tries to approximate it with $P_\theta(x)$.

## Generative vs Discriminative

### Generative Models

Model the distribution of data, often $P(x)$ or $P(x, y)$.

- can generate new samples
- can estimate likelihood or density in some cases
- often useful for representation learning

### Discriminative Models

Model a decision boundary or conditional mapping such as $P(y|x)$.

- optimized directly for prediction
- usually better when only classification accuracy matters

## Main Objectives

Generative modeling is used to:

- sample realistic text, images, audio, or video
- estimate uncertainty
- fill in missing data
- compress or represent data in latent spaces
- simulate future trajectories or observations

## Major Model Families

| Family | Main Idea | Typical Strength |
|--------|-----------|------------------|
| Autoregressive | Factorize joint distribution into conditional terms | Strong likelihood modeling |
| Variational autoencoders | Learn latent variables with approximate inference | Stable latent representations |
| GANs | Generator competes with discriminator | Sharp sample quality |
| Diffusion models | Denoise samples step by step | High-fidelity generation |
| Normalizing flows | Invertible mapping from simple base distribution | Exact likelihood |
| Energy-based models | Assign low energy to realistic samples | Flexible formulation |

## Autoregressive Factorization

By the chain rule:

$$P(x_1, x_2, \ldots, x_T) = \prod_{t=1}^T P(x_t \mid x_{<t})$$

This idea underlies language models and many sequence generators.

## Latent Variable Models

Introduce hidden variables $z$:

$$P(x) = \int P(x|z)P(z)\,dz$$

Latent variables can capture abstract factors such as style, topic, identity, or pose.

## Evaluation

Generative models are harder to evaluate than classifiers because there is no single universal metric.

Common evaluation criteria:

- sample quality
- diversity
- likelihood or perplexity
- reconstruction quality
- controllability
- downstream usefulness

## Tradeoffs

Different model families optimize different goals.

- exact likelihood vs sample fidelity
- stable training vs expressive sampling
- fast generation vs high quality
- interpretable latent space vs raw performance

## Common Challenges

- mode collapse
- blurry outputs
- exposure bias
- expensive sampling
- evaluation mismatch
- memorization of training examples

## Why Generative Models Matter

Generative models are central to modern AI because they support:

- language generation
- image and video synthesis
- speech generation
- world modeling
- self supervised pretraining
- multimodal systems
