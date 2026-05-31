# Proximal Policy Optimization Algorithms (2017)

**Authors:** John Schulman, Filip Wolski, Prafulla Dhariwal, Alec Radford, Oleg Klimov
**Area:** Reinforcement Learning
**Link:** [arXiv](https://arxiv.org/abs/1707.06347)

## What the paper argues

TRPO achieves stable updates through a constrained optimization that requires conjugate gradient and is incompatible with architectures using shared parameters or dropout. PPO achieves similar stability with a first-order method: a **clipped surrogate objective** that simply penalizes the policy ratio moving too far from 1, without a hard constraint or second-order computation.

## Clipped objective

Let r_t(θ) = π_θ(a|s) / π_old(a|s) be the probability ratio. The PPO objective clips this ratio:

```
L_CLIP(θ) = E_t [ min(
    r_t(θ) · A_t,
    clip(r_t(θ), 1-ε, 1+ε) · A_t
) ]
```

Typical ε = 0.2. Taking the minimum of clipped and unclipped ensures that:
- When A_t > 0 (good action): ratio cannot grow beyond 1+ε to claim more credit
- When A_t < 0 (bad action): ratio cannot shrink below 1-ε to avoid more blame

This discourages large policy changes without requiring a hard KL constraint.

## Multiple epochs per rollout

Because the clipped objective limits policy drift, PPO can perform multiple SGD epochs on the same batch of collected data. This improves sample efficiency compared to on-policy methods that discard data after one gradient step:

```
collect rollout  →  run K epochs of mini-batch SGD on clipped objective  →  repeat
```

## Results and impact

Matched TRPO on continuous control and Atari while being much simpler to implement. OpenAI adopted PPO as their default RL algorithm. It is the algorithm used in RLHF to train InstructGPT and ChatGPT, making it arguably the most impactful RL algorithm of the current era.
