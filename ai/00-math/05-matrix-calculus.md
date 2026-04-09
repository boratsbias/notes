# Matrix Calculus

## Why Matrix Calculus?

Neural network parameters live in matrices and tensors. Computing gradients w.r.t. entire weight matrices (rather than scalar-by-scalar) requires matrix calculus, the language of vectorized backpropagation.

## Layout Conventions

Two competing conventions for arranging derivatives:

| Convention | Gradient of scalar $f$ w.r.t. vector $\mathbf{x}$ | Notes |
|------------|-----|-------|
| **Numerator layout** | Row vector $\frac{\partial f}{\partial \mathbf{x}} \in \mathbb{R}^{1 \times n}$ | Used in some ML texts |
| **Denominator layout** | Column vector $\frac{\partial f}{\partial \mathbf{x}} \in \mathbb{R}^{n \times 1}$ | Used in ML frameworks |

These notes use **denominator layout** (column gradient vector), consistent with most ML code.

## Scalar by Vector

For $f: \mathbb{R}^n \to \mathbb{R}$:

$$\frac{\partial f}{\partial \mathbf{x}} = \begin{bmatrix} \frac{\partial f}{\partial x_1} \\ \vdots \\ \frac{\partial f}{\partial x_n} \end{bmatrix} \in \mathbb{R}^n$$

**Common identities:**

| $f(\mathbf{x})$ | $\frac{\partial f}{\partial \mathbf{x}}$ |
|----------------|------------------------------------------|
| $\mathbf{a}^T \mathbf{x}$ | $\mathbf{a}$ |
| $\mathbf{x}^T \mathbf{a}$ | $\mathbf{a}$ |
| $\mathbf{x}^T \mathbf{x}$ | $2\mathbf{x}$ |
| $\mathbf{x}^T A \mathbf{x}$ | $(A + A^T)\mathbf{x}$ |
| $\mathbf{x}^T A \mathbf{x}$ (symmetric $A$) | $2A\mathbf{x}$ |

## Vector by Vector (Jacobian)

For $\mathbf{f}: \mathbb{R}^n \to \mathbb{R}^m$, the Jacobian:

$$J = \frac{\partial \mathbf{f}}{\partial \mathbf{x}} \in \mathbb{R}^{m \times n}, \quad J_{ij} = \frac{\partial f_i}{\partial x_j}$$

**Common identities:**

| $\mathbf{f}(\mathbf{x})$ | $\frac{\partial \mathbf{f}}{\partial \mathbf{x}}$ |
|--------------------------|---------------------------------------------------|
| $A\mathbf{x}$ | $A$ |
| $\mathbf{x}$ | $I$ |
| $\sigma(\mathbf{x})$ (elementwise) | $\text{diag}(\sigma'(\mathbf{x}))$ |

## Scalar by Matrix

For $f: \mathbb{R}^{m \times n} \to \mathbb{R}$, the gradient has the same shape as the matrix:

$$\frac{\partial f}{\partial A} \in \mathbb{R}^{m \times n}, \quad \left(\frac{\partial f}{\partial A}\right)_{ij} = \frac{\partial f}{\partial A_{ij}}$$

**Common identities:**

| $f(A)$ | $\frac{\partial f}{\partial A}$ |
|--------|--------------------------------|
| $\text{tr}(A)$ | $I$ |
| $\text{tr}(AB)$ | $B^T$ |
| $\text{tr}(A^T B)$ | $B$ |
| $\text{tr}(ABA^T)$ | $(B + B^T)A^T$ |
| $\log \det(A)$ | $A^{-T} = (A^{-1})^T$ |
| $\mathbf{a}^T A \mathbf{b}$ | $\mathbf{a}\mathbf{b}^T$ |

## The Chain Rule in Matrix Form

For $f(\mathbf{y})$ where $\mathbf{y} = A\mathbf{x} + \mathbf{b}$:

$$\frac{\partial f}{\partial \mathbf{x}} = A^T \frac{\partial f}{\partial \mathbf{y}}$$

For $f(\mathbf{y})$ where $\mathbf{y} = g(\mathbf{x})$:

$$\frac{\partial f}{\partial \mathbf{x}} = J_g^T \frac{\partial f}{\partial \mathbf{y}}$$

This is **exactly** what happens in a neural network backward pass.

## Gradients Through a Linear Layer

Layer: $\mathbf{y} = W\mathbf{x} + \mathbf{b}$, loss $\mathcal{L}$

Given upstream gradient $\frac{\partial \mathcal{L}}{\partial \mathbf{y}}$:

$$\frac{\partial \mathcal{L}}{\partial W} = \frac{\partial \mathcal{L}}{\partial \mathbf{y}} \mathbf{x}^T$$

$$\frac{\partial \mathcal{L}}{\partial \mathbf{b}} = \frac{\partial \mathcal{L}}{\partial \mathbf{y}}$$

$$\frac{\partial \mathcal{L}}{\partial \mathbf{x}} = W^T \frac{\partial \mathcal{L}}{\partial \mathbf{y}}$$

## Gradients Through Elementwise Operations

For $\mathbf{y} = \sigma(\mathbf{x})$ (elementwise activation):

$$\frac{\partial \mathcal{L}}{\partial \mathbf{x}} = \frac{\partial \mathcal{L}}{\partial \mathbf{y}} \odot \sigma'(\mathbf{x})$$

(elementwise product, since the Jacobian is diagonal)

## Softmax Jacobian

For softmax $\mathbf{p} = \text{softmax}(\mathbf{z})$:

$$\frac{\partial p_i}{\partial z_j} = p_i(\delta_{ij} - p_j)$$

In matrix form: $J = \text{diag}(\mathbf{p}) - \mathbf{p}\mathbf{p}^T$

Combined with cross-entropy loss: $\frac{\partial \mathcal{L}}{\partial \mathbf{z}} = \mathbf{p} - \mathbf{y}$ (clean formula).

## Trace and Cyclic Property

$$\text{tr}(ABC) = \text{tr}(CAB) = \text{tr}(BCA)$$

Cyclic invariance is frequently used to rearrange matrix derivative expressions.

## Vectorization

The **vec** operator stacks columns of a matrix into a vector:

$$\text{vec}(A) \in \mathbb{R}^{mn}$$

**Kronecker product** $A \otimes B$: used to express matrix derivatives as standard vector Jacobians:

$$\text{vec}(AXB) = (B^T \otimes A)\text{vec}(X)$$

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Gradient of $W$ in linear layer | Backprop weight update |
| Jacobian of activations | Backprop through nonlinearities |
| Softmax Jacobian | Classification output layer gradient |
| $\log\det$ gradient | Normalizing flows, Gaussian log-likelihood |
| Trace identities | Deriving gradients analytically |
| Chain rule in matrix form | The entire backpropagation algorithm |
