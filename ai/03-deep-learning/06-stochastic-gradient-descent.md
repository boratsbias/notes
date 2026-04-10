# Stochastic Gradient Descent

**Stochastic Gradient Descent (SGD)** approximates the true gradient using a small random subset (**mini-batch**) of the training data at each step. The noise in the gradient estimate acts as implicit regularization and helps escape sharp minima, making SGD the workhorse optimizer for deep learning.

$$\theta^{(t+1)} = \theta^{(t)} - \eta_t \hat{g}_t$$

where $\hat{g}_t = \frac{1}{B}\sum_{i \in \mathcal{B}_t} \nabla_\theta \mathcal{L}(f_\theta(x_i), y_i)$ is the mini-batch gradient.

## Pure SGD (Batch Size = 1)

$$\hat{g}_t = \nabla_\theta \mathcal{L}(f_\theta(x_{i_t}), y_{i_t})$$

**Unbiased estimate:** $\mathbb{E}[\hat{g}_t] = \nabla_\theta \mathcal{J}(\theta)$

**High variance:** each step is a noisy estimate; updates zigzag around the true gradient direction.

**Advantage:** one pass over data gives $n$ updates (vs. 1 for batch GD).

## Mini-Batch SGD

Uses batch size $B \in [1, n]$. Standard in deep learning with $B \in \{32, 64, 128, 256\}$.

**Variance of mini-batch gradient:**

$$\text{Var}[\hat{g}_t] = \frac{\sigma^2}{B}$$

where $\sigma^2$ is the per-sample variance. Larger batches reduce gradient variance but each step costs more compute.

**Gradient noise:** $\hat{g}_t = \nabla_\theta \mathcal{J}(\theta) + \epsilon_t$ where $\epsilon_t$ is zero-mean noise with variance $\propto 1/B$.

## Epoch

One **epoch** = one complete pass over the training data. Number of steps per epoch = $\lceil n/B \rceil$.

Training typically runs for tens to hundreds of epochs. Total gradient steps $\approx \text{epochs} \times n/B$.

## SGD with Momentum

Accumulates a velocity vector $\mathbf{v}$ to smooth updates and accelerate in consistent directions:

$$\mathbf{v}_{t+1} = \mu \mathbf{v}_t - \eta \hat{g}_t$$

$$\theta^{(t+1)} = \theta^{(t)} + \mathbf{v}_{t+1}$$

- $\mu \in [0.9, 0.99]$: momentum coefficient (exponential decay of past gradients).
- Steady-state velocity: $\mathbf{v} = \frac{\eta}{1 - \mu} \hat{g}$. With $\mu = 0.9$: effective learning rate is $10\times$ larger in consistent directions.

**Physical intuition:** ball rolling down a hill accumulates speed; momentum helps traverse flat regions and reduces oscillation in ravines.

## Nesterov Accelerated Gradient (NAG)

Evaluates gradient at a "look-ahead" position:

$$\mathbf{v}_{t+1} = \mu \mathbf{v}_t - \eta \nabla_\theta \mathcal{J}(\theta + \mu \mathbf{v}_t)$$

$$\theta^{(t+1)} = \theta^{(t)} + \mathbf{v}_{t+1}$$

Corrects the momentum overshoot; converges faster than standard momentum on convex problems. Convergence rate $O(1/T^2)$ vs. $O(1/T)$ for GD.

## Noise and Generalization

SGD noise has a beneficial regularization effect:

**Flat minima hypothesis:** the gradient noise biases SGD toward wide, flat minima where $\lambda_{\max}(H)$ (largest Hessian eigenvalue) is small. Flat minima generalize better under distribution shift.

**Noise scale:** $N \propto \frac{\eta \sigma^2}{B}$. Increasing $\eta$ or decreasing $B$ increases noise.

**Linear scaling rule (Goyal et al.):** when multiplying $B$ by $k$, multiply $\eta$ by $k$ and use a linear warmup phase to maintain the effective noise scale.

## Learning Rate Schedule

SGD benefits significantly from decaying the learning rate over training.

| Schedule | Formula | Notes |
|----------|---------|-------|
| Step decay | $\eta_t = \eta_0 \cdot \gamma^{\lfloor t / s \rfloor}$ | Reduce by $\gamma$ every $s$ steps |
| Cosine annealing | $\eta_t = \eta_{\min} + \frac{1}{2}(\eta_0 - \eta_{\min})(1 + \cos(\pi t / T))$ | Smooth; very common |
| Linear decay | $\eta_t = \eta_0 (1 - t/T)$ | Simple; used in Transformers |
| Warmup | Linearly increase $\eta$ for first $w$ steps | Stabilizes early training |
| Cyclical (CLR) | Oscillates between $\eta_{\min}$ and $\eta_{\max}$ | Can improve final accuracy |
| 1-cycle | Warmup to $\eta_{\max}$, decay to $\eta_{\min}$, anneal to 0 | Used in fastai; strong results |

## Convergence of SGD

For a $\beta$-smooth non-convex function, SGD with $\eta_t = \eta_0 / \sqrt{T}$:

$$\frac{1}{T}\sum_{t=1}^T \mathbb{E}[\|\nabla \mathcal{J}(\theta^{(t)})\|^2] \leq O\!\left(\frac{\sigma}{\sqrt{T}}\right)$$

Converges to a stationary point (not necessarily a local minimum) at rate $O(1/\sqrt{T})$.

## Batch Size Effects

| Batch size | Gradient variance | Steps per epoch | Memory | Generalization |
|-----------|-----------------|-----------------|--------|---------------|
| 1 (pure SGD) | Very high | $n$ | Minimal | Often good |
| 32-256 (mini-batch) | Moderate | $n/B$ | Moderate | Good |
| $n$ (full batch) | Zero | 1 | High | Often worse |
| Very large ($>8192$) | Very low | Few | Very high | Degraded (needs careful LR tuning) |

Large-batch training degrades generalization unless compensated by increased $\eta$ (linear scaling rule) and warmup.

## SGD vs. Adam

| Property | SGD + Momentum | Adam |
|----------|----------------|------|
| Convergence speed | Slower (needs tuning) | Faster |
| Generalization | Often better (CV, language) | Comparable or slightly worse |
| Hyperparameter sensitivity | High (LR, momentum, schedule) | Lower (but $\beta_1, \beta_2, \epsilon$) |
| Sparse gradients | Poor | Good |
| Common use | ResNets, CNNs (image), LLM fine-tune | Transformers, NLP pretraining |

See [Optimization Algorithms](12-optimization-algorithms) for Adam, AdaGrad, RMSProp.
