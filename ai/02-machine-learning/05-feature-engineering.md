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

<table>
<tr><th>Method</th><th>Formula</th><th>Technical effect</th></tr>
<tr><td>Standardization</td><td>$(x-\mu)/\sigma$</td><td>comparable scale, stable optimization</td></tr>
<tr><td>Min-max scaling</td><td>$(x-a)/(b-a)$</td><td>bounded interval</td></tr>
<tr><td>Log transform</td><td>$\log(x+c)$</td><td>compress heavy tail</td></tr>
<tr><td>Binning</td><td>discretize by thresholds</td><td>nonlinear monotone effect</td></tr>
<tr><td>Interaction features</td><td>$x_i x_j$</td><td>explicit second-order terms</td></tr>
<tr><td>PCA</td><td>top eigenvectors</td><td>decorrelation, dimension reduction</td></tr>
</table>

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

<table>
<tr><th>Variant</th><th>Mechanism</th><th>Typical models</th></tr>
<tr><td>Manual domain features</td><td>handcrafted statistics</td><td>linear models, trees</td></tr>
<tr><td>Automated feature crosses</td><td>combinatorial interactions</td><td>CTR models</td></tr>
<tr><td>Embeddings</td><td>learned dense vectors</td><td>deep models, recommenders</td></tr>
<tr><td>Hashing trick</td><td>$h(c) \in \{1,\dots,m\}$</td><td>large sparse categories</td></tr>
<tr><td>Representation learning</td><td>neural $\phi_\theta(x)$</td><td>end-to-end systems</td></tr>
</table>

## Practical Notes

Trees need less scaling than distance-based or gradient-based linear models

Feature selection objective often uses
$$
\max_{S \subseteq \{1,\dots,p\}} \operatorname{Score}(S)
$$
with sparsity or validation constraint

Fit all preprocessing inside training folds during cross-validation

Interpretability usually decreases as $\phi(x)$ becomes more learned and less manual
