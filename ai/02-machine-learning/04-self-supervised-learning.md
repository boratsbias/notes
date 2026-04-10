# Self Supervised Learning

## Concept / Definition

Self-supervised learning constructs surrogate targets from raw data

Given unlabeled samples
$$
D = \{x_i\}_{i=1}^n
$$
learn representation
$$
z = h_\theta(x)
$$
by solving pretext task

## Mathematical Formulation

Contrastive objective for positive pair $(x, x^+)$ and negatives $\{x_j^-\}$
$$
\mathcal{L}_{\text{InfoNCE}} = - \log \frac{\exp(\operatorname{sim}(z, z^+) / \tau)}{\exp(\operatorname{sim}(z, z^+) / \tau) + \sum_j \exp(\operatorname{sim}(z, z_j^-) / \tau)}
$$

Reconstruction objective
$$
\mathcal{L}_{\text{rec}}(\theta,\phi) = \frac{1}{n} \sum_{i=1}^n \|x_i - g_\phi(h_\theta(x_i))\|_2^2
$$

Masked prediction
$$
\mathcal{L}_{\text{mask}} = - \sum_{t \in M} \log p_\theta(x_t \mid x_{\bar{M}})
$$
where $M$ is masked index set

After pretraining, fine-tuning solves
$$
\hat{\psi} = \arg\min_\psi \frac{1}{m} \sum_{i=1}^m \ell(g_\psi(h_\theta(x_i)), y_i)
$$

## Conditions / Properties

Invariance objective
$$
h_\theta(T_1(x)) \approx h_\theta(T_2(x))
$$
for label-preserving augmentations $T_1, T_2$

Avoid collapse
$$
z_i = z_j \quad \forall i,j
$$
which gives trivial constant representation

Contrastive methods use negatives or asymmetry to prevent collapse

Masked modeling works when context predicts removed content

## Algorithms / Methods

| Method family | Objective | Mechanism |
|---|---|---|
| Contrastive | InfoNCE, NT-Xent | pull positives, repel negatives |
| Non-contrastive | BYOL, SimSiam | predictor + stop-gradient or EMA target |
| Masked modeling | masked-token or patch prediction | reconstruct missing content |
| Autoencoding | reconstruction loss | bottleneck compression |
| Predictive coding | future context prediction | temporal dependence |

Cosine similarity
$$
\operatorname{sim}(u,v) = \frac{u^\top v}{\|u\|_2 \|v\|_2}
$$

## Variants / Extensions

| Variant | Data type | Example target |
|---|---|---|
| Vision SSL | image | augmented view agreement, masked patches |
| NLP SSL | text | masked token, next-token prediction |
| Audio SSL | waveform/spectrogram | masked spans, temporal contrast |
| Multimodal SSL | image-text, audio-text | cross-modal alignment |

## Practical Notes

Representation quality often evaluated by linear probing
$$
\hat{W} = \arg\min_W \sum_i \ell(W z_i, y_i)
$$

Augmentation choice defines invariances learned by encoder

Large batch or memory bank improves contrastive negative coverage

Transfer gains strongest when pretraining distribution overlaps downstream domain
