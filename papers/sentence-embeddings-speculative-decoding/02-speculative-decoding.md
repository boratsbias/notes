# Fast Inference from Transformers via Speculative Decoding (2022)

**Authors:** Yaniv Leviathan, Matan Kalman, Yossi Matias
**Area:** Natural Language Processing, Inference Optimization
**Link:** [arXiv](https://arxiv.org/abs/2211.17192)

## What the paper argues

Autoregressive LLM decoding is memory-bandwidth bound: each forward pass of a large model produces exactly one token, and the GPU spends most time moving model weights from HBM to compute units. A single forward pass over k tokens in parallel is barely more expensive than a single-token pass. Speculative decoding exploits this: a small cheap model proposes k candidate tokens, then the large model verifies all k in one parallel pass. If the candidates are good, k tokens are produced for roughly the cost of one large model forward pass.

## The draft-verify algorithm

```
Step 1 (draft):   small model generates tokens t_1, t_2, ..., t_k autoregressively
Step 2 (verify):  large model runs one forward pass over all k+1 positions in parallel

For each position i:
  - if large_model agrees with draft token:  accept t_i, move to i+1
  - if large_model disagrees:               reject, sample from corrected distribution, stop

Accepted tokens are emitted. Restart from the last accepted position.
```

The output distribution is provably identical to the large model's distribution. Speculative decoding is lossless: it changes speed, not quality.

## When it helps

Speedup depends on the draft acceptance rate α (fraction of draft tokens the large model agrees with). If α is high (predictable, templated outputs), many tokens are accepted per verification pass. If α is low (creative, diverse outputs), few tokens are accepted and overhead is wasted.

```
Expected tokens per step ≈ (1 - αᵏ) / (1 - α)
```

For α = 0.8 and k = 5, expected tokens per step ≈ 3.4 instead of 1.

## Results and impact

2-3x speedup on code generation and summarization with no change in output distribution. Adopted in production inference systems at Google and implemented in vLLM, llama.cpp, and HuggingFace TGI. Motivated follow-up work on self-speculative decoding and tree-based speculative approaches.
