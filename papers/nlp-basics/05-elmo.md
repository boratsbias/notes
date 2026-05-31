# ELMo: Deep Contextualized Word Representations (2018)

**Authors:** Matthew Peters, Mark Neumann, Mohit Iyyer, Matt Gardner, Christopher Clark, Kenton Lee, Luke Zettlemoyer
**Area:** Natural Language Processing, Contextualized Embeddings
**Link:** [arXiv](https://arxiv.org/abs/1802.05365)

## What the paper argues

Static embeddings (word2vec, GloVe) assign one vector per word regardless of context. "Bank" gets the same representation in "river bank" and "bank account". ELMo argues that word representations must be a function of the entire sentence, and shows that a deep bidirectional language model trained on raw text produces representations that dramatically improve downstream tasks when used as features.

## Architecture

ELMo trains two separate LSTM language models on the same text: one forward, one backward.

```
Forward LM:   w_1  →  w_2  →  w_3  → ... → w_t    (predicts next word)
Backward LM:  w_t  →  w_{t-1}  → ... → w_1         (predicts previous word)
```

Both LMs have L layers. The ELMo representation for token k is a weighted combination of all 2L+1 layer outputs (including the token embedding layer):

```
ELMo_k = γ · Σ_j  s_j · h_{k,j}
```

The weights s_j and scale γ are learned separately for each downstream task. This is the key contribution: rather than just using the top layer, ELMo lets the task decide which layers are most useful.

## Layer specialization

Lower layers capture syntax (POS tags, dependency structure). Higher layers capture semantics (word sense, coreference). Different tasks benefit from different layer combinations, which is why the learned weighting matters.

## Results and impact

Adding ELMo representations to existing models improved state of the art on SQuAD, NER, coreference, and sentiment analysis simultaneously. It was the first demonstration that contextual representations from large-scale language model pre-training transfer broadly. It directly motivated BERT and GPT, which replaced the LSTM backbone with transformers and scaled the approach substantially.
