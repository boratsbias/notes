# Leave No Context Behind (2024)

**Authors:** Tsendsuren Munkhdalai, Manaal Faruqui, Siddharth Gopal
**Area:** Natural Language Processing, Long Context
**Link:** [arXiv](https://arxiv.org/abs/2404.07143)

## What the paper argues

Standard transformers have a fixed context window. Processing a document longer than this window requires either truncating it or using a sliding window that loses global context. This paper introduces **Infini-attention**, which augments the standard attention layer with a compressive memory so the model can maintain and retrieve information from an arbitrarily long past context without quadratic cost.

## Infini-attention

Each Infini-attention layer has two components running in parallel:

```
Current segment tokens
        ├──────────────────────────────┐
        ↓                             ↓
  Local dot-product attention   Memory retrieval  (from compressed past)
        └──────────────┬───────────────┘
                 learned gate σ
                       ↓
               Combined output
```

The compressive memory is a fixed-size matrix M. Keys and values from processed segments are written into M using an associative update rule. At the next segment, the model reads from M by computing attention scores against the stored keys. A learned scalar gate σ per head controls how much to weight local attention vs memory retrieval.

## Memory update rule

```
M_new = M_old + K^T V        (write: add outer product of keys and values)
A_mem = σ(Q M_old^T)         (read: query the memory)
```

This keeps memory cost O(d²) rather than O(n · d), regardless of total sequence length processed.

## Results and impact

Models with Infini-attention handle 1M+ token sequences and solve passkey retrieval tasks at that scale. The mechanism is plug-in compatible with existing transformers, requiring no architectural changes beyond the attention layers. It represents one approach to the active problem of extending context without quadratic attention cost.
