# Dataset Management

Dataset management covers how training data is versioned, stored, documented, and governed throughout the ML lifecycle.

## Dataset Versioning

ML datasets must be versioned for reproducibility and auditability.

**Why version datasets?**
- Reproduce a training run from months ago.
- Understand which data version led to a regression.
- Safely update the dataset without breaking ongoing experiments.

**DVC (Data Version Control):** git-like CLI for large files and datasets. Stores data in remote storage (S3, GCS, Azure); stores a small `.dvc` pointer file in git. `dvc pull` retrieves the exact data for a given commit.

**Delta Lake / Iceberg:** table formats for data lakes with ACID transactions and time travel. Query data "as of" any past timestamp.

**LakeFS:** git-like branching for data lakes. Branch the data for an experiment; merge after validation.

## Dataset Storage Formats

| Format | Type | Notes |
|--------|------|-------|
| CSV | Row-oriented | Human-readable; slow for analytics |
| Parquet | Columnar, compressed | Efficient for analytical queries; standard |
| Arrow / Feather | Columnar, in-memory | Zero-copy read; fast for ML training |
| TFRecord | Sequential binary | TensorFlow standard; efficient I/O |
| HDF5 | Hierarchical binary | Multi-array storage; used in research |
| WebDataset | Tar-based shards | Efficient streaming for large image datasets |
| JSONL | Row-oriented text | NLP datasets; human-readable |

**Parquet** is the standard for structured data at scale. **WebDataset** is common for large-scale image/video training (ImageNet-scale).

## Data Documentation and Datasheets

**Datasheet for Datasets (Gebru et al. 2018):** standardized template for documenting:
- Motivation and intended use.
- Composition: size, types, missing data.
- Collection process.
- Preprocessing and labeling.
- Distribution and maintenance.
- Social considerations: biases, sensitive attributes.

**Model Cards:** similar documentation for deployed models.

Good documentation is required for responsible AI deployment and regulatory compliance.

## Data Annotation and Labeling

**Crowdsourcing:** Amazon Mechanical Turk, Scale AI, Labelbox. Cost-effective; variable quality. Requires quality control (worker agreement, gold standard examples, honeypot tasks).

**Inter-annotator agreement:** measure label consistency among annotators.
- **Cohen's kappa:** $\kappa = \frac{p_o - p_e}{1 - p_e}$ (observed minus chance agreement, normalized).
- **Krippendorff's alpha:** generalization to multiple annotators and ordinal scales.

**Active learning:** select the most informative unlabeled examples for annotation. Reduces labeling cost by 2-10$\times$. Strategies: uncertainty sampling, query by committee, core-set selection.

**Label smoothing and soft labels:** when annotators disagree, use the distribution of annotations rather than the majority vote.

**Programmatic labeling (Snorkel):** write labeling functions (heuristics, knowledge bases, patterns); combine them with a generative model to produce soft labels. Enables rapid training data creation without manual annotation.

## Data Splits

**Random split:** shuffle and split by fraction (e.g., 70/15/15). Appropriate for i.i.d. data.

**Temporal split:** train on past data, validate on recent data, test on most recent. Required for time-series and forecasting to avoid leakage.

**Stratified split:** maintain class proportions in each split. Important for imbalanced datasets.

**Group split:** keep all records from the same entity (user, patient) in the same split. Prevents leakage when a model predicts about entities seen in training.

**Cold-start split:** test set contains new entities (new users, new items) not in the training set. Required for recommender systems.

## Data Imbalance

Class imbalance is common in real-world ML (fraud: 0.1% positive, medical rare diseases).

**Oversampling:** duplicate minority class samples (naive) or generate synthetic samples (SMOTE: interpolate between nearest minority neighbors).

**Undersampling:** randomly remove majority class samples. Loses information.

**Class weighting:** scale the loss contribution of each class inversely proportional to its frequency:

$$\mathcal{L} = -\sum_i w_{y_i} \log p_{y_i}, \quad w_k = \frac{n}{K \cdot n_k}$$

**Focal loss:** see [Object Detection](../06-computer-vision/03-object-detection).

## Feature Stores

A feature store centralizes the computation and serving of features for both training and online inference.

**Purpose:** ensure training-serving consistency. The same feature logic runs for historical training data and real-time inference.

**Components:**
- **Offline store:** batch features stored in a data warehouse or object storage (Parquet). Used for training.
- **Online store:** low-latency feature serving (Redis, DynamoDB). Used for inference.
- **Backfill job:** populate historical features in the offline store.
- **Streaming pipeline:** update online store in near-real-time.

**Tools:** Feast (open source), Tecton, Hopsworks, SageMaker Feature Store.
