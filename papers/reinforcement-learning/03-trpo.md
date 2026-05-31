# Trust Region Policy Optimization (2015)

**Authors:** John Schulman, Sergey Levine, Philipp Moritz, Michael Jordan, Pieter Abbeel
**Area:** Reinforcement Learning
**Link:** [arXiv](https://arxiv.org/abs/1502.05477)

## What the paper argues

Policy gradient updates can be catastrophically large: a step that changes the policy too much sends it into a bad region, which then collects bad data, making recovery very hard. TRPO argues that policy updates should be constrained to a **trust region**: only allow updates where the new policy is not too different from the old one, as measured by KL divergence. Within this constraint, optimize the surrogate objective as much as possible.

## Surrogate objective

TRPO optimizes an importance-weighted surrogate objective using data collected from the old policy π_old:

```
maximize:   L(θ) = E_s,a [ (π_θ(a|s) / π_old(a|s)) · A^π(s,a) ]

subject to: E_s [ KL(π_old(·|s) || π_θ(·|s)) ] ≤ δ
```

The ratio π_θ / π_old corrects for the fact that data was collected under the old policy. The KL constraint limits how far the new policy can be from the old one.

## Solving the constrained optimization

1. Compute the gradient of L(θ): standard policy gradient.
2. Use **conjugate gradient** to compute the natural gradient direction (F^{-1} g) approximately, without explicitly inverting the Fisher matrix.
3. Run a **line search** along this direction to find the largest step satisfying the KL constraint.

## Theoretical guarantee

TRPO provides a monotonic improvement bound: if the constraint is satisfied, the true policy performance J(θ_new) ≥ J(θ_old) up to approximation error. This makes it one of the few RL algorithms with a formal guarantee.

## Results and impact

Stable, monotonically improving training on locomotion tasks where vanilla policy gradient frequently diverges. Established the trust region framework. PPO later achieved similar stability with a much simpler implementation, making it the practical successor.
