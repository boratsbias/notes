# Deep Neural Networks

## Core Idea

A **deep neural network (DNN)** has multiple hidden layers. Depth enables **hierarchical feature learning**: early layers detect low-level patterns; later layers compose them into abstract representations. This is the key advantage over shallow networks for structured data such as images, text, and audio.

## Architecture

For an $L$-layer network:

$$\mathbf{h}^{(0)} = \mathbf{x}$$

$$\mathbf{z}^{(l)} = W^{(l)} \mathbf{h}^{(l-1)} + \mathbf{b}^{(l)}$$

$$\mathbf{h}^{(l)} = \sigma^{(l)}(\mathbf{z}^{(l)}), \quad l = 1, \ldots, L-1$$

$$\hat{\mathbf{y}} = \text{out}(\mathbf{z}^{(L)})$$

where $\text{out}$ is task-specific (softmax, sigmoid, linear).

## Depth vs. Width

**Depth advantage:** many functions require exponentially fewer neurons when implemented with depth.

For Boolean functions: a depth-$k$ circuit can represent functions that require depth-$(k-1)$ circuits exponentially larger.

For ReLU networks: a depth-$L$, width-$n$ network partitions input space into $O((n/d)^{(L-1)d})$ linear regions. This grows exponentially in $L$; comparable width growth would be polynomial.

**Practical width choices:**

| Architecture | Typical hidden width |
|-------------|---------------------|
| Small MLP (tabular) | 64–512 |
| Medium MLP | 512–2048 |
| ResNet-50 | 256–2048 per block |
| Transformer (GPT-2) | 768–3072 |
| LLM (GPT-4 class) | 8192–16384+ |

## Key Deep Architectures

### Convolutional Neural Networks (CNNs)

Exploit spatial locality and translation invariance via learnable filters.

**Convolution layer:** $Z_{i,j,c} = \sum_{m,n,c'} K_{m,n,c',c} \cdot H_{i+m, j+n, c'} + b_c$

- **Weight sharing:** same filter applied at every spatial location.
- **Receptive field:** grows with depth via pooling and strided convolutions.

Architecture pattern: `[Conv → BN → ReLU]* → Pool → Flatten → Dense`

**Key variants:** LeNet, AlexNet, VGG, ResNet, EfficientNet.

### Residual Networks (ResNets)

Introduces **skip connections** (residual connections):

$$\mathbf{h}^{(l+1)} = \sigma(\mathbf{z}^{(l+1)} + \mathbf{h}^{(l)})$$

The block learns the residual $F(\mathbf{h}) = \mathbf{z}^{(l+1)}$ rather than the full mapping. This solves the **vanishing gradient** and **degradation** problems.

**Vanishing gradient:** gradients are multiplied by $W^T$ at each layer. For deep nets with saturating activations, gradients shrink to zero.

**With skip connections:** gradient has a direct path through the identity shortcut:

$$\frac{\partial \mathcal{L}}{\partial \mathbf{h}^{(l)}} = \frac{\partial \mathcal{L}}{\partial \mathbf{h}^{(L)}} \prod_{k=l}^{L-1} \left(I + \frac{\partial F_k}{\partial \mathbf{h}^{(k)}}\right)$$

The identity term $I$ prevents vanishing. Enables training of networks with 100–1000+ layers.

### Recurrent Neural Networks (RNNs)

Processes sequences by maintaining hidden state $\mathbf{h}_t$:

$$\mathbf{h}_t = \sigma(W_h \mathbf{h}_{t-1} + W_x \mathbf{x}_t + \mathbf{b})$$

**Vanishing/exploding gradients** over long sequences led to:
- **LSTM:** adds cell state $C_t$ with input, forget, and output gates.
- **GRU:** simplified gating; fewer parameters than LSTM.

Largely superseded by Transformers for sequence modeling.

### Transformers

See [NLP](../../05-nlp/index) and Attention mechanism. Core operation:

$$\text{Attention}(Q,K,V) = \text{softmax}\!\left(\frac{QK^T}{\sqrt{d_k}}\right)V$$

Uses self-attention instead of recurrence; fully parallelizable; scales to very long sequences with architectural modifications.

## Depth-Related Problems and Solutions

| Problem | Cause | Solution |
|---------|-------|---------|
| Vanishing gradients | Repeated small multiplications in backprop | ReLU, skip connections, careful init |
| Exploding gradients | Repeated large multiplications | Gradient clipping, careful init |
| Degradation | Deeper plain nets perform worse | Residual connections |
| Internal covariate shift | Changing activation distributions during training | Batch Normalization |
| Overfitting | High capacity | Dropout, weight decay, early stopping |

## Representation Learning

Intermediate layers learn **representations** (features) that are:
- **Distributed:** concepts encoded across many neurons.
- **Hierarchical:** lower layers capture simple features; higher layers abstract patterns.
- **Transferable:** representations learned on one task often transfer to related tasks (transfer learning, fine-tuning).

In CNNs trained on ImageNet, layer-wise visualization shows: edges (layer 1) → textures (layer 2) → parts (layer 3) → objects (layer 4+).

## Depth in Practice

- Start with proven architectures (ResNet, EfficientNet, ViT) rather than designing from scratch.
- Depth is not always better: for small datasets, shallow networks or pre-trained models generalize better.
- Residual connections and normalization layers are nearly always beneficial in deep networks.
- Increase depth before width when scaling up, but follow empirical scaling laws (see EfficientNet, Chinchilla).
