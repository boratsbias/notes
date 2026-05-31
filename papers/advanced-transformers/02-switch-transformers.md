---
title: "Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity"
year: 2021
authors: William Fedus, Barret Zoph, Noam Shazeer
area: Deep Learning, Scalability, Mixture of Experts
link: https://arxiv.org/abs/2101.03961
---

## Simplifying mixture of experts

The 2017 mixture-of-experts paper routed each token to k=2 experts per layer. Switch Transformers reduce this to k=1, meaning each token is processed by exactly one expert per Switch layer. The argument is practical: top-1 routing simplifies the routing logic, eliminates the need to combine outputs from multiple experts, and dramatically reduces communication overhead in distributed training across TPU pods. Crucially, scaling to more experts does not increase the compute per token, because only one FFN is activated per token regardless of how many total experts exist. This allows parameter count to grow without proportional growth in FLOPs.

## The Switch layer mechanism

Each transformer block contains a Switch layer that replaces the standard feedforward sublayer. When a token's hidden state reaches the Switch layer, a lightweight router applies a linear projection followed by softmax over E experts to produce a probability distribution. The expert with the highest probability receives the token and processes it through its own independent FFN. The output replaces what the standard FFN would have produced. All other experts are bypassed for that token. The router is the only additional component and adds negligible compute.

## Capacity buffers and load balancing

Each expert has a fixed capacity: at most C tokens per batch, where C = capacity_factor × (tokens_per_batch / num_experts). If a popular expert receives more than C tokens in a batch, excess tokens skip the expert entirely and pass through unchanged. A capacity factor above 1.0 reduces token dropping but wastes allocated memory. Without any regularization, the router collapses onto a small number of popular experts, starving the rest. An auxiliary load-balancing loss discourages this by penalizing uneven token distribution, computed as the dot product of per-expert importance (summed routing probabilities) and per-expert load (fraction of tokens assigned). Minimizing this term pushes routing toward uniformity.

## Training stability fixes

Sparse models at large scale are prone to instability and NaN losses. Two targeted fixes proved sufficient. First, router weights are initialized with small values, reducing variance in routing decisions early in training before the model has learned meaningful representations. Second, routing computations are performed in float32 precision even when the rest of the model uses bfloat16. Numerical errors in the softmax accumulate and cause divergence in bfloat16; float32 routing eliminates this without significant cost since the router itself is small.

## Results and impact

Switch Transformer reaches T5-Base perplexity in one-seventh the pre-training time. The paper demonstrated that trillion-parameter models are practically trainable on TPU pod infrastructure. Top-1 routing, once considered too simple, proved competitive with k=2 routing while being easier to implement and scale. The architecture directly influenced Mixtral and subsequent production MoE deployments that now underpin several large language models.
