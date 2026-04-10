# Optimization Algorithms

Optimization algorithms update neural network parameters to minimize the training loss. Beyond vanilla gradient descent, adaptive methods adjust the effective learning rate per parameter, enabling faster convergence and better handling of sparse gradients and ill-conditioned loss landscapes.

## Vanilla SGD with Momentum (Recap)

$$\mathbf{v}_t = \mu \mathbf{v}_{t-1} + \eta \nabla_\theta \mathcal{J}_t$$

$$\theta_t = \theta_{t-1} - \mathbf{v}_t$$

See [Stochastic Gradient Descent](06-stochastic-gradient-descent) for full treatment.

## AdaGrad

Adapts the learning rate per parameter by dividing by the square root of the sum of squared gradients:

$$G_t = G_{t-1} + g_t^2 \quad \text{(accumulated squared gradient)}$$

$$\theta_t = \theta_{t-1} - \frac{\eta}{\sqrt{G_t + \epsilon}} g_t$$

**Effect:** parameters with large historical gradients receive smaller updates; sparse features get larger updates early when gradients are rare.

**Problem:** $G_t$ grows monotonically; learning rate decays to zero and training stalls. Unsuitable for non-convex or long-running problems.

**Use:** good for sparse problems (e.g., word embeddings with rare words); rarely used for deep networks today.

## RMSProp

Fixes AdaGrad's shrinking learning rate by using an **exponential moving average** of squared gradients:

$$v_t = \rho v_{t-1} + (1-\rho) g_t^2$$

$$\theta_t = \theta_{t-1} - \frac{\eta}{\sqrt{v_t + \epsilon}} g_t$$

- $\rho \approx 0.9$: decay rate (discounts old gradients).
- $\epsilon \approx 10^{-8}$: numerical stability.

Learning rate does not collapse because old gradients are forgotten. Default in some RNN training regimes.

## Adam (Adaptive Moment Estimation)

Combines momentum (first moment) with RMSProp's adaptive learning rate (second moment):

**First moment (mean of gradients):**

$$m_t = \beta_1 m_{t-1} + (1-\beta_1) g_t$$

**Second moment (uncentered variance):**

$$v_t = \beta_2 v_{t-1} + (1-\beta_2) g_t^2$$

**Bias correction** (compensates for zero initialization of $m_0, v_0$):

$$\hat{m}_t = \frac{m_t}{1 - \beta_1^t}, \quad \hat{v}_t = \frac{v_t}{1 - \beta_2^t}$$

**Update:**

$$\theta_t = \theta_{t-1} - \frac{\eta}{\sqrt{\hat{v}_t} + \epsilon} \hat{m}_t$$

**Default hyperparameters:** $\beta_1 = 0.9$, $\beta_2 = 0.999$, $\epsilon = 10^{-8}$, $\eta = 10^{-3}$.

**Properties:**
- Per-parameter adaptive rates.
- First moment smooths noisy gradients.
- Bias correction critical in early steps.
- Effectively scales each parameter's gradient by $1/\sqrt{\hat{v}_t}$: large-gradient parameters get smaller steps.

**Convergence:** proved for convex objectives; empirically works well for non-convex deep nets. However, Adam may converge to sharper minima than SGD, sometimes hurting generalization.

## AdamW (Adam with Decoupled Weight Decay)

Standard Adam with L2 regularization adds $\lambda \theta$ to the gradient before scaling: this makes the effective weight decay dependent on $\hat{v}_t$ (larger for low-gradient parameters). AdamW decouples weight decay from the gradient update:

$$\theta_t = \theta_{t-1} - \frac{\eta}{\sqrt{\hat{v}_t} + \epsilon} \hat{m}_t - \eta \lambda \theta_{t-1}$$

The weight decay term $\eta\lambda\theta_{t-1}$ is applied after the adaptive step, not before.

**Consequence:** correct L2 regularization for adaptive optimizers. Default optimizer for Transformers (BERT, GPT, LLaMA). Typical $\lambda = 0.01$–$0.1$.

## Nadam (Nesterov Adam)

Incorporates Nesterov momentum into Adam by computing the gradient at the look-ahead position. Marginal improvements over Adam in practice.

## AMSGrad

Fixes a convergence issue in Adam by using the maximum of past squared gradients:

$$\hat{v}_t = \max(\hat{v}_{t-1}, v_t)$$

Guarantees convergence in convex settings. Not consistently better empirically.

## Lion (EvoLved Sign Momentum)

Discovered via program search (Google Brain, 2023). Uses the sign of the update:

$$c_t = \beta_1 m_{t-1} + (1-\beta_1) g_t$$

$$\theta_t = \theta_{t-1} - \eta (\text{sign}(c_t) + \lambda \theta_{t-1})$$

$$m_t = \beta_2 m_{t-1} + (1-\beta_2) g_t$$

**Properties:** memory-efficient (only one moment state vs. two for Adam); uniform update magnitude (no adaptive learning rate); strong regularization. Competitive with AdamW for large-scale vision and language models.

## Sharpness-Aware Minimization (SAM)

Seeks parameters in flat loss regions (generalize better) by perturbing parameters toward the direction of maximal loss increase, then computing the gradient:

$$\theta_{t+1} = \theta_t - \eta \nabla_\theta \mathcal{J}(\theta_t + \rho \cdot \hat{g}_t / \|\hat{g}_t\|)$$

Requires two forward-backward passes per step ($2\times$ cost). Consistently improves generalization across vision and language tasks.

## Comparison

| Optimizer | Adaptive | Momentum | Memory (extra) | Best For |
|-----------|----------|----------|----------------|---------|
| SGD | No | Optional | $O(p)$ (momentum) | CNNs, image classification |
| AdaGrad | Yes | No | $O(p)$ | Sparse features |
| RMSProp | Yes | No | $O(p)$ | RNNs |
| Adam | Yes | Yes | $O(2p)$ | Fast convergence, Transformers |
| AdamW | Yes | Yes | $O(2p)$ | All Transformers (default) |
| Lion | No (sign) | Yes | $O(p)$ | Large-scale models |
| SAM | No | Optional | $O(p)$ | When generalization is critical |

## Learning Rate Schedules

All optimizers benefit from learning rate scheduling. See [Stochastic Gradient Descent](06-stochastic-gradient-descent) for schedule types (cosine, warmup, 1-cycle, etc.).

**Warmup** is especially important for Adam-family optimizers: in early steps, $\hat{v}_t$ underestimates the true second moment, causing large steps. Warmup by starting with a small $\eta$ prevents instability.

## Gradient Clipping

Applied before any parameter update:

$$g \leftarrow g \cdot \min\!\left(1, \frac{\tau}{\|g\|}\right)$$

Essential with Adam for Transformers. Typical $\tau = 1.0$.

## Practical Recommendations

- **Default choice:** AdamW with cosine decay and linear warmup.
- **Image classification from scratch:** SGD with momentum ($\eta = 0.1$, $\mu = 0.9$, cosine decay, weight decay $10^{-4}$).
- **Transformer pretraining:** AdamW ($\beta_1=0.9$, $\beta_2=0.95$–$0.999$, $\epsilon=10^{-8}$, $\lambda=0.1$, warmup + cosine decay).
- **Fine-tuning:** AdamW with small $\eta$ ($10^{-5}$–$10^{-4}$), minimal weight decay.
- **RNNs:** Adam or RMSProp.
