# Sampling Methods

## Core Idea

Sampling methods generate random draws from a probability distribution. In ML, they are used for:
- Approximating intractable integrals (Monte Carlo)
- Generating synthetic data
- Bayesian inference (posterior sampling)
- Training generative models

## Simple Random Sampling

**With replacement:** Each draw is independent, same distribution.

**Without replacement:** Each item can be selected only once.

## Inverse Transform Sampling

If $F$ is the CDF of the target distribution and $U \sim \text{Uniform}(0, 1)$:

$$X = F^{-1}(U)$$

has distribution $F$.

**Algorithm:**
1. Sample $u \sim \text{Uniform}(0, 1)$
2. Return $x = F^{-1}(u)$

**Limitation:** Requires invertible CDF (not available for many distributions).

## Rejection Sampling

Sample from a target distribution $P(x)$ using a proposal distribution $Q(x)$ that is easier to sample from.

**Algorithm:**
1. Sample $x \sim Q(x)$
2. Sample $u \sim \text{Uniform}(0, 1)$
3. Accept $x$ if $u < \frac{P(x)}{M Q(x)}$, where $M$ satisfies $P(x) \leq M Q(x)$ for all $x$
4. Otherwise, reject and repeat

**Acceptance rate:** $1/M$ (higher $M$ = more rejections = less efficient)

**Advantage:** Exact samples from target distribution.

**Disadvantage:** Inefficient in high dimensions (most samples rejected).

## Importance Sampling

Estimate expectations under $P(x)$ using samples from a different distribution $Q(x)$.

For $E_{x \sim P}[f(x)]$:

$$E_{x \sim P}[f(x)] = \int f(x) \frac{P(x)}{Q(x)} Q(x) dx \approx \frac{1}{N} \sum_{i=1}^n w_i f(x_i)$$

where $x_i \sim Q(x)$ and $w_i = \frac{P(x_i)}{Q(x_i)}$ (importance weights).

**Self-normalized importance sampling:**

$$E_{x \sim P}[f(x)] \approx \sum_{i=1}^n \tilde{w}_i f(x_i), \quad \tilde{w}_i = \frac{w_i}{\sum_j w_j}$$

Used when $P(x)$ is known only up to a normalizing constant.

**Problem:** High variance if $Q$ is very different from $P$.

## Markov Chain Monte Carlo (MCMC)

Generate samples using a Markov chain whose stationary distribution is the target $P(x)$.

### Metropolis-Hastings Algorithm

**Algorithm:**
1. Initialize $\theta_0$
2. For $t = 0, 1, 2, \ldots$:
   - Sample proposal $\theta' \sim q(\theta' | \theta_t)$
   - Compute acceptance ratio:
     $$\alpha = \min\left(1, \frac{P(\theta' | D) q(\theta_t | \theta')}{P(\theta_t | D) q(\theta' | \theta_t)}\right)$$
   - Accept $\theta_{t+1} = \theta'$ with probability $\alpha$
   - Otherwise $\theta_{t+1} = \theta_t$

**Key insight:** Only need ratios of posteriors, so normalizing constant $P(D)$ cancels out.

**Special case: Symmetric proposal** ($q(\theta' | \theta) = q(\theta | \theta')$):

$$\alpha = \min\left(1, \frac{P(\theta' | D)}{P(\theta_t | D)}\right)$$

### Gibbs Sampling

Special case of Metropolis-Hastings where proposals are from conditional distributions.

**Algorithm:**
1. Initialize $(\theta_1^{(0)}, \ldots, \theta_k^{(0)})$
2. For $t = 0, 1, 2, \ldots$:
   - Sample $\theta_1^{(t+1)} \sim P(\theta_1 | \theta_2^{(t)}, \ldots, \theta_k^{(t)}, D)$
   - Sample $\theta_2^{(t+1)} \sim P(\theta_2 | \theta_1^{(t+1)}, \theta_3^{(t)}, \ldots, D)$
   - Continue for all variables

**Acceptance rate:** Always 1 (no rejections).

**Requirement:** Need to sample from all conditional distributions.

### Hamiltonian Monte Carlo (HMC)

Uses gradient information to propose distant states with high acceptance probability.

**Idea:** Introduce auxiliary momentum variable $r$ and simulate Hamiltonian dynamics:

$$H(\theta, r) = -\log P(\theta | D) + \frac{1}{2} r^T M^{-1} r$$

**Algorithm:**
1. Sample momentum $r \sim \mathcal{N}(0, M)$
2. Simulate Hamiltonian dynamics using leapfrog integration
3. Accept/reject based on Hamiltonian change

**Advantages:**
- Explores parameter space more efficiently than random-walk MCMC
- Fewer correlations between samples

**Implementation:** No-U-Turn Sampler (NUTS) in Stan, PyMC, NumPyro.

## Block Sampling and Slice Sampling

**Block sampling:** Update groups of correlated variables together (improves mixing).

**Slice sampling:**
- Introduce auxiliary variable $u \sim \text{Uniform}(0, P(\theta))$
- Sample $\theta$ uniformly from the "slice" $\{\theta : P(\theta) > u\}$
- No tuning parameters needed

## Convergence Diagnostics

How to know if MCMC has converged to the stationary distribution?

### Trace Plots

Plot parameter values vs iteration. Look for:
- Stationary (no trend)
- Good mixing (rapid fluctuations, not stuck)

### Gelman-Rubin Statistic (R-hat)

Run multiple chains from different starting points. Compare within-chain and between-chain variance:

$$\hat{R} = \sqrt{\frac{\text{between-chain variance}}{\text{within-chain variance}}}$$

$\hat{R} < 1.1$ indicates convergence.

### Effective Sample Size (ESS)

Number of independent samples equivalent to the correlated MCMC samples:

$$\text{ESS} = \frac{N}{1 + 2 \sum_k \rho_k}$$

where $\rho_k$ is autocorrelation at lag $k$.

## Sequential Monte Carlo (Particle Filters)

For state-space models and time series.

**Algorithm:**
1. Initialize particles $\{x_0^{(i)}\}$ with weights $\{w_0^{(i)}\}$
2. For each time step:
   - Propagate particles through transition model
   - Update weights based on observation likelihood
   - Resample particles (keep high-weight, discard low-weight)

Used in: tracking, robotics, online inference.

## Monte Carlo Integration

Approximate integrals using random samples:

$$\int f(x) P(x) dx \approx \frac{1}{N} \sum_{i=1}^N f(x_i), \quad x_i \sim P(x)$$

**Error:** $O(1/\sqrt{N})$ (independent of dimension!)

**Applications:**
- Computing expectations
- Marginal likelihood estimation
- Predictive distributions

## Variance Reduction Techniques

### Antithetic Variates

Use negatively correlated samples to reduce variance.

### Control Variates

Subtract a correlated variable with known expectation:

$$E[f(X)] = E[f(X) - c(g(X) - E[g(X)))]$$

### Stratified Sampling

Divide domain into strata, sample from each proportionally.
