# Training Infrastructure

Training infrastructure encompasses the hardware, software stack, and cluster management systems that enable efficient model training at scale.

## Hardware for ML Training

### GPUs

The primary training accelerator. Thousands of CUDA cores + Tensor Cores for mixed-precision matrix multiplication.

**NVIDIA GPU generations:**

| GPU | Memory | Memory BW | FP16 TFLOPs | Notes |
|-----|--------|-----------|------------|-------|
| V100 | 16/32 GB HBM2 | 900 GB/s | 125 | Common in older clusters |
| A100 | 40/80 GB HBM2e | 2 TB/s | 312 | Current training standard |
| H100 | 80 GB HBM3 | 3.35 TB/s | 989 | Latest; FP8 support |
| H200 | 141 GB HBM3e | 4.8 TB/s | 989 | Largest memory, 2024 |

**NVLink:** high-bandwidth GPU-to-GPU interconnect within a node (600 GB/s bidirectional for NVLink 4). Critical for tensor parallelism.

### TPUs

Google's custom ASIC for matrix multiplication. Optimized for bfloat16. TPU v4 pods: 4096 chips connected via 3D torus topology. Used internally at Google (BERT, T5, PaLM, Gemini).

### AI Accelerators

**Cerebras CS-2:** wafer-scale chip with 850k cores. Fits large models without tensor parallelism.

**Graphcore IPU:** intelligence processing unit. Bulk synchronous parallel execution; good for sparse models.

**Trainium (AWS) / Gaudi (Intel):** cloud-specific accelerators.

## Compute Clusters

**On-premises HPC:** physically owned GPU clusters. Higher upfront cost; full control. Used by large research labs.

**Cloud (AWS, GCP, Azure):** rent GPU/TPU instances on demand. Flexible scaling; higher per-hour cost.

**Spot/preemptible instances:** 60-90% cheaper; can be interrupted. Training jobs must checkpoint frequently and support restart.

**Cluster topology:** GPUs are connected within a node via NVLink; nodes connect via InfiniBand (NVIDIA HDR/NDR InfiniBand, 200/400 Gb/s). Topology-aware communication scheduling is critical.

## Compute Metrics

**MFU (Model FLOPs Utilization):**

$$\text{MFU} = \frac{\text{observed throughput (tokens/s)} \times C_\text{forward}}{\text{peak hardware FLOPs/s}}$$

where $C_\text{forward} \approx 2N$ FLOPs per token ($N$ = model parameters).

State-of-the-art LLM training: MFU ~38-50% (A100s). Hardware peak is rarely achievable due to memory bandwidth bottlenecks and communication overhead.

**Memory-bound vs. compute-bound:**
- Large batch inference: compute-bound.
- Single-token inference: memory-bound (loading weights dominates).

## Mixed Precision Training

Reduce memory and increase throughput by using lower precision for most operations.

**FP32:** 32-bit float. Full precision; baseline.

**FP16:** 16-bit float. $2\times$ memory; $2\times$ throughput on Tensor Cores. Limited dynamic range; requires loss scaling.

**BF16 (bfloat16):** same bit width as FP16 but same exponent range as FP32. More numerically stable; preferred over FP16 for training. Available on A100+, TPUs.

**FP8:** 8-bit float (H100+). $2\times$ Tensor Core throughput vs. BF16. Used in large-scale LLM training.

**Loss scaling:** multiply the loss by a scale factor $S$ before backward pass to prevent FP16 underflow. Divide gradients by $S$ before the optimizer step. Dynamic loss scaling: increase $S$ if no overflow; decrease if overflow detected.

**Automatic Mixed Precision (AMP):** PyTorch `torch.cuda.amp.autocast()` automatically casts operations to FP16/BF16 where safe; keeps sensitive operations (loss, softmax) in FP32.

## Memory Optimization

**Gradient checkpointing (activation recomputation):** discard activations after the forward pass; recompute them during backward. Trades $\sqrt{n}$ memory for $\sqrt{n}$ extra FLOPs. Standard for large models.

**Optimizer state sharding (ZeRO):** see [Distributed Training](03-distributed-training).

**Micro-batching / gradient accumulation:** run forward-backward over multiple small micro-batches before each optimizer step. Simulates a large batch on limited memory.

## Training Job Management

**SLURM:** standard HPC job scheduler. Submit GPU jobs with `sbatch`; queue management and resource allocation.

**Kubernetes + Volcano/Kubeflow:** container-based cluster management for ML workloads. Supports multi-node distributed training via MPI/NCCL operators.

**Job arrays:** run hyperparameter sweeps as parallel jobs.

**Preemption handling:** checkpoint every $N$ steps; auto-resume from checkpoint on restart. Tools: Pytorch Lightning, Hugging Face Trainer, DeepSpeed.
