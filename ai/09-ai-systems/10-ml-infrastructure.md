# ML Infrastructure

ML infrastructure is the collection of systems and tools that support the full ML lifecycle: data storage, compute, training, serving, and tooling. A well-designed ML platform reduces friction for practitioners and increases reliability.

## Components of ML Infrastructure

```
Storage layer
  ├── Data lake (S3, GCS, Azure Blob)
  ├── Data warehouse (BigQuery, Snowflake, Redshift)
  ├── Feature store (Feast, Tecton)
  └── Model/artifact store (MLflow, W&B)

Compute layer
  ├── Training cluster (GPU/TPU nodes)
  ├── Serving cluster (Kubernetes + GPUs)
  └── Batch processing (Spark, Dataflow)

Orchestration layer
  ├── Pipeline orchestrator (Airflow, Kubeflow, Metaflow)
  └── Experiment scheduler (SLURM, Ray)

Developer tooling
  ├── Notebooks (JupyterHub, SageMaker Studio)
  ├── Experiment tracking (MLflow, W&B)
  └── CI/CD (GitHub Actions, Jenkins)
```

## Cloud ML Platforms

**AWS SageMaker:** end-to-end managed ML platform. SageMaker Studio (notebooks), SageMaker Training (managed training jobs), SageMaker Pipelines (pipeline orchestration), SageMaker Model Registry, SageMaker Endpoints (serving).

**Google Vertex AI:** Managed training, hyperparameter tuning, pipelines (Kubeflow-based), model registry, and endpoints. Tight integration with BigQuery and GCS.

**Azure ML:** end-to-end ML platform on Azure. Workspaces, datasets, environments, pipelines, model registry, endpoints.

**Databricks:** Unified data + AI platform. MLflow integration, distributed Spark compute, Delta Lake, Unity Catalog.

## Storage Architecture

**Data lake:** raw, unprocessed data in object storage. Cheap; any schema. Used for archiving and feeding the feature pipeline.

**Data warehouse:** structured, query-optimized columnar storage. SQL access; used for analytics and offline feature computation.

**Lakehouse (Delta Lake, Apache Iceberg):** combines data lake flexibility with data warehouse ACID transactions. UPSERT, DELETE, time travel on raw files.

**Object storage (S3/GCS):** stores model checkpoints, training datasets, artifacts. Virtually unlimited scale; cheap cold storage.

## Compute Management

**Instance types for ML:**

| Task | Preferred instance | Notes |
|------|--------------------|-------|
| Large model training | A100 80GB, H100 | NVLink interconnect, multi-node |
| Fine-tuning | A100 40GB, A10G | Single node often sufficient |
| Online serving | A10G, T4, CPU | Cost-efficient for low latency |
| Batch inference | A100 80GB | Maximize throughput |
| Development | T4, A10G | Cheap interactive GPU |

**Auto-scaling groups:** scale training workers dynamically based on queue depth. Reduces idle costs.

**Spot/preemptible instances:** 60-90% cost reduction. Training must checkpoint and resume; use with checkpoint-aware frameworks (PyTorch Lightning, DeepSpeed).

## ML Platform Abstractions

**Managed notebooks:** JupyterHub on Kubernetes; per-user environments with GPU access. Practitioners interact with data and develop experiments.

**Training launchers:** abstraction over cluster scheduling. Submit a training job (Docker image + command + resource request); the launcher handles SLURM sbatch or Kubernetes job submission.

**Cluster autoscaler:** scale Kubernetes node pools up when pending pods require GPU nodes; scale down idle nodes. Cloud provider autoscalers (GKE, EKS node groups).

**Shared environments via Docker:** practitioners build Docker images with their requirements; reproducible across local, CI, and cluster environments.

## Resource Quotas and Cost Control

**GPU quotas:** limit GPU hours per team or project to control costs.

**Spot instance strategy:** training: spot instances with checkpointing; serving: on-demand for SLA guarantees.

**Cost allocation tagging:** tag cloud resources by team, project, and environment. Charge back costs to teams.

**Idle resource cleanup:** auto-terminate idle notebooks, auto-delete old artifact versions (with retention policy).

## Security and Compliance

**IAM (Identity and Access Management):** restrict access to datasets and models by role. Data scientists access training data; serving systems access model artifacts; not vice versa.

**Data encryption:** at-rest (S3 SSE, GCS CMEK) and in-transit (TLS). Required for PII and health data.

**Audit logging:** log all access to sensitive datasets. Required for GDPR, HIPAA compliance.

**Model access control:** model registry permissions. Only authorized users can push to production.

**Secrets management:** credentials (API keys, database passwords) in a secrets manager (Vault, AWS Secrets Manager). Never store in code or environment variables in containers.
