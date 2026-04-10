# Backpropagation

## Core Idea

**Backpropagation** (backprop) is an efficient algorithm for computing the gradient of the loss $\mathcal{L}$ with respect to all network parameters $\theta$ by applying the **chain rule** in reverse order through the computational graph. It runs in $O(p)$ time (proportional to the number of parameters), the same cost as a single forward pass.

## The Chain Rule

For a composition $f(g(x))$:

$$\frac{df}{dx} = \frac{df}{dg} \cdot \frac{dg}{dx}$$

For a multi-variable composition $\ell = \mathcal{L}(z)$, $z = Wh + b$:

$$\frac{\partial \mathcal{L}}{\partial W} = \frac{\partial \mathcal{L}}{\partial z} \cdot \frac{\partial z}{\partial W}$$

Backpropagation applies this chain rule systematically across all layers.

## Forward Pass

Compute and cache intermediate activations $\{\mathbf{z}^{(l)}, \mathbf{h}^{(l)}\}$ for each layer $l = 1, \ldots, L$:

$$\mathbf{z}^{(l)} = W^{(l)} \mathbf{h}^{(l-1)} + \mathbf{b}^{(l)}$$

$$\mathbf{h}^{(l)} = \sigma^{(l)}(\mathbf{z}^{(l)})$$

**Output:** $\hat{\mathbf{y}} = \mathbf{h}^{(L)}$, then compute $\mathcal{L}(\hat{\mathbf{y}}, \mathbf{y})$.

These cached values are reused during the backward pass.

## Backward Pass

Define the **error signal** (upstream gradient) at layer $l$:

$$\boldsymbol{\delta}^{(l)} = \frac{\partial \mathcal{L}}{\partial \mathbf{z}^{(l)}}$$

**Output layer** ($l = L$):

$$\boldsymbol{\delta}^{(L)} = \frac{\partial \mathcal{L}}{\partial \mathbf{z}^{(L)}} = \frac{\partial \mathcal{L}}{\partial \hat{\mathbf{y}}} \odot \sigma'^{(L)}(\mathbf{z}^{(L)})$$

For softmax + cross-entropy: $\boldsymbol{\delta}^{(L)} = \hat{\mathbf{y}} - \mathbf{y}$ (clean closed form).

**Propagation** (layer $l$ from $l+1$):

$$\boldsymbol{\delta}^{(l)} = \left(W^{(l+1)T} \boldsymbol{\delta}^{(l+1)}\right) \odot \sigma'^{(l)}(\mathbf{z}^{(l)})$$

**Parameter gradients:**

$$\frac{\partial \mathcal{L}}{\partial W^{(l)}} = \boldsymbol{\delta}^{(l)} (\mathbf{h}^{(l-1)})^T$$

$$\frac{\partial \mathcal{L}}{\partial \mathbf{b}^{(l)}} = \boldsymbol{\delta}^{(l)}$$

## Algorithm Summary

```
Forward pass:
  for l = 1 to L:
    z[l] = W[l] @ h[l-1] + b[l]
    h[l] = σ(z[l])
  compute L(h[L], y)

Backward pass:
  δ[L] = ∂L/∂z[L]
  for l = L-1 downto 1:
    δ[l] = (W[l+1].T @ δ[l+1]) * σ'(z[l])
  
  for l = 1 to L:
    ∂L/∂W[l] = δ[l] @ h[l-1].T
    ∂L/∂b[l] = δ[l]
```

## Computational Cost

- **Forward pass:** $O(\sum_l n_l \cdot n_{l-1})$ multiplications.
- **Backward pass:** same asymptotic cost as forward pass ($\approx 2\times$ wall-clock time).
- **Memory:** $O(\sum_l n_l)$ to store activations. Memory grows with depth and batch size.

## Automatic Differentiation (Autograd)

Modern frameworks implement backprop via **automatic differentiation**, not symbolic or numerical differentiation.

**Forward mode AD:** accumulates derivatives alongside the primal computation. Efficient when input dimension is small; $O(p)$ passes for $p$ parameters.

**Reverse mode AD (backprop):** one backward pass computes all $p$ partial derivatives simultaneously. $O(1)$ passes regardless of $p$. Ideal for neural networks where $p \gg$ number of outputs.

**Tape-based (eager):** PyTorch records operations dynamically; backward traverses the recorded tape.

**Symbolic/compiled:** TensorFlow (v1), JAX's `jit`: builds static computation graph; enables optimization passes (operation fusion, XLA compilation).

## Vanishing and Exploding Gradients

The gradient at layer $l$ involves a product of Jacobians:

$$\frac{\partial \mathcal{L}}{\partial \mathbf{h}^{(l)}} = \frac{\partial \mathcal{L}}{\partial \mathbf{h}^{(L)}} \prod_{k=l}^{L-1} \frac{\partial \mathbf{h}^{(k+1)}}{\partial \mathbf{h}^{(k)}}$$

Each Jacobian factor is $W^{(k)T} \cdot \text{diag}(\sigma'(\mathbf{z}^{(k)}))$.

**Vanishing:** if $\|W^{(k)T}\| \cdot \|\sigma'(\mathbf{z}^{(k)})\| < 1$ on average, the product shrinks exponentially with depth. Early layers learn extremely slowly.

**Exploding:** if the product grows exponentially, gradients blow up. Weights diverge.

**Solutions:**

| Problem | Solution |
|---------|---------|
| Vanishing | ReLU activation, residual connections, careful init |
| Exploding | Gradient clipping, careful init, weight norm |
| Both | Batch normalization, layer normalization |

## Jacobians and the General Case

For vector-to-vector functions $\mathbf{f}: \mathbb{R}^m \to \mathbb{R}^n$, the Jacobian is:

$$J_f = \frac{\partial \mathbf{f}}{\partial \mathbf{x}} \in \mathbb{R}^{n \times m}$$

Backprop computes **vector-Jacobian products (VJPs)** $\mathbf{v}^T J_f$, where $\mathbf{v}$ is the upstream gradient. This is cheaper than materializing the full Jacobian.

## Numerical Gradient Checking

Finite difference approximation to verify backprop implementation:

$$\frac{\partial \mathcal{L}}{\partial \theta_i} \approx \frac{\mathcal{L}(\theta + \epsilon e_i) - \mathcal{L}(\theta - \epsilon e_i)}{2\epsilon}$$

Use $\epsilon = 10^{-5}$. Compare against analytical gradient; relative error should be $< 10^{-5}$. Only used for debugging; too expensive for training.
