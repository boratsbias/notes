# Model Evaluation

## Concept / Definition

Model evaluation estimates predictive performance under target deployment distribution

Given trained predictor $\hat{f}$, evaluate on unseen data
$$D_{\text{test}} = \{(x_i, y_i)\}_{i=1}^m$$

## Mathematical Formulation

Test risk estimate
$$\hat{R}_{\text{test}}(\hat{f}) = \frac{1}{m} \sum_{i=1}^m \ell(\hat{f}(x_i), y_i)$$

Regression metrics
$$\operatorname{MSE} = \frac{1}{m} \sum_{i=1}^m (\hat{y}_i - y_i)^2$$
$$\operatorname{MAE} = \frac{1}{m} \sum_{i=1}^m |\hat{y}_i - y_i|$$
$$R^2 = 1 - \frac{\sum_i (y_i - \hat{y}_i)^2}{\sum_i (y_i - \bar{y})^2}$$

Confusion matrix entries
$$\text{TP}, \text{FP}, \text{TN}, \text{FN}$$

Classification metrics
$$\operatorname{Precision} = \frac{\text{TP}}{\text{TP}+\text{FP}}, \qquad \operatorname{Recall} = \frac{\text{TP}}{\text{TP}+\text{FN}}$$
$$F_1 = \frac{2PR}{P+R}$$
$$\operatorname{Accuracy} = \frac{\text{TP}+\text{TN}}{\text{TP}+\text{TN}+\text{FP}+\text{FN}}$$

## Conditions / Properties

Unbiasedness requires test data independent of training process

Calibration condition
$$P(Y=1 \mid \hat{p}=q) = q$$

Threshold-free ranking metrics such as ROC-AUC depend on score ordering, not calibration

Under class imbalance,
$$\operatorname{Accuracy}$$
can be high for poor classifier

## Algorithms / Methods

<table>
<tr><th>Metric family</th><th>Formula object</th><th>Best when</th></tr>
<tr><td>Point error</td><td>MSE, MAE, RMSE</td><td>regression</td></tr>
<tr><td>Ranking</td><td>ROC-AUC, PR-AUC</td><td>probabilistic classifiers</td></tr>
<tr><td>Probabilistic</td><td>log loss, Brier score</td><td>calibrated probabilities matter</td></tr>
<tr><td>Set overlap</td><td>IoU, Dice</td><td>segmentation</td></tr>
<tr><td>Retrieval</td><td>Recall@k, MAP, NDCG</td><td>ranking/recommenders</td></tr>
</table>

Log loss
$$\operatorname{LogLoss} = - \frac{1}{m} \sum_{i=1}^m \sum_{k=1}^K y_{ik} \log \hat{p}_{ik}$$

Brier score
$$\operatorname{Brier} = \frac{1}{m} \sum_{i=1}^m (\hat{p}_i - y_i)^2$$

## Variants / Extensions

<table>
<tr><th>Setting</th><th>Preferred evaluation</th><th>Note</th></tr>
<tr><td>Imbalanced classification</td><td>PR-AUC, recall at fixed precision</td><td>ROC can appear optimistic</td></tr>
<tr><td>Cost-sensitive deployment</td><td>expected cost</td><td>use business loss matrix</td></tr>
<tr><td>Distribution shift</td><td>temporal or domain split</td><td>random split insufficient</td></tr>
<tr><td>Uncertainty-aware models</td><td>NLL, calibration error</td><td>evaluate probabilistic outputs</td></tr>
</table>

Expected decision cost
$$\mathbb{E}[C(\hat{Y}, Y)]$$

## Practical Notes

Metric must align with deployment objective

Choose split by data-generating process, not convenience

For temporal data use
$$t_{\text{train}} < t_{\text{valid}} < t_{\text{test}}$$

Confidence intervals via bootstrap useful when performance differences small
