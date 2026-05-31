---
title: "Outrageously Large Neural Networks: The Sparsely-Gated Mixture-of-Experts Layer"
authors: "Noam Shazeer, Azalia Mirhoseini, Krzysztof Maziarz, Andy Davis, Quoc Le, Geoffrey Hinton, Jeff Dean"
year: 2017
area: Deep Learning, Scalability
link: https://arxiv.org/abs/1701.06538
---

## The capacity-compute coupling problem

In a dense model, every parameter participates in every forward pass. Doubling parameter count doubles both capacity and compute. This coupling imposes a hard practical ceiling on model size, because the cost of a forward pass grows linearly with parameters. The paper's motivating insight is that capacity and compute can be decoupled: a model can have many more parameters than it uses on any single input.

## The MoE layer

Each MoE layer contains E expert sub-networks, typically feed-forward networks of the same shape. A gating network takes the current hidden state and produces a score for each expert. Only the top-k experts by score are activated, and the layer's output is a weighted sum of those k experts' outputs using the gate scores as weights. Noise drawn from a standard normal distribution is added to gate logits during training, encouraging the model to explore different experts rather than collapsing onto the same few. Setting k=1 or k=2 keeps per-token compute nearly constant while E can be scaled to thousands. Capacity grows linearly with E, but the compute cost per token grows only with k.

## Load balancing

Without constraints, the gating network quickly learns to route all tokens to a small subset of experts. The neglected experts receive no gradient signal and become useless, while the popular experts become overloaded. The paper addresses this with an auxiliary load-balancing loss that penalizes uneven utilization by measuring the coefficient of variation of tokens received per expert across a batch. This encourages all experts to process comparable numbers of tokens. A capacity factor controls each expert's token buffer size, and tokens routed to over-capacity experts are dropped or redirected. Expert specialization emerges without explicit supervision: different experts learn to handle different content types as a consequence of the routing dynamics.

## Results and impact

The MoE model achieved roughly 1000x the capacity of a comparable dense model with only about 2x the compute overhead on language modeling tasks, demonstrating that the decoupling is practically achievable at scale. This paper established the MoE architecture that was subsequently refined in Switch Transformer, which reduced k to 1 for further efficiency, and in Mixtral, which applied the design to large open language models. The sparsely gated MoE layer is widely believed to be a component of GPT-4 and several other frontier models.
