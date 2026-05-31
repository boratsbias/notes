# GloVe: Global Vectors for Word Representation (2014)

**Authors:** Jeffrey Pennington, Richard Socher, Christopher D. Manning
**Area:** Natural Language Processing, Word Embeddings
**Link:** [ACL Anthology](https://aclanthology.org/D14-1162/)

## The gap between local and global methods

Word2vec learns from local context windows: for each training token, it looks at a small neighborhood and adjusts vectors based on what words co-occur within that window. The full co-occurrence statistics of the corpus are never explicitly consulted. Older **matrix factorization** methods like LSA take the opposite approach: they build a global co-occurrence matrix over the entire corpus and factorize it. LSA captures global statistics well but produces embeddings that perform poorly on word analogy benchmarks, the linear geometry that word2vec embeddings exhibit so strikingly. GloVe argues that neither approach alone is optimal and proposes a training objective that directly connects word vector dot products to global co-occurrence counts, combining the advantages of both families.

## The co-occurrence ratio insight

The key theoretical contribution is about **ratios of co-occurrence probabilities** rather than raw probabilities. Consider the words "ice" and "steam." The probability that "solid" appears near "ice" is high, and the probability that "solid" appears near "steam" is low, so their ratio is large. For "water," which relates to both, the ratio is close to 1. For an unrelated word like "fashion," both probabilities are low and the ratio is again near 1. Ratios discriminate relevant from irrelevant words far more cleanly than raw probabilities. The GloVe objective is derived from the requirement that word vectors encode these ratios: the dot product of two word vectors should equal the log of their co-occurrence count, adjusted by per-word bias terms that absorb individual word frequency effects.

## Training objective and weighting

The model minimizes a weighted least-squares loss over all co-occurring word pairs. A **weighting function** caps the contribution of very frequent pairs: pairs involving "the" or "of" should not dominate training because their high frequency reflects grammatical function rather than semantic content. The bias terms serve a complementary role, letting the model separate the frequency signal from the meaning signal without discarding either. The co-occurrence matrix is computed once over the full corpus before training begins, so each gradient step operates on precomputed statistics rather than raw text, making training faster than window-based methods that must stream through the entire corpus repeatedly.

## Results and impact

GloVe matched or exceeded word2vec on word analogy and similarity benchmarks while training faster by operating on the precomputed matrix. It became one of the two standard pretrained embeddings through the mid-2010s, alongside word2vec, and its 50, 100, and 300-dimensional pretrained vectors were a default starting point for NLP systems throughout that period. The paper also sharpened the theoretical understanding of why window-based methods produce linear geometry: the log-bilinear training objective is the reason, not an accidental property of the optimization. This understanding directly informed later analysis of what neural language models implicitly factorize.
