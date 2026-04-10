# Supervised Learning

## Concept / Definition

Supervised learning fits mapping from inputs to labeled targets

Dataset
$$
D = \{(x_i, y_i)\}_{i=1}^n
$$

Tasks
$$
y_i \in \mathbb{R} \quad \text{regression}, \qquad y_i \in \{1,\dots,K\} \quad \text{classification}
$$

## Mathematical Formulation

Empirical risk minimization
$$
\hat{\theta} = \arg\min_\theta \frac{1}{n} \sum_{i=1}^n \ell(f_\theta(x_i), y_i) + \lambda \Omega(\theta)
$$

Regression with squared loss
$$
\ell(\hat{y}, y) = (\hat{y} - y)^2
$$

Binary classification with logistic model
$$
p_\theta(y=1 \mid x) = \sigma(\theta^\top x), \qquad \sigma(z) = \frac{1}{1+e^{-z}}
$$

Cross-entropy loss
$$
\ell(\hat{p}, y) = - y \log \hat{p} - (1-y)\log(1-\hat{p})
$$

Bayes classifier
$$
f^\ast(x) = \arg\max_{k} P(Y=k \mid X=x)
$$

## Conditions / Properties

First-order optimality for differentiable objective
$$
\nabla_\theta J(\hat{\theta}) = 0
$$

Second-order sufficient condition
$$
\nabla_\theta^2 J(\hat{\theta}) \succ 0
$$
for strict local minimum

Excess risk
$$
R(\hat{\theta}) - R(\theta^\ast)
$$

Classification calibration: minimizing cross-entropy recovers posterior probabilities under correct specification

Overfitting appears when
$$
\hat{R}_{\text{train}} \ll \hat{R}_{\text{test}}
$$

## Algorithms / Methods

| Method | Predictor | Objective |
|---|---|---|
| Linear regression | $f(x)=w^\top x + b$ | minimize $\sum (y_i - f(x_i))^2$ |
| Logistic regression | $P(y=1 \mid x)=\sigma(w^\top x+b)$ | maximize Bernoulli likelihood |
| SVM | $f(x)=\operatorname{sign}(w^\top x+b)$ | minimize hinge loss + margin penalty |
| Decision tree | recursive partition | impurity reduction |
| k-NN | local vote/average | nonparametric neighborhood rule |

Gradient update
$$
\theta_{t+1} = \theta_t - \eta_t \nabla_\theta J(\theta_t)
$$

Normal equation for linear regression
$$
\hat{w} = (X^\top X)^{-1} X^\top y
$$
when $X^\top X$ invertible

## Variants / Extensions

| Variant | Main idea | Mathematical note |
|---|---|---|
| Multi-output regression | predict vector target | $y \in \mathbb{R}^m$ |
| Multiclass classification | $K>2$ classes | softmax loss |
| Cost-sensitive learning | unequal error cost | minimize $\mathbb{E}[C(\hat{Y},Y)]$ |
| Structured prediction | output sequence or graph | maximize score over structured space |
| Ordinal regression | ordered labels | threshold or cumulative link model |

## Practical Notes

Feature scaling changes conditioning of
$$
X^\top X
$$
and speeds optimization

Class imbalance makes accuracy unreliable

Probability threshold for binary prediction
$$
\hat{y} = \mathbb{1}[\hat{p} \ge \tau]
$$
should depend on precision-recall cost

Leakage examples: target encoding fit on full data, normalization using test set statistics
