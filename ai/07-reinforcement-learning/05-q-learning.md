# Q-Learning

Q-learning is a model-free, off-policy temporal difference algorithm that directly estimates the optimal action-value function $Q^*$ without requiring knowledge of the environment's transition model.

## The Q-Learning Update

$$Q(s_t, a_t) \leftarrow Q(s_t, a_t) + \alpha \underbrace{\left[r_t + \gamma \max_{a'} Q(s_{t+1}, a') - Q(s_t, a_t)\right]}_{\delta_t \text{ (TD error)}}$$

**Target:** $r_t + \gamma \max_{a'} Q(s_{t+1}, a')$. This is the Bellman optimality target: take the best action at the next step.

**Off-policy:** the $\max$ over $a'$ in the target uses the greedy policy, regardless of which action was actually taken. The behavior policy can be anything that ensures sufficient exploration (e.g., $\epsilon$-greedy).

**Update rule:** move $Q(s_t, a_t)$ toward the target by step size $\alpha$.

## Convergence Guarantees

**Theorem:** for a finite MDP, Q-learning converges to $Q^*$ with probability 1 if:
1. All state-action pairs are visited infinitely often.
2. Step sizes satisfy the Robbins-Monro conditions: $\sum_t \alpha_t = \infty$ and $\sum_t \alpha_t^2 < \infty$.

The conditions ensure sufficient exploration (1) and that the learning rate decays appropriately (2). In practice, a fixed small $\alpha$ works for most applications.

## SARSA: On-Policy TD Control

SARSA is the on-policy counterpart to Q-learning:

$$Q(s_t, a_t) \leftarrow Q(s_t, a_t) + \alpha \left[r_t + \gamma Q(s_{t+1}, a_{t+1}) - Q(s_t, a_t)\right]$$

The target uses the actual next action $a_{t+1}$ taken under the current policy, not the greedy action.

**SARSA** converges to $Q^{\pi_{\epsilon}}$ (the Q-function of the $\epsilon$-greedy policy), not $Q^{\ast}$. As $\epsilon \to 0$, $Q^{\pi_{\epsilon}} \to Q^{\ast}$.

**Cliff Walking:** a standard example where SARSA is safer than Q-learning. Q-learning learns the optimal path along the cliff (risky); SARSA learns a safer path away from the cliff because it accounts for exploratory actions.

## Expected SARSA

Replace the sampled next action with the expected value:

$$Q(s_t, a_t) \leftarrow Q(s_t, a_t) + \alpha \left[r_t + \gamma \sum_{a'} \pi(a'|s_{t+1}) Q(s_{t+1}, a') - Q(s_t, a_t)\right]$$

Lower variance than SARSA; more stable. Reduces to Q-learning when $\pi$ is greedy.

## $n$-Step Q-Learning

Extend the target to $n$ steps:

$$G_t^{(n)} = r_t + \gamma r_{t+1} + \cdots + \gamma^{n-1} r_{t+n-1} + \gamma^n \max_{a'} Q(s_{t+n}, a')$$

$$Q(s_t, a_t) \leftarrow Q(s_t, a_t) + \alpha[G_t^{(n)} - Q(s_t, a_t)]$$

Longer $n$: lower bias, higher variance; less sensitive to bootstrapping errors.

## Double Q-Learning

Standard Q-learning overestimates values because the $\max$ operator is applied to noisy estimates:

$$\mathbb{E}[\max_a Q(s', a)] \geq \max_a \mathbb{E}[Q(s', a)]$$

**Double Q-learning** decouples action selection from action evaluation using two Q-networks $Q_A$ and $Q_B$:

$$\text{target} = r + \gamma Q_B(s', \arg\max_{a'} Q_A(s', a'))$$

Select the action with $Q_A$; evaluate it with $Q_B$ (and vice versa). Reduces overestimation bias significantly.

## Tabular Q-Learning Algorithm

```
Initialize Q(s, a) = 0 for all s, a
for each episode:
    s ← initial state
    while s is not terminal:
        a ← ε-greedy(Q, s)
        take action a; observe r, s'
        Q(s, a) ← Q(s, a) + α[r + γ max_{a'} Q(s', a') - Q(s, a)]
        s ← s'
```

**Tabular Q-table:** $\lvert\mathcal{S}\rvert \times \lvert\mathcal{A}\rvert$ matrix. Feasible only for small state spaces.

## Limitations and the Need for Function Approximation

**State space explosion:** a typical Atari game has $256^{3 \times 84 \times 84}$ possible pixel states; tabular representation is impossible.

**Solution:** approximate $Q(s,a) \approx Q(s,a;\theta)$ with a neural network. This leads to Deep Q-Networks (DQN); see [Deep Q Networks](06-deep-q-networks).

**Deadly triad:** combining function approximation + bootstrapping + off-policy learning can cause divergence. DQN addresses this with experience replay and a target network.
