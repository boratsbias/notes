# Reproducibility

Reproducibility in ML means being able to recreate the exact results of a training run or experiment. It is a prerequisite for debugging, scientific rigor, and safe model deployment.

## Sources of Non-Reproducibility

**Random seeds:** weight initialization, data shuffling, dropout, data augmentation, and batch sampling all use random number generators. Without fixing seeds, results differ across runs.

**Non-deterministic GPU operations:** CUDA has some non-deterministic operations (cuDNN convolution algorithms chosen at runtime; atomic operations in parallel reductions). Even with fixed seeds, results may differ.

**Floating-point non-associativity:** $(a + b) + c \neq a + (b + c)$ in floating point. Parallel reductions with different thread orderings give slightly different results.

**Framework/library versions:** different versions of PyTorch, cuDNN, or CUDA can produce different numerical results. A gradient computation bug fixed in one version may change outputs.

**Data pipeline:** shuffling order, preprocessing randomness, augmentation stochasticity.

**Distributed training:** order of gradient reductions and parameter updates may vary with number of GPUs, communication patterns.

## Fixing Random Seeds

```python
import random, numpy as np, torch
import os

def seed_everything(seed: int):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    os.environ["PYTHONHASHSEED"] = str(seed)

# Force deterministic CUDA operations (may reduce speed)
torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False
```

`torch.backends.cudnn.deterministic = True` disables non-deterministic cuDNN algorithms. May incur a 10-30% speed penalty.

`torch.use_deterministic_algorithms(True)` raises an error if any non-deterministic operation is attempted (PyTorch 1.11+).

## Environment Pinning

Pin every dependency to an exact version.

**requirements.txt with exact versions:**

```
torch==2.3.0
transformers==4.40.0
numpy==1.26.4
```

**conda environment.yml:** pin package versions and Python version.

**Docker:** Docker images capture the exact OS, CUDA version, Python version, and all installed packages. A Dockerfile with pinned base image and package versions fully specifies the environment.

**Poetry / uv:** modern Python dependency managers with lockfiles that pin transitive dependencies.

## Data Reproducibility

**Version the dataset:** use DVC or a data catalog to pin exact dataset versions to each experiment.

**Store the preprocessing script + version:** not just the processed data, but the code that produced it.

**Log data statistics:** number of examples per split, class distribution, mean/std of features. Detect accidental data changes.

**Deterministic splits:** use a fixed random seed for splitting. Better: use a hash of a stable key (user ID, item ID) to assign records to splits deterministically.

## Code Reproducibility

**Git commit hash:** log the exact commit hash (and ideally a `git diff` for uncommitted changes) with every experiment.

**No uncommitted changes in production runs:** enforce via CI that model training runs only on clean commits.

**Experiment tracking:** log commit hash, config file, and code snapshot (MLflow, W&B) with every run.

## Checkpoint Reproducibility

**Save optimizer state:** a checkpoint that includes the model weights, optimizer state ($m$, $v$ in Adam), learning rate schedule state, and epoch/step count allows resuming a run exactly.

**Random state:** save and restore the state of all random number generators at the checkpoint.

```python
checkpoint = {
    "model": model.state_dict(),
    "optimizer": optimizer.state_dict(),
    "scheduler": scheduler.state_dict(),
    "epoch": epoch,
    "rng_state": torch.get_rng_state(),
    "cuda_rng_state": torch.cuda.get_rng_state_all(),
    "np_rng_state": np.random.get_state(),
}
```

## Levels of Reproducibility

| Level | Description | Requirement |
|-------|-------------|-------------|
| Numerical | Bit-for-bit identical outputs | Fixed seeds + deterministic ops + identical hardware |
| Statistical | Same metrics within noise | Fixed seeds + same code/data |
| Scientific | Same conclusions | Same methodology, data, and evaluation |
| Functional | Same production behavior | Sufficient for deployment |

Bit-for-bit reproducibility is often impractical across different hardware or library versions. Statistical reproducibility (same metrics ± small variance) is the realistic target.

## Continuous Integration for Reproducibility

Run short smoke-test training jobs in CI on every commit. Check that metrics match a baseline within tolerance. Catches regressions from code or dependency changes early.
