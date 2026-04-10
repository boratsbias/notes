# Model Deployment Basics

## Concept / Definition

Model deployment serves trained predictor in production environment under latency, reliability, and monitoring constraints

Prediction service
$$
\hat{y} = f_{\theta^\ast}(x; v)
$$
where $v$ denotes code, feature, and model artifact version

## Mathematical Formulation

Online inference objective
$$
\min \operatorname{Latency}(f) \quad \text{s.t.} \quad \operatorname{Quality}(f) \ge q_{\min}
$$

Expected production loss
$$
R_{\text{prod}} = \mathbb{E}_{(X,Y) \sim P_{\text{prod}}}[\ell(f(X),Y)]
$$

Covariate shift detection compares
$$
P_{\text{train}}(X) \neq P_{\text{prod}}(X)
$$

Calibration under deployment threshold $\tau$
$$
\hat{y} = \mathbb{1}[p_\theta(y=1 \mid x) \ge \tau]
$$

## Conditions / Properties

Training-serving skew must satisfy
$$
\phi_{\text{train}}(x) = \phi_{\text{serve}}(x)
$$
for same raw input definition

Reproducibility requires versioning of
$$
(\text{data}, \text{features}, \text{code}, \text{weights}, \text{config})
$$

Monitoring should track performance proxies even when labels delayed

Rollback path required when new model violates service or business constraints

## Algorithms / Methods

| Component | Technical requirement | Typical mechanism |
|---|---|---|
| Packaging | reproducible artifact | serialized weights, container image |
| Serving | low-latency inference | REST, gRPC, batch scoring |
| Rollout | controlled exposure | shadow, canary, A/B test |
| Monitoring | drift and failures | feature stats, latency, error rate |
| Retraining | update under drift | scheduled or trigger-based pipeline |

Population Stability Index for binned feature
$$
\operatorname{PSI} = \sum_{b} (p_b - q_b)\log\frac{p_b}{q_b}
$$
where $p_b$ is train proportion and $q_b$ is production proportion

A/B decision metric
$$
\Delta = \hat{M}_{\text{new}} - \hat{M}_{\text{old}}
$$

## Variants / Extensions

| Variant | Description | Use case |
|---|---|---|
| Batch inference | score offline at intervals | ETL pipelines, ranking refresh |
| Online inference | per-request prediction | realtime APIs |
| Edge deployment | on-device model | privacy, low network dependence |
| Human-in-the-loop | model suggests, user confirms | high-risk decisions |

## Practical Notes

Feature store or shared preprocessing code reduces train-serve mismatch

Monitor:
$$
\text{latency}, \text{throughput}, \text{error rate}, \text{input drift}, \text{calibration}, \text{business KPI}
$$

Delayed labels require proxy metrics and backfilled evaluation

Compression methods
$$
\text{quantization}, \text{pruning}, \text{distillation}
$$
trade small quality loss for large serving gain
