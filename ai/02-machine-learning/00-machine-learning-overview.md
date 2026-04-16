# Machine Learning Overview

## What is Machine Learning?

Machine learning is the study of algorithms that improve their performance on a task through experience. Instead of explicit programming, a model learns a mapping from inputs to outputs (or latent structure) directly from data.

Formally, following Mitchell's definition: a program learns from experience $E$ with respect to task $T$ and performance measure $P$, if its performance at $T$, as measured by $P$, improves with experience $E$.

## The Learning Problem

Given a dataset $\mathcal{D} = \{(x_i, y_i)\}_{i=1}^n$ drawn i.i.d. from an unknown distribution $P(X, Y)$, find a function $f: \mathcal{X} \to \mathcal{Y}$ that generalizes well to unseen data.

**Components:**
- **Input space** $\mathcal{X}$: feature vectors $x \in \mathbb{R}^d$
- **Output space** $\mathcal{Y}$: labels, values, or structure
- **Hypothesis class** $\mathcal{H}$: set of candidate functions the algorithm considers
- **Loss function** $\mathcal{L}(f(x), y)$: measures prediction error
- **Risk** $R(f) = \mathbb{E}_{(x,y) \sim P}[\mathcal{L}(f(x), y)]$: expected loss over the true distribution
- **Empirical risk** $\hat{R}(f) = \frac{1}{n} \sum_{i=1}^n \mathcal{L}(f(x_i), y_i)$: loss on training data

## Types of Machine Learning

| Type | Supervision | Goal | Examples |
|------|-------------|------|---------|
| Supervised | Labeled $(x, y)$ pairs | Learn $f: x \to y$ | Classification, Regression |
| Unsupervised | Unlabeled $x$ only | Discover structure | Clustering, Dimensionality Reduction |
| Semi-supervised | Few labeled, many unlabeled | Leverage both | Label propagation, pseudo-labeling |
| Self-supervised | No labels; supervision from data itself | Learn representations | Contrastive learning, masked modeling |
| Reinforcement | Reward signal from environment | Learn policy | Game playing, robotics |

## Core Algorithms by Task

**Classification:** Logistic Regression, Decision Trees, Random Forests, SVM, k-NN, Naive Bayes, Neural Networks

**Regression:** Linear Regression, Ridge, Lasso, Decision Trees, Gradient Boosted Trees, Neural Networks

**Clustering:** k-Means, DBSCAN, Hierarchical Clustering, Gaussian Mixture Models

**Dimensionality Reduction:** PCA, t-SNE, UMAP, Autoencoders

## The ML Workflow

1. **Problem formulation:** Define task, metric, and data requirements.
2. **Data collection and cleaning:** Handle missing values, outliers, and label noise.
3. **Exploratory Data Analysis (EDA):** Understand distributions, correlations, and class imbalance.
4. **Feature engineering:** Transform raw inputs into informative representations.
5. **Model selection:** Choose hypothesis class appropriate to data size and complexity.
6. **Training:** Minimize empirical risk via optimization (gradient descent, etc.).
7. **Evaluation:** Measure generalization on held-out data.
8. **Hyperparameter tuning:** Search for optimal configuration via validation.
9. **Deployment:** Serve model in production; monitor for distribution shift.

## Generalization and the Goal of Learning

The fundamental goal is **low generalization error**, not just low training error:

$$\text{Generalization gap} = R(f) - \hat{R}(f)$$

**Underfitting:** model too simple to capture true pattern. High training and test error.

**Overfitting:** model fits noise in training data. Low training error, high test error.

The [Bias Variance Tradeoff](07-bias-variance-tradeoff) formalizes this tension.

## No Free Lunch Theorem

No single algorithm is universally best. For any algorithm $A$ that outperforms random guessing on one distribution, there exists another distribution where $A$ performs at most as well as random guessing. Algorithm choice must be guided by inductive bias appropriate for the problem domain.

## Key Assumptions

- **i.i.d. assumption:** training and test data are drawn from the same distribution. Violations lead to distribution shift.
- **Smoothness:** nearby inputs tend to have similar outputs (enables generalization).
- **Finite VC dimension (for PAC learning):** ensures learnability guarantees.

## PAC Learning

**Probably Approximately Correct (PAC)** framework: an algorithm PAC-learns a concept class $\mathcal{C}$ if, given enough samples $n$, it produces a hypothesis $h$ satisfying:

$$P[R(h) \leq \epsilon] \geq 1 - \delta$$

for any $\epsilon, \delta > 0$. The sample complexity is:

$$n \geq \frac{1}{\epsilon}\left(\ln |\mathcal{H}| + \ln \frac{1}{\delta}\right)$$

For infinite hypothesis classes, VC dimension replaces $\ln \lvert\mathcal{H}\rvert$.
