# Machine Learning Overview

## Core Idea

Machine learning studies algorithms that learn patterns from data in order to make predictions, decisions, or representations.

Instead of writing explicit rules for every case, we choose a model family and let data determine the parameters.

## Basic Setup

We usually work with:

- input features $\mathbf{x}$
- target variable $y$
- model $f_\theta(\mathbf{x})$
- parameters $\theta$
- loss function $\mathcal{L}(f_\theta(\mathbf{x}), y)$

Training means solving:

$$\theta^* = \arg\min_\theta \frac{1}{n}\sum_{i=1}^n \mathcal{L}(f_\theta(\mathbf{x}_i), y_i)$$

## Main Goals

Machine learning is used for:

- classification
- regression
- clustering
- ranking
- anomaly detection
- representation learning

## Training, Validation, and Test Data

- **Training set:** used to fit parameters
- **Validation set:** used to tune decisions such as model size or regularization
- **Test set:** used once for final evaluation

This separation helps estimate how well a model will generalize to unseen data.

## Generalization

The main objective is not to memorize the training set but to perform well on new examples from the same distribution.

- low training error alone is not enough
- good models balance fit and simplicity
- noisy or biased data can still produce poor generalization

## Common Model Families

- linear models
- decision trees
- kernel methods
- probabilistic models
- neural networks
- nearest neighbor methods

Each family makes different assumptions about the data and has different tradeoffs in interpretability, flexibility, and computational cost.

## Typical Workflow

1. define the prediction task
2. collect and clean data
3. choose features and model family
4. train the model
5. evaluate on held out data
6. tune and iterate
7. deploy and monitor

## Major Challenges

- underfitting
- overfitting
- data leakage
- class imbalance
- distribution shift
- missing or noisy labels

## Why It Works

Machine learning works when:

- the data contains stable patterns
- the model class can express those patterns
- optimization can find useful parameters
- evaluation reflects the real task
