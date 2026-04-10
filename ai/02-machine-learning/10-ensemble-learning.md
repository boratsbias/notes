# Ensemble Learning

## Concept / Definition

Ensemble learning combines multiple predictors to improve accuracy, stability, or calibration

Given base learners $\{h_m\}_{m=1}^M$, ensemble predictor aggregates outputs

## Mathematical Formulation

Regression averaging
$$F(x) = \frac{1}{M} \sum_{m=1}^M h_m(x)$$

Weighted ensemble
$$F(x) = \sum_{m=1}^M \alpha_m h_m(x), \qquad \sum_{m=1}^M \alpha_m = 1$$

Majority vote for classification
$$F(x) = \arg\max_k \sum_{m=1}^M \mathbf{1}[h_m(x)=k]$$

Boosting additive model
$$F_T(x) = \sum_{t=1}^T \alpha_t h_t(x)$$

## Conditions / Properties

Variance reduction strongest when base learners accurate and weakly correlated

For average of identically distributed learners with variance $\sigma^2$ and pairwise correlation $\rho$
$$\operatorname{Var}(F) = \sigma^2 \left(\rho + \frac{1-\rho}{M}\right)$$

Bias may not decrease under bagging, but variance usually decreases

Boosting can reduce bias and variance but may overfit noisy labels

## Algorithms / Methods

<table>
<tr><th>Method</th><th>Construction</th><th>Core formula</th></tr>
<tr><td>Bagging</td><td>bootstrap resamples + averaging</td><td>$F(x)=\frac{1}{M}\sum h_m(x)$</td></tr>
<tr><td>Random forest</td><td>bagging + random feature subsets</td><td>split on random subset of features</td></tr>
<tr><td>AdaBoost</td><td>reweight hard samples</td><td>$\alpha_t = \frac{1}{2}\log\frac{1-\epsilon_t}{\epsilon_t}$</td></tr>
<tr><td>Gradient boosting</td><td>fit learners to residuals/gradients</td><td>stagewise descent in function space</td></tr>
<tr><td>Stacking</td><td>meta-learner on model outputs</td><td>learn $g(h_1(x),\dots,h_M(x))$</td></tr>
</table>

AdaBoost sample weight update
$$w_i^{(t+1)} \propto w_i^{(t)} \exp\big(-\alpha_t y_i h_t(x_i)\big)$$

Gradient boosting step
$$r_i^{(t)} = - \left.\frac{\partial \ell(y_i, F(x_i))}{\partial F(x_i)}\right|_{F=F_{t-1}}$$

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Difference</th><th>Example</th></tr>
<tr><td>Heterogeneous ensemble</td><td>different model families</td><td>tree + linear + NN</td></tr>
<tr><td>Snapshot ensemble</td><td>multiple checkpoints of one training run</td><td>deep learning</td></tr>
<tr><td>Bayesian model averaging</td><td>posterior model weights</td><td>uncertainty-aware aggregation</td></tr>
<tr><td>Distillation</td><td>compress ensemble into one student</td><td>deployment efficiency</td></tr>
</table>

## Practical Notes

Stacking needs out-of-fold predictions to avoid target leakage

Random forests robust on tabular data with limited preprocessing

Boosting hyperparameters interact strongly:
$$\text{effective complexity} \approx T \times \eta \times \text{tree depth}$$

Ensembles improve performance but increase inference cost and reduce interpretability
