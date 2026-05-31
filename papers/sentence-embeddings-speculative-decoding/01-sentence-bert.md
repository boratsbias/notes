# SentenceBERT: Sentence Embeddings using Siamese BERT-Networks (2019)

**Authors:** Nils Reimers, Iryna Gurevych
**Area:** Natural Language Processing, Sentence Embeddings
**Link:** [arXiv](https://arxiv.org/abs/1908.10084)

## The BERT semantic similarity problem

BERT computes semantic similarity by feeding both sentences together through the same forward pass and reading off the [CLS] token. This is accurate but quadratically expensive: comparing all pairs in a corpus of n sentences requires n² forward passes. For 10,000 sentences that takes roughly 65 hours on a modern GPU, making BERT unusable for semantic search, clustering, or any task that requires comparing a query to a large corpus at runtime. The fix is to pre-compute a fixed vector for each sentence independently, then reduce similarity to a fast cosine computation.

## Siamese architecture and training

SentenceBERT fine-tunes BERT with a siamese network structure. Both sentences pass through the same shared BERT encoder independently. The token embeddings from each sentence are mean-pooled into a single fixed-size vector. During training on natural language inference data, a classification head takes the concatenation of the two sentence vectors along with their element-wise difference and predicts entailment, neutral, or contradiction. After training, the encoder has learned to place semantically similar sentences close together in embedding space.

For datasets where graded similarity scores are available rather than NLI labels, SentenceBERT is trained with a triplet loss that directly optimizes distances in the embedding space:

$$ L = \max(\|s_a - s_p\| - \|s_a - s_n\| + \varepsilon,\ 0) $$

Here, the anchor sentence is pulled toward the positive and pushed away from the negative, with a margin epsilon. Mean pooling over all token positions outperforms using the [CLS] token alone because it captures information from every word rather than relying on a single learned summary token.

## Semantic search after training

Once fine-tuned, the corpus is encoded once offline and stored in a vector index. At query time, the query is encoded in a single forward pass and the nearest neighbors are retrieved with approximate nearest neighbor search. The 65-hour pairwise comparison shrinks to under 5 seconds.

## Results and impact

SentenceBERT achieved state-of-the-art results on STS benchmarks while reducing comparison time by five orders of magnitude. It became the foundation of the sentence-transformers library and underlies most production semantic search, duplicate detection, and clustering systems in use today.
