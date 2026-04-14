# ML Evaluation Systems

ML evaluation systems measure model quality systematically, before and after deployment. Rigorous evaluation prevents deploying models that underperform or cause harm on real-world data.

## Offline vs. Online Evaluation

**Offline evaluation:** evaluate the model on a held-out dataset before deployment. Fast; cheap; controlled. May not reflect production distribution.

**Online evaluation:** measure the model's impact on real users in production. A/B testing, shadow deployment. Slower; more expensive; reflects reality.

Both are necessary. Offline evaluation gates deployment; online evaluation measures real impact.

## Evaluation Metrics

### Classification

**Accuracy:** $\frac{TP + TN}{N}$. Misleading for imbalanced classes.

**Precision:** $\frac{TP}{TP + FP}$. Fraction of positive predictions that are correct.

**Recall (Sensitivity):** $\frac{TP}{TP + FN}$. Fraction of actual positives detected.

**F1:** $\frac{2 \cdot P \cdot R}{P + R}$. Harmonic mean of precision and recall. Good for imbalanced datasets.

**ROC-AUC:** area under the ROC curve. Threshold-independent; measures ranking quality. Good for imbalanced binary classification.

**PR-AUC (Average Precision):** area under precision-recall curve. Better than ROC-AUC when positives are rare.

### Regression

**MAE:** $\frac{1}{n}\sum \lvert y_i - \hat{y}_i \rvert$. Robust to outliers.

**RMSE:** $\sqrt{\frac{1}{n}\sum (y_i - \hat{y}_i)^2}$. Penalizes large errors more.

**MAPE:** $\frac{1}{n}\sum \lvert\frac{y_i - \hat{y}_i}{y_i}\rvert \times 100\%$. Percentage error; undefined when $y_i = 0$.

**$R^2$ (coefficient of determination):** fraction of variance explained.

### Ranking

**NDCG (Normalized Discounted Cumulative Gain):**

$$\text{NDCG@k} = \frac{\text{DCG@k}}{\text{IDCG@k}}, \quad \text{DCG@k} = \sum_{i=1}^k \frac{2^{rel_i} - 1}{\log_2(i+1)}$$

**MRR:** mean reciprocal rank of the first relevant result.

**MAP (Mean Average Precision):** mean of per-query average precision.

## Sliced Evaluation

Evaluate performance on specific subpopulations or scenarios.

**Slices:** gender, age group, geography, device type, input length, confidence bucket.

**Why slice?** A model with 90% overall accuracy may have 70% accuracy on minority groups. Sliced evaluation surfaces disparate impacts.

**Error analysis workflow:**
1. Identify the worst-performing slices.
2. Inspect misclassified examples.
3. Hypothesize the failure mode.
4. Collect more data or add features to address it.

## Calibration

A well-calibrated model's confidence scores match empirical frequencies.

**Expected Calibration Error (ECE):**

$$\text{ECE} = \sum_{m=1}^M \frac{|B_m|}{n} |\text{acc}(B_m) - \text{conf}(B_m)|$$

Partition predictions into $M$ bins by confidence; compute the gap between average confidence and average accuracy per bin.

**Reliability diagram:** plot accuracy vs. confidence. A calibrated model falls on the diagonal.

**Temperature scaling:** post-hoc calibration. Divide logits by a scalar $T$: $p = \text{softmax}(z/T)$. Fit $T$ on a validation set to minimize NLL. Simple; effective.

## Behavioral Testing (Beyond Metrics)

**CheckList (Ribeiro et al. 2020):** test NLP models with minimum functionality tests (MFT), invariance tests (INV), and directional expectation tests (DIR).

- **MFT:** the model should output "positive" for "This movie was great."
- **INV:** adding "This review was written in Paris." should not change a sentiment prediction.
- **DIR:** replacing "good" with "bad" should flip the sentiment.

Behavioral tests catch specific failure modes not visible in aggregate metrics.

## Human Evaluation

For generative models, automated metrics (BLEU, ROUGE, FID) often correlate poorly with human judgment.

**Side-by-side comparison:** show annotators two responses; ask which is better. Compute win rate.

**Likert scales:** annotators rate responses on a 5-point scale (quality, fluency, factuality).

**Chatbot Arena:** crowdsourced pairwise comparisons; compute ELO ratings. Community-based evaluation for LLMs.

## Evaluation in Production

**Holdout-based A/B testing:** randomly assign users to control (old model) and treatment (new model) groups; measure business metrics (click-through rate, conversion, session length).

**Minimum detectable effect (MDE):** the smallest improvement the A/B test is powered to detect. Requires sample size calculation before launching the test.

$$n \approx \frac{2(z_{\alpha/2} + z_\beta)^2 \sigma^2}{\delta^2}$$

**Multi-armed bandit:** dynamically reallocate traffic to the better-performing variant as evidence accumulates. More efficient than fixed A/B tests; faster convergence.

**Evaluation debt:** models in production that have never been carefully evaluated on relevant slices, edge cases, or fairness criteria. Accumulates when teams ship without rigorous evaluation.
