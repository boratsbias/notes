# Dynamic Programming

Dynamic programming (DP) methods compute exact solutions to MDPs when the model ($P$ and $R$) is fully known. They are not practical for large problems but establish the theoretical foundation for all approximate RL methods.

## Policy Evaluation (Prediction)

Compute $V^\pi$ for a given policy $\pi$.

**Iterative policy evaluation:** repeatedly apply the Bellman expectation operator until convergence.

$$V_{k+1}(s) \leftarrow \sum_a \pi(a|s) \sum_{s'} P(s'|s,a)\left[R(s,a) + \gamma V_k(s')\right]$$

Initialize $V_0(s) = 0$ (or any value). Since $\mathcal{T}^\pi$ is a $\gamma$-contraction, $V_k \to V^\pi$ as $k \to \infty$.

**Convergence:** $\|V_k - V^\pi\|_\infty \leq \gamma^k \|V_0 - V^\pi\|_\infty$. Stop when $\|V_{k+1} - V_k\|_\infty < \theta$ for a small threshold.

**Synchronous vs. asynchronous updates:** synchronous updates all states simultaneously using $V_k$. Asynchronous updates states one at a time using the most recent values. Asynchronous DP converges faster in practice.

## Policy Improvement

Given $V^\pi$, improve the policy by acting greedily:

$$\pi'(s) = \arg\max_a \sum_{s'} P(s'|s,a)\left[R(s,a) + \gamma V^\pi(s')\right]$$

**Policy improvement theorem:** $V^{\pi'}(s) \geq V^\pi(s)$ for all $s$. Equality holds iff $\pi = \pi'$ is already optimal.

**Proof sketch:** at any state $s$:

$$V^{\pi'}(s) \geq Q^\pi(s, \pi'(s)) = \max_a Q^\pi(s,a) \geq Q^\pi(s, \pi(s)) = V^\pi(s)$$

## Policy Iteration

Alternate between policy evaluation and policy improvement until convergence.

```
Initialize π arbitrarily
repeat:
    V ← PolicyEvaluation(π)   # compute V^π
    π' ← Greedy(V)             # improve policy
    if π' == π: return π       # convergence
    π ← π'
```

**Convergence:** since there are finitely many deterministic policies ($|\mathcal{A}|^{|\mathcal{S}|}$) and each iteration strictly improves the policy (or terminates), policy iteration converges in finite steps.

**In practice:** policy evaluation can be stopped early (truncated policy iteration). Even one step of policy evaluation followed by improvement works (which leads to value iteration).

## Value Iteration

Combine policy evaluation and improvement into a single update. Apply the Bellman optimality operator directly:

$$V_{k+1}(s) \leftarrow \max_a \sum_{s'} P(s'|s,a)\left[R(s,a) + \gamma V_k(s')\right]$$

No explicit policy is maintained; the policy is implicit (greedy w.r.t. current $V$).

**Convergence:** $\|V_k - V^*\|_\infty \leq \gamma^k \|V_0 - V^*\|_\infty$.

**Termination:** stop when $\|V_{k+1} - V_k\|_\infty < \theta(1-\gamma) / \gamma$ to guarantee the final greedy policy is within $\theta$ of optimal.

**Value iteration is equivalent to one step of policy evaluation per policy improvement.** It is less efficient per iteration but each iteration is much cheaper.

## Complexity

| Algorithm | Per-iteration cost | Iterations to converge |
|-----------|------------------|----------------------|
| Policy evaluation | $O(\lvert\mathcal{S}\rvert^2 \lvert\mathcal{A}\rvert)$ | $O(\log(1/\epsilon))$ |
| Policy iteration | $O(\lvert\mathcal{S}\rvert^2 \lvert\mathcal{A}\rvert)$ per eval | $O(\lvert\mathcal{A}\rvert^{\lvert\mathcal{S}\rvert})$ worst case; often polynomial |
| Value iteration | $O(\lvert\mathcal{S}\rvert^2 \lvert\mathcal{A}\rvert)$ | $O(\log(1/\epsilon) / (1-\gamma))$ |

Policy iteration converges in far fewer iterations than value iteration but each iteration is more expensive. For large $|\mathcal{S}|$, both are infeasible (curse of dimensionality).

## Generalized Policy Iteration (GPI)

The general framework: any interleaving of partial policy evaluation and policy improvement converges to $V^*$ and $\pi^*$.

Policy iteration and value iteration are special cases. Most RL algorithms (Q-learning, actor-critic, etc.) implement GPI approximately with function approximation.

## Limitations of DP

**Curse of dimensionality:** the state space grows exponentially with the number of state variables. Tabular DP is infeasible for continuous or high-dimensional states.

**Model requirement:** requires knowledge of $P$ and $R$. Not available in most real-world settings.

**Solutions:** approximate DP (function approximation + DP), model-free RL (Q-learning, TD learning, policy gradients), model-based RL (learn the model then plan).

## Prioritized Sweeping

An asynchronous DP variant that updates states in priority order, where priority is proportional to the magnitude of the expected Bellman error:

$$|R(s,a) + \gamma V(s') - V(s)|$$

Updates states that are "most out of date" first. Much more efficient than synchronous sweeps in sparse environments.
