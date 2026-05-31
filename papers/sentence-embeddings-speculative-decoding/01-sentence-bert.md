# SentenceBERT: Sentence Embeddings using Siamese BERT-Networks (2019)

**Authors:** Nils Reimers, Iryna Gurevych
**Area:** Natural Language Processing, Sentence Embeddings
**Link:** [arXiv](https://arxiv.org/abs/1908.10084)

## What the paper argues

Computing semantic similarity with BERT requires feeding both sentences through the model together, which is O(n²) for a corpus of n sentences. Comparing 10,000 sentences against each other requires ~50 million BERT inference passes. SentenceBERT fine-tunes BERT with a siamese structure so each sentence can be encoded independently to a fixed vector, reducing similarity search to a dot product.

## Siamese architecture

```
Sentence A  →  BERT  →  mean pool over tokens  →  embedding u
Sentence B  →  BERT  →  mean pool over tokens  →  embedding v
                                                        ↓
                        softmax(W · concat(u, v, |u-v|))  →  NLI label
```

Both branches share the same BERT weights. The model is fine-tuned on NLI data (entailment, neutral, contradiction) so that:
- entailment pairs → embeddings are close in cosine space
- contradiction pairs → embeddings are far apart

A triplet loss variant pulls anchors toward positives and pushes them from negatives directly in embedding space.

## Semantic search at scale

After training, encode the entire corpus once and store embeddings. At query time, encode the query and run approximate nearest neighbor search:

```
offline:  embed all N docs once  →  store in vector index (FAISS, etc.)
online:   embed query (1 BERT pass)  →  cosine search in index  →  top-k results
```

This reduces per-query cost from O(N) BERT passes to O(1) BERT pass + fast vector search.

## Results and impact

SentenceBERT dramatically outperformed previous sentence embedding methods on STS benchmarks and reduced computation for 10,000-sentence comparisons from 65 hours to 5 seconds. It became the foundation of the sentence-transformers library, which underpins most production semantic search systems today.
