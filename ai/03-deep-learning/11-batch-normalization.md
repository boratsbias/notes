# Batch Normalization

**Batch Normalization (BN)** normalizes the pre-activations (or post-activations) of each layer to have zero mean and unit variance within a mini-batch, then applies a learned affine transformation. It accelerates training, reduces sensitivity to initialization, and acts as a mild regularizer.

## Forward Pass

For a mini-batch $\mathcal{B} = \{z_1, \ldots, z_B\}$ of pre-activations at one layer (treating each feature independently):

**Step 1: Batch statistics**

$$\mu_\mathcal{B} = \frac{1}{B}\sum_{i=1}^B z_i, \quad \sigma^2_\mathcal{B} = \frac{1}{B}\sum_{i=1}^B (z_i - \mu_\mathcal{B})^2$$

**Step 2: Normalize**

$$\hat{z}_i = \frac{z_i - \mu_\mathcal{B}}{\sqrt{\sigma^2_\mathcal{B} + \epsilon}}$$

where $\epsilon \approx 10^{-5}$ prevents division by zero.

**Step 3: Scale and shift (affine transform)**

$$y_i = \gamma \hat{z}_i + \beta$$

$\gamma$ (scale) and $\beta$ (shift) are **learned parameters** per feature. They allow the network to undo the normalization if that is optimal.

## Inference (Running Statistics)

During training, maintain exponential moving averages of batch statistics:

$$\mu_\text{run} \leftarrow \alpha \mu_\text{run} + (1-\alpha)\mu_\mathcal{B}$$

$$\sigma^2_\text{run} \leftarrow \alpha \sigma^2_\text{run} + (1-\alpha)\sigma^2_\mathcal{B}$$

At inference: use $\mu_\text{run}$ and $\sigma^2_\text{run}$ (fixed) instead of batch statistics. This decouples inference from batch size.

## Why It Works

**Original motivation (Ioffe & Szegedy 2015):** reduces **internal covariate shift**: the distribution of layer inputs changes as parameters of previous layers update, slowing convergence. BN re-centers and re-scales to stabilize this.

**Current understanding (more nuanced):** empirical and theoretical work suggests the primary benefit is **smoothing the loss landscape**: BN makes the gradient magnitude more predictable and reduces sensitivity to learning rate, enabling larger learning rates and faster convergence.

**Gradient flow:** BN's normalization ensures that gradients in the backward pass are also re-scaled, helping mitigate vanishing/exploding gradients.

## Regularization Effect

The batch statistics $\mu_\mathcal{B}, \sigma^2_\mathcal{B}$ depend on the other samples in the mini-batch, introducing stochasticity similar to dropout. This noise:
- Prevents over-reliance on exact activation values.
- Often reduces the need for dropout in convolutional layers.

BN's regularization effect diminishes with larger batch sizes (less noise in statistics).

## Where to Apply BN

**Standard placement:** before the activation function: `Linear → BN → ReLU`

**Post-activation:** used in some architectures: `Linear → ReLU → BN`

**Pre-norm vs. Post-norm in Transformers:**
- Post-norm (original Transformer): BN/LN applied after residual addition. Less stable for deep models.
- Pre-norm (GPT-2, modern LLMs): LN applied before each sublayer. More stable.

## BN and Batch Size

BN statistics are unreliable for small batch sizes ($B < 8$). Variance estimate is noisy; statistics may not represent the population well.

**Alternatives for small batches:**

| Normalization | Statistics Computed Over | Notes |
|--------------|--------------------------|-------|
| Batch Norm (BN) | Batch dimension (per feature) | Needs $B \geq 16$ ideally |
| Layer Norm (LN) | Feature dimension (per sample) | Used in Transformers; batch-size independent |
| Instance Norm (IN) | Spatial dims per sample per channel | Used in style transfer |
| Group Norm (GN) | Groups of channels per sample | Good for object detection (small batches) |

## Layer Normalization

Most common alternative; used in all Transformer-based models (BERT, GPT, LLaMA):

$$\text{LN}(\mathbf{z}) = \gamma \frac{\mathbf{z} - \mu}{\sqrt{\sigma^2 + \epsilon}} + \beta$$

where $\mu, \sigma^2$ are computed across the feature dimension for a single sample.

**Advantages over BN:**
- No dependence on batch size or batch composition.
- Works identically at training and inference.
- Well-suited for variable-length sequences.

**Disadvantages:** less effective than BN for CNNs on image tasks.

## RMSNorm

Simplified layer normalization used in LLaMA, Mistral, and other modern LLMs. Skips the mean subtraction (re-centering):

$$\text{RMSNorm}(\mathbf{z}) = \frac{\mathbf{z}}{\sqrt{\frac{1}{d}\sum_j z_j^2 + \epsilon}} \cdot \gamma$$

Empirically equivalent to LN in language models; $\approx 7\%$ faster due to fewer operations.

## Practical Considerations

- Always use BN (or LN) in deep networks; reduces need for careful initialization.
- For CNNs: apply BN after each convolutional layer, before activation.
- For Transformers: use Layer Norm (pre-norm for stability).
- Use Group Norm for detection/segmentation models with small batch sizes.
- BN has 4 parameters per feature: $\gamma$, $\beta$ (learned), $\mu_\text{run}$, $\sigma^2_\text{run}$ (running, not trained by backprop).
- Set `model.eval()` to freeze running statistics during inference; forgetting this is a common bug.
