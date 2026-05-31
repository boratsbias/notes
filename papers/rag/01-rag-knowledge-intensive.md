# Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks (2020)

**Authors:** Patrick Lewis et al.
**Area:** Natural Language Processing, Information Retrieval
**Link:** [arXiv](https://arxiv.org/abs/2005.11401)

## The problem with parametric models

Language models that store knowledge entirely in their weights suffer from three structural problems. The knowledge is frozen at training time, so the model cannot reflect facts that changed after the training cutoff. The model cannot cite sources for its answers, making it hard to audit. And because the model must compress world knowledge into a fixed number of parameters, it hallucinates, filling in gaps with plausible-sounding but incorrect text. RAG's core argument is that separating storage of knowledge from the generation mechanism fixes all three problems at once.

## Architecture

RAG combines a dense retriever with a seq2seq generator. The retriever is DPR, a bi-encoder that independently maps the query and each candidate passage to a shared embedding space using BERT-based encoders. At query time, maximum inner product search over a pre-built FAISS index returns the top-k passages in milliseconds. The generator is BART, a seq2seq model that receives the query concatenated with each retrieved passage and produces the final answer. Both components are trained end-to-end: gradients flow from BART's output loss back through the retrieved passages to update both the generator and the retriever's query encoder. The document index itself is not updated during training, which keeps training tractable.

## Two variants

RAG-Sequence uses the same top-k documents for the entire output sequence, marginalizing over them when computing the output probability. RAG-Token allows different documents to be retrieved for each generated token, giving the model flexibility to pull different facts from different sources within a single answer. The non-parametric component means knowledge can be updated by swapping the document index without any retraining.

## Results and impact

RAG outperformed both closed-book language models and extractive QA systems on open-domain question answering benchmarks. It established retrieval augmentation as the standard architecture for knowledge-intensive NLP and directly shaped how production RAG systems are built today, from enterprise search to code assistants.
