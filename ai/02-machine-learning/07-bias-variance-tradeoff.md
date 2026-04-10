# Bias Variance Tradeoff

## Concept / Definition

Prediction error decomposes into approximation bias, estimator variance, and irreducible noise

For estimator $\hat{f}(x)$ under squared loss

## Mathematical Formulation

Bias at point $x$
$$
\operatorname{Bias}(x) = \mathbb{E}[\hat{f}(x)] - f^\ast(x)
$$

Variance at point $x$
$$
\operatorname{Var}(x) = \mathbb{E}\big[(\hat{f}(x) - \mathbb{E}[\hat{f}(x)])^2\big]
$$

Decomposition
$$
\mathbb{E}\big[(Y - \hat{f}(x))^2 \mid X=x\big]
= \sigma^2(x) + \operatorname{Bias}(x)^2 + \operatorname{Var}(x)
$$
where
$$
\sigma^2(x) = \operatorname{Var}(Y \mid X=x)
$$

Integrated risk
$$
R = \mathbb{E}_X[\sigma^2(X) + \operatorname{Bias}(X)^2 + \operatorname{Var}(X)]
$$

## Conditions / Properties

Increasing model capacity usually decreases bias and increases variance

Regularization parameter effect
$$
\lambda \uparrow \Rightarrow \text{bias} \uparrow, \quad \text{variance} \downarrow
$$

Training-set size effect
$$
n \uparrow \Rightarrow \text{variance} \downarrow
$$
typically

Tradeoff concerns expected test error, not training error

## Algorithms / Methods

<table>
<tr><th>Mechanism</th><th>Bias effect</th><th>Variance effect</th></tr>
<tr><td>Deeper tree</td><td>decrease</td><td>increase</td></tr>
<tr><td>Stronger L2 penalty</td><td>increase</td><td>decrease</td></tr>
<tr><td>Bagging</td><td>near-constant</td><td>decrease</td></tr>
<tr><td>Feature expansion</td><td>decrease</td><td>increase</td></tr>
<tr><td>Early stopping</td><td>increase slightly</td><td>decrease</td></tr>
</table>

Ridge estimator
$$
\hat{w}_{\lambda} = (X^\top X + \lambda I)^{-1} X^\top y
$$
shows explicit complexity control

Ensemble variance reduction for average of $M$ estimators with variance $\sigma^2$ and pairwise correlation $\rho$
$$
\operatorname{Var}\left(\frac{1}{M}\sum_{m=1}^M h_m\right)
= \sigma^2 \left(\rho + \frac{1-\rho}{M}\right)
$$

## Variants / Extensions

<table>
<tr><th>Setting</th><th>Tradeoff form</th><th>Note</th></tr>
<tr><td>Classification</td><td>no exact squared-loss decomposition</td><td>still useful conceptual lens</td></tr>
<tr><td>Bayesian models</td><td>posterior mean balances fit and prior</td><td>variance encoded in posterior</td></tr>
<tr><td>Double descent</td><td>error may fall again after interpolation threshold</td><td>modern overparameterized regime</td></tr>
</table>

## Practical Notes

High bias signs: train and validation errors both high

High variance signs: training error low, validation error much higher

Diagnostics should compare
$$
\hat{R}_{\text{train}}, \hat{R}_{\text{valid}}
$$
as model complexity changes

Remedies:
$$
\text{high bias} \to \text{richer model/features}
$$
$$
\text{high variance} \to \text{more data/regularization/ensembling}
$$
