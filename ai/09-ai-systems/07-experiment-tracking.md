# Experiment Tracking

Experiment tracking records the parameters, metrics, artifacts, and code state of every training run. It enables comparison across experiments, reproducibility, and systematic hyperparameter search.

## What to Track

**Hyperparameters:** learning rate, batch size, model architecture, optimizer, regularization settings, data augmentation config.

**Metrics:** training loss, validation loss, task-specific metrics (accuracy, F1, BLEU) at each epoch or step.

**Artifacts:** model checkpoints, dataset versions, evaluation outputs, confusion matrices.

**Code state:** git commit hash, git diff (or full snapshot). Ensures the code that produced a run can be recovered.

**Environment:** Python version, library versions (`requirements.txt`, conda env, Docker image).

**System metrics:** GPU utilization, GPU memory, runtime.

## MLflow

Open-source experiment tracking with four components:

**MLflow Tracking:** log parameters, metrics, and artifacts via a Python API:

```python
import mlflow
with mlflow.start_run():
    mlflow.log_param("lr", 0.001)
    mlflow.log_metric("val_acc", 0.92, step=10)
    mlflow.log_artifact("model.pt")
```

Experiments stored in a local directory or a remote tracking server (MySQL + S3).

**MLflow Models:** standardized model packaging format. Log a model with `mlflow.pytorch.log_model(model, "model")`; load with `mlflow.pyfunc.load_model("runs:/...")`.

**MLflow Model Registry:** lifecycle management. Stages: Staging → Production → Archived. Enables controlled promotion of models.

**MLflow Projects:** package code with an MLproject file for reproducible execution (`mlflow run . -P lr=0.001`).

## Weights & Biases (W&B)

Cloud-based experiment tracking with rich visualization.

```python
import wandb
wandb.init(project="my-project", config={"lr": 0.001})
wandb.log({"loss": loss.item(), "acc": acc})
wandb.save("model.pt")
```

**Features:**
- Real-time metric plots during training.
- Artifact versioning with lineage.
- Hyperparameter sweeps (Bayesian, random, grid).
- Model registry.
- Comparison tables across runs.
- Integration with popular frameworks (PyTorch Lightning, HuggingFace Trainer, Keras).

## Hyperparameter Sweeps

Systematically search for the best hyperparameter configuration.

**Grid search:** exhaustively try all combinations. $O(N^k)$ for $N$ values and $k$ hyperparameters. Infeasible for large search spaces.

**Random search:** sample uniformly at random from the hyperparameter space. More efficient than grid for most practical cases (Bergstra & Bengio 2012).

**Bayesian optimization:** build a probabilistic surrogate model (Gaussian process) of the objective function; use an acquisition function (Expected Improvement, UCB) to select the next configuration to evaluate. More efficient for expensive evaluations.

**Multi-fidelity (Hyperband / ASHA):** run many configurations for a few epochs; terminate underperforming ones early; allocate more budget to promising configurations. Dramatically reduces wall-clock time.

**Population-Based Training (PBT):** run a population of agents; periodically copy hyperparameters from better-performing agents and mutate them. Adapts hyperparameters during training, not just at the start.

## Run Comparison

Experiment tracking tools allow filtering and comparing runs by metric or hyperparameter value.

**Best practice:** log everything upfront; avoid cherry-picking runs to report. Maintain a comparison table with all experiments attempted.

## Integration with Training Frameworks

**PyTorch Lightning:** `WandbLogger`, `MLFlowLogger`, `TensorBoardLogger` integrate with Trainer callbacks.

**Hugging Face Trainer:** pass `report_to=["wandb", "mlflow"]` in `TrainingArguments`.

**TensorBoard:** visualize training curves locally. Limited compared to W&B but no external dependency.

## Experiment Organization

**Naming conventions:** `{project}_{model}_{dataset}_{date}_{notes}`. Consistent naming makes filtering easier.

**Tags:** attach semantic tags (baseline, ablation, final, debug) to runs.

**Groups:** in W&B, group runs belonging to the same sweep or experiment family.

**Notes:** attach free-text notes explaining motivation and observations. Easy to forget why an experiment was run 3 months later.
