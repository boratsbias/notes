# Entropy and KL Divergence

## Entropy

**Shannon entropy** measures the uncertainty or information content of a random variable.

### Discrete Entropy

For a discrete random variable $X$ with PMF $P(X)$:

$$H(X) = -\sum_x P(x) \log P(x)$$

**Properties:**
- $H(X) \geq 0$ (non-negative)
- $H(X) = 0$ iff $X$ is deterministic
- Maximized when $X$ is uniform: $H_{\text{max}} = \log \lvert\mathcal{X}\rvert$
- Base of logarithm: $\log_2$ gives bits, $\ln$ gives nats

### Differential Entropy

For a continuous random variable $X$ with PDF $f(x)$:

$$h(X) = -\int f(x) \log f(x) dx$$

**Differences from discrete entropy:**
- Can be negative (e.g., narrow Gaussian)
- Not invariant to coordinate transformations
- Requires Jacobian correction under change of variables

### Entropy of Common Distributions

| Distribution | Entropy |
|--------------|---------|
| Bernoulli($p$) | $-p \log p - (1-p) \log(1-p)$ |
| Uniform($a, b$) | $\log(b - a)$ |
| Normal($\mu, \sigma^2$) | $\frac{1}{2} \log(2\pi e \sigma^2)$ |
| Exponential($\lambda$) | $1 - \log \lambda$ |

## Joint and Conditional Entropy

### Joint Entropy

Uncertainty in multiple variables together:

$$H(X, Y) = -\sum_{x,y} P(x, y) \log P(x, y)$$

### Conditional Entropy

Uncertainty in $Y$ given knowledge of $X$:

$$H(Y|X) = -\sum_{x,y} P(x, y) \log P(y|x)$$

**Chain rule:**

$$H(X, Y) = H(X) + H(Y|X)$$

**Property:** $H(Y \mid X) \leq H(Y)$ (conditioning reduces entropy)

Equality holds iff $X$ and $Y$ are independent.

## Mutual Information

**Mutual information (MI)** measures the amount of information shared between two variables:

$$I(X; Y) = \sum_{x,y} P(x, y) \log \frac{P(x, y)}{P(x) P(y)}$$

**Equivalent expressions:**

$$I(X; Y) = H(Y) - H(Y|X)$$

$$I(X; Y) = H(X) - H(X|Y)$$

$$I(X; Y) = H(X) + H(Y) - H(X, Y)$$

**Properties:**
- $I(X; Y) \geq 0$ (non-negative)
- $I(X; Y) = 0$ iff $X$ and $Y$ are independent
- Symmetric: $I(X; Y) = I(Y; X)$
- $I(X; X) = H(X)$ (self-information equals entropy)

### Conditional Mutual Information

$$I(X; Y | Z) = H(X|Z) - H(X|Y, Z)$$

Information shared between $X$ and $Y$ given knowledge of $Z$.

## KL Divergence

**Kullback-Leibler divergence** measures how much one distribution diverges from another.

### Definition

For discrete distributions $P$ and $Q$:

$$D_{\text{KL}}(P \Vert Q) = \sum_x P(x) \log \frac{P(x)}{Q(x)}$$

For continuous distributions:

$$D_{\text{KL}}(P \Vert Q) = \int p(x) \log \frac{p(x)}{q(x)} dx$$

### Properties

- $D_{\text{KL}}(P \Vert Q) \geq 0$ (Gibbs' inequality)
- $D_{\text{KL}}(P \Vert Q) = 0$ iff $P = Q$ (almost everywhere)
- **Not symmetric:** $D_{\text{KL}}(P \Vert Q) \neq D_{\text{KL}}(Q \Vert P)$ in general
- **Not a metric:** doesn't satisfy triangle inequality

### Relationship to Entropy and Cross-Entropy

**Cross-entropy:**

$$H(P, Q) = -\sum_x P(x) \log Q(x)$$

**Relationship:**

$$D_{\text{KL}}(P \Vert Q) = H(P, Q) - H(P)$$

Minimizing cross-entropy is equivalent to minimizing KL divergence (since $H(P)$ is constant).

### KL Divergence for Common Distributions

**Bernoulli:**

$$D_{\text{KL}}(\text{Bern}(p) \Vert \text{Bern}(q)) = p \log \frac{p}{q} + (1-p) \log \frac{1-p}{1-q}$$

**Normal:**

$$D_{\text{KL}}(\mathcal{N}_0 \Vert \mathcal{N}_1) = \frac{1}{2} \left[\frac{(\mu_1 - \mu_0)^2}{\sigma_1^2} + \frac{\sigma_0^2}{\sigma_1^2} - 1 + \log \frac{\sigma_1}{\sigma_0}\right]$$

**Multivariate Normal:**

$$D_{\text{KL}}(\mathcal{N}_0 \Vert \mathcal{N}_1) = \frac{1}{2} \left[\text{tr}(\Sigma_1^{-1} \Sigma_0) + (\mu_1 - \mu_0)^T \Sigma_1^{-1} (\mu_1 - \mu_0) - k + \log \frac{|\Sigma_1|}{|\Sigma_0|}\right]$$

## Forward vs Reverse KL

### Forward KL ($D_{\text{KL}}(P \Vert Q)$)

- **Zero-avoiding:** $Q$ must cover all regions where $P$ has mass
- Tends to **overestimate** the support of $P$
- Used in: maximum likelihood, variational inference (variational distribution approximates true posterior)

### Reverse KL ($D_{\text{KL}}(Q \Vert P)$)

- **Zero-forcing:** $Q$ concentrates on high-probability regions of $P$
- Tends to **underestimate** the support of $P$
- Used in: EM algorithm, reinforcement learning (policy optimization)

## Jensen-Shannon Divergence

Symmetrized, smoothed version of KL divergence:

$$\text{JSD}(P \Vert Q) = \frac{1}{2} D_{\text{KL}}(P \Vert M) + \frac{1}{2} D_{\text{KL}}(Q \Vert M)$$

where $M = \frac{1}{2}(P + Q)$ (mixture distribution).

**Properties:**
- Always finite (unlike KL)
- Symmetric: $\text{JSD}(P \Vert Q) = \text{JSD}(Q \Vert P)$
- Bounded: $0 \leq \text{JSD} \leq \log 2$ (for $\log_2$)
- $\sqrt{\text{JSD}}$ is a proper metric

## Cross-Entropy in Machine Learning

### Classification Loss

For true label $y$ (one-hot) and predicted probabilities $\hat{y}$:

$$\mathcal{L} = -\sum_{i=1}^C y_i \log \hat{y}_i$$

**Binary classification:**

$$\mathcal{L} = -[y \log \hat{y} + (1-y) \log(1-\hat{y})]$$

**Multi-class classification:**

$$\mathcal{L} = -\sum_{c=1}^C y_c \log \hat{y}_c$$

Minimizing cross-entropy loss = maximizing log-likelihood = minimizing KL divergence between true and predicted distributions.

## Applications in Information Theory

### Source Coding Theorem

The minimum expected code length to encode samples from $P$ is $H(P)$ bits.

Using a code optimized for $Q$ when the true distribution is $P$ gives expected length $H(P, Q)$.

### Rate-Distortion Theory

Minimum rate (bits) needed to represent a source within distortion $D$:

$$R(D) = \min_{P(\hat{X}|X) : E[d(X, \hat{X})] \leq D} I(X; \hat{X})$$

## Applications in Machine Learning

### Variational Inference

Approximate intractable posterior $P(\theta \mid D)$ with variational distribution $q(\theta)$:

$$q^*(\theta) = \arg\min_q D_{\text{KL}}(q(\theta) \Vert P(\theta | D))$$

**ELBO (Evidence Lower Bound):**

$$\log P(D) \geq E_q[\log P(D | \theta)] - D_{\text{KL}}(q(\theta) \Vert P(\theta))$$

### Variational Autoencoders (VAEs)

KL divergence regularizes the latent space:

$$\mathcal{L} = E_{q(z|x)}[\log P(x|z)] - D_{\text{KL}}(q(z|x) \Vert P(z))$$

### Expectation-Maximization (EM)

E-step: Compute expected complete-data log-likelihood.
M-step: Maximize w.r.t. parameters.

Equivalent to minimizing reverse KL divergence.

### Information Bottleneck

Compress input $X$ while preserving information about target $Y$:

$$\min_{P(Z|X)} I(X; Z) - \beta I(Z; Y)$$

Trade-off between compression and prediction.

### Contrastive Learning

InfoNCE loss estimates mutual information:

$$\mathcal{L} = -\log \frac{\exp(\text{sim}(x, x^+)/\tau)}{\sum_{x^-} \exp(\text{sim}(x, x^-)/\tau)}$$

Lower bound on mutual information between representations.
