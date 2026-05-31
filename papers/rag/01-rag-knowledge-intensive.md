# Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks (2020)

**Authors:** Patrick Lewis et al.
**Area:** Natural Language Processing, Information Retrieval
**Link:** [arXiv](https://arxiv.org/abs/2005.11401)

## What the paper argues

Parametric language models store knowledge in their weights. This knowledge is frozen at training time, cannot be updated without retraining, and cannot cite sources. RAG argues that combining a parametric model with a non-parametric retrieval component is better: retrieve relevant documents on the fly and condition generation on them. The model stays factually grounded and can be updated simply by replacing the document index.

## Architecture

```
Query
  ↓
[DPR Retriever]  →  embed query  →  MIPS over document index  →  top-k passages
  ↓
[BART Generator]  →  input = query + each passage (concatenated)  →  generate answer
```

**DPR (Dense Passage Retriever):** a bi-encoder trained to place relevant (query, passage) pairs close in embedding space. Uses maximum inner product search (MIPS) over a pre-built document index.

**BART Generator:** seq2seq model that conditions on the retrieved passages to produce the final output.

Both components are trained end-to-end. Gradients flow from BART's output loss back through the retrieved passages to update both models. The document index itself is not updated during training.

## Two variants

**RAG-Sequence:** same top-k documents used for the entire output sequence.

**RAG-Token:** different documents can be retrieved for each generated token, allowing different parts of the answer to draw on different sources.

## Results and impact

RAG outperformed both closed-book models and extractive QA systems on open-domain QA benchmarks. It established retrieval augmentation as the standard architecture for knowledge-intensive NLP and directly shaped how production RAG systems are built today.
