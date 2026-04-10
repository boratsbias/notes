# Supervised Learning

Supervised learning trains a model $f_\theta$ on labeled pairs $\{(x_i, y_i)\}_{i=1}^n$ to predict $y$ for unseen $x$. The label $y$ provides direct supervision about the correct output.

$$\hat{\theta} = \arg\min_\theta \frac{1}{n} \sum_{i=1}^n \mathcal{L}(f_\theta(x_i), y_i)$$

## Task Types

| Task | Output $\mathcal{Y}$ | Examples |
|------|---------------------|---------|
| Binary Classification | $\{0, 1\}$ | Spam detection, fraud detection |
| Multi-class Classification | $\{1, \ldots, K\}$ | Image classification, NER |
| Multi-label Classification | $\{0,1\}^K$ | Tagging, multi-disease diagnosis |
| Regression | $\mathbb{R}$ | House price, temperature forecasting |
| Ordinal Regression | ordered categories | Rating prediction |
| Structured Prediction | sequences, trees, graphs | Machine translation, parsing |

## Loss Functions

### Classification Losses

**Binary cross-entropy (log loss):**

$$\mathcal{L} = -\frac{1}{n} \sum_{i=1}^n [y_i \log \hat{p}_i + (1 - y_i) \log(1 - \hat{p}_i)]$$

**Categorical cross-entropy:**

$$\mathcal{L} = -\frac{1}{n} \sum_{i=1}^n \sum_{k=1}^K y_{ik} \log \hat{p}_{ik}$$

**Hinge loss (SVM):**

$$\mathcal{L} = \frac{1}{n} \sum_{i=1}^n \max(0, 1 - y_i f(x_i))$$

### Regression Losses

| Loss | Formula | Notes |
|------|---------|-------|
| MSE | $\frac{1}{n}\sum (y_i - \hat{y}_i)^2$ | Sensitive to outliers |
| MAE | $\frac{1}{n}\sum \|y_i - \hat{y}_i\|$ | Robust to outliers |
| Huber | MSE for $\|e\| \leq \delta$, MAE otherwise | Best of both |
| Log-cosh | $\frac{1}{n}\sum \log\cosh(y_i - \hat{y}_i)$ | Smooth approximation to MAE |

## Core Algorithms

### Linear Models

**Linear Regression:** $\hat{y} = \mathbf{w}^T x + b$. Closed-form solution: $\mathbf{w} = (X^T X)^{-1} X^T y$.

**Logistic Regression:** $\hat{p} = \sigma(\mathbf{w}^T x + b)$ where $\sigma(z) = \frac{1}{1 + e^{-z}}$. Optimized via gradient descent on cross-entropy.

**Ridge Regression (L2):** adds $\lambda \|\mathbf{w}\|_2^2$ to MSE. Shrinks all weights uniformly.

**Lasso (L1):** adds $\lambda \|\mathbf{w}\|_1$. Produces sparse solutions; some weights become exactly zero.

### Tree-based Models

**Decision Tree:** recursively partitions feature space by choosing splits that maximize information gain or minimize Gini impurity.

**Gini impurity:** $G = 1 - \sum_{k=1}^K p_k^2$

**Entropy / information gain:** $H = -\sum_{k=1}^K p_k \log_2 p_k$

Trees overfit easily; mitigated by pruning, min-samples, max-depth constraints.

### Support Vector Machines

Finds the **maximum-margin hyperplane** separating classes:

$$\min_{\mathbf{w},b} \frac{1}{2}\|\mathbf{w}\|^2 \quad \text{s.t.} \quad y_i(\mathbf{w}^T x_i + b) \geq 1$$

**Soft-margin SVM** allows slack variables $\xi_i \geq 0$:

$$\min_{\mathbf{w},b,\xi} \frac{1}{2}\|\mathbf{w}\|^2 + C \sum_i \xi_i$$

**Kernel trick:** replaces $x_i^T x_j$ with $K(x_i, x_j)$ to handle non-linear boundaries implicitly.

| Kernel | Formula |
|--------|---------|
| Linear | $x^T x'$ |
| Polynomial | $(x^T x' + c)^d$ |
| RBF (Gaussian) | $\exp(-\gamma \|x - x'\|^2)$ |
| Sigmoid | $\tanh(\kappa x^T x' + c)$ |

### k-Nearest Neighbors

Predict $y$ for $x$ using the majority vote (classification) or mean (regression) of the $k$ closest training points:

$$\hat{y} = \frac{1}{k} \sum_{i \in \mathcal{N}_k(x)} y_i$$

Non-parametric. No training phase. Inference is $O(nd)$ without indexing structures.

### Naive Bayes

Applies Bayes' theorem with the conditional independence assumption:

$$P(y | x) \propto P(y) \prod_{j=1}^d P(x_j | y)$$

Fast and effective for text classification despite the independence assumption often being violated.

## Inductive Bias

Every supervised learning algorithm encodes assumptions about the true function:

| Algorithm | Inductive Bias |
|-----------|----------------|
| Linear regression | Relationship is linear |
| Decision trees | Axis-aligned splits suffice |
| SVM (RBF kernel) | Nearby points have similar labels |
| Naive Bayes | Features are conditionally independent |
| Neural networks | Hierarchical feature compositions |

## Practical Considerations

- **Class imbalance:** use oversampling (SMOTE), undersampling, or class-weighted loss.
- **Feature scaling:** required for SVMs, k-NN, and linear models; trees are invariant.
- **Missing data:** impute (mean, median, model-based) or use models that handle missingness natively (e.g., XGBoost).
- **Label noise:** robust losses (Huber, MAE), label smoothing, or noise-robust algorithms.

See [Model Evaluation](06-model-evaluation) for performance metrics and [Cross Validation](08-cross-validation) for model selection.
