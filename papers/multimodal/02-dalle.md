# DALL-E: Zero-Shot Text-to-Image Generation (2021)

**Authors:** Aditya Ramesh et al.
**Area:** Multimodal Learning, Generative Models
**Link:** [arXiv](https://arxiv.org/abs/2102.12092)

## What the paper argues

Text-to-image generation requires bridging two very different modalities. Prior GAN-based approaches struggled with compositional prompts. DALL-E treats image generation as a sequence modeling problem: encode the image as discrete tokens, concatenate them with text tokens, and train a transformer to predict the next token autoregressively. At generation time, generate image tokens from a text prefix.

## Two-stage architecture

```
Stage 1: Image tokenization with dVAE
  256×256 image  →  discrete VAE  →  32×32 grid of tokens (1024 tokens total)
  Codebook size: 8192 visual tokens
  (reduces image from 196,608 pixels to 1,024 discrete codes)

Stage 2: Transformer for joint modeling
  [text tokens (up to 256)] + [image tokens (1024)]  =  1280 tokens total
  12B parameter transformer trained to predict next token autoregressively
  Self-attention is causal over text+image, but image tokens see all text tokens
```

The text is tokenized with BPE. The image is tokenized by the dVAE codebook. Both become integers fed into the same transformer.

## Generation and re-ranking

At inference, given a text prompt, the transformer autoregressively generates 1024 image tokens. The tokens are decoded back to pixels by the dVAE decoder. Multiple candidates are generated and re-ranked by CLIP score (which image-text pair has highest cosine similarity):

```
Prompt  →  generate K images  →  score each with CLIP  →  return best
```

## Results and impact

DALL-E produced convincing zero-shot compositional generation (e.g. "an armchair in the shape of an avocado"). It demonstrated that scale and autoregressive modeling could enable creative image synthesis from arbitrary text. DALL-E 2 and DALL-E 3 followed with diffusion-based approaches that substantially improved quality and controllability.
