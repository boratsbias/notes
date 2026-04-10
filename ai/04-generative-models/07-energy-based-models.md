# Energy Based Models

Energy-based models (EBMs) define a probability distribution over data via an **energy function** $E_\theta(x) \in \mathbb{R}$ that assigns low energy to likely configurations and high energy to unlikely ones.

## The Energy-Based Distribution

$$p_\theta(x) = \frac{\exp(-E_\theta(x))}{Z(\theta)}, \quad Z(\theta) = \int \exp(-E_\theta(x)) \, dx$$

- $E_\theta(x)$: scalar energy function, often a neural network.
- $Z(\theta)$: partition function (normalizing constant). **This integral is generally intractable.**

Equivalently: $\log p_\theta(x) = -E_\theta(x) - \log Z(\theta)$.

## Why Energy-Based?

- **Flexibility:** no architectural constraints on $E_\theta$; any neural network works.
- **No generative process required:** no need to define a decoder or forward sampling procedure.
- **Unified framework:** many classical models (Boltzmann machines, CRFs, Hopfield networks) are EBMs.
- **Compositionality:** $E(x) = E_1(x) + E_2(x)$ corresponds to $p(x) \propto p_1(x) \cdot p_2(x)$.

**Challenge:** the intractable $Z(\theta)$ makes MLE and sampling hard.

## Maximum Likelihood Training

The MLE gradient involves the **difference of model expectations**:

$$\nabla_\theta \log p_\theta(x) = -\nabla_\theta E_\theta(x) + \mathbb{E}_{p_\theta(x')}[\nabla_\theta E_\theta(x')]$$

The first term pushes the energy of real data down. The second (the **negative phase**) pushes the energy of model samples up.

Computing the negative phase requires sampling from $p_\theta$, which requires MCMC.

## MCMC for EBMs

Since $p_\theta$ is only known up to $Z(\theta)$, sampling requires Markov Chain Monte Carlo.

### Langevin Dynamics

Iterative refinement of a noisy sample using the gradient of the energy:

$$x^{(k+1)} = x^{(k)} - \frac{\alpha}{2} \nabla_x E_\theta(x^{(k)}) + \sqrt{\alpha} \, \epsilon^{(k)}, \quad \epsilon^{(k)} \sim \mathcal{N}(0, I)$$

As step size $\alpha \to 0$ and steps $K \to \infty$, the chain converges to $p_\theta(x)$.

In practice: run for a finite number of steps starting from noise or a real sample.

### Contrastive Divergence (CD-k)

Initialize MCMC chain from real data $x \sim p_\text{data}$, run $k$ steps of Gibbs or Langevin, use the result as a "negative sample":

$$\nabla_\theta \mathcal{L} \approx -\nabla_\theta E_\theta(x^+) + \nabla_\theta E_\theta(x^-)$$

$k=1$ (CD-1) is often sufficient in practice and is the default for RBMs.

**Persistent Contrastive Divergence (PCD):** maintain a persistent chain across training steps rather than restarting from data. Better captures the full model distribution.

## Replay Buffer

Modern EBMs (Du & Mordatch 2019) maintain a **replay buffer** of past MCMC samples. For each gradient step:

1. Initialize some chains from buffer samples, some from noise.
2. Run $K$ steps of Langevin dynamics.
3. Update the buffer with new samples.
4. Compute the contrastive gradient.

Prevents MCMC from getting stuck and stabilizes training.

## Boltzmann Machines

An EBM on binary vectors $x \in \{0,1\}^d$:

$$E(x) = -x^T W x - b^T x$$

**Training:** maximize $\log p(x) = -E(x) - \log Z$. Gradient requires computing $\mathbb{E}_{p}[x x^T]$, intractable for general BMs.

**Restricted Boltzmann Machine (RBM):** bipartite graph with visible units $v$ and hidden units $h$; no within-layer connections.

$$E(v, h) = -v^T W h - b^T v - c^T h$$

$$p(v) = \sum_h p(v, h), \quad p(h|v) = \sigma(Wv + c), \quad p(v|h) = \sigma(W^T h + b)$$

Alternating Gibbs sampling between $v$ and $h$ is efficient. Trained with CD-1. Building block of Deep Belief Networks.

## Joint Energy Models (JEM)

Combines a classifier $f_\theta(x)[y]$ (logit for class $y$) with an EBM over inputs:

$$p_\theta(x) \propto \sum_y \exp(f_\theta(x)[y])$$

$$p_\theta(y|x) = \text{softmax}(f_\theta(x))$$

Joint MLE: maximize $\log p_\theta(x) + \log p_\theta(y|x)$.

A single network simultaneously classifies and generates. Improves OOD detection and adversarial robustness.

## EBMs for Structured Prediction

In NLP and vision, model $p(y|x) \propto \exp(-E_\theta(x, y))$ where $y$ is a structured output (parse tree, segmentation map).

- **CRF (Conditional Random Field):** shallow EBM with pairwise potentials. Exact inference via dynamic programming for linear chains.
- **Structured SVM:** margin-based training that avoids partition function via a surrogate loss.

## Composing Energy Functions

EBMs compose cleanly via addition:

$$\log p(x|c) \propto -E_\text{model}(x) - E_\text{condition}(x, c)$$

This enables **test-time composition** of multiple constraints without retraining. E.g., combine a generative model with a physics constraint or a classifier.

## Comparison with Other Generative Models

| Property | EBM | VAE | GAN | Diffusion |
|----------|-----|-----|-----|----------|
| Tractable likelihood | No (unnormalized) | No (ELBO) | No | No (ELBO) |
| Sampling | Slow (MCMC) | Fast | Fast | Slow (iterative) |
| Training stability | Difficult (MCMC needed) | Stable | Unstable | Stable |
| Compositionality | Excellent | Poor | Poor | Moderate |
| Flexibility | High | Moderate | High | High |
