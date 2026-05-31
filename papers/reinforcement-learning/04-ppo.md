# Proximal Policy Optimization Algorithms (2017)

**Authors:** John Schulman, Filip Wolski, Prafulla Dhariwal, Alec Radford, Oleg Klimov
**Area:** Reinforcement Learning
**Link:** [arXiv](https://arxiv.org/abs/1707.06347)

## TRPO's practical limitations

TRPO's constrained optimization works well theoretically but is difficult to use in practice. The conjugate gradient solve and the Fisher-vector products require second-order information that is incompatible with architectures using dropout, layer normalization, or parameter sharing between the policy and value function heads. Implementing the constraint satisfaction with a line search adds significant engineering complexity. The result is an algorithm that requires considerable infrastructure to run correctly and does not compose easily with standard deep learning tooling.

## The clipped surrogate objective

PPO replaces the constrained optimization with a clipped objective that implicitly enforces a similar trust region through the loss function itself. The clipped objective is the paper's core contribution:

\[
L^\text{CLIP}(\theta) = \mathbb{E}_t\!\left[\min\!\left(r_t(\theta)\cdot A_t,\; \text{clip}(r_t(\theta), 1-\varepsilon, 1+\varepsilon)\cdot A_t\right)\right]
\]

where r_t(θ) = π_θ(a_t|s_t) / π_old(a_t|s_t) is the importance ratio between the current and old policy. The clipping works asymmetrically based on the sign of the advantage. When A_t > 0, the action was better than expected and the policy wants to increase its probability. The min prevents r_t from growing beyond 1 + ε, stopping the policy from claiming excessive credit. When A_t < 0, the action was worse than expected and the policy wants to decrease its probability. The clip prevents r_t from falling below 1 - ε, stopping the policy from moving too far away from the action it took. Both cases limit the policy shift without requiring a KL computation or a constrained solver. A typical value of ε is 0.2.

## Multiple epochs per rollout and GAE

Because clipping limits how far the policy can move, PPO can safely run K epochs of mini-batch stochastic gradient descent on the same rollout data. This dramatically improves sample efficiency compared to single-step on-policy methods where each rollout is discarded after one gradient step. K is typically between 4 and 10. Advantage estimates are computed using Generalized Advantage Estimation (GAE), an exponentially weighted average of multi-step returns controlled by a λ parameter that balances bias and variance. An entropy bonus is added to the loss to prevent the policy from collapsing to a deterministic solution prematurely, particularly in environments where early commitment to a suboptimal action sequence is irreversible.

## Results and impact

PPO matched or exceeded TRPO on continuous control benchmarks including MuJoCo locomotion tasks and matched DQN on Atari while requiring only first-order gradient computation and standard mini-batch training. The simplicity of the implementation made it immediately usable in large-scale distributed training setups. OpenAI adopted PPO as its default RL algorithm. It was the optimization algorithm used in InstructGPT and subsequently ChatGPT, where the reward signal came from a trained reward model rather than an environment, making PPO the algorithmic engine of RLHF. It is arguably the most practically impactful RL algorithm of the current era.
