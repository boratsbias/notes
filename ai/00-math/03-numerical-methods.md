# Numerical Methods

## Why Numerical Methods?

Most real-world problems in ML have no closed-form solution. Numerical methods find approximate solutions efficiently on a computer.

Key concerns:
- **Accuracy:** how close is the approximation to the true answer?
- **Stability:** does small error in input cause large error in output?
- **Efficiency:** how many operations does it take?

## Floating Point Arithmetic

Computers represent real numbers in IEEE 754 floating point (32-bit float, 64-bit double).

- **Machine epsilon:** $\epsilon_{\text{mach}} \approx 1.2 \times 10^{-7}$ (float32), $\approx 2.2 \times 10^{-16}$ (float64)
- **Underflow / overflow:** very small or large numbers lose precision
- **Catastrophic cancellation:** subtracting two nearly equal numbers amplifies relative error

**In ML:** float32 standard for training; bfloat16 or float16 used in mixed-precision training to save memory and speed up computation.

## Numerical Stability

An algorithm is **numerically stable** if errors do not amplify through computation.

**Example: computing variance:**
- Naive: $\text{Var}(X) = \frac{1}{n}\sum x_i^2 - \bar{x}^2$ → catastrophic cancellation
- Stable: Welford's online algorithm

**Softmax stability:** avoid overflow by subtracting max:
$$\text{softmax}(x_i) = \frac{e^{x_i - \max(\mathbf{x})}}{\sum_j e^{x_j - \max(\mathbf{x})}}$$

**Log-sum-exp trick:** $\log \sum_i e^{x_i} = \max(\mathbf{x}) + \log \sum_i e^{x_i - \max(\mathbf{x})}$

## Solving Linear Systems

$A\mathbf{x} = \mathbf{b}$

### Gaussian Elimination
Forward elimination + back substitution. $O(n^3)$ flops.

### LU Decomposition
$A = LU$ (with partial pivoting for stability). Solve $L\mathbf{y} = \mathbf{b}$, then $U\mathbf{x} = \mathbf{y}$.
- Efficient when solving multiple systems with the same $A$

### Cholesky Decomposition
For symmetric positive definite $A$: $A = LL^T$. Twice as fast as LU.
- Used in Gaussian processes, Kalman filters, covariance matrix operations

### Iterative Methods
For large sparse systems: **Conjugate Gradient (CG)**, **GMRES**. These converge without forming the full matrix, which is critical for large-scale ML.

## Numerical Differentiation

Approximate derivatives when analytical form is unavailable.

**Forward difference:** $f'(x) \approx \frac{f(x+h) - f(x)}{h}$, error $O(h)$

**Central difference:** $f'(x) \approx \frac{f(x+h) - f(x-h)}{2h}$, error $O(h^2)$

**Choice of $h$:** too large → truncation error; too small → cancellation error. Typically $h \approx \sqrt{\epsilon_{\text{mach}}}$.

**In ML:** used for gradient checking, to verify analytic gradients by comparing to numerical estimates.

## Automatic Differentiation (Autograd)

Distinct from numerical differentiation. Computes exact gradients by applying the chain rule to elementary operations.

**Forward mode:** compute $\dot{z} = \frac{\partial z}{\partial x}$ alongside the value. Efficient for few inputs.

**Reverse mode (backpropagation):** efficient for many inputs, few outputs (common in ML: one scalar loss). One forward pass + one backward pass.

**In practice:** PyTorch, JAX, TensorFlow implement reverse-mode autograd.

## Eigenvalue Computation

Exact formulas only exist for $n \leq 4$. For larger matrices:

- **Power iteration:** converges to the dominant eigenvector
- **QR algorithm:** iteratively applies QR decomposition to converge to eigenvalues
- **Lanczos algorithm:** efficient for large sparse symmetric matrices

Used in PCA, spectral methods, graph neural networks.

## Numerical Integration (Quadrature)

Approximate $\int_a^b f(x)\, dx$.

| Method | Rule | Error |
|--------|------|-------|
| Midpoint | $f(\frac{a+b}{2})(b-a)$ | $O(h^2)$ |
| Trapezoidal | $\frac{b-a}{2}[f(a)+f(b)]$ | $O(h^2)$ |
| Simpson's | $\frac{b-a}{6}[f(a)+4f(\frac{a+b}{2})+f(b)]$ | $O(h^4)$ |
| Gaussian quadrature | Optimal node placement | very high accuracy |

**Monte Carlo integration:** $\int f(x)p(x)dx \approx \frac{1}{N}\sum_i f(x_i)$, $x_i \sim p$.
- Error $O(1/\sqrt{N})$, dimension-independent. The only practical method in high dimensions.

## Interpolation and Approximation

**Polynomial interpolation:** fit a polynomial through data points.
- Lagrange interpolation, Newton's divided differences
- Runge's phenomenon: high-degree polynomials oscillate badly at boundaries

**Splines:** piecewise polynomials. Cubic splines are smooth ($C^2$) and stable.

**In ML:** used in feature engineering, upsampling, and signal processing.

## Root Finding

Find $x$ such that $f(x) = 0$.

| Method | Convergence | Notes |
|--------|-------------|-------|
| Bisection | Linear | Always converges if bracketed |
| Newton-Raphson | Quadratic | Requires $f'$, may diverge |
| Secant | Superlinear | No $f'$ needed, two starting points |

Newton-Raphson: $x_{t+1} = x_t - \frac{f(x_t)}{f'(x_t)}$

## Condition Number

Measures sensitivity of a problem to perturbations in input:

$$\kappa(A) = \|A\| \cdot \|A^{-1}\| = \frac{\sigma_{\max}}{\sigma_{\min}}$$

- $\kappa \approx 1$: well-conditioned
- $\kappa \gg 1$: ill-conditioned, small changes in $\mathbf{b}$ cause large changes in $\mathbf{x}$

**In ML:** ill-conditioned Gram matrices ($X^T X$) make training unstable → addressed via regularization or batch normalization.
