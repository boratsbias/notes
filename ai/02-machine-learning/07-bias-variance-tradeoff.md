# Bias Variance Tradeoff

## Core Idea

Prediction error often comes from two major sources:

- **bias:** error from overly simple assumptions
- **variance:** error from sensitivity to the training data

A strong model balances both.

## Bias

High bias means the model is too rigid to capture the true pattern.

Symptoms:

- high training error
- high validation error
- underfitting

Examples:

- fitting a straight line to a strongly nonlinear pattern
- using too much regularization

## Variance

High variance means the model reacts too strongly to the specific training sample.

Symptoms:

- low training error
- high validation error
- overfitting

Examples:

- very deep tree with little data
- very flexible model without regularization

## Error Decomposition

For squared loss, expected prediction error can be decomposed conceptually into:

$$\text{Error} = \text{Bias}^2 + \text{Variance} + \text{Irreducible noise}$$

The last term comes from randomness or noise in the data generating process and cannot be removed completely.

## Model Complexity

As model complexity increases:

- bias usually decreases
- variance usually increases

This is why a model that is too simple or too complex can both perform poorly.

## Ways to Reduce Bias

- use a more expressive model
- add better features
- reduce excessive regularization
- train longer when optimization is incomplete

## Ways to Reduce Variance

- collect more data
- use regularization
- simplify the model
- use ensembling
- apply data augmentation

## Practical Use

The tradeoff guides:

- model selection
- regularization strength
- early stopping
- feature design

It is one of the most important ideas in machine learning because it explains why training accuracy and test accuracy can move differently.
