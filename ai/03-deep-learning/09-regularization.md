# Regularization

Regularization refers to any technique that reduces overfitting (high variance) by adding constraints, noise, or implicit bias to the learning process. It improves generalization by preventing the model from memorizing training data idiosyncrasies.

**Formal framing:** regularization modifies the objective:

$$\mathcal{J}(\theta) = \underbrace{\frac{1}{n}\sum_{i=1}^n \mathcal{L}(f_\theta(x_i), y_i)}_{\text{empirical risk}} + \lambda \underbrace{\Omega(\theta)}_{\text{regularizer}}$$

## L2 Regularization (Weight Decay)

Penalizes the squared $\ell^2$ norm of weights:

$$\Omega(\theta) = \frac{1}{2}\|\theta\|_2^2 = \frac{1}{2}\sum_j \theta_j^2$$

**Modified gradient:**

$$\nabla_\theta \mathcal{J} = \nabla_\theta \mathcal{L} + \lambda \theta$$

**Update rule:**

$$\theta \leftarrow \theta(1 - \eta\lambda) - \eta \nabla_\theta \mathcal{L}$$

The factor $(1 - \eta\lambda)$ shrinks (decays) the weights at each step, hence "weight decay."

**Effect:** shrinks all weights toward zero proportionally to their magnitude. Discourages large weights that could indicate overfitting. Does not produce sparsity.

**Bayesian interpretation:** equivalent to MAP estimation with a Gaussian prior $p(\theta) = \mathcal{N}(0, 1/\lambda)$.

**Note:** in Adam, weight decay and L2 regularization are **not** equivalent. Use **decoupled weight decay** (AdamW) for Adam: apply the decay directly to weights rather than adding $\lambda\theta$ to the gradient.

## L1 Regularization (Lasso)

Penalizes the $\ell^1$ norm:

$$\Omega(\theta) = \|\theta\|_1 = \sum_j \lvert\theta_j\rvert$$

**Modified gradient:** $\nabla_\theta \mathcal{J} = \nabla_\theta \mathcal{L} + \lambda \cdot \text{sign}(\theta)$

**Effect:** drives some weights to exactly zero (sparse solutions). Performs implicit feature selection.

**Bayesian interpretation:** MAP estimation with a Laplace prior $p(\theta) \propto e^{-\lambda\lvert\theta\rvert}$.

Less common in deep learning than L2 due to non-differentiability at zero and lack of scale invariance.

## Elastic Net

Combines L1 and L2:

$$\Omega(\theta) = \alpha \|\theta\|_1 + \frac{1-\alpha}{2}\|\theta\|_2^2$$

Inherits sparsity from L1 and the grouping effect from L2. Common in linear models for tabular data.

## Data Augmentation

Artificially expands the training set by applying label-preserving transformations:

**Images:**
- Random crop and resize
- Horizontal/vertical flip
- Color jitter (brightness, contrast, saturation, hue)
- Gaussian blur, noise injection
- Cutout (random rectangular masking)
- Mixup: $\tilde{x} = \lambda x_i + (1-\lambda)x_j$, $\tilde{y} = \lambda y_i + (1-\lambda)y_j$
- CutMix: paste patch from one image into another

**Text:**
- Synonym substitution
- Back-translation
- Random token masking or deletion
- EDA (Easy Data Augmentation)

**Audio:**
- Time stretching, pitch shifting, SpecAugment (masking frequency/time blocks)

Data augmentation is one of the most effective regularization techniques; the augmented examples are effectively unlimited.

## Early Stopping

Stop training when validation loss stops decreasing and begins to increase.

**Patience $p$:** stop if validation loss does not improve for $p$ consecutive epochs. Restore best checkpoint.

**Effect:** implicit regularization; limits the effective number of gradient steps, preventing the model from fitting noise.

**Equivalent to L2 regularization** under certain conditions (Tikhonov): the optimal early stopping time corresponds to $\lambda \approx 1/(\eta T)$ in the L2-regularized problem.

## Noise Injection

Adding noise to inputs, hidden activations, or gradients acts as regularization:

- **Input noise:** $\tilde{x} = x + \epsilon$, $\epsilon \sim \mathcal{N}(0, \sigma^2)$. Equivalent to Tikhonov regularization for linear models.
- **Weight noise:** $\tilde{W} = W + \epsilon$. Makes model robust to weight perturbations; related to flatness/generalization.
- **Label smoothing:** soft targets prevent overconfident predictions. See [Loss Functions](04-loss-functions).

## Max-Norm Constraint

Constrains the norm of each neuron's weight vector to be at most $c$:

$$\|w_j\|_2 \leq c$$

Applied post-gradient-step by projecting onto the ball. More robust than L2 for very large learning rates; commonly used alongside dropout.

## Summary Comparison

| Technique | Mechanism | Produces Sparsity | Main Use |
|-----------|----------|-------------------|---------|
| L2 (weight decay) | Shrinks weights | No | Default in deep learning |
| L1 | Absolute value penalty | Yes | Feature selection, linear models |
| Elastic Net | L1 + L2 | Yes (partial) | Tabular regression |
| Data augmentation | Effective data increase | No | Vision, NLP, audio |
| Early stopping | Limits optimization steps | No | Always recommended |
| Dropout | Random unit removal | Implicit | Dense, RNN layers |
| Batch normalization | Noise from batch stats | No | Deep networks |
| Label smoothing | Soft targets | No | Classification |
| Max-norm | Constrained optimization | No | With dropout |

See [Dropout](10-dropout) and [Batch Normalization](11-batch-normalization) for dedicated coverage of those techniques.
