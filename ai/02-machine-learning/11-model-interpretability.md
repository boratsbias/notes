# Model Interpretability

## Core Idea

Model interpretability (also called explainability or XAI) is the degree to which a human can understand the cause of a model's prediction. It is essential for debugging, building trust, satisfying regulatory requirements, and detecting bias.

**Interpretability vs. accuracy:** complex models (neural nets, gradient boosting) are often more accurate but harder to interpret. Interpretable models (linear regression, decision trees) trade some accuracy for transparency.

## Scope of Explanation

| Scope | Question |
|-------|---------|
| **Global** | How does the model behave overall? Which features matter most? |
| **Local** | Why did the model make this specific prediction for this instance? |
| **Cohort** | How does the model behave on a specific subgroup? |

## Intrinsically Interpretable Models

### Linear Models

Coefficients $\mathbf{w}$ directly quantify the effect of each feature:

$$\hat{y} = \mathbf{w}^T x + b$$

$w_j$ is the change in $\hat{y}$ per unit increase in $x_j$, holding all else constant.

**Conditions for valid interpretation:**
- Features are standardized (otherwise magnitudes are not comparable).
- No strong multicollinearity (correlated features share credit arbitrarily).
- Correct functional form (linear relationship holds).

### Decision Trees

Provide natural rule-based explanations:

```
if age > 30:
    if income > 50k: predict "approved"
    else: predict "denied"
else:
    predict "denied"
```

Each prediction path is a conjunction of conditions. Depth $\leq 5$ trees are comprehensible to humans; deeper trees lose interpretability.

### Rule-Based Models

**Decision rules:** IF-THEN statements learned directly. E.g., RuleFit learns linear model + sparse set of rules from tree splits.

**Scoring systems:** additive point-based models (FICO score) where each feature contributes a small integer score. Directly applicable by humans without computation.

## Post-hoc Explanation Methods

Applied after training any model.

### Feature Importance

**Permutation importance:** measure drop in validation metric when feature $j$ is randomly permuted:

$$\text{PI}_j = m(\hat{y}, y) - m(\hat{y}_{j\text{ permuted}}, y)$$

Model-agnostic; unbiased; accounts for feature interactions (any drop in performance means $j$ was carrying information).

**SHAP-based importance:** mean absolute SHAP value over the dataset. Consistent and theoretically grounded.

### SHAP (SHapley Additive exPlanations)

Attributes the model's prediction to each feature based on Shapley values from cooperative game theory.

**Shapley value:** the average marginal contribution of feature $j$ across all possible orderings of features:

$$\phi_j = \sum_{S \subseteq \mathcal{F} \setminus \{j\}} \frac{|S|!(|\mathcal{F}| - |S| - 1)!}{|\mathcal{F}|!} [f(S \cup \{j\}) - f(S)]$$

**SHAP explanation:** $\hat{f}(x) = \phi_0 + \sum_{j=1}^d \phi_j(x)$, where $\phi_0 = \mathbb{E}[\hat{f}(x)]$.

**Properties:**
- **Efficiency:** $\sum_j \phi_j = \hat{f}(x) - \mathbb{E}[\hat{f}]$
- **Symmetry:** features that contribute equally get equal values.
- **Dummy:** features that never affect output get $\phi_j = 0$.
- **Additivity:** SHAP values of a sum of models equal sum of individual SHAP values.

**Algorithms:**

| Variant | Target Model | Complexity |
|---------|-------------|-----------|
| TreeSHAP | Tree-based models | $O(TLD^2)$; exact |
| KernelSHAP | Any model | $O(2^d)$ exact, approximated in practice |
| LinearSHAP | Linear models | $O(d)$; exact |
| DeepSHAP | Neural networks | Approximation via DeepLIFT |

### LIME (Local Interpretable Model-agnostic Explanations)

Locally approximates the black-box model with a simple (linear) model around a specific instance $x'$.

**Algorithm:**
1. Sample perturbed instances around $x'$.
2. Get predictions from black-box model for each perturbation.
3. Weight by proximity to $x'$: $w_i = \exp(-d(x', z_i)^2 / \sigma^2)$.
4. Fit a sparse linear model to the weighted dataset.
5. Report linear coefficients as explanation.

**Limitations:** local linearity assumption may not hold; explanation can be unstable across runs.

### Partial Dependence Plots (PDP)

Shows the **marginal** effect of one (or two) features on the predicted outcome, averaging over all other features:

$$\hat{f}_S(x_S) = \mathbb{E}_{x_C}[\hat{f}(x_S, x_C)] \approx \frac{1}{n}\sum_{i=1}^n \hat{f}(x_S, x_C^{(i)})$$

Assumes feature independence. Can be misleading with correlated features.

### Individual Conditional Expectation (ICE) Plots

One line per sample: shows how prediction changes as a single feature varies, holding all others at their observed values. PDP is the mean of ICE curves. Reveals heterogeneous effects that PDP averages away.

**Centered ICE (c-ICE):** subtract the value at a reference point to highlight differences in slopes.

### Accumulated Local Effects (ALE)

Resolves the feature independence assumption of PDP. Uses conditional distribution $P(X_{-j} | X_j)$ rather than marginal:

$$\hat{f}_{j,\text{ALE}}(x_j) = \int_{z_0}^{x_j} \mathbb{E}_{X_{-j}|X_j=z}\!\left[\frac{\partial \hat{f}}{\partial X_j}(z, X_{-j})\right] dz$$

Unbiased even with correlated features.

### Saliency and Attribution for Neural Networks

| Method | Approach |
|--------|---------|
| Gradient (Saliency map) | $|\partial \hat{y} / \partial x_j|$; highlights input features by gradient magnitude |
| Integrated Gradients | Integrates gradients from baseline to input; satisfies completeness axiom |
| GradCAM | Class-weighted activation maps; localizes image regions driving predictions |
| LIME for images | Superpixel perturbations; identifies key image regions |

## Global Surrogate Models

Train an interpretable model (e.g., decision tree) to mimic the black-box model's predictions over the entire input space. Explanation quality depends on how well the surrogate approximates the original.

$$R^2_{\text{surrogate}} = 1 - \frac{\sum_i (g(x_i) - \hat{f}(x_i))^2}{\sum_i (\hat{f}(x_i) - \bar{\hat{f}})^2}$$

High $R^2$ means the surrogate is faithful to the original.

## Fairness and Bias

Interpretability enables fairness auditing:
- Inspect SHAP values or PDP for sensitive attributes (age, race, gender).
- **Disparate impact:** $\frac{P(\hat{y}=1 | A=0)}{P(\hat{y}=1 | A=1)}$ should be $\geq 0.8$ (four-fifths rule).
- **Equalized odds:** equalize TPR and FPR across groups.

## Choosing an Explanation Method

| Scenario | Recommended Method |
|----------|-------------------|
| Tree model, any scope | TreeSHAP |
| Any model, local explanation | LIME or KernelSHAP |
| Feature ranking | Permutation importance or mean SHAP |
| Single feature effect | ALE or ICE plot |
| Neural network, image | GradCAM or Integrated Gradients |
| Regulatory requirement (actionable) | Decision rules, scoring systems |
| Debugging / data quality | Residual analysis + SHAP |
