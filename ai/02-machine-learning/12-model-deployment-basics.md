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

<table>
<tr><th>Component</th><th>Technical requirement</th><th>Typical mechanism</th></tr>
<tr><td>Packaging</td><td>reproducible artifact</td><td>serialized weights, container image</td></tr>
<tr><td>Serving</td><td>low-latency inference</td><td>REST, gRPC, batch scoring</td></tr>
<tr><td>Rollout</td><td>controlled exposure</td><td>shadow, canary, A/B test</td></tr>
<tr><td>Monitoring</td><td>drift and failures</td><td>feature stats, latency, error rate</td></tr>
<tr><td>Retraining</td><td>update under drift</td><td>scheduled or trigger-based pipeline</td></tr>
</table>

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

<table>
<tr><th>Variant</th><th>Description</th><th>Use case</th></tr>
<tr><td>Batch inference</td><td>score offline at intervals</td><td>ETL pipelines, ranking refresh</td></tr>
<tr><td>Online inference</td><td>per-request prediction</td><td>realtime APIs</td></tr>
<tr><td>Edge deployment</td><td>on-device model</td><td>privacy, low network dependence</td></tr>
<tr><td>Human-in-the-loop</td><td>model suggests, user confirms</td><td>high-risk decisions</td></tr>
</table>

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
