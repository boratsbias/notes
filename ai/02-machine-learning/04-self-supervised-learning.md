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

<table>
<tr><th>Method family</th><th>Objective</th><th>Mechanism</th></tr>
<tr><td>Contrastive</td><td>InfoNCE, NT-Xent</td><td>pull positives, repel negatives</td></tr>
<tr><td>Non-contrastive</td><td>BYOL, SimSiam</td><td>predictor + stop-gradient or EMA target</td></tr>
<tr><td>Masked modeling</td><td>masked-token or patch prediction</td><td>reconstruct missing content</td></tr>
<tr><td>Autoencoding</td><td>reconstruction loss</td><td>bottleneck compression</td></tr>
<tr><td>Predictive coding</td><td>future context prediction</td><td>temporal dependence</td></tr>
</table>

Cosine similarity
$$
\operatorname{sim}(u,v) = \frac{u^\top v}{\|u\|_2 \|v\|_2}
$$

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Data type</th><th>Example target</th></tr>
<tr><td>Vision SSL</td><td>image</td><td>augmented view agreement, masked patches</td></tr>
<tr><td>NLP SSL</td><td>text</td><td>masked token, next-token prediction</td></tr>
<tr><td>Audio SSL</td><td>waveform/spectrogram</td><td>masked spans, temporal contrast</td></tr>
<tr><td>Multimodal SSL</td><td>image-text, audio-text</td><td>cross-modal alignment</td></tr>
</table>

## Practical Notes

Representation quality often evaluated by linear probing
$$
\hat{W} = \arg\min_W \sum_i \ell(W z_i, y_i)
$$

Augmentation choice defines invariances learned by encoder

Large batch or memory bank improves contrastive negative coverage

Transfer gains strongest when pretraining distribution overlaps downstream domain
