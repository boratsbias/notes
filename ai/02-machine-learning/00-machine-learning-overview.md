# Machine Learning Overview

## Core Idea

Machine learning studies algorithms that improve performance on a task by learning patterns from data instead of relying only on hand-written rules.

## Basic Setup

- **Input features:** $\mathbf{x}$
- **Target:** $y$
- **Model:** $f_\theta(\mathbf{x})$
- **Parameters:** $\theta$
- **Loss function:** $\mathcal{L}(f_\theta(\mathbf{x}), y)$

Training aims to find parameters that minimize average loss on the training set:

$$\theta^* = \arg\min_\theta \frac{1}{n}\sum_{i=1}^n \mathcal{L}(f_\theta(\mathbf{x}_i), y_i)$$

## Main Learning Paradigms

### Supervised Learning

Learn from labeled pairs $(\mathbf{x}, y)$.

- Tasks: classification, regression
- Examples: spam detection, house price prediction

### Unsupervised Learning

Learn structure from unlabeled data $\mathbf{x}$ only.

- Tasks: clustering, dimensionality reduction, density estimation
- Examples: customer segmentation, anomaly detection

### Semi Supervised Learning

Use a small labeled set with a large unlabeled set.

- Useful when labels are expensive but raw data is abundant

### Self Supervised Learning

Create supervision from the data itself.

- Predict masked tokens, missing image patches, next steps in sequences

## Generalization

The goal is not only to fit training data but to perform well on unseen examples.

- **Training error:** error on seen data
- **Test error:** error on new data
- **Generalization gap:** difference between test and training performance

## Bias and Variance

### High Bias

- Model is too simple
- Underfits the data
- Both training and test error are high

### High Variance

- Model is too flexible
- Overfits the training set
- Training error is low but test error is high

## Common Workflow

1. Define the task and metric
2. Collect and clean data
3. Split into train, validation, and test sets
4. Choose features and model family
5. Train and tune hyperparameters
6. Evaluate on held-out data
7. Deploy and monitor

## Model Families

| Family | Typical Tasks | Strength |
|--------|---------------|----------|
| Linear models | Regression, classification | Simple and interpretable |
| Decision trees | Classification, regression | Handles nonlinear rules |
| Kernel methods | Classification, regression | Strong with structured margins |
| Neural networks | Vision, language, audio | Flexible high-capacity models |
| Probabilistic models | Density estimation, uncertainty | Explicit probabilistic structure |

## Evaluation Metrics

### Classification

- Accuracy
- Precision
- Recall
- F1 score
- ROC-AUC

### Regression

- Mean squared error
- Mean absolute error
- $R^2$

## Regularization

Regularization reduces overfitting by controlling model complexity.

- L1 penalty encourages sparsity
- L2 penalty shrinks parameters
- Early stopping prevents excessive fitting
- Data augmentation increases effective dataset size

## Common Failure Modes

- Data leakage
- Distribution shift
- Class imbalance
- Noisy labels
- Spurious correlations

## Why ML Works

Machine learning works when:

- the task contains repeatable patterns
- the training data is representative
- the model class can express the relevant structure
- optimization finds parameters with good generalization
