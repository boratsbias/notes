# Self Supervised Learning

## Core Idea

Self-supervised learning (SSL) trains a model on a **pretext task** derived from unlabeled data, using the data itself to generate supervisory signals. The learned representations then transfer to downstream tasks with few or no labels.

Unlike semi-supervised learning, there is no labeled set at pretraining time. Labels are created automatically from structure in the data.

## Why Self-Supervision Works

Good representations should capture semantic structure. Self-supervised objectives that require understanding data content (rather than memorizing surface statistics) force the model to learn such structure.

**Transfer learning pipeline:**
1. Pretrain encoder $f_\theta$ on large unlabeled corpus via pretext task.
2. Fine-tune $f_\theta$ (or a linear head on top of it) on small labeled downstream dataset.

## Pretext Tasks

### For Images

| Pretext Task | Description |
|-------------|-------------|
| Rotation prediction | Predict rotation angle ($0°, 90°, 180°, 270°$) |
| Jigsaw puzzle | Predict permutation of shuffled image patches |
| Colorization | Predict color channels from grayscale |
| Inpainting | Reconstruct masked regions |
| Relative patch location | Predict spatial relationship between two patches |

### For Text

| Pretext Task | Description |
|-------------|-------------|
| Masked Language Modeling (MLM) | Predict masked tokens (BERT) |
| Causal Language Modeling (CLM) | Predict next token (GPT) |
| Sentence order prediction | Predict if two sentences are in order |
| Next sentence prediction (NSP) | Predict if sentence B follows sentence A |

## Contrastive Learning

The dominant paradigm for visual SSL. Learns representations by pulling **positive pairs** (different views of the same image) together and pushing **negative pairs** apart.

**View generation:** two augmentations $v, v'$ of the same image $x$ form a positive pair. All other images in the batch form negatives.

### InfoNCE Loss (NT-Xent)

$$\mathcal{L}_i = -\log \frac{\exp(\text{sim}(z_i, z_i') / \tau)}{\sum_{j=1}^{2N} \mathbf{1}[j \neq i] \exp(\text{sim}(z_i, z_j) / \tau)}$$

where $z_i = g(f_\theta(v_i))$ is the projected representation, $\text{sim}$ is cosine similarity, $\tau$ is temperature, and $N$ is batch size.

### SimCLR

Framework: augment $x$ twice, encode with shared $f_\theta$, project with small MLP $g$, apply NT-Xent. Projection head is discarded after pretraining; representations from $f_\theta$ are used for downstream tasks.

Key findings:
- Strong augmentations (random crop, color jitter, Gaussian blur) are critical.
- Larger batch sizes and longer training improve quality.
- Nonlinear projection head significantly boosts representation quality.

### MoCo (Momentum Contrast)

Maintains a **queue** of negative keys from past batches, decoupling batch size from number of negatives. Key encoder updated as exponential moving average (EMA) of query encoder:

$$\theta_k \leftarrow m \theta_k + (1 - m) \theta_q$$

Allows large effective number of negatives without huge batch sizes.

### BYOL

Bootstrap Your Own Latent. Eliminates explicit negatives. Two networks: **online** ($\theta$) and **target** ($\xi$, EMA of $\theta$). Online predicts target representation:

$$\mathcal{L} = 2 - 2 \cdot \frac{\langle q_\theta(z_\theta), z_\xi \rangle}{\|q_\theta(z_\theta)\| \cdot \|z_\xi\|}$$

Avoids collapse via the asymmetric architecture and stop-gradient on the target.

### SimSiam

Similar to BYOL without EMA. Stop-gradient on one branch is the key to avoiding collapse. Simple and effective: no large batches, no negatives, no momentum encoder.

## Masked Autoencoding

### Masked Autoencoders (MAE)

For images: mask a large fraction ($\sim 75\%$) of patches, encode only visible patches with a ViT, decode to reconstruct masked patches.

$$\mathcal{L} = \frac{1}{|\mathcal{M}|} \sum_{p \in \mathcal{M}} \|x_p - \hat{x}_p\|^2$$

High masking ratio forces the encoder to learn semantic representations rather than interpolating local statistics.

## Comparison of Approaches

| Method | Negatives | Momentum Encoder | Projection Head | Key Idea |
|--------|-----------|-----------------|-----------------|---------|
| SimCLR | Large batch | No | MLP | NT-Xent with strong augmentations |
| MoCo | Queue | Yes | MLP | Decoupled negatives via memory bank |
| BYOL | No | Yes (EMA) | Predictor | Asymmetric network prevents collapse |
| SimSiam | No | No | Predictor | Stop-gradient avoids collapse |
| MAE | No | No | Decoder | Reconstruction of masked patches |

## Evaluation Protocol

**Linear evaluation:** freeze pretrained encoder; train a linear classifier on top. Measures representation quality independent of fine-tuning.

**Fine-tuning:** update all parameters. Measures transfer performance; typically higher than linear evaluation.

**Few-shot:** fine-tune with very few labeled examples per class. Tests sample efficiency.

## Key Augmentations for Visual SSL

| Augmentation | Role |
|-------------|------|
| Random crop + resize | Invariance to scale and location |
| Color jitter | Invariance to color and brightness |
| Gaussian blur | Invariance to sharpness |
| Grayscale | Removes color-based shortcuts |
| Horizontal flip | Invariance to orientation |

Augmentation strength must be calibrated: too weak and the task is trivial; too strong and positives become semantically different.
