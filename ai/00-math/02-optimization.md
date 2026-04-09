# Optimization

## The Problem

Find parameters $\theta$ that minimize (or maximize) an objective function:

$$\theta^* = \arg\min_\theta \mathcal{L}(\theta)$$

In ML, $\mathcal{L}$ is the loss function computed over training data.

## Conditions for Optimality

**First-order necessary condition:** $\nabla \mathcal{L}(\theta^*) = 0$ (gradient is zero at a critical point)

**Second-order conditions:**
- Local minimum: $\nabla \mathcal{L} = 0$ and $H \succ 0$ (positive definite Hessian)
- Local maximum: $\nabla \mathcal{L} = 0$ and $H \prec 0$
- Saddle point: $\nabla \mathcal{L} = 0$ and $H$ indefinite

**Convex functions** have only global minima, so any local minimum is global.

## Gradient Descent

Iteratively move in the negative gradient direction:

$$\theta_{t+1} = \theta_t - \eta \nabla \mathcal{L}(\theta_t)$$

where $\eta$ is the **learning rate** (step size).

### Variants

| Variant | Gradient computed over | Notes |
|---------|----------------------|-------|
| Batch GD | Entire dataset | Accurate but slow per step |
| Stochastic GD (SGD) | Single sample | Noisy but fast, good regularization effect |
| Mini-batch GD | Small batch (e.g. 32–512) | Standard in deep learning |

### Learning Rate

- Too large → diverges or oscillates
- Too small → slow convergence
- Tuned via grid search, learning rate schedules, or adaptive methods

## Momentum

Accumulates velocity in the gradient direction to smooth updates and escape local optima:

$$v_{t+1} = \beta v_t + \nabla \mathcal{L}(\theta_t)$$

$$\theta_{t+1} = \theta_t - \eta v_{t+1}$$

Typical $\beta = 0.9$.

## Adaptive Optimizers

### AdaGrad
Scales learning rate by accumulated squared gradients, giving large updates for rare features:

$$G_t = G_{t-1} + g_t^2, \quad \theta_{t+1} = \theta_t - \frac{\eta}{\sqrt{G_t + \epsilon}} g_t$$

Downside: learning rate monotonically decreases to zero.

### RMSProp
Uses exponential moving average of squared gradients (fixes AdaGrad's diminishing rate):

$$G_t = \rho G_{t-1} + (1-\rho) g_t^2$$

### Adam (Adaptive Moment Estimation)
Combines momentum (first moment) + RMSProp (second moment):

$$m_t = \beta_1 m_{t-1} + (1-\beta_1) g_t$$

$$v_t = \beta_2 v_{t-1} + (1-\beta_2) g_t^2$$

$$\hat{m}_t = \frac{m_t}{1-\beta_1^t}, \quad \hat{v}_t = \frac{v_t}{1-\beta_2^t}$$

$$\theta_{t+1} = \theta_t - \frac{\eta}{\sqrt{\hat{v}_t} + \epsilon} \hat{m}_t$$

Default hyperparameters: $\beta_1 = 0.9$, $\beta_2 = 0.999$, $\epsilon = 10^{-8}$.

Most widely used optimizer in deep learning.

### AdamW
Adam with decoupled weight decay. Applies L2 regularization directly to weights, not through the gradient. Fixes Adam's poor weight decay behavior.

## Newton's Method

Uses second-order information (Hessian) for faster convergence:

$$\theta_{t+1} = \theta_t - H^{-1} \nabla \mathcal{L}(\theta_t)$$

- Quadratic convergence near optimum
- Computing and inverting $H$ is $O(n^3)$, infeasible for large models

**Quasi-Newton methods** (L-BFGS) approximate the Hessian from gradient history. Used in smaller ML problems.

## Convexity

A function $f$ is convex if:

$$f(\lambda x + (1-\lambda)y) \leq \lambda f(x) + (1-\lambda) f(y) \quad \forall \lambda \in [0,1]$$

- Convex: linear regression, logistic regression, SVMs, lasso
- Non-convex: neural networks (multiple local minima, saddle points)

**In practice:** deep networks are non-convex but gradient descent works well due to the loss landscape properties. Most local minima have similar loss values.

## Learning Rate Schedules

| Schedule | Description |
|----------|-------------|
| Step decay | Multiply $\eta$ by factor every $k$ epochs |
| Exponential decay | $\eta_t = \eta_0 e^{-kt}$ |
| Cosine annealing | $\eta$ follows cosine curve to near-zero |
| Warmup | Ramp up $\eta$ for first few steps, then decay |
| Cyclical | Oscillate between min and max $\eta$ |

## Regularization (as Constrained Optimization)

Adds a penalty term to prevent overfitting:

$$\mathcal{L}_{reg}(\theta) = \mathcal{L}(\theta) + \lambda R(\theta)$$

| Regularizer | Penalty | Effect |
|-------------|---------|--------|
| L2 (Ridge) | $\lVert\theta\rVert_2^2$ | Small weights, smooth solution |
| L1 (Lasso) | $\lVert\theta\rVert_1$ | Sparse weights, feature selection |
| Elastic Net | $\alpha\lVert\theta\rVert_1 + (1-\alpha)\lVert\theta\rVert_2^2$ | Combines both |

## Constrained Optimization

Minimize $f(\mathbf{x})$ subject to $g_i(\mathbf{x}) = 0$ and $h_j(\mathbf{x}) \leq 0$.

**Lagrangian:** $\mathcal{L}(\mathbf{x}, \lambda, \mu) = f(\mathbf{x}) + \sum_i \lambda_i g_i(\mathbf{x}) + \sum_j \mu_j h_j(\mathbf{x})$

**KKT conditions** generalize this to inequality constraints.

Used in SVMs, RLHF, and constrained policy optimization.

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| SGD / Adam | Training all neural networks |
| Gradient descent | Loss minimization |
| Convexity | Proofs of convergence for linear models |
| Momentum | Faster training, escaping flat regions |
| LR schedules | Training stability and final performance |
| Constrained opt. | SVMs, RL policy optimization, safety |
