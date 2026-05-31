---
title: "Swin Transformer: Hierarchical Vision Transformer using Shifted Windows"
year: 2021
authors: Ze Liu et al.
area: Computer Vision, Transformers
link: https://arxiv.org/abs/2103.14030
---

## ViT's limitations for dense prediction

Global self-attention scales quadratically with image resolution. For high-resolution inputs needed by detection and segmentation models, this becomes prohibitively expensive. ViT also produces a single-scale feature map, but dense prediction tasks require multi-scale features: detectors like FPN expect feature maps at 4 different spatial resolutions so that the model can detect objects at many sizes. ViT was designed for classification and cannot serve as a general backbone without architectural changes to address both problems.

## Window-based attention and the shift mechanism

Swin's first innovation is partitioning the image into non-overlapping M×M local windows and computing self-attention independently within each window. Complexity drops from O((HW)²) to O(HW·M²), which is linear in image size since M is fixed (typically 7). The problem with pure window attention is that patches in different windows never interact, preventing any global communication. Swin resolves this by alternating between two window configurations on successive layers: regular windows aligned to the grid in even layers, and windows shifted by M/2 pixels in odd layers. The shifted windows overlap with multiple windows from the previous layer, so information from separated regions exchanges across alternating layers. Over many such alternations, information propagates globally while each individual attention operation remains local and cheap.

## Hierarchical feature maps

Swin organizes computation into four stages with progressively decreasing spatial resolution and increasing channel dimension: H/4×W/4, H/8×W/8, H/16×W/16, and H/32×W/32. Patch merging operations between stages concatenate and project neighboring patch tokens to halve spatial resolution. This produces a feature pyramid directly compatible with FPN-based detectors and segmentation decoders, something global-attention ViT cannot provide without modification. Learned relative position biases are added within each window rather than using absolute position embeddings, encoding spatial proximity more effectively for vision tasks where location relative to neighbors matters more than absolute position in the image.

## Results and impact

Swin achieves 87.3% top-1 on ImageNet and simultaneously reaches state of the art on COCO object detection and ADE20K semantic segmentation. This simultaneous dominance across classification, detection, and segmentation established it as a general-purpose vision backbone. Swin displaced CNNs as the standard backbone for dense prediction tasks throughout 2021 and 2022. The shifted window mechanism has been widely cited and adapted in efficient attention research, and the hierarchical design influenced subsequent transformer backbones for video and 3D vision.
