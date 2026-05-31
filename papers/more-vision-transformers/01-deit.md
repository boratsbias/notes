# DeiT: Data-Efficient Image Transformers (2020)

**Authors:** Hugo Touvron et al.
**Area:** Computer Vision, Transformers
**Link:** [arXiv](https://arxiv.org/abs/2012.12877)

## What the paper argues

ViT only matches CNNs when pre-trained on massive private datasets like JFT-300M. DeiT shows that with the right training recipe and a knowledge distillation token, a pure vision transformer trained on ImageNet alone (1.2M images) can match state-of-the-art CNNs. No extra data needed.

## Distillation token

DeiT adds a second special token alongside the [CLS] token:

```
Input patches  +  [CLS] token  +  [DIST] token  +  position embeddings
                       ↓                ↓
                  soft label       teacher logits
                  cross-entropy    KL divergence
                  (true labels)    (CNN teacher: RegNet/EfficientNet)
```

The [CLS] token learns from ground truth labels. The [DIST] token learns to match the soft predictions of a CNN teacher. Both tokens interact through self-attention across all layers, allowing the student to absorb the CNN's inductive biases through the distillation signal.

At inference, the final prediction averages the [CLS] and [DIST] logits.

## Training recipe

The key ingredients that make ViT work without extra data:

```
Data augmentation:  RandAugment, CutMix, Mixup, random erasing
Regularization:     stochastic depth (drop layers randomly), label smoothing
Optimizer:          AdamW with cosine schedule and warmup
```

Without these, ViT on ImageNet alone significantly underperforms CNNs. With them, DeiT-B matches EfficientNet-B4.

## Results and impact

DeiT-B achieves 85.2% top-1 on ImageNet with no extra pre-training. Trained in 53 hours on 8 GPUs. It made vision transformers accessible to the broader research community and the training recipe has been adopted in virtually all subsequent ViT variants.
