# Model Interpretability

## Core Idea

Model interpretability is the study of how and why a model makes its predictions.

Interpretability matters when decisions affect trust, debugging, fairness, safety, or regulation.

## Two Broad Types

### Intrinsic Interpretability

Some models are understandable by design.

Examples:

- linear regression
- shallow decision trees
- rule-based models

### Post-Hoc Interpretability

For complex models, we analyze the trained system after learning.

Examples:

- feature importance
- partial dependence
- saliency maps
- local surrogate explanations

## Global vs Local Explanations

### Global

Explain the model behavior overall.

Questions:

- which features matter most on average
- what kind of structure did the model learn

### Local

Explain one specific prediction.

Questions:

- why was this loan denied
- why was this image classified as a cat

## Common Methods

### Coefficients and Rules

Linear weights and explicit rules are often easy to inspect, though interpretation can still be distorted by correlated features.

### Permutation Importance

Measure performance drop when a feature is shuffled.

### SHAP and Related Methods

Estimate feature contributions to individual predictions.

### Partial Dependence

Show how predictions change as one feature varies while others are averaged out.

## Cautions

Interpretability tools can be misleading if:

- features are strongly correlated
- explanations are unstable
- the explanation method makes its own assumptions

An explanation is not automatically a causal statement.

## Why It Matters

Interpretability helps with:

- debugging data leakage
- identifying spurious correlations
- communicating with domain experts
- satisfying accountability requirements
