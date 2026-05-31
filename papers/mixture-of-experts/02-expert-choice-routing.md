---
title: "Mixture-of-Experts with Expert Choice Routing"
authors: "Yanqi Zhou et al."
year: 2022
area: Deep Learning, Mixture of Experts
link: https://arxiv.org/abs/2202.09368
---

## The token-choice routing problem

In standard MoE routing, each token selects its top-k experts. This creates a load imbalance problem: tokens tend to route to the same popular experts, overloading them while others sit idle. Auxiliary load-balancing losses reduce this imbalance but introduce a training objective that is in tension with the primary language modeling loss. Even with these losses, popular experts still receive more tokens than they can process and must drop the excess, meaning some tokens receive no expert computation at all. The instability from balancing two competing objectives slows convergence and complicates tuning.

## Flipping the routing direction

Expert choice routing inverts the decision: rather than tokens choosing experts, each expert selects its top-k tokens from the full batch. Since each expert selects exactly k tokens by construction, load is perfectly balanced with no auxiliary loss and no dropped tokens. This is the paper's central insight. The routing problem is reframed from a selection problem on the token side to a fixed-budget selection problem on the expert side, and the budget constraint is trivially satisfied.

## Adaptive compute allocation

Flipping the routing direction produces an unexpected benefit: adaptive compute allocation. Experts compete for tokens, so tokens that are more informative or more difficult will be selected by more experts and receive more computation. A common token like "the" appearing frequently in a trivial context may be selected by no experts and pass through only the residual connection. A rare technical term in an ambiguous context may be selected by several experts and receive proportionally more processing. This is not explicitly designed; it emerges from the expert selection dynamics. Token-choice routing allocates the same compute to every token regardless of difficulty, which is a fundamental inefficiency that expert choice eliminates.

## Results and impact

Expert choice MoE outperformed standard top-2 token-choice MoE on language modeling and downstream fine-tuning benchmarks while requiring fewer training steps to converge. The authors attribute the faster convergence to the elimination of load-imbalance instability and to the alignment between model capacity and token difficulty. The paper contributed to a broader understanding that routing direction is a fundamental architectural choice in sparse models, not an implementation detail. It influenced subsequent MoE designs by demonstrating that the standard token-choice framing carries unnecessary assumptions that can be discarded entirely.
