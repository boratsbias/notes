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

<table>
<tr><th>Method</th><th>Split rule</th><th>Use case</th></tr>
<tr><td>Holdout</td><td>one train-valid split</td><td>fast baseline</td></tr>
<tr><td>k-fold</td><td>equal partitions</td><td>standard tabular evaluation</td></tr>
<tr><td>Stratified k-fold</td><td>preserve class ratios</td><td>classification</td></tr>
<tr><td>Group k-fold</td><td>split by group id</td><td>patient/user/item leakage control</td></tr>
<tr><td>Time-series CV</td><td>forward chaining</td><td>temporal dependence</td></tr>
</table>

Forward-chaining folds
$$
D_{\text{train}}^{(t)} = \{1,\dots,t\}, \qquad D_{\text{valid}}^{(t)} = \{t+1,\dots,t+h\}
$$

## Variants / Extensions

<table>
<tr><th>Variant</th><th>Main change</th><th>Benefit</th></tr>
<tr><td>Repeated k-fold</td><td>repeat random partitions</td><td>lower Monte Carlo variance</td></tr>
<tr><td>Monte Carlo CV</td><td>random subsampling</td><td>flexible split ratio</td></tr>
<tr><td>Nested CV</td><td>inner tuning + outer evaluation</td><td>unbiased model selection estimate</td></tr>
<tr><td>Blocked CV</td><td>contiguous blocks</td><td>dependent observations</td></tr>
</table>

## Practical Notes

All preprocessing must be fit inside each training fold

Model selection on same folds used for final reporting gives optimistic estimate unless nested CV or held-out test set used

Computation cost roughly
$$
O(K \times \text{training cost})
$$

After tuning, retrain chosen model on full training data before test evaluation
