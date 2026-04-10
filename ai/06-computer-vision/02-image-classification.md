# Image Classification

Image classification assigns a label from a fixed set of categories to an input image. It is the canonical computer vision benchmark and the entry point for most pretrained models.

## Problem Formulation

Given an image $x \in \mathbb{R}^{H \times W \times 3}$ and a label set $\mathcal{Y} = \{1, \ldots, K\}$, learn a function $f_\theta: x \mapsto \hat{y}$ that minimizes classification error.

**Softmax output:**

$$p(y = k | x) = \frac{\exp(z_k)}{\sum_{j=1}^K \exp(z_j)}$$

where $z = f_\theta(x) \in \mathbb{R}^K$ are the logits.

**Cross-entropy loss:**

$$\mathcal{L} = -\sum_{k=1}^K y_k \log p_k = -\log p_{y^*}$$

## Benchmarks

| Dataset | Classes | Train images | Notes |
|---------|---------|-------------|-------|
| MNIST | 10 | 60k | Handwritten digits; near-saturated |
| CIFAR-10 / 100 | 10 / 100 | 50k | 32×32 images |
| ImageNet (ILSVRC) | 1000 | 1.2M | Standard large-scale benchmark |
| ImageNet-21k | 21k | 14M | Pretraining dataset |
| JFT-300M | ~30k | 300M | Google internal; used for ViT pretraining |

**Top-1 accuracy:** fraction of test images where the highest-probability class is correct.

**Top-5 accuracy:** fraction where the correct class is in the top 5 predictions.

## Training Pipeline

1. **Data loading:** random resize crop to 224×224, random horizontal flip, ColorJitter, normalization.
2. **Model:** pretrained backbone + classification head.
3. **Optimizer:** SGD with momentum (classical) or AdamW (modern).
4. **Learning rate schedule:** cosine annealing; warmup for first few epochs.
5. **Regularization:** weight decay, dropout, label smoothing.
6. **Inference:** center crop 224×224 or multi-scale crop with averaging.

## Transfer Learning

Pretraining on ImageNet (or larger datasets) and fine-tuning on a target task is the standard workflow.

**Feature extraction:** freeze the backbone; train only the classification head. Fast; good when target dataset is small.

**Fine-tuning:** unfreeze all or some layers; use a smaller learning rate for early layers. Better when target dataset is large enough.

**Rule of thumb:**

| Target dataset | Similar to source | Strategy |
|---------------|------------------|---------|
| Small | Yes | Feature extraction |
| Small | No | Fine-tune top layers |
| Large | Yes | Fine-tune all |
| Large | No | Fine-tune all (or train from scratch) |

## Key Milestones on ImageNet

| Model | Year | Top-1 | Key idea |
|-------|------|-------|---------|
| AlexNet | 2012 | 63.3% | Deep CNN + GPU |
| VGG-16 | 2014 | 73.0% | Uniform 3×3 convs |
| GoogLeNet | 2014 | 74.8% | Inception module |
| ResNet-152 | 2015 | 78.6% | Residual connections |
| DenseNet-264 | 2017 | 80.8% | Dense connections |
| EfficientNet-B7 | 2019 | 84.3% | Compound scaling |
| ViT-H/14 | 2021 | 88.5% | Pure attention |
| CoAtNet-7 | 2021 | 90.9% | Conv + attention hybrid |
| CoCa | 2022 | 91.0% | Contrastive + captioning |

Human top-5 error is approximately 5.1%.

## Regularization Techniques

**Label smoothing:** replace hard one-hot labels with $(1-\epsilon)$ for the correct class and $\epsilon/(K-1)$ for others. Prevents overconfident predictions. $\epsilon = 0.1$ standard.

**Mixup:** blend pairs of training images and their labels proportionally with $\lambda \sim \text{Beta}(\alpha, \alpha)$.

**CutMix:** cut a rectangular region from one image into another; blend labels by area ratio.

**Dropout:** randomly zero activations during training. Applied after FC layers; rarely after conv layers in modern architectures.

**Stochastic depth:** randomly drop entire residual blocks during training. Acts as dropout over the network depth.

## Self-Supervised Pretraining for Classification

Pretrain on unlabeled images; fine-tune on labeled data.

**Contrastive learning (SimCLR, MoCo):** create two augmented views of the same image; maximize agreement between their representations while pushing other images apart.

$$\mathcal{L}_\text{SimCLR} = -\log \frac{\exp(\text{sim}(z_i, z_j)/\tau)}{\sum_{k \neq i} \exp(\text{sim}(z_i, z_k)/\tau)}$$

**BYOL / SimSiam:** no negative pairs; use a momentum encoder (BYOL) or stop-gradient (SimSiam) to prevent collapse.

**MAE (Masked Autoencoders, He et al. 2022):** mask 75% of image patches; train a ViT encoder-decoder to reconstruct masked pixels. Simple and highly effective for ViT pretraining.

**DINO / DINOv2:** self-distillation with no labels. A student network matches the output of a momentum teacher. DINOv2 produces features that are competitive with supervised pretraining for many downstream tasks.

## Multi-Label Classification

Each image can have multiple correct labels (e.g., "dog", "grass", "outdoors").

**Output:** sigmoid per class (not softmax); each $p_k = \sigma(z_k)$.

**Loss:** binary cross-entropy over all classes.

**Metrics:** mean Average Precision (mAP), precision@k, F1.

## Fine-Grained Classification

Distinguish between similar subcategories (bird species, car models, aircraft types).

**Challenges:** high inter-class similarity; low intra-class variation. Requires localizing discriminative parts.

**Approaches:** attention-based part localization, bilinear pooling (outer product of two feature maps captures pairwise feature interactions), specialized augmentation.
