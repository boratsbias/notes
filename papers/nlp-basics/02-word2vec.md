# word2vec: Distributed Representations of Words and Phrases and Their Compositionality (2013)

**Authors:** Tomas Mikolov, Ilya Sutskever, Kai Chen, Greg Corrado, Jeffrey Dean
**Area:** Natural Language Processing, Word Embeddings
**Link:** [arXiv](https://arxiv.org/abs/1310.4546)

## The core insight

The Bengio 2003 model learned excellent word embeddings as a side effect of training a full language model, but training a full language model is expensive. The word2vec insight is that **the language modeling objective is overkill** if the goal is just to learn useful vector representations. You do not need to predict exact probability distributions over the vocabulary. You only need to create a training signal that pushes words appearing in similar contexts toward similar vectors. Stripping the model down to the minimal architecture that achieves this allows training on billions of words in a fraction of the time.

## Two architectures

The paper introduces two model variants. **CBOW** (Continuous Bag of Words) takes the context words surrounding a target and predicts the center word. **Skip-gram** takes the center word and predicts each surrounding context word. Skip-gram produces better representations for rare words because predicting multiple context words from a single center word generates more gradient signal per training token: a single occurrence of an infrequent word updates the model many times, once per predicted context position. Both models are shallow, with no hidden nonlinearity between the input embedding and the output prediction.

## Negative sampling

The remaining bottleneck is the softmax over the full vocabulary at every step. **Negative sampling** replaces it: instead of computing a full probability distribution, the model treats each training example as a binary classification problem. Is this (word, context) pair a real co-occurrence or a noise pair? For each real pair, sample k random words from the vocabulary as negatives and update only the embeddings of the target word and those k negatives. With k between 5 and 20, training on a billion-word corpus becomes feasible on a single machine.

## Linear geometry of the embedding space

The most striking result is the **linear algebraic structure** of the learned space. The vector arithmetic vec(king) - vec(man) + vec(woman) produces a point nearest to vec(queen). Similarly, vec(Paris) - vec(France) + vec(Italy) points toward vec(Rome). These relationships are not programmed in: they emerge from the distributional statistics of the training corpus. The embedding space is encoding relational structure, grammatical and semantic, as linear offsets between regions. This is evidence that the geometry of the space reflects genuine regularities in language, not just surface co-occurrence patterns.

## Results and impact

word2vec became the dominant embedding method through the mid-2010s, largely because negative sampling made large-scale training practical and the resulting embeddings transferred well across tasks. It directly influenced GloVe, which asked why the same geometry should not be derivable from global co-occurrence statistics, and FastText, which extended the approach to subword units. More broadly, word2vec established the template for the pre-training paradigm: train a self-supervised objective on large unlabeled text, then transfer the learned representations to downstream tasks.
