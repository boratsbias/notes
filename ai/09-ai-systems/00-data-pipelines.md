# Data Pipelines

A data pipeline is the sequence of processes that transforms raw data into a form suitable for model training or inference. Reliable, scalable data pipelines are a prerequisite for production ML systems.

## Pipeline Stages

```
Raw data sources
  → Ingestion
  → Validation
  → Transformation / Preprocessing
  → Splitting (train / val / test)
  → Feature computation
  → Storage (feature store / artifact store)
  → Consumption by training job
```

## Data Ingestion

**Batch ingestion:** load data periodically (hourly, daily). Simple; data is not immediately fresh.

**Streaming ingestion:** process events as they arrive (Kafka, Kinesis, Pub/Sub). Near-real-time; more complex.

**Change Data Capture (CDC):** track row-level changes in a source database; emit them as a stream to the pipeline.

**Common sources:** databases (PostgreSQL, MySQL), object storage (S3, GCS), data warehouses (BigQuery, Snowflake), external APIs, web scrapes.

## Data Validation

Catch data quality issues before they propagate to model training.

**Schema validation:** check that columns have the expected types, nullability, and value ranges.

**Distribution checks:** compare feature statistics to a reference baseline. Flag significant deviations:
- Mean / standard deviation shift.
- Null rate change.
- Categorical cardinality change.

**Great Expectations:** define data quality assertions as "expectations"; generate an HTML report of pass/fail. Widely used in production.

**TFX Data Validation (TFDV):** compute schema and statistics from training data; validate serving data against the schema.

## Data Transformation

**Normalization and standardization:** see preprocessing for specific techniques.

**Encoding:** encode categorical variables (one-hot, label encoding, target encoding, embedding).

**Imputation:** handle missing values (mean fill, forward fill, model-based imputation).

**Aggregation:** roll up raw events to session-level, user-level, or time-window features.

**Join enrichment:** join raw events with reference tables (user profiles, item metadata) to add contextual features.

## ETL vs. ELT

**ETL (Extract-Transform-Load):** transform data before loading into the target store. Traditional; transformation happens outside the data warehouse.

**ELT (Extract-Load-Transform):** load raw data into a data warehouse; transform using SQL. Modern approach; leverages the warehouse's compute (dbt + BigQuery/Snowflake).

## dbt (Data Build Tool)

SQL-based transformation framework. Transforms are modular SQL models with dependencies resolved as a DAG. Includes testing, documentation generation, and lineage visualization. Standard for analytics and feature engineering in data warehouses.

## Streaming Pipelines

**Apache Kafka:** distributed message queue. Topics store ordered event streams. Consumers pull messages and process them.

**Apache Flink / Spark Streaming:** stateful stream processing with exactly-once semantics. Used for real-time feature computation (session aggregates, fraud signals).

**Windowing:** aggregate events over time windows (tumbling: non-overlapping fixed windows; sliding: overlapping; session: activity-gap-based).

## Feature Computation

**Point-in-time correctness:** when computing features for training, only use information available before the label's timestamp. Avoid data leakage.

**Time-travel features:** for each training example $(x, y, t)$, compute features using only data before time $t$. Standard in fraud detection, forecasting.

**Backfilling:** compute historical features for training data. Must exactly replicate the production feature computation logic.

## Data Lineage

Track how each dataset was produced: what source data, what transformation code, what version.

**Benefits:** reproducibility, debugging, compliance (GDPR data deletion propagation), impact analysis (which models depend on this dataset?).

**Tools:** Apache Atlas, Marquez, OpenLineage, DataHub.

## Pipeline Orchestration

Schedule and monitor pipeline execution.

**Apache Airflow:** Python-based DAG scheduler. Sensors, operators, XCom for data passing. Widely adopted.

**Prefect / Dagster:** modern alternatives with better Python-native APIs, dynamic workflows, and improved observability.

**Handling failures:** retry policies, alerting on failure, partial re-runs (only re-run failed tasks, not the whole pipeline).
