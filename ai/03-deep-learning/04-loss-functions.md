# Loss Functions

## Core Idea

The loss function $\mathcal{L}(\hat{y}, y)$ measures the discrepancy between the model's prediction $\hat{y}$ and the true target $y$. It defines what the network is optimizing and must be chosen to match the task, output distribution, and desired error geometry.

The **training objective** is:

$$\mathcal{J}(\theta) = \frac{1}{n} \sum_{i=1}^n \mathcal{L}(f_\theta(x_i), y_i) + \lambda \Omega(\theta)$$

where $\Omega(\theta)$ is an optional regularizer.

## Classification Losses

### Binary Cross-Entropy (Log Loss)

For $y \in \{0, 1\}$ and predicted probability $\hat{p} = \sigma(z) \in (0,1)$:

$$\mathcal{L} = -[y \log \hat{p} + (1-y) \log(1 - \hat{p})]$$

**Derivation:** MLE under a Bernoulli likelihood $P(y|\hat{p}) = \hat{p}^y (1-\hat{p})^{1-y}$.

**Gradient:** $\frac{\partial \mathcal{L}}{\partial z} = \hat{p} - y$. Clean and bounded; no vanishing gradient at output.

### Categorical Cross-Entropy

For $y \in \{1, \ldots, K\}$ (one-hot encoded as $\mathbf{y}$) and softmax probabilities $\hat{\mathbf{p}}$:

$$\mathcal{L} = -\sum_{k=1}^K y_k \log \hat{p}_k$$

In practice, combined with the softmax as **log-softmax + NLL**:

$$\mathcal{L} = -z_{y} + \log \sum_k e^{z_k}$$

where $z_y$ is the logit for the true class. Numerically stable when computed this way.

### Label Smoothing

Replaces hard one-hot targets with soft targets:

$$\tilde{y}_k = (1 - \epsilon) y_k + \frac{\epsilon}{K}$$

Prevents overconfident predictions; improves calibration. Typically $\epsilon = 0.1$.

### Focal Loss

Addresses class imbalance by down-weighting easy (well-classified) examples:

$$\mathcal{L}_\text{focal} = -(1 - \hat{p}_t)^\gamma \log \hat{p}_t$$

where $\hat{p}_t = \hat{p}$ if $y=1$, else $1 - \hat{p}$, and $\gamma \geq 0$ is the focusing parameter. Used in RetinaNet for object detection.

At $\gamma = 0$: reduces to standard cross-entropy.

### Hinge Loss (SVM)

$$\mathcal{L} = \max(0, 1 - y \cdot f(x)), \quad y \in \{-1, +1\}$$

**Multi-class (Crammer-Singer):** $\mathcal{L} = \max(0, 1 - z_{y_i} + \max_{j \neq y_i} z_j)$

Does not produce calibrated probabilities. Used in SVMs; occasionally in neural nets when margin-based objective is desired.

## Regression Losses

### Mean Squared Error (MSE / L2 Loss)

$$\mathcal{L} = \frac{1}{n}\sum_{i=1}^n (y_i - \hat{y}_i)^2$$

**Derivation:** MLE under a Gaussian likelihood $P(y|\hat{y}) = \mathcal{N}(y; \hat{y}, \sigma^2)$.

**Gradient:** $\frac{\partial \mathcal{L}}{\partial \hat{y}_i} = 2(\hat{y}_i - y_i)$. Amplifies large errors.

### Mean Absolute Error (MAE / L1 Loss)

$$\mathcal{L} = \frac{1}{n}\sum_{i=1}^n |y_i - \hat{y}_i|$$

**Gradient:** $\text{sign}(\hat{y}_i - y_i)$. Robust to outliers; non-differentiable at 0.

### Huber Loss (Smooth L1)

$$\mathcal{L}_\delta = \begin{cases} \frac{1}{2}(y - \hat{y})^2 & |y - \hat{y}| \leq \delta \\ \delta\left(|y - \hat{y}| - \frac{\delta}{2}\right) & |y - \hat{y}| > \delta \end{cases}$$

Differentiable everywhere. MSE behavior near zero; MAE behavior for large errors. $\delta$ controls the transition point.

### Log-Cosh Loss

$$\mathcal{L} = \frac{1}{n}\sum_{i=1}^n \log\!\cosh(y_i - \hat{y}_i)$$

Smooth approximation to Huber/MAE. Has well-defined second derivatives, useful for second-order optimizers.

## Probabilistic / Distribution Losses

### KL Divergence

$$\mathcal{L} = D_{\text{KL}}(P \| Q) = \sum_x P(x) \log \frac{P(x)}{Q(x)}$$

Minimized when model distribution $Q$ matches true distribution $P$. Cross-entropy loss $= H(P, Q) = H(P) + D_{\text{KL}}(P \| Q)$; minimizing cross-entropy is equivalent to minimizing KL when $H(P)$ is fixed.

### ELBO (Evidence Lower Bound)

Used in Variational Autoencoders:

$$\mathcal{L}_{\text{ELBO}} = \mathbb{E}_{q_\phi(z|x)}[\log p_\theta(x|z)] - D_{\text{KL}}(q_\phi(z|x) \| p(z))$$

**Reconstruction term:** forces decoder to reconstruct inputs well.

**KL term:** regularizes latent space toward prior $p(z) = \mathcal{N}(0, I)$.

### Contrastive Loss

Used in self-supervised and metric learning:

$$\mathcal{L} = y \cdot d^2 + (1-y) \cdot \max(0, m - d)^2$$

where $d = \|z_1 - z_2\|$ is the distance between embeddings and $m$ is the margin.

## Ranking / Metric Learning Losses

### Triplet Loss

$$\mathcal{L} = \max(0, \|f(a) - f(p)\|^2 - \|f(a) - f(n)\|^2 + \alpha)$$

Anchor $a$, positive $p$, negative $n$ with margin $\alpha$. Learns embeddings where positive pairs are closer than negative pairs.

### NT-Xent (Normalized Temperature-scaled Cross-Entropy)

Used in contrastive SSL (SimCLR). See [Self Supervised Learning](../../02-machine-learning/04-self-supervised-learning).

## Choosing a Loss Function

| Task | Recommended Loss |
|------|-----------------|
| Binary classification | Binary cross-entropy |
| Multi-class classification | Categorical cross-entropy |
| Multi-label classification | Binary cross-entropy per output |
| Regression (low noise) | MSE |
| Regression (outlier-prone) | Huber or MAE |
| Class imbalance | Focal loss |
| Probabilistic outputs | NLL, ELBO |
| Metric learning | Triplet, NT-Xent |
| Overconfidence problem | Cross-entropy + label smoothing |
