# Adagrad: Adaptive Subgradient Methods for Online Learning and Stochastic Optimization (2011)

**Authors:** John Duchi, Elad Hazan, Yoram Singer
**Area:** Optimization, Online Learning
**Link:** [JMLR](https://jmlr.org/papers/v12/duchi11a.html)

## The problem with flat learning rates in sparse settings

In NLP, most parameters receive gradient updates very rarely. The embedding for a common word like "the" fires on almost every training step. The embedding for a rare technical term might update once per epoch. A global learning rate treats both identically: it is either too large for the frequent parameter, causing instability, or too small for the rare one, meaning it barely moves. Adagrad gives each parameter its own effective learning rate automatically, with no manual tuning required beyond the global rate α.

## The accumulated squared gradient

Adagrad maintains a running sum of squared gradients G_t for each parameter, starting from zero at the beginning of training. At each step, the squared gradient is added to the accumulator, and the effective learning rate is α divided by the square root of this sum:

```
G_t = G_{t-1} + g_t²
θ_t = θ_{t-1} − (α / √(G_t + ε)) · g_t
```

A parameter that has received large or frequent gradients builds up a large G_t and takes smaller steps. A parameter barely touched keeps a near-zero G_t and takes much larger steps when its gradient finally arrives. This scaling is computed per-parameter at every step with no hyperparameters beyond α.

## Why it works for NLP

Sparse input representations are the norm in text: bag-of-words models, one-hot encodings, and word embeddings all have most entries at zero on any given example. Adagrad's mechanism is exactly calibrated for this case, scaling rare feature updates up and frequent ones down. It demonstrated clear gains over fixed-rate SGD on large-scale NLP tasks and was the first optimizer to make per-parameter adaptation practical.

## The fatal flaw that motivated Adam

Because G_t only ever grows, the effective learning rate for every parameter decays monotonically toward zero. Given enough training steps, all learning stalls regardless of how much gradient signal remains. **RMSProp** addressed this by replacing the cumulative sum with an exponential moving average, preserving the adaptive behavior while preventing the rate from collapsing. **Adam** then combined this fix with momentum, completing the lineage from Adagrad to the modern default optimizer.
