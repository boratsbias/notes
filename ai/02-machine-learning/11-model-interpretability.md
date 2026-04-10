# Model Interpretability

## Concept / Definition

Model interpretability studies how predictions depend on inputs, features, or internal representations

Given predictor $f(x)$, objective is explanation map
$$E(x, f) \to \text{human-readable attribution or rule}$$

## Mathematical Formulation

Local sensitivity
$$\nabla_x f(x)$$
measures infinitesimal change in prediction with respect to input

Feature attribution with additive explanation
$$f(x) \approx \phi_0 + \sum_{j=1}^d \phi_j$$
where $\phi_j$ is contribution of feature $j$

Permutation importance for feature $j$
$$I_j = \widehat{R}(f; X_{\pi(j)}) - \widehat{R}(f; X)$$
where $X_{\pi(j)}$ permutes feature $j$

Partial dependence for subset $S$
$$\operatorname{PD}_S(x_S) = \mathbb{E}_{X_C}[f(x_S, X_C)]$$
where $C$ is complement of $S$

## Conditions / Properties

Faithfulness requires explanation correlate with true model behavior

Stability requires small perturbations in data or seed not change explanation excessively

Global explanations summarize behavior over distribution
$$P(X)$$
local explanations explain one sample $x$

Correlated features break naive marginal interpretations such as permutation importance or PDP

## Algorithms / Methods

<table>
<tr><th>Method</th><th>Type</th><th>Mathematical object</th></tr>
<tr><td>Linear coefficients</td><td>global intrinsic</td><td>sign and magnitude of $w_j$</td></tr>
<tr><td>Decision paths</td><td>local intrinsic</td><td>split sequence in tree</td></tr>
<tr><td>Permutation importance</td><td>global post hoc</td><td>metric drop after shuffling</td></tr>
<tr><td>PDP / ICE</td><td>global/local post hoc</td><td>expected prediction curve</td></tr>
<tr><td>SHAP</td><td>additive local attribution</td><td>Shapley values</td></tr>
<tr><td>LIME</td><td>local surrogate</td><td>weighted local regression</td></tr>
</table>

Shapley value for feature $j$
$$\phi_j = \sum_{S \subseteq N \setminus \{j\}} \frac{|S|!(|N|-|S|-1)!}{|N|!} \big(v(S \cup \{j\}) - v(S)\big)$$

LIME surrogate fit
$$\arg\min_{g \in \mathcal{G}} \mathcal{L}(f, g, \pi_x) + \Omega(g)$$

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Scope</th><th>Example</th></tr>
<tr><td>Intrinsic interpretability</td><td>model itself simple</td><td>linear model, shallow tree</td></tr>
<tr><td>Post hoc interpretability</td><td>explain black box after training</td><td>SHAP, saliency</td></tr>
<tr><td>Counterfactual explanations</td><td>minimal input change</td><td>actionable recourse</td></tr>
<tr><td>Concept-based explanations</td><td>human concepts</td><td>TCAV</td></tr>
</table>

Counterfactual optimization
$$x' = \arg\min_{x'} d(x', x) \quad \text{s.t.} \quad f(x') = y_{\text{target}}$$

## Practical Notes

Interpretability does not imply causality

Use explanation method matched to question: global ranking, local decision, fairness audit, debugging

For highly correlated tabular features, prefer conditional or grouped importance over naive permutation

Human usefulness depends on stability, sparsity, and domain semantics, not only mathematical elegance
