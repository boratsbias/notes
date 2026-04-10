# Hyperparameter Tuning

## Concept / Definition

Hyperparameters are configuration variables not learned directly by optimizer

Examples:
$$\lambda \text{ regularization}, \quad \eta \text{ learning rate}, \quad d \text{ tree depth}, \quad K \text{ neighbors}$$

Goal
$$\hat{\lambda} = \arg\min_{\lambda \in \Lambda} \widehat{R}_{\text{valid}}(\lambda)$$

## Mathematical Formulation

Bilevel optimization
$$\theta^\ast(\lambda) = \arg\min_\theta J(\theta; \lambda)$$
$$\hat{\lambda} = \arg\min_{\lambda \in \Lambda} \widehat{R}_{\text{valid}}(\theta^\ast(\lambda))$$

Grid search over finite set
$$\Lambda = \Lambda_1 \times \cdots \times \Lambda_p$$

Bayesian optimization acquisition
$$\lambda_{t+1} = \arg\max_{\lambda \in \Lambda} a(\lambda \mid \mathcal{D}_t)$$
where $\mathcal{D}_t = \{(\lambda_s, r_s)\}_{s=1}^t$

## Conditions / Properties

Validation metric must be independent of final test set

Search spaces often log-scaled
$$\lambda \in [10^{-6}, 10^2]$$
because sensitivity is multiplicative

High-dimensional hyperparameter spaces make exhaustive grid search inefficient

Noisy training implies noisy objective
$$\widehat{R}_{\text{valid}}(\lambda)$$

## Algorithms / Methods

<table>
<tr><th>Method</th><th>Selection rule</th><th>Strength</th></tr>
<tr><td>Manual search</td><td>domain-guided trials</td><td>cheap when few knobs matter</td></tr>
<tr><td>Grid search</td><td>exhaust finite mesh</td><td>simple, parallel</td></tr>
<tr><td>Random search</td><td>sample $\lambda \sim p(\lambda)$</td><td>efficient in sparse-relevance spaces</td></tr>
<tr><td>Bayesian optimization</td><td>surrogate + acquisition</td><td>sample efficient</td></tr>
<tr><td>Hyperband / ASHA</td><td>adaptive resource allocation</td><td>early-stop poor trials</td></tr>
</table>

Random search
$$\lambda^{(t)} \sim p(\lambda)$$

Successive halving keeps top fraction according to partial-resource score
$$r_1 < r_2 < \dots < r_L$$

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Description</th><th>Note</th></tr>
<tr><td>Multi-fidelity tuning</td><td>use subset epochs/data</td><td>cheaper approximate ranking</td></tr>
<tr><td>Population-based training</td><td>evolve hyperparameters during training</td><td>nonstationary schedules</td></tr>
<tr><td>Differentiable HPO</td><td>gradient through validation loss</td><td>expensive but principled</td></tr>
<tr><td>Multi-objective tuning</td><td>accuracy-latency-memory tradeoff</td><td>Pareto frontier</td></tr>
</table>

## Practical Notes

Tune most sensitive parameters first: learning rate, regularization, capacity

Use nested CV or dedicated validation split for fair comparison

Best configuration should satisfy deployment constraints
$$\text{latency} \le L_{\max}, \quad \text{memory} \le M_{\max}$$

Record seed, search space, budget, and metric to make tuning reproducible
