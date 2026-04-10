# Cross Validation

## Core Idea

Cross validation estimates model performance by repeatedly splitting the dataset into training and validation parts.

It uses the data more efficiently than a single train-validation split.

## K-Fold Cross Validation

In $k$-fold cross validation:

1. split the data into $k$ folds
2. train on $k-1$ folds
3. evaluate on the remaining fold
4. repeat so each fold is used once as validation
5. average the scores

If the fold scores are $s_1, s_2, \ldots, s_k$, then:

$$\bar{s} = \frac{1}{k}\sum_{i=1}^k s_i$$

## Why It Helps

- reduces dependence on a single split
- gives a more stable estimate
- helps compare models and hyperparameters

## Common Variants

### Stratified K-Fold

Preserves label proportions across folds. This is important for imbalanced classification.

### Leave-One-Out Cross Validation

Uses one example as validation and the rest as training.

- low bias
- high computational cost
- often high variance

### Time Series Validation

For temporal data, future observations must not leak into the past.

Typical approach:

- train on earlier time periods
- validate on later time periods

## Nested Cross Validation

Used when hyperparameter tuning is part of the evaluation process.

- inner loop selects hyperparameters
- outer loop estimates final performance

This prevents optimistic bias from tuning on the same validation folds used for reporting.

## Limitations

- computationally expensive for large models
- can still be misleading if data leakage exists
- standard random folds are not appropriate for grouped or time-dependent data

## Best Use

Cross validation is especially useful when datasets are modest in size and model selection decisions matter.
