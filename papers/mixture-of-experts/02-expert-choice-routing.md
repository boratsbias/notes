# Mixture-of-Experts with Expert Choice Routing (2022)

**Authors:** Yanqi Zhou et al.
**Area:** Deep Learning, Mixture of Experts
**Link:** [arXiv](https://arxiv.org/abs/2202.09368)

## What the paper argues

Standard MoE routing is token-choice: each token picks its top-k experts. This causes load imbalance because popular experts receive too many tokens and must drop them, while others sit idle. Expert Choice flips the routing direction: each expert independently selects its top-k tokens from the batch. Load balance is guaranteed by construction with no auxiliary loss needed.

## Token-choice vs expert-choice

```
Token-choice:   each token  →  selects k experts       (token decides)
                Problem: popular experts get overloaded, tokens may be dropped

Expert-choice:  each expert →  selects k tokens        (expert decides)
                Each expert processes exactly k tokens per batch: perfectly balanced
```

For a batch of T tokens and E experts each selecting k tokens, each expert processes exactly k tokens. A token may be selected by 0, 1, or multiple experts.

## Heterogeneous compute allocation

Since tokens compete for expert slots, harder or more informative tokens attract more expert selections. Easy or repetitive tokens may be skipped entirely:

```
"The"   →  selected by 0 experts  (trivial, skipped)
"mitochondria"  →  selected by 3 experts  (rare, gets more processing)
```

This is an emergent form of adaptive compute allocation: the model implicitly gives more capacity to tokens that need it.

## Results and impact

Expert Choice outperformed standard top-k token-choice MoE on language modeling and fine-tuning benchmarks, converging faster and reaching better perplexity with the same compute. The perfect load balance eliminates dropped tokens and training instability from imbalanced routing, making it a cleaner training objective.
