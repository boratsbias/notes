---
title: "Mamba: Linear-Time Sequence Modeling with Selective State Spaces"
year: 2023
authors: Albert Gu, Tri Dao
area: Deep Learning, Sequence Modeling
link: https://arxiv.org/abs/2312.00752
---

## The transformer's quadratic bottleneck

Attention is O(n²) in sequence length. At 100k tokens a single attention layer requires roughly 10 billion operations, and memory usage grows quadratically as well. This makes transformers impractical for genomics, audio, and long-document tasks where sequences routinely exceed tens of thousands of tokens. State-space models like S4 offer linear-time alternatives, but prior SSMs apply a fixed linear recurrence to every input:

$$h_t = \bar{A} h_{t-1} + \bar{B} x_t, \quad y_t = C h_t$$

When $\bar{A}$, $\bar{B}$, and $C$ are time-invariant the model cannot choose to ignore irrelevant tokens. It writes everything into hidden state with equal weight, which causes it to underperform transformers on tasks requiring selective recall of specific past information.

## Selective state spaces

Mamba's core innovation is making $B$ and $C$ input-dependent: $B_t = \text{Linear}(x_t)$, $C_t = \text{Linear}(x_t)$. This selectivity lets the model gate what information to write into state and what to read from state at each step, based on the content of the current input. The mechanism resembles a continuous relaxation of LSTM gating but without the quadratic attention cost. For a factual recall task, the model needs to remember relevant tokens and suppress filler. A time-invariant SSM cannot do this. A selective SSM can set $B_t \approx 0$ for irrelevant tokens, effectively skipping them, while retaining salient information across arbitrarily long contexts.

## Hardware-aware parallel scan

Making B and C input-dependent breaks the time-invariant convolution that made prior SSMs fast to train. Mamba replaces the convolution with a parallel scan algorithm implemented in a custom CUDA kernel. The key insight is that the recurrence can be computed without materializing the full state sequence in high-bandwidth memory. Instead the kernel performs the recurrence entirely in SRAM, which is orders of magnitude faster to access. The result is a model that trains with parallel efficiency comparable to convolution and runs autoregressively at O(1) memory and compute per step at inference.

## Results and impact

Mamba matches or outperforms transformers of comparable parameter count on language modeling, DNA sequence modeling, and audio benchmarks, with 5x higher inference throughput at 2k sequence length. The work demonstrated that SSMs are a practical alternative to attention rather than a theoretical curiosity. It directly sparked research into hybrid architectures combining Mamba blocks with attention layers, including Mamba-2 and Jamba, and renewed interest in linear-time sequence models across the research community.
