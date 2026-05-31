---
title: "Generative Adversarial Nets (GANs)"
year: 2014
authors: Ian J. Goodfellow, Jean Pouget-Abadie, Mehdi Mirza, Bing Xu, David Warde-Farley, Sherjil Ozair, Aaron Courville, Yoshua Bengio
area: Deep Learning, Generative Models
link: https://arxiv.org/abs/1406.2661
---

## The problem with prior generative models

Before GANs, generative models required either computing or approximating the intractable likelihood p(x). Boltzmann machines needed expensive MCMC sampling. VAEs optimized a lower bound on the likelihood. GANs sidestep likelihood estimation entirely by framing generation as a two-player game between a generator and a discriminator, requiring neither.

## The adversarial objective

The core contribution is the minimax game:

min_G max_D E_{x~p_data}[log D(x)] + E_{z~p(z)}[log(1 - D(G(z)))]

The generator G takes a noise vector z as input and produces a synthetic sample G(z). The discriminator D takes any sample and outputs the probability that it came from the real data distribution. D is trained to maximize its classification accuracy on both real and fake samples. G is trained to minimize D's ability to distinguish its outputs from real data. At the theoretical optimum, G's distribution exactly matches the data distribution and D outputs 0.5 everywhere, provably derived using optimal transport arguments. In practice, G is trained to maximize log D(G(z)) rather than minimize log(1 - D(G(z))), because the latter saturates and produces near-zero gradients early in training when D is confident that G's outputs are fake.

## Training dynamics and instabilities

Training alternates: update D for one step with G fixed, then update G for one step with D fixed. This alternating update procedure is the source of GAN training instability. If D becomes too strong, G receives no useful gradient signal. If G moves too fast, D cannot track it. Mode collapse is a persistent failure mode where G learns to produce a narrow set of outputs that reliably fool D, ignoring large portions of the data distribution. D adapts to those specific outputs, G shifts, but the diversity never improves because neither player is incentivized to cover the full distribution.

## Improvements and successors

Wasserstein GAN replaced the Jensen-Shannon divergence implicit in the original objective with the Wasserstein distance, providing stable gradient signal even when G and D have non-overlapping support. It requires enforcing a Lipschitz constraint on D via weight clipping or gradient penalty. Progressive training, used in StyleGAN, starts G and D at low resolution and simultaneously increases resolution during training, stabilizing the process by avoiding the difficult problem of learning global structure and fine detail simultaneously.

## Results and impact

The original GAN produced blurry, low-resolution samples on small datasets. Despite this, the adversarial framework became the dominant approach to image synthesis over the following years. StyleGAN, BigGAN, and CycleGAN all extend the core framework. GANs remained the state of the art for image generation until diffusion models displaced them around 2022.
