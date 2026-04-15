# Maximum Likelihood Estimation

**Maximum Likelihood Estimation (MLE)** finds the parameter values that make the observed data most probable.

Given data $D = \{x_1, \ldots, x_n\}$ and a parametric model $P(x | \theta)$:

$$\hat{\theta}_{\text{MLE}} = \arg\max_\theta P(D | \theta) = \arg\max_\theta \prod_{i=1}^n P(x_i | \theta)$$

## The Likelihood Function

**Likelihood:** $L(\theta) = P(D | \theta)$ viewed as a function of $\theta$.

**Important distinction:**
- $P(D | \theta)$ as a function of $D$: probability of data
- $L(\theta)$ as a function of $\theta$: likelihood of parameters

**Note:** Likelihood is NOT a probability distribution over $\theta$ (doesn't sum/integrate to 1).

## Log-Likelihood

Since $\log$ is monotonically increasing, maximizing likelihood is equivalent to maximizing log-likelihood:

$$\ell(\theta) = \log L(\theta) = \sum_{i=1}^n \log P(x_i | \theta)$$

**Advantages:**
- Converts products to sums (easier to compute)
- More numerically stable (avoids underflow)
- Derivatives are simpler

## Finding the MLE

### Analytical Solution

Set derivative to zero:

$$\frac{\partial \ell(\theta)}{\partial \theta} = 0$$

Solve for $\theta$ (if closed-form exists).

### Numerical Optimization

When no closed-form exists:
- Gradient ascent on $\ell(\theta)$
- Newton-Raphson / Fisher scoring
- EM algorithm (for latent variable models)

## Examples

### Bernoulli / Binomial

Data: $x_1, \ldots, x_n \in \{0, 1\}$, $P(x | \theta) = \theta^x (1-\theta)^{1-x}$

**Log-likelihood:**

$$\ell(\theta) = \sum_{i=1}^n [x_i \log \theta + (1-x_i) \log(1-\theta)]$$

**Derivative:**

$$\frac{\partial \ell}{\partial \theta} = \frac{\sum x_i}{\theta} - \frac{n - \sum x_i}{1-\theta} = 0$$

**MLE:**

$$\hat{\theta}_{\text{MLE}} = \frac{1}{n} \sum_{i=1}^n x_i$$

(sample mean = proportion of successes)

### Normal Distribution

Data: $x_1, \ldots, x_n \sim \mathcal{N}(\mu, \sigma^2)$

**Log-likelihood:**

$$\ell(\mu, \sigma^2) = -\frac{n}{2} \log(2\pi) - \frac{n}{2} \log(\sigma^2) - \frac{1}{2\sigma^2} \sum_{i=1}^n (x_i - \mu)^2$$

**MLE for mean:**

$$\hat{\mu}_{\text{MLE}} = \frac{1}{n} \sum_{i=1}^n x_i = \bar{x}$$

**MLE for variance:**

$$\hat{\sigma}^2_{\text{MLE}} = \frac{1}{n} \sum_{i=1}^n (x_i - \bar{x})^2$$

**Note:** Biased estimator (divides by $n$, not $n-1$).

### Poisson Distribution

Data: $x_1, \ldots, x_n \sim \text{Poisson}(\lambda)$

**Log-likelihood:**

$$\ell(\lambda) = \sum_{i=1}^n [x_i \log \lambda - \lambda - \log(x_i!)]$$

**MLE:**

$$\hat{\lambda}_{\text{MLE}} = \frac{1}{n} \sum_{i=1}^n x_i = \bar{x}$$

### Multinomial / Categorical

Data: counts $n_1, \ldots, n_k$ for $k$ categories, $\sum n_i = n$

**Log-likelihood:**

$$\ell(p_1, \ldots, p_k) = \sum_{i=1}^k n_i \log p_i$$

**MLE (with constraint $\sum p_i = 1$):**

$$\hat{p}_i = \frac{n_i}{n}$$

(relative frequencies)

## Properties of MLE

### Consistency

As $n \to \infty$, $\hat{\theta}_{\text{MLE}} \to \theta_0$ (true parameter value).

### Asymptotic Normality

As $n \to \infty$:

$$\sqrt{n}(\hat{\theta}_{\text{MLE}} - \theta_0) \xrightarrow{d} \mathcal{N}(0, I(\theta_0)^{-1})$$

where $I(\theta)$ is the Fisher information.

### Asymptotic Efficiency

MLE achieves the Cramer-Rao lower bound asymptotically (minimum variance among unbiased estimators).

### Invariance

If $\hat{\theta}$ is the MLE of $\theta$, then $g(\hat{\theta})$ is the MLE of $g(\theta)$ for any function $g$.

## Fisher Information

Measures how much information the data provides about $\theta$:

$$I(\theta) = E\left[\left(\frac{\partial}{\partial \theta} \log P(X | \theta)\right)^2\right] = -E\left[\frac{\partial^2}{\partial \theta^2} \log P(X | \theta)\right]$$

**Cramer-Rao bound:** Any unbiased estimator $\hat{\theta}$ satisfies:

$$\text{Var}(\hat{\theta}) \geq \frac{1}{n I(\theta)}$$

## MLE vs MAP

| Aspect | MLE | MAP |
|--------|-----|-----|
| Formula | $\arg\max_\theta P(D \mid \theta)$ | $\arg\max_\theta P(D \mid \theta) P(\theta)$ |
| Prior | None (implicit uniform) | Explicit |
| Result | Point estimate | Point estimate |
| Regularization | None | Prior acts as regularizer |
| Bayesian? | Frequentist | Hybrid (point estimate from Bayesian framework) |

**Connection:** MAP with Gaussian prior = MLE with L2 regularization.

## MLE in Machine Learning

### Linear Regression

Assuming $y_i = \mathbf{w}^T \mathbf{x}_i + \epsilon$ with $\epsilon \sim \mathcal{N}(0, \sigma^2)$:

$$\hat{\mathbf{w}}_{\text{MLE}} = \arg\min_{\mathbf{w}} \sum_{i=1}^n (y_i - \mathbf{w}^T \mathbf{x}_i)^2$$

MLE under Gaussian noise = least squares.

### Logistic Regression

For binary classification with $P(y=1 | \mathbf{x}, \mathbf{w}) = \sigma(\mathbf{w}^T \mathbf{x})$:

$$\hat{\mathbf{w}}_{\text{MLE}} = \arg\max_{\mathbf{w}} \sum_{i=1}^n [y_i \log \sigma(\mathbf{w}^T \mathbf{x}_i) + (1-y_i) \log(1 - \sigma(\mathbf{w}^T \mathbf{x}_i))]$$

MLE = minimizing cross-entropy loss.

### Neural Networks

Training neural networks with cross-entropy or MSE loss is equivalent to MLE:
- Cross-entropy: MLE for categorical output
- MSE: MLE for Gaussian output

## Problems with MLE

### Overfitting

MLE maximizes fit to training data, no penalty for model complexity.

**Solution:** Use MAP or add regularization.

### No Uncertainty Quantification

MLE gives a single point estimate, no measure of confidence.

**Solution:** Full Bayesian inference or bootstrap.

### Non-identifiability

Multiple parameter values may give the same likelihood.

**Example:** Label switching in mixture models.

### Boundary Solutions

MLE can give degenerate solutions (e.g., zero variance, perfect separation).

**Solution:** Add prior / regularization.
