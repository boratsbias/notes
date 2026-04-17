# Actor-Critic Methods

Actor-critic methods combine the strengths of policy gradient methods (actor) and value-based methods (critic). The critic estimates value functions to reduce variance; the actor updates the policy using the critic's feedback.

## Architecture

**Actor:** the policy $\pi_\theta(a \mid s)$. Takes actions and is updated to maximize expected return.

**Critic:** a value function $V_\phi(s)$ or $Q_\phi(s,a)$. Evaluates the actor's actions and is updated by TD learning.

The actor uses the critic's estimate as a baseline, producing the advantage:

$$A_t = r_t + \gamma V_\phi(s_{t+1}) - V_\phi(s_t) \quad (\text{one-step TD advantage})$$

**Actor update:**

$$\theta \leftarrow \theta + \alpha_\theta \nabla_\theta \log \pi_\theta(a_t|s_t) A_t$$

**Critic update:**

$$\phi \leftarrow \phi - \alpha_\phi \nabla_\phi (r_t + \gamma V_\phi(s_{t+1}) - V_\phi(s_t))^2$$

## A2C / A3C

**A3C (Asynchronous Advantage Actor-Critic, Mnih et al. 2016):** run multiple agents in parallel environments asynchronously; each agent computes gradients and applies them to a shared network. Breaks correlations without a replay buffer.

**A2C:** synchronous version of A3C. Wait for all parallel workers to complete a rollout; update once. More reproducible; often comparable performance.

**$n$-step returns:** use $n$-step TD targets for both actor and critic. GAE (see [Policy Gradients](07-policy-gradients)) replaces fixed $n$-step returns in most implementations.

## Soft Actor-Critic (SAC)

Haarnoja et al. (2018). The dominant off-policy actor-critic algorithm for continuous control.

**Maximum entropy RL:** augment the objective with an entropy bonus to encourage exploration and robustness:

$$J(\pi) = \mathbb{E}\left[\sum_t r_t + \alpha \mathcal{H}(\pi(\cdot|s_t))\right]$$

The optimal policy is a **Boltzmann policy** that allocates probability mass to all near-optimal actions, not just the single best.

**Soft Bellman equations:**

$$Q^*(s,a) = r + \gamma \mathbb{E}_{s'}[V^*(s')]$$

$$V^*(s) = \mathbb{E}_{a \sim \pi^*}[Q^*(s,a) - \alpha \log \pi^*(a|s)]$$

**SAC components:**
- **Stochastic actor** $\pi_\theta$: parameterized as a Gaussian; actions sampled via reparameterization trick.
- **Two Q-networks** $Q_{\phi_1}$, $Q_{\phi_2}$: minimize overestimation by using $\min(Q_1, Q_2)$ for targets.
- **Soft value network** (or compute implicitly).
- **Target networks** $\bar{\phi}_1$, $\bar{\phi}_2$: exponential moving average of Q-network weights.
- **Automatic entropy tuning:** adjust $\alpha$ so that the policy entropy matches a target entropy $\mathcal{H}_\text{target}$.

**Actor loss:** maximize $\mathbb{E}_{a \sim \pi_\theta}[\min(Q_1, Q_2)(s,a) - \alpha \log \pi_\theta(a \mid s)]$.

**Q-network loss:** MSE to Bellman target using min-double-Q and target networks.

SAC is sample-efficient, stable, and works well for manipulation, locomotion, and continuous control.

## Twin Delayed Deep Deterministic Policy Gradient (TD3)

Fujimoto et al. (2018). Extends DDPG (deterministic off-policy actor-critic) with three key fixes:

**DDPG base:** deterministic actor $\mu_\theta(s)$; Q-critic; experience replay; target networks. Policy gradient:

$$\nabla_\theta J = \mathbb{E}_s[\nabla_a Q_\phi(s,a)|_{a=\mu_\theta(s)} \cdot \nabla_\theta \mu_\theta(s)]$$

**TD3 improvements:**

1. **Clipped double Q-learning:** two Q-networks; target uses $\min(Q_1, Q_2)$ to reduce overestimation.

2. **Delayed policy updates:** update the actor every $d$ steps (typically $d=2$) but update critics every step. The policy update is more reliable when the critic is more accurate.

3. **Target policy smoothing:** add small clipped noise to target actions to smooth the Q-landscape:

$$a' = \mu_{\theta^-}(s') + \text{clip}(\mathcal{N}(0,\sigma), -c, c)$$

TD3 and SAC are the two standard benchmarks for continuous control. SAC is generally preferred for its entropy regularization and more stable training.

## Proximal Policy Optimization (PPO) as Actor-Critic

PPO (covered in [Policy Gradients](07-policy-gradients)) shares the actor-critic structure. The critic estimates $V_\phi(s)$ for GAE. The actor is updated with the clipped surrogate objective.

PPO is the standard on-policy algorithm; SAC/TD3 are the standard off-policy algorithms.

## Comparison

| Algorithm | On/Off-policy | Action space | Key feature |
|-----------|--------------|-------------|------------|
| A2C | On-policy | Discrete/Continuous | Synchronous parallel |
| PPO | On-policy | Discrete/Continuous | Clipped surrogate |
| DDPG | Off-policy | Continuous | Deterministic policy |
| TD3 | Off-policy | Continuous | Double Q + delay |
| SAC | Off-policy | Continuous | Max entropy, sample-efficient |
