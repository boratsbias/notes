---
title: "CLIP: Learning Transferable Visual Models From Natural Language Supervision"
year: 2021
authors: Alec Radford et al.
area: Multimodal Learning, Computer Vision, Natural Language Processing
link: https://arxiv.org/abs/2103.00020
---

## The fixed label set problem

Standard image classifiers are trained on a closed set of categories. Adding a new category requires labeled examples and retraining. This approach does not scale to the long tail of visual concepts people actually care about, and it ties model capability directly to the categories chosen at dataset construction time. Supervised ImageNet models also tend to learn spurious correlations specific to the ImageNet data distribution, which causes performance to collapse on shifted versions of the same classes.

## Contrastive pretraining on image-text pairs

CLIP trains an image encoder and a text encoder jointly on 400 million image-text pairs collected from the internet. The training objective is contrastive: for a batch of N pairs, CLIP computes an N×N similarity matrix between all image embeddings and all text embeddings, then applies cross-entropy over rows to predict the correct text for each image and over columns to predict the correct image for each text. With batch size 32,768, each example sees 32,767 negatives per step. A learned temperature parameter sharpens or softens the softmax distribution. This forces both encoders to produce aligned representations in a shared embedding space where semantically matching image-text pairs cluster together.

## Zero-shot classification and prompt engineering

Zero-shot classification requires no labeled target data. Each category name is wrapped in a text template such as "a photo of a {class}" and encoded by the text encoder. The query image is encoded by the image encoder. The predicted class is whichever text embedding has the highest cosine similarity with the image embedding. Simple prompt templates outperform bare class names by a meaningful margin, and ensembling multiple prompt templates improves accuracy further. This prompt sensitivity reveals that CLIP's text encoder is doing genuine language processing rather than treating class names as opaque tokens.

## Results and impact

Zero-shot CLIP matches a supervised ResNet-50 on ImageNet without seeing any labeled ImageNet examples during training. More notably, its performance on distribution-shifted variants, including ImageNet-A, ImageNet-V2, and ObjectNet, degrades substantially less than supervised models, because CLIP did not overfit to ImageNet-specific patterns during training. CLIP's image encoder became the standard visual backbone in DALL-E 2, Stable Diffusion, LLaVA, and most subsequent multimodal models, making it one of the most widely reused components in modern AI systems.
