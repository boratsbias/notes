# Ensemble Learning

## Core Idea

Ensemble learning combines multiple models to produce a stronger overall predictor.

The main idea is that different models make different errors, and combining them can reduce variance, bias, or both.

## Basic Principle

If models are diverse and individually useful, aggregation can improve robustness and accuracy.

For regression, a simple ensemble may average predictions:

$$\hat{y} = \frac{1}{M}\sum_{m=1}^M \hat{y}^{(m)}$$

For classification, it may use majority vote or average class probabilities.

## Bagging

Bagging trains models on bootstrap samples of the data and averages their outputs.

Benefits:

- reduces variance
- works well for unstable base learners such as decision trees

### Random Forest

Random forests add feature subsampling to bagging of trees.

This decorrelates trees and usually improves performance.

## Boosting

Boosting builds models sequentially so later models focus more on earlier errors.

Examples:

- AdaBoost
- Gradient Boosting
- XGBoost
- LightGBM

Boosting often achieves strong tabular performance.

## Stacking

Stacking trains multiple base models and then trains a meta-model to combine their predictions.

This can exploit complementary strengths of different model families.

## Why Ensembles Work

They work best when base models are:

- reasonably accurate
- not perfectly correlated in their mistakes

## Tradeoffs

Advantages:

- higher accuracy
- greater stability
- reduced sensitivity to one bad model

Disadvantages:

- more computation
- less interpretability
- harder deployment

## Practical Use

Ensembles are common in:

- tabular prediction
- competitions
- uncertainty-aware systems
- production systems where performance matters more than simplicity
