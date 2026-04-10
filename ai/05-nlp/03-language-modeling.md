# Language Modeling

A language model assigns a probability to a sequence of tokens. It is the foundation of modern NLP: pretraining a language model on large corpora produces representations that transfer to virtually every downstream task.

## The Language Modeling Objective

Given a sequence $w_1, w_2, \ldots, w_T$, the joint probability is:

$$p(w_1, \ldots, w_T) = \prod_{t=1}^T p(w_t | w_1, \ldots, w_{t-1})$$

by the chain rule. A language model learns to estimate each conditional $p(w_t | w_{<t})$.

**Training:** maximize log-likelihood (minimize cross-entropy) over a large corpus:

$$\mathcal{L} = -\frac{1}{T}\sum_{t=1}^T \log p_\theta(w_t | w_{<t})$$

## Perplexity

The standard evaluation metric. Lower is better.

$$\text{PPL} = \exp\!\left(-\frac{1}{T}\sum_{t=1}^T \log p(w_t | w_{<t})\right) = \exp(\mathcal{L})$$

**Interpretation:** the effective vocabulary size the model is "choosing from" at each step. PPL = 10 means the model is as uncertain as choosing uniformly among 10 options.

**Baseline:** uniform over vocabulary: $\text{PPL} = |V|$.

## N-gram Language Models

Approximate the conditional with a fixed context window of $n-1$ words:

$$p(w_t | w_{<t}) \approx p(w_t | w_{t-n+1}, \ldots, w_{t-1})$$

**Bigram:** $p(w_t | w_{t-1}) = \frac{c(w_{t-1}, w_t)}{c(w_{t-1})}$

**Sparsity problem:** most $n$-grams never appear in training data. Requires smoothing.

**Smoothing methods:**

| Method | Idea |
|--------|------|
| Add-$k$ (Laplace) | Add $k$ to all counts |
| Interpolation | Combine trigram, bigram, unigram with learned weights |
| Kneser-Ney | Discounting + absolute continuation probability |
| Stupid Backoff | Use lower-order model when count is zero |

Kneser-Ney smoothing is the standard for n-gram models. N-gram models are practical for small-scale applications (keyboard autocomplete) but saturate in quality quickly.

## Neural Language Models

Replace the n-gram table with a neural network that can capture longer dependencies and share statistical strength across similar contexts.

### Fixed-Window Neural LM (Bengio et al. 2003)

Concatenate embeddings of $n-1$ context words; pass through MLP to predict next word.

$$p(w_t | w_{t-n+1:t-1}) = \text{softmax}(W_2 \tanh(W_1 [e_{t-n+1}; \ldots; e_{t-1}] + b_1) + b_2)$$

Limitation: fixed context window; no weight sharing across positions.

### RNN Language Models

Process sequences recurrently:

$$h_t = f(W_h h_{t-1} + W_x e_t + b)$$
$$p(w_{t+1} | w_{\leq t}) = \text{softmax}(W_o h_t + b_o)$$

Theoretically unbounded context; in practice, vanishing gradients limit effective context. LSTMs extend this. See [Sequence Models](04-sequence-models).

### Transformer Language Models

Decoder-only Transformer with causal self-attention. Full parallel training; excellent at long-range dependencies. The dominant architecture. See [Transformers](06-transformers).

## Bidirectional vs. Causal LMs

**Causal (autoregressive) LM:** $p(w_t | w_{<t})$. Conditions only on past context. Can generate text. GPT family.

**Masked LM (MLM):** $p(w_t | w_{\neq t})$. Conditions on both left and right context. Cannot directly generate; excellent representations. BERT.

**Prefix LM:** causal on the generated tokens, bidirectional on the prefix. T5 in text-to-text framework.

## Pretraining Objectives

| Objective | Model | Description |
|-----------|-------|-------------|
| Causal LM (CLM) | GPT, LLaMA | Predict next token; train on all positions |
| Masked LM (MLM) | BERT | Predict 15% randomly masked tokens |
| Replaced Token Detection | ELECTRA | Distinguish real vs. generator-replaced tokens |
| Denoising | T5, BART | Reconstruct corrupted spans of text |
| Permutation LM | XLNet | Predict tokens in random order with full context |

**ELECTRA efficiency:** the discriminator (detect replaced tokens) sees all tokens, not just 15%. Same FLOPs, more signal. Trains $4\times$ more efficiently than BERT.

## Language Model Scaling

**Scaling laws (Kaplan et al. 2020):** test loss scales as a power law in model parameters $N$, dataset tokens $D$, and compute $C$:

$$L(N) \propto N^{-\alpha_N}, \quad L(D) \propto D^{-\alpha_D}$$

**Chinchilla scaling (Hoffmann et al. 2022):** optimal compute allocation requires $D \approx 20N$ tokens. Many large models were undertrained; a smaller model trained on more data can outperform a larger model trained on fewer tokens.

## Decoding Strategies

At inference, generating text requires choosing tokens from $p(w_t | w_{<t})$.

**Greedy decoding:** always pick $\arg\max$. Fast; repetitive and degenerate.

**Beam search:** maintain top-$k$ partial sequences at each step. Better quality; still tends toward generic outputs.

**Top-$k$ sampling:** sample from the top-$k$ most probable tokens. Diverse but can sample low-quality tokens.

**Top-$p$ (nucleus) sampling:** sample from the smallest set of tokens whose cumulative probability exceeds $p$. Adapts to the sharpness of the distribution. $p = 0.9$–$0.95$ typical.

**Temperature:** scale logits by $1/T$ before softmax. $T < 1$: sharper, more conservative; $T > 1$: flatter, more random. $T = 0$ is greedy.

**Min-$p$ sampling (2024):** filter tokens below $p_\text{min} \times p_\text{max}$. Adapts threshold relative to the top token's probability; strong quality/diversity balance.

| Strategy | Diversity | Quality | Speed |
|----------|-----------|---------|-------|
| Greedy | None | Low | Fast |
| Beam search | Low | Moderate | Moderate |
| Top-$k$ | High | Moderate | Fast |
| Top-$p$ | High | Good | Fast |
| Temperature + top-$p$ | Tunable | Good | Fast |
