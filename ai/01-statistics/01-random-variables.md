# Random Variables

## Definition

A **random variable** $X$ is a function that maps outcomes from a sample space $\Omega$ to real numbers:

$$X: \Omega \to \mathbb{R}$$

**Discrete random variable:** takes countable values (e.g., number of heads, word counts).

**Continuous random variable:** takes uncountable values in an interval (e.g., height, time).

## Probability Mass Function (PMF)

For discrete random variables:

$$p(x) = P(X = x)$$

Properties:
- $0 \leq p(x) \leq 1$
- $\sum_x p(x) = 1$
- $P(X \in A) = \sum_{x \in A} p(x)$

## Probability Density Function (PDF)

For continuous random variables:

$$f(x) \geq 0, \quad \int_{-\infty}^{\infty} f(x) dx = 1$$

The probability over an interval:

$$P(a \leq X \leq b) = \int_a^b f(x) dx$$

**Important:** $P(X = x) = 0$ for continuous variables (probability at a point is zero).

## Cumulative Distribution Function (CDF)

The CDF gives the probability that $X$ is less than or equal to $x$:

$$F(x) = P(X \leq x)$$

**For discrete variables:**

$$F(x) = \sum_{t \leq x} p(t)$$

**For continuous variables:**

$$F(x) = \int_{-\infty}^x f(t) dt$$

**Properties:**
- $F(x)$ is non-decreasing
- $\lim_{x \to -\infty} F(x) = 0$, $\lim_{x \to \infty} F(x) = 1$
- $P(a < X \leq b) = F(b) - F(a)$
- PDF is the derivative: $f(x) = \frac{d}{dx} F(x)$

## Survival Function

Complement of the CDF:

$$S(x) = P(X > x) = 1 - F(x)$$

Used in reliability analysis and survival analysis.

## Quantiles and Percentiles

The **$p$-th quantile** (or $100p$-th percentile) is the value $x_p$ such that:

$$F(x_p) = p$$

**Special quantiles:**
- Median: $x_{0.5}$ (50th percentile)
- Quartiles: $x_{0.25}, x_{0.5}, x_{0.75}$ (25th, 50th, 75th percentiles)
- Interquartile range (IQR): $x_{0.75} - x_{0.25}$

## Indicator Random Variables

For an event $A$, the indicator variable:

$$\mathbb{1}_A = \begin{cases} 1 & \text{if } A \text{ occurs} \\ 0 & \text{otherwise} \end{cases}$$

Useful for converting events into numeric quantities for expectation calculations.

## Transformations of Random Variables

If $Y = g(X)$, the distribution of $Y$ can be derived from $X$.

**For monotonic $g$:**

$$f_Y(y) = f_X(g^{-1}(y)) \left| \frac{d}{dy} g^{-1}(y) \right|$$

The term $\lvert \frac{d}{dy} g^{-1}(y) \rvert$ is the **Jacobian** of the transformation.

## Joint Distributions

For two random variables $X$ and $Y$:

**Joint PMF/PDF:** $p(x, y) = P(X = x, Y = y)$ or $f(x, y)$

**Marginal distribution:**

$$p_X(x) = \sum_y p(x, y) \quad \text{(discrete)}$$

$$f_X(x) = \int_{-\infty}^{\infty} f(x, y) dy \quad \text{(continuous)}$$

## Conditional Distributions

**Conditional PMF/PDF:**

$$p(y|x) = \frac{p(x, y)}{p(x)}, \quad p(x) > 0$$

$$f(y|x) = \frac{f(x, y)}{f_X(x)}, \quad f_X(x) > 0$$

## Independent Random Variables

$X$ and $Y$ are independent if:

$$p(x, y) = p_X(x) p_Y(y)$$

Equivalently: $p(y \mid x) = p_Y(y)$ (knowing $X$ gives no information about $Y$).
