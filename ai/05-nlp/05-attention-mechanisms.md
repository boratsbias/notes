# Attention Mechanisms

Attention allows a model to dynamically weight different parts of the input when producing each output. It overcomes the bottleneck of fixed-size context vectors in encoder-decoder models and is the core operation in Transformers.

## The Bottleneck Problem

In vanilla seq2seq, the encoder compresses the entire source into a single vector $c = h_T$. For long sequences, this vector cannot hold all relevant information. The decoder cannot selectively retrieve source content.

## Bahdanau Attention

Bahdanau et al. (2015). For each decoder step $t$, compute a context vector $c_t$ as a weighted sum of all encoder hidden states.

**Alignment scores:** a small feedforward network scores how well decoder state $s_{t-1}$ matches each encoder state $h_i$:

$$e_{ti} = v_a^T \tanh(W_a s_{t-1} + U_a h_i)$$

**Attention weights:** softmax over scores:

$$\alpha_{ti} = \frac{\exp(e_{ti})}{\sum_{j=1}^{T_x} \exp(e_{tj})}$$

**Context vector:**

$$c_t = \sum_{i=1}^{T_x} \alpha_{ti} h_i$$

The weights $\alpha_{ti}$ can be visualized as an alignment matrix, showing which source tokens the model attends to when generating each target token.

## Luong Attention

Luong et al. (2015). Computes scores using the current decoder state $s_t$ (after the recurrence) rather than the previous state.

**Dot-product score:** $e_{ti} = s_t^T h_i$

**General score:** $e_{ti} = s_t^T W_a h_i$

**Concat score:** same as Bahdanau.

After computing context $c_t$, concatenate with $s_t$ and apply a linear layer to get the final output state.

## Scaled Dot-Product Attention

The attention operation at the heart of Transformers (Vaswani et al. 2017).

Given queries $Q \in \mathbb{R}^{n \times d_k}$, keys $K \in \mathbb{R}^{m \times d_k}$, values $V \in \mathbb{R}^{m \times d_v}$:

$$\text{Attention}(Q, K, V) = \text{softmax}\!\left(\frac{QK^T}{\sqrt{d_k}}\right) V$$

**Scaling factor $\sqrt{d_k}$:** without it, dot products grow large in magnitude for high $d_k$, pushing softmax into a saturated region with near-zero gradients. Scaling keeps variance of the dot product $\approx 1$.

**Complexity:** $O(n^2 d)$ in time and $O(n^2)$ in memory (the attention matrix). The quadratic $n^2$ term is the main bottleneck for long sequences.

## Multi-Head Attention

Rather than a single attention function, run $h$ attention heads in parallel, each with its own learned projections:

$$\begin{aligned}
\text{head}_i &= \text{Attention}(QW_i^Q, KW_i^K, VW_i^V) \\
\text{MultiHead}(Q, K, V) &= \text{Concat}(\text{head}_1, \ldots, \text{head}_h) W^O
\end{aligned}$$

Where $W_i^Q \in \mathbb{R}^{d_\text{model} \times d_k}$, $W_i^K \in \mathbb{R}^{d_\text{model} \times d_k}$, $W_i^V \in \mathbb{R}^{d_\text{model} \times d_v}$, with $d_k = d_v = d_\text{model}/h$.

**Why multiple heads?** Different heads can attend to different types of relationships (syntactic, semantic, positional) simultaneously.

## Self-Attention

When $Q$, $K$, $V$ are all derived from the same sequence, the operation is called self-attention. Each token attends to every other token in the same sequence.

This replaces the recurrence in RNNs: all pairwise interactions are computed in a single layer, with $O(1)$ depth instead of $O(n)$ sequential steps.

## Causal (Masked) Self-Attention

For autoregressive language modeling, the model must not attend to future tokens. Apply a causal mask before softmax:

$$e_{ij} = -\infty \quad \text{for } j > i$$

This forces $\alpha_{ij} = 0$ for all future positions, preserving the left-to-right generation order.

## Cross-Attention

Used in encoder-decoder Transformers. The decoder attends to the encoder's output:

- Queries come from the decoder hidden states.
- Keys and values come from the encoder output.

This generalizes Bahdanau attention: the same weighted-sum mechanism, now fully parallelized and applied at every Transformer layer.

## Relative Position Encodings

Standard attention is permutation-equivariant (no position information). Positional encodings inject position information.

**Absolute sinusoidal (original Transformer):**

$$\begin{aligned}
PE_{(pos, 2i)} &= \sin(pos / 10000^{2i/d}) \\
PE_{(pos, 2i+1)} &= \cos(pos / 10000^{2i/d})
\end{aligned}$$

Added to token embeddings before the first layer.

**Learned absolute positions:** a learnable embedding per position. Simple; does not extrapolate beyond training length.

**Relative position encodings (T5, DeBERTa):** encode the distance between query and key positions rather than absolute positions. Naturally generalizes to longer sequences.

**Rotary Position Embedding (RoPE):** applied to queries and keys by rotating them in 2D planes proportional to position. Decomposes the position-dependent dot product into a relative distance term. Used in LLaMA, Mistral, GPT-NeoX. Supports length extrapolation with YaRN or other extensions.

**ALiBi (Attention with Linear Biases):** subtracts a linear bias from attention scores proportional to the key-query distance. No positional embedding vectors; strong length generalization.

| Method | Relative positions | Length extrapolation | Extra params |
|--------|-------------------|---------------------|-------------|
| Sinusoidal | No | Limited | None |
| Learned absolute | No | Poor | $O(n_\text{max} \cdot d)$ |
| T5 relative bias | Yes | Good | Small |
| RoPE | Yes | Good (with extensions) | None |
| ALiBi | Yes | Excellent | None |

## Efficient Attention

The $O(n^2)$ complexity limits Transformer context length.

**FlashAttention (Dao et al. 2022):** exact attention with $O(n)$ memory (instead of $O(n^2)$) by tiling the computation to stay in SRAM. Does not approximate; just optimizes memory access patterns. 2-4$\times$ faster wall-clock time.

**FlashAttention-2 / FlashAttention-3:** further optimizations for parallelism and hardware utilization.

**Linear attention:** replaces softmax with a kernel function $\phi(q)^T \phi(k)$, enabling $O(n)$ complexity. Loses some expressivity; active research area.

**Sliding window attention (Longformer, Mistral):** each token attends only to a window of $w$ neighbors plus global tokens. $O(n \cdot w)$ complexity.

**Sparse attention (BigBird, Longformer):** combines local window, global, and random attention patterns. $O(n)$ or $O(n \sqrt{n})$ complexity.
