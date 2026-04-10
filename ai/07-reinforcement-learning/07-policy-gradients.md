# Policy Gradients

Policy gradient methods directly optimize the policy $\pi_\theta$ by gradient ascent on the expected return. Unlike value-based methods, they work naturally with continuous actions, stochastic policies, and can represent multi-modal policies.

## Policy Gradient Theorem

Parameterize the policy as $\pi_\theta(a|s)$. The objective is:

$$J(\theta) = \mathbb{E}_{\tau \sim \pi_\theta}\left[\sum_{t=0}^T r_t\right] = \mathbb{E}_{\tau \sim \pi_\theta}[G(\tau)]$$

**Policy gradient theorem (Sutton et al. 2000):**

$$\nabla_\theta J(\theta) = \mathbb{E}_{\tau \sim \pi_\theta}\left[\sum_{t=0}^T \nabla_\theta \log \pi_\theta(a_t|s_t) \cdot G_t\right]$$

The gradient is an expectation over trajectories; no model of $P$ or $R$ is required.

**Derivation sketch (log-derivative trick):**

$$\nabla_\theta J = \int \nabla_\theta p_\theta(\tau) G(\tau) d\tau = \int p_\theta(\tau) \frac{\nabla_\theta p_\theta(\tau)}{p_\theta(\tau)} G(\tau) d\tau = \mathbb{E}_\tau[\nabla_\theta \log p_\theta(\tau) \cdot G(\tau)]$$

Since $\log p_\theta(\tau) = \sum_t \log \pi_\theta(a_t|s_t) + \text{const}$ (transition probabilities cancel), only the policy log-probs remain.

## REINFORCE (Monte Carlo Policy Gradient)

Sample full episodes; use the trajectory return as the signal:

```
for each episode:
    sample τ = (s0, a0, r0, ..., sT) from π_θ
    for each step t:
        G_t ← Σ_{k≥t} γ^(k-t) r_k
        θ ← θ + α ∇_θ log π_θ(a_t|s_t) G_t
```

**Intuition:** increase the log-probability of actions that led to high returns; decrease for low returns.

**High variance:** $G_t$ is a sum of many random rewards; Monte Carlo returns have high variance. Makes REINFORCE slow to converge.

## Baseline: Variance Reduction

Adding a baseline $b(s_t)$ to the return does not bias the gradient but reduces variance:

$$\nabla_\theta J = \mathbb{E}\left[\sum_t \nabla_\theta \log \pi_\theta(a_t|s_t) (G_t - b(s_t))\right]$$

**Proof that baseline doesn't bias:** $\mathbb{E}[\nabla_\theta \log \pi_\theta(a|s) b(s)] = b(s) \mathbb{E}[\nabla_\theta \log \pi_\theta(a|s)] = 0$ (since $\sum_a \pi(a|s) = 1$, its gradient is 0).

**Optimal baseline:** $b^*(s) = V^\pi(s)$ (the state value function). Makes the gradient signal the advantage function $A(s,a) = Q(s,a) - V(s)$.

## Trust Region Policy Optimization (TRPO)

Schulman et al. (2015). Policy improvement by maximizing a surrogate objective subject to a KL divergence constraint:

$$\max_\theta \mathbb{E}\left[\frac{\pi_\theta(a|s)}{\pi_{\theta_\text{old}}(a|s)} A^{\pi_{\theta_\text{old}}}(s,a)\right]$$

$$\text{subject to} \quad \mathbb{E}\left[D_\text{KL}(\pi_{\theta_\text{old}}(\cdot|s) \| \pi_\theta(\cdot|s))\right] \leq \delta$$

The ratio $\rho_t(\theta) = \pi_\theta(a_t|s_t) / \pi_{\theta_\text{old}}(a_t|s_t)$ is the importance weight; allows off-policy data reuse.

TRPO uses a conjugate gradient method + line search. Complex and expensive but stable.

## Proximal Policy Optimization (PPO)

Schulman et al. (2017). Simplifies TRPO by replacing the hard constraint with a clipped surrogate objective:

$$\mathcal{L}^\text{CLIP}(\theta) = \mathbb{E}_t\left[\min\left(\rho_t(\theta) A_t, \;\text{clip}(\rho_t(\theta), 1-\epsilon, 1+\epsilon) A_t\right)\right]$$

**Clipping:** if $\rho_t$ moves too far from 1, the objective is clipped to discourage large policy updates. $\epsilon = 0.1$–$0.2$ typical.

**Combined loss:**

$$\mathcal{L} = \mathcal{L}^\text{CLIP} - c_1 \mathcal{L}^\text{VF} + c_2 \mathcal{H}[\pi_\theta]$$

Value function loss $\mathcal{L}^\text{VF}$: MSE of value predictions.
Entropy bonus $\mathcal{H}$: encourages exploration.

**PPO is the most widely used on-policy RL algorithm.** It is simple to implement, stable, and effective across a wide range of tasks including robotics, games, and RLHF for LLMs.

## Generalized Advantage Estimation (GAE)

Schulman et al. (2016). Compute the advantage as an exponentially weighted average of $n$-step advantages:

$$\hat{A}_t = \sum_{l=0}^{\infty} (\gamma \lambda)^l \delta_{t+l}$$

where $\delta_t = r_t + \gamma V(s_{t+1}) - V(s_t)$ is the TD error.

- $\lambda = 0$: TD advantage, low variance, high bias.
- $\lambda = 1$: Monte Carlo advantage, high variance, zero bias.
- $\lambda \approx 0.95$: standard choice, balances both.

GAE is used in PPO, TRPO, and most actor-critic implementations.

## Comparison: Value-Based vs. Policy Gradient

| Property | DQN (value-based) | PPO (policy gradient) |
|----------|------------------|----------------------|
| Action space | Discrete | Discrete or continuous |
| Policy type | Implicit (greedy) | Explicit (parameterized) |
| On/off-policy | Off-policy | On-policy |
| Variance | Low | Higher (with baseline: moderate) |
| Sample efficiency | Better | Lower |
| Stability | Moderate | High (PPO) |
| Stochastic policies | Indirect | Natural |
