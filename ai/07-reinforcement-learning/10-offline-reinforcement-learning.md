# Offline Reinforcement Learning

Offline RL (also called batch RL) learns a policy entirely from a fixed dataset of pre-collected transitions, without any interaction with the environment during training. This is critical for domains where online exploration is unsafe, expensive, or infeasible (healthcare, robotics, autonomous driving).

## The Offline RL Problem

Given a static dataset $\mathcal{D} = \{(s, a, r, s')\}$ collected by a (possibly suboptimal) behavior policy $\mu$, learn the best possible policy $\pi^*$ without any further environment interaction.

**Key challenge: distributional shift.** The learned policy $\pi$ will visit state-action pairs not well covered by $\mathcal{D}$. Q-values at these out-of-distribution (OOD) points are unreliable; the agent may exploit them, leading to catastrophic failure.

## Why Standard Off-Policy RL Fails Offline

Standard Q-learning (or SAC) applied to a fixed dataset diverges because:

1. Q-function overestimates values of OOD actions (extrapolation error).
2. The policy optimizes over the Q-function, selecting OOD actions.
3. Q-values for OOD actions are used as targets, amplifying errors further.

This feedback loop causes Q-values to grow without bound (bootstrapping over extrapolation errors).

## Conservative Q-Learning (CQL)

Kumar et al. (2020). Regularize the Q-function to be conservative on OOD actions.

**Objective:** maximize Q-values on dataset actions; minimize Q-values on OOD actions:

$$\min_Q \alpha \left(\mathbb{E}_{s \sim \mathcal{D}, a \sim \hat{\pi}_\beta(a|s)}[Q(s,a)] - \mathbb{E}_{s \sim \mathcal{D}, a \sim \hat{\mu}(a|s)}[Q(s,a)]\right) + \frac{1}{2}\mathbb{E}_{(s,a,s') \sim \mathcal{D}}[(Q(s,a) - \mathcal{T}^\pi Q(s,a))^2]$$

The first term pushes Q-values on in-distribution actions up and OOD actions down. The second term is the standard Bellman error.

**Result:** the Q-function lower-bounds the true Q-function under the behavior policy. The policy cannot exploit overestimated OOD values.

## Implicit Q-Learning (IQL)

Kostrikov et al. (2021). Avoids evaluating Q at OOD actions entirely.

**Key idea:** use expectile regression for the value function update:

$$\mathcal{L}_V(\phi) = \mathbb{E}_{(s,a) \sim \mathcal{D}}\left[L_2^\tau(Q_{\bar\psi}(s,a) - V_\phi(s))\right]$$

where $L_2^\tau(u) = |\tau - \mathbf{1}[u < 0]| u^2$. With $\tau > 0.5$, this upweights positive errors, effectively estimating a high quantile of $Q$ without querying actions outside $\mathcal{D}$.

**Policy extraction:** advantage-weighted regression (AWR):

$$\mathcal{L}_\pi(\theta) = -\mathbb{E}_{(s,a) \sim \mathcal{D}}\left[\exp\!\left(\beta (Q_\psi(s,a) - V_\phi(s))\right) \log \pi_\theta(a|s)\right]$$

IQL is simple, stable, and strong. Standard baseline for offline RL.

## Behavior Cloning (BC) and Imitation Learning

**Behavior cloning:** supervised learning on dataset actions:

$$\mathcal{L}_\text{BC}(\theta) = -\mathbb{E}_{(s,a) \sim \mathcal{D}}[\log \pi_\theta(a|s)]$$

No credit assignment; no reward optimization. Recovers the behavior policy. Strong for high-quality datasets; fails for suboptimal data.

**Filtered BC:** only clone actions where $Q(s,a) > V(s)$ (advantage-positive actions). Better than full BC on mixed-quality datasets.

**TD3+BC (Fujimoto & Gu, 2021):** add a BC regularization term to TD3:

$$\pi = \arg\max_\pi \mathbb{E}_{(s,a) \sim \mathcal{D}}\left[\lambda Q(s, \pi(s)) - (\pi(s) - a)^2\right]$$

Simple and competitive with more complex methods.

## Offline-to-Online RL

After offline pretraining, fine-tune online with a small number of environment interactions. A common pattern:

1. Pretrain policy with offline RL (CQL, IQL, BC).
2. Initialize online RL (SAC, PPO) from pretrained weights.
3. Mix offline data with online experience for stable updates.

## Offline RL Benchmarks

**D4RL (Fu et al. 2020):** standard benchmark. Datasets for locomotion (HalfCheetah, Hopper, Walker), manipulation (Adroit, Kitchen). Dataset types:

| Dataset quality | Description |
|----------------|-------------|
| `random` | Random policy; poor coverage |
| `medium` | Suboptimal trained policy |
| `medium-replay` | Data from training run buffer |
| `expert` | Near-optimal policy |
| `medium-expert` | Mix of medium and expert |

Performance measured as normalized score: 0 = random, 100 = expert.

## Dataset Quality and Coverage

The quality and coverage of the offline dataset fundamentally limits what can be learned:

**Insufficient coverage:** if the dataset never visits state-action pairs needed for a better policy, no offline algorithm can recover the optimal policy (information-theoretic lower bound).

**Mixed-quality data:** algorithms that correctly identify and upweight high-return trajectories can improve beyond the behavior policy. IQL, CQL, and TD3+BC do this through advantage weighting or Q-regularization.
