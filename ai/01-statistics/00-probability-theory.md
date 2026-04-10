# Probability Theory

## Core Idea

Probability theory provides the mathematical foundation for quantifying uncertainty. In ML, it underpins everything from model predictions to hypothesis testing and Bayesian inference.

## Basic Definitions

**Sample space** $\Omega$: the set of all possible outcomes.

**Event** $A \subseteq \Omega$: a subset of outcomes.

**Probability measure** $P$: a function assigning probabilities to events, satisfying:
- $P(A) \geq 0$ for all events $A$
- $P(\Omega) = 1$
- Countable additivity: $P(\cup_i A_i) = \sum_i P(A_i)$ for disjoint $A_i$

## Conditional Probability

The probability of $A$ given that $B$ has occurred:

$$P(A|B) = \frac{P(A \cap B)}{P(B)}, \quad P(B) > 0$$

**Chain rule:**

$$P(A \cap B) = P(A|B) P(B) = P(B|A) P(A)$$

## Independence

Events $A$ and $B$ are **independent** if:

$$P(A \cap B) = P(A) P(B)$$

Equivalently: $P(A|B) = P(A)$ (knowing $B$ gives no information about $A$).

**Conditional independence:** $A$ and $B$ are independent given $C$ if:

$$P(A \cap B | C) = P(A|C) P(B|C)$$

Foundation of Naive Bayes classifiers and graphical models.

## Bayes' Theorem

$$P(A|B) = \frac{P(B|A) P(A)}{P(B)}$$

Expanded form:

$$P(A|B) = \frac{P(B|A) P(A)}{P(B|A) P(A) + P(B|\neg A) P(\neg A)}$$

For multiple hypotheses $H_1, \ldots, H_k$:

$$P(H_i | D) = \frac{P(D | H_i) P(H_i)}{\sum_j P(D | H_j) P(H_j)}$$

**Terms:**
- $P(H_i)$: prior (belief before seeing data)
- $P(D | H_i)$: likelihood (probability of data under hypothesis)
- $P(H_i | D)$: posterior (updated belief after seeing data)
- $P(D)$: evidence (normalizing constant)

## Law of Total Probability

If $B_1, \ldots, B_k$ form a partition of $\Omega$:

$$P(A) = \sum_{i=1}^k P(A | B_i) P(B_i)$$

Used to compute marginal probabilities from conditionals.

## Combinatorics

**Permutations:** number of ways to arrange $k$ items from $n$:

$$P(n, k) = \frac{n!}{(n-k)!}$$

**Combinations:** number of ways to choose $k$ items from $n$ (order doesn't matter):

$$\binom{n}{k} = \frac{n!}{k!(n-k)!}$$

**Binomial coefficient properties:**
- $\binom{n}{0} = \binom{n}{n} = 1$
- $\binom{n}{k} = \binom{n}{n-k}$
- Pascal's identity: $\binom{n}{k} = \binom{n-1}{k-1} + \binom{n-1}{k}$

## Key Probability Distributions

| Distribution | Type | Formula | Mean | Variance |
|--------------|------|---------|------|----------|
| Bernoulli | Discrete | $P(X=1) = p$ | $p$ | $p(1-p)$ |
| Binomial | Discrete | $\binom{n}{k} p^k (1-p)^{n-k}$ | $np$ | $np(1-p)$ |
| Geometric | Discrete | $(1-p)^{k-1} p$ | $1/p$ | $(1-p)/p^2$ |
| Poisson | Discrete | $\frac{\lambda^k e^{-\lambda}}{k!}$ | $\lambda$ | $\lambda$ |
| Uniform | Continuous | $\frac{1}{b-a}$ on $[a,b]$ | $\frac{a+b}{2}$ | $\frac{(b-a)^2}{12}$ |
| Normal | Continuous | $\frac{1}{\sqrt{2\pi\sigma^2}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$ | $\mu$ | $\sigma^2$ |

See [Probability Distributions](02-probability-distributions.md) for full details.

## Key AI/ML Applications

| Concept | Where Used |
|---------|------------|
| Bayes' theorem | Naive Bayes, Bayesian inference, spam filtering |
| Conditional independence | Graphical models, HMMs, Bayesian networks |
| Chain rule | Sequence modeling, language models |
| Combinatorics | Feature selection, model counting |
| Probability axioms | Foundation of all probabilistic ML |
