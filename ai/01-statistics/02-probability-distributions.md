# Probability Distributions

## Discrete Distributions

### Bernoulli Distribution

Single binary trial with success probability $p$:

$$P(X = k) = p^k (1-p)^{1-k}, \quad k \in \{0, 1\}$$

- Mean: $p$
- Variance: $p(1-p)$
- Used for: binary classification, coin flips

### Binomial Distribution

Number of successes in $n$ independent Bernoulli trials:

$$P(X = k) = \binom{n}{k} p^k (1-p)^{n-k}, \quad k = 0, 1, \ldots, n$$

- Mean: $np$
- Variance: $np(1-p)$
- Used for: A/B testing, quality control

### Geometric Distribution

Number of trials until first success:

$$P(X = k) = (1-p)^{k-1} p, \quad k = 1, 2, \ldots$$

- Mean: $1/p$
- Variance: $(1-p)/p^2$
- **Memoryless property:** $P(X > m+n | X > m) = P(X > n)$

### Negative Binomial Distribution

Number of trials until $r$ successes:

$$P(X = k) = \binom{k-1}{r-1} p^r (1-p)^{k-r}$$

- Mean: $r/p$
- Variance: $r(1-p)/p^2$
- Used for: overdispersed count data

### Poisson Distribution

Count of events in fixed interval with rate $\lambda$:

$$P(X = k) = \frac{\lambda^k e^{-\lambda}}{k!}, \quad k = 0, 1, 2, \ldots$$

- Mean: $\lambda$
- Variance: $\lambda$
- Used for: rare events, count regression, arrival processes

### Multinomial Distribution

Generalization of binomial to $k$ categories:

$$P(X_1 = n_1, \ldots, X_k = n_k) = \frac{n!}{n_1! \cdots n_k!} p_1^{n_1} \cdots p_k^{n_k}$$

where $\sum_i n_i = n$ and $\sum_i p_i = 1$.

- Used for: multi-class classification, word counts in documents

## Continuous Distributions

### Uniform Distribution

Equal probability over interval $[a, b]$:

$$f(x) = \frac{1}{b-a}, \quad a \leq x \leq b$$

- Mean: $\frac{a+b}{2}$
- Variance: $\frac{(b-a)^2}{12}$
- Used for: initialization, baseline models

### Normal (Gaussian) Distribution

The most important distribution in statistics:

$$f(x) = \frac{1}{\sqrt{2\pi\sigma^2}} \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)$$

- Mean: $\mu$
- Variance: $\sigma^2$
- **Central Limit Theorem:** sum of i.i.d. variables converges to Normal

**Standard Normal:** $\mu = 0, \sigma = 1$

$$\phi(z) = \frac{1}{\sqrt{2\pi}} e^{-z^2/2}$$

**68-95-99.7 rule:**
- 68% of mass within $\mu \pm \sigma$
- 95% of mass within $\mu \pm 2\sigma$
- 99.7% of mass within $\mu \pm 3\sigma$

### Multivariate Normal Distribution

Generalization to $\mathbb{R}^d$:

$$f(\mathbf{x}) = \frac{1}{(2\pi)^{d/2} |\Sigma|^{1/2}} \exp\left(-\frac{1}{2} (\mathbf{x}-\mu)^T \Sigma^{-1} (\mathbf{x}-\mu)\right)$$

- Mean vector: $\mu \in \mathbb{R}^d$
- Covariance matrix: $\Sigma \in \mathbb{R}^{d \times d}$ (symmetric, positive definite)
- Used for: Gaussian processes, Kalman filters, factor analysis

### Exponential Distribution

Time between events in a Poisson process:

$$f(x) = \lambda e^{-\lambda x}, \quad x \geq 0$$

- Mean: $1/\lambda$
- Variance: $1/\lambda^2$
- **Memoryless property:** $P(X > s+t | X > s) = P(X > t)$
- Used for: survival analysis, queueing theory

### Gamma Distribution

Sum of $k$ exponential waiting times:

$$f(x) = \frac{\beta^\alpha}{\Gamma(\alpha)} x^{\alpha-1} e^{-\beta x}, \quad x > 0$$

- Shape: $\alpha > 0$, Rate: $\beta > 0$
- Mean: $\alpha/\beta$
- Variance: $\alpha/\beta^2$
- Used for: Bayesian priors, waiting times

### Beta Distribution

Distribution on $[0, 1]$, conjugate prior for Bernoulli/Binomial:

$$f(x) = \frac{1}{B(\alpha, \beta)} x^{\alpha-1} (1-x)^{\beta-1}, \quad 0 \leq x \leq 1$$

where $B(\alpha, \beta) = \frac{\Gamma(\alpha)\Gamma(\beta)}{\Gamma(\alpha+\beta)}$

- Mean: $\frac{\alpha}{\alpha+\beta}$
- Variance: $\frac{\alpha\beta}{(\alpha+\beta)^2(\alpha+\beta+1)}$
- Used for: Bayesian inference, modeling probabilities

### Dirichlet Distribution

Multivariate generalization of Beta, conjugate prior for Multinomial:

$$f(\mathbf{p}) = \frac{1}{B(\alpha)} \prod_{i=1}^k p_i^{\alpha_i-1}$$

where $\sum_i p_i = 1$ and $B(\alpha) = \frac{\prod_i \Gamma(\alpha_i)}{\Gamma(\sum_i \alpha_i)}$

- Used for: topic models (LDA), categorical priors

### Student's t-Distribution

Heavy-tailed alternative to Normal:

$$f(x) = \frac{\Gamma(\frac{\nu+1}{2})}{\sqrt{\nu\pi} \Gamma(\frac{\nu}{2})} \left(1 + \frac{x^2}{\nu}\right)^{-\frac{\nu+1}{2}}$$

- Degrees of freedom: $\nu > 0$
- Mean: $0$ (for $\nu > 1$)
- Variance: $\frac{\nu}{\nu-2}$ (for $\nu > 2$)
- As $\nu \to \infty$, converges to Standard Normal
- Used for: robust statistics, small-sample inference

### Chi-Squared Distribution

Sum of squared standard Normals:

If $Z_1, \ldots, Z_k \sim \mathcal{N}(0, 1)$, then $X = \sum_i Z_i^2 \sim \chi^2_k$

- Degrees of freedom: $k$
- Mean: $k$
- Variance: $2k$
- Used for: hypothesis testing, confidence intervals

## Summary Table

| Distribution | Parameters | Support | Mean | Variance | Typical Use |
|--------------|------------|---------|------|----------|-------------|
| Bernoulli | $p$ | $\{0,1\}$ | $p$ | $p(1-p)$ | Binary outcomes |
| Binomial | $n, p$ | $\{0,\ldots,n\}$ | $np$ | $np(1-p)$ | Count of successes |
| Poisson | $\lambda$ | $\{0,1,\ldots\}$ | $\lambda$ | $\lambda$ | Rare events |
| Uniform | $a, b$ | $[a,b]$ | $\frac{a+b}{2}$ | $\frac{(b-a)^2}{12}$ | Baseline, initialization |
| Normal | $\mu, \sigma^2$ | $\mathbb{R}$ | $\mu$ | $\sigma^2$ | General modeling |
| Exponential | $\lambda$ | $[0,\infty)$ | $1/\lambda$ | $1/\lambda^2$ | Waiting times |
| Gamma | $\alpha, \beta$ | $(0,\infty)$ | $\alpha/\beta$ | $\alpha/\beta^2$ | Bayesian priors |
| Beta | $\alpha, \beta$ | $[0,1]$ | $\frac{\alpha}{\alpha+\beta}$ | complex | Probability priors |
| Student's t | $\nu$ | $\mathbb{R}$ | $0$ | $\frac{\nu}{\nu-2}$ | Robust statistics |
