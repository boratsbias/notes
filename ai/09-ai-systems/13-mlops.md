# MLOps

MLOps (Machine Learning Operations) applies DevOps practices to machine learning to enable rapid, reliable, and repeatable delivery of ML models to production. It bridges the gap between model development and production deployment.

## What MLOps Solves

The "last mile" of ML is operationalization. Research models often work in notebooks but fail in production due to:

- Training-serving skew: different preprocessing in training vs. inference.
- No automated retraining when models drift.
- No monitoring after deployment.
- Manual, error-prone deployment processes.
- Lack of reproducibility.

MLOps addresses all of these with automation, tooling, and organizational practices.

## MLOps Maturity Levels

**Level 0 (Manual):** data scientists train models manually; export to deployment manually. No automation. Common in early-stage projects.

**Level 1 (Automated pipeline):** automated training pipeline triggered by new data. Model artifacts stored and versioned. Still manual deployment gate.

**Level 2 (CI/CD for ML):** continuous integration for training code; automated testing; automated deployment on passing evaluation. Full pipeline automation.

## CI/CD for ML

**Continuous Integration (CI):**
- Unit tests for preprocessing and model components.
- Integration tests for the full pipeline on a small dataset.
- Linting and type checking.
- Triggered on every pull request.

**Continuous Delivery (CD):**
- On merge to main, trigger a training pipeline.
- Automated evaluation gate: only promote if new model improves over baseline.
- Automated staging deployment.
- Canary deployment to production.

**GitHub Actions / GitLab CI / Jenkins** are common CI/CD platforms. Specialized ML CI/CD: Seldon, BentoML, SageMaker Pipelines.

## Model Registry

A centralized versioned store for trained model artifacts.

**Stages:** Staging → Production → Archived.

**Metadata per version:** training run ID, metrics, dataset version, environment, author.

**Promotion workflow:**
1. Training job registers a new model version in Staging.
2. Automated evaluation tests run.
3. A human or automated gate promotes to Production.
4. Old version moves to Archived.

**Tools:** MLflow Model Registry, W&B Model Registry, Hugging Face Hub, SageMaker Model Registry.

## Feature Store in MLOps

The feature store ensures the same feature definitions are used in training and serving, eliminating training-serving skew.

**Write path:** batch jobs or streaming pipelines write to the offline (batch) and online (low-latency) stores.

**Read path (training):** fetch historical point-in-time correct features from the offline store.

**Read path (serving):** fetch current features from the online store with <10ms latency.

**Feature versioning:** features are versioned; a model pins the feature version it was trained with.

## Training-Serving Skew

A common and subtle failure mode. The model's training distribution differs from its serving distribution due to different code paths.

**Causes:**
- Different normalization in training and serving code.
- Feature computed differently (mean of last 30 days vs. cumulative mean).
- Missing feature imputation differs.
- Different tokenizer version.

**Prevention:**
- Shared feature computation code (feature store).
- Automated training-serving consistency tests.
- Log a sample of training features and compare to serving features.

## Model Deployment Strategies

See [Model Serving](04-model-serving) for implementation details.

| Strategy | Traffic | Rollback | Risk |
|----------|---------|---------|------|
| Blue/Green | Instant switch | Instant | Moderate |
| Canary | Gradual ramp | Fast | Low |
| Shadow | 0% production | N/A | Very low |
| Rolling update | One pod at a time | Slow | Moderate |

## Automated Retraining

**Trigger options:**
- Scheduled (daily/weekly cron).
- Drift-based (PSI > threshold).
- Performance-based (accuracy drop).
- Data volume-based (enough new labeled data).

**Automated training pipeline:**
1. New data arrives in the feature store.
2. Pipeline validates data quality.
3. Model retrains on new data.
4. Automated evaluation.
5. Auto-deploy if metrics improve.

## Governance and Compliance

**Model lineage:** trace each production model back to its training data, training code, and evaluation.

**Model cards:** document model purpose, training data, performance across slices, limitations, and intended use.

**Audit trail:** who deployed what model when. Required for financial and medical AI.

**Bias and fairness audits:** evaluate model performance across protected attributes before deployment.

**Right to explanation (GDPR Art. 22):** models making consequential automated decisions must provide explanations. Requires integrated explainability (SHAP, LIME) in the serving pipeline.

## MLOps Tools Ecosystem

| Category | Tools |
|----------|-------|
| Experiment tracking | MLflow, W&B, Comet |
| Pipeline orchestration | Airflow, Kubeflow, Metaflow, ZenML |
| Feature store | Feast, Tecton, Hopsworks |
| Model registry | MLflow, W&B, Hugging Face Hub |
| Serving | TorchServe, Triton, Ray Serve, vLLM |
| Monitoring | Evidently, Arize, WhyLabs |
| CI/CD | GitHub Actions, Seldon, BentoML |
| Data versioning | DVC, Delta Lake, LakeFS |
