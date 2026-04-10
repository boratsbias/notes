# Feature Engineering

## Core Idea

Feature engineering transforms raw input data into representations that are more informative for a learning algorithm. Even powerful models benefit from well-engineered features; poor representations can make a problem unlearnable regardless of model capacity.

> "Applied machine learning is basically feature engineering." — Andrew Ng

## Feature Types

| Type | Description | Examples |
|------|-------------|---------|
| Numerical | Continuous or discrete numbers | Age, price, count |
| Categorical | Discrete unordered values | Country, product category |
| Ordinal | Discrete ordered values | Rating (1-5), education level |
| Text | Sequences of tokens | Reviews, documents |
| Temporal | Time-indexed values | Timestamps, time series |
| Geospatial | Coordinates or regions | Lat/lon, postal codes |
| Image / Audio | Raw tensors | Pixel arrays, waveforms |

## Numerical Feature Transformations

### Scaling

Required for distance-based and gradient-based methods. Trees are invariant to monotone transformations.

**Standard scaling (z-score):**

$$x' = \frac{x - \mu}{\sigma}$$

Results in zero mean and unit variance. Sensitive to outliers.

**Min-max scaling:**

$$x' = \frac{x - x_{\min}}{x_{\max} - x_{\min}}$$

Maps to $[0, 1]$. Sensitive to outliers.

**Robust scaling:**

$$x' = \frac{x - \text{median}(x)}{\text{IQR}(x)}$$

Uses interquartile range; robust to outliers.

**Log transform:** $x' = \log(x + 1)$. Reduces right skew; requires $x \geq 0$.

**Box-Cox transform:**

$$x'(\lambda) = \begin{cases} \frac{x^\lambda - 1}{\lambda} & \lambda \neq 0 \\ \log x & \lambda = 0 \end{cases}$$

Finds optimal $\lambda$ to normalize distribution. Requires $x > 0$.

**Yeo-Johnson:** generalization of Box-Cox that handles $x \leq 0$.

### Binning / Discretization

Converts continuous feature to ordinal categories. Reduces sensitivity to outliers and can expose non-linear relationships for linear models.

- **Fixed-width bins:** equal-size intervals.
- **Quantile bins:** equal-frequency intervals (handles skew better).

## Categorical Feature Encoding

### One-Hot Encoding

Creates a binary indicator for each category. For $K$ categories: $K$ binary columns (or $K-1$ to avoid multicollinearity).

$$\text{cat} \in \{A, B, C\} \to [1, 0, 0], [0, 1, 0], [0, 0, 1]$$

Appropriate when categories have no natural order. Explodes dimensionality for high-cardinality features.

### Ordinal Encoding

Maps categories to integers preserving order. Only use when order is meaningful.

### Target Encoding (Mean Encoding)

Replace each category with the mean target value in that category:

$$\text{enc}(c) = \frac{\sum_{i: x_i = c} y_i}{|\{i: x_i = c\}|}$$

Risk of target leakage. Use cross-validation or smoothing:

$$\text{enc}(c) = \frac{n_c \cdot \bar{y}_c + \lambda \cdot \bar{y}_{\text{global}}}{n_c + \lambda}$$

### Embedding

Learned dense vectors for high-cardinality categoricals (e.g., user ID, product ID). Standard in deep learning; can be pre-trained (word2vec, GloVe) or learned end-to-end.

### Hashing Trick

Maps categories to a fixed-size vector of length $m$ via a hash function. No vocabulary needed; handles unseen categories. Risk of collisions.

## Temporal Features

From timestamps, extract:
- **Calendar features:** hour, day-of-week, month, quarter, year, is_holiday
- **Cyclical encoding:** encode periodic features as $(\sin, \cos)$ pairs to preserve continuity

$$\text{hour\_sin} = \sin\!\left(\frac{2\pi \cdot \text{hour}}{24}\right), \quad \text{hour\_cos} = \cos\!\left(\frac{2\pi \cdot \text{hour}}{24}\right)$$

- **Lag features:** $x_{t-1}, x_{t-2}, \ldots$ for time series.
- **Rolling statistics:** rolling mean, std, min, max over a window.
- **Time since event:** days since last purchase, etc.

## Feature Interactions

**Polynomial features:** expand $[x_1, x_2]$ to $[x_1, x_2, x_1^2, x_1 x_2, x_2^2]$. Allows linear models to capture nonlinear relationships.

**Cross features:** explicit products of two categorical or numerical features.

**Ratio features:** $x_1 / x_2$ can capture meaningful relationships (e.g., debt-to-income ratio).

## Feature Selection

Reduces dimensionality, removes irrelevant/noisy features, and speeds up training.

| Method | Approach |
|--------|---------|
| Filter (variance threshold) | Remove features with variance below threshold |
| Filter (correlation) | Remove features highly correlated with each other |
| Univariate statistical test | Select by $\chi^2$, ANOVA $F$-statistic, mutual information with target |
| Recursive Feature Elimination (RFE) | Repeatedly train and remove weakest features |
| L1 regularization (Lasso) | Drives irrelevant feature weights to zero |
| Tree-based importance | Rank by impurity decrease (Gini/entropy) or permutation importance |
| SHAP values | Model-agnostic, measures each feature's marginal contribution |

## Handling Missing Values

| Strategy | When to Use |
|----------|------------|
| Mean / median imputation | Numerical features, MCAR/MAR assumption |
| Mode imputation | Categorical features |
| Indicator feature | Add binary "was\_missing" column alongside imputed value |
| Model-based imputation | MICE, KNN imputation |
| Drop rows | Very few missing, missing not at random |
| Drop feature | High fraction missing with no predictive value |

## Text Features

**Bag of Words (BoW):** count matrix over vocabulary. Sparse, ignores order.

**TF-IDF:**

$$\text{tf-idf}(t, d) = \text{tf}(t, d) \cdot \log \frac{N}{\text{df}(t)}$$

Downweights common terms. Better than raw counts for retrieval and classification.

**N-grams:** captures local word context. Bigrams, trigrams added to vocabulary.

**Word embeddings:** dense representations from word2vec, GloVe, fastText. Average or pool over tokens for document representation.

**Sentence/document embeddings:** BERT CLS token, Sentence-BERT, or bag of word-embeddings.

## Feature Engineering Principles

- Features should encode domain knowledge that the model cannot easily learn on its own from raw inputs.
- Always transform training features and apply the same transformation to test/production features (fit on train only).
- Check for data leakage: no feature should encode information about the future or the target itself.
- High-cardinality features require special treatment to avoid overfitting.
