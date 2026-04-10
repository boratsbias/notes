# Reinforcement Learning Overview

## Core Idea

Reinforcement learning studies how an agent should act in an environment to maximize cumulative reward through trial and error.

## Interaction Loop

At each time step:

1. the agent observes a state $s_t$
2. it selects an action $a_t$
3. the environment returns reward $r_t$
4. the environment transitions to the next state $s_{t+1}$

The objective is to maximize expected return.

## Return

The discounted return from time $t$ is:

$$G_t = \sum_{k=0}^{\infty} \gamma^k r_{t+k+1}$$

where $0 \leq \gamma < 1$ is the discount factor.

## Markov Decision Process

An MDP is defined by:

- states $S$
- actions $A$
- transition probabilities $P(s'|s,a)$
- reward function $R(s,a)$
- discount factor $\gamma$

The Markov property means the next state depends only on the current state and action.

## Policy and Value Functions

### Policy

A policy tells the agent what action to take:

$$\pi(a|s) = P(A_t = a \mid S_t = s)$$

### State Value Function

Expected return from state $s$ under policy $\pi$:

$$V^\pi(s) = E_\pi[G_t \mid S_t = s]$$

### Action Value Function

Expected return after taking action $a$ in state $s$:

$$Q^\pi(s, a) = E_\pi[G_t \mid S_t = s, A_t = a]$$

## Bellman Equation

The Bellman expectation equation for the value function is:

$$V^\pi(s) = \sum_a \pi(a|s)\sum_{s',r} P(s', r|s, a)\left[r + \gamma V^\pi(s')\right]$$

This recursive structure is central to RL algorithms.

## Exploration vs Exploitation

The agent must balance:

- **exploration:** trying actions to gather information
- **exploitation:** choosing actions known to give high reward

Too little exploration can trap learning in poor policies.

## Major Algorithm Families

| Family | Main Idea |
|--------|-----------|
| Dynamic programming | Solve known MDPs exactly |
| Monte Carlo methods | Learn from complete episodes |
| Temporal-difference learning | Bootstrap from current estimates |
| Q-learning | Learn action values off-policy |
| Policy gradients | Optimize policy directly |
| Actor-critic | Learn policy and value together |

## Why RL Is Difficult

- rewards can be sparse or delayed
- data is non-i.i.d.
- actions affect future observations
- exploration is costly
- optimization can be unstable

## Applications

- robotics
- game playing
- recommendation and ranking
- resource allocation
- control systems
- alignment and preference optimization in generative AI
