# Adagrad: Adaptive Subgradient Methods for Online Learning and Stochastic Optimization (2011)

**Authors:** John Duchi, Elad Hazan, Yoram Singer
**Area:** Optimization, Online Learning
**Link:** [JMLR](https://jmlr.org/papers/v12/duchi11a.html)

## What the paper argues

In NLP and other sparse-feature settings, most parameters receive gradient signal very rarely. A flat learning rate treats all parameters the same, wasting updates on common features and under-updating rare ones. Adagrad gives each parameter its own learning rate, inversely scaled by how much gradient it has accumulated so far.

## Per-parameter update rule

Adagrad accumulates the sum of squared gradients for each parameter from the start of training:

```
G_t = G_{t-1} + g_t²          ← running sum of squared gradients

θ_t = θ_{t-1} - (α / √(G_t + ε)) · g_t
```

Parameters with a large cumulative squared gradient (updated frequently or with large signal) get a smaller effective learning rate. Parameters that have barely been updated get a large one when they finally fire.

## Why it works for sparse data

A word embedding for "the" gets updated on almost every step. A rare technical term embedding gets updated almost never. With a flat rate both receive the same step size, which is wrong in both directions. Adagrad's adaptive denominator automatically sets appropriate scales for each.

## The vanishing rate problem

Because G_t only ever grows, the effective rate α / √G_t decays monotonically toward zero. For long training runs this causes learning to stall. RMSProp (using an exponential moving average instead of a cumulative sum) and Adam fix this while keeping the per-parameter adaptation.

## Results and impact

Adagrad improved NLP tasks significantly over fixed-rate SGD and was the first widely adopted adaptive optimizer. It directly motivated RMSProp, Adadelta, and Adam.
