# Markov Decision Processes

A Markov Decision Process (MDP) is the formal mathematical framework for sequential decision-making under uncertainty. It provides the foundation for virtually all of reinforcement learning theory.

## Formal Definition

An MDP is a tuple $(\mathcal{S}, \mathcal{A}, P, R, \gamma)$:

- $\mathcal{S}$: state space (finite, countably infinite, or continuous).
- $\mathcal{A}$: action space.
- $P: \mathcal{S} \times \mathcal{A} \times \mathcal{S} \to [0,1]$: transition probability function. $P(s'|s,a)$ is the probability of reaching $s'$ from $s$ via action $a$.
- $R: \mathcal{S} \times \mathcal{A} \to \mathbb{R}$: reward function. $R(s,a)$ is the expected immediate reward.
- $\gamma \in [0,1)$: discount factor.

**Markov property:** $P(s_{t+1}|s_t, a_t, s_{t-1}, a_{t-1}, \ldots) = P(s_{t+1}|s_t, a_t)$. The future is independent of the past given the present state.

## Finite vs. Infinite Horizon

**Finite horizon:** the episode terminates after exactly $T$ steps. Return is $G_t = \sum_{k=0}^{T-t-1} r_{t+k}$ (undiscounted or discounted).

**Infinite horizon with discount:** $G_t = \sum_{k=0}^{\infty} \gamma^k r_{t+k}$. Discounting ensures $G_t$ is bounded as long as rewards are bounded.

**Episodic MDP:** finite horizon with a terminal state. After reaching the terminal state, the environment resets. Atari games, board games.

**Continuing MDP:** no terminal state; the agent interacts indefinitely. Average reward criterion may be used instead of discounted sum.

## Policies

A **policy** $\pi$ specifies the agent's behavior.

**Stochastic policy:** $\pi(a|s) = P(A_t = a | S_t = s)$. The probability of taking action $a$ in state $s$.

**Deterministic policy:** $\pi: \mathcal{S} \to \mathcal{A}$.

**Stationary policy:** does not depend on time $t$. For infinite-horizon discounted MDPs, the optimal policy is always stationary.

**Markov policy:** depends only on the current state (not on history). Sufficient for MDPs.

## Return and Value Functions

**Return from step $t$:**

$$G_t = r_t + \gamma r_{t+1} + \gamma^2 r_{t+2} + \cdots = r_t + \gamma G_{t+1}$$

**State value function under policy $\pi$:**

$$V^\pi(s) = \mathbb{E}_\pi[G_t | S_t = s]$$

**Action value (Q) function under policy $\pi$:**

$$Q^\pi(s, a) = \mathbb{E}_\pi[G_t | S_t = s, A_t = a]$$

Relationship: $V^\pi(s) = \sum_a \pi(a|s) Q^\pi(s,a)$

## Partially Observable MDPs (POMDPs)

When the agent cannot directly observe the full state, the process is a POMDP:

$(\mathcal{S}, \mathcal{A}, \mathcal{O}, P, R, Z, \gamma)$

where $\mathcal{O}$ is the observation space and $Z(o|s',a)$ is the observation emission probability.

The agent maintains a **belief state** $b(s) = P(S_t = s | o_1, a_1, \ldots, o_t)$, updated by Bayes' rule after each observation.

Exact POMDP solution is PSPACE-hard. Practical approaches:

- Maintain a history of observations as a proxy for the belief state.
- Use a recurrent neural network to maintain an implicit belief state.
- Frame-stacking (Atari DQN): input the last 4 frames to provide temporal context.

## Reward Design

The reward function fully specifies the agent's objective. Poor design leads to reward hacking.

**Sparse rewards:** reward only at goal achievement. Hard to learn with; requires efficient exploration.

**Dense rewards:** shaped rewards at intermediate steps. Easier to learn; may misalign with the true objective.

**Reward shaping:** add a potential-based shaping term $F(s,a,s') = \gamma \Phi(s') - \Phi(s)$ without changing the optimal policy (potential-based shaping theorem).

**Inverse RL:** infer the reward function from expert demonstrations. Applicable when specifying rewards is difficult.

## Absorbing States and Termination

**Terminal (absorbing) state $s_\text{term}$:** $P(s_\text{term} | s_\text{term}, a) = 1$ for all $a$; $R(s_\text{term}, a) = 0$.

Once reached, the episode ends. Modeling termination as an absorbing state with zero reward preserves the standard MDP framework.

## Finite MDP Example: Grid World

A grid of cells. States: cell positions. Actions: up, down, left, right.

- Moving into a wall: stay in place.
- Terminal states: goal (reward +1), pit (reward -1).
- All other transitions: reward -0.01 (step cost to encourage efficiency).

This is fully specified as a finite MDP and can be solved exactly with dynamic programming.
