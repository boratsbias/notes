# Ensemble Learning

## Concept / Definition

Ensemble learning combines multiple predictors to improve accuracy, stability, or calibration

Given base learners $\{h_m\}_{m=1}^M$, ensemble predictor aggregates outputs

## Mathematical Formulation

Regression averaging
$$
F(x) = \frac{1}{M} \sum_{m=1}^M h_m(x)
$$

Weighted ensemble
$$
F(x) = \sum_{m=1}^M \alpha_m h_m(x), \qquad \sum_{m=1}^M \alpha_m = 1
$$

Majority vote for classification
$$
F(x) = \arg\max_k \sum_{m=1}^M \mathbf{1}[h_m(x)=k]
$$

Boosting additive model
$$
F_T(x) = \sum_{t=1}^T \alpha_t h_t(x)
$$

## Conditions / Properties

Variance reduction strongest when base learners accurate and weakly correlated

For average of identically distributed learners with variance $\sigma^2$ and pairwise correlation $\rho$
$$
\operatorname{Var}(F) = \sigma^2 \left(\rho + \frac{1-\rho}{M}\right)
$$

Bias may not decrease under bagging, but variance usually decreases

Boosting can reduce bias and variance but may overfit noisy labels

## Algorithms / Methods

| Method | Construction | Core formula |
|---|---|---|
| Bagging | bootstrap resamples + averaging | $F(x)=\frac{1}{M}\sum h_m(x)$ |
| Random forest | bagging + random feature subsets | split on random subset of features |
| AdaBoost | reweight hard samples | $\alpha_t = \frac{1}{2}\log\frac{1-\epsilon_t}{\epsilon_t}$ |
| Gradient boosting | fit learners to residuals/gradients | stagewise descent in function space |
| Stacking | meta-learner on model outputs | learn $g(h_1(x),\dots,h_M(x))$ |

AdaBoost sample weight update
$$
w_i^{(t+1)} \propto w_i^{(t)} \exp\big(-\alpha_t y_i h_t(x_i)\big)
$$

Gradient boosting step
$$
r_i^{(t)} = - \left.\frac{\partial \ell(y_i, F(x_i))}{\partial F(x_i)}\right|_{F=F_{t-1}}
$$

## Variants / Extensions

| Variant | Difference | Example |
|---|---|---|
| Heterogeneous ensemble | different model families | tree + linear + NN |
| Snapshot ensemble | multiple checkpoints of one training run | deep learning |
| Bayesian model averaging | posterior model weights | uncertainty-aware aggregation |
| Distillation | compress ensemble into one student | deployment efficiency |

## Practical Notes

Stacking needs out-of-fold predictions to avoid target leakage

Random forests robust on tabular data with limited preprocessing

Boosting hyperparameters interact strongly:
$$
\text{effective complexity} \approx T \times \eta \times \text{tree depth}
$$

Ensembles improve performance but increase inference cost and reduce interpretability
