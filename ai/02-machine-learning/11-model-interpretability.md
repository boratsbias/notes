# Model Interpretability

## Concept / Definition

Model interpretability studies how predictions depend on inputs, features, or internal representations

Given predictor $f(x)$, objective is explanation map
$$
E(x, f) \to \text{human-readable attribution or rule}
$$

## Mathematical Formulation

Local sensitivity
$$
\nabla_x f(x)
$$
measures infinitesimal change in prediction with respect to input

Feature attribution with additive explanation
$$
f(x) \approx \phi_0 + \sum_{j=1}^d \phi_j
$$
where $\phi_j$ is contribution of feature $j$

Permutation importance for feature $j$
$$
I_j = \widehat{R}(f; X_{\pi(j)}) - \widehat{R}(f; X)
$$
where $X_{\pi(j)}$ permutes feature $j$

Partial dependence for subset $S$
$$
\operatorname{PD}_S(x_S) = \mathbb{E}_{X_C}[f(x_S, X_C)]
$$
where $C$ is complement of $S$

## Conditions / Properties

Faithfulness requires explanation correlate with true model behavior

Stability requires small perturbations in data or seed not change explanation excessively

Global explanations summarize behavior over distribution
$$
P(X)
$$
local explanations explain one sample $x$

Correlated features break naive marginal interpretations such as permutation importance or PDP

## Algorithms / Methods

| Method | Type | Mathematical object |
|---|---|---|
| Linear coefficients | global intrinsic | sign and magnitude of $w_j$ |
| Decision paths | local intrinsic | split sequence in tree |
| Permutation importance | global post hoc | metric drop after shuffling |
| PDP / ICE | global/local post hoc | expected prediction curve |
| SHAP | additive local attribution | Shapley values |
| LIME | local surrogate | weighted local regression |

Shapley value for feature $j$
$$
\phi_j = \sum_{S \subseteq N \setminus \{j\}} \frac{|S|!(|N|-|S|-1)!}{|N|!} \big(v(S \cup \{j\}) - v(S)\big)
$$

LIME surrogate fit
$$
\arg\min_{g \in \mathcal{G}} \mathcal{L}(f, g, \pi_x) + \Omega(g)
$$

## Variants / Extensions

| Variant | Scope | Example |
|---|---|---|
| Intrinsic interpretability | model itself simple | linear model, shallow tree |
| Post hoc interpretability | explain black box after training | SHAP, saliency |
| Counterfactual explanations | minimal input change | actionable recourse |
| Concept-based explanations | human concepts | TCAV |

Counterfactual optimization
$$
x' = \arg\min_{x'} d(x', x) \quad \text{s.t.} \quad f(x') = y_{\text{target}}
$$

## Practical Notes

Interpretability does not imply causality

Use explanation method matched to question: global ranking, local decision, fairness audit, debugging

For highly correlated tabular features, prefer conditional or grouped importance over naive permutation

Human usefulness depends on stability, sparsity, and domain semantics, not only mathematical elegance
