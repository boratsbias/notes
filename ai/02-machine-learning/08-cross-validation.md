# Cross Validation

Cross validation (CV) is a resampling technique that estimates a model's generalization performance by repeatedly training on subsets of the data and evaluating on the held-out portion. It provides a more reliable estimate than a single train/test split, especially when data is limited.

## Why CV Is Needed

A single train/test split has high variance: the evaluation metric can vary substantially depending on which samples land in the test set. CV averages over multiple splits to reduce this variance and obtain a more stable estimate.

## k-Fold Cross Validation

The standard method.

**Procedure:**
1. Partition the dataset into $k$ equal (or near-equal) folds.
2. For each fold $i = 1, \ldots, k$:
   - Train on folds $\{1, \ldots, k\} \setminus \{i\}$.
   - Evaluate on fold $i$, recording metric $m_i$.
3. Report mean and standard error:

$$\hat{m} = \frac{1}{k}\sum_{i=1}^k m_i, \quad \text{SE} = \frac{\text{std}(m_1, \ldots, m_k)}{\sqrt{k}}$$

**Typical values of $k$:** 5 or 10. Higher $k$ reduces bias (more training data per fold) but increases variance and computation.

## Leave-One-Out Cross Validation (LOOCV)

Special case of $k$-fold where $k = n$: each fold contains exactly one sample.

**Advantages:**
- Almost unbiased estimate of true generalization error.
- Deterministic (no randomness in splits).

**Disadvantages:**
- Computationally expensive: $n$ model fits.
- High variance estimate: each training set is nearly identical.
- For least-squares regression, LOOCV has a closed-form via the hat matrix: $\text{CV} = \frac{1}{n}\sum_{i=1}^n \left(\frac{y_i - \hat{y}_i}{1 - H_{ii}}\right)^2$ where $H = X(X^TX)^{-1}X^T$.

## Stratified k-Fold

For classification: ensures each fold contains approximately the same proportion of each class as the full dataset.

Critical for imbalanced datasets where random splits could produce folds with no examples of a minority class.

## Repeated k-Fold

Repeat $k$-fold CV multiple times with different random splits. Averages over both fold assignments, reducing variance of the CV estimate.

## Time Series CV (Walk-Forward Validation)

Standard k-fold violates temporal ordering (future data used to predict past). Use a **rolling window** or **expanding window** strategy instead.

**Expanding window:**
- Training set grows with each split.
- Fold 1: train on $[1, t_1]$, validate on $[t_1+1, t_2]$.
- Fold 2: train on $[1, t_2]$, validate on $[t_2+1, t_3]$.
- Realistic simulation of deployment.

**Sliding window:**
- Training window is fixed size; both train and validation windows slide forward.
- Useful when older data is less relevant (concept drift).

## Nested Cross Validation

Used when hyperparameter tuning is performed inside CV, to avoid optimistic bias from selecting hyperparameters on the same data used to estimate performance.

**Structure:**
- **Outer loop:** $k_\text{out}$ folds for unbiased performance estimation.
- **Inner loop:** $k_\text{in}$ folds for hyperparameter selection on each outer training set.

Total model fits: $k_\text{out} \times k_\text{in} \times |\text{hyperparameter configs}|$.

Computationally expensive but statistically correct.

## CV for Model Selection vs. Performance Estimation

| Goal | Approach |
|------|---------|
| Select best model / hyperparameters | Use CV score on training data to rank configurations |
| Estimate generalization of final model | Fit final model on all training data; evaluate on held-out test set |
| Both (no separate test set) | Nested CV |

**Key rule:** never use the test set to guide any model choices. Reserve it strictly for the final evaluation.

## Bias-Variance of CV Estimators

| Method | Bias | Variance | Cost |
|--------|------|---------|------|
| Hold-out (single split) | High | High | Low |
| 5-fold CV | Medium | Medium | $5\times$ |
| 10-fold CV | Low | Lower | $10\times$ |
| LOOCV | Very low | High | $n\times$ |
| Repeated 10-fold | Low | Very low | $r \cdot 10\times$ |

## Practical Considerations

- **Shuffle before splitting** (unless time series): random ordering prevents fold bias from data collection order.
- **Group-aware CV:** if samples are not independent (e.g., multiple images from the same patient), use `GroupKFold` to ensure all samples from a group are in the same fold.
- **Computational budget:** for expensive models, use 5-fold or 3-fold with repeated runs rather than 10-fold.
- **Metric choice:** report CV mean, standard deviation, and the metric appropriate for the task. See [Model Evaluation](06-model-evaluation).
- **Final model:** after CV-based model selection, refit on the entire training set using the selected configuration.

## CV and the Bootstrap

An alternative to k-fold: sample with replacement $B$ times, train on bootstrap sample, test on out-of-bag (OOB) samples not selected.

**OOB estimate:** approximately $1 - (1 - 1/n)^n \approx 0.632$ of data per bootstrap sample. The 0.632+ bootstrap estimator corrects the pessimistic bias:

$$\hat{\text{err}}_{0.632+} = 0.368 \cdot \hat{\text{err}}_{\text{train}} + 0.632 \cdot \hat{\text{err}}_{\text{OOB}}$$

Used internally in Random Forests for feature importance and error estimation.
