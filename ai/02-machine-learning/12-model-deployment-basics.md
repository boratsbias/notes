# Model Deployment Basics

## What does it mean to deploy a model?

Model deployment is the process of making a trained model available for use in production systems. A model that never serves real users has no impact. Deployment bridges the gap between offline experimentation and online value, and introduces challenges absent during research: latency, reliability, scalability, and distribution shift.

## Deployment Patterns

### Batch Inference

Model runs on a fixed dataset on a schedule (hourly, daily). Results are stored in a database and consumed by downstream systems.

**Use cases:** churn prediction, credit scoring, recommendation precomputation.

**Advantages:** high throughput, simple infrastructure, easy debugging.

**Limitations:** predictions can be stale; not suitable for real-time decisions.

### Online (Real-Time) Inference

Model receives a single request and returns a prediction within a latency budget (typically $<$ 100ms for user-facing, $<$ 10ms for high-frequency trading).

**Infrastructure:** REST API or gRPC service wrapping the model.

**Use cases:** fraud detection, search ranking, ad serving, NLP text completion.

**Challenges:** latency SLA, concurrency, fault tolerance, cold start.

### Streaming Inference

Inference over a continuous stream of events (Kafka, Kinesis). Model is invoked per event or per micro-batch.

**Use cases:** real-time anomaly detection, fraud monitoring, live recommendation updates.

### Edge Inference

Model runs on-device (phone, IoT sensor, browser) to avoid network latency and preserve privacy.

**Requirements:** small model size, low memory, low power. Achieved via quantization, pruning, knowledge distillation.

## Serving Infrastructure

### REST API

Most common serving pattern. Wrap model in a web service:

```
POST /predict
Content-Type: application/json

{"features": [0.5, 1.2, -0.3]}

→ {"score": 0.87, "label": "positive"}
```

Frameworks: FastAPI, Flask, BentoML, Seldon Core.

### Model Servers

Dedicated model serving systems with built-in batching, versioning, and monitoring:

| Server | Origin | Notes |
|--------|--------|-------|
| TensorFlow Serving | Google | TF/SavedModel native |
| TorchServe | Meta/AWS | PyTorch native |
| Triton Inference Server | NVIDIA | Multi-framework; GPU batching |
| MLflow Models | Databricks | Model registry + serving |
| Ray Serve | Anyscale | Composable pipelines |

### Feature Store

Centralized repository that computes, stores, and serves features consistently between training and serving.

**Training-serving skew:** one of the most common production bugs. Features computed differently in training vs. serving lead to degraded performance. Feature stores solve this by enforcing a single feature definition.

**Examples:** Feast, Tecton, Hopsworks, Vertex AI Feature Store.

## ML Pipeline

Production ML is more than just a model. The full pipeline:

1. **Data ingestion:** pull from databases, event streams, or APIs.
2. **Preprocessing and feature engineering:** must match training exactly.
3. **Model inference:** execute forward pass.
4. **Post-processing:** threshold, calibrate, rank.
5. **Logging:** record request, prediction, and metadata.
6. **Monitoring:** detect drift, errors, latency violations.

Pipelines are orchestrated with Airflow, Prefect, Kubeflow Pipelines, or Metaflow.

## Model Packaging

A deployable model artifact bundles the model weights + any preprocessing steps.

| Format | Ecosystem | Notes |
|--------|-----------|-------|
| `pickle` / `joblib` | scikit-learn | Simple; version-sensitive |
| ONNX | Cross-framework | Framework-agnostic; supports runtime optimization |
| TorchScript | PyTorch | JIT-compiled; deployable without Python |
| SavedModel | TensorFlow | Self-contained; includes serving signatures |
| MLflow Model | MLflow | Flavor-agnostic with metadata |

## Latency Optimization

| Technique | Description |
|-----------|-------------|
| Model quantization | Reduce weight precision (FP32 to INT8). Speedup $2\text{-}4\times$, minimal accuracy loss. |
| Knowledge distillation | Train small student model to mimic large teacher. |
| Pruning | Remove near-zero weights or entire neurons/heads. |
| Batching | Group multiple requests; amortize overhead. |
| Caching | Cache predictions for frequent or identical inputs. |
| Hardware acceleration | GPU, TPU, FPGA, specialized inference chips. |
| ONNX Runtime | Fuses ops and applies hardware-specific kernels. |

## Versioning and A/B Testing

**Model versioning:** track model artifacts alongside their training code, data, and hyperparameters. Tools: MLflow, DVC, Weights & Biases Model Registry.

**A/B testing:** route a fraction of traffic to the new model, compare metrics against the control (old model). Requires statistical testing to declare significance. See [Hypothesis Testing](../../01-statistics/07-hypothesis-testing).

**Canary deployment:** release new model to a small percentage of traffic first; roll back if metrics degrade.

**Shadow mode:** new model receives traffic and logs predictions but does not serve results to users. Useful for validating without risk.

## Monitoring in Production

**Data drift:** input distribution $P(X)$ shifts over time. Detect via statistical tests (KS test, Population Stability Index).

$$\text{PSI} = \sum_{i=1}^k (A_i - E_i) \ln\frac{A_i}{E_i}$$

PSI $< 0.1$: no drift; $0.1$-$0.2$: moderate; $> 0.2$: significant.

**Concept drift:** relationship $P(Y|X)$ changes. Harder to detect without ground truth labels. Proxy: monitor prediction distribution shifts.

**Performance monitoring:** track live metrics (accuracy, AUC, F1) using delayed ground truth labels. Set up alerts on degradation thresholds.

**Infrastructure monitoring:** latency (p50, p95, p99), error rate, throughput, memory/CPU usage.

**Types of drift:**

| Type | What changes | Detection |
|------|-------------|-----------|
| Covariate shift | $P(X)$ | Feature distribution statistics |
| Label shift | $P(Y)$ | Prediction distribution |
| Concept drift | $P(Y \mid X)$ | Performance on labeled samples |
| Upstream data change | Pipeline or schema | Data validation (Great Expectations) |

## MLOps Maturity

| Level | Capability |
|-------|-----------|
| 0 | Manual, notebook-based, no automation |
| 1 | Automated training pipeline; manual deployment |
| 2 | Automated training + deployment (CI/CD for ML) |
| 3 | Continuous training triggered by drift or scheduled retraining |

Full MLOps includes: experiment tracking, model registry, automated retraining, drift detection, rollback automation, and lineage tracking.

## Responsible Deployment Checklist

- Model performance evaluated on held-out test set before deployment.
- Fairness audited across demographic groups. See [Model Interpretability](11-model-interpretability).
- Prediction explanations available for high-stakes decisions.
- Fallback logic in place (rule-based or previous model version).
- Rate limits and abuse prevention implemented.
- Privacy: PII not logged in raw form; compliance with GDPR / CCPA.
- Rollback plan documented and tested.
