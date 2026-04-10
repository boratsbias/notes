# Gradient Descent

## Core Idea

Gradient descent minimizes a differentiable loss $\mathcal{J}(\theta)$ by iteratively moving parameters in the direction of the negative gradient. The gradient $\nabla_\theta \mathcal{J}$ points in the direction of steepest ascent; moving opposite to it decreases the loss.

$$\theta \leftarrow \theta - \eta \nabla_\theta \mathcal{J}(\theta)$$

## Formal Setup

**Objective:** $\min_\theta \mathcal{J}(\theta) = \frac{1}{n}\sum_{i=1}^n \mathcal{L}(f_\theta(x_i), y_i)$

**Gradient:** $\nabla_\theta \mathcal{J}(\theta) \in \mathbb{R}^p$ where $p = |\theta|$

**Learning rate (step size):** $\eta > 0$

**Update rule:**

$$\theta^{(t+1)} = \theta^{(t)} - \eta \nabla_\theta \mathcal{J}(\theta^{(t)})$$

## Batch (Full) Gradient Descent

Computes the exact gradient using all $n$ training examples per update:

$$\nabla_\theta \mathcal{J} = \frac{1}{n}\sum_{i=1}^n \nabla_\theta \mathcal{L}(f_\theta(x_i), y_i)$$

**Advantages:**
- Exact gradient; deterministic updates.
- Guaranteed to converge to a local minimum for convex objectives (with appropriate $\eta$).

**Disadvantages:**
- One update requires processing all $n$ samples: $O(n)$ per step.
- Impractical for large datasets.
- Converges slowly; does not escape shallow local minima.

## Convergence Analysis

For a $\beta$-smooth convex function (Lipschitz-continuous gradient, $\|\nabla f(x) - \nabla f(y)\| \leq \beta \|x - y\|$):

With $\eta = 1/\beta$:

$$\mathcal{J}(\theta^{(T)}) - \mathcal{J}(\theta^*) \leq \frac{\beta \|\theta^{(0)} - \theta^*\|^2}{2T}$$

Convergence rate: $O(1/T)$. For $\mu$-strongly convex functions: linear convergence $O(\exp(-\mu T / \beta))$.

## Learning Rate

The learning rate $\eta$ is the most critical hyperparameter.

| $\eta$ value | Behavior |
|-------------|---------|
| Too large | Diverges or oscillates; may overshoot minimum |
| Too small | Converges very slowly |
| Well-chosen | Smooth, efficient convergence |
| Adaptive | Adjusts per-parameter (AdaGrad, Adam) |

**Choosing $\eta$:**
- Start at $10^{-3}$ for Adam, $10^{-1}$ for SGD with momentum.
- Use learning rate range test (LR finder): increase $\eta$ exponentially over one epoch; pick value just before loss diverges.
- Lipschitz constant of loss provides a theoretical upper bound: $\eta < 1/L$.

## Gradient Descent on Non-Convex Objectives

Neural network losses are non-convex. Key phenomena:

**Local minima:** points where $\nabla \mathcal{J} = 0$ and Hessian is positive definite. In high dimensions, most critical points are saddle points, not local minima.

**Saddle points:** $\nabla \mathcal{J} = 0$ but Hessian is indefinite. Gradient descent slows near saddle points; perturbation or momentum helps escape.

**Plateaus:** regions where $\|\nabla \mathcal{J}\| \approx 0$ but $\mathcal{J}$ is not at a minimum.

**Sharp vs. flat minima:** flat minima (low Hessian eigenvalues) generalize better. Sharp minima have high curvature and are more sensitive to parameter perturbations.

## Loss Landscape Geometry

For an $L$-layer neural network with width $n \to \infty$: in the infinite-width limit, the loss landscape becomes convex (Neural Tangent Kernel regime). In practice, overparameterization still helps gradient descent find good solutions.

**Implicit regularization:** gradient descent with small $\eta$ and large batch finds solutions with specific inductive biases (e.g., minimum norm solutions for overparameterized linear models).

## Gradient Clipping

Prevents exploding gradients by scaling the gradient when its norm exceeds a threshold $\tau$:

$$g \leftarrow \begin{cases} g & \|g\| \leq \tau \\ \tau \cdot g / \|g\| & \|g\| > \tau \end{cases}$$

Critical for RNNs and Transformers on long sequences. Typical $\tau \in [0.5, 5.0]$.

## Comparison of Gradient Descent Variants

| Variant | Gradient Estimate | Batch Size | Notes |
|---------|------------------|-----------|-------|
| Batch GD | Exact | $n$ | Deterministic; slow |
| Stochastic GD (SGD) | Single sample | 1 | Noisy; fast updates |
| Mini-batch GD | Approximate | $B$ | Best in practice |

See [Stochastic Gradient Descent](06-stochastic-gradient-descent) and [Optimization Algorithms](12-optimization-algorithms) for variants with momentum, adaptive rates, etc.
