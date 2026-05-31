# Adam: A Method for Stochastic Optimization (2014)

**Authors:** Diederik P. Kingma, Jimmy Ba
**Area:** Optimization, Deep Learning
**Link:** [arXiv](https://arxiv.org/abs/1412.6980)

## Why fixed learning rates fail

Standard SGD applies the same step size to every parameter at every update. For sparse inputs, most parameters receive near-zero gradients for many steps, then a large gradient when their feature fires. A global learning rate calibrated for dense parameters is too large for sparse ones, causing instability, and too small for frequent ones, causing slow convergence. The challenge deepens in deep networks where gradients vary widely in scale across layers and training objectives span computer vision, NLP, and reinforcement learning simultaneously.

## The two moments

Adam maintains two running statistics per parameter. The **first moment** m_t is an exponential moving average of past gradients, acting as a momentum term that smooths noisy gradient estimates and carries updates through flat regions of the loss surface:

```
m_t = β₁·m_{t-1} + (1−β₁)·g_t
```

The **second moment** v_t is an exponential moving average of squared gradients, estimating per-parameter gradient variance. Parameters with consistently large gradients accumulate a large v_t, shrinking their effective step size. Parameters with rare updates keep a near-zero v_t and take larger steps when their gradient finally arrives:

```
v_t = β₂·v_{t-1} + (1−β₂)·g_t²
```

## Bias correction and the update rule

Both moments are initialized at zero. Early in training this biases them toward zero, making updates too conservative before the estimates have warmed up. Bias correction divides each moment by a term that starts small and grows toward one:

```
m̂_t = m_t / (1−β₁ᵗ)
v̂_t = v_t / (1−β₂ᵗ)
θ_t = θ_{t-1} − α·m̂_t / (√v̂_t + ε)
```

Default hyperparameters α=0.001, β₁=0.9, β₂=0.999, ε=10⁻⁸ transfer across architectures and tasks without manual tuning.

## Results and impact

Adam was evaluated on logistic regression, multi-layer networks, convolutional networks, and variational autoencoders, outperforming SGD with momentum and Adagrad across most settings with the same defaults. It became the standard optimizer in deep learning research and practice, and is the default in PyTorch and TensorFlow. Its practical appeal is that it combines per-parameter adaptation with momentum in a single low-memory algorithm that requires no careful tuning to produce reasonable results on a new problem.
