# ML Pipelines

An ML pipeline is an automated, reproducible sequence of steps that transforms raw data into a deployed model. Pipelines make ML workflows repeatable, scalable, and maintainable.

## Why ML Pipelines?

**Manual workflows don't scale:** data collection → preprocessing → training → evaluation → deployment done ad-hoc is error-prone and not reproducible.

**Automation:** pipelines trigger automatically when new data arrives or on a schedule.

**Reproducibility:** each pipeline run is a documented, versioned artifact.

**Collaboration:** teams can work on modular components without interfering.

**CI/CD for ML:** pipelines integrate with software release practices.

## Pipeline Components

A typical ML pipeline:

```
Data Ingestion
  → Data Validation
  → Feature Engineering
  → Training
  → Evaluation
  → Model Validation (performance gate)
  → Push to Registry
  → Deployment
```

Each step is a component with well-defined inputs and outputs (data artifacts, model artifacts).

## TFX (TensorFlow Extended)

Google's production ML pipeline framework.

**Components:**
- `ExampleGen`: ingest data; convert to TFRecord.
- `StatisticsGen`: compute dataset statistics.
- `SchemaGen`: infer schema from statistics.
- `ExampleValidator`: validate data against schema.
- `Transform`: feature engineering (scalers, encoders).
- `Trainer`: train the model.
- `Evaluator`: compute metrics; compare to baseline.
- `Pusher`: push to serving if evaluation passes.

**Metadata:** TFX stores artifact metadata in ML Metadata (MLMD), a database of all inputs, outputs, and executions. Enables lineage queries.

**Orchestration:** TFX pipelines run on Airflow, Kubeflow Pipelines, or Vertex AI Pipelines.

## Kubeflow Pipelines

Kubernetes-native pipeline orchestration. Pipelines are defined as Python functions with the `@component` decorator; KFP compiles them to Argo Workflows YAML.

```python
@kfp.component
def train(dataset: Input[Dataset], model: Output[Model]):
    ...

@kfp.pipeline
def my_pipeline():
    data = ingest()
    trained = train(dataset=data.output)
    evaluate(model=trained.output)
```

**Artifacts:** large artifacts (datasets, models) stored in GCS/S3; small parameters passed as JSON.

**UI:** visualize pipeline DAGs, step status, logs, artifact lineage.

## Metaflow

Netflix's ML pipeline framework. Python-native; steps are class methods.

```python
from metaflow import FlowSpec, step

class TrainFlow(FlowSpec):
    @step
    def start(self):
        self.next(self.preprocess)

    @step
    def preprocess(self):
        ...
        self.next(self.train)

    @step
    def train(self):
        ...
        self.next(self.end)

    @step
    def end(self):
        pass

if __name__ == "__main__":
    TrainFlow()
```

Runs locally or on AWS/GCP. Auto-versioning of all inputs and outputs. Time-travel: inspect any past run's artifacts.

## ZenML

Framework-agnostic ML pipelines with a focus on portability. Pipelines are defined as Python functions; steps can run on any orchestrator (local, Airflow, Kubeflow) and stack (AWS, GCP, Azure).

## Continuous Training

**Trigger-based retraining:** retrain when drift is detected, performance drops, or new labeled data is available.

**Pipeline as code:** the pipeline DAG is in version control; changes to training logic trigger a new pipeline run.

**Automated evaluation gate:** a step in the pipeline compares the new model's metrics to the current production model. Only promotes the new model if it improves by at least a threshold.

**Rollback:** maintain the previous model version; roll back automatically if the new model degrades production metrics.

## Pipeline Testing

**Unit tests:** test individual components (feature transformers, model constructors).

**Integration tests:** run the full pipeline on a small subset of data. Ensure all components connect and produce correct artifacts.

**Smoke tests:** verify that training runs without errors and produces a model with reasonable metrics.

**Regression tests:** verify that metrics match a stored baseline within tolerance.
