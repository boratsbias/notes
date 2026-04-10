# Expectation and Variance

## Expected Value

The **expected value** (mean, expectation) is the long-run average value of a random variable.

**For discrete variables:**

$$E[X] = \sum_x x \cdot p(x)$$

**For continuous variables:**

$$E[X] = \int_{-\infty}^{\infty} x \cdot f(x) dx$$

**Notation:** $E[X]$, $\mathbb{E}[X]$, or $\mu_X$

## Properties of Expectation

- **Linearity:** $E[aX + bY] = aE[X] + bE[Y]$
- **Constant:** $E[c] = c$
- **Independence:** If $X$ and $Y$ are independent, $E[XY] = E[X]E[Y]$
- **Law of the unconscious statistician (LOTUS):**

  $$E[g(X)] = \sum_x g(x) p(x) \quad \text{(discrete)}$$

  $$E[g(X)] = \int_{-\infty}^{\infty} g(x) f(x) dx \quad \text{(continuous)}$$

## Variance

**Variance** measures the spread or dispersion around the mean:

$$\text{Var}(X) = E[(X - \mu)^2]$$

**Computational formula:**

$$\text{Var}(X) = E[X^2] - (E[X])^2$$

**Notation:** $\text{Var}(X)$, $\sigma_X^2$, or $\sigma^2$

## Properties of Variance

- **Constant:** $\text{Var}(c) = 0$
- **Scaling:** $\text{Var}(aX) = a^2 \text{Var}(X)$
- **Shift:** $\text{Var}(X + c) = \text{Var}(X)$
- **Sum of independent variables:**

  $$\text{Var}(X + Y) = \text{Var}(X) + \text{Var}(Y) \quad \text{(if independent)}$$

- **General sum:**

  $$\text{Var}(X + Y) = \text{Var}(X) + \text{Var}(Y) + 2\text{Cov}(X, Y)$$

## Standard Deviation

**Standard deviation** is the square root of variance:

$$\sigma = \sqrt{\text{Var}(X)}$$

Same units as $X$, more interpretable than variance.

## Covariance

**Covariance** measures how two variables vary together:

$$\text{Cov}(X, Y) = E[(X - \mu_X)(Y - \mu_Y)]$$

**Computational formula:**

$$\text{Cov}(X, Y) = E[XY] - E[X]E[Y]$$

**Properties:**
- $\text{Cov}(X, X) = \text{Var}(X)$
- $\text{Cov}(X, Y) = \text{Cov}(Y, X)$ (symmetric)
- $\text{Cov}(aX, bY) = ab \cdot \text{Cov}(X, Y)$
- $\text{Cov}(X + Y, Z) = \text{Cov}(X, Z) + \text{Cov}(Y, Z)$

## Correlation

**Correlation** is normalized covariance (scale-free):

$$\rho(X, Y) = \frac{\text{Cov}(X, Y)}{\sigma_X \sigma_Y}$$

**Properties:**
- $-1 \leq \rho \leq 1$
- $\rho = 1$: perfect positive linear relationship
- $\rho = -1$: perfect negative linear relationship
- $\rho = 0$: no linear relationship (but may have nonlinear dependence)
- **Independence implies zero correlation**, but zero correlation does NOT imply independence

## Sample Statistics

Given data $x_1, \ldots, x_n$:

**Sample mean:**

$$\bar{x} = \frac{1}{n} \sum_{i=1}^n x_i$$

**Sample variance** (unbiased estimator):

$$s^2 = \frac{1}{n-1} \sum_{i=1}^n (x_i - \bar{x})^2$$

**Sample standard deviation:**

$$s = \sqrt{s^2}$$

**Sample covariance:**

$$\text{Cov}(X, Y) = \frac{1}{n-1} \sum_{i=1}^n (x_i - \bar{x})(y_i - \bar{y})$$

## Moments

**Raw moments:** $\mu_k' = E[X^k]$

**Central moments:** $\mu_k = E[(X - \mu)^k]$

- $\mu_1 = \mu$ (mean)
- $\mu_2 = \sigma^2$ (variance)
- $\mu_3$ relates to **skewness** (asymmetry)
- $\mu_4$ relates to **kurtosis** (tail heaviness)

## Moment Generating Function (MGF)

$$M_X(t) = E[e^{tX}]$$

**Key property:** $k$-th derivative at $t=0$ gives $k$-th moment:

$$M_X^{(k)}(0) = E[X^k]$$

**Uniqueness:** If two distributions have the same MGF, they are identical.

## Inequalities

**Markov's inequality** (for non-negative $X$):

$$P(X \geq a) \leq \frac{E[X]}{a}$$

**Chebyshev's inequality:**

$$P(|X - \mu| \geq k\sigma) \leq \frac{1}{k^2}$$

Guarantees that most mass lies within a few standard deviations of the mean.

## Law of Large Numbers

**Weak LLN:** Sample mean converges in probability to expected value:

$$\bar{X}_n \xrightarrow{P} \mu \quad \text{as } n \to \infty$$

**Strong LLN:** Sample mean converges almost surely:

$$\bar{X}_n \xrightarrow{a.s.} \mu \quad \text{as } n \to \infty$$

Foundation of Monte Carlo methods and empirical risk minimization.

## Central Limit Theorem

For i.i.d. variables $X_1, \ldots, X_n$ with mean $\mu$ and variance $\sigma^2$:

$$\frac{\bar{X}_n - \mu}{\sigma/\sqrt{n}} \xrightarrow{d} \mathcal{N}(0, 1)$$

As $n \to \infty$, the sample mean approaches a Normal distribution regardless of the original distribution.

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Expectation | Loss functions, policy gradients in RL |
| Variance | Model uncertainty, regularization |
| Covariance/Correlation | Feature selection, PCA, covariance matrices |
| Sample statistics | Empirical risk, batch normalization |
| LLN | Monte Carlo estimation, SGD convergence |
| CLT | Confidence intervals, hypothesis testing |
| MGF | Deriving distribution properties, proofs |
