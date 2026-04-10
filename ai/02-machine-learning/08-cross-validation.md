# Cross Validation

## Concept / Definition

Cross-validation estimates out-of-sample performance by repeated train-validation splitting

Given dataset
$$
D = \{(x_i, y_i)\}_{i=1}^n
$$
partition into folds
$$
D = \bigsqcup_{j=1}^K D_j
$$

## Mathematical Formulation

$K$-fold CV estimate
$$
\widehat{R}_{\text{CV}} = \frac{1}{K} \sum_{j=1}^K \frac{1}{|D_j|} \sum_{(x_i,y_i) \in D_j} \ell(\hat{f}^{(-j)}(x_i), y_i)
$$
where $\hat{f}^{(-j)}$ is trained on $D \setminus D_j$

LOOCV special case
$$
K = n
$$

Nested CV for hyperparameter selection
$$
\hat{\lambda}^{(-j)} = \arg\min_{\lambda \in \Lambda} \widehat{R}_{\text{inner}}^{(-j)}(\lambda)
$$

## Conditions / Properties

Random folds assume exchangeable observations

For class imbalance use stratified folds preserving
$$
P(Y=k)
$$

For grouped data require
$$
g_i = g_{i'}
$$
never split across train and validation if observations share entity

For temporal data random CV invalid when future leaks into past

Bias-variance profile:
$$
K \uparrow \Rightarrow \text{estimate bias} \downarrow, \quad \text{estimate variance} \uparrow
$$

## Algorithms / Methods

| Method | Split rule | Use case |
|---|---|---|
| Holdout | one train-valid split | fast baseline |
| k-fold | equal partitions | standard tabular evaluation |
| Stratified k-fold | preserve class ratios | classification |
| Group k-fold | split by group id | patient/user/item leakage control |
| Time-series CV | forward chaining | temporal dependence |

Forward-chaining folds
$$
D_{\text{train}}^{(t)} = \{1,\dots,t\}, \qquad D_{\text{valid}}^{(t)} = \{t+1,\dots,t+h\}
$$

## Variants / Extensions

| Variant | Main change | Benefit |
|---|---|---|
| Repeated k-fold | repeat random partitions | lower Monte Carlo variance |
| Monte Carlo CV | random subsampling | flexible split ratio |
| Nested CV | inner tuning + outer evaluation | unbiased model selection estimate |
| Blocked CV | contiguous blocks | dependent observations |

## Practical Notes

All preprocessing must be fit inside each training fold

Model selection on same folds used for final reporting gives optimistic estimate unless nested CV or held-out test set used

Computation cost roughly
$$
O(K \times \text{training cost})
$$

After tuning, retrain chosen model on full training data before test evaluation
