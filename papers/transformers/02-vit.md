# Vision Transformer (ViT) (2021)

**Authors:** Alexey Dosovitskiy et al.
**Area:** Computer Vision, Transformers
**Link:** [arXiv](https://arxiv.org/abs/2010.11929)

## What the paper argues

CNNs have dominated vision because their inductive biases (local receptive fields, translation equivariance) were considered essential for image understanding. ViT challenges this: a standard transformer applied directly to sequences of image patches can match or beat state-of-the-art CNNs when trained on enough data. The inductive biases of CNNs are not necessary; they can be learned from data.

## Patch embedding

A 224×224 image is divided into 16×16 patches (196 patches total). Each patch is flattened to a vector and linearly projected to the model dimension. A learnable [CLS] token is prepended. Learnable position embeddings are added:

```
Image (224×224)
  ↓  split into 16×16 patches
196 patches, each flattened to 768-dim vector
  ↓  + [CLS] token  +  position embeddings
197 tokens  →  standard transformer encoder
  ↓  [CLS] output
Linear classifier  →  label
```

The transformer has no built-in notion of 2D structure; it learns spatial relationships entirely from the position embeddings and self-attention patterns.

## Data requirements

ViT trained only on ImageNet underperforms CNNs: without inductive biases, the model needs more data to learn spatial structure. Pre-trained on JFT-300M (300M images), ViT matches and then exceeds CNN performance.

**DeiT** later showed that with strong data augmentation and knowledge distillation from a CNN teacher, ViT can be trained competitively on ImageNet alone.

## Results and impact

ViT-H/14 achieved 88.5% top-1 accuracy on ImageNet, surpassing the best CNNs. It triggered a wave of vision transformer variants (DeiT, Swin, BEiT) and is now the standard image encoder in multimodal models like CLIP and LLaVA.
