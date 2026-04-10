# NLP Foundations

## Core Idea

Natural language processing studies how to represent, analyze, and generate human language with computational models.

## Why Language Is Difficult

Language is structured at multiple levels:

- characters and subwords
- words and phrases
- syntax
- semantics
- discourse and context

The same surface form can have different meanings depending on context, which makes language modeling difficult.

## Common NLP Tasks

| Task | Goal |
|------|------|
| Text classification | Assign labels to text |
| Sequence labeling | Tag each token |
| Machine translation | Map text from one language to another |
| Question answering | Find or generate an answer |
| Summarization | Compress content while preserving meaning |
| Language modeling | Predict the next token or masked token |

## Text Representation

Before transformers, NLP systems often relied on sparse vector representations.

### Bag of Words

Represent a document by word counts.

- ignores word order
- simple and effective for baselines

### TF-IDF

Weights words by frequency and rarity:

$$\text{tf-idf}(t, d) = \text{tf}(t, d)\cdot \log\frac{N}{df(t)}$$

This reduces the impact of very common words.

## Distributed Representations

Word embeddings map tokens into dense vectors:

$$w_i \mapsto \mathbf{e}_i \in \mathbb{R}^d$$

Similar meanings tend to have nearby vectors.

Examples:

- Word2Vec
- GloVe
- FastText

## Sequence Modeling

Language is sequential, so models must capture dependencies across positions.

Earlier approaches:

- n-gram models
- recurrent neural networks
- LSTMs and GRUs

Modern NLP is dominated by transformers, which model interactions between all tokens with attention.

## Tokenization

Text is broken into smaller units before modeling.

Common choices:

- character-level
- word-level
- subword tokenization such as BPE or WordPiece

Subword methods handle rare words better than fixed word vocabularies.

## Language Modeling

Language models estimate:

$$P(x_1, x_2, \ldots, x_T) = \prod_{t=1}^T P(x_t \mid x_{<t})$$

or learn to recover masked tokens from context.

These objectives power pretraining for many downstream tasks.

## Attention and Context

Attention lets a model focus on relevant parts of the input when processing each token.

This improves long-range dependency modeling and parallel training compared with recurrent models.

## Core Challenges

- ambiguity
- long context dependencies
- out-of-vocabulary terms
- multilingual variation
- factual consistency in generation
- evaluation beyond exact string match

## Evaluation

Common metrics depend on the task:

- accuracy, F1 for classification
- BLEU for translation
- ROUGE for summarization
- perplexity for language modeling
- exact match and F1 for question answering

## Modern Direction

Current NLP systems increasingly rely on pretrained transformers and large language models that can be adapted through prompting, fine-tuning, retrieval, or tool use.
