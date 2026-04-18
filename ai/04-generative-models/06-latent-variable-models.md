# Latent Variable Models

Latent variable models (LVMs) explain observed data $x$ by positing unobserved (latent) variables $z$ that generate or cause $x$. The joint distribution factorizes as:

$$p_\theta(x, z) = p_\theta(x \mid z) \cdot p(z)$$

The marginal likelihood $p_\theta(x) = \int p_\theta(x \mid z) p(z) \, dz$ is the quantity of interest for generative modeling, but this integral is typically intractable.

## Why Latent Variables?

- **Compact representation:** $z$ captures the essential structure of $x$ in a lower-dimensional space.
- **Disentanglement:** different dimensions of $z$ may correspond to interpretable factors of variation.
- **Compositionality:** complex data distributions can be modeled as mixtures or hierarchies of simpler distributions.
- **Missing data / semi-supervised learning:** latent variables naturally handle unobserved quantities.

## Mixture Models

The simplest latent variable model. $z$ is a discrete categorical variable:

$$p(x) = \sum_{k=1}^K p(z=k) \cdot p(x \mid z=k) = \sum_{k=1}^K \pi_k \cdot p_k(x)$$

**Gaussian Mixture Model (GMM):**

$$p(x) = \sum_{k=1}^K \pi_k \, \mathcal{N}(x; \mu_k, \Sigma_k)$$

Parameters $\{\pi_k, \mu_k, \Sigma_k\}$ are estimated via the **EM algorithm** (see below).

## The EM Algorithm

**Expectation-Maximization** is a general method for MLE in latent variable models. It alternates between:

**E-step:** compute the expected complete-data log-likelihood under the posterior $p(z \mid x, \theta_\text{old})$:

$$Q(\theta \mid \theta_\text{old}) = \mathbb{E}_{z \sim p(z \mid x, \theta_\text{old})}[\log p_\theta(x, z)]$$

**M-step:** maximize $Q$ w.r.t. $\theta$:

$$\theta_\text{new} = \arg\max_\theta Q(\theta \mid \theta_\text{old})$$

**Convergence:** EM guarantees non-decreasing log-likelihood at each step. Converges to a local maximum.

**For GMMs:**
- E-step: compute responsibilities $r_{ik} = p(z_i = k \mid x_i, \theta) \propto \pi_k \mathcal{N}(x_i; \mu_k, \Sigma_k)$.
- M-step: update $\pi_k$, $\mu_k$, $\Sigma_k$ using weighted sample statistics.

## Factor Analysis

Continuous latent variables; linear Gaussian model:

$$z \sim \mathcal{N}(0, I), \quad x = Wz + \mu + \epsilon, \quad \epsilon \sim \mathcal{N}(0, \Psi)$$

where $W \in \mathbb{R}^{d \times k}$ ($k \ll d$) is the factor loading matrix and $\Psi$ is diagonal.

Marginal: $p(x) = \mathcal{N}(x; \mu, WW^T + \Psi)$.

**PCA as special case:** $\Psi = \sigma^2 I$ (isotropic noise), $\sigma^2 \to 0$ gives PCA directions.

## Probabilistic PCA

Explicit probabilistic model for PCA. Marginal and posterior have closed forms:

$$p(z \mid x) = \mathcal{N}(z; M^{-1}W^T(x-\mu), \sigma^2 M^{-1})$$

where $M = W^T W + \sigma^2 I$. The MAP estimate of $z$ corresponds to the PCA projection.

Provides principled handling of missing data and model selection via marginal likelihood.

## Variational Inference

When the posterior $p(z \mid x, \theta)$ is intractable (nonlinear decoder, deep networks), use a variational approximation $q_\phi(z \mid x) \approx p_\theta(z \mid x)$.

**Variational lower bound (ELBO):**

$$\log p_\theta(x) \geq \mathbb{E}_{q_\phi(z \mid x)}[\log p_\theta(x \mid z)] - D_\text{KL}(q_\phi(z \mid x) \| p(z))$$

This is the objective optimized by VAEs. See [Variational Autoencoders](02-variational-autoencoders).

## Hierarchical Latent Variable Models

Stack multiple layers of latent variables:

$$p_\theta(x) = \int p_\theta(x \mid z_1) p_\theta(z_1 \mid z_2) \cdots p(z_L) \, dz_{1:L}$$

**Motivation:** a single Gaussian posterior cannot capture complex, multi-modal posteriors. Hierarchy allows richer representations at different levels of abstraction.

**Inference network:** a hierarchical encoder $q_\phi(z_{1:L} \mid x)$ factorized as:

$$q_\phi(z_{1:L} \mid x) = q_\phi(z_1 \mid x) \prod_{l=2}^L q_\phi(z_l \mid z_{l-1}, x)$$

**NVAE / VDVAE:** state-of-the-art hierarchical VAEs with 30+ latent groups, achieving high-quality image generation.

## Discrete Latent Variables

Categorical or discrete latent variables are non-differentiable. Workarounds:

**REINFORCE / score function estimator:**

$$\nabla_\phi \mathbb{E}_{q_\phi}[f(z)] = \mathbb{E}_{q_\phi}[f(z) \nabla_\phi \log q_\phi(z)]$$

High variance; requires many samples or control variates.

**Straight-through estimator:** in the forward pass, use discrete $z$; in the backward pass, treat it as if continuous. Used in VQ-VAE.

**Gumbel-Softmax (concrete distribution):**

$$z_k = \frac{\exp((\log \pi_k + g_k) / \tau)}{\sum_j \exp((\log \pi_j + g_j) / \tau)}, \quad g_k \sim \text{Gumbel}(0,1)$$

Temperature $\tau \to 0$: approaches discrete one-hot; $\tau > 0$: soft, differentiable. Anneal $\tau$ during training.

## Topic Models

LVMs for discrete text data.

**Latent Dirichlet Allocation (LDA):** each document is a mixture of topics; each topic is a distribution over words.

$$p(\text{words}|\text{doc}) = \sum_{k=1}^K \theta_k \cdot \phi_k(\text{word})$$

where $\theta \sim \text{Dirichlet}(\alpha)$ (document-topic proportions) and $\phi_k \sim \text{Dirichlet}(\beta)$ (topic-word distributions). Inference via variational EM or collapsed Gibbs sampling.

## Disentangled Representations

A latent space is **disentangled** if individual dimensions of $z$ correspond to independent, interpretable factors of variation.

**$\beta$-VAE:** increases KL weight to $\beta > 1$, pushing the encoder toward more independent latent dimensions.

**TC-VAE:** explicitly penalizes the total correlation $D_\text{KL}(q(z) \| \prod_j q(z_j))$, which measures dependence between latent dimensions.

**Metrics:** Mutual Information Gap (MIG), DCI disentanglement score, SAP score.

Disentanglement is useful for controllable generation and fairness (sensitive attributes confined to specific $z_j$).
