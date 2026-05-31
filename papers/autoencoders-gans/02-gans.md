# Generative Adversarial Nets (GANs) (2014)

**Authors:** Ian J. Goodfellow, Jean Pouget-Abadie, Mehdi Mirza, Bing Xu, David Warde-Farley, Sherjil Ozair, Aaron Courville, Yoshua Bengio
**Area:** Deep Learning, Generative Models
**Link:** [arXiv](https://arxiv.org/abs/1406.2661)

## What the paper argues

Learning generative models traditionally requires computing or approximating intractable likelihoods. GANs avoid this entirely: two networks play a minimax game against each other until the generator produces samples indistinguishable from real data, without ever computing a likelihood.

## The adversarial game

```
Generator G:      noise z ~ p(z)  →  fake sample G(z)
Discriminator D:  sample x        →  probability that x is real (not from G)

G tries to fool D  (maximize D's error on fake samples)
D tries to catch G  (correctly classify real vs fake)
```

The minimax objective:

```
min_G max_D  E_{x~p_data}[log D(x)] + E_{z~p(z)}[log(1 - D(G(z)))]
```

At the theoretical optimum, G's distribution matches the data distribution exactly and D outputs 0.5 everywhere. In practice, G is trained to maximize log D(G(z)) rather than minimize log(1-D(G(z))) to avoid vanishing gradients early in training.

## Training procedure

```
Step 1:  sample real batch  +  generate fake batch
Step 2:  update D to maximize log D(x_real) + log(1 - D(G(z)))
Step 3:  sample new noise, update G to maximize log D(G(z))
         (keep D fixed during generator update)
```

## Known failure modes

**Mode collapse:** G generates a small set of high-quality outputs that fool D, rather than covering the full data distribution. D then adapts to reject them and the cycle continues without diversity.

**Training instability:** G and D can diverge or oscillate. Wasserstein GAN (WGAN) replaced the JS divergence implicit in the original loss with Wasserstein distance, which provides more stable gradients.

## Results and impact

The adversarial framework became the dominant approach to image synthesis. StyleGAN, BigGAN, and CycleGAN all use it. By 2022 diffusion models displaced GANs as the state of the art for image generation, but GAN training techniques remain influential.
