# CLIP: Learning Transferable Visual Models From Natural Language Supervision (2021)

**Authors:** Alec Radford et al.
**Area:** Multimodal Learning, Computer Vision, Natural Language Processing
**Link:** [arXiv](https://arxiv.org/abs/2103.00020)

## What the paper argues

Standard image classifiers are trained on fixed label sets and cannot generalize to new categories without labeled examples and retraining. CLIP trains a vision model on 400M image-text pairs scraped from the internet, using a contrastive objective that aligns image and text representations. The resulting model can classify images into arbitrary categories zero-shot by comparing the image embedding to text embeddings of the category names.

## Contrastive pre-training

For a batch of N (image, text) pairs, CLIP trains two encoders so that matching pairs are close and non-matching pairs are far:

```
Images:  [img_1, img_2, ..., img_N]  →  Image encoder  →  [I_1, I_2, ..., I_N]
Texts:   [txt_1, txt_2, ..., txt_N]  →  Text encoder   →  [T_1, T_2, ..., T_N]

Similarity matrix: S_{ij} = I_i · T_j / temperature

Loss: cross-entropy on rows (each image should match its text)
    + cross-entropy on columns (each text should match its image)
```

This is a symmetric contrastive loss over N² pairs per batch. With large batch sizes (32,768), the model sees a huge range of negatives.

## Zero-shot classification

```
Target categories: ["cat", "dog", "car", "airplane"]
  ↓  prompt engineering
Text prompts: ["a photo of a cat", "a photo of a dog", ...]
  ↓  text encoder
Text embeddings: [T_cat, T_dog, T_car, T_airplane]

Query image  →  image encoder  →  I_query
  ↓
argmax cosine_similarity(I_query, T_i)  →  predicted class
```

No gradient updates. The model was never told about ImageNet during training; it generalizes via the shared embedding space.

## Results and impact

Zero-shot CLIP matches supervised ResNet-50 on ImageNet while showing far better robustness to distribution shift. It became the standard image encoder for multimodal systems: DALL-E 2, Stable Diffusion, LLaVA, and most vision-language models use CLIP or a variant as the vision backbone.
