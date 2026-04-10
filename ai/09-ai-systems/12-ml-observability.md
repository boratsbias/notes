# ML Observability

ML observability provides end-to-end visibility into the behavior of production ML systems. It extends software observability (metrics, logs, traces) with ML-specific concerns: data quality, feature drift, prediction quality, and model behavior.

## The Three Pillars of Observability (Extended for ML)

**Metrics:** aggregated numerical measurements. Request count, latency P99, GPU utilization, prediction distribution mean, drift score.

**Logs:** timestamped events with structured context. Each prediction request logged with input features, output, confidence, latency, model version.

**Traces:** distributed request traces linking all services involved in a single prediction (API gateway → feature store → model server → response). Identifies bottlenecks and errors in multi-service pipelines.

**ML additions:**
- Feature distributions.
- Prediction distributions.
- Ground-truth labels (when available with delay).
- Model explanations (SHAP values, attention).

## Data Observability

**Column-level checks:**
- Completeness: null rate.
- Distinctness: unique value count.
- Freshness: time since last update.
- Volume: row count change.
- Distribution: mean, std, quantiles.

**Table-level checks:**
- Row count anomalies.
- Schema changes (added/dropped columns).
- Cross-column correlations shift.

**Tools:** Monte Carlo, Soda Core, Great Expectations, Anomalo.

**Lineage tracking:** trace each dataset artifact back to its source data and transformation code. Critical for debugging data issues ("where did this bad feature come from?").

## Feature Observability

Monitor the distribution of features at inference time vs. training time.

**Reference distribution:** compute feature statistics from the training set or a stable recent window.

**Drift detection:** run statistical tests (KS test, PSI, chi-squared) on incoming feature batches.

**Alerting:** alert when drift exceeds a threshold per feature. Prioritize features by their predictive importance (SHAP global importance).

**Feature store observability:** track feature freshness (how recently was the feature value computed?). Stale features are a common production bug.

## Prediction Observability

Monitor the output distribution of the model.

**Prediction confidence distribution:** histogram of model output probabilities. If the model is over-confident or under-confident, the distribution shifts.

**Output anomalies:** unusually high rates of extreme predictions (all confidence = 0.99, all predictions = class 0).

**Concept drift proxy:** when labels are not available, prediction drift is used as a proxy. Large shifts in output distribution often correlate with concept drift.

## Explainability in Production

Understanding why a model made a specific prediction is important for debugging and stakeholder trust.

**SHAP (SHapley Additive exPlanations):** assigns each feature a contribution value for a given prediction based on Shapley values from cooperative game theory.

$$\phi_i = \sum_{S \subseteq F \setminus \{i\}} \frac{|S|!(|F|-|S|-1)!}{|F|!} [f(S \cup \{i\}) - f(S)]$$

**LIME (Local Interpretable Model-agnostic Explanations):** fit a simple linear model locally around the prediction point. Fast; less faithful for complex models.

**Integrated Gradients:** computes the path integral of the gradient of the output w.r.t. the input from a baseline. Faithful; works for neural networks.

**Production explainability:** compute and log SHAP values for each prediction. Surface in dashboards for debugging anomalies. Log explanations for audit trails in regulated industries.

## Distributed Tracing for ML

Instrument the serving pipeline to trace the journey of each request.

**OpenTelemetry:** vendor-neutral tracing instrumentation. Spans for each service (preprocessing, model inference, postprocessing). Propagate trace IDs across service boundaries.

**Jaeger / Zipkin:** distributed tracing backends. Visualize end-to-end latency breakdown.

**ML-specific spans:** log model version, input feature hash, prediction, and confidence as span attributes.

## Log Management

**Structured logging:** log in JSON format. Fields: timestamp, request\_id, model\_version, input\_features, prediction, confidence, latency\_ms, user\_id.

**Centralized log aggregation:** Elasticsearch + Kibana (ELK stack), Grafana Loki, Splunk, Datadog Logs.

**Log sampling:** for high-QPS systems, log 100% of anomalous requests but only 1-5% of normal requests. Reduces storage cost; preserves coverage of rare events.

**Retention policy:** full logs for 30-90 days; aggregate metrics indefinitely.

## Alerting and Incident Response

**Define SLOs (Service Level Objectives):** e.g., P99 latency < 200ms; error rate < 0.1%; feature null rate < 1%.

**Alert routing:** data drift alerts → ML team; latency alerts → infrastructure team; business metric alerts → product team.

**Runbooks:** document the response procedure for each alert type. Reduces time-to-resolution.

**Incident postmortem:** after each incident, document the timeline, root cause, and corrective actions. Prevents recurrence.
