---
title: "DeiT: Data-Efficient Image Transformers"
year: 2020
authors: Hugo Touvron et al.
area: Computer Vision, Transformers
link: https://arxiv.org/abs/2012.12877
---

## The problem with ViT

The original Vision Transformer demonstrated that pure transformer architectures could match CNNs on image classification, but only when pretrained on JFT-300M, a proprietary Google dataset of 300 million images. Trained on ImageNet alone (1.2M images), ViT significantly underperforms CNNs of comparable size. This made ViT inaccessible to most researchers and organizations without large private datasets. The core issue is that transformers lack the inductive biases CNNs have built in: local connectivity and translation equivariance. Without these biases, the model requires vastly more data to learn basic spatial structure from scratch.

## Distillation token

DeiT's primary contribution is a knowledge distillation scheme tailored to transformers. Alongside the standard [CLS] token, DeiT introduces a [DIST] token. The [CLS] token is trained with standard cross-entropy loss against ground truth labels. The [DIST] token is trained to match the soft output predictions of a CNN teacher, such as RegNet or EfficientNet. Both tokens participate fully in self-attention across every layer, so the student model absorbs the teacher's spatial inductive biases through the distillation gradient rather than requiring massive data volumes to discover them independently. At inference, the logits from [CLS] and [DIST] are averaged to produce the final prediction. The choice of a CNN teacher is deliberate: a CNN teacher transfers its built-in local structure priors, whereas a transformer teacher would not provide the same complementary signal.

## Training recipe

The distillation token alone does not account for DeiT's success. An equally important contribution is the training recipe that enables ViT to converge well on ImageNet without extra data. This recipe combines several aggressive augmentation strategies: RandAugment, CutMix, Mixup, and random erasing. Regularization uses stochastic depth and label smoothing. Optimization uses AdamW with a cosine learning rate schedule and linear warmup. Without this recipe, ViT massively overfits on ImageNet-scale data regardless of model size.

## Results and impact

DeiT-B has 86M parameters and achieves 85.2% top-1 accuracy on ImageNet when trained with distillation, matching EfficientNet-B4 without ensembling and using a simpler, fully attention-based architecture. Training takes 53 hours on 8 GPUs, a compute budget accessible to academic labs. DeiT made vision transformers practically usable without proprietary data. The training recipe it introduced has been adopted in nearly every subsequent ViT variant, and the distillation token mechanism influenced how practitioners think about transferring CNN priors into transformer architectures.
