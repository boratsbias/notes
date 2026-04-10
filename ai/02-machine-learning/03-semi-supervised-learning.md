# Semi Supervised Learning

## Concept / Definition

Semi-supervised learning uses small labeled set and large unlabeled set

Data
$$D_L = \{(x_i, y_i)\}_{i=1}^{n_L}, \qquad D_U = \{x_j\}_{j=1}^{n_U}, \qquad n_U \gg n_L$$

Goal: reduce supervised sample complexity by exploiting structure of $P(X)$

## Mathematical Formulation

Generic objective
$$J(\theta) = \frac{1}{n_L} \sum_{i=1}^{n_L} \ell(f_\theta(x_i), y_i) + \lambda \, \Omega_U(\theta; D_U)$$

Consistency regularization
$$\Omega_U(\theta) = \frac{1}{n_U} \sum_{j=1}^{n_U} d\big(f_\theta(x_j), f_\theta(T(x_j))\big)$$
where $T$ is perturbation and $d$ is discrepancy

Entropy minimization
$$\Omega_U(\theta) = \frac{1}{n_U} \sum_{j=1}^{n_U} H\big(p_\theta(\cdot \mid x_j)\big)$$

Pseudo-label objective
$$\tilde{y}_j = \arg\max_k p_\theta(y=k \mid x_j), \qquad \Omega_U(\theta) = \frac{1}{n_U} \sum_{j=1}^{n_U} \mathbf{1}[\max_k p_\theta(k \mid x_j) \ge \tau] \, \ell(f_\theta(x_j), \tilde{y}_j)$$

## Conditions / Properties

Cluster assumption
$$P(Y \mid X=x)$$
changes mainly across low-density regions

Smoothness assumption
$$x \approx x' \implies f^\ast(x) \approx f^\ast(x')$$

Manifold assumption: high-dimensional data lie near lower-dimensional manifold $\mathcal{M}$

Failure mode: if unlabeled distribution contains out-of-class or shifted samples, $\Omega_U$ can bias decision boundary

## Algorithms / Methods

<table>
<tr><th>Method</th><th>Main term</th><th>Technical idea</th></tr>
<tr><td>Self-training</td><td>pseudo-label loss</td><td>iterate teacher predictions</td></tr>
<tr><td>Label propagation</td><td>graph smoothness</td><td>diffuse labels on similarity graph</td></tr>
<tr><td>Co-training</td><td>agreement loss</td><td>two conditionally independent views</td></tr>
<tr><td>Mean Teacher</td><td>consistency to EMA teacher</td><td>temporal ensembling</td></tr>
<tr><td>FixMatch</td><td>weak/strong augmentation consistency</td><td>thresholded pseudo-labels</td></tr>
</table>

Graph regularization
$$\Omega_U(f) = \sum_{i,j} w_{ij} \|f(x_i) - f(x_j)\|_2^2 = 2 f^\top L f$$
where $L = D - W$ is graph Laplacian

Teacher update in Mean Teacher
$$\theta'_t = \alpha \theta'_{t-1} + (1-\alpha)\theta_t$$

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Difference</th><th>Note</th></tr>
<tr><td>Transductive SSL</td><td>predict only observed unlabeled set</td><td>no explicit out-of-sample rule required</td></tr>
<tr><td>Inductive SSL</td><td>learn general predictor</td><td>standard deployment setting</td></tr>
<tr><td>Positive-unlabeled learning</td><td>only positives labeled</td><td>class-prior estimation important</td></tr>
<tr><td>Semi-supervised regression</td><td>unlabeled smoothness in continuous target setting</td><td>graph and consistency methods</td></tr>
</table>

## Practical Notes

Confidence threshold $\tau$ trades label quantity against label noise

Augmentations must preserve class semantics

Validation must use labeled holdout only

SSL strongest when
$$n_L \text{ small}, \quad n_U \text{ large}, \quad P_{\text{labeled}}(X,Y) \approx P_{\text{unlabeled}}(X,Y)$$
