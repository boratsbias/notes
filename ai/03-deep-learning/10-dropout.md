# Dropout

## Core Idea

**Dropout** randomly sets a fraction of neurons to zero during each forward pass of training. This prevents neurons from co-adapting (relying on specific other neurons) and forces the network to learn redundant, distributed representations. It acts as an approximate ensemble of exponentially many thinned networks.

## Mechanism

During training, each neuron in a dropout layer is retained with probability $p$ (the **keep probability**) or zeroed out with probability $1 - p$ (the **drop probability**, commonly called $p_\text{drop}$):

$$\tilde{h}_j = \begin{cases} h_j / p & \text{with probability } p \\ 0 & \text{with probability } 1 - p \end{cases}$$

The division by $p$ (**inverted dropout**) ensures that the expected value of $\tilde{h}_j$ equals $h_j$, making the expected output unchanged:

$$\mathbb{E}[\tilde{h}_j] = p \cdot \frac{h_j}{p} + (1-p) \cdot 0 = h_j$$

## Training vs. Inference

**Training:** apply dropout mask; scale by $1/p$.

**Inference:** do not drop any units; use the full network unchanged. This is the "average" of the $2^n$ thinned networks (for $n$ dropped neurons).

In code (inverted dropout):

```python
mask = (torch.rand(h.shape) < p).float()
h_dropped = h * mask / p   # training
# h_undropped = h           # inference
```

## Hyperparameter: Drop Probability

- **$p_\text{drop} = 0.5$:** originally proposed by Hinton et al. for fully connected layers. Maximizes the number of possible sub-networks.
- **$p_\text{drop} = 0.1$–$0.3$:** used for convolutional and attention layers where features are spatially correlated and stronger dropout is too destructive.
- **$p_\text{drop} = 0.0$:** disables dropout. Typical in the first layer (inputs are already noisy).

Higher capacity models and larger datasets can tolerate higher dropout rates.

## Ensemble Interpretation

A network with $n$ dropout units defines $2^n$ possible "thinned" sub-networks sharing weights. Each training step trains one randomly sampled sub-network. At inference, the full network approximates a geometric mean over all sub-networks.

**Exact ensemble cost:** exponential. **Approximate cost at inference:** single forward pass.

## Regularization Effect

**Prevents co-adaptation:** a neuron cannot rely on a specific set of co-workers always being present; must learn features useful in many contexts.

**Implicit L2 regularization:** for linear models, dropout is equivalent to an adaptive form of L2 regularization where the penalty is proportional to the activation magnitude.

**Noise injection:** dropout is equivalent to adding multiplicative Bernoulli noise to activations, which acts as a regularizer related to the Fisher information matrix.

## Variants

### Spatial Dropout (SpatialDropout2d)

Drops entire feature maps (channels) rather than individual elements. Suitable for convolutional layers where neighboring spatial activations are highly correlated; dropping individual pixels provides weak regularization.

### DropConnect

Drops individual **weights** rather than activations. Strictly more general than dropout; marginal practical gains.

### Variational Dropout

Uses the same dropout mask across all timesteps in an RNN (rather than a new mask per step). Implements a consistent Bayesian approximation; significantly better regularization for RNNs.

### Alpha Dropout

Designed for SELU activations. Maintains the mean and variance of SELU after dropout, preserving the self-normalizing property. Uses an affine transformation to renormalize.

### DropPath (Stochastic Depth)

Drops entire residual branches randomly during training:

$$\mathbf{h}^{(l+1)} = \mathbf{h}^{(l)} + b_l \cdot F^{(l)}(\mathbf{h}^{(l)})$$

where $b_l \sim \text{Bernoulli}(p_l)$. Drop probability typically increases linearly with depth. Used in DeiT, Swin Transformer, EfficientNet; effectively reduces the expected depth and regularizes very deep networks.

### Attention Dropout

Applied to the attention weight matrix after softmax in Transformer models:

$$\text{Attention}(Q,K,V) = \text{softmax}\!\left(\frac{QK^T}{\sqrt{d_k}}\right)_\text{drop} V$$

Standard in BERT ($p_\text{drop} = 0.1$) and GPT.

## Interaction with Batch Normalization

Dropout + Batch Normalization (BN) can **conflict**: BN uses batch statistics to normalize; dropout shifts the variance of inputs to BN, causing a discrepancy between training and inference statistics. This is known as **variance shift**.

**Solutions:**
- Apply dropout after BN, not before.
- Use dropout only in fully connected layers, not in convolutional layers with BN.
- In practice, most modern CNNs (ResNet, EfficientNet) avoid dropout in convolutional blocks and apply it only before the final classifier layer.

## Practical Recommendations

- Use dropout after dense/linear layers, not after convolutional layers with BN.
- Use spatial dropout for convolutional layers when regularization is needed.
- Use variational (locked) dropout for RNNs.
- Use DropPath for very deep residual networks.
- Tune drop probability with other hyperparameters; higher capacity models can tolerate more dropout.
- Disable during inference; always check that `model.eval()` is called in PyTorch.
