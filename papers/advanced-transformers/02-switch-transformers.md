# Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity (2021)

**Authors:** William Fedus, Barret Zoph, Noam Shazeer
**Area:** Deep Learning, Scalability, Mixture of Experts
**Link:** [arXiv](https://arxiv.org/abs/2101.03961)

## What the paper argues

The 2017 MoE paper routed each token to k=2 experts. Switch Transformers simplify this to k=1 (one expert per token). This **Switch layer** is simpler, has lower communication overhead in distributed training, and scales to over a trillion parameters while keeping the compute per token the same as a dense model.

## Switch routing

Each transformer block replaces the feed-forward sublayer with a Switch layer:

```
Token h
  ↓
Router: softmax(h W_r)  →  scores over E experts
  ↓
Select top-1 expert (highest score)
  ↓
Expert FFN processes h
  ↓
Output (no weighted sum needed since only 1 expert)
```

Each expert has a capacity buffer: it can process at most C tokens per batch. If an expert is over capacity, excess tokens are passed through unchanged (token dropping). A **capacity factor** controls the buffer size:

```
expert capacity = (tokens per batch / num experts) × capacity factor
```

Setting capacity factor > 1 reduces dropping but increases memory usage.

## Training stability

Sparse models are more unstable than dense models at large scale. The paper identifies two fixes:

1. Initialize router weights with small values (reduces initial routing variance)
2. Compute routing in float32 even if the rest of the model uses bfloat16 (prevents NaN losses)

## Results and impact

A Switch Transformer reaches the same perplexity as T5-Base in 1/7th the pre-training time. Demonstrated that trillion-parameter models are practically trainable on TPU pods. Established top-1 sparse routing as a viable and simpler alternative to top-k routing. Directly influenced Mixtral and subsequent production MoE architectures.
