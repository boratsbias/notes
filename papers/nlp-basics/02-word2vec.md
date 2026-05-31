# word2vec: Distributed Representations of Words and Phrases and Their Compositionality (2013)

**Authors:** Tomas Mikolov, Ilya Sutskever, Kai Chen, Greg Corrado, Jeffrey Dean
**Area:** Natural Language Processing, Word Embeddings
**Link:** [arXiv](https://arxiv.org/abs/1310.4546)

## What the paper argues

Training a full language model to get word vectors is expensive. word2vec strips the architecture to the minimum: two shallow objectives with no hidden layers, trained on billions of words, produce embeddings that capture richer semantic structure than any previous method.

## Two architectures

**CBOW (Continuous Bag of Words):** predict the center word from surrounding context words.

**Skip-gram:** predict surrounding context words from the center word.

```
CBOW:    [w-2, w-1, _, w+1, w+2]  →  predict  w
Skip-gram:        w               →  predict  [w-2, w-1, w+1, w+2]
```

Skip-gram works better for rare words. Both are trained with **negative sampling**: instead of updating all vocabulary weights at each step, update only the target word and k randomly sampled negative words (k = 5-20). This makes training on billions of words feasible.

## Linear structure of the embedding space

The trained embeddings satisfy arithmetic relationships:

```
vec("king") - vec("man") + vec("woman")  ≈  vec("queen")
vec("Paris") - vec("France") + vec("Italy")  ≈  vec("Rome")
```

This shows the geometry of the space encodes semantic and syntactic relationships, not just co-occurrence statistics.

## Results and impact

word2vec became the dominant embedding method and was used in nearly every NLP system through the mid-2010s. The negative sampling trick and the demonstration of linear semantic geometry were both widely adopted and studied. It directly influenced GloVe, FastText, and the pre-training paradigm that led to BERT.
