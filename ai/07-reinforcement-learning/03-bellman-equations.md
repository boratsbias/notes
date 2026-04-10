# Bellman Equations

The Bellman equations are recursive consistency conditions for value functions. They are the central equations of RL theory: every major algorithm is either a direct solution to, or an approximation of, the Bellman equations.

## Bellman Expectation Equation

The value of a state equals the expected immediate reward plus the discounted value of the next state:

**For $V^\pi$:**

$$V^\pi(s) = \sum_a \pi(a|s) \sum_{s'} P(s'|s,a)\left[R(s,a) + \gamma V^\pi(s')\right]$$

**For $Q^\pi$:**

$$Q^\pi(s,a) = R(s,a) + \gamma \sum_{s'} P(s'|s,a) \sum_{a'} \pi(a'|s') Q^\pi(s',a')$$

In compact operator notation, defining the Bellman expectation operator $\mathcal{T}^\pi$:

$$(\mathcal{T}^\pi V)(s) = \sum_a \pi(a|s) \sum_{s'} P(s'|s,a)[R(s,a) + \gamma V(s')]$$

$V^\pi$ is the unique fixed point: $\mathcal{T}^\pi V^\pi = V^\pi$.

$\mathcal{T}^\pi$ is a contraction mapping with modulus $\gamma$ under the $\ell_\infty$ norm. Repeated application converges to $V^\pi$ from any initialization.

## Bellman Optimality Equation

The optimal value function satisfies a nonlinear equation: the agent takes the best action:

**For $V^*$:**

$$V^*(s) = \max_a \sum_{s'} P(s'|s,a)\left[R(s,a) + \gamma V^*(s')\right]$$

**For $Q^*$:**

$$Q^*(s,a) = R(s,a) + \gamma \sum_{s'} P(s'|s,a) \max_{a'} Q^*(s',a')$$

The Bellman optimality operator $\mathcal{T}^*$:

$$(\mathcal{T}^* V)(s) = \max_a \sum_{s'} P(s'|s,a)[R(s,a) + \gamma V(s')]$$

$V^*$ is the unique fixed point of $\mathcal{T}^*$. Contraction with modulus $\gamma$. Value iteration applies $\mathcal{T}^*$ repeatedly to converge to $V^*$.

## TD Error

The temporal difference (TD) error is the difference between the current value estimate and the Bellman target:

$$\delta_t = r_t + \gamma V(s_{t+1}) - V(s_t)$$

**Interpretation:** $r_t + \gamma V(s_{t+1})$ is a one-step estimate of $V(s_t)$ (the TD target). $\delta_t$ is the prediction error; a non-zero TD error means the value estimate is inconsistent with the Bellman equation.

**TD(0) update:**

$$V(s_t) \leftarrow V(s_t) + \alpha \delta_t$$

Drives $V$ toward the TD target. Converges to $V^\pi$ for tabular MDPs with appropriate step sizes.

**SARSA (on-policy Q-update):**

$$Q(s_t, a_t) \leftarrow Q(s_t, a_t) + \alpha [r_t + \gamma Q(s_{t+1}, a_{t+1}) - Q(s_t, a_t)]$$

**Q-learning (off-policy):**

$$Q(s_t, a_t) \leftarrow Q(s_t, a_t) + \alpha [r_t + \gamma \max_{a'} Q(s_{t+1}, a') - Q(s_t, a_t)]$$

## Multi-Step Bellman Targets

The one-step TD target can be extended to $n$ steps:

$$G_t^{(n)} = r_t + \gamma r_{t+1} + \cdots + \gamma^{n-1} r_{t+n-1} + \gamma^n V(s_{t+n})$$

**$n$-step TD update:**

$$V(s_t) \leftarrow V(s_t) + \alpha [G_t^{(n)} - V(s_t)]$$

- $n=1$: standard TD; low variance, biased.
- $n = T$ (end of episode): Monte Carlo; zero bias, high variance.
- Intermediate $n$: tradeoff.

Multi-step returns are used in A2C, PPO, and Rainbow DQN.

## Bellman Equations in Matrix Form

For a finite MDP with $|\mathcal{S}|$ states under a fixed policy $\pi$:

$$\mathbf{v}^\pi = \mathbf{r}^\pi + \gamma P^\pi \mathbf{v}^\pi$$

$$\mathbf{v}^\pi = (I - \gamma P^\pi)^{-1} \mathbf{r}^\pi$$

where $P^\pi_{ss'} = \sum_a \pi(a|s) P(s'|s,a)$ and $r^\pi_s = \sum_a \pi(a|s) R(s,a)$.

Direct solution is $O(|\mathcal{S}|^3)$; feasible only for small state spaces. Dynamic programming uses iterative methods instead.

## Contraction and Convergence

The Bellman operators $\mathcal{T}^\pi$ and $\mathcal{T}^*$ are $\gamma$-contractions under $\|\cdot\|_\infty$:

$$\|\mathcal{T}^\pi V - \mathcal{T}^\pi U\|_\infty \leq \gamma \|V - U\|_\infty$$

By Banach's fixed point theorem, repeated application converges to the unique fixed point at a geometric rate.

**Error propagation:** if $V$ is an $\epsilon$-approximate fixed point ($\|\mathcal{T}^\pi V - V\|_\infty \leq \epsilon$), then:

$$\|V - V^\pi\|_\infty \leq \frac{\epsilon}{1-\gamma}$$

This $\frac{1}{1-\gamma}$ factor explains why small discount factors make RL easier: errors amplify less.
