# Trust Region Policy Optimization (2015)

**Authors:** John Schulman, Sergey Levine, Philipp Moritz, Michael Jordan, Pieter Abbeel
**Area:** Reinforcement Learning
**Link:** [arXiv](https://arxiv.org/abs/1502.05477)

## The catastrophic update problem

Vanilla policy gradient is brittle because the data collection and the optimization are coupled. If a gradient step is too large, the new policy is significantly different from the one that collected the training data. That bad policy then generates bad trajectories, which produce a misleading gradient estimate, which causes another bad update. There is no natural recovery mechanism: the system can collapse and fail to return to a good policy region. Reducing the learning rate helps but slows training dramatically, and the right step size varies across training and across environments. A principled approach to constraining update size is needed.

## The trust region formulation

TRPO constrains each update to a region where the new policy is not too different from the old one, then optimizes as aggressively as possible within that region. The surrogate objective and its constraint are the paper's core contribution:

$$
\text{maximize} \quad L(\theta) = \mathbb{E}\left[\frac{\pi_\theta(a|s)}{\pi_\text{old}(a|s)} \cdot A^\pi(s,a)\right]
$$

$$
\text{subject to} \quad \mathbb{E}_s\left[\text{KL}\left(\pi_\text{old}(\cdot|s) \,\|\, \pi_\theta(\cdot|s)\right)\right] \leq \delta
$$

The importance ratio π_θ / π_old corrects for the fact that the data was collected under the old policy, allowing the objective to be evaluated without additional rollouts. The KL constraint limits how far the new distribution can move from the old one in any single update. A typical value of δ is 0.01. This is small enough to keep the importance ratio well-conditioned and the surrogate objective a faithful proxy for the true objective.

## Solving the constrained problem

Directly inverting the Fisher information matrix is infeasible for neural network policies, where n can be in the millions and F is n × n. TRPO uses the conjugate gradient algorithm to compute the product F^{-1}g iteratively, requiring only matrix-vector products of the form Fv, which can be computed via two backpropagation passes. This runs in O(k · n) time where k is the number of CG iterations, typically 10. After finding the natural gradient direction, TRPO performs a line search along that direction to find the largest step that satisfies the KL constraint and produces an actual improvement in the surrogate objective.

## Monotonic improvement guarantee

TRPO provides one of the few formal guarantees in deep RL: if the KL constraint is satisfied, the true expected return J(θ_new) is at least J(θ_old) minus a term that depends on the approximation error in the surrogate. In practice this means training is monotonically improving on the surrogate, with only minor deviations from monotonicity in the true objective due to finite-sample estimation. Locomotion tasks where vanilla policy gradient diverges show stable, consistent improvement curves under TRPO.

## Results and impact

TRPO demonstrated stable monotonically improving training on MuJoCo locomotion tasks, including hopper, half-cheetah, and swimmer, environments where policy gradient without constraints regularly diverges. It established the trust region framework as the right lens for thinking about policy update stability. PPO later approximated the same guarantee using a much simpler clipped objective, making the ideas broadly accessible, but TRPO's theoretical contribution and the conjugate gradient machinery remain foundational references.
