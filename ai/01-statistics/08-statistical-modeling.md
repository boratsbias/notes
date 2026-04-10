# Statistical Modeling

## Core Idea

Statistical modeling uses probability distributions to describe data-generating processes and make inferences or predictions.

## General Framework

A statistical model consists of:
- **Response variable (dependent):** $Y$ (what we want to predict/explain)
- **Predictor variables (independent):** $X_1, X_2, \ldots, X_p$ (features, covariates)
- **Parameters:** $\theta$ (unknown quantities to estimate)
- **Error term:** $\epsilon$ (unexplained variability)

**General form:**

$$Y = f(X; \theta) + \epsilon$$

## Linear Regression

### Simple Linear Regression

One predictor variable:

$$Y = \beta_0 + \beta_1 X + \epsilon, \quad \epsilon \sim \mathcal{N}(0, \sigma^2)$$

**Parameters:**
- $\beta_0$: intercept (expected $Y$ when $X = 0$)
- $\beta_1$: slope (change in $Y$ per unit change in $X$)

**OLS estimates:**

$$\hat{\beta}_1 = \frac{\sum (x_i - \bar{x})(y_i - \bar{y})}{\sum (x_i - \bar{x})^2}$$

$$\hat{\beta}_0 = \bar{y} - \hat{\beta}_1 \bar{x}$$

### Multiple Linear Regression

Multiple predictors:

$$Y = \beta_0 + \beta_1 X_1 + \cdots + \beta_p X_p + \epsilon$$

**Matrix form:**

$$\mathbf{y} = X\boldsymbol{\beta} + \boldsymbol{\epsilon}$$

**OLS solution:**

$$\hat{\boldsymbol{\beta}} = (X^T X)^{-1} X^T \mathbf{y}$$

**Assumptions:**
1. Linearity: relationship is linear
2. Independence: observations are independent
3. Homoscedasticity: constant error variance
4. Normality: errors are normally distributed
5. No multicollinearity: predictors not perfectly correlated

## Generalized Linear Models (GLMs)

Extension of linear regression for non-normal responses.

**Components:**
1. **Random component:** $Y$ follows exponential family distribution
2. **Systematic component:** Linear predictor $\eta = X\boldsymbol{\beta}$
3. **Link function:** $g(\mu) = \eta$ relates mean to linear predictor

### Logistic Regression

Binary outcome $Y \in \{0, 1\}$:

$$\log\left(\frac{P(Y=1)}{P(Y=0)}\right) = \beta_0 + \beta_1 X_1 + \cdots + \beta_p X_p$$

$$P(Y=1) = \sigma(\mathbf{x}^T \boldsymbol{\beta}) = \frac{1}{1 + e^{-\mathbf{x}^T \boldsymbol{\beta}}}$$

**Likelihood:**

$$L(\boldsymbol{\beta}) = \prod_{i=1}^n P(Y_i=1)^{y_i} (1 - P(Y_i=1))^{1-y_i}$$

**MLE:** Maximize log-likelihood (no closed form, use iterative methods).

### Poisson Regression

Count outcome $Y \in \{0, 1, 2, \ldots\}$:

$$\log(E[Y]) = \beta_0 + \beta_1 X_1 + \cdots + \beta_p X_p$$

$$E[Y] = \exp(\mathbf{x}^T \boldsymbol{\beta})$$

Used for: rate data, count data, contingency tables.

### Multinomial Logistic Regression

Multi-class outcome $Y \in \{1, \ldots, K\}$:

$$P(Y = k) = \frac{e^{\boldsymbol{\beta}_k^T \mathbf{x}}}{\sum_{j=1}^K e^{\boldsymbol{\beta}_j^T \mathbf{x}}}$$

Reference class (usually $K$) has $\boldsymbol{\beta}_K = \mathbf{0}$.

## Model Selection

### Goodness of Fit Measures

**R-squared (coefficient of determination):**

$$R^2 = 1 - \frac{SS_{\text{res}}}{SS_{\text{tot}}} = 1 - \frac{\sum (y_i - \hat{y}_i)^2}{\sum (y_i - \bar{y})^2}$$

Proportion of variance explained by the model.

**Adjusted R-squared:**

$$R^2_{\text{adj}} = 1 - \frac{(1 - R^2)(n - 1)}{n - p - 1}$$

Penalizes for number of predictors.

**AIC (Akaike Information Criterion):**

$$\text{AIC} = 2k - 2\log(\hat{L})$$

where $k$ = number of parameters, $\hat{L}$ = maximized likelihood.

**BIC (Bayesian Information Criterion):**

$$\text{BIC} = k \log(n) - 2\log(\hat{L})$$

Stronger penalty for model complexity than AIC.

### Model Selection Strategies

**Forward selection:** Start with no predictors, add most significant one at a time.

**Backward elimination:** Start with all predictors, remove least significant one at a time.

**Stepwise selection:** Combination of forward and backward.

**Best subset:** Try all possible combinations (computationally expensive).

## Regularization

### Ridge Regression (L2)

$$\hat{\boldsymbol{\beta}} = \arg\min_{\boldsymbol{\beta}} \left[\sum_{i=1}^n (y_i - \mathbf{x}_i^T \boldsymbol{\beta})^2 + \lambda \sum_{j=1}^p \beta_j^2\right]$$

**Solution:**

$$\hat{\boldsymbol{\beta}}_{\text{ridge}} = (X^T X + \lambda I)^{-1} X^T \mathbf{y}$$

**Effect:** Shrinks coefficients toward zero, handles multicollinearity.

### Lasso (L1)

$$\hat{\boldsymbol{\beta}} = \arg\min_{\boldsymbol{\beta}} \left[\sum_{i=1}^n (y_i - \mathbf{x}_i^T \boldsymbol{\beta})^2 + \lambda \sum_{j=1}^p |\beta_j|\right]$$

**Effect:** Produces sparse solutions (some coefficients exactly zero).

Used for: feature selection, high-dimensional settings.

### Elastic Net

Combines L1 and L2:

$$\hat{\boldsymbol{\beta}} = \arg\min_{\boldsymbol{\beta}} \left[\sum_{i=1}^n (y_i - \mathbf{x}_i^T \boldsymbol{\beta})^2 + \lambda_1 \sum_{j=1}^p |\beta_j| + \lambda_2 \sum_{j=1}^p \beta_j^2\right]$$

## Diagnostics

### Residual Analysis

**Residuals:** $e_i = y_i - \hat{y}_i$

**Check:**
- Residuals vs fitted: should show no pattern (linearity)
- Q-Q plot: residuals should follow normal distribution
- Scale-location: constant variance (homoscedasticity)
- Leverage vs residuals: identify influential points

### Multicollinearity

**Variance Inflation Factor (VIF):**

$$\text{VIF}_j = \frac{1}{1 - R_j^2}$$

where $R_j^2$ is from regressing $X_j$ on other predictors.

$\text{VIF} > 5$ or $\text{VIF} > 10$ indicates problematic multicollinearity.

### Cross-Validation

**k-fold CV:**
1. Split data into $k$ folds
2. Train on $k-1$ folds, test on held-out fold
3. Repeat for all folds, average performance

Used for: model selection, hyperparameter tuning, estimating generalization error.

## Missing Data

### Types of Missingness

**MCAR (Missing Completely At Random):** Missingness independent of data.

**MAR (Missing At Random):** Missingness depends on observed data.

**MNAR (Missing Not At Random):** Missingness depends on unobserved data.

### Handling Missing Data

**Listwise deletion:** Remove rows with any missing values (biased if not MCAR).

**Mean/median imputation:** Replace with column mean/median (underestimates variance).

**Multiple imputation:** Create multiple imputed datasets, combine results.

**Model-based:** Use models that handle missing data (e.g., XGBoost).
