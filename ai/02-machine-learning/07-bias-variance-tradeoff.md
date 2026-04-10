# Bias Variance Tradeoff

## What is the Bias-Variance Tradeoff?

The bias-variance tradeoff decomposes the expected generalization error of a learning algorithm into three terms: bias (systematic error), variance (sensitivity to training data), and irreducible noise. Minimizing total error requires balancing bias and variance.

## Decomposition

For a regression problem with squared error loss, the expected test error at a point $x$ is:

$$\mathbb{E}[(y - \hat{f}(x))^2] = \text{Bias}^2[\hat{f}(x)] + \text{Var}[\hat{f}(x)] + \sigma^2$$

where:
- $y = f(x) + \epsilon$, $\mathbb{E}[\epsilon] = 0$, $\text{Var}[\epsilon] = \sigma^2$
- $\hat{f}(x)$ is the model's prediction, averaged over different training sets

**Bias:**

$$\text{Bias}[\hat{f}(x)] = \mathbb{E}[\hat{f}(x)] - f(x)$$

How far the average prediction is from the true function.

**Variance:**

$$\text{Var}[\hat{f}(x)] = \mathbb{E}\left[(\hat{f}(x) - \mathbb{E}[\hat{f}(x)])^2\right]$$

How much the prediction changes across different training sets.

**Irreducible noise** $\sigma^2$: inherent randomness in the data. Cannot be reduced by any model.

## Interpretation

| Term | Meaning | Caused by |
|------|---------|-----------|
| High bias | Model systematically misses the true pattern | Underfitting, model too simple |
| High variance | Model is highly sensitive to training data | Overfitting, model too complex |
| Irreducible noise | Noise in labels or features | Measurement error, label ambiguity |

**Underfitting:** high bias, low variance. Model does not capture the signal.

**Overfitting:** low bias, high variance. Model fits noise specific to training set.

**Sweet spot:** model complexity where total error is minimized.

## The Tradeoff

As model complexity increases:
- Bias decreases (more expressive model can fit true function).
- Variance increases (more parameters, more sensitivity to training set).

Total expected error is a U-shaped curve as a function of complexity.

$$\text{Total Error} = \text{Bias}^2 + \text{Variance} + \sigma^2$$

## Identifying from Train/Test Error

| Situation | Train Error | Test Error | Diagnosis |
|-----------|------------|------------|-----------|
| High bias | High | High | Underfitting |
| High variance | Low | High | Overfitting |
| Optimal | Low | Low (close to train) | Good generalization |
| Irreducible noise dominates | Cannot go below $\sigma^2$ | Cannot go below $\sigma^2$ | Improve data quality |

## Reducing Bias

- Use a more expressive model (higher degree polynomial, deeper network).
- Add features or feature interactions.
- Reduce regularization strength.
- Train longer (for iterative methods).
- Engineer better features.

## Reducing Variance

- Collect more training data: variance scales as $O(1/n)$ for many models.
- Increase regularization (L1, L2, dropout, early stopping).
- Reduce model complexity (fewer parameters, shallower depth, fewer features).
- Use ensemble methods: **Bagging** averages predictions across models trained on bootstrap samples, reducing variance without increasing bias.
- Data augmentation.

## Formal Example: Polynomial Regression

True function: $f(x) = \sin(2\pi x)$, noise $\sigma^2 = 0.1$.

| Model | Bias | Variance |
|-------|------|---------|
| Degree 0 (constant) | High | Very low |
| Degree 1 (linear) | High | Low |
| Degree 3 (cubic) | Low | Medium |
| Degree 9 (complex) | Very low | Very high |

Degree 3 achieves the best balance for limited data.

## Bagging as Variance Reduction

If $\hat{f}_1, \ldots, \hat{f}_B$ are independent models each with variance $\sigma^2$ and pairwise correlation $\rho$:

$$\text{Var}\!\left[\frac{1}{B}\sum_{b=1}^B \hat{f}_b\right] = \rho \sigma^2 + \frac{1-\rho}{B}\sigma^2$$

As $B \to \infty$, variance approaches $\rho \sigma^2$. Decorrelating models (via random subspace, bootstrap) drives $\rho$ down and further reduces variance.

## Double Descent

Modern observation that transcends classical bias-variance tradeoff: as model complexity continues past the interpolation threshold (where training error reaches zero), test error can decrease again.

**Three regimes:**
1. **Classical:** increasing complexity reduces bias, increases variance (U-curve).
2. **Interpolation threshold:** model is just large enough to fit training data; test error peaks.
3. **Over-parameterized:** extremely large models can memorize training data while still generalizing well (implicit regularization from gradient descent, benign overfitting).

Relevant for deep neural networks and large kernel machines. Challenges the classical assumption that overfitting always hurts.

## Bias-Variance in Classification

For 0-1 loss, the decomposition is more complex and non-additive. An analogous (but different) decomposition exists:

- **Bias:** error of the main prediction (most frequent label across datasets).
- **Variance:** probability that prediction differs from the main prediction.
- Net error is not simply bias$^2$ + variance.

The qualitative insight still holds: simpler models underfit, complex models overfit.

See [Cross Validation](08-cross-validation) for empirically estimating these quantities and [Ensemble Learning](10-ensemble-learning) for structured variance reduction.
