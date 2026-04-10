# Autoregressive Models

Autoregressive models factorize the joint distribution over a sequence using the chain rule of probability, modeling each element conditioned on all previous elements.

$$p_\theta(x) = \prod_{t=1}^T p_\theta(x_t | x_1, \ldots, x_{t-1}) = \prod_{t=1}^T p_\theta(x_t | x_{<t})$$

This gives an exact, tractable likelihood. Any ordering of dimensions works; temporal or spatial orderings are most natural.

## Why Autoregressive?

- **Exact likelihood:** direct optimization via MLE: $\max_\theta \sum_i \log p_\theta(x_i)$.
- **No approximations:** unlike VAEs (ELBO) or diffusion models (ELBO), the objective is exact.
- **Flexible:** works for any discrete or continuous data with a defined ordering.
- **Expressive:** with a powerful enough conditional model, can represent any distribution.

**Drawback:** sampling is sequential; generating $T$ tokens requires $T$ forward passes. Slow for long sequences.

## Discrete Autoregressive Models

### Language Models (Transformers)

The dominant architecture. Each $p_\theta(x_t | x_{<t})$ is modeled by a decoder-only Transformer:

1. Embed tokens $x_{<t}$ as vectors.
2. Apply $L$ Transformer layers with **causal (masked) self-attention**: position $t$ can only attend to positions $\leq t$.
3. Project to vocabulary logits; apply softmax.

**Causal mask:** sets attention weights to $-\infty$ for future positions before softmax, ensuring no information flows from $x_{>t}$.

**Training:** cross-entropy loss summed over positions:

$$\mathcal{L} = -\sum_{t=1}^T \log p_\theta(x_t | x_{<t})$$

All positions trained in parallel (teacher forcing). Only inference is sequential.

**Key models:** GPT series, LLaMA, Mistral, Falcon.

### PixelCNN

Autoregressive model for images. Pixels generated in raster scan order (left to right, top to bottom).

**Masked convolutions:** convolutional filters are masked so that computing $p(x_t | x_{<t})$ only sees pixels already generated.

- **Type A mask (first layer):** excludes current pixel.
- **Type B mask (subsequent layers):** includes current pixel's channel (for RGB).

**PixelCNN++** adds logistic mixture model for pixel intensities, skip connections, and other improvements.

**Drawback:** slow inference (one pixel at a time for megapixel images = millions of passes).

### WaveNet

PixelCNN for audio waveforms. Uses **dilated causal convolutions** to achieve large receptive fields efficiently:

Dilation rates double each layer: $1, 2, 4, 8, 16, \ldots$. After $k$ layers: receptive field $= 2^k$ samples.

Gated activation: $z = \tanh(W_f * x) \odot \sigma(W_g * x)$.

16,000 samples/sec audio; each sample requires one forward pass at inference. Very slow without parallel WaveNet (knowledge distillation to inverse autoregressive flow).

## Continuous Autoregressive Models

For continuous data, $p_\theta(x_t | x_{<t})$ is a density (e.g., mixture of Gaussians, logistic mixture, or Gaussian with predicted mean and variance).

**MADE (Masked Autoencoder for Distribution Estimation):** single forward pass through a masked MLP computes all conditionals simultaneously. Masks ensure each output only depends on earlier inputs.

## Image Autoregressive Models at Scale

**ImageGPT (Chen et al. 2020):** treats pixels as tokens; trains a GPT-2 scale model on 9-bit pixel values. Shows that Transformer pretraining transfers to vision.

**VQVAE + Transformer:** two-stage approach:
1. Train a VQVAE to compress images to discrete token grids.
2. Train an autoregressive Transformer over the discrete token sequence.

This avoids modeling raw pixels; the Transformer operates in a compressed semantic space.

**VQ-GAN + Transformer (Taming Transformers):** similar but uses a GAN-trained codebook for sharper reconstructions.

## Speculative Decoding

Accelerates sequential sampling. A small draft model generates $k$ candidate tokens in parallel; a large target model verifies them in a single forward pass (since verification is parallelizable). Accepted tokens are kept; the first rejected token triggers resampling.

Speedup: $2\text{-}4\times$ for large language models with a well-matched draft model.

## Key-Value (KV) Cache

At inference, previously computed key and value tensors in each attention layer are cached and reused. Reduces per-step computation from $O(T)$ to $O(1)$ (for each new token) after the prompt is processed.

Memory cost: $2 \times L \times d \times T$ per sequence ($L$ layers, $d$ hidden dim). For long contexts, KV cache dominates GPU memory.

## Comparison

| Model | Data type | Architecture | Sampling speed |
|-------|-----------|-------------|---------------|
| GPT / LLaMA | Text tokens | Causal Transformer | Slow (token-by-token) |
| PixelCNN | Discrete pixels | Masked CNN | Very slow (pixel-by-pixel) |
| WaveNet | Audio samples | Dilated causal CNN | Very slow |
| VQVAE + Transformer | Image tokens | Transformer over codebook | Moderate |

## Likelihood and Compression

Autoregressive models with exact likelihoods can be used directly for lossless compression via **arithmetic coding**. The model's predicted probability $p_\theta(x_t | x_{<t})$ provides the code length for each symbol. Optimal code length: $-\log_2 p_\theta(x_t | x_{<t})$ bits.
