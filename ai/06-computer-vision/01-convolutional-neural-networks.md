# Convolutional Neural Networks

CNNs are the foundational architecture for vision. They exploit spatial locality and translation equivariance through parameter-shared convolutional filters, enabling efficient learning of visual features across all spatial locations.

## The Convolution Operation

A 2D convolution applies a learned filter $W \in \mathbb{R}^{k \times k \times C_\text{in}}$ to an input feature map $X \in \mathbb{R}^{H \times W \times C_\text{in}}$:

$$Y(h, w, c) = \sum_{i=0}^{k-1} \sum_{j=0}^{k-1} \sum_{c'=0}^{C_\text{in}-1} W(i, j, c', c) \cdot X(h \cdot s + i, w \cdot s + j, c')$$

where $s$ is the stride and $c \in \{0, \ldots, C_\text{out}-1\}$ indexes output channels.

**Key properties:**
- **Local connectivity:** each output element depends on a $k \times k$ spatial region (the receptive field).
- **Weight sharing:** the same filter is applied at every spatial location. Reduces parameters from $O(H \cdot W \cdot C^2)$ to $O(k^2 \cdot C^2)$.
- **Translation equivariance:** shifting the input shifts the output by the same amount.

## Padding and Stride

**Padding:** add zeros around the input border to control output spatial size.
- `valid` (no padding): output shrinks by $k-1$.
- `same` padding: $p = \lfloor k/2 \rfloor$; output has same spatial size as input (for stride 1).

**Output size:**

$$H_\text{out} = \lfloor \frac{H + 2p - k}{s} \rfloor + 1$$

**Stride $s > 1$:** downsamples the output. Alternative to pooling.

## Pooling

Reduces spatial resolution; provides limited translation invariance.

**Max pooling:** $\max$ over a $k \times k$ window.

**Average pooling:** mean over the window.

**Global average pooling (GAP):** collapse the entire spatial map to a single value per channel. $\mathbb{R}^{H \times W \times C} \to \mathbb{R}^C$. Used as the final spatial reduction before classification.

## Depthwise Separable Convolutions

Factor standard convolution into two steps to reduce compute.

**Depthwise convolution:** apply one filter per input channel independently.

$$Y_\text{dw}(h, w, c) = \sum_{i,j} W_\text{dw}(i, j, c) \cdot X(h \cdot s + i, w \cdot s + j, c)$$

**Pointwise convolution:** $1 \times 1$ convolution mixes channels.

$$Y(h, w, c') = \sum_c W_\text{pw}(c, c') \cdot Y_\text{dw}(h, w, c)$$

**FLOPs reduction:**

$$\frac{C_\text{out} \cdot k^2 + C_\text{out}}{C_\text{out} \cdot k^2} = \frac{1}{C_\text{out}} + \frac{1}{k^2} \approx \frac{1}{k^2}$$

For $k=3$: ~9$\times$ fewer multiply-adds. Used in MobileNet, Xception, EfficientNet.

## Receptive Field

The receptive field (RF) of a neuron is the region in the input image that influences its output.

After $L$ convolutional layers with kernel size $k$ and stride 1:

$$RF = 1 + L(k-1)$$

With stride $s > 1$ or pooling, the RF grows faster. With dilated convolutions:

$$RF = 1 + L \cdot (k-1) \cdot d$$

where $d$ is the dilation factor.

**Dilated (atrous) convolution:** insert $d-1$ zeros between filter elements. Expands the RF without increasing parameters or reducing resolution. Used in DeepLab, WaveNet.

## Classic CNN Architectures

### LeNet-5 (1998)

First successful CNN. Two conv layers + pooling + three FC layers. Input: 32×32 grayscale. Designed for digit recognition.

### AlexNet (2012)

Won ImageNet 2012 by a large margin. 5 conv layers + 3 FC layers; ReLU activations; dropout; data augmentation; trained on 2 GPUs. Demonstrated that deep CNNs with GPU training could solve large-scale visual recognition.

### VGG (2014)

Systematic use of $3 \times 3$ convolutions only; depth from 11 to 19 layers. Simple, uniform architecture; strong features; widely used as a backbone. High memory usage from large FC layers.

### GoogLeNet / Inception (2014)

**Inception module:** apply $1 \times 1$, $3 \times 3$, $5 \times 5$ convolutions and $3 \times 3$ max pooling in parallel; concatenate output feature maps. Multi-scale feature extraction; $1 \times 1$ bottleneck reduces computation.

### ResNet (2015)

**Residual connection:** the output of a block is $F(x) + x$, not $F(x)$.

$$y = F(x, \{W_i\}) + x$$

If the block is an identity, the gradient flows directly: $\partial \mathcal{L}/\partial x = \partial \mathcal{L}/\partial y$. Solves the degradation problem: deeper networks no longer perform worse on training data. Enabled 50, 101, 152, and 1000-layer networks.

**Bottleneck block:** $1 \times 1$ (reduce channels) → $3 \times 3$ → $1 \times 1$ (expand channels). Reduces FLOPs.

### DenseNet (2017)

Each layer receives feature maps from all previous layers: $x_l = H_l([x_0, x_1, \ldots, x_{l-1}])$. Maximum feature reuse; fewer parameters. Strong for segmentation tasks.

### EfficientNet (2019)

**Compound scaling:** simultaneously scale depth $d$, width $w$, and resolution $r$ with a fixed ratio under a compute constraint. Found via neural architecture search (NAS).

$$d = \alpha^\phi, \quad w = \beta^\phi, \quad r = \gamma^\phi \quad \text{subject to } \alpha \beta^2 \gamma^2 \approx 2$$

EfficientNet-B7 achieves state-of-the-art ImageNet accuracy with significantly fewer parameters than prior models.

### ConvNeXt (2022)

Redesigns ResNet to incorporate design choices from Vision Transformers (larger kernels $7 \times 7$, depthwise conv, GeLU, LayerNorm, fewer activations). Competitive with ViT while maintaining the simplicity of CNNs.

## Normalization in CNNs

**Batch Normalization:** normalize over the batch and spatial dimensions for each channel:

$$\hat{x} = \frac{x - \mu_\mathcal{B}}{\sqrt{\sigma_\mathcal{B}^2 + \epsilon}}, \quad y = \gamma \hat{x} + \beta$$

Standard for image classification. Reduces sensitivity to initialization; allows higher learning rates.

**Layer Norm / Group Norm:** alternatives when batch size is small (detection, segmentation). Group Norm normalizes over groups of channels per sample; independent of batch size.

## Spatial Attention and Channel Attention

**SE (Squeeze-and-Excitation) block:** globally pool each channel; learn channel-wise scaling weights via a small FC bottleneck. Recalibrates channel importance.

$$s = \sigma(W_2 \delta(W_1 \text{GAP}(X))), \quad \hat{X}_c = s_c \cdot X_c$$

**CBAM (Convolutional Block Attention Module):** sequential channel attention then spatial attention. Applied in many detection and classification backbones.
