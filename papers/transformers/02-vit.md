---
title: "An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale (ViT)"
authors: "Alexey Dosovitskiy et al."
year: 2021
area: "Computer Vision, Transformers"
link: "https://arxiv.org/abs/2010.11929"
---

## CNNs and their inductive biases

For decades, convolutional neural networks were considered essential for vision tasks. CNNs have strong inductive biases baked into their architecture: local connectivity means each filter sees only a small spatial region, and weight sharing enforces translation equivariance, meaning the model recognizes the same pattern regardless of where it appears. These biases were believed to be necessary because natural images have strong local correlations and translation invariance. ViT's core argument is that these biases are not necessary when sufficient training data is available. With enough scale, a plain transformer with no vision-specific structure learns to model spatial relationships on its own.

## Patch tokenization pipeline

ViT converts an image into a sequence of tokens that the transformer can process without modification:

```
Image → 16×16 patches → linear projection → [CLS] + patches + pos embed → Transformer encoder → [CLS] → classifier
```

A 224x224 image divided into 16x16 patches yields 196 patches. Each patch is flattened into a vector and linearly projected to the model's embedding dimension. A learnable [CLS] token is prepended to the sequence, and its final representation is passed to a linear classification head. Learnable position embeddings are added to all tokens before the transformer encoder. Because self-attention is permutation-equivariant, the model has no inherent sense of which patch is where, so position information must come entirely from these embeddings.

## The data requirement

ViT trained on ImageNet alone, with roughly 1.3M images, underperforms comparably sized CNNs. The model's lack of inductive biases means it must learn spatial structure from data, and 1.3M images are not enough for this. Trained on JFT-300M, Google's internal 300M-image dataset, ViT matches and surpasses CNNs on ImageNet. DeiT later showed that data augmentation and knowledge distillation from a CNN teacher can make ViT competitive on ImageNet alone, removing the requirement for massive proprietary datasets.

## Results and impact

ViT-H/14 achieves 88.5% top-1 accuracy on ImageNet. The paper triggered a wave of vision transformer research including DeiT, Swin Transformer, BEiT, and MAE. ViT is now the standard image encoder in CLIP, LLaVA, Flamingo, and most multimodal models, making the patch tokenization approach a foundational primitive for connecting vision and language in modern AI systems.
