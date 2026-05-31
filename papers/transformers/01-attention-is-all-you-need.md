---
title: "Attention Is All You Need"
authors: "Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Lukasz Kaiser, Illia Polosukhin"
year: 2017
area: "Natural Language Processing, Transformers"
link: "https://arxiv.org/abs/1706.03762"
---

## The recurrence problem

Sequence models before 2017 were almost exclusively RNN-based. The fundamental problem with recurrence is sequential computation: each step depends on the previous hidden state, making parallelization across the sequence length impossible. Long-range dependencies are additionally fragile because signals must propagate through every intermediate recurrent step, causing gradients to vanish or explode. Convolutional alternatives reduced sequential computation but still required many layers to connect distant positions. The paper's central argument is that attention alone, without any recurrence or convolution, is sufficient to model sequence relationships and is superior in both quality and computational efficiency.

## Scaled dot-product attention

The core operation is:

$$
\text{Attention}(Q, K, V) = \text{softmax}\!\left(\frac{QK^\top}{\sqrt{d_k}}\right)V
$$

Q, K, and V are projections of the input into query, key, and value spaces. The dot product of Q and K measures compatibility between each query and every key, producing a score matrix. Dividing by $\sqrt{d_k}$ prevents large dot products from pushing the softmax into regions of near-zero gradient, which becomes critical at larger embedding dimensions. The softmax converts scores into a probability distribution over positions, and these weights are used to compute a weighted sum over the value vectors. The result is a context-sensitive representation for every position that directly reflects the relevance of every other position, regardless of distance.

## Multi-head attention and architecture

Multi-head attention runs h independent attention operations in parallel, each in a lower-dimensional subspace. Outputs are concatenated and projected. Different heads can specialize in different relationship types, such as syntactic vs. semantic dependencies, within the same layer. The full model uses an encoder-decoder structure. The encoder applies self-attention over the source sequence. The decoder applies masked self-attention over the target sequence and cross-attention over encoder outputs. Positional encodings using sine and cosine functions at different frequencies are added to embeddings, since self-attention is permutation-equivariant and has no inherent sense of position. Residual connections and layer normalization are applied around every sub-layer.

## Results and impact

The Transformer set state-of-the-art BLEU scores on English-German and English-French translation at a fraction of the training compute of previous models. The impact extended far beyond translation. BERT, GPT, ViT, DALL-E, Whisper, AlphaFold 2, and virtually every major AI system built since 2018 use the transformer as their backbone. The attention mechanism made long-range dependencies cheap to compute, unlocked massive parallelization during training, and established a unified architecture that scales from language to vision to protein structure prediction.
