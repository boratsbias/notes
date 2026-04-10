# Semi Supervised Learning

Semi-supervised learning (SSL) leverages a small labeled dataset $\mathcal{D}_L = \{(x_i, y_i)\}_{i=1}^l$ together with a large unlabeled dataset $\mathcal{D}_U = \{x_j\}_{j=1}^u$ (where $u \gg l$) to learn a better model than supervised learning on $\mathcal{D}_L$ alone.

The key insight: unlabeled data reveals the structure of $P(X)$, which often constrains $P(Y|X)$.

## Assumptions

SSL methods work only when the data distribution satisfies one or more of these:

**Smoothness assumption:** if two points $x_1, x_2$ are close in input space, their labels $y_1, y_2$ should be the same.

**Cluster assumption:** the decision boundary should lie in low-density regions. Points in the same cluster likely share a label.

**Manifold assumption:** high-dimensional data lies on a low-dimensional manifold. Labels vary smoothly along the manifold.

## Core Methods

### Self-Training (Pseudo-Labeling)

Iteratively extends the labeled set using the model's own predictions on unlabeled data.

**Algorithm:**
1. Train model $f$ on $\mathcal{D}_L$.
2. Predict labels for $\mathcal{D}_U$; add high-confidence predictions to $\mathcal{D}_L$.
3. Retrain $f$ on the expanded labeled set.
4. Repeat until convergence.

**Threshold:** only add predictions with confidence $\max_k P(y = k | x) \geq \tau$ (typically $\tau = 0.95$).

**Risk:** confirmation bias. If early predictions are wrong, errors compound. Addressed by sharpening, temperature scaling, or consistency regularization.

### Label Propagation

Graph-based method. Constructs a graph $G = (V, E)$ where nodes are all data points and edge weights reflect similarity:

$$w_{ij} = \exp\left(-\frac{\|x_i - x_j\|^2}{2\sigma^2}\right)$$

Labels diffuse from labeled nodes to unlabeled nodes via the graph Laplacian. Closed-form solution for label matrix $F$:

$$F_U = (I - \alpha W_{UU})^{-1} (\alpha W_{UL} Y_L)$$

where $\alpha \in (0, 1)$ controls the balance between propagated labels and initial values.

### Generative Models

Fit $P(x, y) = P(y) P(x | y)$ using both labeled and unlabeled data. The unlabeled data contributes to estimating $P(x)$.

**EM approach:**
- E-step: infer soft labels $P(y | x_j, \theta)$ for unlabeled $x_j$.
- M-step: update model parameters using both hard labeled and soft unlabeled assignments.

Generative SSL is theoretically grounded but sensitive to model misspecification.

### Consistency Regularization

Forces the model to give stable predictions under perturbations of unlabeled data:

$$\mathcal{L}_u = \frac{1}{u} \sum_{j=1}^u \| f_\theta(x_j) - f_\theta(\tilde{x}_j) \|^2$$

where $\tilde{x}_j$ is a perturbed (augmented) version of $x_j$.

**Methods:**

| Method | Perturbation Strategy |
|--------|----------------------|
| $\Pi$-model | Two random augmentations of the same input |
| Mean Teacher | Student vs. exponential moving average of student weights |
| VAT (Virtual Adversarial Training) | Adversarial perturbation that maximally changes prediction |
| MixMatch | Combines label guessing, sharpening, and MixUp augmentation |
| FixMatch | Consistency between weak and strong augmentations with confidence threshold |

### FixMatch (Key Algorithm)

For unlabeled $x$:
1. Weak augmentation $\alpha(x)$: predict $\hat{q} = f_\theta(\alpha(x))$.
2. If $\max \hat{q} \geq \tau$: construct pseudo-label $\hat{y} = \arg\max \hat{q}$.
3. Strong augmentation $\mathcal{A}(x)$: compute cross-entropy loss against $\hat{y}$.

Total loss:

$$\mathcal{L} = \frac{1}{l} \sum_{(x,y) \in \mathcal{D}_L} H(y, f_\theta(\alpha(x))) + \lambda \frac{1}{u} \sum_{x \in \mathcal{D}_U} \mathbf{1}[\max \hat{q} \geq \tau] \, H(\hat{y}, f_\theta(\mathcal{A}(x)))$$

## Comparison

| Method | Approach | Scalability | Sensitivity to Assumptions |
|--------|----------|-------------|---------------------------|
| Self-training | Iterative pseudo-labeling | High | Confirmation bias risk |
| Label propagation | Graph diffusion | $O(n^2)$ graph build | Requires meaningful distances |
| Generative models | Model $P(x, y)$ | Medium | High (model misspecification) |
| Consistency regularization | Augmentation stability | High | Augmentation quality matters |

## Practical Considerations

- SSL is most valuable when labeled data is scarce and annotation is expensive.
- Data augmentation quality is critical for consistency-based methods.
- Evaluate on validation labeled data; monitor that unlabeled data is helping, not hurting.
- Distribution mismatch between labeled and unlabeled sets can degrade performance.

See [Self Supervised Learning](04-self-supervised-learning) for pretraining-based approaches that also leverage unlabeled data.
