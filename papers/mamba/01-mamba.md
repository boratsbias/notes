# Mamba: Linear-Time Sequence Modeling with Selective State Spaces (2023)

**Authors:** Albert Gu, Tri Dao
**Area:** Deep Learning, Sequence Modeling
**Link:** [arXiv](https://arxiv.org/abs/2312.00752)

## What the paper argues

Transformers have quadratic attention cost in sequence length. State-space models (SSMs) like S4 run in linear time but underperform transformers on tasks requiring selective recall, because they apply a fixed linear recurrence to every token. Mamba introduces **selective state spaces**: the recurrence parameters are made input-dependent, letting the model decide what to remember and what to forget at each step, like attention but at linear cost.

## State-space model basics

A linear SSM maps an input sequence x(t) to an output y(t) through a hidden state h(t):

```
h'(t) = A · h(t) + B · x(t)     ← state update
y(t)  = C · h(t)                 ← output projection
```

Discretized for sequences:

```
h_t = Ā · h_{t-1} + B̄ · x_t
y_t = C · h_t
```

In standard SSMs, A, B, C are fixed (time-invariant). Mamba makes B and C functions of the current input:

```
B_t = Linear(x_t)
C_t = Linear(x_t)
```

This **selectivity** lets the model filter irrelevant tokens (set B_t ≈ 0 to not write them to state) and selectively read from state (adjust C_t based on what the current query needs).

## Hardware-aware parallel scan

Making B and C input-dependent breaks the time-invariant convolution that made SSMs trainable efficiently with FFTs. Mamba replaces it with a **parallel scan algorithm** implemented in a custom CUDA kernel that avoids materializing the full sequence in HBM (GPU high-bandwidth memory), running the recurrence in SRAM:

```
Training:  parallel scan  →  fast, like a convolutional model
Inference: sequential recurrence  →  O(1) per step, like an RNN
```

## Results and impact

Mamba matches or outperforms transformers of comparable size on language modeling, DNA modeling, and audio benchmarks, with 5x higher throughput at 2k sequence length. It sparked significant research into SSM-transformer hybrid architectures (Mamba-2, Jamba) and demonstrated that state-space models are a practical alternative to attention for long sequences.
