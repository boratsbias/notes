# Vector Spaces

## Definition

A **vector space** $V$ over a field $\mathbb{F}$ (usually $\mathbb{R}$) is a set of objects (vectors) with two operations:
- **Addition:** $\mathbf{u} + \mathbf{v} \in V$
- **Scalar multiplication:** $c\mathbf{v} \in V$

satisfying 8 axioms (closure, associativity, commutativity, identity, inverse, distributivity, compatibility, unitary).

**Examples:**
- $\mathbb{R}^n$ (standard Euclidean space)
- Set of polynomials of degree $\leq n$
- Set of continuous functions on $[a, b]$
- Set of $m \times n$ matrices

## Subspaces

A subset $S \subseteq V$ is a **subspace** if it is closed under addition and scalar multiplication, and contains $\mathbf{0}$.

**Four fundamental subspaces of a matrix $A \in \mathbb{R}^{m \times n}$:**

| Subspace | Definition | Dimension |
|----------|-----------|-----------|
| Column space $C(A)$ | $\{A\mathbf{x} : \mathbf{x} \in \mathbb{R}^n\}$ | rank$(A)$ |
| Null space $N(A)$ | $\{\mathbf{x} : A\mathbf{x} = \mathbf{0}\}$ | $n - $ rank$(A)$ |
| Row space $C(A^T)$ | span of rows of $A$ | rank$(A)$ |
| Left null space $N(A^T)$ | $\{\mathbf{y} : A^T\mathbf{y} = \mathbf{0}\}$ | $m - $ rank$(A)$ |

**Rank-nullity theorem:** dim$(C(A))$ + dim$(N(A))$ = $n$

## Basis and Dimension

A **basis** of $V$ is a set of vectors that are:
1. **Linearly independent**
2. **Spanning** (every $\mathbf{v} \in V$ can be written as a linear combination)

The **dimension** of $V$ = number of vectors in any basis.

**Standard basis** of $\mathbb{R}^n$: $\{\mathbf{e}_1, \ldots, \mathbf{e}_n\}$ (unit coordinate vectors)

Every vector has a **unique** representation in a given basis.

## Span

$$\text{span}(\mathbf{v}_1, \ldots, \mathbf{v}_k) = \{c_1\mathbf{v}_1 + \cdots + c_k\mathbf{v}_k : c_i \in \mathbb{R}\}$$

The smallest subspace containing all $\mathbf{v}_i$.

## Inner Product Spaces

A vector space equipped with an **inner product** $\langle \cdot, \cdot \rangle : V \times V \to \mathbb{R}$ satisfying:
- Symmetry: $\langle \mathbf{u}, \mathbf{v} \rangle = \langle \mathbf{v}, \mathbf{u} \rangle$
- Linearity in first argument
- Positive definiteness: $\langle \mathbf{v}, \mathbf{v} \rangle \geq 0$, equals 0 only if $\mathbf{v} = \mathbf{0}$

**Standard inner product in $\mathbb{R}^n$:** $\langle \mathbf{u}, \mathbf{v} \rangle = \mathbf{u}^T \mathbf{v} = \sum_i u_i v_i$

**Induced norm:** $\|\mathbf{v}\| = \sqrt{\langle \mathbf{v}, \mathbf{v} \rangle}$

## Orthogonality

Vectors $\mathbf{u}$ and $\mathbf{v}$ are **orthogonal** if $\langle \mathbf{u}, \mathbf{v} \rangle = 0$.

An **orthonormal basis** has vectors that are:
- Pairwise orthogonal: $\langle \mathbf{e}_i, \mathbf{e}_j \rangle = 0$ for $i \neq j$
- Unit norm: $\|\mathbf{e}_i\| = 1$

**Gram-Schmidt process:** converts any basis into an orthonormal one.

**Projection** of $\mathbf{v}$ onto $\mathbf{u}$:
$$\text{proj}_{\mathbf{u}} \mathbf{v} = \frac{\langle \mathbf{v}, \mathbf{u} \rangle}{\langle \mathbf{u}, \mathbf{u} \rangle} \mathbf{u}$$

## Normed Spaces and Metric Spaces

**Normed space:** vector space with a norm $\|\cdot\|$

**Metric space:** set with a distance function $d(x, y)$ satisfying:
- Non-negativity, symmetry, triangle inequality, identity of indiscernibles

Every normed space is a metric space via $d(\mathbf{x}, \mathbf{y}) = \|\mathbf{x} - \mathbf{y}\|$.

## Banach and Hilbert Spaces

**Banach space:** complete normed vector space (all Cauchy sequences converge).

**Hilbert space:** complete inner product space. The infinite-dimensional generalization of Euclidean space.

- $L^2([a,b])$ — square-integrable functions — is a Hilbert space
- Used in: kernel methods (RKHS), quantum mechanics, signal processing

## Linear Maps (Linear Transformations)

A function $T: V \to W$ is **linear** if:
$$T(\alpha \mathbf{u} + \beta \mathbf{v}) = \alpha T(\mathbf{u}) + \beta T(\mathbf{v})$$

Every linear map between finite-dimensional spaces has a **matrix representation**.

**Kernel (null space):** $\ker(T) = \{\mathbf{v} : T(\mathbf{v}) = \mathbf{0}\}$

**Image (range):** $\text{im}(T) = \{T(\mathbf{v}) : \mathbf{v} \in V\}$

**Rank-nullity:** $\dim(\ker T) + \dim(\text{im } T) = \dim V$

## Change of Basis

Given basis $B = \{\mathbf{b}_1, \ldots, \mathbf{b}_n\}$, the **change of basis matrix** $P$ converts coordinates from $B$ to the standard basis.

If $A$ represents a linear map in the standard basis, the same map in basis $B$ is:
$$A_B = P^{-1} A P$$

This is why **eigendecomposition** is a change of basis to the eigenvector basis (where the transformation is diagonal).

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Column/null space | Understanding linear layers, rank of weight matrices |
| Orthonormal basis | QR decomposition, Gram-Schmidt in training |
| Inner product | Attention (dot product), cosine similarity |
| Projection | Least squares, PCA |
| Hilbert space / RKHS | Kernel methods, SVMs, Gaussian processes |
| Linear maps | Every neural network layer |
| Change of basis | Interpreting PCA, eigendecomposition |
