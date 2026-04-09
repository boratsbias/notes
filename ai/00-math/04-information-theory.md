# Information Theory

## Core Idea

Information theory quantifies **uncertainty**, **information content**, and **communication efficiency**. In ML, it provides the theoretical foundation for loss functions, compression, and learning bounds.

## Entropy

**Shannon entropy** measures the expected surprise (uncertainty) of a random variable $X$:

$$H(X) = -\sum_x p(x) \log p(x)$$

- Uses $\log_2$ → bits; $\ln$ → nats
- $H(X) \geq 0$, equals 0 when $X$ is deterministic
- Maximized by the uniform distribution
- For binary $X$: $H = -p\log p - (1-p)\log(1-p)$ (binary entropy function)

**Differential entropy** for continuous distributions:

$$h(X) = -\int p(x) \log p(x)\, dx$$

Can be negative (unlike discrete entropy).

## Joint and Conditional Entropy

$$H(X, Y) = -\sum_{x,y} p(x,y) \log p(x,y)$$

$$H(Y|X) = -\sum_{x,y} p(x,y) \log p(y|x)$$

**Chain rule:** $H(X, Y) = H(X) + H(Y \mid X)$

**Conditioning reduces entropy:** $H(Y \mid X) \leq H(Y)$

## Cross-Entropy

Measures the expected number of bits needed to encode samples from $p$ using a code optimized for $q$:

$$H(p, q) = -\sum_x p(x) \log q(x)$$

**Cross-entropy loss** in classification:

$$\mathcal{L} = -\sum_i y_i \log \hat{y}_i$$

where $y$ is the true label (one-hot) and $\hat{y}$ is the predicted probability.

- Minimizing cross-entropy = maximizing log-likelihood = MLE

## KL Divergence

Measures how much distribution $q$ diverges from the true distribution $p$:

$$D_{KL}(p \Vert q) = \sum_x p(x) \log \frac{p(x)}{q(x)}$$

Properties:
- $D_{KL}(p \Vert q) \geq 0$ (Gibbs' inequality)
- $D_{KL}(p \Vert q) = 0$ iff $p = q$
- **Not symmetric:** $D_{KL}(p \Vert q) \neq D_{KL}(q \Vert p)$ in general
- Relationship: $H(p, q) = H(p) + D_{KL}(p \Vert q)$

**Forward KL** $D_{KL}(p \Vert q)$: zero-avoiding, $q$ must cover all of $p$.
**Reverse KL** $D_{KL}(q \Vert p)$: zero-forcing, $q$ concentrates where $p$ is high. Used in variational inference (ELBO).

## Mutual Information

Measures the amount of information shared between $X$ and $Y$:

$$I(X; Y) = \sum_{x,y} p(x,y) \log \frac{p(x,y)}{p(x)p(y)}$$

$$I(X; Y) = H(X) - H(X|Y) = H(Y) - H(Y|X) = H(X) + H(Y) - H(X,Y)$$

- $I(X; Y) = 0$ iff $X$ and $Y$ are independent
- $I(X; Y) = D_{KL}(p(x,y) \Vert p(x)p(y))$

Used in: feature selection, representation learning (InfoNCE), IB (information bottleneck).

## Jensen's Inequality

For a convex function $f$:

$$f(\mathbb{E}[X]) \leq \mathbb{E}[f(X)]$$

For a concave function (like $\log$):

$$\log(\mathbb{E}[X]) \geq \mathbb{E}[\log X]$$

Jensen's inequality is used to derive the ELBO in VAEs and EM algorithm.

## Data Processing Inequality

If $X \to Y \to Z$ form a Markov chain:
$$I(X; Z) \leq I(X; Y)$$

Processing data cannot increase the information about the original source. Foundation of the **information bottleneck** theory of deep learning.

## Minimum Description Length (MDL)

The best model is the one that gives the shortest combined description of:
- The model itself
- The data given the model

Connects information theory to Bayesian inference and model selection.

## Maximum Entropy Principle

Among all distributions satisfying known constraints, choose the one with **maximum entropy** (the least committal distribution).

- No constraints → uniform distribution
- Known mean and variance → Gaussian distribution (maximum entropy for fixed mean/variance)

Used in: feature-based models (MaxEnt classifiers), energy-based models.

## Entropy in Decision Trees

**Information gain** for feature $A$ with respect to target $Y$:

$$\text{IG}(Y, A) = H(Y) - H(Y|A)$$

Greedy split criterion: choose the feature that maximizes information gain. Used in ID3, C4.5 algorithms.

**Gini impurity** is an alternative to entropy for CART:

$$G = 1 - \sum_k p_k^2$$

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Cross-entropy loss | Classification training objective |
| KL divergence | VAE regularization (ELBO), RL (PPO, KL penalty) |
| Mutual information | Representation learning (SimCLR, MINE), feature selection |
| Entropy | Decision trees, RL exploration bonuses |
| Jensen's inequality | ELBO derivation, EM algorithm |
| Data processing inequality | Information bottleneck theory |
| Max entropy | Language model distributions, MaxEnt RL |
