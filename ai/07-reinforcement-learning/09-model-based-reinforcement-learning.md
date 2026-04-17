# Model-Based Reinforcement Learning

Model-based RL (MBRL) algorithms learn or are given an explicit model of the environment's dynamics, then use that model for planning or generating synthetic experience. MBRL is substantially more sample-efficient than model-free methods at the cost of model learning complexity.

## Why Model-Based?

**Sample efficiency:** model-free algorithms require millions of environment interactions to learn good policies. MBRL can reuse model-generated rollouts; reduces real environment interactions by orders of magnitude.

**Planning:** with a model, we can look ahead and evaluate the consequences of actions without executing them.

**Tradeoff:** model errors can mislead the policy. Compounding errors in long rollouts can cause model-based methods to fail in complex environments.

## World Models

A world model consists of:

**Dynamics model:** $P_\psi(s_{t+1} \mid s_t, a_t)$ (or $s_{t+1} = f_\psi(s_t, a_t) + \epsilon$).

**Reward model:** $R_\psi(s_t, a_t)$.

**Termination model:** $P(\text{done} \mid s_t, a_t)$ (for episodic tasks).

**Uncertainty:** dynamics models should quantify prediction uncertainty, especially out-of-distribution.

## Dyna Architecture

Sutton (1990). Integrate model-based planning with model-free Q-learning.

**Real experience:** interact with the environment; update Q-function and model.

**Simulated experience:** sample state-action pairs; query the model for next state and reward; update Q-function.

```
for each real step:
    take action; observe (s, a, r, s')
    update model: P̂, R̂ ← update with (s, a, r, s')
    update Q: Q(s,a) ← TD update with real (s, a, r, s')
    for k planning steps:
        s̃, ã ← random previously seen state-action
        r̃, s̃' ← model(s̃, ã)
        update Q(s̃, ã) ← TD update with (s̃, ã, r̃, s̃')
```

Each real step amortizes the environment cost across $k$ planning steps. Highly sample-efficient in tabular settings.

## Model-Based Policy Optimization (MBPO)

Janner et al. (2019). Use an ensemble of neural network dynamics models; generate short rollouts from real states; add synthetic data to a model-free SAC replay buffer.

**Ensemble:** $N = 7$ probabilistic neural network models. Each predicts a Gaussian over next state and reward. Epistemic uncertainty estimated from disagreement between ensemble members.

**Short rollouts:** limit rollout length to $k = 1$–$5$ steps to prevent compounding errors.

**Policy:** train SAC on a mixture of real and model-generated data.

MBPO achieves comparable performance to SAC on locomotion tasks with $20$–$100\times$ fewer environment steps.

## Planning Algorithms

When the model is given (or learned accurately enough), classic planning methods apply.

### Model Predictive Control (MPC)

At each step:
1. Optimize a sequence of actions $a_0, \ldots, a_{H-1}$ to maximize predicted return over horizon $H$.
2. Execute only the first action $a_0$.
3. Re-plan at the next step.

Replanning corrects for model errors. Works well even with simple, approximate models.

**CEM (Cross-Entropy Method):** iteratively sample action sequences, keep the top-$k$, refit a Gaussian; repeat. Standard optimizer for MPC in RL.

**MPPI (Model Predictive Path Integral):** sample action perturbations; weight by exponentiated return; update action sequence as a weighted mean.

### Monte Carlo Tree Search (MCTS)

Build a tree of possible futures; use Monte Carlo rollouts to estimate leaf values; select actions via UCB.

**UCB1 for tree nodes:**

$$\text{UCT}(s, a) = Q(s,a) + c\sqrt{\frac{\ln N(s)}{N(s,a)}}$$

Balance exploitation (high $Q$) and exploration (rarely visited nodes).

Used in AlphaGo, AlphaZero, MuZero.

## AlphaZero and MuZero

**AlphaZero (Silver et al. 2018):** learns Go, Chess, and Shogi from scratch using self-play + MCTS with a learned policy and value network. No handcrafted features; pure self-play. Surpasses all prior game AI.

**MuZero (Schrittwieser et al. 2020):** extends AlphaZero without requiring knowledge of the game rules. Learns a latent-space model of the environment:

- **Representation:** $h_t = f(o_0, \ldots, o_t)$ (encode observations to latent state).
- **Dynamics:** $h_{t+1}, r_t = g(h_t, a_t)$ (transition in latent space).
- **Prediction:** $\pi_t, V_t = p(h_t)$ (predict policy and value from latent state).

Planning with MCTS entirely in latent space. Achieves superhuman performance on Atari and board games.

## Dreamer

Hafner et al. (2020, 2023). Learn a world model in latent space; optimize the policy using imagined rollouts (backpropagation through the world model).

**World model (RSSM):** Recurrent State Space Model. Combines a deterministic GRU with a stochastic latent variable.

**Actor-critic in imagination:** unroll the world model for $H$ steps; compute returns; backpropagate through the model to update the actor.

DreamerV3 achieves human-level performance on Atari with significantly fewer environment steps than model-free methods.
