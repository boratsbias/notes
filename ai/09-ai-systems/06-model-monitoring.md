# Model Monitoring

Model monitoring tracks the health of deployed models over time. Production models degrade as the world changes; monitoring detects degradation early so corrective action can be taken.

## Why Models Degrade

**Data drift:** the distribution of input features $P(X)$ changes over time. The model was trained on past data; present data looks different.

**Concept drift:** the relationship between inputs and outputs $P(Y|X)$ changes. For example, spam patterns change as spammers adapt; consumer behavior shifts seasonally.

**Label distribution shift:** the frequency of target classes changes ($P(Y)$ changes). A fraud model trained on 1% fraud rate may encounter 3% fraud during a fraud campaign.

**Upstream data issues:** a feature pipeline breaks; missing fields, schema changes, or incorrect aggregations silently corrupt inputs.

## Monitoring Categories

### Infrastructure Metrics

Hardware and service health. Monitored by platform teams.

- GPU/CPU utilization, memory usage.
- Request latency (P50, P95, P99).
- Error rate (HTTP 5xx, exception counts).
- Throughput (requests per second).

### Data Drift

Statistical comparison of current input distributions to a reference (training data or recent healthy window).

**Population Stability Index (PSI):**

$$\text{PSI} = \sum_{i} (A_i - E_i) \ln\!\left(\frac{A_i}{E_i}\right)$$

$A_i$: actual fraction in bin $i$. $E_i$: expected fraction. PSI < 0.1: no drift; 0.1-0.2: moderate; > 0.2: significant drift.

**KL Divergence / Wasserstein distance:** compare current and reference distributions. More sensitive than PSI.

**Kolmogorov-Smirnov test:** non-parametric test for distribution shift in continuous features.

**Chi-squared test:** categorical feature distribution shift.

### Prediction Drift

Monitor the distribution of model outputs/predictions.

- Distribution of predicted probabilities.
- Distribution of predicted classes.
- Mean prediction score over time.

If predictions shift significantly without a corresponding ground-truth shift, it may indicate input drift or model issues.

### Model Performance Metrics

Compare predictions to ground truth when labels become available (often with a delay).

- Classification: accuracy, F1, AUC.
- Regression: MAE, RMSE.
- Ranking: NDCG, MRR.

**Label delay:** labels may not be immediately available (e.g., churn: customer label is known months later). Design for delayed feedback.

## Monitoring Workflow

```
Production requests
  → Log (inputs, outputs, metadata)
  → Feature drift detection (statistical tests)
  → Prediction drift detection
  → Performance monitoring (when labels arrive)
  → Alert if threshold exceeded
  → Trigger retraining or investigation
```

## Alerting

**Threshold-based:** alert when a metric exceeds a fixed threshold. Simple but prone to false positives from seasonal patterns.

**Anomaly detection:** model the expected metric distribution; alert on statistical outliers. More adaptive.

**Integration:** PagerDuty, OpsGenie, Slack webhooks, Datadog, Grafana.

## Tools

| Tool | Focus |
|------|-------|
| Evidently AI | Open-source drift + quality reports |
| Arize | LLM and classical model monitoring |
| WhyLabs | Data logging, drift, explainability |
| Fiddler | Bias, explainability, performance |
| Prometheus + Grafana | Infrastructure + custom metrics |
| MLflow | Experiment tracking (limited monitoring) |

## Shadow Mode Testing

Run a new model in shadow mode alongside the production model: both process every request, but only the production model's output is returned. Compare offline metrics.

Safer than A/B testing for high-stakes decisions (medical, financial) since the new model's output cannot cause harm.

## Retraining Triggers

**Scheduled retraining:** retrain on a fixed schedule (weekly, monthly). Simple; may miss rapid drift.

**Performance-based:** retrain when monitored metrics fall below a threshold.

**Drift-based:** retrain when data drift exceeds a threshold, even before labels arrive.

**Continuous training:** stream new data into a replay buffer; retrain incrementally (online learning or periodic micro-fine-tunes).
