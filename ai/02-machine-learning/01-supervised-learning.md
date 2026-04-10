# Supervised Learning

## Core Idea

Supervised learning uses labeled examples $(\mathbf{x}, y)$ to learn a mapping from inputs to targets.

The model sees the correct answer during training and adjusts its parameters to reduce prediction error.

## Main Types

### Classification

Predict a discrete label.

Examples:

- spam or not spam
- disease present or absent
- image category

### Regression

Predict a continuous value.

Examples:

- house price
- temperature
- demand forecast

## Objective

Given training examples $\{(\mathbf{x}_i, y_i)\}_{i=1}^n$, learn a function $f_\theta$ that minimizes prediction loss:

$$\theta^* = \arg\min_\theta \sum_{i=1}^n \mathcal{L}(f_\theta(\mathbf{x}_i), y_i)$$

## Common Loss Functions

### Regression Losses

- mean squared error

$$\text{MSE} = \frac{1}{n}\sum_{i=1}^n (\hat{y}_i - y_i)^2$$

- mean absolute error

$$\text{MAE} = \frac{1}{n}\sum_{i=1}^n |\hat{y}_i - y_i|$$

### Classification Losses

- binary cross-entropy
- multiclass cross-entropy
- hinge loss

For multiclass prediction with true label distribution $y$ and predicted probabilities $\hat{y}$:

$$\mathcal{L} = -\sum_k y_k \log \hat{y}_k$$

## Common Algorithms

- linear regression
- logistic regression
- decision trees
- random forests
- support vector machines
- neural networks
- gradient boosted trees

## Assumptions

Supervised learning assumes:

- labels are available and reasonably correct
- train and test data come from similar distributions
- the chosen features contain predictive information

## Challenges

- limited labeled data
- noisy annotations
- class imbalance
- spurious correlations
- dataset shift

## Evaluation

Evaluation depends on the task:

- accuracy, precision, recall, F1 for classification
- MSE, MAE, $R^2$ for regression

The best metric is the one closest to the real decision objective.
