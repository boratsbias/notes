# Deep Q Networks

Deep Q-Networks (DQN) extend Q-learning to high-dimensional state spaces (e.g., raw pixels) by approximating the Q-function with a deep neural network. DQN was the first algorithm to learn control policies directly from raw pixel inputs across a wide range of Atari games.

## DQN Architecture

**Q-network:** $Q(s, a; \theta) \approx Q^*(s, a)$, parameterized by weights $\theta$.

**Input:** stack of 4 grayscale frames (84×84×4) to provide temporal information.

**Network:** 3 convolutional layers + 2 fully connected layers. Output: one Q-value per action.

**Key innovation:** instead of outputting a single $Q(s,a)$ for a given $(s,a)$ pair, output all $\lvert\mathcal{A}\rvert$ Q-values simultaneously. Single forward pass covers all actions.

## Instability of Naive Deep Q-Learning

Three sources of instability when naively combining Q-learning with neural networks:

1. **Correlated updates:** consecutive transitions $(s_t, a_t, r_t, s_{t+1})$ are highly correlated; networks trained on correlated sequences diverge.

2. **Non-stationary targets:** the target $r + \gamma \max_{a'} Q(s', a'; \theta)$ changes every step because $\theta$ changes. Chasing a moving target causes oscillations.

3. **Overestimation bias:** the $\max$ operator amplifies noise in Q-value estimates.

## Experience Replay

Store transitions $(s_t, a_t, r_t, s_{t+1}, \text{done})$ in a replay buffer $\mathcal{D}$ of fixed size $N$.

At each training step, sample a random mini-batch of size $B$ from $\mathcal{D}$:

$$\{(s_j, a_j, r_j, s_j')\}_{j=1}^B \sim \mathcal{D}$$

**Benefits:**
- Breaks temporal correlations: mini-batch samples are approximately i.i.d.
- Data efficiency: each transition is used multiple times.
- Off-policy: old data can be replayed even after the policy has changed.

**Buffer size:** typically $10^5$–$10^6$ transitions. Too small: recent bias; too large: stale data.

## Target Network

Maintain a separate **target network** $Q(s, a; \theta^-)$ with weights $\theta^-$ that are updated slowly.

**Loss:**

$$\mathcal{L}(\theta) = \mathbb{E}_{(s,a,r,s') \sim \mathcal{D}}\left[(r + \gamma \max_{a'} Q(s', a'; \theta^-) - Q(s, a; \theta))^2\right]$$

**Update schedule:** copy $\theta \to \theta^-$ every $C$ steps (e.g., $C = 10000$). Keeps the target approximately fixed during updates, reducing oscillations.

## DQN Training Loop

```
Initialize Q(·; θ), Q(·; θ−) = Q(·; θ), replay buffer D
for each step t:
    a_t ← ε-greedy policy from Q(s_t; θ)
    execute a_t, observe r_t, s_{t+1}
    store (s_t, a_t, r_t, s_{t+1}) in D
    sample mini-batch from D
    compute targets: y_j = r_j + γ max_{a'} Q(s_j', a'; θ−)
    update θ by gradient descent on (y_j − Q(s_j, a_j; θ))²
    every C steps: θ− ← θ
```

## DQN Improvements: Rainbow

**Double DQN:** decouple action selection (use $\theta$) and evaluation (use $\theta^-$):

$$y = r + \gamma Q(s', \arg\max_{a'} Q(s', a'; \theta); \theta^-)$$

Reduces overestimation bias.

**Dueling DQN:** decompose the Q-value into state value and advantage:

$$Q(s, a; \theta) = V(s; \theta_V) + \left(A(s, a; \theta_A) - \frac{1}{|\mathcal{A}|}\sum_{a'} A(s, a'; \theta_A)\right)$$

$V(s)$ captures the state value; $A(s,a)$ captures action-relative advantage. Better generalization when many actions are equally good.

**Prioritized Experience Replay (PER):** sample transitions with priority proportional to their TD error magnitude $\lvert\delta\rvert^\omega$. Transitions with large errors are revisited more; compensate with importance sampling weights.

**Multi-step returns:** use $n$-step Bellman targets instead of one-step. Reduces bootstrap bias.

**Distributional RL (C51):** instead of learning the expected return $\mathbb{E}[G]$, learn the full return distribution $P(G \mid s,a)$ parameterized as a categorical distribution over $N$ atoms. Minimizes KL divergence.

**Noisy Nets:** replace $\epsilon$-greedy with learned stochastic weights in the network. Exploration is state-dependent and learnable.

**Rainbow DQN:** combine all six improvements. Substantially outperforms individual components on Atari.

## Hyperparameters

| Parameter | Typical value |
|-----------|--------------|
| Replay buffer size | $10^6$ |
| Batch size | 32 |
| Target update frequency | 10000 steps |
| $\epsilon$ initial | 1.0 |
| $\epsilon$ final | 0.1 |
| $\epsilon$ annealing steps | $10^6$ |
| Learning rate | $2.5 \times 10^{-4}$ |
| $\gamma$ | 0.99 |

## Limitations of DQN

**Discrete actions only:** the $\arg\max_a$ over the output requires a finite action set. Does not extend to continuous actions.

**Solution:** for continuous actions, use policy gradient methods (SAC, TD3) or discretize the action space.

**Sample efficiency:** DQN requires $10^7$–$10^8$ environment steps on Atari to reach human-level performance. Model-based methods can be orders of magnitude more sample-efficient.
