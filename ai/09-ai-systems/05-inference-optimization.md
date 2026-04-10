# Inference Optimization

Inference optimization reduces the latency, memory, and compute cost of model predictions without significantly degrading quality. Especially critical for LLMs and large vision models deployed at scale.

## Quantization

Reduce the precision of weights (and optionally activations) from FP32/BF16 to lower-bit formats.

**Post-training quantization (PTQ):** quantize after training; no retraining required.

**INT8 quantization:** $2\times$ memory reduction vs. FP16. Near-lossless for most models. Requires calibrating scale factors using a small calibration dataset.

**INT4 / 4-bit quantization:** $4\times$ vs. FP16. Noticeable quality loss without careful handling.

**GPTQ (4-bit):** layer-wise quantization that minimizes the reconstruction error of the quantized layer output. Solves a second-order optimization per layer. Effective for LLMs; compresses 70B model to ~35 GB (from ~140 GB BF16).

**GGUF / llama.cpp:** quantization format for CPU inference. Supports 2/3/4/5/6/8-bit mixed precision. Enables running 7B models on MacBook.

**AWQ (Activation-aware Weight Quantization):** identify and protect salient weight channels (those multiplied by large activations) from aggressive quantization. Strong 4-bit quality.

**Quantization-aware training (QAT):** simulate quantization during training via fake quantization; the model learns to tolerate it. Better quality than PTQ at 4-bit; requires retraining.

## Pruning

Remove weights or entire structures from the model.

**Unstructured pruning:** zero out individual weights below a magnitude threshold. High sparsity possible; sparse computation is hard to accelerate on modern GPU hardware (requires custom sparse kernels).

**Structured pruning:** remove entire channels, heads, or layers. Directly reduces computation; compatible with dense matrix libraries.

**Magnitude pruning:** remove weights with the smallest absolute values. Simple; may remove important small weights.

**Gradient-based pruning:** use first/second-order gradient information (Hessian) to identify weights with the smallest impact on the loss.

**Iterative pruning:** alternate between pruning and fine-tuning to recover accuracy. Standard workflow for structured pruning.

## Knowledge Distillation

Train a small student model to mimic a larger teacher model.

**Soft targets (Hinton et al. 2015):**

$$\mathcal{L}_\text{KD} = (1-\alpha) \mathcal{L}_\text{CE}(y, p_s) + \alpha T^2 \mathcal{L}_\text{CE}(p_t^{(T)}, p_s^{(T)})$$

Temperature $T > 1$ softens the teacher's distribution, revealing dark knowledge (relative class probabilities). Student matches the teacher's soft distribution.

**Feature-level distillation:** match intermediate layer activations, attention maps, or relation matrices between teacher and student.

**DistilBERT:** 40% smaller than BERT; retains 97% of performance. Trained with soft-target distillation + cosine embedding loss on hidden states.

## TensorRT

NVIDIA's inference optimization toolkit.

**Graph optimization:** fuse multiple operations into single kernels (e.g., Conv + BN + ReLU into one kernel). Eliminates intermediate memory reads/writes.

**Kernel auto-tuning:** profile and select the fastest CUDA kernel for each operation given the input shapes.

**Precision calibration:** convert FP32 to INT8 using a calibration dataset; find optimal per-layer scale factors.

**TensorRT significantly reduces latency** (2-5$\times$ vs. PyTorch eager) for CNNs and encoder models. Integration via `torch.compile` or ONNX export.

## ONNX and Model Compilation

**ONNX (Open Neural Network Exchange):** graph interchange format. Export from PyTorch; run with ONNX Runtime on CPU, GPU, or edge devices.

**ONNX Runtime:** optimized cross-platform inference engine. Operator fusion, quantization, hardware-specific execution providers (TensorRT, OpenVINO, CoreML).

**torch.compile (PyTorch 2.0):** JIT compile PyTorch models with TorchDynamo + Inductor backend. Automatic kernel fusion; 1.5-3$\times$ speedup on NVIDIA GPUs for many workloads.

**XLA (Accelerated Linear Algebra):** TensorFlow and JAX compilation backend. Fusion, tiling, and operator scheduling optimized per hardware target.

## LLM-Specific Optimizations

**KV cache:** cache key/value tensors for past tokens to avoid recomputation. Memory $\propto n \cdot d \cdot L$ per sequence (sequence length × hidden dim × layers).

**Multi-query attention (MQA) / Grouped query attention (GQA):** share K/V heads across query heads. Reduces KV cache memory by $h/g\times$ (ratio of heads to groups). Faster decoding.

**Speculative decoding:** a small draft model generates $k$ candidate tokens; the large target model verifies all $k$ in a single parallel forward pass. Accepts/rejects each token. Speeds up autoregressive generation by 2-3$\times$.

**Continuous batching:** see [Model Serving](04-model-serving).

**FlashAttention:** memory-efficient exact attention. Reduces memory from $O(n^2)$ to $O(n)$; faster due to reduced HBM access.

**Flash-Decoding:** parallelizes the attention computation over the KV cache across heads and sequence length during decoding. Improves throughput for long-context inference.

## Edge Deployment

Deploy models on CPUs, mobile phones, or microcontrollers.

**llama.cpp:** CPU inference for LLMs with 4-bit quantization. 7B models run at several tokens/second on laptops.

**CoreML / MPS:** Apple Silicon neural engine + GPU. Optimized for on-device inference.

**TFLite / TensorFlow Lite:** mobile and embedded deployment. Quantization, pruning, and delegate acceleration (GPU, EdgeTPU, NNAPI).

**GGML / GGUF:** tensor library and format for efficient CPU quantized inference. Basis of llama.cpp and related projects.
