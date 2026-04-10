# Model Evaluation

## Core Idea

Model evaluation measures how well a model performs on data that was not used to fit its parameters.

Without proper evaluation, high training performance can be misleading.

## General Principle

A model should be evaluated on held out data sampled in a way that matches the real use case.

This helps estimate generalization rather than memorization.

## Classification Metrics

### Accuracy

$$\text{Accuracy} = \frac{\text{Number of correct predictions}}{\text{Total predictions}}$$

Useful when classes are balanced.

### Precision

$$\text{Precision} = \frac{TP}{TP + FP}$$

Measures how many predicted positives are actually positive.

### Recall

$$\text{Recall} = \frac{TP}{TP + FN}$$

Measures how many true positives are recovered.

### F1 Score

$$F_1 = \frac{2PR}{P + R}$$

Useful when balancing precision and recall.

### ROC-AUC

Measures ranking quality across thresholds.

## Regression Metrics

### Mean Squared Error

$$\text{MSE} = \frac{1}{n}\sum_{i=1}^n (\hat{y}_i - y_i)^2$$

### Mean Absolute Error

$$\text{MAE} = \frac{1}{n}\sum_{i=1}^n |\hat{y}_i - y_i|$$

### Coefficient of Determination

$$R^2 = 1 - \frac{\sum_i (y_i - \hat{y}_i)^2}{\sum_i (y_i - \bar{y})^2}$$

## Calibration

A model can have good ranking accuracy but poor probability estimates.

Calibration asks whether predicted probabilities match actual frequencies.

## Threshold Choice

For many classifiers, the final decision depends on a threshold.

The best threshold depends on:

- false positive cost
- false negative cost
- business or scientific constraints

## Common Pitfalls

- evaluating on training data
- tuning on the test set
- ignoring class imbalance
- using a metric that does not match the real objective
- hidden data leakage

## Beyond a Single Number

Good evaluation often includes:

- overall metric
- per-class performance
- error analysis
- slice-based evaluation
- robustness checks
