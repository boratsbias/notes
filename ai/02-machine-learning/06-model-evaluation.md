# Model Evaluation

## Core Idea

Model evaluation measures how well a learned model generalizes to unseen data. It guides model selection, debugging, and deployment decisions. The choice of metric must align with the real-world cost structure of errors.

## Train / Validation / Test Split

- **Training set:** used to fit model parameters.
- **Validation set:** used for hyperparameter tuning and model selection.
- **Test set:** used once, at the end, for unbiased estimation of generalization performance.

Contaminating the test set (using it to guide any decisions) leads to optimistic evaluation. Typical splits: 60/20/20 or 70/15/15.

## Classification Metrics

### Confusion Matrix

For binary classification with predicted label $\hat{y}$ and true label $y$:

|  | Predicted Positive | Predicted Negative |
|--|-------------------|--------------------|
| **Actual Positive** | TP | FN |
| **Actual Negative** | FP | TN |

Derived metrics:

$$\text{Accuracy} = \frac{TP + TN}{TP + FP + TN + FN}$$

$$\text{Precision} = \frac{TP}{TP + FP}$$

$$\text{Recall (Sensitivity)} = \frac{TP}{TP + FN}$$

$$\text{Specificity} = \frac{TN}{TN + FP}$$

$$\text{F1} = \frac{2 \cdot \text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}} = \frac{2 \cdot TP}{2 \cdot TP + FP + FN}$$

$$F_\beta = (1 + \beta^2) \cdot \frac{\text{Precision} \cdot \text{Recall}}{\beta^2 \cdot \text{Precision} + \text{Recall}}$$

$\beta > 1$ weights recall higher; $\beta < 1$ weights precision higher.

### ROC Curve and AUC

Plot True Positive Rate (Recall) vs. False Positive Rate ($\frac{FP}{FP + TN}$) across all classification thresholds.

**AUC-ROC:** area under the ROC curve. Ranges $[0, 1]$; 0.5 is random; 1.0 is perfect. Threshold-independent measure of discriminative ability.

**Interpretation:** AUC = probability that the model ranks a random positive example higher than a random negative example.

**AUC-PR (Precision-Recall curve):** preferred for class-imbalanced problems. AUC-ROC is overly optimistic when negatives greatly outnumber positives.

### Multi-class Metrics

Extend binary metrics by averaging:

| Averaging | How |
|-----------|-----|
| Macro | Compute metric per class, take unweighted mean |
| Weighted | Compute per class, weight by class support |
| Micro | Aggregate TP, FP, FN across all classes, then compute |

### Matthews Correlation Coefficient (MCC)

$$\text{MCC} = \frac{TP \cdot TN - FP \cdot FN}{\sqrt{(TP+FP)(TP+FN)(TN+FP)(TN+FN)}}$$

Reliable single metric even with class imbalance. Ranges $[-1, 1]$.

## Regression Metrics

| Metric | Formula | Notes |
|--------|---------|-------|
| MSE | $\frac{1}{n}\sum(y_i - \hat{y}_i)^2$ | Penalizes large errors heavily |
| RMSE | $\sqrt{\text{MSE}}$ | Same units as target |
| MAE | $\frac{1}{n}\sum\|y_i - \hat{y}_i\|$ | Robust to outliers |
| MAPE | $\frac{100}{n}\sum\frac{\|y_i - \hat{y}_i\|}{y_i}$ | Scale-free; undefined if $y_i = 0$ |
| $R^2$ | $1 - \frac{\sum(y_i - \hat{y}_i)^2}{\sum(y_i - \bar{y})^2}$ | Fraction of variance explained; $\leq 1$ |
| Adjusted $R^2$ | $1 - (1 - R^2)\frac{n-1}{n-p-1}$ | Penalizes extra features |

## Ranking Metrics

Used in information retrieval and recommendation.

**Precision@k:** fraction of top-$k$ recommendations that are relevant.

**Mean Average Precision (MAP):**

$$\text{MAP} = \frac{1}{Q} \sum_{q=1}^Q \text{AP}(q), \quad \text{AP}(q) = \frac{1}{R_q}\sum_{k=1}^{n} P(k) \cdot \mathbf{1}[\text{item}_k \text{ is relevant}]$$

**NDCG@k (Normalized Discounted Cumulative Gain):**

$$\text{DCG@k} = \sum_{i=1}^k \frac{2^{r_i} - 1}{\log_2(i+1)}, \quad \text{NDCG@k} = \frac{\text{DCG@k}}{\text{IDCG@k}}$$

where $r_i$ is the relevance score of item at position $i$.

## Calibration

A well-calibrated model's predicted probability $\hat{p}$ matches the empirical frequency of the positive class.

**Reliability diagram (calibration curve):** plot mean predicted probability vs. fraction of positives in each probability bin. Perfect calibration lies on the diagonal.

**Expected Calibration Error (ECE):**

$$\text{ECE} = \sum_{m=1}^M \frac{|B_m|}{n} |\text{acc}(B_m) - \text{conf}(B_m)|$$

**Brier score:** $\frac{1}{n}\sum(\hat{p}_i - y_i)^2$. Combines calibration and discrimination.

**Calibration methods:** Platt scaling (logistic regression on outputs), isotonic regression, temperature scaling.

## Choosing the Right Metric

| Scenario | Recommended Metric |
|---------|-------------------|
| Balanced classes | Accuracy, F1 |
| Imbalanced classes | AUC-PR, F1 (weighted), MCC |
| False positives costly (spam filter) | Precision |
| False negatives costly (cancer screening) | Recall |
| Probabilistic outputs | AUC-ROC, Brier score, log-loss |
| Regression with outliers | MAE, Huber loss |
| Ordinal/rank predictions | NDCG, Spearman correlation |

## Diagnostic Tools

**Learning curves:** plot train and validation loss as a function of training set size. Reveals underfitting (both losses high) vs. overfitting (train loss low, validation loss high).

**Residual analysis:** for regression, plot residuals $e_i = y_i - \hat{y}_i$ vs. $\hat{y}_i$ or vs. input features. Non-random patterns indicate model misspecification.

**Confusion matrix heatmap:** reveals systematic class confusions.

**Error analysis:** manually inspect misclassified examples to identify patterns.

See [Cross Validation](08-cross-validation) for unbiased metric estimation and [Bias Variance Tradeoff](07-bias-variance-tradeoff) for interpreting train vs. test error.
