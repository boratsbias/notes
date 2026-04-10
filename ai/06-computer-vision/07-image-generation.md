# Image Generation

Image generation models learn to produce realistic images from noise, text, or other conditioning signals. The field has advanced rapidly, moving from GANs to diffusion models as the dominant paradigm.

## Generative Adversarial Networks for Images

See [Generative Adversarial Networks](../04-generative-models/03-generative-adversarial-networks) for the GAN framework. Here we focus on image-specific architectures.

### DCGAN (2015)

First stable GAN for natural images. Key design choices:
- Replace pooling with strided convolutions (discriminator) and fractional-strided convolutions (generator).
- Batch normalization in both networks (not input/output layers).
- LeakyReLU in discriminator; ReLU in generator except Tanh at output.

### Progressive GAN (ProGAN, 2018)

Train on low-resolution images first (4×4); gradually add higher-resolution layers (8×8, 16×16, ..., 1024×1024). Smooth fading-in of new layers with a blending weight $\alpha$. Produces photorealistic 1024×1024 face images (CelebA-HQ).

### StyleGAN / StyleGAN2

Karras et al. (2019, 2020). Introduces the style-based generator.

**Mapping network:** $z \sim \mathcal{N}(0,I) \to w \in \mathcal{W}$ via 8-layer MLP. The $\mathcal{W}$ space is more disentangled than $\mathcal{Z}$.

**Adaptive Instance Normalization (AdaIN):**

$$\text{AdaIN}(x_i, y) = y_{s,i} \frac{x_i - \mu(x_i)}{\sigma(x_i)} + y_{b,i}$$

The style vector $w$ is affinely transformed into scale $y_s$ and bias $y_b$ at each layer.

**Style mixing:** inject different $w$ vectors at different resolutions. Coarse styles (low-res layers) control pose, shape; fine styles (high-res layers) control texture, color.

StyleGAN2 eliminates blob artifacts via revised normalization (demodulation).

## Variational Autoencoders for Images

VAE encodes an image to a latent distribution $q(z|x)$ and decodes back to pixel space. See [Variational Autoencoders](../04-generative-models/02-variational-autoencoders) for details. Image VAEs tend to produce blurry outputs due to the pixel-level reconstruction loss.

## Diffusion Models for Images

The dominant image generation paradigm. See [Diffusion Models](../04-generative-models/04-diffusion-models) for the full derivation.

### DDPM (2020)

Ho et al. A U-Net backbone with residual blocks and self-attention learns to predict the noise $\epsilon$ added at each timestep. 1000 denoising steps; slow sampling.

**U-Net for diffusion:** encoder-decoder with skip connections; timestep embedding injected via AdaGN (Adaptive Group Normalization); attention at lower-resolution (16×16, 8×8) spatial scales.

### DDIM (2021)

Deterministic sampling via a non-Markovian process; allows 50-200 step sampling with similar quality. Maps a fixed noise to a fixed image (useful for image editing/interpolation).

### Latent Diffusion Models (LDM) / Stable Diffusion

Rombach et al. (2022). Run diffusion in the latent space of a pretrained VAE rather than pixel space.

**VQ-VAE encoder:** compress $512 \times 512 \times 3$ image to $64 \times 64 \times 4$ latent (8$\times$ spatial compression). Dramatically reduces compute.

**Conditioning:** text conditioning via cross-attention with CLIP or T5 text embeddings.

**Cross-attention in U-Net:**

$$\text{Attention}(Q, K, V) = \text{softmax}\!\left(\frac{QK^T}{\sqrt{d}}\right)V, \quad Q = W_Q \phi(z_t), \; K = W_K \tau(c), \; V = W_V \tau(c)$$

where $\phi(z_t)$ is the denoised latent, $\tau(c)$ is the text encoding.

Stable Diffusion is open-source; enabled a massive ecosystem of image generation tools.

### Classifier-Free Guidance (CFG)

Ho & Salimans (2022). Train the model both conditionally (with text) and unconditionally (drop condition with probability $p$). At inference, interpolate between the two:

$$\tilde{\epsilon}_\theta(z_t, c) = \epsilon_\theta(z_t) + s \cdot (\epsilon_\theta(z_t, c) - \epsilon_\theta(z_t))$$

Guidance scale $s > 1$ amplifies the condition; higher $s$ = more text-aligned but less diverse.

### Consistency Models (2023)

Song et al. Directly learn the mapping from any noise level to the clean image in one or few steps. Supports both one-step and iterative refinement. Much faster than DDPM.

## Text-to-Image Models

| Model | Org | Architecture | Notes |
|-------|-----|-------------|-------|
| DALL-E 2 | OpenAI | Diffusion + CLIP | CLIP prior + decoder |
| Imagen | Google | Cascaded diffusion | T5-XXL text encoder |
| Stable Diffusion | Stability AI | LDM | Open source |
| SDXL | Stability AI | LDM (larger) | 1024×1024 native |
| Flux | Black Forest Labs | Rectified flow + DiT | State of the art (2024) |
| Firefly | Adobe | LDM | Licensed training data |

### Diffusion Transformer (DiT)

Peebles & Xie (2023). Replace the U-Net backbone with a Transformer operating on image patches (patchify, process with Transformer layers, unpatchify). Scales predictably with compute. Basis of Flux and Sora.

**Adaptive Layer Norm (adaLN-Zero):** modulate layer norm with timestep and class conditioning; initialize to output zero residual (identity at initialization).

## Image Editing with Diffusion Models

**SDEdit:** add noise to a real image to a specific timestep; denoise with a new text prompt. Controls the strength of edit via the noise level.

**InstructPix2Pix:** train on (original image, instruction, edited image) pairs. The model learns to apply natural language editing instructions.

**Prompt-to-Prompt:** manipulate the cross-attention maps to control spatial layout of edits.

**DreamBooth / Textual Inversion:** fine-tune the model on 3-10 images of a specific subject; inject the subject into new scenes via text prompts.

## Evaluation

| Metric | What it measures |
|--------|----------------|
| FID (Fréchet Inception Distance) | Distribution similarity between real and generated images using Inception features |
| IS (Inception Score) | Quality and diversity of generated images |
| CLIP score | Alignment between generated image and text prompt |
| Human evaluation | Photorealism, text alignment, creativity |
| Precision / Recall | Fidelity (precision) and diversity (recall) separately |

**FID** is the most commonly reported metric. Lower is better. It is sensitive to the number of images used for estimation; typically computed with 50k samples.
