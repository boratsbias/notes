# Policy Gradient Algorithms (2000)

**Authors:** Richard S. Sutton, David McAllester, Satinder Singh, Yishay Mansour
**Area:** Reinforcement Learning
**Link:** [NeurIPS](https://proceedings.neurips.cc/paper/1999/hash/464d828b85b0bed98e80ade0a5c43b0f-Abstract.html)

## The limitation of value-based methods

Q-learning and related methods estimate a value function and then derive a policy from it indirectly, typically by taking the argmax over Q(s, a). This is workable in discrete action spaces, but the approach breaks down in continuous settings where computing argmax over Q is intractable. Even in discrete settings, the policy extraction step is a separate operation and introduces instability: small changes in Q values can cause large, discontinuous swings in the derived policy. The coupling between the function approximator errors and the policy makes convergence difficult to guarantee. The fundamental issue is that value-based methods optimize the wrong object. They optimize the value function and hope the policy follows.

## The policy gradient theorem

Policy gradient methods bypass the value function entirely as a policy source by directly parameterizing the policy as $\pi_\theta(a \mid s)$ and optimizing the expected return $J(\theta)$ with respect to $\theta$. The paper's core contribution is a clean formula for the gradient of $J$:

$$\nabla_\theta J(\theta) = \mathbb{E}_\pi\!\left[\nabla_\theta \log \pi_\theta(a \mid s) \cdot Q^\pi(s,a)\right]$$

Here $J(\theta)$ is the expected cumulative return, $\nabla_\theta \log \pi_\theta(a \mid s)$ is the score function measuring how a change in parameters shifts the log probability of the action taken, and $Q^\pi(s, a)$ is the expected return starting from state $s$ and taking action $a$ under the current policy. The expectation is taken over trajectories sampled from $\pi_\theta$, so no differentiation through environment dynamics is needed. The formula is tractable because it reduces to an average over rollouts.

## REINFORCE and variance reduction

The simplest implementation, REINFORCE, replaces $Q^\pi(s, a)$ with the actual sampled return $G_t$ collected from the trajectory. The update rule is $\theta \mathrel{+}= \alpha \cdot \nabla_\theta \log \pi_\theta(a_t \mid s_t) \cdot G_t$. This is unbiased but has extremely high variance because $G_t$ accumulates stochastic rewards over many steps. Subtracting a baseline $b(s)$ from $G_t$ controls variance without introducing bias, since any function of state alone has zero expectation in the gradient expression. The state value function $V(s)$ is the natural baseline because it represents the average return from that state, and the difference $G_t - V(s)$ is the advantage: how much better the taken action was than average.

## Actor-critic interpretation

This baseline choice gives rise to the actor-critic architecture. The actor is the policy $\pi_\theta$, updated using the policy gradient. The critic is a separate function approximator for $V(s)$, used to estimate the advantage $A(s, a) = Q^\pi(s, a) - V(s)$. The actor improves by following the direction that increases returns above what the critic predicts. The critic improves by minimizing prediction error against observed returns. The two components train in a loop, with the critic providing lower-variance gradient estimates to the actor.

## Results and impact

The policy gradient theorem gave the field a rigorous theoretical grounding for directly optimizing parameterized policies. It showed that the gradient of expected return can be expressed as an expectation over on-policy rollouts, making it estimable from sampled experience. This result is the theoretical foundation on which REINFORCE, actor-critic methods, TRPO, PPO, and RLHF all rest. Nearly every modern policy optimization algorithm can be understood as a refinement of the update rule derived in this paper.
