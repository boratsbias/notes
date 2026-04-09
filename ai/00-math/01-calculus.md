# Calculus

## Derivatives

The derivative of $f(x)$ measures the instantaneous rate of change:

$$f'(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$$

### Common Rules

| Rule | Formula |
|------|---------|
| Power | $\frac{d}{dx} x^n = nx^{n-1}$ |
| Chain | $\frac{d}{dx} f(g(x)) = f'(g(x)) \cdot g'(x)$ |
| Product | $\frac{d}{dx} [f \cdot g] = f'g + fg'$ |
| Quotient | $\frac{d}{dx} [f/g] = (f'g - fg') / g^2$ |
| Sum | $\frac{d}{dx} [f + g] = f' + g'$ |

### Common Derivatives

| Function | Derivative |
|----------|-----------|
| $e^x$ | $e^x$ |
| $\ln x$ | $1/x$ |
| $\sin x$ | $\cos x$ |
| $\cos x$ | $-\sin x$ |
| $\sigma(x) = \frac{1}{1+e^{-x}}$ | $\sigma(x)(1 - \sigma(x))$ |
| $\tanh(x)$ | $1 - \tanh^2(x)$ |
| $\text{ReLU}(x)$ | $0$ if $x<0$, $1$ if $x>0$ |

## Partial Derivatives

For $f(x_1, x_2, \ldots, x_n)$, the partial derivative with respect to $x_i$ treats all other variables as constants:

$$\frac{\partial f}{\partial x_i}$$

## Gradient

The gradient $\nabla f$ is the vector of all partial derivatives:

$$\nabla f(\mathbf{x}) = \left[\frac{\partial f}{\partial x_1}, \frac{\partial f}{\partial x_2}, \ldots, \frac{\partial f}{\partial x_n}\right]^T$$

- Points in the direction of steepest ascent
- Gradient descent moves opposite to the gradient to minimize $f$

## Jacobian

For a vector-valued function $\mathbf{f}: \mathbb{R}^n \to \mathbb{R}^m$, the Jacobian is the $m \times n$ matrix of all partial derivatives:

$$J_{ij} = \frac{\partial f_i}{\partial x_j}$$

Used heavily in backpropagation: the Jacobian of layer outputs w.r.t. inputs.

## Hessian

For $f: \mathbb{R}^n \to \mathbb{R}$, the Hessian $H$ is the $n \times n$ matrix of second-order partial derivatives:

$$H_{ij} = \frac{\partial^2 f}{\partial x_i \partial x_j}$$

- Symmetric if $f$ has continuous second derivatives
- Positive definite Hessian → local minimum
- Negative definite Hessian → local maximum
- Indefinite Hessian → saddle point

## Chain Rule (Multivariable)

If $\mathbf{y} = f(\mathbf{x})$ and $z = g(\mathbf{y})$:

$$\frac{\partial z}{\partial x_i} = \sum_j \frac{\partial z}{\partial y_j} \frac{\partial y_j}{\partial x_i}$$

In matrix form: $\frac{\partial z}{\partial \mathbf{x}} = J_f^T \frac{\partial z}{\partial \mathbf{y}}$

This is the foundation of **backpropagation**.

## Taylor Series

Approximates a function around a point $a$:

$$f(x) = f(a) + f'(a)(x-a) + \frac{f''(a)}{2!}(x-a)^2 + \cdots$$

**First-order (linear) approximation:**

$$f(\mathbf{x} + \delta) \approx f(\mathbf{x}) + \nabla f(\mathbf{x})^T \delta$$

**Second-order approximation:**

$$f(\mathbf{x} + \delta) \approx f(\mathbf{x}) + \nabla f(\mathbf{x})^T \delta + \frac{1}{2} \delta^T H \delta$$

Used in Newton's method and second-order optimizers.

## Integration

$$\int_a^b f(x)\, dx$$

**Fundamental Theorem of Calculus:** $\frac{d}{dx} \int_a^x f(t)\, dt = f(x)$

**Key integral identities:**
- $\int e^x dx = e^x + C$
- $\int x^n dx = \frac{x^{n+1}}{n+1} + C$ (for $n \neq -1$)
- $\int \frac{1}{x} dx = \ln\lvert x \rvert + C$

**Gaussian integral:** $\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$

Used extensively in probability distributions and variational inference.

## Multivariable Integration

- **Change of variables:** introduces the Jacobian determinant $\lvert \det J \rvert$
- **Monte Carlo integration:** approximate $\int f(x) p(x) dx \approx \frac{1}{N}\sum_i f(x_i)$ where $x_i \sim p$

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Gradient | Gradient descent, backprop |
| Chain rule | Backpropagation through layers |
| Jacobian | Layer-wise gradients in neural nets |
| Hessian | Newton's method, curvature in loss landscape |
| Taylor expansion | Optimizer analysis, perturbation methods |
| Integration | Probabilistic inference, normalizing constants |
| Sigmoid/tanh derivatives | Activation function gradients |
