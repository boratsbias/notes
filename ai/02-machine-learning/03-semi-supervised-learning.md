# Semi Supervised Learning

## Concept / Definition

Semi-supervised learning uses small labeled set and large unlabeled set

Data
$$
D_L = \{(x_i, y_i)\}_{i=1}^{n_L}, \qquad D_U = \{x_j\}_{j=1}^{n_U}, \qquad n_U \gg n_L
$$

Goal: reduce supervised sample complexity by exploiting structure of $P(X)$

## Mathematical Formulation

Generic objective
$$
J(\theta) = \frac{1}{n_L} \sum_{i=1}^{n_L} \ell(f_\theta(x_i), y_i) + \lambda \, \Omega_U(\theta; D_U)
$$

Consistency regularization
$$
\Omega_U(\theta) = \frac{1}{n_U} \sum_{j=1}^{n_U} d\big(f_\theta(x_j), f_\theta(T(x_j))\big)
$$
where $T$ is perturbation and $d$ is discrepancy

Entropy minimization
$$
\Omega_U(\theta) = \frac{1}{n_U} \sum_{j=1}^{n_U} H\big(p_\theta(\cdot \mid x_j)\big)
$$

Pseudo-label objective
$$
\tilde{y}_j = \arg\max_k p_\theta(y=k \mid x_j), \qquad
\Omega_U(\theta) = \frac{1}{n_U} \sum_{j=1}^{n_U} \mathbf{1}[\max_k p_\theta(k \mid x_j) \ge \tau] \, \ell(f_\theta(x_j), \tilde{y}_j)
$$

## Conditions / Properties

Cluster assumption
$$
P(Y \mid X=x)
$$
changes mainly across low-density regions

Smoothness assumption
$$
x \approx x' \implies f^\ast(x) \approx f^\ast(x')
$$

Manifold assumption: high-dimensional data lie near lower-dimensional manifold $\mathcal{M}$

Failure mode: if unlabeled distribution contains out-of-class or shifted samples, $\Omega_U$ can bias decision boundary

## Algorithms / Methods

| Method | Main term | Technical idea |
|---|---|---|
| Self-training | pseudo-label loss | iterate teacher predictions |
| Label propagation | graph smoothness | diffuse labels on similarity graph |
| Co-training | agreement loss | two conditionally independent views |
| Mean Teacher | consistency to EMA teacher | temporal ensembling |
| FixMatch | weak/strong augmentation consistency | thresholded pseudo-labels |

Graph regularization
$$
\Omega_U(f) = \sum_{i,j} w_{ij} \|f(x_i) - f(x_j)\|_2^2 = 2 f^\top L f
$$
where $L = D - W$ is graph Laplacian

Teacher update in Mean Teacher
$$
\theta'_t = \alpha \theta'_{t-1} + (1-\alpha)\theta_t
$$

## Variants / Extensions

| Variant | Difference | Note |
|---|---|---|
| Transductive SSL | predict only observed unlabeled set | no explicit out-of-sample rule required |
| Inductive SSL | learn general predictor | standard deployment setting |
| Positive-unlabeled learning | only positives labeled | class-prior estimation important |
| Semi-supervised regression | unlabeled smoothness in continuous target setting | graph and consistency methods |

## Practical Notes

Confidence threshold $\tau$ trades label quantity against label noise

Augmentations must preserve class semantics

Validation must use labeled holdout only

SSL strongest when
$$
n_L \text{ small}, \quad n_U \text{ large}, \quad P_{\text{labeled}}(X,Y) \approx P_{\text{unlabeled}}(X,Y)
$$
