# Training Dynamics

## Core Idea

**Training dynamics** refers to how neural network parameters, activations, gradients, and loss evolve during the training process. Understanding these dynamics is essential for diagnosing training failures, choosing hyperparameters, and designing architectures that are stable and efficient to train.

## The Training Loop

A standard training iteration:

1. Sample mini-batch $\mathcal{B}$ of size $B$.
2. Forward pass: compute $\hat{y} = f_\theta(x)$ and loss $\mathcal{L}$.
3. Backward pass: compute $\nabla_\theta \mathcal{L}$ via backpropagation.
4. Optimizer step: update $\theta \leftarrow \theta - \eta \cdot \text{opt}(\nabla_\theta \mathcal{L})$.
5. (Optional) Update learning rate schedule.

## Loss Landscape and Optimization Trajectory

**Saddle points:** in high-dimensional spaces, most critical points where $\nabla \mathcal{J} = 0$ are saddle points, not local minima. Gradient descent with noise (SGD) escapes saddle points via perturbation.

**Loss plateaus:** regions of near-zero gradient; momentum helps traverse them.

**Sharp vs. flat minima:** flat minima (small curvature, small $\lambda_\text{max}(H)$) generalize better. SGD with small batches and appropriate noise is biased toward flat minima.

## Gradient Flow Diagnostics

Monitor gradient norms per layer during training. Healthy training shows gradients of similar magnitude across all layers.

**Vanishing gradients:** gradient norms in early layers are orders of magnitude smaller than later layers. Learning stalls in early layers.

**Exploding gradients:** gradient norms grow unbounded. Loss spikes or diverges. Fix: gradient clipping, smaller learning rate, weight normalization.

**Dead neurons (ReLU):** neurons whose activation is always zero; gradient is always zero. Monitor the fraction of zero activations per layer.

**Diagnostic tools:**
- Log `param.grad.norm()` per parameter group after backward.
- Log activation statistics (mean, std, fraction of zeros) per layer.

## Loss Curves: Patterns and Causes

| Pattern | Diagnosis | Fix |
|---------|-----------|-----|
| Loss decreases then plateaus | Good training; model saturated | Increase capacity, more data |
| Loss oscillates wildly | Learning rate too high | Reduce $\eta$ or add warmup |
| Loss explodes (goes to NaN) | Exploding gradient or bad learning rate | Clip gradients, reduce $\eta$ |
| Validation loss diverges from train | Overfitting | More regularization, early stopping |
| Both losses high | Underfitting | More capacity, fewer regularization |
| Loss decreases in spikes | Learning rate schedule too aggressive | Smoother schedule |

## Warmup

Starting with a small learning rate and linearly increasing it over the first $w$ steps (warmup steps):

$$\eta_t = \eta_\text{max} \cdot \frac{t}{w}, \quad t \leq w$$

**Why warmup is needed:**
- For Adam-family: early bias-corrected second moment $\hat{v}_t$ underestimates true variance; large effective learning rate causes instability.
- For large-batch training: statistics are unreliable in the first few steps.
- For Transformers: gradient variance is very high at initialization; warmup stabilizes early updates.

Typical warmup: 500–10,000 steps depending on batch size and model.

## Gradient Accumulation

Simulates a larger effective batch size by accumulating gradients over $k$ mini-batches before updating:

```
for step in range(k):
    loss = compute_loss(batch)
    (loss / k).backward()     # accumulate gradients
optimizer.step()
optimizer.zero_grad()
```

Useful when GPU memory limits batch size. Effective batch size = $B \times k$.

## Mixed Precision Training (FP16/BF16)

Uses lower-precision floating point to reduce memory and speed up compute:

- **FP32:** 32-bit, full precision. Used for weight storage and optimizer states.
- **FP16:** 16-bit, half precision. Used for forward/backward pass computations. $\approx 2\times$ speedup on modern GPUs.
- **BF16:** 16-bit with wider dynamic range (same exponent bits as FP32). Preferred for LLM training; less prone to overflow.

**Loss scaling:** multiply loss by a large scale factor $S$ before backward; divide gradients by $S$ before update. Prevents FP16 underflow (gradients too small to represent).

Modern frameworks (PyTorch `torch.cuda.amp`, Accelerate) handle this automatically.

## Gradient Checkpointing

Trades compute for memory: instead of caching all intermediate activations during the forward pass (needed for backprop), only checkpoint activations at a subset of layers and recompute the others during backward.

**Memory reduction:** from $O(L)$ to $O(\sqrt{L})$ with optimal placement.

**Compute cost:** $\approx +33\%$ extra computation. Enables training much larger models on fixed GPU memory.

## Learning Rate Finder

Empirical method to find a good initial learning rate (Smith 2017):

1. Start with a very small $\eta$ (e.g., $10^{-7}$).
2. Increase $\eta$ exponentially over one epoch.
3. Plot training loss vs. $\eta$.
4. Choose $\eta$ at the steepest descent point (just before loss diverges).

## Catastrophic Forgetting

When fine-tuning a pre-trained model on a new task, parameters may shift far from their pre-trained values, degrading performance on the original task.

**Mitigations:**
- **Elastic Weight Consolidation (EWC):** adds a regularizer that penalizes changes to weights that were important for previous tasks (measured by Fisher information).
- **Small learning rate:** limits how far parameters move during fine-tuning.
- **Layer-wise learning rate decay:** lower layers (closer to input) get smaller learning rates; they encode general features that should not change much.

## Layer-wise Adaptive Rate Scaling (LARS / LAMB)

Scales the learning rate per layer based on the ratio of weight norm to gradient norm:

$$\eta_l = \eta \cdot \frac{\|\theta_l\|}{\|g_l\|}$$

Allows very large batch training by keeping the update magnitude proportional to the weight magnitude. LARS for CNNs; LAMB for Transformers. Used to train BERT on 64k batch size.

## Monitoring Training at Scale

Key metrics to log throughout training:
- Training loss (per step, smoothed)
- Validation loss and metrics (every $N$ steps)
- Gradient norm (per layer and global)
- Activation statistics (mean, std, fraction saturated)
- Learning rate (current value from scheduler)
- GPU utilization and memory
- Throughput (tokens/sec or samples/sec)

Tools: TensorBoard, Weights & Biases (W&B), MLflow.
