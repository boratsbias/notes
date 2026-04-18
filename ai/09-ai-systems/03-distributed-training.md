# Distributed Training

Distributed training splits the training workload across multiple GPUs or nodes to overcome memory limits and accelerate large model training. It is essential for training models that don't fit on a single GPU.

## Why Distribute?

**Memory limit:** a 70B parameter model requires ~140 GB in BF16, far exceeding any single GPU's memory (80 GB for A100).

**Speed:** more GPUs can process more data in parallel.

**Scale law:** larger models require more compute; single-GPU training would take years.

## Data Parallelism (DP)

Replicate the full model on each GPU; split the training batch across GPUs.

**Workflow:**
1. Each GPU receives a different mini-batch.
2. Each GPU computes loss and gradients independently.
3. Gradients are synchronized (averaged) across all GPUs via AllReduce.
4. Each GPU updates its local model copy with the averaged gradient.

**AllReduce:** a collective communication operation that reduces a tensor across all processes and broadcasts the result. Implemented via ring-AllReduce for bandwidth efficiency.

**Synchronous DP:** wait for all GPUs to finish before updating. Stable; the straggler problem (slowest GPU delays all others).

**Asynchronous DP:** workers update a parameter server independently. Faster; stale gradients may reduce convergence quality.

**Limitations:** each GPU must hold the full model. Fails when model doesn't fit on a single GPU.

## Model Parallelism (MP)

Split the model across GPUs.

### Tensor Parallelism (TP)

Partition individual operations (matrices) across GPUs.

**Column parallel linear:** split weight matrix $W \in \mathbb{R}^{d \times 4d}$ column-wise: $[W_1 \mid W_2]$ on GPU 1 and 2. Both GPUs receive the same input $x$; outputs $[W_1^T x, W_2^T x]$ are concatenated.

**Row parallel linear:** split input activation column-wise; each GPU computes part of the output; results are summed (AllReduce).

**Megatron-LM** is the standard tensor parallelism implementation for Transformer LLMs. Attention heads and FFN dimensions are split across GPUs.

**Communication:** AllReduce at each tensor parallel boundary. High bandwidth demand; requires NVLink (within a node).

### Pipeline Parallelism (PP)

Partition model layers into $P$ stages; assign each stage to a GPU. Each GPU processes its layers and passes activations to the next GPU.

**Micro-batching (GPipe):** split the mini-batch into micro-batches; pipeline micro-batches through stages. Reduces the bubble (idle time waiting for pipeline to fill/drain).

**Bubble fraction:** $\frac{P-1}{m + P - 1}$ where $m$ is the number of micro-batches. Use $m \gg P$ to minimize bubble.

**1F1B schedule (PipeDream):** interleave forward and backward passes to reduce memory at intermediate stages.

## ZeRO (Zero Redundancy Optimizer)

Rajbhandari et al. (2020). Eliminates memory redundancy in data parallel training by partitioning optimizer states, gradients, and parameters across GPUs.

**ZeRO Stage 1:** partition optimizer states ($m$, $v$ in Adam) across $N$ GPUs. Reduces optimizer memory by $N\times$.

**ZeRO Stage 2:** + partition gradients. Further $2\times$ reduction.

**ZeRO Stage 3:** + partition model parameters. Full $N\times$ reduction. Each GPU holds only $1/N$ of the parameters; gathers parameters from other GPUs as needed.

**Memory savings:** for a 70B model with 80 GPUs (A100), ZeRO Stage 3 reduces per-GPU memory from 280 GB (full model + optimizer) to ~3.5 GB.

**Communication overhead:** ZeRO-3 requires AllGather for parameters before each forward pass and ReduceScatter for gradients. Significant bandwidth cost.

**DeepSpeed** and **FSDP (PyTorch Fully Sharded Data Parallel)** are the main implementations.

## Hybrid Parallelism

Large-scale LLM training combines all three strategies:

$$N_\text{GPU} = N_\text{DP} \times N_\text{TP} \times N_\text{PP}$$

**Typical configuration for LLaMA-3 70B on 512 A100s:**
- Tensor parallelism: 8 (within a node via NVLink).
- Pipeline parallelism: 4 (across nodes, lower bandwidth required).
- Data parallelism: 16 (remaining GPUs).

Communication hierarchy matches hardware topology: TP uses high-bandwidth NVLink; PP/DP use InfiniBand.

## Communication Primitives

| Operation | Description |
|-----------|-------------|
| AllReduce | Reduce + broadcast to all; used in DP gradient sync |
| AllGather | Gather tensors from all; used in ZeRO-3 parameter fetch |
| ReduceScatter | Reduce into disjoint shards; used in ZeRO gradient reduction |
| Broadcast | Send from one to all |
| P2P Send/Recv | Point-to-point; used in PP activation passing |

**NCCL (NVIDIA Collective Communications Library):** high-performance implementations of these primitives over NVLink and InfiniBand.

## Gradient Compression

Reduce communication volume in data parallelism.

**Gradient quantization:** compress gradients to 16-bit or 8-bit. Some information loss.

**Top-K sparsification:** send only the top-$k$ largest-magnitude gradient elements. Error feedback accumulates the dropped gradients locally.

**PowerSGD:** approximate gradient matrix with a low-rank factorization. High compression ratio with small accuracy loss.
