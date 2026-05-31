# GloVe: Global Vectors for Word Representation (2014)

**Authors:** Jeffrey Pennington, Richard Socher, Christopher D. Manning
**Area:** Natural Language Processing, Word Embeddings
**Link:** [ACL Anthology](https://aclanthology.org/D14-1162/)

## What the paper argues

word2vec trains on local context windows one word at a time, ignoring global co-occurrence statistics. Matrix factorization methods like LSA use the full co-occurrence matrix but produce poor analogical reasoning. GloVe combines both: it trains directly on global co-occurrence counts and produces embeddings with the linear geometric structure of word2vec.

## The key insight

The ratio of co-occurrence probabilities encodes meaning more clearly than raw probabilities. Given words i = "ice" and j = "steam":

```
P(k|ice) / P(k|steam)  ≈  large    when k = "solid"   (related to ice, not steam)
P(k|ice) / P(k|steam)  ≈  small    when k = "gas"     (related to steam, not ice)
P(k|ice) / P(k|steam)  ≈  1        when k = "water"   (related to both)
```

GloVe trains embeddings so that their dot product approximates the log of co-occurrence count:

```
w_i · w_j + b_i + b_j  ≈  log X_{ij}
```

where X_{ij} is the number of times word j appears in the context of word i. A weighting function down-weights very frequent pairs to prevent "the" from dominating.

## Results and impact

GloVe matched or outperformed word2vec on word analogy and similarity benchmarks while training faster on the same corpus, since it processes the co-occurrence matrix rather than iterating through the full text. It became one of the two standard pre-trained embedding sets (alongside word2vec) used throughout the mid-2010s.
