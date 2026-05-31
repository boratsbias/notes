# Adam: A Method for Stochastic Optimization (2014)

**Authors:** Diederich P. Kingma, Jimmy Ba
**Area:** Optimization, Deep Learning
**Link:** [arXiv](https://arxiv.org/abs/1412.6980)

## What the paper argues

SGD uses one global learning rate for every parameter. This is inefficient: a parameter that receives large, frequent gradient updates needs a smaller step, while a rarely updated parameter needs a larger one. Adam combines momentum (first moment) and per-parameter adaptive rates (second moment) into a single optimizer that works well across tasks with little tuning.

## The two moments

For each parameter, Adam maintains two running averages updated at every step:

```
m_t = β₁ · m_{t-1} + (1 - β₁) · g_t        ← first moment (momentum)
v_t = β₂ · v_{t-1} + (1 - β₂) · g_t²       ← second moment (gradient variance)
```

Defaults: β₁ = 0.9, β₂ = 0.999.

## Bias correction and the update

Both moments are initialized at zero, so they are biased toward zero in early steps. Adam corrects this before applying the update:

```
m̂_t = m_t / (1 - β₁ᵗ)
v̂_t = v_t / (1 - β₂ᵗ)

θ_t = θ_{t-1} - α · m̂_t / (√v̂_t + ε)
```

Default: α = 0.001, ε = 10⁻⁸. The denominator scales the step down for parameters with historically large gradients and up for those with small ones. As training progresses the bias correction terms approach 1 and the correction disappears.

## Results and impact

Adam converges reliably with default hyperparameters across image classification, language modeling, and generative models. It became the default optimizer in deep learning and is used to train virtually all large language models and diffusion models today.
