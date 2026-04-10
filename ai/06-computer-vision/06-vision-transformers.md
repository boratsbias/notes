# Vision Transformers

Vision Transformers (ViT) apply the Transformer architecture directly to images, replacing convolutional inductive biases with global self-attention. They have become the dominant architecture for large-scale vision pretraining.

## ViT: Vision Transformer

Dosovitskiy et al. (2020). "An Image is Worth 16x16 Words."

**Patch tokenization:** divide the image into non-overlapping $P \times P$ patches. For a 224×224 image with $P=16$: $14 \times 14 = 196$ patches.

**Patch embedding:** flatten each patch to a vector; project linearly:

$$z_i = W_e \cdot \text{flatten}(x_i^P) + b_e, \quad z_i \in \mathbb{R}^D$$

**[CLS] token:** prepend a learnable class token $z_0$. Its final representation is used for classification.

**Position embedding:** add learnable 1D position embeddings to each patch embedding (standard absolute positions).

**Transformer encoder:** $L$ layers, each with multi-head self-attention + MLP + pre-LayerNorm.

**Classification head:** linear layer on $z_0^L$ (the final [CLS] representation).

$$p(y|x) = \text{softmax}(W_\text{cls} z_0^L)$$

### ViT Variants

| Model | Layers | Hidden dim | Heads | Params | Notes |
|-------|--------|-----------|-------|--------|-------|
| ViT-S/16 | 12 | 384 | 6 | 22M | Small |
| ViT-B/16 | 12 | 768 | 12 | 86M | Base |
| ViT-L/16 | 24 | 1024 | 16 | 307M | Large |
| ViT-H/14 | 32 | 1280 | 16 | 632M | Huge |

The `/16` or `/14` notation denotes the patch size $P$.

**Key finding:** ViT requires large-scale pretraining (JFT-300M or ImageNet-21k) to match CNN performance. With sufficient data, ViT surpasses CNNs.

## Data-Efficient ViTs

### DeiT (Data-Efficient Image Transformers)

Touvron et al. (2021). Trains ViT on ImageNet only (no JFT) using:
- **Knowledge distillation:** a CNN teacher (RegNet); a distillation token added alongside [CLS].
- **Heavy augmentation:** CutMix, Mixup, RandAugment, Random Erasing.
- **Repeated augmentation:** sample each image multiple times per batch.

DeiT-B matches ViT-B/16 JFT performance using only ImageNet-1k training.

### BEiT (BERT Pre-Training of Image Transformers)

Masked image modeling pretraining: mask random patches; predict discrete visual tokens (from a DALL-E tokenizer). Analogous to BERT MLM.

### MAE (Masked Autoencoders)

He et al. (2022). Mask 75% of patches; reconstruct pixel values of masked patches with a lightweight decoder.

**Key insight:** pixel reconstruction requires much less capacity than language token prediction. A large asymmetric design (heavy encoder, light decoder) is optimal. Simple, scalable, and produces strong representations.

### DINO / DINOv2

Self-distillation without labels. Student network is supervised to match the output of a momentum-updated teacher. DINOv2 scales to ViT-G (1B params) trained on a curated 142M image dataset; produces features that achieve strong performance on classification, depth estimation, segmentation, and retrieval without fine-tuning.

## Efficient ViT Variants

### Swin Transformer

Liu et al. (2021). Hierarchical Transformer with shifted windows.

**Window self-attention:** restrict attention to a local $M \times M$ window. Complexity: $O(M^2 \cdot HW)$ instead of $O((HW)^2)$.

**Shifted windows:** alternate between regular and shifted windows to enable cross-window connections.

**Hierarchical stages:** 4 stages with patch merging between stages (2×2 merge → halve resolution, double channels). Produces multi-scale feature maps like a CNN; plug-in for FPN-based detection/segmentation.

Swin-B achieves 83.5% ImageNet top-1 and serves as backbone for state-of-the-art detection and segmentation models.

### PVT (Pyramid Vision Transformer)

Produces multi-scale features with spatial reduction attention: reduce K, V resolution by a factor $R$ before self-attention. Lighter than Swin for the same performance.

### MixFormer / ConvNeXt v2 (Hybrid models)

Combine convolutions and attention. Convolutions capture local patterns efficiently; attention captures global context. Hybrids often outperform pure ViT at the same parameter count on constrained data.

## ViT for Dense Prediction

ViT produces a single-scale feature map (no hierarchy). Adaptations for detection/segmentation:

**ViTDet (He et al. 2022):** use a plain ViT-L with windowed attention (for efficiency) + 4 global attention blocks. Add a simple FPN to build multi-scale features. Achieves state-of-the-art detection without hierarchical design.

**SAM (Segment Anything Model):** ViT-H encoder + lightweight prompt encoder + mask decoder. Trained on SA-1B (1 billion masks). Enables zero-shot segmentation from point, box, or text prompts.

## Attention Patterns in ViT

Self-attention heads in ViT learn semantically meaningful patterns:

- Some heads attend globally; some locally.
- [CLS] token attends to semantically relevant patches (foreground objects) in deeper layers.
- Different heads in the same layer capture complementary aspects (shape, texture, semantic region).

**Attention rollout:** propagate attention maps through all layers to visualize which input patches each token attends to at the final layer.

## Computational Comparison

| Property | CNN (ResNet) | ViT |
|----------|-------------|-----|
| Inductive biases | Strong (locality, equivariance) | Weak |
| Data efficiency | High | Lower without pretraining |
| Long-range dependencies | Limited (large receptive field) | Excellent (global attention) |
| Multi-scale features | Native (FPN) | Requires adaptation |
| Inference memory | $O(HW)$ | $O((HW/P^2)^2)$ naive |
| Training at scale | Strong | Better with scale |
