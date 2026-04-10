# Model Serving

Model serving is the infrastructure that makes trained models available for real-time or batch predictions. The goal is to serve predictions with low latency, high throughput, and high availability.

## Serving Patterns

**Online (real-time) inference:** respond to requests within milliseconds. Used for recommendation, fraud detection, search, chatbots.

**Batch inference:** process large datasets offline (overnight batch scoring). Lower latency requirements; simpler infrastructure.

**Streaming inference:** process a continuous stream of events; latency in seconds. Used for monitoring, real-time features, alert systems.

## REST API Serving

Wrap the model in an HTTP server; accept requests as JSON; return predictions as JSON.

**FastAPI + Uvicorn:** lightweight Python async HTTP server. Simple to build; good for low-to-medium QPS.

**Flask:** older synchronous Python server. Less efficient for concurrent requests.

**Deployment:** containerize with Docker; deploy to Kubernetes or a cloud run service.

**Bottleneck:** Python GIL limits single-process concurrency. Use multiple workers (gunicorn) or async frameworks.

## Dedicated Model Serving Frameworks

**TorchServe:** official PyTorch serving library. Model archive format; REST API; batching; metrics.

**TensorFlow Serving:** gRPC + REST; model versioning; multiple models on one server.

**Triton Inference Server (NVIDIA):** multi-framework (PyTorch, TensorFlow, ONNX, TensorRT). Dynamic batching; concurrent model execution; streaming.

**Ray Serve:** distributed serving on Ray. Python-native; supports arbitrary computation (preprocessing, postprocessing, ensembles). Easy auto-scaling.

**vLLM:** optimized serving for LLMs. Continuous batching, PagedAttention for KV cache management. High-throughput LLM inference.

## Containerization and Orchestration

**Docker:** package the model, dependencies, and server code into a container image. Reproducible; portable.

**Kubernetes:** orchestrate containers at scale. Deployments, Services, Horizontal Pod Autoscaler (HPA) scales replicas based on CPU/QPS. Supports rolling updates (zero-downtime deployments).

**Helm charts:** Kubernetes configuration templates. Standard for packaging ML serving deployments.

## Scaling and Load Balancing

**Horizontal scaling:** add more serving replicas behind a load balancer. Scales throughput linearly.

**Vertical scaling:** use larger GPUs or more GPUs per pod. Scales per-request latency.

**Auto-scaling:** scale replicas based on QPS or GPU utilization. HPA in Kubernetes; KEDA for event-driven scaling.

**Load balancer:** distribute requests across replicas. Round-robin, least-connections, or consistent hashing (for sticky routing).

## Batching

Group multiple requests into a single batch for efficient GPU execution.

**Static batching:** wait until a batch is full. Adds latency; underutilizes GPU if traffic is low.

**Dynamic batching (Triton):** accumulate requests for a configurable time window; batch whatever is queued. Balances latency and throughput.

**Continuous batching (vLLM):** for LLMs, new requests are inserted into the ongoing generation batch as soon as a slot is free. Eliminates the starvation of waiting for all sequences in a batch to finish.

**Optimal batch size:** limited by GPU memory (KV cache for LLMs; activations for CNNs). Larger batches increase GPU utilization up to the memory limit.

## Model Versioning and A/B Testing

**Canary deployment:** route a small fraction of traffic (e.g., 5%) to a new model version; monitor metrics; gradually increase.

**Shadow deployment:** new model processes all traffic but its predictions are not returned; compare offline with production.

**Blue/green deployment:** maintain two identical environments; switch traffic instantly on validation.

**Feature flags:** control which model version a user receives. Useful for gradual rollouts and experimentation.

## Caching

**Response caching:** cache prediction results for identical inputs. Effective for low-cardinality inputs (e.g., autocomplete for common queries).

**KV cache (LLMs):** cache key/value tensors for the prompt prefix. Prefix caching (vLLM, TGI) avoids recomputing the same system prompt for every request.

**Embedding cache:** precompute and cache embeddings for static items (product catalog, knowledge base passages). Avoid redundant GPU computation.

## Latency Components

```
Total latency = Network (client → server)
              + Queue wait
              + Preprocessing
              + GPU compute (inference)
              + Postprocessing
              + Network (server → client)
```

Profiling each component reveals the bottleneck. GPU compute dominates for large models; network dominates for edge deployments.

**P99 latency:** the 99th percentile latency. Often $3$–$5\times$ higher than median due to outlier requests (cold starts, large inputs). SLOs are typically defined on P99.
