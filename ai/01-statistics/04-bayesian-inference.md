# Bayesian Inference

Bayesian inference treats parameters as random variables and updates beliefs using Bayes' theorem:

$$P(\theta | D) = \frac{P(D | \theta) P(\theta)}{P(D)}$$

- $\theta$: unknown parameter(s)
- $D$: observed data
- $P(\theta)$: prior (belief before seeing data)
- $P(D \mid \theta)$: likelihood (probability of data given parameters)
- $P(\theta \mid D)$: posterior (updated belief after seeing data)
- $P(D)$: marginal likelihood / evidence (normalizing constant)

## The Evidence (Marginal Likelihood)

$$P(D) = \int P(D | \theta) P(\theta) d\theta$$

For discrete parameters, replace integral with sum.

**Role:**
- Normalizes the posterior to sum/integrate to 1
- Used for model comparison (higher evidence = better model)
- Often intractable for continuous parameters (requires approximation)

## Conjugate Priors

A prior is **conjugate** to a likelihood if the posterior is in the same family as the prior.

| Likelihood | Conjugate Prior | Posterior |
|------------|-----------------|-----------|
| Bernoulli | Beta($\alpha, \beta$) | Beta($\alpha + \text{successes}, \beta + \text{failures}$) |
| Binomial | Beta($\alpha, \beta$) | Beta($\alpha + k, \beta + n-k$) |
| Poisson | Gamma($\alpha, \beta$) | Gamma($\alpha + \sum x_i, \beta + n$) |
| Normal (known $\sigma^2$) | Normal($\mu_0, \sigma_0^2$) | Normal (updated mean/variance) |
| Normal (known $\mu$) | Inverse-Gamma | Inverse-Gamma |
| Multinomial | Dirichlet($\alpha_1, \ldots, \alpha_k$) | Dirichlet($\alpha_1 + n_1, \ldots, \alpha_k + n_k$) |

## Example: Beta-Bernoulli Model

**Prior:** $\theta \sim \text{Beta}(\alpha, \beta)$

$$P(\theta) \propto \theta^{\alpha-1} (1-\theta)^{\beta-1}$$

**Likelihood:** $D = \{x_1, \ldots, x_n\}$, $x_i \sim \text{Bernoulli}(\theta)$

$$P(D | \theta) = \theta^k (1-\theta)^{n-k}$$

where $k = \sum_i x_i$ (number of successes).

**Posterior:**

$$P(\theta | D) \propto P(D | \theta) P(\theta) \propto \theta^{k+\alpha-1} (1-\theta)^{n-k+\beta-1}$$

$$\theta | D \sim \text{Beta}(\alpha + k, \beta + n - k)$$

**Interpretation:** Prior acts like "pseudo-counts" added to observed data.

## Point Estimation in Bayesian Framework

**Maximum a Posteriori (MAP):**

$$\hat{\theta}_{\text{MAP}} = \arg\max_\theta P(\theta | D) = \arg\max_\theta P(D | \theta) P(\theta)$$

Like MLE but with prior regularization.

**Posterior Mean:**

$$\hat{\theta}_{\text{mean}} = E[\theta | D] = \int \theta P(\theta | D) d\theta$$

Minimizes squared error loss.

**Posterior Median:**

Minimizes absolute error loss.

## Bayesian Prediction

Predicting new data $x_{\text{new}}$ integrates over all possible parameter values:

$$P(x_{\text{new}} | D) = \int P(x_{\text{new}} | \theta) P(\theta | D) d\theta$$

This is the **posterior predictive distribution**.

**Key difference from frequentist:** Accounts for parameter uncertainty, not just point estimates.

## Credible Intervals

A **$100(1-\alpha)\%$ credible interval** is a range $[a, b]$ such that:

$$P(a \leq \theta \leq b | D) = 1 - \alpha$$

**Interpretation:** "There is a $1-\alpha$ probability that $\theta$ lies in this interval" (unlike frequentist confidence intervals).

**Highest Density Interval (HDI):** The narrowest interval containing $1-\alpha$ of the posterior mass.

## Priors: Choosing and Interpreting

**Informative priors:** Encode domain knowledge (e.g., previous studies, physical constraints).

**Weakly informative priors:** Regularize without strongly influencing (e.g., Normal(0, 10) for regression coefficients).

**Non-informative / reference priors:** Minimal influence (e.g., Uniform, Jeffreys prior).

**Improper priors:** Don't integrate to 1 but yield proper posteriors (e.g., $P(\theta) \propto 1$ for real-valued parameters).

## Hierarchical Bayesian Models

Parameters themselves have priors with hyperparameters:

$$\theta \sim P(\theta | \phi), \quad \phi \sim P(\phi)$$

**Example:** Modeling student test scores across schools:
- Each school has its mean $\mu_j$
- School means come from a population distribution: $\mu_j \sim \text{Normal}(\mu_0, \tau^2)$
- Hyperpriors on $\mu_0$ and $\tau$

**Benefit:** Partial pooling shares statistical strength across groups.

## Computational Methods

### Analytical Solutions

Only available for conjugate models or simple cases.

### Grid Approximation

Discretize parameter space, compute posterior at each point.

- Simple but scales poorly with dimension
- Good for teaching and 1-2 parameter problems

### Laplace Approximation

Approximate posterior with a Normal centered at the MAP:

$$P(\theta | D) \approx \mathcal{N}(\hat{\theta}_{\text{MAP}}, H^{-1})$$

where $H$ is the Hessian of $\log P(\theta \mid D)$ at the mode.

### Markov Chain Monte Carlo (MCMC)

Generate samples from the posterior using a Markov chain.

**Metropolis-Hastings:**
1. Propose $\theta' \sim q(\theta' \mid \theta_t)$
2. Accept with probability $\alpha = \min\left(1, \frac{P(\theta' \mid D) q(\theta_t \mid \theta')}{P(\theta_t \mid D) q(\theta' \mid \theta_t)}\right)$

**Gibbs Sampling:**
- Sample each parameter from its conditional distribution given others
- Special case of Metropolis-Hastings with acceptance = 1

**Hamiltonian Monte Carlo (HMC):**
- Uses gradient information for efficient exploration
- Implemented in Stan, PyMC, NumPyro

### Variational Inference

Approximate posterior with a simpler distribution $q(\theta)$ by minimizing KL divergence:

$$q^*(\theta) = \arg\min_q D_{\text{KL}}(q(\theta) \Vert P(\theta | D))$$

- Faster than MCMC but introduces approximation bias
- Scales to large datasets

## Bayesian vs Frequentist

| Aspect | Frequentist | Bayesian |
|--------|-------------|----------|
| Parameters | Fixed but unknown | Random variables |
| Data | Fixed | Random |
| Inference | Point estimates, confidence intervals | Full posterior, credible intervals |
| Prior information | Not incorporated | Explicitly modeled |
| Computation | Optimization | Integration / sampling |
| Interpretation | Long-run frequency | Degree of belief |
