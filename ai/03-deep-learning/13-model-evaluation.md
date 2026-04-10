# Model Evaluation (Deep Learning)

## How do we evaluate Deep Learning models?

Evaluating deep learning models requires the same statistical rigor as classical ML but adds concerns specific to neural networks: training curves, generalization gaps, calibration, and the gap between benchmark performance and real-world behavior.

For standard evaluation metrics (accuracy, AUC, F1, RMSE, etc.) see [Model Evaluation](../../02-machine-learning/06-model-evaluation).

## Training and Validation Curves

Plot loss and metrics as a function of training steps or epochs.

**Healthy training:**
- Training loss decreases smoothly.
- Validation loss follows training loss closely.
- Both plateau at a low value.

**Overfitting:**
- Training loss continues to decrease.
- Validation loss flattens or increases.
- Gap between train and val grows over time.

**Underfitting:**
- Both training and validation losses are high and plateau early.
- Model lacks capacity or is undertrained.

**Unstable training:**
- Loss oscillates or spikes.
- Causes: learning rate too high, exploding gradients, bad batches.

## Generalization Gap

$$\text{Gap} = \mathcal{J}_\text{val}(\theta^*) - \mathcal{J}_\text{train}(\theta^*)$$

A large gap indicates overfitting; a small gap on a high loss indicates underfitting.

**Modern observation:** overparameterized networks (many more parameters than training examples) can achieve near-zero training loss and still generalize well. Classical bias-variance intuition (more parameters $\Rightarrow$ more overfit) does not always hold. See double descent in [Bias Variance Tradeoff](../../02-machine-learning/07-bias-variance-tradeoff).

## Checkpointing and Early Stopping

Save model weights at the epoch with the best validation metric (**checkpoint**). Use these weights for final evaluation.

Early stopping: stop training if validation loss does not improve for $p$ patience epochs. Restoring the best checkpoint is equivalent to early stopping.

## Per-Class and Disaggregated Evaluation

Aggregate metrics (overall accuracy) can hide poor performance on subgroups:

- Compute precision, recall, and F1 per class. Identify which classes are hardest.
- Slice evaluation: compute metrics separately for each data slice (age group, geography, device type).
- **Slice-based testing:** a model with 95% accuracy might have 60% accuracy on a minority class.

## Confusion Matrix Analysis

Visualize as a heatmap (rows = true classes, columns = predicted classes). Systematic off-diagonal patterns reveal class confusions. For a 10-class problem, a $10 \times 10$ matrix shows which classes are confused with each other.

## Calibration

Well-calibrated models' predicted probabilities match empirical frequencies. Critical for risk-sensitive applications.

**Temperature scaling:** post-hoc calibration by learning a scalar $T > 0$:

$$\hat{p} = \text{softmax}(\mathbf{z} / T)$$

$T > 1$: softens (more uncertain); $T < 1$: sharpens. Optimal $T$ found on a held-out validation set.

**Expected Calibration Error (ECE):** see [Model Evaluation](../../02-machine-learning/06-model-evaluation).

Deep neural networks are typically overconfident (output high-probability predictions even when wrong). Temperature scaling, label smoothing, and mixup improve calibration.

## Robustness Evaluation

Measure performance under distribution shift:

| Evaluation Type | What It Tests |
|----------------|--------------|
| In-distribution (i.i.d.) test set | Standard generalization |
| Out-of-distribution (OOD) | Shift in $P(X)$ (new domains, corruptions) |
| Adversarial examples | Worst-case small perturbations |
| Corrupted inputs | Blur, noise, JPEG artifacts (ImageNet-C) |
| Subgroup evaluation | Minority classes, rare conditions |

**Confidence under distribution shift:** a model should output low confidence (high entropy) for OOD inputs, not high-confidence wrong predictions.

## Benchmark Evaluation

Standard benchmarks provide reproducible comparison points:

| Domain | Benchmark | Metric |
|--------|-----------|--------|
| Image classification | ImageNet-1k | Top-1, Top-5 accuracy |
| Object detection | COCO | mAP@50, mAP@50:95 |
| Language modeling | Penn Treebank, The Pile | Perplexity |
| NLU | GLUE, SuperGLUE | Average score |
| Question answering | SQuAD 2.0 | EM, F1 |
| MT | WMT | BLEU, ChrF |

**Caveat:** overfitting to benchmarks (evaluation set leakage, benchmark saturation) can give a misleadingly optimistic picture. Always evaluate on held-out data from the target distribution.

## Loss vs. Metric

The training loss (cross-entropy, MSE) and the evaluation metric (accuracy, AUROC) often differ. Do not confuse them:
- A model can have low cross-entropy but mediocre accuracy (miscalibrated confidences).
- Monitor both training loss and downstream metric throughout training.

## Hyperparameter Sensitivity Analysis

After finding the best configuration, measure how sensitive results are to hyperparameter changes:
- Sweep $\pm 1$ order of magnitude on learning rate, weight decay.
- Report mean $\pm$ std over multiple random seeds.
- A model whose performance varies $>2\%$ across seeds or minor hyperparameter changes should be treated with caution.

## Practical Checklist

- Train/val/test split is clean; no leakage.
- Evaluation metric matches the real-world objective.
- Report results on the **test set** used only once.
- Report mean and standard deviation over at least 3 random seeds.
- Analyze failure modes and per-class performance.
- Check calibration if model outputs are used as probabilities.
- Evaluate robustness to expected distribution shifts.
