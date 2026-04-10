# Hyperparameter Tuning

## Concept / Definition

Hyperparameters are configuration variables not learned directly by optimizer

Examples:
$$
\lambda \text{ regularization}, \quad \eta \text{ learning rate}, \quad d \text{ tree depth}, \quad K \text{ neighbors}
$$

Goal
$$
\hat{\lambda} = \arg\min_{\lambda \in \Lambda} \widehat{R}_{\text{valid}}(\lambda)
$$

## Mathematical Formulation

Bilevel optimization
$$
\theta^\ast(\lambda) = \arg\min_\theta J(\theta; \lambda)
$$
$$
\hat{\lambda} = \arg\min_{\lambda \in \Lambda} \widehat{R}_{\text{valid}}(\theta^\ast(\lambda))
$$

Grid search over finite set
$$
\Lambda = \Lambda_1 \times \cdots \times \Lambda_p
$$

Bayesian optimization acquisition
$$
\lambda_{t+1} = \arg\max_{\lambda \in \Lambda} a(\lambda \mid \mathcal{D}_t)
$$
where $\mathcal{D}_t = \{(\lambda_s, r_s)\}_{s=1}^t$

## Conditions / Properties

Validation metric must be independent of final test set

Search spaces often log-scaled
$$
\lambda \in [10^{-6}, 10^2]
$$
because sensitivity is multiplicative

High-dimensional hyperparameter spaces make exhaustive grid search inefficient

Noisy training implies noisy objective
$$
\widehat{R}_{\text{valid}}(\lambda)
$$

## Algorithms / Methods

| Method | Selection rule | Strength |
|---|---|---|
| Manual search | domain-guided trials | cheap when few knobs matter |
| Grid search | exhaust finite mesh | simple, parallel |
| Random search | sample $\lambda \sim p(\lambda)$ | efficient in sparse-relevance spaces |
| Bayesian optimization | surrogate + acquisition | sample efficient |
| Hyperband / ASHA | adaptive resource allocation | early-stop poor trials |

Random search
$$
\lambda^{(t)} \sim p(\lambda)
$$

Successive halving keeps top fraction according to partial-resource score
$$
r_1 < r_2 < \dots < r_L
$$

## Variants / Extensions

| Variant | Description | Note |
|---|---|---|
| Multi-fidelity tuning | use subset epochs/data | cheaper approximate ranking |
| Population-based training | evolve hyperparameters during training | nonstationary schedules |
| Differentiable HPO | gradient through validation loss | expensive but principled |
| Multi-objective tuning | accuracy-latency-memory tradeoff | Pareto frontier |

## Practical Notes

Tune most sensitive parameters first: learning rate, regularization, capacity

Use nested CV or dedicated validation split for fair comparison

Best configuration should satisfy deployment constraints
$$
\text{latency} \le L_{\max}, \quad \text{memory} \le M_{\max}
$$

Record seed, search space, budget, and metric to make tuning reproducible
