---
title: "Mixtral of Experts"
authors: "Mistral AI"
year: 2024
area: "Large Language Models, Mixture of Experts"
link: "https://arxiv.org/abs/2401.04088"
---

## Parameter-compute decoupling

Dense language models couple parameter count and compute inseparably: more parameters mean more computation per token. Mixture-of-experts architectures break this coupling. Mixtral 8x7B has 46.7B total parameters, but only 12.9B parameters are activated per token during inference. The remaining parameters belong to expert networks that the current token's gating decision did not select. This means the model thinks at 13B-scale compute while storing 47B-scale knowledge, a favorable trade-off for both quality and speed.

## Expert routing mechanism

Each transformer block in Mixtral replaces the standard feed-forward network with eight parallel expert FFN networks. A gating network computes a score for each of the eight experts, selects the top two, and routes the token to those two experts. The output for that token is a weighted sum of the two experts' outputs, where the weights come from the softmax-normalized gate scores. The gating decision is made independently for each token at each layer, so the same token may be routed to different expert pairs at different layers.

Specialization emerges without explicit supervision. Analysis of routing decisions shows that certain experts handle specific domains or syntactic roles more frequently than others, though the assignment is soft and statistical rather than hard.

## Sliding window attention

Mixtral uses sliding window attention in place of full self-attention. Each token attends to at most a fixed window of previous tokens rather than the entire sequence. This reduces attention memory from O(n²) to O(n times W), where W is the window size, allowing the model to handle longer sequences efficiently. The effective receptive field extends beyond the window through stacked layers, since information from earlier tokens propagates forward through the sequence over multiple transformer blocks.

## Results and impact

Mixtral 8x7B outperforms LLaMA 2 70B on most benchmarks and matches or exceeds GPT-3.5 on standard evaluation suites, despite activating less than a third of GPT-3.5's estimated active parameter count per token. Mistral released the weights publicly under an open license, making Mixtral the first high-quality open-weight MoE model at this scale. The release demonstrated that mixture-of-experts is practically viable at the 7B-equivalent compute point, not just at frontier scale, and sparked a wave of subsequent open-weight MoE work.
