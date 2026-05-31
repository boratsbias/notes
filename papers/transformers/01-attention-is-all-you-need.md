# Attention Is All You Need (2017)

**Authors:** Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Lukasz Kaiser, Illia Polosukhin
**Area:** Natural Language Processing, Transformers
**Link:** [arXiv](https://arxiv.org/abs/1706.03762)

## What the paper argues

RNNs process tokens sequentially: token t cannot be computed until token t-1 is done. This prevents parallelization and makes it hard to connect distant tokens because information must flow through every intermediate step. The paper argues that attention alone, with no recurrence, is sufficient and superior: any two positions can interact directly, and the entire sequence is processed in parallel.

## Scaled dot-product attention

For a set of queries Q, keys K, and values V:

```
Attention(Q, K, V) = softmax( Q Kᵀ / √d_k ) V
```

Each query attends to all keys by computing dot products, scaling by √d_k (to prevent large dot products from pushing softmax into low-gradient regions), applying softmax to get weights, and taking a weighted sum of values. This is O(n²) in sequence length but O(1) in how far information can travel between positions.

## Multi-head attention

Run h attention heads in parallel, each in a lower-dimensional subspace:

```
MultiHead(Q,K,V) = Concat(head_1, ..., head_h) W^O
     head_i = Attention(Q W_i^Q, K W_i^K, V W_i^V)
```

Different heads learn to attend to different relationship types simultaneously (syntactic, positional, semantic).

## Transformer block

```
Input
  ↓
[Multi-Head Self-Attention]  +  residual
  ↓
[Layer Norm]
  ↓
[Feed-Forward (linear → ReLU → linear)]  +  residual
  ↓
[Layer Norm]
  ↓
Output
```

Encoder stacks N of these blocks. Decoder adds a cross-attention sublayer between self-attention and feed-forward, attending to the encoder output.

## Results and impact

State of the art on English-German and English-French translation at a fraction of the compute of the best RNN models. The transformer became the backbone of BERT, GPT, ViT, Whisper, AlphaFold, and essentially every major AI system since.
