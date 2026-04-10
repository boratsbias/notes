# Machine Learning Overview

## Concept / Definition

Machine learning learns predictor $f_\theta : \mathcal{X} \to \mathcal{Y}$ from data

Given dataset
$$
D = \{(x_i, y_i)\}_{i=1}^n
$$
where $x_i \in \mathcal{X}$ are inputs and $y_i \in \mathcal{Y}$ are targets

Learning objective
$$
\theta^\ast = \arg\min_{\theta \in \Theta} \hat{R}(\theta)
$$
where $\hat{R}$ is empirical risk

## Mathematical Formulation

Population risk
$$
R(\theta) = \mathbb{E}_{(X,Y) \sim P}[\ell(f_\theta(X), Y)]
$$

Empirical risk
$$
\hat{R}(\theta) = \frac{1}{n} \sum_{i=1}^n \ell(f_\theta(x_i), y_i)
$$

Regularized objective
$$
J(\theta) = \hat{R}(\theta) + \lambda \Omega(\theta)
$$
where $\Omega(\theta)$ is complexity penalty and $\lambda \ge 0$

Prediction rule
$$
\hat{y} = f_{\hat{\theta}}(x)
$$

Generalization gap
$$
R(\hat{\theta}) - \hat{R}(\hat{\theta})
$$

## Conditions / Properties

First-order stationarity
$$
\nabla_\theta J(\theta^\ast) = 0
$$

Second-order local minimum condition
$$
\nabla_\theta^2 J(\theta^\ast) \succeq 0
$$

Bias-variance decomposition for squared loss
$$
\mathbb{E}\big[(Y - \hat{f}(X))^2\big] = \sigma^2 + \operatorname{Bias}[\hat{f}(X)]^2 + \operatorname{Var}[\hat{f}(X)]
$$
where $\sigma^2 = \operatorname{Var}(Y \mid X)$ is irreducible noise

IID assumption in standard setting
$$
(x_i, y_i) \overset{\text{iid}}{\sim} P(X,Y)
$$

Core property: success criterion is low test risk, not low training loss

## Algorithms / Methods

| Component | Mathematical object | Typical choices |
|---|---|---|
| Model | $f_\theta(x)$ | linear model, tree, kernel method, neural network |
| Loss | $\ell(\hat{y}, y)$ | MSE, cross-entropy, hinge |
| Optimizer | $\theta_{t+1} = \theta_t - \eta_t \nabla J(\theta_t)$ | GD, SGD, Adam |
| Regularizer | $\Omega(\theta)$ | $\|\theta\|_2^2$, $\|\theta\|_1$, early stopping |
| Evaluation | $\widehat{R}_{\text{test}}$ | holdout, cross-validation |

Pipeline
$$
\text{data} \to \text{features} \to \text{train} \to \text{validate} \to \text{test} \to \text{deploy}
$$

## Variants / Extensions

| Setting | Training signal | Objective |
|---|---|---|
| Supervised | labeled $(x,y)$ | minimize predictive loss |
| Unsupervised | unlabeled $x$ | estimate structure or density |
| Semi-supervised | few labels + many unlabeled samples | combine supervised and unsupervised terms |
| Self-supervised | surrogate labels from data | pretext objective then transfer |
| Online | stream $(x_t, y_t)$ | sequential regret minimization |
| Reinforcement learning | reward $r_t$ | maximize expected return |

## Practical Notes

Choice of loss defines statistical model
$$
\ell_{\text{MSE}} \leftrightarrow Y \mid X \sim \mathcal{N}(f_\theta(X), \sigma^2)
$$

Model capacity controls approximation-estimation tradeoff

Data leakage invalidates estimate of
$$
R(\hat{\theta})
$$

Training, validation, test distributions should satisfy
$$
P_{\text{train}}(X,Y) \approx P_{\text{test}}(X,Y)
$$
else covariate shift or concept drift appears
