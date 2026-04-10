# Ensemble Learning

## Why do Ensembles work?

Ensemble learning combines predictions from multiple models (base learners) to produce a final prediction that is more accurate and robust than any individual model. The key insight: models make different errors; averaging reduces variance without increasing bias proportionally.

**Ensemble prediction (regression):**

$$\hat{y} = \frac{1}{M} \sum_{m=1}^M \hat{f}_m(x)$$

**For classification:** majority vote or averaging predicted probabilities.

## Why Ensembles Work

From the [Bias Variance Tradeoff](07-bias-variance-tradeoff): if $M$ models are uncorrelated and each has variance $\sigma^2$, the averaged prediction has variance:

$$\text{Var}[\bar{f}] = \rho\sigma^2 + \frac{1-\rho}{M}\sigma^2$$

As $M \to \infty$: variance $\to \rho\sigma^2$. Decorrelating base learners (reducing $\rho$) magnifies variance reduction.

## Bagging (Bootstrap Aggregating)

**Bagging** trains $M$ models on $M$ different bootstrap samples of the training data. Predictions are averaged (regression) or majority-voted (classification).

**Bootstrap sample:** sample $n$ points from the training set **with replacement**. Each sample contains $\approx 63.2\%$ unique points; the remaining $\approx 36.8\%$ are out-of-bag (OOB).

**OOB error:** each sample is OOB for $\approx 1/3$ of trees. Average OOB predictions give a free validation error estimate without a separate val set.

**Variance reduction:** averaging over $M$ models reduces variance by a factor of $M$ (for independent models) or $\rho + (1-\rho)/M$ for correlated ones.

**Bias:** unchanged from individual models.

### Random Forests

Bagging + random feature subspace at each split.

**Key modifications:**
- Each tree is grown on a bootstrap sample.
- At each split, only $m$ randomly chosen features are considered ($m \approx \sqrt{d}$ for classification, $m \approx d/3$ for regression).
- Trees are grown to maximum depth (low bias, high variance; variance reduced by averaging).

**Feature importance:**

- **Impurity-based (Gini importance):** mean decrease in impurity across all splits using that feature. Fast but biased toward high-cardinality features.
- **Permutation importance:** measure decrease in OOB accuracy when a feature's values are randomly permuted. Model-agnostic and unbiased.

## Boosting

Boosting trains base learners **sequentially**, each correcting the errors of the previous ensemble. Reduces bias; can also reduce variance.

### AdaBoost

Maintains a distribution $D_t$ over training samples. Misclassified samples get higher weight in the next round.

For weak learners $h_t$ with weighted error $\epsilon_t$:

$$\alpha_t = \frac{1}{2} \ln\frac{1 - \epsilon_t}{\epsilon_t}$$

Update weights:

$$D_{t+1}(i) \propto D_t(i) \exp(-\alpha_t y_i h_t(x_i))$$

Final prediction:

$$F(x) = \text{sign}\!\left(\sum_{t=1}^T \alpha_t h_t(x)\right)$$

**Training error bound:** $\text{err}_{\text{train}} \leq \exp\!\left(-2\sum_{t=1}^T \gamma_t^2\right)$ where $\gamma_t = 0.5 - \epsilon_t$ is the edge over random.

### Gradient Boosting

Generalizes boosting to arbitrary differentiable loss functions. Each new model fits the **pseudo-residuals** (negative gradient of the loss with respect to current predictions).

At step $m$:

1. Compute pseudo-residuals: $r_i^{(m)} = -\frac{\partial \mathcal{L}(y_i, F_{m-1}(x_i))}{\partial F_{m-1}(x_i)}$

2. Fit a base learner $h_m$ to $\{(x_i, r_i^{(m)})\}$.

3. Update: $F_m(x) = F_{m-1}(x) + \nu \cdot h_m(x)$, where $\nu$ is the learning rate (shrinkage).

For squared loss: $r_i^{(m)} = y_i - F_{m-1}(x_i)$. Reduces to fitting residuals.

### XGBoost

Extreme Gradient Boosting. Adds second-order Taylor expansion to the loss, L1/L2 regularization on leaf weights, and column subsampling. Objective at step $m$:

$$\mathcal{L}^{(m)} \approx \sum_{i=1}^n [g_i f_m(x_i) + \frac{1}{2} h_i f_m^2(x_i)] + \Omega(f_m)$$

where $g_i = \partial_{F} \mathcal{L}(y_i, F)$, $h_i = \partial^2_{F} \mathcal{L}(y_i, F)$, and $\Omega(f) = \gamma T + \frac{1}{2}\lambda \|w\|^2$.

**Optimal leaf weight:** $w_j^* = -\frac{\sum_{i \in I_j} g_i}{\sum_{i \in I_j} h_i + \lambda}$

### LightGBM

Gradient boosting with:
- **Gradient-based One-Side Sampling (GOSS):** keeps samples with large gradients; randomly samples those with small gradients. Reduces data without losing information from hard examples.
- **Exclusive Feature Bundling (EFB):** bundles mutually exclusive sparse features to reduce dimensionality.
- **Leaf-wise growth:** grows the leaf with the largest loss reduction, rather than level-wise. More accurate but can overfit on small datasets.

### CatBoost

Handles categorical features natively via ordered target statistics; avoids target leakage using permutation-based encoding. Ordered boosting reduces overfitting. Strong default performance without extensive tuning.

## Stacking (Stacked Generalization)

Trains a **meta-learner** on the out-of-fold predictions of base learners.

**Procedure:**
1. Split training data into $k$ folds.
2. Train each base model $M_j$ on $k-1$ folds; generate predictions on held-out fold. Collect OOF predictions as new features.
3. Train meta-learner on the OOF predictions as inputs, with original labels.
4. For inference: predict with each base model; feed predictions to meta-learner.

**Meta-learner:** typically a simple model (logistic regression, linear regression, light GBM) to avoid overfitting.

## Voting and Averaging

**Hard voting:** majority class label across classifiers.

**Soft voting:** average predicted probabilities; class with highest average wins. Generally superior to hard voting when classifiers are calibrated.

**Weighted averaging:** $\hat{y} = \sum_m w_m \hat{y}_m$, weights learned on validation or by optimization.

## Comparison

| Method | Bias | Variance | Sequential | Comments |
|--------|------|---------|-----------|---------|
| Bagging | Same | Lower | No | Easy to parallelize |
| Random Forest | Slightly higher | Much lower | No | Best single-model alternative |
| AdaBoost | Lower | Varies | Yes | Sensitive to noise/outliers |
| Gradient Boosting | Lower | Varies | Yes | Highly accurate; needs tuning |
| XGBoost / LightGBM | Lower | Varies | Yes | State of the art on tabular data |
| Stacking | Lower | Lower | No | Powerful; complex pipeline |

## Practical Considerations

- Random Forest and gradient boosting (XGBoost, LightGBM) are the dominant choices for tabular data.
- Gradient boosting benefits more from hyperparameter tuning than Random Forest.
- Stacking and blending often provide 0.5-2% improvement over single best model in competitions.
- Diverse base learners (different algorithms, feature sets, data subsets) improve ensemble quality more than duplicating the same model.
