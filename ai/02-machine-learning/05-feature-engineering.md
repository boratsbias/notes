# Feature Engineering

## Concept / Definition

Feature engineering maps raw input $x$ to representation $\phi(x)$ better suited for predictor

Model becomes
$$
f(x) = g(\phi(x))
$$

Goal: increase signal-to-noise ratio, improve linear separability, reduce nuisance variation

## Mathematical Formulation

Feature map
$$
\phi : \mathcal{X} \to \mathbb{R}^p
$$

Standardization
$$
z_j = \frac{x_j - \mu_j}{\sigma_j}
$$
where $\mu_j, \sigma_j$ computed on training split only

Polynomial expansion
$$
\phi(x) = [1, x_1, \dots, x_d, x_1^2, x_1x_2, \dots]
$$

One-hot encoding for categorical feature $c \in \{1,\dots,K\}$
$$
\phi(c) = e_c \in \{0,1\}^K
$$

Principal component transform
$$
z = W^\top (x - \bar{x})
$$

## Conditions / Properties

Monotone scaling preserves order statistics but changes Euclidean geometry

Collinearity in engineered features yields ill-conditioned matrix
$$
X^\top X
$$

Leakage condition to avoid:
$$
\phi \text{ fit on full dataset } \Rightarrow \text{ optimistic validation estimate}
$$

Sparse high-cardinality encodings increase dimension $p$ and memory cost

## Algorithms / Methods

| Method | Formula | Technical effect |
|---|---|---|
| Standardization | $(x-\mu)/\sigma$ | comparable scale, stable optimization |
| Min-max scaling | $(x-a)/(b-a)$ | bounded interval |
| Log transform | $\log(x+c)$ | compress heavy tail |
| Binning | discretize by thresholds | nonlinear monotone effect |
| Interaction features | $x_i x_j$ | explicit second-order terms |
| PCA | top eigenvectors | decorrelation, dimension reduction |

Target encoding for category $c$
$$
\phi(c) = \mathbb{E}[Y \mid C=c]
$$
requires out-of-fold estimation

Missing value imputation
$$
\tilde{x}_{ij} =
\begin{cases}
x_{ij}, & x_{ij} \text{ observed} \\
m_j, & x_{ij} \text{ missing}
\end{cases}
$$

## Variants / Extensions

| Variant | Mechanism | Typical models |
|---|---|---|
| Manual domain features | handcrafted statistics | linear models, trees |
| Automated feature crosses | combinatorial interactions | CTR models |
| Embeddings | learned dense vectors | deep models, recommenders |
| Hashing trick | $h(c) \in \{1,\dots,m\}$ | large sparse categories |
| Representation learning | neural $\phi_\theta(x)$ | end-to-end systems |

## Practical Notes

Trees need less scaling than distance-based or gradient-based linear models

Feature selection objective often uses
$$
\max_{S \subseteq \{1,\dots,p\}} \operatorname{Score}(S)
$$
with sparsity or validation constraint

Fit all preprocessing inside training folds during cross-validation

Interpretability usually decreases as $\phi(x)$ becomes more learned and less manual
