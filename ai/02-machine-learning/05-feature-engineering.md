# Feature Engineering

## Core Idea

Feature engineering is the process of transforming raw data into representations that make learning easier for a model.

Good features can greatly improve performance, especially for classical machine learning methods.

## Why Features Matter

Models do not see the world directly. They only see the numerical representation we provide.

Bad features can hide useful structure. Good features can expose patterns that are easier to learn.

## Common Operations

### Scaling

Many models work better when numerical features have comparable ranges.

Common choices:

- standardization

$$x' = \frac{x - \mu}{\sigma}$$

- min-max scaling

$$x' = \frac{x - x_{\min}}{x_{\max} - x_{\min}}$$

### Encoding Categorical Variables

Common methods:

- one-hot encoding
- ordinal encoding
- target encoding

### Missing Value Handling

Options include:

- mean or median imputation
- model-based imputation
- adding missing indicators

### Transformations

Useful transformations include:

- logarithm for skewed variables
- polynomial features
- interaction terms
- binning

## Domain-Specific Features

Examples:

- text: TF-IDF, n-grams
- time series: lags, rolling averages, seasonal indicators
- images: classical descriptors such as HOG or SIFT
- graphs: degree, centrality, local motifs

## Feature Selection

Not all features are useful.

Feature selection can:

- reduce overfitting
- improve interpretability
- reduce computation

Common methods:

- filter methods using correlation or mutual information
- wrapper methods
- embedded methods such as L1 regularization

## Risks

- data leakage if features use future information
- overly manual features that do not generalize
- redundant features that increase noise

## Classical vs Deep Learning

Classical ML often depends strongly on manual feature engineering.

Deep learning reduces this dependence by learning representations automatically, but feature quality and preprocessing still matter.
