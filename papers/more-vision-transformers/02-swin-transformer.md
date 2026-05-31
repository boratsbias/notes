# Swin Transformer: Hierarchical Vision Transformer using Shifted Windows (2021)

**Authors:** Ze Liu et al.
**Area:** Computer Vision, Transformers
**Link:** [arXiv](https://arxiv.org/abs/2103.14030)

## What the paper argues

ViT computes global self-attention: every patch attends to every other patch. This scales quadratically with image resolution and produces only one scale of features, making it unsuitable for dense prediction tasks like detection and segmentation. Swin Transformer introduces **window-based attention** and a hierarchical structure that gives linear complexity and multi-scale features, making it a practical general-purpose vision backbone.

## Window-based self-attention

The image is partitioned into non-overlapping local windows of M×M patches. Self-attention is computed independently within each window:

```
Full image (H×W patches)
  ↓  partition into M×M windows
(H/M) × (W/M) windows, each with M² patches
  ↓
Self-attention within each window independently
Complexity: O(M² · (H/M)(W/M)) = O(HW)  (linear in image size, not quadratic)
```

Patches in different windows never attend to each other in standard window attention.

## Shifted windows

To connect across window boundaries, alternating layers shift the window partition by (M/2, M/2):

```
Layer l:    windows aligned to grid      [A][B][C][D]
Layer l+1:  windows shifted by M/2       [E][F][G][H]  (crosses original boundaries)
```

Over multiple layers, information propagates across the full image through the shifted window sequence.

## Hierarchical structure

Like ResNet, Swin uses 4 stages with progressively smaller spatial resolution and larger channel dimension:

```
Stage 1:  (H/4 × W/4) resolution,  C channels
Stage 2:  (H/8 × W/8),             2C channels
Stage 3:  (H/16 × W/16),           4C channels
Stage 4:  (H/32 × W/32),           8C channels
```

This produces feature maps at 4 scales, directly compatible with FPN-based detectors and segmentation decoders.

## Results and impact

State of the art on ImageNet (87.3%), COCO detection, and ADE20K segmentation. Displaced CNNs as the standard backbone for dense prediction tasks. The shifted window mechanism is widely cited and adapted in subsequent efficient attention research.
