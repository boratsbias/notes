# Multi-Agent Reinforcement Learning

Multi-agent reinforcement learning (MARL) studies settings where multiple agents interact in a shared environment, each learning its own policy. The agents may cooperate, compete, or both.

## Problem Setup

$N$ agents interact in a shared environment. At each step $t$:

1. Each agent $i$ observes $o_t^i$ (may be partial or full state).
2. Each agent selects action $a_t^i \sim \pi^i(\cdot \mid o_t^i)$.
3. The environment transitions to $s_{t+1} \sim P(s_{t+1} \mid s_t, \mathbf{a}_t)$.
4. Each agent receives reward $r_t^i = R^i(s_t, \mathbf{a}_t)$.

The joint action $\mathbf{a}_t = (a_t^1, \ldots, a_t^N)$ affects the transition and rewards of all agents.

## Interaction Types

**Cooperative:** all agents share the same reward ($r^i = r^j$ for all $i,j$). Goal: maximize joint return. Examples: multi-robot coordination, multi-agent navigation, team sports.

**Competitive (zero-sum):** one agent's gain is another's loss ($\sum_i r^i = 0$). Examples: chess, poker, StarCraft.

**Mixed (general-sum):** agents have partially aligned interests. Examples: autonomous driving, economics, social dilemmas.

## Non-Stationarity

The primary challenge in MARL: from agent $i$'s perspective, the environment is non-stationary because other agents' policies change during training. Standard single-agent convergence guarantees break down.

Even in a two-player game, if both agents update simultaneously via gradient descent, the joint update may oscillate or diverge.

## Centralized Training with Decentralized Execution (CTDE)

The dominant paradigm for cooperative MARL. During training, agents share information (global state, other agents' observations and actions). At execution, each agent acts using only its local observation.

**Motivation:** sharing information during training is fine (offline process); at execution, communication bandwidth or latency may be limited.

### QMIX

Rashid et al. (2018). Value decomposition for cooperative MARL with per-agent Q-functions.

**Individual Q-functions:** each agent $i$ has $Q_i(o^i, a^i; \theta_i)$.

**Monotonicity constraint:** the joint action should be the argmax of a mixed Q-function $Q_\text{tot}$. QMIX enforces:

$$\frac{\partial Q_\text{tot}}{\partial Q_i} \geq 0 \quad \forall i$$

via a hypernetwork-parameterized mixing network with non-negative weights.

**Result:** decentralized greedy execution is optimal w.r.t. $Q_\text{tot}$.

### MAPPO

Multi-agent PPO. Each agent runs PPO with a centralized critic (observes global state) and a decentralized actor. Simple extension of PPO; strong cooperative baseline.

## Independent Learners

Each agent runs a single-agent algorithm independently, treating other agents as part of the environment.

**Independent Q-Learning (IQL):** each agent runs DQN independently. Simple; works in practice for small numbers of agents with slowly changing policies.

**Issues:** non-stationarity from other learning agents; no theoretical guarantees.

## Competitive MARL and Game Theory

**Nash equilibrium:** a joint policy $(\pi^{*1}, \ldots, \pi^{*N})$ where no agent can improve by unilaterally changing its policy.

$$V^i(\pi^{*i}, \pi^{*-i}) \geq V^i(\pi^i, \pi^{*-i}) \quad \forall i, \forall \pi^i$$

Every finite game has at least one Nash equilibrium (Nash 1950).

**Self-play:** train agents by playing against their past selves or current copies. Prevents exploitation of non-stationarity; converges to Nash in two-player zero-sum games.

**Fictitious play:** agents best-respond to the empirical average of opponents' past actions. Converges to Nash in two-player zero-sum games.

### AlphaStar

DeepMind (2019). Superhuman StarCraft II. Uses:
- League training: main agents + exploiters + main exploiters evolve together.
- Each agent uses UPGO (upward-looking policy gradient) + V-trace for off-policy correction.
- Pointer network for unit selection; Transformer for global context.

## Communication in MARL

Agents can share information via communication channels.

**CommNet (Sukhbaatar et al. 2016):** broadcast mean of all agents' hidden states; each agent conditions on the aggregate message.

**DIAL (Differentiable Inter-Agent Learning):** pass gradients through communication; discrete communication emerges.

**QMIX / MAPPO with communication:** agents share observations or messages during centralized training.

## Multi-Agent Challenges

| Challenge | Description |
|-----------|-------------|
| Non-stationarity | Other agents' policies change during training |
| Credit assignment | Who contributed to the joint reward? |
| Scalability | Exponential joint action space with many agents |
| Emergent behavior | Complex strategies not explicitly programmed |
| Coordination | Agents must align without explicit communication |

## Emergent Communication

When communication protocols are not pre-specified, agents can develop emergent communication systems (grounded language-like protocols). Studied in referential games (speaker describes an object; listener must identify it). Emergent protocols are efficient but often not human-interpretable.

## Applications

| Domain | Type | Algorithm |
|--------|------|---------|
| StarCraft II | Competitive/cooperative | AlphaStar |
| Multi-robot tasks | Cooperative | QMIX, MAPPO |
| Traffic signal control | Cooperative | MAPPO |
| OpenAI Five (Dota 2) | Cooperative team vs. team | PPO + self-play |
| Poker | Competitive | Counterfactual Regret Minimization |
