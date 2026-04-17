# Policies and Value Functions

Policies define how an agent acts; value functions quantify how good it is to be in a state or to take an action. Together they are the central objects of RL theory and the building blocks of most algorithms.

## The Optimal Policy

The goal is to find a policy $\pi^*$ that maximizes the expected return from every state:

$$\pi^* = \arg\max_\pi V^\pi(s) \quad \forall s \in \mathcal{S}$$

**Theorem (existence):** for any finite MDP with discount $\gamma < 1$, there exists an optimal policy $\pi^*$ that is deterministic and stationary.

**Optimal value function:**

$$V^*(s) = \max_\pi V^\pi(s)$$

$$Q^*(s, a) = \max_\pi Q^\pi(s, a)$$

Given $Q^*$, the optimal policy is:

$$\pi^*(s) = \arg\max_a Q^*(s, a)$$

## State Value Function $V^\pi$

$$V^\pi(s) = \mathbb{E}_\pi\!\left[\sum_{k=0}^{\infty} \gamma^k r_{t+k} \;\Big|\; S_t = s\right]$$

$V^\pi(s)$ tells us how good it is to be in state $s$ when following policy $\pi$.

**Computing $V^\pi$ (policy evaluation):**

For a finite MDP, $V^\pi$ satisfies a linear system:

$$V^\pi(s) = \sum_a \pi(a|s) \sum_{s'} P(s'|s,a) [R(s,a) + \gamma V^\pi(s')]$$

This can be solved directly (matrix inversion) or iteratively (iterative policy evaluation).

## Action Value Function $Q^\pi$

$$Q^\pi(s,a) = \mathbb{E}_\pi\!\left[\sum_{k=0}^{\infty} \gamma^k r_{t+k} \;\Big|\; S_t = s, A_t = a\right]$$

$Q^\pi(s,a)$ is the expected return when taking action $a$ in state $s$, then following $\pi$ thereafter.

**Relationship to $V^\pi$:**

$$V^\pi(s) = \sum_a \pi(a|s) Q^\pi(s,a)$$

$$Q^\pi(s,a) = R(s,a) + \gamma \sum_{s'} P(s'|s,a) V^\pi(s')$$

## Advantage Function

The advantage function measures how much better action $a$ is compared to the average action under $\pi$:

$$A^\pi(s,a) = Q^\pi(s,a) - V^\pi(s)$$

$A^\pi(s,a) > 0$ means $a$ is better than average; $A^\pi(s,a) < 0$ means worse.

The advantage function is central to policy gradient methods because it reduces variance while keeping the policy update unbiased.

## Policy Improvement

**Policy improvement theorem:** given a policy $\pi$, define $\pi'$ as the greedy policy w.r.t. $Q^\pi$:

$$\pi'(s) = \arg\max_a Q^\pi(s,a)$$

Then $V^{\pi'}(s) \geq V^\pi(s)$ for all $s$. If equality holds everywhere, $\pi$ is already optimal.

**Policy iteration:** alternate between policy evaluation (compute $V^\pi$) and policy improvement (compute greedy $\pi'$). Converges to $\pi^*$ in finite steps.

## Generalized Policy Iteration (GPI)

The unifying principle behind most RL algorithms. Maintain two interacting processes:

1. **Policy evaluation:** make the value function consistent with the current policy.
2. **Policy improvement:** make the policy greedy with respect to the current value function.

These two processes work against each other in the short term but converge together to optimality.

```
V ←→ π
evaluation  improvement
```

GPI: the processes don't need to run to completion each time. Take one step of each, alternating (TD learning + greedy policy update).

## On-Policy vs. Off-Policy

**On-policy:** the policy being evaluated and improved is the same as the policy generating data.

**Off-policy:** the policy generating data (behavior policy $b$) is different from the policy being learned (target policy $\pi$).

Off-policy learning enables:
- Learning from demonstrations (expert behavior policy).
- Reusing old experience (experience replay).
- Learning multiple policies simultaneously.

**Importance sampling correction** for off-policy value estimation:

$$V^\pi(s) = \mathbb{E}_b\left[\frac{\pi(A_t|S_t)}{b(A_t|S_t)} G_t \;\Big|\; S_t = s\right]$$

The ratio $\rho_t = \pi(A_t \mid S_t)/b(A_t \mid S_t)$ is the importance weight.

## Eligibility Traces and $\text{TD}(\lambda)$

Eligibility traces blend multi-step returns:

**$\lambda$-return:**

$$G_t^\lambda = (1-\lambda)\sum_{n=1}^\infty \lambda^{n-1} G_t^{(n)}$$

where $G_t^{(n)} = r_t + \gamma r_{t+1} + \cdots + \gamma^{n-1} r_{t+n-1} + \gamma^n V(S_{t+n})$ is the $n$-step return.

- $\lambda = 0$: one-step TD (TD(0)).
- $\lambda = 1$: full Monte Carlo return.
- Intermediate $\lambda$: balances bias (low $\lambda$) and variance (high $\lambda$).

**Eligibility trace $e_t(s)$:** accumulates recent visit frequency of a state; used to propagate the TD error backward efficiently.

$$e_t(s) = \gamma \lambda e_{t-1}(s) + \mathbf{1}[S_t = s]$$

$$V(S_t) \leftarrow V(S_t) + \alpha \delta_t e_t(s)$$
