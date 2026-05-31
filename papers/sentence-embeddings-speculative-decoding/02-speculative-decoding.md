# Fast Inference from Transformers via Speculative Decoding (2022)

**Authors:** Yaniv Leviathan, Matan Kalman, Yossi Matias
**Area:** Natural Language Processing, Inference Optimization
**Link:** [arXiv](https://arxiv.org/abs/2211.17192)

## Why autoregressive inference is slow

Generating text with a large language model is memory-bandwidth bound, not compute bound. Each forward pass loads all model weights from high-bandwidth memory to compute units to produce exactly one token. The GPU's arithmetic units are mostly idle during this transfer. The bottleneck is not the computation itself but the cost of moving billions of parameters across the memory bus on every single step. Speculative decoding attacks this bottleneck directly.

## The draft-verify algorithm

The key insight is that a single forward pass over k tokens in parallel costs only slightly more than a single-token pass, because the memory transfer of weights dominates. If a cheap draft model can propose k plausible tokens, the large model can verify all k simultaneously in one forward pass. The algorithm works as follows. A small draft model generates k candidate tokens autoregressively. The large model then runs a single forward pass over the k+1 positions (original context plus k drafts) and computes its own probability distribution at each position. Starting from position 1, token i is accepted if the large model's distribution agrees with the draft to within a threshold; otherwise the first disagreement is found, the token is resampled from a corrected distribution, and all subsequent draft tokens are discarded. This procedure is provably lossless: the output distribution is identical to running the large model alone token by token.

The expected number of tokens generated per large-model forward pass depends on the average acceptance rate alpha and the number of draft tokens k:

\[ \mathbb{E}[\text{tokens per step}] = \frac{1 - \alpha^k}{1 - \alpha} \]

At alpha = 0.8 and k = 5, this yields roughly 3.4 tokens per step instead of 1.

## When it helps and when it does not

Speculative decoding works best when outputs are predictable and templated, such as code generation, summarization of structured documents, and repetitive formatting tasks. It works poorly when outputs are highly creative or diverse, because a low acceptance rate means the large model rejects most drafts and the overhead of running the draft model adds latency without benefit. Performance also depends on the draft and target models being from the same family so that the draft's token distribution is well-aligned with the target's.

## Results and impact

Speculative decoding achieves 2 to 3 times speedup on code generation and summarization benchmarks with no change in output quality. It has been adopted in vLLM, llama.cpp, HuggingFace TGI, and Google production inference systems, making it one of the most widely deployed inference optimizations in practice.
