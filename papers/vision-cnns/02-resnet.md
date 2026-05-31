# Deep Residual Learning for Image Recognition (ResNet) (2015)

**Authors:** Kaiming He, Xiangyu Zhang, Shaoqing Ren, Jian Sun
**Area:** Computer Vision, Deep Learning
**Link:** [arXiv](https://arxiv.org/abs/1512.03385)

## What the paper argues

Adding more layers to a neural network should not hurt: a deeper network can always simulate a shallower one by learning identity mappings in the extra layers. But in practice, deeper networks have higher training error than shallower ones. This is a pure optimization problem. ResNet argues that if the target function for each block is close to identity, it is much easier to learn the residual (the deviation from identity) than to learn the full transformation directly.

## Residual block

Instead of learning H(x) directly, each block learns the residual F(x) = H(x) - x, and the block output is:

```
Output = F(x) + x    ← skip connection adds input directly to block output
```

If F(x) = 0 (identity is optimal), the gradient still flows through the skip connection unchanged. This prevents vanishing gradients in very deep networks and lets the optimization easily represent near-identity mappings in any block.

```
    x
    |─────────────────────────────┐
    ↓                             │
  Conv (3×3)                      │  skip connection (identity)
    ↓                             │
   ReLU                           │
    ↓                             │
  Conv (3×3)                      │
    ↓                             │
  [+] ←────────────────────────── ┘
    ↓
   ReLU
```

For deeper networks (50+), a bottleneck block is used: 1×1 → 3×3 → 1×1 convolutions, which reduces the number of parameters while maintaining depth.

## Depth enabled by residuals

```
VGG-16:       16 layers
ResNet-50:    50 layers
ResNet-152:  152 layers
```

ResNet-152 outperforms VGG-16 while using fewer parameters per layer because the skip connections allow gradients to flow directly and every layer genuinely contributes to the representation.

## Results and impact

3.57% top-5 error on ImageNet 2015, surpassing human-level performance. Residual connections became a universal building block: every modern transformer, language model, and vision architecture uses them. The idea of learning residuals rather than full functions is one of the most consequential insights in deep learning.
