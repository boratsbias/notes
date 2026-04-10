# Supervised Learning

## Concept / Definition

Supervised learning fits mapping from inputs to labeled targets

Dataset
$$D = \{(x_i, y_i)\}_{i=1}^n$$

Tasks
$$y_i \in \mathbb{R} \quad \text{regression}, \qquad y_i \in \{1,\dots,K\} \quad \text{classification}$$

## Mathematical Formulation

Empirical risk minimization
$$\hat{\theta} = \arg\min_\theta \frac{1}{n} \sum_{i=1}^n \ell(f_\theta(x_i), y_i) + \lambda \Omega(\theta)$$

Regression with squared loss
$$\ell(\hat{y}, y) = (\hat{y} - y)^2$$

Binary classification with logistic model
$$p_\theta(y=1 \mid x) = \sigma(\theta^\top x), \qquad \sigma(z) = \frac{1}{1+e^{-z}}$$

Cross-entropy loss
$$\ell(\hat{p}, y) = - y \log \hat{p} - (1-y)\log(1-\hat{p})$$

Bayes classifier
$$f^\ast(x) = \arg\max_{k} P(Y=k \mid X=x)$$

## Conditions / Properties

First-order optimality for differentiable objective
$$\nabla_\theta J(\hat{\theta}) = 0$$

Second-order sufficient condition
$$\nabla_\theta^2 J(\hat{\theta}) \succ 0$$
for strict local minimum

Excess risk
$$R(\hat{\theta}) - R(\theta^\ast)$$

Classification calibration: minimizing cross-entropy recovers posterior probabilities under correct specification

Overfitting appears when
$$\hat{R}_{\text{train}} \ll \hat{R}_{\text{test}}$$

## Algorithms / Methods

<table>
<tr><th>Method</th><th>Predictor</th><th>Objective</th></tr>
<tr><td>Linear regression</td><td>$f(x)=w^\top x + b$</td><td>minimize $\sum (y_i - f(x_i))^2$</td></tr>
<tr><td>Logistic regression</td><td>$P(y=1 \mid x)=\sigma(w^\top x+b)$</td><td>maximize Bernoulli likelihood</td></tr>
<tr><td>SVM</td><td>$f(x)=\operatorname{sign}(w^\top x+b)$</td><td>minimize hinge loss + margin penalty</td></tr>
<tr><td>Decision tree</td><td>recursive partition</td><td>impurity reduction</td></tr>
<tr><td>k-NN</td><td>local vote/average</td><td>nonparametric neighborhood rule</td></tr>
</table>

Gradient update
$$\theta_{t+1} = \theta_t - \eta_t \nabla_\theta J(\theta_t)$$

Normal equation for linear regression
$$\hat{w} = (X^\top X)^{-1} X^\top y$$
when $X^\top X$ invertible

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Main idea</th><th>Mathematical note</th></tr>
<tr><td>Multi-output regression</td><td>predict vector target</td><td>$y \in \mathbb{R}^m$</td></tr>
<tr><td>Multiclass classification</td><td>$K>2$ classes</td><td>softmax loss</td></tr>
<tr><td>Cost-sensitive learning</td><td>unequal error cost</td><td>minimize $\mathbb{E}[C(\hat{Y},Y)]$</td></tr>
<tr><td>Structured prediction</td><td>output sequence or graph</td><td>maximize score over structured space</td></tr>
<tr><td>Ordinal regression</td><td>ordered labels</td><td>threshold or cumulative link model</td></tr>
</table>

## Practical Notes

Feature scaling changes conditioning of
$$X^\top X$$
and speeds optimization

Class imbalance makes accuracy unreliable

Probability threshold for binary prediction
$$\hat{y} = \mathbb{1}[\hat{p} \ge \tau]$$
should depend on precision-recall cost

Leakage examples: target encoding fit on full data, normalization using test set statistics
