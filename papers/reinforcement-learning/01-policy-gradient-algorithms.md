# Policy Gradient Algorithms (2000)

**Authors:** Richard S. Sutton, David McAllester, Satinder Singh, Yishay Mansour
**Area:** Reinforcement Learning
**Link:** [NeurIPS](https://proceedings.neurips.cc/paper/1999/hash/464d828b85b0bed98e80ade0a5c43b0f-Abstract.html)

## What the paper argues

Value-based RL (Q-learning, value iteration) estimates a value function and derives a policy from it. This is indirect, unstable, and struggles with continuous action spaces. Policy gradient methods directly parameterize the policy π_θ and optimize expected cumulative reward by gradient ascent. The paper proves the **policy gradient theorem**: the exact gradient of expected return is computable from sampled trajectories without differentiating through environment dynamics.

## The policy gradient theorem

Let J(θ) = E[Σ_t r_t] be the expected return under policy π_θ. The theorem states:

```
∇_θ J(θ) = E_π [ ∇_θ log π_θ(a|s) · Q^π(s, a) ]
```

The gradient of the expected return equals the expected product of:
- ∇_θ log π_θ(a|s): how much the log probability of the taken action changes with θ
- Q^π(s, a): the return obtained after taking action a in state s

This expectation can be estimated by collecting trajectories and averaging. No knowledge of the environment dynamics is needed.

## REINFORCE

The simplest implementation replaces Q^π(s,a) with the actual return G_t from that timestep:

```
θ ← θ + α · Σ_t ∇_θ log π_θ(a_t | s_t) · G_t
```

This is unbiased but has high variance. Subtracting a baseline b(s) (e.g. the value function V(s)) from G_t reduces variance without introducing bias:

```
θ ← θ + α · Σ_t ∇_θ log π_θ(a_t | s_t) · (G_t - b(s_t))
```

## Results and impact

The policy gradient theorem provided the theoretical foundation for a large family of RL algorithms. REINFORCE, actor-critic methods, TRPO, PPO, and RLHF all build on this result. It is a standard theorem in any RL course.
