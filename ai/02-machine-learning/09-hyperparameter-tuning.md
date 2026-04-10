# Hyperparameter Tuning

## Core Idea

Hyperparameters are settings chosen before training that control model structure or learning behavior.

They are not learned directly from the data by the optimizer.

## Examples

- learning rate
- regularization strength
- tree depth
- number of neighbors in k-NN
- number of hidden layers
- batch size

## Parameters vs Hyperparameters

- **Parameters:** learned during training, such as weights in a model
- **Hyperparameters:** chosen externally, such as model capacity or optimization settings

## Objective

Choose hyperparameters $\lambda$ that give the best validation performance:

$$\lambda^* = \arg\max_\lambda \text{ValidationScore}(\lambda)$$

or equivalently minimize validation loss.

## Search Methods

### Grid Search

Try all combinations in a predefined grid.

- simple
- expensive in high dimensions

### Random Search

Sample combinations at random.

Often more efficient than grid search when only a few hyperparameters matter strongly.

### Bayesian Optimization

Build a surrogate model of the validation objective and choose promising configurations sequentially.

Useful when training is expensive.

## Practical Considerations

- use validation data or cross validation
- search on log scale for quantities such as learning rate or regularization
- start with coarse ranges, then narrow them
- track all runs carefully

## Common Failure Modes

- tuning on the test set
- searching too narrowly around poor initial values
- changing many factors at once without tracking results
- overfitting to validation data through excessive search

## Early Stopping as a Hyperparameter

Training duration is itself an important hyperparameter. Stopping too early underfits. Stopping too late can overfit.

## In Practice

Strong tuning often matters as much as the model family itself. A well-tuned simple model can outperform a poorly tuned complex one.
